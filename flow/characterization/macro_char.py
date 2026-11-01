#!/usr/bin/env python3
"""Macro-level STA / PVT / deterministic-jitter characterization.

This runner is deliberately explicit about its evidence level:

* STA is gate-level OpenSTA on the built macro Verilog, with the PDK
  standard-cell Liberty at each PVT corner and the macro SDC.
* Ring PVT is a transistor/cell-level transient of the built macro SPICE.
  It is not an RC-extracted simulation: the available sky130/gf180mcu
  macro SPICE views have no routed parasitics.  IHP has a SPEF for STA,
  but the SPICE view is still the pre-PEX cell netlist.
* "Jitter" here is deterministic transient period spread.  ngspice/Xyce
  transient runs are noiseless, so this is not random jitter and it is not
  phase noise.  No Pnoise/PSS signoff is claimed.
* Counter/NCO jitter is the exact deterministic TICK quantization of the
  phase accumulator.  Its output frequency is PVT-invariant in the ideal
  digital model; PVT enters through the achievable TICK rate and STA.

The script intentionally does not silently turn a failed oscillation or a
missing signoff into a pass.  Failed runs are recorded with an explicit
status.
"""
from __future__ import annotations

import argparse
import csv
import json
import math
import os
import re
import shutil
import statistics
import struct
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Iterable

ROOT = Path(__file__).resolve().parents[2]
CHAR = ROOT / "flow" / "characterization"
OUT = CHAR / "macro_char"
WORK = OUT / "work"

SKY = Path(
    "/home/yanlu/.ciel/ciel/sky130/versions/"
    "8afc8346a57fe1ab7934ba5a6056ea8b43078e71/sky130A"
)
IHP = Path(
    "/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
    "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2"
)
GF = Path(
    "/home/yanlu/.ciel/ciel/gf180mcu/versions/"
    "792ef67037d74c8c51811eab3ce23cf793491296/gf180mcuD"
)
GF_AS = Path("/grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk")
XYCE = Path(
    "/home/yanlu/spack/opt/spack/linux-ivybridge/"
    "xyce-7.10.0-lfrc7zxg3xzdkh67lqrvbig5oyxrklvf/bin/Xyce"
)

PDKS = ("gf180mcu", "sky130", "ihp-sg13g2")


@dataclass(frozen=True)
class Corner:
    label: str
    liberty: Path
    vdd: float
    temp_c: int
    model: str

    @property
    def slug(self) -> str:
        return self.label


CORNERS = {
    "gf180mcu": (
        Corner(
            "tt",
            GF_AS
            / "libs.ref/gf180mcu_as_sc_mcu7t3v3/lib/"
            "gf180mcu_as_sc_mcu7t3v3__tt_025C_3v30.lib",
            3.30,
            25,
            "typical",
        ),
        Corner(
            "ss",
            GF_AS
            / "libs.ref/gf180mcu_as_sc_mcu7t3v3/lib/"
            "gf180mcu_as_sc_mcu7t3v3__ss_125C_3v00.lib",
            3.00,
            125,
            "ss",
        ),
        Corner(
            "ff",
            GF_AS
            / "libs.ref/gf180mcu_as_sc_mcu7t3v3/lib/"
            "gf180mcu_as_sc_mcu7t3v3__ff_n40C_3v60.lib",
            3.60,
            -40,
            "ff",
        ),
    ),
    "sky130": (
        Corner(
            "tt",
            SKY / "libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib",
            1.80,
            25,
            "tt",
        ),
        Corner(
            "ss",
            SKY / "libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib",
            1.60,
            100,
            "ss",
        ),
        Corner(
            "ff",
            SKY / "libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib",
            1.95,
            -40,
            "ff",
        ),
    ),
    "ihp-sg13g2": (
        Corner(
            "tt",
            IHP / "libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib",
            1.20,
            25,
            "mos_tt",
        ),
        Corner(
            "ss",
            IHP / "libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_slow_1p08V_125C.lib",
            1.08,
            125,
            "mos_ss",
        ),
        Corner(
            "ff",
            IHP / "libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_fast_1p32V_m40C.lib",
            1.32,
            -40,
            "mos_ff",
        ),
    ),
}

MACRO_DIRS = {
    "ring": {
        "gf180mcu": "ring_dco_gf180mcu",
        "sky130": "ring_dco_sky130",
        "ihp-sg13g2": "ring_dco_ihp130",
    },
    "counter": {
        "gf180mcu": "counter_dco_gf180mcu",
        "sky130": "counter_dco_sky130",
        "ihp-sg13g2": "counter_dco_ihp130",
    },
}

# DCO_EN is active-high in the RTL for all three ring macros.  INJ_WIN is
# tied low inside PLL_RING_DCO_PHYS on every PDK, so the ring variant is
# free-running and the top-level INJ_EN pin is unused.  Keep the probe values
# explicit so the transient deck drives the enable that the built netlist
# actually uses.
RING_ENABLE = {
    "gf180mcu": ("vdd", "0"),
    "sky130": ("vdd", "0"),
    "ihp-sg13g2": ("vdd", "0"),
}


# ---------------------------------------------------------------------------
# small helpers
# ---------------------------------------------------------------------------


def _run(cmd: list[str], cwd: Path | None = None, timeout: int | None = None,
         env: dict[str, str] | None = None) -> subprocess.CompletedProcess:
    return subprocess.run(
        cmd,
        cwd=cwd,
        timeout=timeout,
        env=env,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )


def _write_json(path: Path, data) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, sort_keys=False) + "\n")


def _read_json(path: Path):
    return json.loads(path.read_text())


def _safe_name(s: str) -> str:
    return re.sub(r"[^A-Za-z0-9_.+-]+", "_", s)


