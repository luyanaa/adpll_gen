#!/usr/bin/env python3
"""SPEF-annotated loop-delay / fine-tuning sweep for the extracted ring DCO.

Why a loop cut: the ring DCO is a combinational loop, which STA refuses to
analyse.  This script rewrites the post-PnR netlist so the oscillator's closing
gate drives LOOP_OUT and the loop is driven from LOOP_IN.  One traversal is
half an oscillation period, so

    period = t(max traversal) + t(min traversal)
    f      = 1 / period

The same sweep over FINE_MUX gives the fine code -> period curve.  Note that
Liberty pin capacitances are code-invariant: the FINE bank is a switched
*transistor* load, so this flow measures the PEX frequency and the coarse/mid
effect, but it can only prove "no effect" for FINE.  Fine monotonicity needs a
transistor-level transient (see flow/characterization/macro_char.py).
"""
from __future__ import annotations

import argparse
import csv
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TCL = Path(__file__).resolve().parent / "ring_dco_loop.sta.tcl"
WORK = Path("/tmp/opencode/ring_dco_loop")

PDKS = {
    "ics55": {
        "netlist": ROOT / "pnr/outputs/ics55/PLL_RING_DCO_PHYS.v",
        "spef": ROOT / "pnr/outputs/ics55/PLL_RING_DCO_PHYS.spef",
        "libs": {
            "tt": "/grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CR/liberty/"
                  "ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib",
            "ss": "/grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CR/liberty/"
                  "ics55_LLSC_H7CR_ss_cworst_1p08_m40_nldm.lib",
            "ff": "/grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CR/liberty/"
                  "ics55_LLSC_H7CR_ff_cbest_1p32_125_nldm.lib",
        },
    },
    "ihp": {
        "netlist": ROOT / "pnr/outputs/ihp-sg13g2-sg13g2_stdcell/"
                          "PLL_RING_DCO_PHYS.v",
        "spef": ROOT / "pnr/outputs/ihp-sg13g2-sg13g2_stdcell/"
                       "PLL_RING_DCO_PHYS.spef",
        "libs": {
            "tt": "/shared/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2/"
                  "lib/sg13g2_stdcell_typ_1p20V_25C.lib",
            "ss": "/shared/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2/"
                  "lib/sg13g2_stdcell_slow_1p08V_125C.lib",
            "ff": "/shared/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2/"
                  "lib/sg13g2_stdcell_fast_1p65V_m40C.lib",
        },
    },
}

PHYS_RE = re.compile(
    r"^\s*(?:FILLER\d*H7R|FILLCAP\d*H7R|FILLTAPH7R|FILLER2H7R"
    r"|sg13g2_(?:fill|decap|tap)\S*)\s+\S+\s*\(\s*\)\s*;\s*$",
    re.M,
)


def flatten_escaped(text: str) -> str:
    return re.sub(r"\\([^\s;()]+)", lambda m: m.group(1).replace("/", "_"), text)


def cut_loop(pdk: str, src: Path) -> str:
    s = PHYS_RE.sub("", src.read_text())
    m = re.search(
        r"\n\s*(?:NAND2\w*H7R|sg13g2_nand2\w*)\s+\\ring/sym/sym_mux/nand_pll_impl"
        r"\s*\((.*?)\);",
        s, re.S)
    if m is None:
        raise SystemExit("closing gate (nand_pll_impl) not found")
    y = re.search(r"\.Y\(\s*([^)\s]+)\s*\)", m.group(1)).group(1)

    # 1) Rename the closing gate output first: this splice uses offsets into
    #    the current string, so it must happen before any length change.
    s = s[:m.start()] + m.group(0).replace(f".Y({y})", ".Y(LOOP_OUT)") + s[m.end():]

    # 2) Expose the cut.  OUT is the loop start; LOOP_OUT is the loop return.
    s = s.replace(
        "module PLL_RING_DCO_PHYS (DCO_EN,",
        "module PLL_RING_DCO_PHYS (LOOP_IN,\n    LOOP_OUT,\n    DCO_EN,", 1)
    s = s.replace("    OUT,\n", "", 1)
    s = s.replace(" input DCO_EN;",
                  " input LOOP_IN;\n output LOOP_OUT;\n input DCO_EN;", 1)
    if y == "OUT":
        s = s.replace(" output OUT;",
                      " wire OUT;\n assign OUT = LOOP_IN;", 1)
    else:
        s = s.replace(f" wire {y};",
                      f" wire {y};\n assign {y} = LOOP_IN;", 1)
    return flatten_escaped(s)


