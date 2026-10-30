#!/usr/bin/env python3
"""Run one DCO code with and without routed-net capacitance.

Input is the ``dco_pex_caps.inc`` produced by ``pex_extract.py``.  The
capacitors are the SPEF total net capacitance of the ``pll_ana_dco`` nets; a
1 Gohm resistor gives every otherwise-floating gate net a DC path.  This is a
first-order PEX sensitivity check, not full RC/coupling back-annotation.
"""
from __future__ import annotations

import argparse
import csv
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
IHP_ROOT = Path(
    "/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
    "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2"
)
CELL_CDL = Path("/grid/ics55/libs.ref/ics55_LLSC_H7CR/cdl/ics55_LLSC_H7CR.cdl")
MODEL_LIB = Path("/grid/ics55/libs.tech/spice/foundry/ngspice/ICsprout_55LLULP1225_V1p1_hsp.lib")
FLATTEN = ROOT / "flow" / "macro" / "ics55_h7cr" / "flatten_cdl.py"


def parse_raw(path: Path):
    b = path.read_bytes()
    marker = b"Binary:\n"
    i = b.index(marker) + len(marker)
    text = b[:i].decode("latin1")
    nv = int(re.search(r"No\. Variables:\s*(\d+)", text).group(1))
    np = int(re.search(r"No\. Points:\s*(\d+)", text).group(1))
    names = re.findall(r"^\s*\d+\s+(\S+)\s+", text, re.M)
    vals = struct_unpack(nv * np, b[i:i + nv * np * 8])
    time = [vals[k * nv] for k in range(np)]
    return time, {name: [vals[k * nv + j] for k in range(np)]
                  for j, name in enumerate(names)}


def struct_unpack(count: int, data: bytes):
    import struct
    return struct.unpack("<%dd" % count, data)


def period_of(time, wave, threshold=0.6):
    edges = [time[k] for k in range(1, len(time)) if wave[k - 1] < threshold <= wave[k]]
    if len(edges) < 3:
        return None
    edges = edges[max(1, int(len(edges) * 0.25)):]
    periods = [b - a for a, b in zip(edges, edges[1:])]
    return sum(periods) / len(periods) if periods else None


def write_code(path: Path, coarse: int, mid: int, fine: int):
    s = path.read_text()
    for name, code in (("coarse", coarse), ("mid", mid), ("fine", fine)):
        s = re.sub(
            rf"^V{name}<(\d+)> {name}<\d+> GND DC=\S+",
            lambda mm: f"V{name}<{mm.group(1)}> {name}<{mm.group(1)}> GND DC="
                       + ("lvdd" if int(mm.group(1)) < code else "0.0"),
            s, flags=re.M,
        )
    path.write_text(s)


def setup_ics55(out: Path, code: tuple[int, int, int]) -> str:
    out.mkdir(parents=True, exist_ok=True)
    model_dir = MODEL_LIB.parent
    for f in ("model_wrapper1_hsp.lib", "model_wrapper2_hsp.lib"):
        dst = out / f
        if not dst.exists():
            dst.symlink_to(model_dir / f)
    for d in ("mos", "bjt", "dio", "res", "var", "mom"):
        dst = out / d
        if not dst.exists():
            dst.symlink_to(model_dir / d, target_is_directory=True)

    dco = ROOT / "syn" / "outputs" / "ics55" / "PLL_ILDCO.sp"
    flat = out / "PLL_ILDCO_flat.sp"
    subprocess.run([sys.executable, str(FLATTEN),
                    "--cells", str(CELL_CDL), "--macro", str(dco),
                    "--top", "PLL_ILDCO", "--out", str(flat),
                    "--preserve-top-nets"],
                   check=True, stdout=subprocess.DEVNULL)
    lines = []
    for line in flat.read_text().splitlines():
        if line.startswith("M"):
            toks = line.split()
            toks[0] = "X" + toks[0][1:]
            toks = [("mr=" + t[2:]) if t.startswith("m=") else t for t in toks]
            line = " ".join(toks)
        lines.append(line)
    (out / "PLL_ILDCO_flat_x.sp").write_text("\n".join(lines) + "\n")
    (out / "models_flat.inc").write_text(
        f'.LIB "{MODEL_LIB}" tt_mos\n'
        ".PARAM lvdd=1.2\n"
        ".SUBCKT PLL_CELL_BUFFX0 VDD VSS I Z\n"
        "B1 Z 0 V=V(I)\n"
        ".ENDS\n"
    )
    base = (ROOT / "src" / "test_dco.sp").read_text()
    base = base.replace(".inc models.inc", ".inc models_flat.inc")
    base = base.replace(".inc PLL_ILDCO.sp", ".inc PLL_ILDCO_flat_x.sp")
    base = base.replace(".PARAM stopsim=(10000n)", ".PARAM stopsim=(10000n)")
    return base