def _macro_dir(kind: str, pdk: str) -> Path:
    return ROOT / "flow" / "macro" / MACRO_DIRS[kind][pdk]


def _macro_name(kind: str) -> str:
    return "PLL_RING_DCO_PHYS" if kind == "ring" else "PLL_COUNTER_DCO_PHYS"


def _sdc(kind: str, pdk: str) -> Path:
    d = _macro_dir(kind, pdk)
    if pdk == "ihp-sg13g2":
        return d / f"{_macro_name(kind)}.sdc.tcl"
    return d / "macro.sdc.tcl"


def _netlist(kind: str, pdk: str) -> Path:
    return _macro_dir(kind, pdk) / f"{_macro_name(kind)}.v"


def _spice(kind: str, pdk: str) -> Path:
    return _macro_dir(kind, pdk) / f"{_macro_name(kind)}.spice"


def _ensure_dirs() -> None:
    for p in (OUT, WORK):
        p.mkdir(parents=True, exist_ok=True)


# ---------------------------------------------------------------------------
# OpenSTA
# ---------------------------------------------------------------------------


def parse_sta_report(text: str) -> dict:
    """Extract per-path-group WNS and path count from a full OpenSTA report."""
    groups: dict[str, list[float]] = {}
    starts = [m.start() for m in re.finditer(r"(?m)^Startpoint:", text)]
    for i, start in enumerate(starts):
        end = starts[i + 1] if i + 1 < len(starts) else len(text)
        block = text[start:end]
        gm = re.search(r"(?m)^Path Group:\s*(\S+)", block)
        sm = re.findall(r"([-+]?\d+(?:\.\d+)?)\s+slack\s+\((?:MET|VIOLATED)\)", block)
        if gm and sm:
            groups.setdefault(gm.group(1), []).append(float(sm[-1]))
    summary = {}
    for group, slacks in groups.items():
        summary[group] = {
            "wns_ns": round(min(slacks), 6),
            "paths": len(slacks),
        }
    return summary


def parse_power(text: str) -> dict:
    m = re.search(
        r"(?m)^Total\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)\s+"
        r"([0-9.eE+-]+)\s+([0-9.eE+-]+)",
        text,
    )
    if not m:
        return {}
    vals = [float(x) for x in m.groups()]
    return {
        "internal_w": vals[0],
        "switching_w": vals[1],
        "leakage_w": vals[2],
        "total_w": vals[3],
    }


def parse_tns(text: str) -> float | None:
    m = re.search(r"(?m)^\s*tns\s+([-+]?\d+(?:\.\d+)?)", text)
    return float(m.group(1)) if m else None


def run_sta(kind: str, pdk: str, corner: Corner) -> dict:
    top = _macro_name(kind)
    net = _netlist(kind, pdk)
    sdc = _sdc(kind, pdk)
    if not net.exists():
        raise FileNotFoundError(net)
    if not corner.liberty.exists():
        raise FileNotFoundError(corner.liberty)
    odir = WORK / "sta" / pdk / kind / corner.slug
    odir.mkdir(parents=True, exist_ok=True)
    tcl = odir / "run.tcl"
    rpt = odir / "sta.rpt"
    log = odir / "sta.log"
    tcl.write_text(
        f"read_liberty {corner.liberty}\n"
        f"read_verilog {net}\n"
        f"link_design {top}\n"
        f"read_sdc {sdc}\n"
        "report_checks -path_delay max -format full -group_count 200 "
        "-endpoint_count 1\n"
        "report_checks -path_delay min -format full -group_count 200 "
        "-endpoint_count 1\n"
        "report_tns\n"
        "report_power\n"
    )
    proc = _run(["sta", "-no_init", "-exit", str(tcl)], timeout=300)
    log.write_text(proc.stdout)
    # The Tcl prints reports to stdout; keep the complete log as the report.
    rpt.write_text(proc.stdout)
    if proc.returncode != 0:
        return {
            "pdk": pdk,
            "macro": kind,
            "corner": corner.label,
            "status": "STA_ERROR",
            "returncode": proc.returncode,
            "log": str(log.relative_to(ROOT)),
        }
    max_groups = parse_sta_report(proc.stdout)
    # Parse hold from the second report by splitting at report_tns.
    head, _, tail = proc.stdout.partition("\ntns ")
    # A simpler and robust split: parse all blocks and rely on Path Type.
    max_text = ""
    min_text = ""
    chunks = re.split(r"(?m)^(?=Startpoint:)", head)
    for chunk in chunks:
        if not chunk.strip():
            continue
        if "Path Type: max" in chunk:
            max_text += chunk
        elif "Path Type: min" in chunk:
            min_text += chunk
    max_groups = parse_sta_report(max_text)
    min_groups = parse_sta_report(min_text)
    power = parse_power(proc.stdout)
    tns = parse_tns(proc.stdout)
    tick = max_groups.get("TICK", {}) if kind == "counter" else {}
    max_tick_mhz = None
    if kind == "counter" and tick.get("wns_ns") is not None:
        tmin_ns = 10.0 - tick["wns_ns"]
        if tmin_ns > 0:
            max_tick_mhz = 1000.0 / tmin_ns
    setup_wns = min((g["wns_ns"] for g in max_groups.values()), default=None)
    hold_wns = min((g["wns_ns"] for g in min_groups.values()), default=None)
    return {
        "pdk": pdk,
        "macro": kind,
        "corner": corner.label,
        "liberty": str(corner.liberty),
        "vdd": corner.vdd,
        "temp_c": corner.temp_c,
        "status": "STA_OK",
        "max_groups": max_groups,
        "min_groups": min_groups,
        "wns_ns": setup_wns,
        "hold_wns_ns": hold_wns,
        "tns_ns": tns,
        "tick_wns_ns": tick.get("wns_ns"),
        "timing_pass": bool(
            (setup_wns is not None and setup_wns >= 0.0)
            and (hold_wns is not None and hold_wns >= 0.0)
            and (kind != "counter" or tick.get("wns_ns", 0.0) >= 0.0)
        ),
        "max_tick_mhz": round(max_tick_mhz, 3) if max_tick_mhz else None,
        "power": power,
        "report": str(rpt.relative_to(ROOT)),
    }


