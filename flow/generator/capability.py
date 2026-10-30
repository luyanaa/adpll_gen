#!/usr/bin/env python3
"""Capability-driven frequency feasibility check for the ADPLL generator.

The generator must not treat an L1 behavioral DCO scan as a production
frequency/PVT/jitter signoff.  This module returns an explicit status:

  PASS_L1_EXPERIMENTAL  target is inside the characterized L1 range and a
                        candidate coarse/mid/fine code exists
  FAIL_OUT_OF_RANGE     target is outside the characterized L1 range
  FAIL_SYSTEM_FMAX      target/REF/FCW exceeds the per-PDK planning ceiling
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

try:  # package import
    from .system_limits import check_system, limits
except ImportError:  # direct script execution
    from system_limits import check_system, limits

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_MANIFESTS = {
    "ics55": ROOT / "flow" / "characterization" / "ics55_sim" / "dco_capability.json",
    "ihp-sg13g2": ROOT / "flow" / "characterization" / "ihp_l3" / "dco_capability_l3.json",
    "ics55-l3": ROOT / "flow" / "characterization" / "ics55_l3" / "dco_capability_l3.json",
    "ics55-l3-dense": ROOT / "flow" / "characterization" / "ics55_l3_dense" / "dco_capability_l3.json",
}


def load_manifest(pdk: str, path: Path | None = None) -> dict[str, Any]:
    p = path or DEFAULT_MANIFESTS.get(pdk)
    if p is None or not p.exists():
        raise FileNotFoundError(f"no capability manifest for {pdk}")
    return json.loads(p.read_text())


def _tuning_rows(pdk: str, manifest: dict[str, Any]) -> list[dict[str, Any]]:
    # The manifest can point at a sparse L3 table; otherwise use the L1 path.
    table = manifest.get("table")
    p = ROOT / table if table else ROOT / "flow" / "characterization" / f"{pdk}_sim" / "dco_tuning.csv"
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
    tolerance_mhz: float = 10.0,
    ref_mhz: float | None = None,
    fcw: int | None = None,
) -> dict[str, Any]:
    limit_hit = check_system(pdk, target_mhz, ref_mhz, fcw)
    if limit_hit:
        return limit_hit

    try:
        manifest = load_manifest(pdk)
    except FileNotFoundError:
        return {
            "status": "FAIL_UNCHARACTERIZED",
            "pdk": pdk,
            "target_mhz": target_mhz,
            "system_limits": limits(pdk),
            "reason": "no DCO capability manifest; digital ceiling is not DCO evidence",
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
    status = "PASS_L1_EXPERIMENTAL"
    reason = "L1 behavioral range/code check only; not PVT/PEX/jitter signoff"
    if level.startswith("L3"):
        status = "PASS_L3_SPARSE" if ("sparse" in level or "dense_axes" in level or not valid) else "PASS_L3"
        reason = ("Sparse/transistor-level range check; PEX/PVT/jitter signoff is "
                  "still required" if not valid else
                  "Transistor-level range/code check; PEX/PVT signoff still required")

    # Pick the closest measured point; return a few neighbours for a local
    # acquisition search.
    best = sorted(rows, key=lambda r: abs(r["freq_mhz"] - target_mhz))[:3]
    error = best[0]["freq_mhz"] - target_mhz
    if abs(error) > tolerance_mhz:
        return {
            "status": "FAIL_NO_CODE_WITHIN_TOLERANCE",
            "pdk": pdk,
            "target_mhz": target_mhz,
            "range_mhz": [fmin, fmax],
            "characterization_level": level,
            "candidates": best,
            "error_mhz": error,
            "tolerance_mhz": tolerance_mhz,
            "reason": "no measured code is close enough to the target",
        }
    return {
        "status": status,
        "pdk": pdk,
        "target_mhz": target_mhz,
        "range_mhz": [fmin, fmax],
        "characterization_level": level,
        "production_eligible": False,
        "candidates": best,
        "error_mhz": error,
        "tolerance_mhz": tolerance_mhz,
        "reason": reason,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdk", default="ics55")
    ap.add_argument("--target-mhz", type=float, required=True)
    ap.add_argument("--margin-mhz", type=float, default=0.0)
    ap.add_argument("--signoff", choices=["l1", "production"], default="l1")
    ap.add_argument("--ref-mhz", type=float)
    ap.add_argument("--fcw", type=int)
    ap.add_argument("--tolerance-mhz", type=float, default=10.0)
    args = ap.parse_args()
    result = check_target(args.pdk, args.target_mhz, args.margin_mhz, args.signoff,
                          args.tolerance_mhz, args.ref_mhz, args.fcw)
    print(json.dumps(result, indent=2))
    return 0 if result["status"] in ("PASS_L1_EXPERIMENTAL", "PASS_L3_SPARSE", "PASS_L3") else 1


if __name__ == "__main__":
    raise SystemExit(main())
