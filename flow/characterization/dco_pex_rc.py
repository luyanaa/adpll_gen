#!/usr/bin/env python3
"""Lumped series-R/capacitance back-annotation for the ics55 DCO.

The SPEF is used to split every DCO top-level net into a driver side and a
gate-load side:

    driver/port ---- R_total ---- gate-load side
       C_total/2                    C_total/2

This is still a lumped model (not the full distributed SPEF tree), but unlike
the earlier capacitance-only run it actually puts the extracted wire
resistance in series with the DCO delay path.  Coupling capacitance is grounded.
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path

from dco_pex_cap import (
    parse_raw, period_of, setup_ics55, write_code,
)

ROOT = Path(__file__).resolve().parents[2]
COLORS = re.compile(r"^\*D_NET\s+(\S+)\s+([\d.eE+-]+)", re.M)


def parse_spef(path: Path) -> dict[str, dict[str, float]]:
    text = path.read_text(errors="ignore")
    names: dict[str, str] = {}
    m = re.search(r"^\*NAME_MAP\s*$", text, re.M)
    if m:
        end = text.find("*PORTS", m.end())
        for line in text[m.end():end].splitlines():
            mm = re.match(r"\*(\d+)\s+(\S+)", line)
            if mm:
                names["*" + mm.group(1)] = mm.group(2)
    out: dict[str, dict[str, float]] = {}
    matches = list(COLORS.finditer(text))
    for i, mm in enumerate(matches):
        name = names.get(mm.group(1), mm.group(1))
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        block = text[mm.end():end]
        res = 0.0
        in_res = False
        for line in block.splitlines():
            if line.startswith("*RES"):
                in_res = True
                continue
            if line.startswith("*"):
                if in_res:
                    in_res = False
                continue
            if in_res:
                parts = line.split()
                if len(parts) >= 4:
                    try:
                        res += float(parts[-1])
                    except ValueError:
                        pass
        out[name] = {"cap_pf": float(mm.group(2)), "res_ohm": res}
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(ROOT / "flow" / "characterization" / "pex_ics55"))
    ap.add_argument("--coarse", type=int, default=8)
    ap.add_argument("--mid", type=int, default=8)
    ap.add_argument("--fine", type=int, default=8)
    ap.add_argument("--stopsim-ns", type=float, default=10.0)
    args = ap.parse_args()
    out = Path(args.out)
    spef = out / "PLL_ANALOG_MACRO.spef"
    if not spef.exists():
        raise SystemExit(f"missing {spef}; run pex_extract.py first")
    code = (args.coarse, args.mid, args.fine)
    base = setup_ics55(out, code)
    flat = out / "PLL_ILDCO_flat_x.sp"
    lines = flat.read_text().splitlines()

    netdata = parse_spef(spef)
    caps = {}
    for name, data in netdata.items():
        short = name[len("pll_ana_dco/"):] if name.startswith("pll_ana_dco/") else name
        if name.startswith("pll_ana_dco/") or name in ("OUT", "MID_OUT"):
            caps[short] = data

    # Gate terminals are the load side; drain/source terminals stay on the
    # driver/port side.  This is valid for the DCO's static CMOS stages.
    gate_nets = set()
    for line in lines:
        if not line.startswith("X"):
            continue
        toks = line.split()
        if len(toks) >= 6 and toks[2] in caps:
            gate_nets.add(toks[2])

    out_lines = []
    rc_lines = []
    n = 0
    for line in lines:
        if line.startswith("X") and not line.startswith(".SUBCKT"):
            toks = line.split()
            if len(toks) >= 6:
                if toks[2] in caps and toks[2] in gate_nets:
                    toks[2] = toks[2] + "__load"
                line = " ".join(toks)
        out_lines.append(line)

    for net, data in caps.items():
        c = data["cap_pf"]
        r = data["res_ohm"]
        if net in gate_nets:
            load = net + "__load"
            rc_lines.append(f"Rrc{n} {net} {load} {max(r, 1e-3):.6g}")
            rc_lines.append(f"Crc{n} {net} 0 {c/2:.9g}p")
            rc_lines.append(f"Crc{n}b {load} 0 {c/2:.9g}p")
        else:
            rc_lines.append(f"Crc{n} {net} 0 {c:.9g}p")
        n += 1

    # Insert the RC elements inside the DCO subcircuit.
    final = []
    for line in out_lines:
        if line.strip().upper().startswith(".ENDS"):
            final.extend(rc_lines)
        final.append(line)
    (out / "PLL_ILDCO_flat_rc.sp").write_text("\n".join(final) + "\n")

    stem = f"rc_c{code[0]}_m{code[1]}_f{code[2]}"
    sol = base.replace(".inc PLL_ILDCO_flat_x.sp", ".inc PLL_ILDCO_flat_rc.sp")
    (out / f"test_dco_{stem}.sp").write_text(sol)
    write_code(out / f"test_dco_{stem}.sp", *code)
    netlist = out / f"test_dco_{stem}_tran.sp"
    netlist.write_text(
        "* ics55 DCO lumped RC back-annotation\n"
        f".inc test_dco_{stem}.sp\n"
        ".ic V(OUT)=0.6 V(MID_OUT)=0.6\n"
        f".tran 1p {args.stopsim_ns}n\n"
        ".SAVE V(OUT) V(MID_OUT)\n"
        ".control\nrun\n"
        f"write test_dco_{stem}.raw\n"
        "quit\n.endc\n"
    )
    subprocess.run(["ngspice", "-o", f"test_dco_{stem}.log", netlist.name],
                   cwd=out, check=True, timeout=900,
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    time, traces = parse_raw(out / f"test_dco_{stem}.raw")
    period = period_of(time, traces["v(out)"])
    if period is None:
        raise SystemExit("no output edges")
    freq = 1e-6 / period
    total_r = sum(d["res_ohm"] for d in caps.values())
    manifest = json.loads((out / "dco_pex.json").read_text())
    manifest.update({
        "characterization_level": "L3_PEX_RC_LUMPED",
        "rc_model": "one series R_total per top net, C_total split driver/load",
        "series_r_total_ohm": round(total_r, 6),
        "rc_mhz": round(freq, 6),
        "code": {"coarse": code[0], "mid": code[1], "fine": code[2]},
        "status": "L3_PEX_RC_LUMPED",
    })
    (out / "dco_pex_rc.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"lumped-RC: {freq:.3f} MHz, sum R={total_r:.3f} ohm")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
