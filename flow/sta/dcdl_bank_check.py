#!/usr/bin/env python3
"""Report per-bank DCDL sensitivity from dcdl_bank.sta.tcl.

Usage: dcdl_bank_check.py <bank.sta.log> [TT|SS|FF]
"""
from __future__ import annotations

import re
import sys


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: dcdl_bank_check.py <log> [TT|SS|FF]")
        return 2
    corner = sys.argv[2] if len(sys.argv) > 2 else "TT"
    text = open(sys.argv[1], encoding="utf-8").read()
    sections = re.findall(
        r"=== (ZERO|COARSE_MUX \d+|MID_MUX \d+|FINE_MUX \d+) ==="
        r"(.*?)(?==== |\Z)", text, re.DOTALL)
    delays: dict[str, float] = {}
    for tag, body in sections:
        hits = re.findall(r"([0-9.]+)\s+data arrival time", body)
        if hits:
            delays[tag] = max(float(h) for h in hits)
    if "ZERO" not in delays:
        print("FAIL: missing ZERO section")
        return 1
    base = delays["ZERO"]
    print(f"corner {corner}: baseline {base:.3f} ns")
    errors = 0
    for bank in ("COARSE_MUX", "MID_MUX", "FINE_MUX"):
        codes = sorted(
            (int(tag.split()[1]), tag)
            for tag in delays
            if tag.startswith(bank + " "))
        if not codes:
            print(f"FAIL: no {bank} codes")
            errors += 1
            continue
        vals = [(code, delays[tag] - base) for code, tag in codes]
        span = vals[-1][1]
        mono = all(vals[i][1] + 1e-4 >= vals[i-1][1]
                   for i in range(1, len(vals)))
        steps = [vals[i][1] - vals[i-1][1] for i in range(1, len(vals))]
        print(f"{bank}: span={span*1000.0:.1f} ps "
              f"monotonic={mono} steps_ps={[round(s*1000.0, 1) for s in steps]}")
        if span * 1000.0 < 10.0:
            print(f"FAIL: {bank} sensitivity below 10 ps")
            errors += 1
        if not mono:
            print(f"FAIL: {bank} is non-monotonic")
            errors += 1
    if errors:
        return 1
    print(f"PASS: {corner} all banks have measurable, monotonic sensitivity")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
