#!/usr/bin/env python3
"""Validate measured DCO tuning maps and compute KDCO/PVT spread.

This tool consumes measured data.  It never fills missing codes or invents a
PVT corner.  A map is suitable for a SAR/binary-search gate only when it is
monotonic, covers all requested codes, and its declared corners are present.
"""
from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
from typing import Any


class TuningError(ValueError):
    """Measured map is malformed or not usable."""


def load_maps(path: Path) -> list[dict[str, Any]]:
    data = json.loads(path.read_text())
    maps = data.get("maps", [data]) if isinstance(data, dict) else data
    if not isinstance(maps, list) or not maps:
        raise TuningError("input must contain a map or a non-empty maps list")
    return maps


def _check_branch(name: str, rows: list[dict[str, Any]], expected: int,
                  direction: int | None) -> tuple[int, list[dict[str, Any]]]:
    if len(rows) != expected:
        raise TuningError(f"{name}: expected {expected} codes, got {len(rows)}")
    by_code = sorted(rows, key=lambda r: int(r["code"]))
    codes = [int(r["code"]) for r in by_code]
    if codes != list(range(expected)):
        raise TuningError(f"{name}: missing/duplicate codes: {codes}")
    freqs = [float(r["frequency_mhz"]) for r in by_code]
    if any(f <= 0 for f in freqs):
        raise TuningError(f"{name}: non-positive frequency")
    diffs = [b - a for a, b in zip(freqs, freqs[1:])]
    signs = {1 if d > 0 else -1 if d < 0 else 0 for d in diffs}
    if 0 in signs:
        raise TuningError(f"{name}: duplicate frequency at a code step")
    if len(signs) != 1:
        raise TuningError(f"{name}: nonmonotonic frequency map")
    got = signs.pop()
    if direction is None:
        direction = got
    elif direction != got:
        raise TuningError(f"{name}: direction changes across map")
    out = []
    for i, row in enumerate(by_code):
        r = dict(row)
        if i == 0:
            slope = freqs[1] - freqs[0]
        elif i == len(freqs) - 1:
            slope = freqs[-1] - freqs[-2]
        else:
            slope = (freqs[i + 1] - freqs[i - 1]) / 2.0
        r["kdco_mhz_per_code"] = round(slope, 9)
        r["step_mhz"] = None if i == 0 else round(freqs[i] - freqs[i - 1], 9)
        out.append(r)
    return direction, out


def analyze_map(m: dict[str, Any], expected: int = 16) -> dict[str, Any]:
    for key in ("pdk", "process", "temperature_c", "voltage_v"):
        if key not in m:
            raise TuningError(f"missing {key}")
    direction, coarse = _check_branch("coarse", m.get("coarse", []), expected, None)
    _, mid = _check_branch("mid", m.get("mid", []), expected, direction)
    c_freq = [float(r["frequency_mhz"]) for r in coarse]
    m_freq = [float(r["frequency_mhz"]) for r in mid]
    c_lo, c_hi = min(c_freq), max(c_freq)
    m_lo, m_hi = min(m_freq), max(m_freq)
    overlap = max(c_lo, m_lo) <= min(c_hi, m_hi)
    steps_c = [r["step_mhz"] for r in coarse if r["step_mhz"] is not None]
    steps_m = [r["step_mhz"] for r in mid if r["step_mhz"] is not None]
    kdco_c = [r["kdco_mhz_per_code"] for r in coarse]
    kdco_m = [r["kdco_mhz_per_code"] for r in mid]
    return {
        "pdk": m["pdk"],
        "process": m["process"],
        "temperature_c": float(m["temperature_c"]),
        "voltage_v": float(m["voltage_v"]),
        "direction": "increasing" if direction > 0 else "decreasing",
        "coarse": coarse,
        "mid": mid,
        "overlap": overlap,
        "ranges_mhz": {"coarse": [c_lo, c_hi], "mid": [m_lo, m_hi]},
        "step_mhz": {"coarse_min": min(steps_c), "coarse_max": max(steps_c),
                     "mid_min": min(steps_m), "mid_max": max(steps_m)},
        "kdco_mhz_per_code": {"coarse_min": min(kdco_c), "coarse_max": max(kdco_c),
                              "mid_min": min(kdco_m), "mid_max": max(kdco_m)},
        "monotonic": True,
        "valid_for_sar": bool(overlap),
    }


