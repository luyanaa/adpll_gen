#!/usr/bin/env python3
"""Report the physical TDC delay-line span/resolution from OpenSTA."""
import re
import sys

def main() -> int:
    if len(sys.argv) < 2:
        print("usage: tdc_line_check.py <sta.log> [corner]")
        return 2
    corner = sys.argv[2] if len(sys.argv) > 2 else "TT"
    text = open(sys.argv[1], encoding="utf-8").read()
    sections = re.findall(r"=== LINE (MIN|MAX) ===(.*?)(?==== LINE|\Z)",
                          text, re.DOTALL)
    d = {}
    for name, body in sections:
        m = re.search(r"([0-9.]+)\s+data arrival time", body)
        if m:
            d[name] = float(m.group(1))
    if set(d) != {"MIN", "MAX"}:
        print(f"FAIL: missing TDC line min/max: {d}")
        return 1
    lo, hi = d["MIN"], d["MAX"]
    print(f"corner {corner}: TDC line {lo:.3f}-{hi:.3f} ns, "
          f"tap step {lo/320*1000.0:.1f}-{hi/320*1000.0:.1f} ps")
    if hi < 5.0:
        print(f"FAIL: {corner} TDC line max {hi:.3f} ns does not reach 5 ns")
        return 1
    print(f"PASS: {corner} TDC line covers a 5 ns phase")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
