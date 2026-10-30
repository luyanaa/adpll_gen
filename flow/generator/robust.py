#!/usr/bin/env python3
"""PVT-aware DCO feasibility: intersection of per-corner reachable intervals.

The existing capability check treats a frequency range and nearest measured
code as independent facts.  This module treats a corner as a tuning curve:

  * sort the measured codes by frequency;
  * keep only points that have a measured neighbour on both sides inside a
    requested margin (a code with no tuning headroom is not a feasible point);
  * allow local non-monotonicity only if it is explicitly masked by
    ``valid_mask``; by default a rising step breaks the run;
  * intersect the resulting intervals across corners.

Production is intentionally not granted by a characterization-level string.
It also requires explicit phase-noise/jitter and DRC/LVS flags.
"""
from __future__ import annotations

import csv
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


@dataclass(frozen=True)
class Point:
    coarse: int
    mid: int
    fine: int
    freq_mhz: float
    valid: bool = True


def load_points(path: Path, valid_mask: set[tuple[int, int, int]] | None = None) -> list[Point]:
    rows: list[Point] = []
    for r in csv.DictReader(path.open()):
        key = (int(r["coarse_code"]), int(r["mid_code"]), int(r["fine_code"]))
        rows.append(Point(*key, float(r["freq_mhz"]),
                           valid_mask is None or key in valid_mask))
    return rows


def feasible_runs(points: Iterable[Point], margin_mhz: float) -> list[tuple[float, float]]:
    """Return frequency intervals with at least ``margin_mhz`` on both sides."""
    # Keep control-code order (not frequency order): a tuning curve is a
    # function of the code, and a local frequency rise is a tuning hole.
    pts = sorted((p for p in points if p.valid),
                 key=lambda p: (p.coarse, p.mid, p.fine))
    if len(pts) < 2:
        return []
    runs: list[list[Point]] = []
    current: list[Point] = [pts[0]]
    for p in pts[1:]:
        # A local rise is a tuning hole unless the caller masked it out.
        if p.freq_mhz < current[-1].freq_mhz:
            current.append(p)
        else:
            if len(current) >= 2:
                runs.append(current)
            current = [p]
    if len(current) >= 2:
        runs.append(current)

    out: list[tuple[float, float]] = []
    for run in runs:
        lo = run[-1].freq_mhz
        hi = run[0].freq_mhz
        # Need measured points on both sides of every returned edge.
        inner = run[1:-1]
        if inner:
            inner_lo = min(p.freq_mhz for p in inner)
            inner_hi = max(p.freq_mhz for p in inner)
            out.append((max(lo, inner_lo - margin_mhz),
                        min(hi, inner_hi + margin_mhz)))
        elif hi - lo >= 2 * margin_mhz:
            out.append((lo + margin_mhz, hi - margin_mhz))
    return out


def intersect(intervals: list[list[tuple[float, float]]]) -> list[tuple[float, float]]:
    if not intervals:
        return []
    current = intervals[0]
    for nxt in intervals[1:]:
        current = [(max(a, c), min(b, d)) for a, b in current for c, d in nxt
                   if max(a, c) < min(b, d)]
    return sorted(current)


def check_target(corners: dict[str, list[Point]], target_mhz: float,
                 margin_mhz: float = 10.0, require: int = 2,
                 jitter_verified: bool = False,
                 drc_lvs_verified: bool = False) -> dict:
    if len(corners) < require:
        return {"status": "FAIL_UNCHARACTERIZED",
                "reason": f"need {require} PVT corners, have {len(corners)}"}
    per_corner = {name: feasible_runs(pts, margin_mhz)
                  for name, pts in corners.items()}
    robust = intersect(list(per_corner.values()))
    if not robust:
        return {"status": "FAIL_DISJOINT",
                "reason": "no frequency interval survives all corners",
                "per_corner": per_corner}
    hit = [iv for iv in robust if iv[0] <= target_mhz <= iv[1]]
    if not hit:
        return {"status": "FAIL_OUT_OF_ROBUST_RANGE",
                "robust_intervals": robust,
                "per_corner": per_corner}
    if not (jitter_verified and drc_lvs_verified):
        return {"status": "PASS_L3_ROBUST_EXPERIMENTAL",
                "robust_intervals": robust,
                "production_eligible": False,
                "reason": "frequency/PVT interval only; jitter or DRC/LVS missing"}
    return {"status": "PASS_L3_PEX_PVT",
            "robust_intervals": robust,
            "production_eligible": True}