def pvt_summary(analyses: list[dict[str, Any]]) -> dict[str, Any]:
    if not analyses:
        return {}
    corners = sorted({f"{a['process']}/{a['temperature_c']:g}C/{a['voltage_v']:g}V"
                      for a in analyses})
    f_by_corner = {}
    for a in analyses:
        key = f"{a['process']}/{a['temperature_c']:g}C/{a['voltage_v']:g}V"
        f_by_corner[key] = {
            "min_mhz": min(a["ranges_mhz"]["coarse"][0], a["ranges_mhz"]["mid"][0]),
            "max_mhz": max(a["ranges_mhz"]["coarse"][1], a["ranges_mhz"]["mid"][1]),
        }
    ks = [a["kdco_mhz_per_code"]["coarse_max"] for a in analyses]
    return {
        "corners": corners,
        "corner_ranges_mhz": f_by_corner,
        "kdco_mhz_per_code_spread": {
            "min": min(ks), "max": max(ks),
            "spread_pct": (max(ks) - min(ks)) / abs(min(ks)) * 100.0 if min(ks) else math.inf,
        },
    }


def main() -> int:
    ap = argparse.ArgumentParser(description="Validate measured DCO tuning/KDCO maps")
    ap.add_argument("--input", type=Path, required=True)
    ap.add_argument("--codes", type=int, default=16)
    ap.add_argument("--require-corners", nargs="*", default=[])
    ap.add_argument("--json-out", type=Path)
    ap.add_argument("--md-out", type=Path)
    ap.add_argument("--allow-invalid", action="store_true")
    args = ap.parse_args()
    maps = load_maps(args.input)
    analyses = []
    errors = []
    for i, m in enumerate(maps):
        try:
            a = analyze_map(m, args.codes)
        except TuningError as exc:
            errors.append(f"map[{i}]: {exc}")
            continue
        if args.require_corners:
            present = {f"{a['process']}/{a['temperature_c']:g}C/{a['voltage_v']:g}V"}
            missing = [c for c in args.require_corners if c not in present]
            if missing:
                errors.append(f"map[{i}]: missing required corners {missing}")
        analyses.append(a)
    result = {
        "schema_version": 1,
        "input": str(args.input),
        "maps": analyses,
        "errors": errors,
        "pvt": pvt_summary(analyses),
        "valid_for_sar": not errors and all(a["valid_for_sar"] for a in analyses),
        "note": "Consumes measured data only; no missing corner is synthesized.",
    }
    if args.json_out:
        args.json_out.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    lines = ["# DCO tuning / KDCO report", "",
             f"- valid_for_sar: **{result['valid_for_sar']}**",
             f"- maps: {len(analyses)}", f"- errors: {len(errors)}", ""]
    if errors:
        lines += ["## Errors", ""] + [f"- {e}" for e in errors] + [""]
    for a in analyses:
        lines += [f"## {a['pdk']} {a['process']} {a['temperature_c']:g}C {a['voltage_v']:g}V", "",
                  f"- direction: {a['direction']}",
                  f"- range: {a['ranges_mhz']}",
                  f"- overlap: {a['overlap']}",
                  f"- KDCO: {a['kdco_mhz_per_code']}", ""]
    if args.md_out:
        args.md_out.write_text("\n".join(lines) + "\n")
    print(json.dumps({"valid_for_sar": result["valid_for_sar"], "errors": errors}, indent=2))
    return 0 if result["valid_for_sar"] or args.allow_invalid else 1


if __name__ == "__main__":
    raise SystemExit(main())
