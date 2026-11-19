#!/usr/bin/env python3
"""Derive a DLL legal-code window for a target reference period.

Why this exists
---------------
`DLL_FULL_PERIOD_TOP` accepts a code only inside [CODE_MIN, CODE_MAX].  Those
constants encode the delay-line model

    period_ps(code) = T0_PS
                    + (code // SEG_TAPS) * EXTRA_PS
                    + code * CELL_PS

so the window is valid for exactly one reference period.  Feed the DLL a
different reference and the whole window can miss, leaving no legal code --
the "no legal code in one period" failure that showed up when the DDR DLL was
driven from a 200 MHz (5 ns) reference while the shipped window was calibrated
for 10 ns.

Deriving the window at runtime was tried and abandoned: any combinational
dependence on `period_ticks` (X until the first measurement) made the
simulator re-enter the always block indefinitely.  The window stays a pair of
parameters, and this script prints the pair for a given period.

Usage
-----
    python3 flow/sta/derive_code_window.py --period-ns 5
    python3 flow/sta/derive_code_window.py --period-ns 10 --margin 0.05
    python3 flow/sta/derive_code_window.py --period-ns 5 --chparam

The --chparam form prints the chparam fragment the gate-level flow uses.
"""
from __future__ import annotations

import argparse
import math


def period_ps(code: int, t0_ps: int, cell_ps: int, extra_ps: int,
              seg_taps: int) -> float:
    """Delay-line period for a code, matching dll_full_period_top's model."""
    return t0_ps + (code // seg_taps) * extra_ps + code * cell_ps


def solve_code(target_ps: float, t0_ps: int, cell_ps: int, extra_ps: int,
               seg_taps: int) -> tuple[int, int]:
    """Smallest code whose modelled period reaches target_ps.

    Returns (code, achieved_ps).  The line is monotone in the code, so a
    linear scan is exact and the search space is a few hundred points.
    """
    best_code, best_ps = 0, period_ps(0, t0_ps, cell_ps, extra_ps, seg_taps)
    code = 0
    while code < 4096:
        ps = period_ps(code, t0_ps, cell_ps, extra_ps, seg_taps)
        if abs(ps - target_ps) < abs(best_ps - target_ps):
            best_code, best_ps = code, ps
        if ps > target_ps:
            break
        code += 1
    return best_code, int(round(best_ps))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--period-ns", type=float, required=True,
                    help="target reference period in ns")
    ap.add_argument("--t0-ps", type=int, default=2930)
    ap.add_argument("--cell-ps", type=int, default=30)
    ap.add_argument("--extra-ps", type=int, default=62)
    ap.add_argument("--seg-taps", type=int, default=56)
    ap.add_argument("--margin", type=float, default=0.25,
                    help="half-window as a fraction of the centre code "
                         "(default 0.25 = +/-25%%)")
    ap.add_argument("--chparam", action="store_true",
                    help="print the chparam fragment instead of a table")
    args = ap.parse_args()

    target = args.period_ns * 1000.0
    centre, achieved = solve_code(target, args.t0_ps, args.cell_ps,
                                  args.extra_ps, args.seg_taps)
    lo = max(1, int(round(centre * (1.0 - args.margin))))
    hi = int(round(centre * (1.0 + args.margin)))

    if args.chparam:
        print(f"-set CODE_MIN {lo} -set CODE_MAX {hi}")
        return 0

    print(f"target period      : {args.period_ns:g} ns ({target:g} ps)")
    print(f"delay-line model   : T0={args.t0_ps} ps, CELL={args.cell_ps} ps, "
          f"EXTRA={args.extra_ps} ps per {args.seg_taps} taps")
    print(f"centre code        : {centre} -> {achieved} ps "
          f"({achieved / target * 100.0:.2f}% of target)")
    print(f"legal window       : CODE_MIN={lo}  CODE_MAX={hi} "
          f"(+/-{args.margin * 100:.0f}%)")
    print()
    print("reject check (the window must not accept a half- or double-period "
          "code):")
    for mult, name in ((0.5, "0T/0.5T"), (1.0, "1T"), (2.0, "2T")):
        c, ps = solve_code(target * mult, args.t0_ps, args.cell_ps,
                           args.extra_ps, args.seg_taps)
        verdict = "ACCEPT" if lo <= c <= hi else "reject"
        print(f"  {name:8s} code~{c:4d} ({ps} ps) -> {verdict}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