def setup_ihp(out: Path, code: tuple[int, int, int]) -> str:
    src = ROOT / "flow" / "characterization" / "ihp_l3"
    for f in ("models_l3.inc", "PLL_ILDCO.sp"):
        if not (src / f).exists():
            raise SystemExit(f"missing {src / f}; run flow/characterization/ihp_l3_scan.py first")
        shutil.copy(src / f, out / f)
    osdi = src / "psp103.osdi"
    if not osdi.exists():
        raise SystemExit(f"missing {osdi}; run ihp_l3_scan.py to compile it")
    (out / ".spiceinit").write_text(f"set num_threads=8\nosdi '{osdi.resolve()}'\n")
    base = (ROOT / "src" / "test_dco.sp").read_text()
    base = base.replace(".inc models.inc", ".inc models_l3.inc")
    base = base.replace(".inc PLL_ILDCO.sp", ".inc PLL_ILDCO.sp")
    return base


def run_case(out: Path, base: str, mode: str, pdk: str, code: tuple[int, int, int],
             stop_ns: float) -> tuple[float, float, str]:
    c, m, f = code
    stem = f"{mode}_c{c}_m{m}_f{f}"
    code_file = out / f"test_dco_{stem}.sp"
    code_file.write_text(base)
    write_code(code_file, c, m, f)
    inc = f'.inc test_dco_{stem}.sp\n'
    if mode == "pex":
        inc += ".inc dco_pex_caps.inc\n"
    if pdk == "ics55":
        tran = (
            f".ic V(OUT)=0.6 V(MID_OUT)=0.6\n"
            f".tran 1p {stop_ns}n\n"
        )
    else:
        tran = f".tran 10n {stop_ns}n uic\n"
    net = out / f"test_dco_{stem}_tran.sp"
    net.write_text(
        f"* {pdk} {mode} DCO transient\n"
        f"{inc}"
        f"{tran}"
        ".SAVE V(OUT) V(MID_OUT)\n"
        ".control\nrun\n"
        f"write test_dco_{stem}.raw\n"
        "quit\n.endc\n"
    )
    raw = out / f"test_dco_{stem}.raw"
    log = out / f"test_dco_{stem}.log"
    env = dict(os.environ)
    env.setdefault("OMP_NUM_THREADS", "4")
    subprocess.run(["ngspice", "-o", log.name, net.name], cwd=out,
                   check=True, timeout=900, env=env,
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    time, traces = parse_raw(raw)
    p = period_of(time, traces["v(out)"])
    if p is None:
        raise RuntimeError(f"{stem}: no output edges")
    return p, 1e-6 / p, log.name


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdk", choices=("ics55", "ihp-sg13g2"), required=True)
    ap.add_argument("--out", required=True, help="directory with dco_pex_caps.inc")
    ap.add_argument("--coarse", type=int, default=8)
    ap.add_argument("--mid", type=int, default=8)
    ap.add_argument("--fine", type=int, default=8)
    ap.add_argument("--stopsim-ns", type=float)
    args = ap.parse_args()
    out = Path(args.out)
    if not (out / "dco_pex_caps.inc").exists():
        raise SystemExit(f"missing {out / 'dco_pex_caps.inc'}; run pex_extract.py")
    code = (args.coarse, args.mid, args.fine)
    base = setup_ics55(out, code) if args.pdk == "ics55" else setup_ihp(out, code)
    stop_ns = args.stopsim_ns or (10.0 if args.pdk == "ics55" else 30.0)
    rows = []
    for mode in ("baseline", "pex"):
        period, freq, log = run_case(out, base, mode, args.pdk, code, stop_ns)
        rows.append({"pdk": args.pdk, "mode": mode,
                     "coarse": code[0], "mid": code[1], "fine": code[2],
                     "period_ns": period * 1e9, "freq_mhz": freq, "log": log})
        print(f"{args.pdk} {mode}: {freq:.3f} MHz")
    delta = rows[1]["freq_mhz"] - rows[0]["freq_mhz"]
    pct = 100.0 * delta / rows[0]["freq_mhz"]
    with (out / "dco_pex_results.csv").open("w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    manifest = json.loads((out / "dco_pex.json").read_text())
    manifest.update({
        "code": {"coarse": code[0], "mid": code[1], "fine": code[2]},
        "baseline_mhz": round(rows[0]["freq_mhz"], 6),
        "pex_mhz": round(rows[1]["freq_mhz"], 6),
        "delta_mhz": round(delta, 6),
        "delta_percent": round(pct, 3),
        "stopsim_ns": stop_ns,
        "status": "L3_PEX_CAP",
    })
    (out / "dco_pex.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"delta: {delta:+.3f} MHz ({pct:+.2f}%)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
