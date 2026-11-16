#!/usr/bin/env python3
"""Check the OpenSTA tap-step log and report the physical tap step.

Usage: tap_step_check.py <sta.log>
The log is produced by dcdl_tap_step.sta.tcl.  A pass requires every TAP
arrival to be present and the average step to be in a plausible ics55 fine-cell
range.  This is a structural/TT check, not a PVT characterization.
"""
from __future__ import annotations

import re
import sys


def main() -> int:
    if len(sys.argv) not in (2, 3):
        print("usage: tap_step_check.py <sta.log> [TT|SS|FF]")
        return 2
    corner = sys.argv[2] if len(sys.argv) == 3 else "TT"
    ranges = {"TT": (20.0, 50.0), "SS": (45.0, 80.0), "FF": (15.0, 35.0)}
    if corner not in ranges:
        print(f"FAIL: unknown corner {corner}")
        return 2
    text = open(sys.argv[1], encoding="utf-8").read()
    arrivals: dict[int, float] = {}
    for match in re.finditer(
            r"=== TAP(\d+) ===.*?([0-9.]+)\s+data arrival time", text,
            re.DOTALL):
        arrivals[int(match.group(1))] = float(match.group(2))
    missing = [g for g in range(16) if g not in arrivals]
    if missing:
        print(f"FAIL: missing tap arrivals {missing}")
        return 1
    base = arrivals[0]
    steps = [(arrivals[g] - base) / g for g in range(1, 16)]
    avg = (arrivals[15] - base) / 15.0
    print(f"corner {corner}")
    print("tap  arrival_ns  delay_ps")
    for g in range(16):
        print(f"{g:3d}  {arrivals[g]:9.4f}  {(arrivals[g]-base)*1000.0:8.1f}")
    print(f"average step = {avg*1000.0:.1f} ps "
          f"(min {min(steps)*1000.0:.1f}, max {max(steps)*1000.0:.1f})")
    lo, hi = ranges[corner]
    if not lo <= avg * 1000.0 <= hi:
        print(f"FAIL: average tap step outside {lo:.0f}-{hi:.0f} ps at {corner}")
        return 1
    print(f"PASS: {corner} tap step measured from real cells")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