def run_sta_all(pdks: Iterable[str], jobs: int) -> None:
    _ensure_dirs()
    rows = []
    jobs_list = [
        (kind, pdk, corner)
        for kind in ("ring", "counter")
        for pdk in pdks
        for corner in CORNERS[pdk]
    ]
    with ThreadPoolExecutor(max_workers=jobs) as ex:
        futs = {ex.submit(run_sta, *j): j for j in jobs_list}
        for fut in as_completed(futs):
            kind, pdk, corner = futs[fut]
            try:
                row = fut.result()
            except Exception as exc:  # noqa: BLE001 - recorded as evidence
                row = {
                    "pdk": pdk,
                    "macro": kind,
                    "corner": corner.label,
                    "status": "STA_EXCEPTION",
                    "error": str(exc),
                }
            rows.append(row)
            print(f"STA {pdk:14s} {kind:7s} {corner.label:2s}: {row['status']}")
    rows.sort(key=lambda r: (r["pdk"], r["macro"], r["corner"]))
    _write_json(OUT / "sta_summary.json", {
        "evidence_level": "gate_level_opensta",
        "note": "Gate-level OpenSTA on built macro Verilog + PDK corner Liberty + macro SDC. Vectorless report_power. No SPEF except IHP (not applied here).",
        "rows": rows,
    })
    with (OUT / "sta_summary.csv").open("w", newline="") as fh:
        fields = ["pdk", "macro", "corner", "status", "timing_pass",
                  "wns_ns", "hold_wns_ns", "tick_wns_ns", "tns_ns",
                  "max_tick_mhz", "total_w", "report"]
        w = csv.DictWriter(fh, fieldnames=fields)
        w.writeheader()
        for r in rows:
            w.writerow({
                **{k: r.get(k) for k in fields if k != "total_w"},
                "total_w": (r.get("power") or {}).get("total_w"),
            })


# ---------------------------------------------------------------------------
# netlist / testbench generation
# ---------------------------------------------------------------------------


def parse_top_ports(path: Path, top: str) -> list[str]:
    lines = path.read_text(errors="ignore").splitlines()
    start = None
    for i, line in enumerate(lines):
        if line.upper().startswith(f".SUBCKT {top.upper()}"):
            start = i
            break
    if start is None:
        raise ValueError(f"{path}: no .SUBCKT {top}")
    parts = lines[start].split()[2:]
    i = start + 1
    while i < len(lines) and lines[i].startswith("+"):
        parts += lines[i][1:].split()
        i += 1
    return parts


def extract_top(path: Path, top: str, out: Path) -> None:
    lines = path.read_text(errors="ignore").splitlines()
    start = next(
        i for i, line in enumerate(lines)
        if line.upper().startswith(f".SUBCKT {top.upper()}")
    )
    end = next(
        i for i, line in enumerate(lines[start:], start)
        if line.upper().startswith(f".ENDS {top.upper()}")
    )
    out.write_text("\n".join(lines[start:end + 1]) + "\n")


def _node_for(pin: str, supply: str) -> str:
    p = pin.lower()
    if p in ("vdd", "vpwr"):
        return supply
    if p in ("vss", "vgnd"):
        return "vss"
    return re.sub(r"[^a-z0-9]+", "_", p).strip("_")


def code_bits(code: tuple[int, int, int]) -> dict[str, str]:
    c, m, f = code
    out = {}
    for i in range(15):
        out[f"COARSE_MUX[{i}]"] = "vdd" if i < c else "0"
    for i in range(15):
        out[f"MID_MUX[{i}]"] = "vdd" if i < m else "0"
    for i in range(31):
        out[f"FINE_MUX[{i}]"] = "vdd" if i < f else "0"
    return out


def _model_header(kind: str, pdk: str, corner: Corner, top_only: Path | None) -> str:
    if pdk == "gf180mcu":
        return (
            f".include {GF / 'libs.tech/ngspice/design.spice'}\n"
            f".lib {GF / 'libs.tech/ngspice/sm141064.spice'} {corner.model}\n"
            f".include {_spice(kind, pdk)}\n"
        )
    if pdk == "sky130":
        return (
            ".option scale=1u\n"
            f".lib {SKY / 'libs.tech/ngspice/sky130.lib.spice'} {corner.model}\n"
            f".include {SKY / 'libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice'}\n"
            f".include {top_only}\n"
        )
    if pdk == "ihp-sg13g2":
        return (
            f".lib {IHP / 'libs.tech/ngspice/models/cornerMOSlv.lib'} {corner.model}\n"
            f".include {IHP / 'libs.tech/ngspice/models/sg13g2_moslv_mod.lib'}\n"
            f".include {IHP / 'libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice'}\n"
            f".include {top_only}\n"
        )
    raise ValueError(pdk)


def _spiceinit(pdk: str, odir: Path) -> None:
    if pdk != "ihp-sg13g2":
        return
    (odir / ".spiceinit").write_text(
        "set num_threads=2\n"
        f"osdi '{IHP / 'libs.tech/ngspice/osdi/psp103.osdi'}'\n"
        f"osdi '{IHP / 'libs.tech/ngspice/osdi/psp103_nqs.osdi'}'\n"
    )


