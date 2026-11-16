#!/usr/bin/env python3
"""Check 4-segment DCDL monotonicity/continuity across coarse x 56 boundaries.

Usage: segmented_boundary_check.py <sta.log> [TT|SS|FF] [--max-step=300]

The STA log is produced by segmented_boundary.sta.tcl.  Every measured code
must be monotonic, and no adjacent code step may exceed --max-step ps.  The
boundary steps at codes 56/112/168/224 are reported separately; they are the
physical coarse-to-fine handoff and are not assumed to equal the fine step.
"""
from __future__ import annotations

import re
import sys


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if not args:
        print("usage: segmented_boundary_check.py <sta.log> [corner] [--max-step=300]")
        return 2
    corner = args[1] if len(args) > 1 else "TT"
    max_step = 300.0
    for arg in sys.argv:
        if arg.startswith("--max-step="):
            max_step = float(arg.split("=", 1)[1])

    text = open(args[0], encoding="utf-8").read()
    sections = re.findall(
        r"=== CODE (\d+) (\d+) (\d+) ===(.*?)(?==== CODE |\Z)",
        text, re.DOTALL)
    delays: dict[int, float] = {}
    for code, coarse, fine, body in sections:
        match = re.search(r"([0-9.]+)\s+data arrival time", body)
        if match:
            delays[int(code)] = float(match.group(1))
    if not delays:
        print(f"FAIL: no CODE sections in {args[0]}")
        return 1

    ordered = sorted(delays)
    errors = 0
    max_seen = 0.0
    for a, b in zip(ordered, ordered[1:]):
        step = (delays[b] - delays[a]) * 1000.0
        if step <= 0.0:
            print(f"FAIL: {corner} non-monotonic {a}->{b}: {step:.1f} ps")
            errors += 1
        # Only adjacent codes define a physical tap step; the test samples
        # 4-code windows around each boundary, so larger gaps are expected.
        if b - a == 1:
            if step > max_step:
                print(f"FAIL: {corner} step {a}->{b} is {step:.1f} ps "
                      f"(> {max_step:.0f} ps)")
                errors += 1
            max_seen = max(max_seen, step)

    print(f"corner {corner}: measured codes {ordered[0]}..{ordered[-1]}, "
          f"max adjacent step {max_seen:.1f} ps")
    for code in (56, 112, 168, 224):
        if code in delays and (code - 1) in delays:
            print(f"  boundary {code}: step "
                  f"{(delays[code]-delays[code-1])*1000.0:.1f} ps")
        else:
            print(f"FAIL: {corner} missing boundary pair {code-1}/{code}")
            errors += 1

    if errors:
        print(f"FAIL: {corner} 4-seg DCDL continuity check failed")
        return 1
    print(f"PASS: {corner} 4-seg DCDL is monotonic and step-bounded")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
