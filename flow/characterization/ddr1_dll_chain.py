#!/usr/bin/env python3
"""DDR1 CK90 DLL segment chain characterization (bare cascade, real sg13g2).

Measures a chain of N dll8-v4-style elements (INV4B/INV4 driver + INVX4 +
thermometer moscap bank, exactly the DLL8_ELEM netlist from
flow/characterization/dll8_pex2.py) in the DDR1 configuration:

  * BARE cascade — no tap buffers, no SR regenerator loads (those are
    dll8-line specifics; the DDR1 segment chain is element-to-element only).
  * N=6 elements per segment (docs/DDR1_DLL_ELEMENT_SIZING.md pick).
  * Pulse mode: propagation delay rise+fall, edge rates, tpHL-tpLH
    asymmetry per chain.

Targets (from the sizing analysis):
  * per-segment delay exactly 2500 ps at some thermometer code at every
    corner, lock codes 84/103/102 (SS/TT/FF) per the interpolated estimate —
    this campaign measures the true chain-level curve.
  * monotonicity in code; headroom both directions; per-LSB step at lock
    code; duty asymmetry accumulation through 6 elements.

Outputs: JSON rows into --out; the analysis is done by the caller.

Usage:
  python3 flow/characterization/ddr1_dll_chain.py \
      --codes 0,32,64,80,96,100,104,112,127 --driver custom --jobs 8 \
      --out sim/outputs/ddr1/dll_chain/chain_custom.json
"""

import argparse
import json
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import dll8_pex2 as P  # netlist/measurement reuse; no side effects on import

WORKDIR = Path(os.environ.get("DDR1_CHAIN_WORKDIR", "/tmp/opencode/ddr1chain/decks"))


def emit_top_ddr1(cfg: dict) -> str:
    """Bare N-element cascade: no tap buf_1, no inv_4 end-loads (unlike the
    dll8 line harness).  Wire cap per node kept at the same 0.96 fF mean."""
    c = P.CORNERS[cfg["corner"]]
    nelem = cfg["nelem"]
    wire = cfg.get("wire", True)
    code = cfg.get("code", 0)
    bits = [(code >> b) & 1 for b in range(P.NBITS)]
    # generous pulse window: input pulse must outlive the chain delay
    est = nelem * 0.9  # ns, worst-case-ish chain delay at SS high code
    t_fall = 0.4 + est + 1.0
    # the output falling edge lands at t_fall + chain delay; the window
    # must cover BOTH edges plus margin (first smoke run lost delay_fall
    # because stop was t_fall + 1.0).
    stop = t_fall + est + 1.5
    dt = "5p"
    s = [f"* ddr1 dll chain corner={cfg['corner']} code={code} nelem={nelem} driver={cfg.get('driver','custom')}",
         f".TEMP {c['temp']}",
         f'.LIB "{P.CORNER_MOS}" {c["mos"]}',
         f'.LIB "{P.CORNER_CAP}" moscap_tt',
         f'.inc "{P.MOSCAP_MOD}"',
         f'.inc "{P.CELLS}"',
         ".inc dll8_elem.sp",
         f".PARAM CMID={'0.96f' if wire else '0f'}",
         ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12 TRTOL=15 ITL4=30",
         f"vvdd VDD 0 DC={c['vdd']}", "vvss VSS 0 DC=0"]
    for b in range(P.NBITS):
        s.append(f"vc{b} C{b} 0 DC={c['vdd'] if bits[b] else 0.0}")
    s.append(P.pwl_pulse(c["vdd"], t_fall))
    nodes = ["IN"] + [f"x{i+1}" for i in range(nelem)]
    for i in range(nelem):
        s.append(f"Xn{i} {nodes[i]} {nodes[i+1]} C0 C1 C2 C3 C4 C5 C6 VDD VSS DLL8_ELEM")
        if wire:
            s.append(f"Cwire{i} {nodes[i+1]} 0 {P.WIRE_FF:.3f}f")
    s += [".control", "set filetype=ascii", "run",
          f"wrdata tran.out v(IN) v({nodes[nelem]})", "quit", ".endc",
          f".TRAN {dt} {stop:.4g}n", ".end"]
    return "\n".join(s)


