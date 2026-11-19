#!/usr/bin/env python3
"""Deterministic period jitter and low-frequency drift from a transient.

What this measures, and what it does NOT
----------------------------------------
This runs a noiseless transient and analyses the ZERO-CROSSING TIME SERIES of
the oscillator output.  That gives:

  * period jitter (cycle-to-cycle and period-to-period) caused by real effects
    that exist without device noise -- settling of the bias node, start-up
    transient, supply coupling through a real PDN, code-dependent delay
    modulation;
  * low-frequency drift: the trend of the instantaneous period, which is what
    an integrating loop actually has to track;
  * a spectrum of the period sequence (period-domain PSD), which exposes
    deterministic tones such as a bias-loop oscillation.

It does NOT give random jitter or phase noise.  The transient is noiseless, so
there is no device noise to integrate; any jitter reported here is
deterministic.  See `src/isf_phase_noise.py` for the ISF-based estimate, which
is the only path in this repo that can produce a random-jitter number, and read
its header before quoting one.  (An earlier revision of this header pointed at
`phase_noise.py`, which does not exist.)

Why zero crossings and not FFT on the waveform
----------------------------------------------
A ring DCO output is a large-signal square wave; its FFT is dominated by the
harmonics, and the few-ps jitter sits far below the spectrum bin resolution of
a transient this short.  The zero-crossing (or threshold-crossing) series is a
direct time-domain measurement of when each edge actually arrived, and it has
no resolution limit beyond the simulator's time step.  That is why every real
jitter bench interpolates crossings rather than transforming the waveform.

Interpolation
-------------
Crossing times are linearly interpolated between the two samples that bracket
the threshold.  With a 0.5-1 ps print step on a 100 ns period that is well
below the jitter being measured; the interpolation error is reported so it can
be compared with the result.

Usage
-----
    python3 flow/characterization/jitter_zerocross.py --pdk ihp \\
        --corner tt --code 8 --stop-ns 400

    # use an existing raw file instead of running ngspice
    python3 flow/characterization/jitter_zerocross.py --raw jitter.raw \\
        --node v(out)
"""
from __future__ import annotations

import argparse
import json
import math
import re
import struct
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
IHP = Path("/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
           "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2")
IHP_RING = ROOT / "flow" / "macro" / "ring_dco_ihp130"


# ---------------------------------------------------------------------------
# ngspice raw reader (ASCII or binary, ngspice-44 layout)
# ---------------------------------------------------------------------------
def read_raw(path: Path) -> tuple[list[float], dict[str, list[float]]]:
    b = path.read_bytes()
    marker = b"Binary:\n"
    if b"Values:\n" in b and marker not in b:
        text = b.decode("latin1")
        names = re.findall(r"^\s*\d+\s+(\S+)\s+", text, re.M)
        vals = [float(x) for x in text.split("Values:\n", 1)[1].split()]
        nvars = len(names)
        npoints = len(vals) // nvars
        traces = {n: [vals[k * nvars + j] for k in range(npoints)]
                  for j, n in enumerate(names)}
        return traces[names[0]], traces
    i = b.index(marker) + len(marker)
    text = b[:i].decode("latin1")
    nvars = int(re.search(r"No\. Variables:\s*(\d+)", text).group(1))
    npoints = int(re.search(r"No\. Points:\s*(\d+)", text).group(1))
    names = re.findall(r"^\s*\d+\s+(\S+)\s+", text, re.M)
    raw = struct.unpack("<%dd" % (nvars * npoints),
                        b[i: i + nvars * npoints * 8])
    traces = {n: [] for n in names}
    for k in range(npoints):
        for j, n in enumerate(names):
            traces[n].append(raw[k * nvars + j])
    return traces[names[0]], traces