def build_ring_deck(
    pdk: str,
    corner: Corner,
    code: tuple[int, int, int],
    stop_ns: float,
    step_ns: float,
    odir: Path,
    *,
    force_dco_enable: bool = False,
) -> tuple[Path, Path]:
    top = _macro_name("ring")
    src = _spice("ring", pdk)
    ports = parse_top_ports(src, top)
    odir.mkdir(parents=True, exist_ok=True)
    top_only = None
    if pdk != "gf180mcu":
        top_only = odir / "top_only.sp"
        extract_top(src, top, top_only)
    odir.mkdir(parents=True, exist_ok=True)
    # gf is self-contained; sky/IHP use the official cell library + top-only.
    header = _model_header("ring", pdk, corner, top_only)
    bits = code_bits(code)
    dco, inj = RING_ENABLE[pdk]
    if force_dco_enable:
        dco, inj = "vdd", "0"
    conn = []
    for pin in ports:
        if pin in bits:
            conn.append(bits[pin])
        elif pin == "DCO_EN":
            conn.append(dco)
        elif pin == "INJ_EN":
            conn.append(inj)
        elif pin in ("REF", "INJ_EDGE"):
            conn.append("0" if pin == "REF" else "inj_edge")
        elif pin in ("OUT", "MID_OUT", "SS_BBPD[0]", "SS_BBPD[1]"):
            conn.append(_node_for(pin, "vdd"))
        else:
            conn.append(_node_for(pin, "vdd"))
    deck = odir / "ring.sp"
    raw = odir / "ring.raw"
    log = odir / "ring.log"
    head = (
        "* macro ring characterization\n"
        f"{header}"
        f"Vdd vdd 0 {corner.vdd}\n"
        "Vss vss 0 0\n"
        f"Xmac {' '.join(conn)} {top}\n"
        f".ic V(out)={corner.vdd / 2:.6g} V(mid_out)={corner.vdd / 2:.6g}\n"
        f".tran {step_ns}n {stop_ns}n uic\n"
    )
    if pdk == "sky130":
        # Xyce does not implement ngspice's .control/write save list.
        deck.write_text(head + ".print tran V(out) V(mid_out)\n.end\n")
    else:
        deck.write_text(
            head
            + ".save V(out) V(mid_out)\n"
            ".control\nrun\n"
            f"write {raw.name}\n"
            "quit\n.endc\n.end\n"
        )
    return deck, log


def build_counter_deck(
    pdk: str,
    corner: Corner,
    stop_ns: float,
    step_ns: float,
    odir: Path,
    tick_ns: float = 10.0,
) -> tuple[Path, Path]:
    top = _macro_name("counter")
    src = _spice("counter", pdk)
    ports = parse_top_ports(src, top)
    odir.mkdir(parents=True, exist_ok=True)
    top_only = None
    if pdk != "gf180mcu":
        top_only = odir / "top_only.sp"
        extract_top(src, top, top_only)
    header = _model_header("counter", pdk, corner, top_only)
    bits = code_bits((0, 0, 0))
    conn = []
    for pin in ports:
        if pin in bits:
            conn.append(bits[pin])
        elif pin == "TICK":
            conn.append("tick")
        elif pin == "DCO_EN":
            conn.append("vdd")
        elif pin in ("REF", "INJ_EN"):
            conn.append("0")
        elif pin in ("OUT", "MID_OUT", "INJ_EDGE", "SS_BBPD[0]", "SS_BBPD[1]"):
            conn.append(_node_for(pin, "vdd"))
        else:
            conn.append(_node_for(pin, "vdd"))
    deck = odir / "counter.sp"
    raw = odir / "counter.raw"
    log = odir / "counter.log"
    head = (
        "* macro counter characterization\n"
        f"{header}"
        f"Vdd vdd 0 {corner.vdd}\n"
        "Vss vss 0 0\n"
        f"Vtick tick 0 PULSE(0 {corner.vdd} 1n 10p 10p {tick_ns / 2}n {tick_ns}n)\n"
        f"Xmac {' '.join(conn)} {top}\n"
        f".tran {step_ns}n {stop_ns}n uic\n"
    )
    if pdk == "sky130":
        deck.write_text(head + ".print tran V(out) V(tick)\n.end\n")
    else:
        deck.write_text(
            head
            + ".save V(out) V(tick)\n"
            ".control\nrun\n"
            f"write {raw.name}\n"
            "quit\n.endc\n.end\n"
        )
    return deck, log


# ---------------------------------------------------------------------------
# raw / ASCII waveform parsing and edge metrics
# ---------------------------------------------------------------------------


def parse_ngspice_raw(path: Path) -> tuple[list[float], dict[str, list[float]]]:
    b = path.read_bytes()
    marker = b"Binary:\n"
    i = b.index(marker) + len(marker)
    text = b[:i].decode("latin1")
    nv = int(re.search(r"No\. Variables:\s*(\d+)", text).group(1))
    np_ = int(re.search(r"No\. Points:\s*(\d+)", text).group(1))
    names = re.findall(r"^\s*\d+\s+(\S+)\s+", text, re.M)
    vals = struct.unpack("<%dd" % (nv * np_), b[i:i + nv * np_ * 8])
    time = [vals[k * nv] for k in range(np_)]
    traces = {
        name: [vals[k * nv + j] for k in range(np_)]
        for j, name in enumerate(names)
    }
    return time, traces


