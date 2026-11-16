#!/usr/bin/env python3
"""Check the ics55 DCDL min/max range and a required period.

Usage: dcdl_range_check.py <sta.log> [TT|SS|FF] [period_ns]

The log is produced by dcdl_range.sta.tcl.  A valid measurement always exits
0; a period not covered is printed as BLOCKED because it is a real physical
range finding, not a parser failure.
"""
from __future__ import annotations

import re
import sys


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: dcdl_range_check.py <sta.log> [TT|SS|FF] [period_ns]")
        return 2
    corner = sys.argv[2] if len(sys.argv) > 2 else "TT"
    period = float(sys.argv[3]) if len(sys.argv) > 3 else 5.0
    text = open(sys.argv[1], encoding="utf-8").read()
    sections = re.findall(
        r"=== (MIN|MAX)[^=]*===(.*?)(?==== (?:MIN|MAX)|\Z)",
        text, re.DOTALL)
    delays: dict[str, float] = {}
    for name, body in sections:
        match = re.search(r"([0-9.]+)\s+data arrival time", body)
        if match:
            delays[name] = float(match.group(1))
    if set(delays) != {"MIN", "MAX"}:
        print(f"FAIL: missing min/max delays: {delays}")
        return 1
    lo, hi = delays["MIN"], delays["MAX"]
    print(f"corner {corner}: DCDL range {lo:.3f}-{hi:.3f} ns "
          f"(span {(hi-lo)*1000.0:.1f} ps)")
    if lo <= period <= hi:
        print(f"COVERAGE: {period:.3f} ns is inside the {corner} range")
    else:
        print(f"BLOCKED: {period:.3f} ns is outside the {corner} range")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