# ---------------------------------------------------------------------------
# crossing extraction
# ---------------------------------------------------------------------------
def rising_crossings(t: list[float], v: list[float],
                     thresh: float) -> list[tuple[float, float]]:
    """Interpolated rising-crossing times plus the local slope (V/ns).

    The slope is used to estimate the interpolation error: with a linear model
    the only error left is curvature over one timestep, so
    error ~= 0.125 * dt^2 * |v''|/|v'|, which the caller bounds by dt itself.
    """
    out = []
    n = len(v)
    for k in range(1, n):
        if v[k - 1] < thresh <= v[k]:
            dv = v[k] - v[k - 1]
            frac = 0.0 if dv == 0 else (thresh - v[k - 1]) / dv
            tc = t[k - 1] + frac * (t[k] - t[k - 1])
            dt = t[k] - t[k - 1]
            slope = (dv / dt) if dt else 0.0
            out.append((tc, slope))
    return out


def stats(xs: list[float]) -> dict:
    n = len(xs)
    if n == 0:
        return {"n": 0}
    mean = sum(xs) / n
    var = sum((x - mean) ** 2 for x in xs) / (n - 1) if n > 1 else 0.0
    rms = math.sqrt(var)
    return {
        "n": n,
        "mean": mean,
        "rms": rms,
        "pp": max(xs) - min(xs),
        "min": min(xs),
        "max": max(xs),
    }