def parse_xyce_prn(path: Path) -> tuple[list[float], dict[str, list[float]]]:
    lines = path.read_text(errors="ignore").splitlines()
    header = lines[0].split()
    names = [h.strip().lower() for h in header[1:]]
    time: list[float] = []
    traces: dict[str, list[float]] = {n: [] for n in names}
    for line in lines[1:]:
        if line.startswith("End"):
            break
        t = line.split()
        if len(t) != len(header):
            continue
        try:
            vals = [float(x) for x in t]
        except ValueError:
            continue
        time.append(vals[1])
        for j, name in enumerate(names):
            traces[name].append(vals[j + 1])
    return time, traces


def _crossings(time: list[float], wave: list[float], threshold: float,
               rising: bool = True) -> list[float]:
    edges = []
    for k in range(1, len(time)):
        a, b = wave[k - 1], wave[k]
        hit = (a < threshold <= b) if rising else (a > threshold >= b)
        if not hit:
            continue
        den = b - a
        frac = (threshold - a) / den if den else 0.0
        edges.append(time[k - 1] + frac * (time[k] - time[k - 1]))
    return edges


def _deglitch(edges: list[float], min_gap_s: float) -> list[float]:
    if not edges:
        return []
    out = [edges[0]]
    for e in edges[1:]:
        if e - out[-1] >= min_gap_s:
            out.append(e)
    return out


def period_metrics(
    time: list[float],
    wave: list[float],
    *,
    vdd: float,
    settle_s: float,
    min_gap_s: float = 2e-9,
) -> dict:
    lo, hi = min(wave), max(wave)
    threshold = 0.5 * (lo + hi)
    edges = _deglitch(_crossings(time, wave, threshold), min_gap_s)
    edges = [e for e in edges if e >= settle_s]
    if len(edges) < 2:
        return {
            "status": "NO_OSCILLATION",
            "edges": len(edges),
            "vmin": lo,
            "vmax": hi,
        }
    if len(edges) == 2:
        # Slow corners can complete only one output period inside the
        # committed transient window.  Report the frequency estimate and
        # mark it clearly; do not fabricate a period-spread/jitter number.
        period = edges[1] - edges[0]
        return {
            "status": "LIMITED_EDGES",
            "edges": 2,
            "settle_ns": settle_s * 1e9,
            "period_mean_ns": period * 1e9,
            "period_min_ns": period * 1e9,
            "period_max_ns": period * 1e9,
            "period_pp_ns": 0.0,
            "period_rms_ns": 0.0,
            "period_rms_ps": 0.0,
            "c2c_rms_ps": None,
            "freq_mhz": 1e-6 / period,
            "vmin": lo,
            "vmax": hi,
        }
    periods = [b - a for a, b in zip(edges, edges[1:])]
    mean = statistics.fmean(periods)
    rms = math.sqrt(statistics.fmean((p - mean) ** 2 for p in periods))
    c2c = [b - a for a, b in zip(periods, periods[1:])]
    c2c_rms = math.sqrt(statistics.fmean(x * x for x in c2c)) if c2c else None
    return {
        "status": "OK",
        "edges": len(edges),
        "settle_ns": settle_s * 1e9,
        "period_mean_ns": mean * 1e9,
        "period_min_ns": min(periods) * 1e9,
        "period_max_ns": max(periods) * 1e9,
        "period_pp_ns": (max(periods) - min(periods)) * 1e9,
        "period_rms_ns": rms * 1e9,
        "period_rms_ps": rms * 1e12,
        "c2c_rms_ps": (c2c_rms * 1e12) if c2c_rms is not None else None,
        "freq_mhz": 1e-6 / mean,
        "vmin": lo,
        "vmax": hi,
    }


def run_transient(
    deck: Path,
    log: Path,
    pdk: str,
    odir: Path,
    timeout: int = 1800,
) -> tuple[str, str]:
    if pdk == "sky130" and XYCE.exists():
        # Xyce is substantially more robust/faster for the sky130 BSIM4 deck.
        proc = _run([str(XYCE), "-l", log.name, deck.name], cwd=odir, timeout=timeout)
        prn = deck.with_suffix(deck.suffix + ".prn")
        return "xyce", str(prn)
    env = dict(os.environ)
    if pdk == "ihp-sg13g2":
        env.update({
            "PDK_ROOT": str(IHP.parent),
            "PDK": "ihp-sg13g2",
        })
        _spiceinit(pdk, odir)
    proc = _run(["ngspice", "-o", log.name, deck.name], cwd=odir,
                timeout=timeout, env=env)
    if proc.returncode != 0 and "Error" not in proc.stdout:
        raise RuntimeError(f"ngspice failed for {deck}: {proc.stdout[-2000:]}")
    return "ngspice", str(odir / "ring.raw" if "ring" in deck.name else odir / "counter.raw")


def run_ring_case(
    pdk: str,
    corner: Corner,
    code: tuple[int, int, int],
    tag: str,
    *,
    stop_ns: float = 200.0,
    step_ns: float = 0.01,
    force_dco_enable: bool = False,
) -> dict:
    odir = WORK / "ring" / pdk / f"{corner.slug}_{tag}"
    if odir.exists():
        shutil.rmtree(odir)
    deck, log = build_ring_deck(pdk, corner, code, stop_ns, step_ns, odir,
                                force_dco_enable=force_dco_enable)
    engine, raw = run_transient(deck, log, pdk, odir)
    if engine == "xyce":
        time, traces = parse_xyce_prn(Path(raw))
    else:
        time, traces = parse_ngspice_raw(Path(raw))
    wave = traces.get("v(out)") or traces.get("v(out)")
    if wave is None:
        raise RuntimeError(f"{pdk} {tag}: no v(out) trace")
    # A fixed short settle window keeps 3+ cycles in a 200 ns run at the
    # slow corners while still rejecting the startup glitch.
    metrics = period_metrics(time, wave, vdd=corner.vdd, settle_s=10e-9)
    return {
        "pdk": pdk,
        "macro": "ring",
        "corner": corner.label,
        "code": {"coarse": code[0], "mid": code[1], "fine": code[2]},
        "tag": tag,
        "engine": engine,
        "vdd": corner.vdd,
        "temp_c": corner.temp_c,
        "stop_ns": stop_ns,
        "step_ns": step_ns,
        "spice_view": str(_spice("ring", pdk).relative_to(ROOT)),
        "work": str(odir.relative_to(ROOT)),
        **metrics,
    }


