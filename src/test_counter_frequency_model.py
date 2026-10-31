#!/usr/bin/env python3
"""Golden-model check for the counter/NCO output frequency.

The RTL toggles OUT once per accumulator carry.  This test compares that
edge-measured frequency against the independent formula
``f_tick * increment / 2**(acc_bits+1)`` for several control codes.
"""
from __future__ import annotations

import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ACC_BITS = 16
BASE_INC = 3493


def expected_mhz(coarse: int, mid: int, fine: int, tick_mhz: float = 1000.0) -> float:
    # COARSE/MID/FINE are thermometer/unary buses, not binary code values.
    inc = (BASE_INC - bin(coarse).count("1") * 120
           - bin(mid).count("1") * 60 - bin(fine).count("1") * 15)
    inc = max(1, min(2 ** ACC_BITS, inc))
    return tick_mhz * inc / float(2 ** (ACC_BITS + 1))


def main() -> int:
    with tempfile.TemporaryDirectory() as td:
        exe = Path(td) / "counter_tb"
        cmd = [
            "iverilog", "-g2012", "-DSIMULATION", "-o", str(exe),
            str(ROOT / "src" / "pll_counter_dco_phys.v"),
            str(ROOT / "src" / "sim_SSBBPD.v"),
            str(ROOT / "src" / "counter_dco_phys_tb.v"),
        ]
        subprocess.run(cmd, check=True)
        out = subprocess.run(["vvp", str(exe)], check=True,
                             text=True, capture_output=True).stdout
    rows = []
    for line in out.splitlines():
        m = re.search(
            r"COARSE=(\d+) MID=(\d+) FINE=(\d+) period_ns=([0-9.]+) freq_mhz=([0-9.]+)",
            line)
        if m:
            rows.append(tuple(int(m.group(i)) for i in (1, 2, 3))
                        + (float(m.group(4)), float(m.group(5))))
    if len(rows) != 4:
        print(out)
        raise SystemExit(f"expected 4 measurements, got {len(rows)}")

    # The testbench applies all-ones thermometer codes in this order.
    codes = [(0, 0, 0), (0x7fff, 0, 0), (0x7fff, 0x7fff, 0),
             (0x7fff, 0x7fff, 0x7fffffff)]
    for (coarse, mid, fine, period_ns, freq_mhz), (ec, em, ef) in zip(rows, codes):
        if (coarse, mid, fine) != (ec, em, ef):
            raise SystemExit(f"unexpected code order: {rows}")
        want = expected_mhz(ec, em, ef)
        rel = abs(freq_mhz - want) / want
        print(f"code=({ec},{em},{ef}) rtl={freq_mhz:.6f} "
              f"model={want:.6f} MHz relerr={rel:.3e}")
        if rel > 1e-3:
            raise SystemExit(
                "RTL frequency does not match the /2 carry-toggle model")
    print("test_counter_frequency_model: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
