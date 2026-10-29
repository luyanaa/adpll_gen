#!/usr/bin/env python3
"""Capability-driven frequency feasibility check for the ADPLL generator.

The generator must not treat an L1 behavioral DCO scan as a production
frequency/PVT/jitter signoff.  This module returns an explicit status:

  PASS_L1_EXPERIMENTAL  target is inside the characterized L1 range and a
                        candidate coarse/mid/fine code exists
  FAIL_OUT_OF_RANGE     target is outside the characterized L1 range
  FAIL_UNCHARACTERIZED  no L1/L3 manifest, or the requested signoff level is
                        production/PVT/PEX

The candidate code is selected from the measured (L1) table; it is not a
claim that the closed-loop PLL will lock at that frequency.
"""
from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_MANIFESTS = {
    "ics55": ROOT / "flow" / "characterization" / "ics55_sim" / "dco_capability.json",
}


def load_manifest(pdk: str, path: Path | None = None) -> dict[str, Any]:
    p = path or DEFAULT_MANIFESTS.get(pdk)
    if p is None or not p.exists():
        raise FileNotFoundError(f"no capability manifest for {pdk}")
    return json.loads(p.read_text())


def _tuning_rows(pdk: str, manifest: dict[str, Any]) -> list[dict[str, Any]]:
    # The current schema stores the measured table next to the manifest.
    p = ROOT / "flow" / "characterization" / f"{pdk}_sim" / "dco_tuning.csv"
    if not p.exists():
        return []
    rows = []
    with p.open() as f:
        for r in csv.DictReader(f):
            rows.append({
                "coarse": int(r["coarse_code"]),
                "mid": int(r["mid_code"]),
                "fine": int(r["fine_code"]),
                "freq_mhz": float(r["freq_mhz"]),
            })
    return rows


def check_target(
    pdk: str,
    target_mhz: float,
    margin_mhz: float = 0.0,
    signoff: str = "l1",
) -> dict[str, Any]:
    try:
        manifest = load_manifest(pdk)
    except FileNotFoundError:
        return {
            "status": "FAIL_UNCHARACTERIZED",
            "pdk": pdk,
            "target_mhz": target_mhz,
            "reason": "no capability manifest",
        }

    level = manifest.get("characterization_level")
    fmin = manifest["frequency_mhz"]["min"]
    fmax = manifest["frequency_mhz"]["max"]

    if signoff == "production" and level != "L3_PEX_PVT":
        return {
            "status": "FAIL_UNCHARACTERIZED",
            "pdk": pdk,
            "target_mhz": target_mhz,
            "reason": "production signoff requires L3/PEX/PVT; current level is "
                      f"{level}",
        }

    if target_mhz < fmin + margin_mhz or target_mhz > fmax - margin_mhz:
        return {
            "status": "FAIL_OUT_OF_RANGE",
            "pdk": pdk,
            "target_mhz": target_mhz,
            "range_mhz": [fmin, fmax],
            "reason": "target is outside the characterized L1 range",
        }

    rows = _tuning_rows(pdk, manifest)
    if not rows:
        return {
            "status": "FAIL_UNCHARACTERIZED",
            "pdk": pdk,
            "target_mhz": target_mhz,
            "reason": "manifest exists but tuning table is missing",
        }

    valid = manifest.get("valid_codes", {}).get("all_scanned_codes_valid", False)
    if not valid:
        return {
            "status": "FAIL_UNCHARACTERIZED",
            "pdk": pdk,
            "target_mhz": target_mhz,
            "reason": "tuning table contains non-monotonic/invalid codes",
        }

    # Pick the closest measured point; return a few neighbours for a local
    # acquisition search.
    best = sorted(rows, key=lambda r: abs(r["freq_mhz"] - target_mhz))[:3]
    return {
        "status": "PASS_L1_EXPERIMENTAL",
        "pdk": pdk,
        "target_mhz": target_mhz,
        "range_mhz": [fmin, fmax],
        "characterization_level": level,
        "production_eligible": False,
        "candidates": best,
        "error_mhz": best[0]["freq_mhz"] - target_mhz,
        "reason": "L1 behavioral range/code check only; not PVT/PEX/jitter signoff",
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdk", default="ics55")
    ap.add_argument("--target-mhz", type=float, required=True)
    ap.add_argument("--margin-mhz", type=float, default=0.0)
    ap.add_argument("--signoff", choices=["l1", "production"], default="l1")
    args = ap.parse_args()
    result = check_target(args.pdk, args.target_mhz, args.margin_mhz, args.signoff)
    print(json.dumps(result, indent=2))
    return 0 if result["status"] == "PASS_L1_EXPERIMENTAL" else 1


if __name__ == "__main__":
    raise SystemExit(main())