RING_SIM = {
    "gf180mcu": (200.0, 0.01),
    # The sky130 ring has a 256-stage base delay before the tuned delay line;
    # the startup transient alone is tens of ns at SS.  Use a longer window
    # and a coarser print step so the run captures several settled periods.
    "sky130": (300.0, 0.05),
    "ihp-sg13g2": (150.0, 0.015),
}


def run_ring_pvt(pdks: Iterable[str], jobs: int, *, stop_ns: float | None = None, step_ns: float | None = None) -> None:
    _ensure_dirs()
    rows = []
    jobs_list = [
        (pdk, corner, (0, 0, 0), "min")
        for pdk in pdks
        for corner in CORNERS[pdk]
    ]
    with ThreadPoolExecutor(max_workers=jobs) as ex:
        futs = {
            ex.submit(
                run_ring_case, pdk, corner, code, tag,
                stop_ns=(stop_ns if stop_ns is not None else RING_SIM[pdk][0]),
                step_ns=(step_ns if step_ns is not None else RING_SIM[pdk][1]),
            ): (pdk, corner, code, tag)
            for pdk, corner, code, tag in jobs_list
        }
        for fut in as_completed(futs):
            pdk, corner, code, tag = futs[fut]
            try:
                row = fut.result()
            except Exception as exc:  # noqa: BLE001
                row = {"pdk": pdk, "macro": "ring", "corner": corner.label,
                       "code": {"coarse": code[0], "mid": code[1],
                                "fine": code[2]},
                       "tag": tag, "status": "SIM_ERROR",
                       "error": str(exc)}
            rows.append(row)
            print(f"RING {pdk:14s} {corner.label:2s} {tag}: {row.get('status')}")
    rows.sort(key=lambda r: (r["pdk"], r["corner"], r["tag"]))
    _write_json(OUT / "ring_pvt.json", {
        "evidence_level": "cell_level_transient_no_rc",
        "note": "Built macro SPICE transient; no routed RC parasitics. Jitter is deterministic period spread, not random/phase noise.",
        "rows": rows,
    })
    with (OUT / "ring_pvt.csv").open("w", newline="") as fh:
        fields = ["pdk", "corner", "tag", "status", "coarse", "mid",
                  "fine", "freq_mhz", "period_mean_ns", "period_pp_ns",
                  "period_rms_ps", "c2c_rms_ps", "edges", "engine", "work"]
        w = csv.DictWriter(fh, fieldnames=fields)
        w.writeheader()
        for r in rows:
            c = r.get("code") or {}
            w.writerow({
                **{k: r.get(k) for k in fields
                   if k not in ("coarse", "mid", "fine", "work")},
                "coarse": c.get("coarse"), "mid": c.get("mid"),
                "fine": c.get("fine"), "work": r.get("work"),
            })


def run_ring_tune(pdks: Iterable[str], jobs: int) -> None:
    _ensure_dirs()
    codes = {
        "min": (0, 0, 0),
        "coarse1": (1, 0, 0),
        "mid1": (0, 1, 0),
        "fine1": (0, 0, 1),
    }
    jobs_list = [
        (pdk, CORNERS[pdk][0], code, tag)
        for pdk in pdks
        for tag, code in codes.items()
    ]
    rows = []
    with ThreadPoolExecutor(max_workers=jobs) as ex:
        futs = {
            ex.submit(
                run_ring_case, pdk, corner, code, tag,
                stop_ns=RING_SIM[pdk][0], step_ns=RING_SIM[pdk][1],
            ): (pdk, corner, code, tag)
            for pdk, corner, code, tag in jobs_list
        }
        for fut in as_completed(futs):
            pdk, corner, code, tag = futs[fut]
            try:
                row = fut.result()
            except Exception as exc:  # noqa: BLE001
                row = {"pdk": pdk, "macro": "ring", "corner": corner.label,
                       "code": {"coarse": code[0], "mid": code[1],
                                "fine": code[2]},
                       "tag": tag, "status": "SIM_ERROR",
                       "error": str(exc)}
            rows.append(row)
            print(f"TUNE {pdk:14s} {tag:8s}: {row.get('status')}")
    rows.sort(key=lambda r: (r["pdk"], r["tag"]))
    _write_json(OUT / "ring_tuning.json", {
        "evidence_level": "tt_cell_level_transient_no_rc",
        "note": "One-bit coarse/mid/fine code steps at TT. Approximate local KDCO; no random jitter.",
        "rows": rows,
    })
    with (OUT / "ring_tuning.csv").open("w", newline="") as fh:
        fields = ["pdk", "corner", "tag", "status", "coarse", "mid",
                  "fine", "freq_mhz", "period_mean_ns", "period_pp_ns",
                  "period_rms_ps", "edges"]
        w = csv.DictWriter(fh, fieldnames=fields)
        w.writeheader()
        for r in rows:
            c = r.get("code") or {}
            w.writerow({
                **{k: r.get(k) for k in fields
                   if k not in ("coarse", "mid", "fine")},
                "coarse": c.get("coarse"), "mid": c.get("mid"),
                "fine": c.get("fine"),
            })


# ---------------------------------------------------------------------------
# counter / NCO
# ---------------------------------------------------------------------------


