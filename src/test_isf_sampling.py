#!/usr/bin/env python3
import sys
from pathlib import Path
import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from isf_sampling import adaptive_phases, uniform_phases, may_reuse


def edge_isf(phases):
    phases = np.asarray(phases)
    # Sharp edge near 0 and a smaller feature near 0.5.
    return np.exp(-((phases - 0.0) / 0.02) ** 2) + 0.5 * np.exp(-((phases - 0.5) / 0.04) ** 2)


def main():
    u = uniform_phases(128)
    a = adaptive_phases(128, edge_window=0.04, edge_density=2)
    assert len(u) == 128
    assert 128 <= len(a) <= 256
    # Budgeted adaptive sampling must still retain edge-dense points.
    b = adaptive_phases(128, edge_window=0.04, edge_density=2, budget=192)
    assert len(b) <= 192
    near_edge = np.sum(np.minimum(np.abs(b - 0.0), np.abs(b - 1.0)) < 0.04)
    near_center = np.sum(np.abs(b - 0.5) < 0.04)
    assert near_edge > 1 and near_center > 1
    ref = (u, edge_isf(u))
    same = (u, edge_isf(u) * (1.0 + 0.01 * np.sin(2 * np.pi * u)))
    ok, err = may_reuse(ref, same, max_rms_relative=0.10, max_integrated_relative=0.10)
    assert ok, err
    bad = (u, np.sin(2 * np.pi * u) * 10)
    ok, err = may_reuse(ref, bad, max_rms_relative=0.05, max_integrated_relative=0.05)
    assert not ok, err
    print("test_isf_sampling: PASS")


if __name__ == "__main__":
    main()
