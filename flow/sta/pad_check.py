#!/usr/bin/env python3
"""Check the ics55 IO pad OpenSTA log and report duty/phase.

Usage: pad_check.py <sta.log> [TT|SS|FF]

The log is produced by ics55_ck_pad.sta.tcl with a 5 ns input period and a
2 pF load on each pad.  Duty is the single-ended CK_T/CK_C high fraction;
the differential crossing needs an SI/IBIS model and is not claimed here.
"""
from __future__ import annotations

import re
import sys


def main() -> int:
    if len(sys.argv) not in (2, 3):
        print("usage: pad_check.py <sta.log> [TT|SS|FF]")
        return 2
    corner = sys.argv[2] if len(sys.argv) == 3 else "TT"
    text = open(sys.argv[1], encoding="utf-8").read()

    def edges(inst: str) -> dict[str, float]:
        out: dict[str, float] = {}
        for match in re.finditer(
                rf"([0-9.]+)\s+[0-9.]+\s+([\^v])\s+u_pad\.{inst}/PAD", text):
            out[match.group(2)] = float(match.group(1))
        return out

    t = edges("u_t")
    c = edges("u_c")
    if set(t) != {"^", "v"} or set(c) != {"^", "v"}:
        print(f"FAIL: missing pad edges: CK_T={t} CK_C={c}")
        return 1
    period = 5.0
    high_t = period / 2.0 + (t["v"] - t["^"])
    high_c = period / 2.0 + (c["^"] - c["v"])
    duty_t = 100.0 * high_t / period
    duty_c = 100.0 * high_c / period
    print(f"corner {corner}")
    print(f"CK_T rise={t['^']:.3f} ns fall={t['v']:.3f} ns "
          f"single-ended duty={duty_t:.1f}%")
    print(f"CK_C rise={c['^']:.3f} ns fall={c['v']:.3f} ns "
          f"single-ended duty={duty_c:.1f}%")
    print(f"pad common crossing ~{(t['^'] + c['v']) / 2.0:.3f} ns")
    if not (45.0 <= duty_t <= 55.0 and 45.0 <= duty_c <= 55.0):
        print("FAIL: single-ended pad duty outside 45-55%")
        return 1
    print(f"PASS: {corner} pad duty inside 45-55% (single-ended)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