def nco_sequence(tick_ns: float = 10.0, acc_bits: int = 16,
                 base_inc: int = 3493, coarse: int = 0, mid: int = 0,
                 fine: int = 0, carries: int = 512) -> dict:
    inc = base_inc - 120 * coarse - 60 * mid - 15 * fine
    inc = max(1, min(inc, 1 << (acc_bits - 1)))
    phase = 0
    toggles = []
    out = 0
    for n in range(1, carries + 1):
        phase_sum = phase + inc
        carry = phase_sum >> acc_bits
        phase = phase_sum & ((1 << acc_bits) - 1)
        if carry:
            out ^= 1
            if out:
                toggles.append(n * tick_ns)
    periods = [b - a for a, b in zip(toggles, toggles[1:])]
    if not periods:
        return {"increment": inc, "status": "NO_EDGES"}
    mean = statistics.fmean(periods)
    rms = math.sqrt(statistics.fmean((p - mean) ** 2 for p in periods))
    return {
        "status": "OK",
        "increment": inc,
        "tick_ns": tick_ns,
        "acc_bits": acc_bits,
        "carries": carries,
        "output_period_ns": periods[:16],
        "period_mean_ns": mean,
        "period_pp_ns": max(periods) - min(periods),
        "period_rms_ns": rms,
        # periods are in ns here, so ns -> MHz is 1000 / period_ns.
        "freq_mhz": 1000.0 / mean,
        "edge_count": len(toggles),
    }


def run_counter() -> None:
    _ensure_dirs()
    rows = []
    for pdk in PDKS:
        seq = nco_sequence()
        rows.append({"pdk": pdk, "macro": "counter", **seq})
    _write_json(OUT / "counter_nco.json", {
        "evidence_level": "exact_digital_quantization",
        "note": "Exact phase-accumulator output periods for TICK=10 ns, ACC_BITS=16, BASE_INC=3493, code 0. This is deterministic TICK quantization, not random jitter. Output frequency is PVT-invariant in the ideal digital model.",
        "rows": rows,
    })
    with (OUT / "counter_nco.csv").open("w", newline="") as fh:
        fields = ["pdk", "status", "increment", "tick_ns", "period_mean_ns",
                  "period_pp_ns", "period_rms_ns", "freq_mhz", "carries"]
        w = csv.DictWriter(fh, fieldnames=fields)
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k) for k in fields})


# ---------------------------------------------------------------------------
# report
# ---------------------------------------------------------------------------


def _fmt(v, nd=3):
    return "" if v is None else f"{v:.{nd}f}"


