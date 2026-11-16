#!/usr/bin/env python3
"""Check that the 4-segment bypass DCDL covers a requested delay window.

Usage: segmented_delay_check.py <sta.log> [TT|SS|FF] [--min=4.5] [--max=5.5]

Only the MIN (coarse=0/fine=0) and MAX (coarse=4/fine=55) endpoints are in
the STA log; the fine taps are a mux and are not individually time-verified
here.  Exit 2 when the window is not covered.
"""
from __future__ import annotations

import re
import sys


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if not args:
        print("usage: segmented_delay_check.py <sta.log> [corner] [--min=4.5] [--max=5.5]")
        return 2
    corner = args[1] if len(args) > 1 else "TT"
    lo_target, hi_target = 4.5, 5.5
    for arg in sys.argv:
        if arg.startswith("--min="):
            lo_target = float(arg.split("=", 1)[1])
        elif arg.startswith("--max="):
            hi_target = float(arg.split("=", 1)[1])

    text = open(args[0], encoding="utf-8").read()
    sections = re.findall(
        r"=== (MIN|MAX)[^\n]*===(.*?)(?==== (?:MIN|MAX)|\Z)",
        text, re.DOTALL)
    delays: dict[str, float] = {}
    for name, body in sections:
        match = re.search(r"([0-9.]+)\s+data arrival time", body)
        if match:
            delays[name] = float(match.group(1))
    if set(delays) != {"MIN", "MAX"}:
        print(f"FAIL: missing MIN/MAX delay in {args[0]}: {delays}")
        return 1
    lo, hi = delays["MIN"], delays["MAX"]
    print(f"corner {corner}: 4-seg DCDL {lo:.3f}-{hi:.3f} ns "
          f"(span {(hi-lo)*1000.0:.1f} ps)")
    if lo <= lo_target and hi >= hi_target:
        print(f"COVERAGE: {lo_target:.3f}-{hi_target:.3f} ns is inside "
              f"the {corner} range")
        return 0
    print(f"BLOCKED: {lo_target:.3f}-{hi_target:.3f} ns is outside "
          f"the {corner} range")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
