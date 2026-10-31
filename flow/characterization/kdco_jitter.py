#!/usr/bin/env python3
"""Extract KDCO and transient period-jitter metrics from measured data.

This tool is deliberately explicit about what it measures:
  * KDCO comes from adjacent tuning-table points, not from a model.
  * Period jitter comes from edge timestamps in a transient waveform.  It is
    not phase noise and does not include a calibrated device-noise source.
  * The NCO path has zero *random* jitter for an ideal TICK, but its carry
    intervals are quantized.  The report therefore separates deterministic
    period quantization from external TICK jitter and device noise.
"""
from __future__ import annotations

import argparse
import csv
import json
import math
import re
import statistics
import struct
from pathlib import Path


def tuning_rows(path: Path):
    rows = []
    with path.open() as fh:
        for r in csv.DictReader(fh):
            rows.append({
                "coarse": int(r["coarse_code"]),
                "mid": int(r["mid_code"]),
                "fine": int(r["fine_code"]),
                "freq_mhz": float(r["freq_mhz"]),
            })
    return rows


def kdco(rows):
    by = {(r["coarse"], r["mid"], r["fine"]): r["freq_mhz"] for r in rows}
    slopes = {"coarse": [], "mid": [], "fine": []}
    # Sparse tables jump by more than one code; normalize by the code delta.
    for axis, idx, other in (("coarse", 0, (1, 2)),
                             ("mid", 1, (0, 2)),
                             ("fine", 2, (0, 1))):
        groups = {}
        for key, freq in by.items():
            groups.setdefault((key[other[0]], key[other[1]]), []).append(
                (key[idx], freq))
        for vals in groups.values():
            vals.sort()
            for (ca, fa), (cb, fb) in zip(vals, vals[1:]):
                if cb != ca:
                    slopes[axis].append((fb - fa) / (cb - ca))
    out = {}
    for axis, vals in slopes.items():
        if not vals:
            out[axis] = {"count": 0, "note": "no adjacent pair"}
            continue
        vals_abs = sorted(vals)
        out[axis] = {
            "count": len(vals),
            "min_mhz_per_code": min(vals),
            "max_mhz_per_code": max(vals),
            "median_mhz_per_code": statistics.median(vals),
            "direction": "increasing" if statistics.median(vals) > 0 else "decreasing",
        }
    return out


def parse_raw(path: Path):
    b = path.read_bytes()
    marker = b"Binary:\n"
    i = b.index(marker) + len(marker)
    text = b[:i].decode("latin1")
    nv = int(re.search(r"No\. Variables:\s*(\d+)", text).group(1))
    np = int(re.search(r"No\. Points:\s*(\d+)", text).group(1))
    names = re.findall(r"^\s*\d+\s+(\S+)\s+", text, re.M)
    vals = struct.unpack("<%dd" % (nv * np), b[i:i + nv * np * 8])
    return [vals[k * nv] for k in range(np)], {
        name: [vals[k * nv + j] for k in range(np)]
        for j, name in enumerate(names)
    }


def period_jitter(path: Path):
    time, traces = parse_raw(path)
    key = next((k for k in traces if k.lower() in ("v(out)", "out")), None)
    if key is None:
        raise SystemExit(f"no OUT trace in {path}")
    wave = traces[key]
    edges = [time[k] for k in range(1, len(time))
             if wave[k - 1] < 0.6 <= wave[k]]
    if len(edges) < 3:
        raise SystemExit("fewer than three rising edges")
    edges = edges[max(1, int(len(edges) * 0.25)):]
    periods = [b - a for a, b in zip(edges, edges[1:])]
    mean = sum(periods) / len(periods)
    rms = math.sqrt(sum((p - mean) ** 2 for p in periods) / len(periods))
    return {
        "trace": key,
        "edges_used": len(edges),
        "periods_used": len(periods),
        "mean_period_ns": mean * 1e9,
        "freq_mhz": 1e-6 / mean,
        "period_jitter_pp_ns": (max(periods) - min(periods)) * 1e9,
        "period_jitter_rms_ns": rms * 1e9,
        "period_jitter_rms_ps": rms * 1e12,
        "note": "deterministic transient period spread; not random/phase noise",
    }


