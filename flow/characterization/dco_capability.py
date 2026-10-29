#!/usr/bin/env python3
"""Build the L1 DCO capability manifest from dco_tuning.csv.

This validates the full 16 x 16 x 32 behavioral grid and records monotonicity,
frequency coverage and per-code KDCO.  It intentionally labels the result as
L1 behavioral, not PVT/PEX signoff.
"""
from __future__ import annotations

import argparse
import csv
import json
import statistics
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", default=str(ROOT / "flow" / "characterization" / "ics55_sim"))
    args = ap.parse_args()
    indir = Path(args.input)
    rows = []
    with (indir / "dco_tuning.csv").open() as f:
        for r in csv.DictReader(f):
            rows.append({
                "coarse": int(r["coarse_code"]),
                "mid": int(r["mid_code"]),
                "fine": int(r["fine_code"]),
                "period_fs": int(r["period_fs"]),
                "freq_mhz": float(r["freq_mhz"]),
            })

    if not rows:
        raise SystemExit("empty tuning table")

    coarse = sorted({r["coarse"] for r in rows})
    mid = sorted({r["mid"] for r in rows})
    fine = sorted({r["fine"] for r in rows})
    expected = len(coarse) * len(mid) * len(fine)
    if len(rows) != expected:
        raise SystemExit(f"grid mismatch: {len(rows)} points, expected {expected}")

    def by(c, m, f=None):
        return [r for r in rows if r["coarse"] == c and r["mid"] == m
                and (f is None or r["fine"] == f)]

    # For every sweep, frequency must be non-increasing as the code increases.
    fine_inv = []
    for c in coarse:
        for m in mid:
            s = sorted(by(c, m), key=lambda r: r["fine"])
            for a, b in zip(s, s[1:]):
                if a["freq_mhz"] < b["freq_mhz"] - 1e-9:
                    fine_inv.append([c, m, a["fine"], b["fine"]])

    coarse_inv = []
    for m in mid:
        for f in fine:
            s = sorted([r for r in rows if r["mid"] == m and r["fine"] == f],
                       key=lambda r: r["coarse"])
            for a, b in zip(s, s[1:]):
                if a["freq_mhz"] < b["freq_mhz"] - 1e-9:
                    coarse_inv.append([m, f, a["coarse"], b["coarse"]])

    mid_inv = []
    for c in coarse:
        for f in fine:
            s = sorted([r for r in rows if r["coarse"] == c and r["fine"] == f],
                       key=lambda r: r["mid"])
            for a, b in zip(s, s[1:]):
                if a["freq_mhz"] < b["freq_mhz"] - 1e-9:
                    mid_inv.append([c, f, a["mid"], b["mid"]])

    fine_delta = []
    for c in coarse:
        for m in mid:
            s = sorted(by(c, m), key=lambda r: r["fine"])
            fine_delta += [a["freq_mhz"] - b["freq_mhz"] for a, b in zip(s, s[1:])]

    mid_delta = []
    for c in coarse:
        for f in fine:
            s = sorted([r for r in rows if r["coarse"] == c and r["fine"] == f],
                       key=lambda r: r["mid"])
            mid_delta += [a["freq_mhz"] - b["freq_mhz"] for a, b in zip(s, s[1:])]

    coarse_delta = []
    for m in mid:
        for f in fine:
            s = sorted([r for r in rows if r["mid"] == m and r["fine"] == f],
                       key=lambda r: r["coarse"])
            coarse_delta += [a["freq_mhz"] - b["freq_mhz"] for a, b in zip(s, s[1:])]

    def stats(v):
        return {
            "min_mhz_per_code": min(v),
            "max_mhz_per_code": max(v),
            "median_mhz_per_code": statistics.median(v),
        }

    manifest = {
        "technology": "ics55",
        "library": "ics55_LLSC_H7CR",
        "model": "L1 behavioral sim_dco",
        "source": "src/sim_dco.v",
        "characterization_level": "L1_behavioral",
        "points": len(rows),
        "grid": {
            "coarse": [min(coarse), max(coarse)],
            "mid": [min(mid), max(mid)],
            "fine": [min(fine), max(fine)],
        },
        "frequency_mhz": {
            "min": min(r["freq_mhz"] for r in rows),
            "max": max(r["freq_mhz"] for r in rows),
        },
        "monotonic": {
            "fine_non_increasing": len(fine_inv) == 0,
            "mid_non_increasing": len(mid_inv) == 0,
            "coarse_non_increasing": len(coarse_inv) == 0,
            "fine_inversions": fine_inv[:20],
            "mid_inversions": mid_inv[:20],
            "coarse_inversions": coarse_inv[:20],
        },
        "kdco": {
            "fine": stats(fine_delta),
            "mid": stats(mid_delta),
            "coarse": stats(coarse_delta),
        },
        "valid_codes": {
            "all_scanned_codes_valid": not (fine_inv or mid_inv or coarse_inv),
            "coarse": [min(coarse), max(coarse)],
            "mid": [min(mid), max(mid)],
            "fine": [min(fine), max(fine)],
        },
        "verification": {
            "frequency_verified": "L1_behavioral_only",
            "pvt_verified": False,
            "pex_verified": False,
            "jitter_verified": False,
        },
        "notes": (
            "Full 16x16x32 behavioral grid. Codes are thermometer-coded; "
            "increasing code increases delay and lowers frequency. Not a "
            "PVT/PEX/jitter signoff."
        ),
    }

    (indir / "dco_capability.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"wrote {indir / 'dco_capability.json'}")
    print(f"valid={manifest['valid_codes']['all_scanned_codes_valid']} "
          f"range={manifest['frequency_mhz']['min']:.3f}..{manifest['frequency_mhz']['max']:.3f} MHz")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