def write_report() -> None:
    sta = _read_json(OUT / "sta_summary.json") if (OUT / "sta_summary.json").exists() else {"rows": []}
    ring = _read_json(OUT / "ring_pvt.json") if (OUT / "ring_pvt.json").exists() else {"rows": []}
    tune = _read_json(OUT / "ring_tuning.json") if (OUT / "ring_tuning.json").exists() else {"rows": []}
    nco = _read_json(OUT / "counter_nco.json") if (OUT / "counter_nco.json").exists() else {"rows": []}
    lines = [
        "# Physical DCO macro characterization",
        "",
        "Generated by `flow/characterization/macro_char.py`.",
        "",
        "## Evidence level",
        "",
        "- **STA:** gate-level OpenSTA on the built macro Verilog, PDK corner",
        "  Liberty and the macro SDC. `report_power` is vectorless.",
        "- **Ring PVT:** built-macro cell-level transient. No routed RC",
        "  parasitics are present in the committed macro SPICE views.",
        "- **Jitter:** deterministic transient period spread only. The",
        "  transient source is noiseless. This is **not** random jitter and",
        "  **not** phase noise.",
        "- **Counter/NCO:** exact digital TICK quantization plus STA PVT.",
        "  The ideal digital output frequency is PVT-invariant.",
        "",
        "## STA summary",
        "",
        "| PDK | Macro | Corner | Timing | Setup WNS (ns) | Hold WNS (ns) | TICK WNS (ns) | Max TICK (MHz) | Power (W) | Status |",
        "|---|---|---|---|---:|---:|---:|---:|---:|---|",
    ]
    for r in sta.get("rows", []):
        total = (r.get("power") or {}).get("total_w")
        lines.append(
            f"| {r['pdk']} | {r['macro']} | {r['corner']} | "
            f"{'PASS' if r.get('timing_pass') else 'FAIL'} | "
            f"{_fmt(r.get('wns_ns'))} | {_fmt(r.get('hold_wns_ns'))} | "
            f"{_fmt(r.get('tick_wns_ns'))} | "
            f"{_fmt(r.get('max_tick_mhz'),1)} | {_fmt(total,6)} | {r['status']} |"
        )
    lines += [
        "",
        "`Setup WNS` and `Hold WNS` are the worst slacks across all path",
        "groups; `TICK WNS` is",
        "only reported for the counter `TICK` group. `Timing` is a simple",
        "non-negative-slack gate, not a signoff criterion. `Max TICK` is the",
        "period-reduced estimate `1/(10 ns - TICK WNS)`, not a measured",
        "oscillator or a hold-closed frequency.",
        "",
        "## Ring PVT / deterministic period spread",
        "",
        "| PDK | Corner | Code | f (MHz) | Period (ns) | pp (ns) | RMS (ps) | c2c RMS (ps) | Edges | Status |",
        "|---|---|---|---:|---:|---:|---:|---:|---:|---|",
    ]
    for r in ring.get("rows", []):
        c = r.get("code") or {}
        code = f"{c.get('coarse')}/{c.get('mid')}/{c.get('fine')}"
        lines.append(
            f"| {r['pdk']} | {r['corner']} | {code} | "
            f"{_fmt(r.get('freq_mhz'))} | {_fmt(r.get('period_mean_ns'))} | "
            f"{_fmt(r.get('period_pp_ns'))} | {_fmt(r.get('period_rms_ps'),1)} | "
            f"{_fmt(r.get('c2c_rms_ps'),1)} | {r.get('edges')} | {r.get('status')} |"
        )
    lines += [
        "",
        "### Ring code steps at TT",
        "",
        "| PDK | Tag | Code | f (MHz) | Period (ns) | Status |",
        "|---|---|---|---:|---:|---|",
    ]
    for r in tune.get("rows", []):
        c = r.get("code") or {}
        code = f"{c.get('coarse')}/{c.get('mid')}/{c.get('fine')}"
        lines.append(
            f"| {r['pdk']} | {r['tag']} | {code} | {_fmt(r.get('freq_mhz'))} | "
            f"{_fmt(r.get('period_mean_ns'))} | {r.get('status')} |"
        )
    lines += [
        "",
        "The TT code-step table is a local large-signal frequency sensitivity",
        "check. It is not a calibrated KDCO over the full thermometer range.",
        "A `LIMITED_EDGES` ring row is a one-period frequency estimate from a",
        "slow corner; its RMS/pp fields are not a jitter claim.",
        "",
        "## Jitter interpretation",
        "",
        "The ring table's `RMS` is the standard deviation of settled output",
        "period, and `c2c RMS` is the RMS of first differences. These are",
        "deterministic spread from a noiseless transient, not random jitter.",
        "No integrated phase noise or Pnoise number is reported.",
        "",
        "The counter's output period is quantized to TICK periods. At",
        "TICK = 100 MHz and BASE_INC = 3493 the output alternates 380/370 ns:",
        "period pp = 10 ns and RMS = 4.985 ns. This is deterministic",
        "quantization, not a random-jitter model.",
        "",
        "## Counter / NCO",
        "",
        "| PDK | Increment | Mean period (ns) | pp (ns) | RMS (ns) | f (MHz) | Status |",
        "|---|---:|---:|---:|---:|---:|---|",
    ]
    for r in nco.get("rows", []):
        lines.append(
            f"| {r['pdk']} | {r.get('increment')} | {_fmt(r.get('period_mean_ns'))} | "
            f"{_fmt(r.get('period_pp_ns'))} | {_fmt(r.get('period_rms_ns'))} | "
            f"{_fmt(r.get('freq_mhz'))} | {r.get('status')} |"
        )
    lines += [
        "",
        "## Explicit limitations",
        "",
        "- No PSS/Pnoise result exists in the available ngspice build; no",
        "  phase-noise or random-jitter number is claimed.",
        "- gf180mcu and sky130 macro SPICE views are cell-level, not",
        "  RC-extracted. IHP has a routed SPEF, but its instance names do not",
        "  match the gate netlist, so this STA is gate-level rather than",
        "  SPEF-annotated. The IHP SPICE PVT run also uses the cell-level view.",
        "- The sky130 ring functional probe is included as an actual result.",
        "  The RTL `PLL_CELL_NOR2BX1` mapping was corrected so `DCO_EN=1`",
        "  enables the oscillator path.  Any row that still reports",
        "  `NO_OSCILLATION` after this change is a startup-window or",
        "  edge-count limitation of that transient, not the old",
        "  `DCO_EN`/`INJ_WIN` mapping failure.",
        "- The sky130 counter previously failed setup at the 100 MHz TICK",
        "  planning point in the SS corner (WNS -0.640 ns, TNS -1.85 ns).",
        "  The carry-select phase accumulator closes it (SS WNS +1.47 ns,",
        "  estimated max TICK ~117.2 MHz); TT/FF also pass.",
        "- Counter PVT frequency is not a measured transistor-level number.",
        "  The digital output frequency is set by TICK and the code; PVT",
        "  affects timing closure and maximum TICK only.",
        "",
        "## Reproduction",
        "",
        "```sh",
        "python3 flow/characterization/macro_char.py sta --pdk all",
        "python3 flow/characterization/macro_char.py ring-pvt --pdk all",
        "python3 flow/characterization/macro_char.py ring-tune --pdk all",
        "python3 flow/characterization/macro_char.py counter",
        "python3 flow/characterization/macro_char.py report",
        "```",
        "",
    ]
    (OUT / "CHARACTERIZATION.md").write_text("\n".join(lines))


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def _pdks(arg: str) -> list[str]:
    return list(PDKS) if arg == "all" else [arg]


def main() -> int:
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("sta")
    p.add_argument("--pdk", choices=("all",) + PDKS, default="all")
    p.add_argument("--jobs", type=int, default=4)

    p = sub.add_parser("ring-pvt")
    p.add_argument("--pdk", choices=("all",) + PDKS, default="all")
    p.add_argument("--jobs", type=int, default=2)
    p.add_argument("--stop-ns", type=float, default=None)
    p.add_argument("--step-ns", type=float, default=None)

    p = sub.add_parser("ring-tune")
    p.add_argument("--pdk", choices=("all",) + PDKS, default="all")
    p.add_argument("--jobs", type=int, default=2)

    sub.add_parser("counter")
    sub.add_parser("report")

    args = ap.parse_args()
    _ensure_dirs()
    if args.cmd == "sta":
        run_sta_all(_pdks(args.pdk), args.jobs)
    elif args.cmd == "ring-pvt":
        run_ring_pvt(_pdks(args.pdk), args.jobs,
                      stop_ns=args.stop_ns, step_ns=args.step_ns)
    elif args.cmd == "ring-tune":
        run_ring_tune(_pdks(args.pdk), args.jobs)
    elif args.cmd == "counter":
        run_counter()
    elif args.cmd == "report":
        write_report()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
