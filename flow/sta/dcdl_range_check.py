#!/usr/bin/env python3
"""Check the ics55 DCDL min/max range and a required period.

Usage:
  dcdl_range_check.py <sta.log> [TT|SS|FF] [period_ns]
  dcdl_range_check.py <sta.log> --measure-only ...
  dcdl_range_check.py <sta.log> --require-coverage --period=5.0 --guardband=0.5

``--measure-only`` always exits 0 for a valid measurement.
``--require-coverage`` exits 2 when any corner does not cover the requested
period plus guardband.
"""
from __future__ import annotations

import re
import sys


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if not args:
        print("usage: dcdl_range_check.py <sta.log> [corner] [period] [options]")
        return 2
    measure_only = "--measure-only" in sys.argv
    require_coverage = "--require-coverage" in sys.argv
    corner = args[1] if len(args) > 1 else "TT"
    period = float(args[2]) if len(args) > 2 else 5.0
    guard = 0.5
    for arg in sys.argv:
        if arg.startswith("--period="):
            period = float(arg.split("=", 1)[1])
        elif arg.startswith("--guardband="):
            guard = float(arg.split("=", 1)[1])

    text = open(args[0], encoding="utf-8").read()
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
    covered = lo <= period - guard and hi >= period + guard
    if covered:
        print(f"COVERAGE: {period:.3f} +/- {guard:.3f} ns is inside "
              f"the {corner} range")
        return 0
    print(f"BLOCKED: {period:.3f} +/- {guard:.3f} ns is outside "
          f"the {corner} range")
    if require_coverage:
        print(f"FAIL: {corner} does not cover the required period")
        return 2
    if measure_only:
        return 0
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