def flatten_spef(src: Path) -> str:
    out, in_map = [], False
    for line in src.read_text().splitlines():
        if line.startswith("*NAME_MAP"):
            in_map = True
            out.append(line)
            continue
        if in_map and line.startswith("*") and not re.match(r"^\*\d+ ", line):
            in_map = False
        if in_map:
            m = re.match(r"^(\*\d+) (\S+)$", line)
            if m:
                line = f"{m.group(1)} {m.group(2).replace('/', '_')}"
        out.append(line)
    return "\n".join(out) + "\n"


def run_corner(pdk: str, corner: str, netlist: Path, spef: Path,
               codes: list[int], coarse: int, mid: int) -> list[dict]:
    env = {
        "LIB": PDKS[pdk]["libs"][corner],
        "NETLIST": str(netlist),
        "SPEF": str(spef),
        "CODES": " ".join(str(c) for c in codes),
        "COARSE": str(coarse),
        "MID": str(mid),
        "PATH": "/usr/local/bin:/usr/bin:/bin",
    }
    proc = subprocess.run(
        ["sta", "-exit", str(TCL)], capture_output=True, text=True, env=env,
        timeout=1800,
    )
    if proc.returncode != 0:
        print(proc.stdout[-2000:], file=sys.stderr)
        print(proc.stderr[-2000:], file=sys.stderr)
        raise SystemExit(f"sta failed for {pdk}/{corner}")
    rows, blocks = [], re.split(r"RINGSTA_BEGIN fine=(\d+)", proc.stdout)
    for i in range(1, len(blocks), 2):
        code = int(blocks[i])
        arrivals = re.findall(r"(\d+\.\d+)\s+data arrival time", blocks[i + 1])
        if len(arrivals) < 2:
            rows.append({"pdk": pdk, "corner": corner, "fine": code,
                         "status": "NOPATH"})
            continue
        tu, td = float(arrivals[0]), float(arrivals[1])
        rows.append({"pdk": pdk, "corner": corner, "fine": code,
                     "status": "OK", "rise_ns": tu, "fall_ns": td,
                     "period_ns": tu + td, "freq_mhz": 1000.0 / (tu + td)})
    return rows


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdk", choices=sorted(PDKS), required=True)
    ap.add_argument("--corners", default="tt,ss,ff")
    ap.add_argument("--codes", default="0,8,16,24,31")
    ap.add_argument("--no-spef", action="store_true",
                    help="cell-delay-only baseline (no parasitics)")
    ap.add_argument("--coarse", type=int, default=0)
    ap.add_argument("--mid", type=int, default=0)
    ap.add_argument("--csv", default="")
    args = ap.parse_args()

    codes = [int(c) for c in args.codes.split(",") if c != ""]
    WORK.mkdir(parents=True, exist_ok=True)
    net = WORK / f"{args.pdk}_loop.v"
    net.write_text(cut_loop(args.pdk, PDKS[args.pdk]["netlist"]))
    spef = WORK / f"{args.pdk}.spef"
    if not args.no_spef:
        spef.write_text(flatten_spef(PDKS[args.pdk]["spef"]))
    else:
        spef.write_text("")

    rows = []
    for corner in [c for c in args.corners.split(",") if c]:
        rows += run_corner(args.pdk, corner, net, spef, codes,
                           args.coarse, args.mid)

    print(f"{'pdk':6} {'corner':6} {'fine':>4} {'rise_ns':>9} {'fall_ns':>9} "
          f"{'period_ns':>10} {'freq_MHz':>9}")
    for r in rows:
        if r["status"] != "OK":
            print(f"{r['pdk']:6} {r['corner']:6} {r['fine']:>4} {r['status']}")
            continue
        print(f"{r['pdk']:6} {r['corner']:6} {r['fine']:>4} "
              f"{r['rise_ns']:>9.5f} {r['fall_ns']:>9.5f} "
              f"{r['period_ns']:>10.5f} {r['freq_mhz']:>9.2f}")

    if args.csv:
        fields = ["pdk", "corner", "fine", "status", "rise_ns", "fall_ns",
                  "period_ns", "freq_mhz"]
        with Path(args.csv).open("w", newline="") as fh:
            w = csv.DictWriter(fh, fieldnames=fields, extrasaction="ignore")
            w.writeheader()
            w.writerows(rows)
        print(f"wrote {args.csv}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