def measure_ddr1(cfg, raw):
    c = P.CORNERS[cfg["corner"]]
    vdd = c["vdd"]
    thr = 0.5 * vdd
    t, w = P.parse_wrdata(raw)
    res = dict(cfg)
    rin = P.interp_cross(t, w["v0"], thr, True)
    fin = P.interp_cross(t, w["v0"], thr, False)
    rout = P.interp_cross(t, w["v1"], thr, True)
    fout = P.interp_cross(t, w["v1"], thr, False)

    def prop(a, b):
        if not a or not b:
            return None
        bb = next((x for x in b if x > a[0]), None)
        return (bb - a[0]) * 1e12 if bb is not None else None

    res["delay_ps"] = prop(rin, rout)
    res["delay_fall_ps"] = prop(fin, fout)
    if res["delay_ps"] is not None and res["delay_fall_ps"] is not None:
        res["tpHL_minus_tpLH"] = res["delay_fall_ps"] - res["delay_ps"]

    def e(frac, rising):
        return P.interp_cross(t, w["v1"], frac * vdd, rising)

    r10, r90 = e(0.1, True), e(0.9, True)

    def d(lo, hi):
        if not lo or not hi:
            return None
        bb = next((x for x in hi if x > lo[0]), None)
        return (bb - lo[0]) * 1e12 if bb is not None else None

    res["rise_10_90_ps"] = d(r10, r90)
    res["fall_10_90_ps"] = d(e(0.9, False), e(0.1, False))
    return res


def deck_dir(cfg):
    return WORKDIR / (f"d1_{cfg['nelem']}e_{cfg['corner']}"
                      f"_c{cfg.get('code', 0):03d}_{cfg.get('driver', 'custom')}")


def run_one(cfg):
    d = deck_dir(cfg)
    d.mkdir(parents=True, exist_ok=True)
    (d / "dll8_elem.sp").write_text(
        P.emit_elem2(P.NBITS, -1, "np", cfg.get("driver", "custom")))
    (d / "top.sp").write_text(emit_top_ddr1(cfg))
    (d / ".spiceinit").write_text(
        f"set num_threads=1\nosdi {P.OSDI.resolve()}\nosdi {P.OSDI_NQS.resolve()}\n")
    raw = d / "tran.out"
    if not raw.exists():
        subprocess.run(["ngspice", "-b", "top.sp"], cwd=d, check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return measure_ddr1(cfg, raw)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--corners", default="ss,tt,ff")
    ap.add_argument("--codes", default="0,32,64,80,96,100,104,112,127")
    ap.add_argument("--nelem", type=int, default=6)
    ap.add_argument("--driver", default="custom", choices=["custom", "stock"])
    ap.add_argument("--jobs", type=int, default=8)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    cfgs = []
    for c in args.corners.split(","):
        for code in [int(x) for x in args.codes.split(",")]:
            cfgs.append(dict(corner=c, code=code, nelem=args.nelem,
                             driver=args.driver, wire=True))

    def go(cfg):
        try:
            return run_one(cfg)
        except Exception as ex:
            import traceback
            return {**cfg, "error": repr(ex), "trace": traceback.format_exc()[-800:]}

    with ThreadPoolExecutor(args.jobs) as ex:
        res = list(ex.map(go, cfgs))
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    json.dump(res, open(out, "w"), indent=1)
    nerr = 0
    for r in sorted(res, key=lambda r: (r["corner"], r["code"])):
        if "error" in r:
            nerr += 1
            print("ERR", r["corner"], r["code"], r["error"][:120])
        else:
            print(f"{r['corner']} c{r['code']:03d}: delay={r['delay_ps'] and round(r['delay_ps'],1)} "
                  f"fall={r['delay_fall_ps'] and round(r['delay_fall_ps'],1)} "
                  f"asym={r.get('tpHL_minus_tpLH') is not None and round(r['tpHL_minus_tpLH'],1)} "
                  f"tr={r.get('rise_10_90_ps') is not None and round(r['rise_10_90_ps'],1)}")
    print(f"{len(cfgs)} points, {nerr} errors -> {out}")


if __name__ == "__main__":
    main()
