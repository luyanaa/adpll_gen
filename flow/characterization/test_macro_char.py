#!/usr/bin/env python3
"""Unit and evidence checks for macro characterization.

The NCO periods are in ns; the frequency conversion must be 1000/period_ns,
not 1e6/period_ns.  The committed JSON is checked as well so a regenerated
report cannot silently reintroduce the 1000x error.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).parent))

from macro_char import nco_sequence  # noqa: E402


def main() -> int:
    seq = nco_sequence()
    assert seq["status"] == "OK", seq
    mean_ns = seq["period_mean_ns"]
    assert abs(seq["freq_mhz"] - 1000.0 / mean_ns) < 1e-9, seq
    assert 2.0 < seq["freq_mhz"] < 3.0, seq

    evidence = ROOT / "flow/characterization/macro_char/counter_nco.json"
    data = json.loads(evidence.read_text())
    rows = [r for r in data.get("rows", []) if r.get("pdk") == "gf180mcu"]
    assert rows, data
    row = rows[0]
    assert abs(row["freq_mhz"] - 1000.0 / row["period_mean_ns"]) < 1e-9, row
    assert abs(row["freq_mhz"] - 2.6639344262295084) < 1e-6, row
    print("test_macro_char: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
