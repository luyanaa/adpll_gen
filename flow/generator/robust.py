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

This module intentionally never grants production eligibility.  It reports a
conservative frequency/PVT screen and the completeness of any caller-supplied
evidence flags for an external review.
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


def _adjacent(a: Point, b: Point) -> bool:
    """True only for a one-code step on exactly one tuning axis."""
    d = [b.coarse - a.coarse, b.mid - a.mid, b.fine - a.fine]
    return sum(x != 0 for x in d) == 1 and all(abs(x) <= 1 for x in d)


def feasible_runs(points: Iterable[Point], margin_mhz: float) -> list[tuple[float, float]]:
    """Return intervals that are connected in code space and monotone.

    Invalid/missing codes and non-adjacent code jumps break a run; a coarse
    or mid boundary never bridges two unrelated valid codes.
    """
    # Keep control-code order (not frequency order): a tuning curve is a
    # function of the code, and a local frequency rise is a tuning hole.
    pts = sorted((p for p in points if p.valid),
                 key=lambda p: (p.coarse, p.mid, p.fine))
    if len(pts) < 2:
        return []
    runs: list[list[Point]] = []
    current: list[Point] = [pts[0]]
    for p in pts[1:]:
        if not _adjacent(current[-1], p) or p.freq_mhz >= current[-1].freq_mhz:
            if len(current) >= 2:
                runs.append(current)
            current = [p]
        else:
            current.append(p)
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
                 margin_mhz: float = 10.0, require: int = 3,
                 jitter_verified: bool = False,
                 drc_lvs_verified: bool = False,
                 pex_verified: bool = False,
                 pvt_verified: bool = False,
                 lock_verified: bool = False,
                 sta_verified: bool = False,
                 injection_verified: bool = False,
                 evidence_key: str | None = None,
                 required_corners: tuple[str, ...] = ("TT", "SS", "FF")) -> dict:
    """Screen a frequency/PVT intersection; never self-grant production.

    This function is a frequency/PVT *screen*.  Even with a complete set of
    caller flags it returns ``PVT_FREQUENCY_SCREEN`` and never grants
    production eligibility; that decision belongs to the external evidence
    review that owns the PEX/PVT/lock/STA/DRC artifacts.
    """
    names = {k.upper(): k for k in corners}
    missing = [c for c in required_corners if c.upper() not in names]
    if len(corners) < require or missing:
        return {
            "status": "FAIL_UNCHARACTERIZED",
            "reason": f"need {require} PVT corners and required corners {required_corners}; "
                      f"missing {missing or 'corner count'}",
            "missing_corners": missing,
        }
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
    evidence = {
        "jitter_verified": bool(jitter_verified),
        "drc_lvs_verified": bool(drc_lvs_verified),
        "pex_verified": bool(pex_verified),
        "pvt_verified": bool(pvt_verified),
        "lock_verified": bool(lock_verified),
        "sta_verified": bool(sta_verified),
        "injection_verified": bool(injection_verified),
        "evidence_key": evidence_key,
    }
    complete = all(v for k, v in evidence.items() if k != "evidence_key")
    complete = complete and bool(evidence_key) and bool(required_corners)
    return {
        "status": "PVT_FREQUENCY_SCREEN",
        "robust_intervals": robust,
        "production_eligible": False,
        "evidence_complete": complete,
        "evidence": evidence,
        "reason": ("frequency/PVT screen only; this module never grants "
                   "production eligibility")
                  if complete else
                  ("frequency/PVT screen only; complete PEX/PVT/lock/STA/"
                   "jitter/DRC-LVS evidence is missing"),
    }
