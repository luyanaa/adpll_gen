#!/usr/bin/env python3
"""Phase-sampling helpers for ISF generation.

The physical DCO is not a simple symmetric M-stage ring (coarse path select,
controlled mid/fine loads, mux, SS-BBPD and injection), so this module never
derives an ISF by assuming 2*pi/M symmetry.  It only chooses sampling points
and compares independently generated ISFs.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable

import numpy as np


def uniform_phases(nphase: int) -> np.ndarray:
    if nphase < 2:
        raise ValueError("nphase must be at least 2")
    return np.arange(nphase, dtype=float) / float(nphase)


def adaptive_phases(nphase: int, edge_window: float = 0.05,
                    edge_density: int = 2, budget: int | None = None,
                    edges: Iterable[float] = (0.0, 0.5)) -> np.ndarray:
    """Uniform baseline plus denser points around selected switching edges.

    The result is sorted, unique, and bounded by `budget` (or `nphase` by
    default).  The extra points do not replace the uniform baseline, so an
    adaptive run can be compared with the full baseline.
    """
    if nphase < 2 or edge_density < 1:
        raise ValueError("invalid nphase/edge_density")
    if edge_window <= 0 or edge_window >= 0.5:
        raise ValueError("edge_window must be in (0, 0.5)")
    limit = int(budget if budget is not None else 2 * nphase)
    if limit < nphase:
        raise ValueError("budget must be at least the uniform baseline")
    base = uniform_phases(nphase)
    extra = []
    for edge in edges:
        lo, hi = edge - edge_window, edge + edge_window
        count = max(1, int(round((hi - lo) * nphase * edge_density)))
        extra.extend(np.linspace(lo, hi, count, endpoint=True))
    merged = np.unique(np.concatenate([base, np.mod(np.asarray(extra), 1.0)]))
    if len(merged) > limit:
        # Keep endpoints and a uniform thinning; never silently drop the
        # baseline entirely.
        idx = np.linspace(0, len(merged) - 1, limit).round().astype(int)
        merged = np.unique(merged[idx])
    return merged


def normalize_isf(phases: np.ndarray, values: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    phases = np.asarray(phases, dtype=float)
    values = np.asarray(values, dtype=float)
    if phases.shape != values.shape or phases.ndim != 1:
        raise ValueError("phases and values must be 1-D and equal length")
    order = np.argsort(np.mod(phases, 1.0))
    return np.mod(phases[order], 1.0), values[order]


def interp_periodic(phases: np.ndarray, values: np.ndarray, grid: np.ndarray) -> np.ndarray:
    p, v = normalize_isf(phases, values)
    if p.size == 0:
        raise ValueError("empty ISF")
    return np.interp(grid, p, v, period=1.0)


def isf_error(reference: tuple[np.ndarray, np.ndarray],
              candidate: tuple[np.ndarray, np.ndarray],
              grid: np.ndarray | None = None) -> dict[str, float]:
    if grid is None:
        grid = uniform_phases(256)
    r = interp_periodic(reference[0], reference[1], grid)
    c = interp_periodic(candidate[0], candidate[1], grid)
    diff = c - r
    rms = float(np.sqrt(np.mean(diff ** 2)))
    rms_ref = float(np.sqrt(np.mean(r ** 2)))
    max_err = float(np.max(np.abs(diff)))
    # Integrated h^2 is proportional to the white phase-noise contribution.
    int_r = float(np.mean(r ** 2))
    int_c = float(np.mean(c ** 2))
    noise_err = abs(int_c - int_r) / int_r if int_r > 0 else float("inf")
    return {"rms": rms, "rms_relative": rms / rms_ref if rms_ref else float("inf"),
            "max": max_err, "integrated_power_relative": noise_err}


def may_reuse(reference, candidate, max_rms_relative: float = 0.05,
              max_integrated_relative: float = 0.05,
              grid: np.ndarray | None = None) -> tuple[bool, dict[str, float]]:
    err = isf_error(reference, candidate, grid)
    ok = (err["rms_relative"] <= max_rms_relative
          and err["integrated_power_relative"] <= max_integrated_relative)
    return ok, err