def psd_peak(times: list[float], periods: list[float]) -> dict:
    """Coarse period-domain PSD: find the strongest tone in the drift.

    A full FFT needs uniformly spaced samples; the period series is already one
    sample per cycle, so it is directly usable.  Detrending first is what makes
    the peak meaningful -- otherwise the low-frequency start-up ramp dominates
    every bin.
    """
    n = len(periods)
    if n < 32:
        return {"note": "too few periods for a spectrum", "n": n}
    mean = sum(periods) / n
    d = [p - mean for p in periods]
    # Hann window, then a direct DFT over a coarse frequency grid (the series
    # is short, so a hand-rolled DFT is cheaper than pulling in numpy).
    w = [0.5 - 0.5 * math.cos(2 * math.pi * k / (n - 1)) for k in range(n)]
    dw = [d[k] * w[k] for k in range(n)]
    mean_period = mean
    f_cycle = 1.0 / mean_period          # per-cycle frequency axis
    best = (0.0, 0.0)
    bins = min(256, n // 2)
    for bi in range(1, bins):
        f = bi / (2.0 * bins)
        re = im = 0.0
        for k in range(n):
            ang = 2 * math.pi * f * k
            re += dw[k] * math.cos(ang)
            im -= dw[k] * math.sin(ang)
        mag = math.hypot(re, im)
        if mag > best[0]:
            best = (mag, f)
    return {
        "n": n,
        "peak_bin": best[1],
        "peak_cycles_per_cycle": best[1],
        "peak_freq_hz": best[1] * f_cycle,
        "note": "period-domain spectrum; a tone here is deterministic drift, "
                "not random jitter",
    }


# ---------------------------------------------------------------------------
# deck construction
# ---------------------------------------------------------------------------
def build_deck(pdk: str, corner: str, code: int, stop_ns: float,
               step_ps: float, outdir: Path) -> tuple[Path, Path, Path]:
    """Corner deck for the IHP ring DCO at one fine code."""
    libc = {
        "tt": "mos_tt", "ss": "mos_ss", "ff": "mos_ff",
    }[corner]
    spice = IHP_RING / "PLL_RING_DCO_PHYS.spice"
    if not spice.exists():
        raise SystemExit(f"missing DCO SPICE view: {spice}")

    # Pull the port list so the harness cannot drift from the netlist.
    text = spice.read_text()
    # The port list spans many lines with SPICE "+" continuations, so collect
    # until the next directive rather than reading one line.
    lines = text.splitlines()
    start = next((i for i, ln in enumerate(lines)
                  if ln.upper().startswith(".SUBCKT PLL_RING_DCO_PHYS")), None)
    if start is None:
        raise SystemExit("no .SUBCKT PLL_RING_DCO_PHYS in the SPICE view")
    ports = lines[start].split()[2:]
    for ln in lines[start + 1:]:
        if not ln.startswith("+"):
            break
        ports += ln[1:].split()

    outdir.mkdir(parents=True, exist_ok=True)
    inc = outdir / "dco.sp"
    inc.write_text(text)

    conns = []
    for p in ports:
        if p.startswith("COARSE_MUX["):
            conns.append("0")
        elif p.startswith("MID_MUX["):
            conns.append("0")
        elif p.startswith("FINE_MUX["):
            # thermometer: bit index < code is high
            idx = int(p.split("[")[1].rstrip("]"))
            conns.append("vdd" if idx < code else "0")
        elif p in ("DCO_EN", "INJ_EN"):
            conns.append("vdd" if p == "DCO_EN" else "0")
        elif p == "REF":
            conns.append("ref")
        elif p in ("OUT", "MID_OUT", "INJ_EDGE"):
            conns.append(f"n_{p.lower()}")
        elif p.startswith("SS_BBPD["):
            conns.append(f"n_{p.replace('[', '_').replace(']', '')}")
        elif p in ("VDD", "VSS"):
            conns.append("vdd" if p == "VDD" else "0")
        else:
            conns.append("0")

    raw = outdir / "jitter.raw"
    log = outdir / "jitter.log"
    deck = outdir / "jitter.cir"
    # Model setup, mirroring flow/characterization/macro_char.py, which is the
    # only IHP transistor-level path known to work here:
    #   * the corner .lib selects the process corner,
    #   * sg13g2_moslv_mod.lib supplies the sg13_lv_nmos/pmos subcircuits,
    #   * the stdcell SPICE view supplies the cell subcircuits,
    #   * .spiceinit loads the pre-compiled PSP103 OSDI so the subcircuits'
    #     internal "nmos"/"pmos" model names resolve.
    # Do NOT include sg13g2_moslv_parm.lib by hand: it expects pre_layout and
    # the other parameters the subcircuit passes down, and including it ahead
    # of the subcircuit makes ngspice fail with "Undefined parameter".
    (outdir / ".spiceinit").write_text(
        "set num_threads=4\n"
        f"osdi '{IHP / 'libs.tech/ngspice/osdi/psp103.osdi'}'\n"
        f"osdi '{IHP / 'libs.tech/ngspice/osdi/psp103_nqs.osdi'}'\n"
    )
    deck.write_text(f"""* Ring DCO transient for zero-crossing jitter analysis
* PDK {pdk} corner {corner}, fine code {code}
.lib "{IHP}/libs.tech/ngspice/models/cornerMOSlv.lib" {libc}
.include "{IHP}/libs.tech/ngspice/models/sg13g2_moslv_mod.lib"
.include "{IHP}/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice"
.include "{inc}"

Vdd  vdd 0 1.2
Vref ref 0 PULSE(0 1.2 0 10p 10p 5n 10n)

Xring {' '.join(conns)} PLL_RING_DCO_PHYS

* 1 ps print resolution: the jitter being measured is a few ps, so the print
* step must be well below it or the interpolation dominates.
.option accurate
.tran {step_ps}p {stop_ns}n uic

.control
run
set filetype = binary
write "{raw}" n_out n_mid_out
quit
.endc
.end
""")
    return deck, raw, log


# ---------------------------------------------------------------------------
# main analysis
# ---------------------------------------------------------------------------
def analyse(t: list[float], v: list[float], node: str,
            settle_frac: float = 0.25) -> dict:
    lo, hi = min(v), max(v)
    thresh = 0.5 * (lo + hi)
    crossings = rising_crossings(t, v, thresh)
    if len(crossings) < 8:
        return {"node": node, "error": "too few crossings",
                "crossings": len(crossings)}

    ct = [c[0] for c in crossings]
    slopes = [c[1] for c in crossings]
    # Drop the start-up interval: the bias node is still settling and the first
    # periods are not representative.
    skip = int(len(ct) * settle_frac)
    ct = ct[skip:]
    slopes = slopes[skip:]

    periods = [ct[i + 1] - ct[i] for i in range(len(ct) - 1)]
    c2c = [periods[i + 1] - periods[i] for i in range(len(periods) - 1)]

    # Interpolation bound: half a timestep, scaled by the local slope error.
    dts = [t[k + 1] - t[k] for k in range(min(len(t) - 1, 5000))]
    dt = sum(dts) / len(dts) if dts else 0.0

    # Low-frequency drift: fit a line to the period sequence; the residual RMS
    # is the deterministic jitter left after removing the ramp.
    n = len(periods)
    xm = (n - 1) / 2.0
    ym = sum(periods) / n
    sxx = sum((i - xm) ** 2 for i in range(n))
    sxy = sum((i - xm) * (periods[i] - ym) for i in range(n))
    slope = sxy / sxx if sxx else 0.0
    resid = [periods[i] - (ym + slope * (i - xm)) for i in range(n)]

    return {
        "node": node,
        "threshold_v": thresh,
        "settle_frac_dropped": settle_frac,
        "print_step_ps": dt * 1000.0,
        "interp_bound_ps": dt * 500.0,
        "period_mean_ps": stats(periods)["mean"] * 1000.0,
        "period_jitter": {k: v * 1000.0 for k, v in stats(periods).items()
                          if k not in ("n",)},
        "cycle_to_cycle_jitter": {k: v * 1000.0
                                  for k, v in stats(c2c).items()
                                  if k not in ("n",)},
        "period_pp_ps": stats(periods)["pp"] * 1000.0,
        "period_rms_ps": stats(periods)["rms"] * 1000.0,
        "c2c_rms_ps": stats(c2c)["rms"] * 1000.0,
        "drift_ps_per_cycle": slope * 1000.0,
        "drift_removed_rms_ps": stats(resid)["rms"] * 1000.0,
        "spectrum": psd_peak(ct, periods),
        "note": "deterministic only: the transient is noiseless, so this is "
                "not random jitter",
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdk", default="ihp", choices=("ihp",))
    ap.add_argument("--corner", default="tt", choices=("tt", "ss", "ff"))
    ap.add_argument("--code", type=int, default=8,
                    help="fine thermometer code (0..31)")
    ap.add_argument("--stop-ns", type=float, default=400.0)
    ap.add_argument("--step-ps", type=float, default=1.0)
    ap.add_argument("--settle-frac", type=float, default=0.25)
    ap.add_argument("--node", default="n_out")
    ap.add_argument("--raw", default="", help="analyse an existing raw file")
    ap.add_argument("--out", default="/tmp/opencode/jitter")
    ap.add_argument("--json", default="")
    args = ap.parse_args()

    outdir = Path(args.out)
    if args.raw:
        raw = Path(args.raw)
        deck = log = None
    else:
        deck, raw, log = build_deck(args.pdk, args.corner, args.code,
                                   args.stop_ns, args.step_ps, outdir)
        print(f"deck: {deck}")
        proc = subprocess.run(["ngspice", "-b", "-o", str(log), deck.name],
                              capture_output=True, text=True, timeout=7200,
                              cwd=str(outdir))
        if not raw.exists():
            print((proc.stdout or "")[-2000:], file=sys.stderr)
            print((proc.stderr or "")[-2000:], file=sys.stderr)
            raise SystemExit(f"ngspice produced no raw file (log: {log})")

    t, traces = read_raw(raw)
    key = args.node if args.node in traces else next(
        (k for k in traces if k.lower().endswith("out")), None)
    if key is None:
        raise SystemExit(f"no usable node in {list(traces)[:8]}")

    result = analyse(t, traces[key], key, args.settle_frac)
    result.update({"corner": args.corner, "fine_code": args.code,
                   "stop_ns": args.stop_ns, "source": str(raw)})

    print(f"\n=== {args.corner} code={args.code} node={key} ===")
    for k in ("period_mean_ps", "period_pp_ps", "period_rms_ps",
              "c2c_rms_ps", "drift_ps_per_cycle", "drift_removed_rms_ps",
              "interp_bound_ps"):
        if k in result:
            print(f"  {k:24s} {result[k]:10.3f}")
    sp = result.get("spectrum", {})
    if "peak_freq_hz" in sp:
        print(f"  drift tone               {sp['peak_freq_hz']:10.3e} Hz")
    print(f"  {result.get('note', '')}")

    if args.json:
        Path(args.json).write_text(json.dumps(result, indent=2) + "\n")
        print(f"wrote {args.json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