def counter(base_inc: int, coarse_step: int, mid_step: int, fine_step: int,
            acc_bits: int, tick_mhz: float):
    """Return the NCO model, including deterministic carry quantization.

    OUT toggles once per accumulator carry, so one output period is two
    carries:
        f_out = f_tick * increment / 2^(acc_bits + 1)
    The extra /2 is not a reporting convention; it is the RTL edge count.
    """
    modulus = 2 ** acc_bits
    scale = float(2 ** (acc_bits + 1))
    tick_period_ns = 1000.0 / tick_mhz

    def inc(c, m, f):
        return base_inc - c * coarse_step - m * mid_step - f * fine_step

    def freq(c, m, f):
        return tick_mhz * inc(c, m, f) / scale

    def deterministic_periods(inc_value: int):
        if inc_value <= 0:
            return {"valid": False, "reason": "increment must be positive"}
        phase = 0
        carries = []
        # One full phase-accumulator cycle is enough to enumerate the carry
        # pattern.  This is an ideal-TICK, event-level model, not SPICE.
        for tick in range(1, modulus + 1):
            phase += inc_value
            if phase >= modulus:
                phase -= modulus
                carries.append(tick)
        if len(carries) < 3:
            return {"valid": False, "reason": "fewer than three carries"}
        carry_intervals = [b - a for a, b in zip(carries, carries[1:])]
        # Rising OUT edges occur every second carry; use pairs of carry
        # intervals so the output period is measured edge-to-edge.
        rising = carries[0::2]
        periods = [b - a for a, b in zip(rising, rising[1:])]
        if not periods:
            return {"valid": False, "reason": "fewer than two output periods"}
        periods_ns = [p * tick_period_ns for p in periods]
        mean = sum(periods_ns) / len(periods_ns)
        rms = math.sqrt(sum((p - mean) ** 2 for p in periods_ns) / len(periods_ns))
        return {
            "valid": True,
            "carry_interval_ticks_min": min(carry_intervals),
            "carry_interval_ticks_max": max(carry_intervals),
            "carry_interval_ticks_mean": sum(carry_intervals) / len(carry_intervals),
            "carry_interval_quantization_pp_ns": (
                (max(carry_intervals) - min(carry_intervals)) * tick_period_ns),
            "output_period_ns_min": min(periods_ns),
            "output_period_ns_max": max(periods_ns),
            "output_period_mean_ns": mean,
            "period_jitter_pp_ns": max(periods_ns) - min(periods_ns),
            "period_jitter_rms_ps": rms * 1000.0,
            "periods_observed": len(periods_ns),
            "note": ("ideal-TICK deterministic accumulator quantization; "
                     "not random/phase noise"),
        }

    f0 = freq(0, 0, 0)
    f111 = freq(1, 1, 1)
    return {
        "base_inc": base_inc,
        "acc_bits": acc_bits,
        "tick_mhz": tick_mhz,
        "formula": "f_out = f_tick * increment / 2^(acc_bits+1)",
        "modulus_ticks": modulus,
        "frequency_mhz": {
            "code_000": f0,
            "code_111": f111,
            "mean_output_period_ns_code_000": 1000.0 / f0 if f0 > 0 else None,
        },
        "kdco_mhz_per_code": {
            "coarse": abs(tick_mhz * coarse_step / scale),
            "mid": abs(tick_mhz * mid_step / scale),
            "fine": abs(tick_mhz * fine_step / scale),
        },
        "deterministic_period_quantization": deterministic_periods(
            max(1, min(modulus, base_inc))),
        "external_tick_jitter": {
            "modeled": False,
            "note": "TICK jitter is a separate source; no source waveform is bound",
        },
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--tuning-csv", type=Path)
    ap.add_argument("--raw", type=Path)
    ap.add_argument("--counter", action="store_true")
    ap.add_argument("--base-inc", type=int, default=3493)
    ap.add_argument("--coarse-step", type=int, default=120)
    ap.add_argument("--mid-step", type=int, default=60)
    ap.add_argument("--fine-step", type=int, default=15)
    ap.add_argument("--acc-bits", type=int, default=16)
    ap.add_argument("--tick-mhz", type=float, default=100.0,
                    help="external TICK frequency; default matches physical counter STA")
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()
    result = {"schema_version": 1, "inputs": {}, "limitations": [
        "KDCO is local adjacent-code data, not a smooth model.",
        "Transient period spread is not random jitter or phase noise.",
        "No pnoise/device-noise run is claimed by this report.",
    ]}
    if args.tuning_csv:
        rows = tuning_rows(args.tuning_csv)
        result["inputs"]["tuning_csv"] = str(args.tuning_csv)
        result["points"] = len(rows)
        result["kdco"] = kdco(rows)
        result["frequency_mhz"] = {
            "min": min(r["freq_mhz"] for r in rows),
            "max": max(r["freq_mhz"] for r in rows),
        }
    if args.raw:
        result["inputs"]["raw"] = str(args.raw)
        result["jitter"] = period_jitter(args.raw)
    if args.counter:
        result["counter"] = counter(args.base_inc, args.coarse_step,
                                    args.mid_step, args.fine_step,
                                    args.acc_bits, args.tick_mhz)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2)[:4000])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
