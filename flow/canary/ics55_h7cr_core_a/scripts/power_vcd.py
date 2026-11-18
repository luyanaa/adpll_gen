#!/usr/bin/env python3
"""VCD-driven power for the ics55 digital canary post-PnR netlist.

Why this exists: `report_power` without activity data is a default-toggle
estimate.  The DSM accumulator / FLL IIR ICG only pays off when the design is
actually locked, so the vectorless number cannot show the saving.  This script
runs OpenROAD's `read_vcd` on the placed-and-routed netlist and reports
switching power for a chosen simulation window.

OpenSTA 2.0.17 has no `read_vcd`, so the OpenROAD binary is required.  On this
host it lives in the iic-osic-tools container; pass --openroad to override.

The VCD comes from the gate-level simulation (`make test_pll_digital_postsyn`
in sim/), which dumps every net.  Two windows are meaningful:

  * before lock -- DSM and the FLL IIR are both active
  * after lock  -- the ICG is closed (dsm_en=0, fll_en=0)

Splitting the VCD by time gives the comparable numbers.  Note that a gate-level
simulation of the behavioural DCO is not a signoff environment: use the deltas
as a trend, not as measured silicon power.
"""
from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

RUNS = ROOT / "flow" / "canary" / "ics55_h7cr_core_a" / "runs"

OPENROAD_TCL = """\
read_liberty {lib}
read_verilog {netlist}
link_design pll_logic
read_sdc {sdc}
{extra}
read_vcd -scope pll_logic_tb/dut {vcd}
report_power > {report}
exit
"""


def latest_run() -> Path:
    runs = sorted(RUNS.glob("RUN_*"), key=lambda p: p.stat().st_mtime)
    if not runs:
        raise SystemExit(f"no LibreLane run under {RUNS}")
    return runs[-1]


def pick_openroad(explicit: str | None) -> list[str]:
    if explicit:
        return [explicit]
    local = shutil.which("openroad")
    if local:
        return [local]
    return [
        "docker", "run", "--rm", "--entrypoint", "/bin/bash",
        "-v", "/grid:/grid", "-v", "/tmp/opencode:/tmp/opencode",
        "-e", "PATH=/foss/tools/bin:/usr/local/bin:/usr/bin:/bin",
        "hpretl/iic-osic-tools:latest", "-lc",
    ]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--run", default="", help="LibreLane run dir (default: newest)")
    ap.add_argument("--corner", default="nom_tt_025C_1v20")
    ap.add_argument("--vcd", required=True)
    ap.add_argument("--scope", default="pll_logic_tb/dut")
    ap.add_argument("--begin", default="", help="VCD begin time (ns)")
    ap.add_argument("--end", default="", help="VCD end time (ns)")
    ap.add_argument("--openroad", default="")
    ap.add_argument("--report", default="")
    ap.add_argument("--json", default="", help="write a summary JSON here")
    args = ap.parse_args()

    run = Path(args.run) if args.run else latest_run()
    netlist = run / "final" / "nl" / "pll_logic.nl.v"
    sdc = run / "final" / "sdc" / "pll_logic.sdc"
    lib_dir = run / "final" / "lib" / args.corner
    libs = sorted(lib_dir.glob("*.lib"))
    for p in (netlist, sdc, Path(args.vcd)):
        if not p.exists():
            raise SystemExit(f"missing: {p}")
    if not libs:
        raise SystemExit(f"no liberty under {lib_dir}")

    extra = []
    if args.begin:
        extra.append(f"read_vcd -begin {args.begin}")
    report = Path(args.report) if args.report else (
        Path("/tmp/opencode") / f"power_vcd_{args.corner}.rpt")
    report.parent.mkdir(parents=True, exist_ok=True)

    tcl = OPENROAD_TCL.format(
        lib=libs[0], netlist=netlist, sdc=sdc, vcd=Path(args.vcd).resolve(),
        report=report, extra="",
    )
    tcl_path = Path("/tmp/opencode") / "power_vcd.tcl"
    tcl_path.write_text(tcl)

    runner = pick_openroad(args.openroad or None)
    if runner[0] == "docker":
        cmd = runner + [f"openroad -exit {tcl_path}"]
    else:
        cmd = runner + ["-exit", str(tcl_path)]
    print("run:", " ".join(cmd[:3]), "...")
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=3600)
    out = proc.stdout + proc.stderr
    if proc.returncode != 0:
        print(out[-3000:], file=sys.stderr)
        raise SystemExit(f"openroad failed ({proc.returncode})")
    if not report.exists():
        print(out[-3000:], file=sys.stderr)
        raise SystemExit("report_power produced no file")

    text = report.read_text()
    print(text)
    totals = {}
    for line in text.splitlines():
        if line.startswith("Total "):
            parts = line.split()
            totals = {"internal": parts[1], "switching": parts[2],
                      "leakage": parts[3], "total": parts[4]}
    if args.json:
        Path(args.json).write_text(json.dumps(
            {"run": str(run), "corner": args.corner, "vcd": args.vcd,
             "begin_ns": args.begin, "end_ns": args.end, "totals": totals},
            indent=2) + "\n")
        print("wrote", args.json)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
