#!/usr/bin/env python3
"""Delay-line monotonicity / DNL check for the DLL code->period map.

The DLL can only settle on a period some code actually produces.  If a segment
boundary steps by more than one fine cell there is a GAP in the curve: no code
lands on the periods inside it, and the loop reports "no legal code" for a
reference that needs one.  If it steps by less, two codes give the same period
and the loop can hunt.

This script mirrors the RTL model

    period(code) = T0
                 + (code // SEG_TAPS) * (SEG_TAPS*CELL + EXTRA)
                 + (code %  SEG_TAPS) * CELL

and reports, over the whole reachable range:
  * the worst positive DNL (a gap)
  * the worst negative DNL (an overlap)
  * monotonicity
  * the code window for a set of reference periods

Usage
-----
    python3 flow/sta/dll_line_linearity.py
    python3 flow/sta/dll_line_linearity.py --extra-ps 62      # the old value
    python3 flow/sta/dll_line_linearity.py --periods 5,10
"""
from __future__ import annotations

import argparse


def build_codes(t0: int, cell: int, extra: int, seg_taps: int,
                segs: int, fine_taps: int) -> list[tuple[int, int]]:
    out = []
    total = segs * seg_taps + fine_taps
    for c in range(total):
        ps = t0 + (c // seg_taps) * (seg_taps * cell + extra) \
                + (c % seg_taps) * cell
        out.append((c, ps))
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--t0-ps", type=int, default=2930)
    ap.add_argument("--cell-ps", type=int, default=30)
    ap.add_argument("--extra-ps", type=int, default=0,
                    help="segment bypass trim (0 = uniform grid)")
    ap.add_argument("--seg-taps", type=int, default=56)
    ap.add_argument("--segs", type=int, default=4)
    ap.add_argument("--fine-taps", type=int, default=56)
    ap.add_argument("--periods", default="5,10",
                    help="comma-separated reference periods (ns) to report")
    args = ap.parse_args()

    codes = build_codes(args.t0_ps, args.cell_ps, args.extra_ps,
                        args.seg_taps, args.segs, args.fine_taps)
    lsb = args.cell_ps

    worst_pos = (0, None)   # (dnl in LSB, code)
    worst_neg = (0, None)
    non_monotone = []

    for i in range(1, len(codes)):
        step = codes[i][1] - codes[i - 1][1]
        dnl = (step - lsb) / lsb
        if dnl > worst_pos[0]:
            worst_pos = (dnl, codes[i][0])
        if dnl < worst_neg[0]:
            worst_neg = (dnl, codes[i][0])
        if step <= 0:
            non_monotone.append((codes[i][0], step))
        # A gap wider than one LSB means no code can land inside it.
        if step > 2 * lsb:
            non_monotone.append((codes[i][0], step))

    print(f"delay line: T0={args.t0_ps} ps, LSB={lsb} ps, "
          f"EXTRA={args.extra_ps} ps per {args.seg_taps} taps")
    print(f"codes      : {len(codes)}  "
          f"({codes[0][1]} .. {codes[-1][1]} ps)")
    print(f"worst DNL  : +{worst_pos[0]:.2f} LSB at code {worst_pos[1]}")
    print(f"             {worst_neg[0]:.2f} LSB at code {worst_neg[1]}")
    if non_monotone:
        print(f"DEFECTS    : {len(non_monotone)} (gap > 1 LSB or non-monotone)")
        for c, s in non_monotone[:6]:
            print(f"             code {c}: step {s} ps")
        status = 1
    else:
        print("DEFECTS    : none (monotone, no gap wider than one LSB)")
        status = 0

    print()
    print("code windows for target reference periods:")
    for ns in [x for x in args.periods.split(",") if x]:
        target = float(ns) * 1000.0
        best = min(codes, key=lambda kv: abs(kv[1] - target))
        err = (best[1] - target) / target * 100.0
        # +/-25% of the centre code, matching derive_code_window.py
        lo = max(1, int(round(best[0] * 0.75)))
        hi = int(round(best[0] * 1.25))
        print(f"  {ns} ns -> code {best[0]:4d} ({best[1]} ps, "
              f"{err:+.2f}%), window {lo}..{hi}")
    return status


if __name__ == "__main__":
    raise SystemExit(main())
