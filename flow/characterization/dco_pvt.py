#!/usr/bin/env python3
"""Corner sweep for one PEX-capacitance-annotated DCO code.

Corners are the vendor MOS decks at their library supply/temperature points:
TT/1.20 V/25 C, SS/1.08 V/125 C, FF/1.32 V/-40 C.  This is a frequency-corner
check, not a jitter or phase-noise signoff.
"""
from __future__ import annotations

import argparse
import csv
import json
import os
import re
import subprocess
from pathlib import Path

from dco_pex_cap import (
    IHP_ROOT, MODEL_LIB, parse_raw, period_of, setup_ics55, setup_ihp, write_code,
)

CORNERS = {
    "ics55": {
        "tt": ("tt_mos", 1.20, 25),
        "ss": ("ss_mos", 1.08, 125),
        "ff": ("ff_mos", 1.32, -40),
    },
    "ihp-sg13g2": {
        "tt": ("mos_tt", 1.20, 25),
        "ss": ("mos_ss", 1.08, 125),
        "ff": ("mos_ff", 1.32, -40),
    },
}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdk", choices=("ics55", "ihp-sg13g2"), required=True)
    ap.add_argument("--out", required=True)
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
    for label, (lib, vdd, temp) in CORNERS[args.pdk].items():
        if args.pdk == "ics55":
            model = (
                f'.LIB "{MODEL_LIB}" {lib}\n'
                f".PARAM lvdd={vdd}\n"
                ".SUBCKT PLL_CELL_BUFFX0 VDD VSS I Z\n"
                "B1 Z 0 V=V(I)\n"
                ".ENDS\n"
            )
            inc = f".inc models_{label}.inc"
            sol_inc = base.replace(".inc models_flat.inc", inc)
            tran = f".tran 1p {stop_ns}n\n.ic V(OUT)=0.6 V(MID_OUT)=0.6\n"
        else:
            src = (out / "models_l3.inc").read_text()
            src = re.sub(r'\.LIB "[^"]+" mos_\w+',
                         f'.LIB "{IHP_ROOT}/libs.tech/ngspice/models/cornerMOSlv.lib" {lib}',
                         src, count=1)
            src = re.sub(r"\.PARAM lvdd=\S+", f".PARAM lvdd={vdd}", src, count=1)
            model = src
            inc = f".inc models_{label}.inc"
            sol_inc = base.replace(".inc models_l3.inc", inc)
            tran = f".tran 10n {stop_ns}n uic\n"
        (out / f"models_{label}.inc").write_text(model)
        sol_inc = sol_inc.replace(".TEMP 25", f".TEMP {temp}")
        stem = f"pvt_{label}_c{code[0]}_m{code[1]}_f{code[2]}"
        (out / f"test_dco_{stem}.sp").write_text(sol_inc)
        write_code(out / f"test_dco_{stem}.sp", *code)
        net = out / f"test_dco_{stem}_tran.sp"
        net.write_text(
            f"* {args.pdk} {label} PEX-cap DCO\n"
            f".inc test_dco_{stem}.sp\n"
            ".inc dco_pex_caps.inc\n"
            f"{tran}"
            ".SAVE V(OUT) V(MID_OUT)\n"
            ".control\nrun\n"
            f"write test_dco_{stem}.raw\n"
            "quit\n.endc\n"
        )
        env = dict(os.environ)
        env.setdefault("OMP_NUM_THREADS", "4")
        subprocess.run(["ngspice", "-o", f"test_dco_{stem}.log", net.name],
                       cwd=out, check=True, timeout=900, env=env,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        time, traces = parse_raw(out / f"test_dco_{stem}.raw")
        p = period_of(time, traces["v(out)"])
        if p is None:
            raise RuntimeError(f"{stem}: no output edges")
        freq = 1e-6 / p
        rows.append({"pdk": args.pdk, "corner": label, "lib": lib,
                     "vdd": vdd, "temp_c": temp,
                     "coarse": code[0], "mid": code[1], "fine": code[2],
                     "period_ns": p * 1e9, "freq_mhz": freq})
        print(f"{args.pdk} {label}: {freq:.3f} MHz")

    with (out / "dco_pvt.csv").open("w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    (out / "dco_pvt.json").write_text(json.dumps({
        "characterization_level": "L3_PEX_CAP",
        "code": {"coarse": code[0], "mid": code[1], "fine": code[2]},
        "stopsim_ns": stop_ns,
        "rows": rows,
        "note": "MOS corner frequency only; no jitter/phase-noise/PEX-R signoff.",
    }, indent=2) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
