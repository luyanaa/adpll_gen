#!/usr/bin/env python3
"""DLL8 element / line SPICE characterisation (real sg13g2 cells).

Same method as flow/characterization/dco_tuned_pex.py: real stdcell SPICE
subckts + cornerMOSlv + OSDI PSP103 (NQS) + routed wire caps (0.96 fF mean
per node from the STEP=3 SPEF, DCO_PEX_WIRE=1 method).

    DLL8_ELEM = INVX4 -> mid -> INVX4, binary 1:2:4:8:16:32:64 bank of
                sg13g2_nand3_1 switched-cap fingers on mid (A=~code,
                B=mid, C=code), one buf_1 + inv_1 per bit.

Modes:
  pulse  : one rising + one falling edge, measures rising-edge propagation
           delay (the delay the DLL locks on), fall delay, rise/fall 10-90.
  square : square wave at the corner operating period, measures tap duty.

Corners: ss 1.08 V 125 C, tt 1.20 V 25 C, ff 1.32 V -40 C.
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path("/grid/adpll_gen")
OUT = Path(os.environ.get("DLL8_PEX_OUT", str(ROOT / "flow/characterization/dll8_pex")))
WORKDIR = Path(os.environ.get("DLL8_PEX_WORKDIR", "/tmp/opencode/dll8pex/decks"))
IHP = Path("/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
           "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2")
CELLS = IHP / "libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice"
CORNER_MOS = IHP / "libs.tech/ngspice/models/cornerMOSlv.lib"
CORNER_CAP = IHP / "libs.tech/ngspice/models/cornerMOSCAP.lib"
MOSCAP_MOD = IHP / "libs.tech/ngspice/models/sg13g2_moscap_mod.lib"
OSDI = ROOT / "flow/characterization/ihp_l3/psp103.osdi"
OSDI_NQS = IHP / "libs.tech/ngspice/osdi/psp103_nqs.osdi"

CORNERS = {
    "ss": dict(mos="mos_ss", vdd=1.08, temp=125, period=4.0),
    "tt": dict(mos="mos_tt", vdd=1.20, temp=25,  period=3.0),
    "ff": dict(mos="mos_ff", vdd=1.32, temp=-40, period=2.0),
}
NBITS = 7
WIRE_FF = 0.96
EDGE = 0.03   # ns


def emit_elem() -> str:
    s = [".subckt DLL8_ELEM IN OUT C0 C1 C2 C3 C4 C5 C6 VDD VSS"
         " params: CMID=0.96f",
         "* two INVX4 stages, binary switched-cap NAND3 bank on mid",
         "Xinv_in mid IN VDD VSS sg13g2_inv_4",
         "Xinv_out OUT mid VDD VSS sg13g2_inv_4",
         "Cmid mid 0 {CMID}"]
    for b in range(NBITS):
        s.append(f"* bit {b}: {1<<b} finger(s)")
        s.append(f"Xgb{b} g{b} C{b} VDD VSS sg13g2_buf_1")
        s.append(f"Xgi{b} gb{b} g{b} VDD VSS sg13g2_inv_1")
        for j in range(1 << b):
            # each finger output floats (as .ZN() unconnected in the RTL); a
            # single shared node would tie 127 PMOS pull-ups together and pin
            # the stack, killing the switched-cap effect.
            s.append(f"Xnf{b}_{j} ncy{b}_{j} gb{b} mid g{b} VDD VSS sg13g2_nand3_1")
            s.append(f"Rnc{b}_{j} ncy{b}_{j} VSS 1G")
    s.append(".ends DLL8_ELEM")
    return "\n".join(s)


def pwl_pulse(vdd: float, t_fall: float) -> str:
    seg = ["0 0",
           f"{0.4 - EDGE:.6g}n 0", f"0.4n {vdd}",
           f"{t_fall - EDGE:.6g}n {vdd}", f"{t_fall:.6g}n 0",
           f"{t_fall + 0.4:.6g}n 0"]
    return "Vin IN 0 PWL(" + " ".join(seg) + ")"


def pwl_square(period_ns: float, vdd: float, ncyc: int) -> str:
    seg = ["0 0"]
    for k in range(1, 2 * ncyc + 2):
        t = 0.5 * period_ns * k
        if k % 2 == 1:
            prev, lvl = 0.0, vdd
        else:
            prev, lvl = vdd, 0.0
        seg.append(f"{t - EDGE:.6g}n {prev}")
        seg.append(f"{t:.6g}n {lvl}")
    return "Vin IN 0 PWL(" + " ".join(seg) + ")"


def emit_top(cfg: dict) -> str:
    corner = cfg["corner"]
    code = cfg["code"]
    nelem = cfg["nelem"]
    mode = cfg.get("mode", "pulse")
    wire = cfg.get("wire", True)
    c = CORNERS[corner]
    p = cfg.get("period") or c["period"]
    bits = [(code >> b) & 1 for b in range(NBITS)]
    # pulse fall time scales with the chain length (total delay must fit)
    t_fall = 0.4 + nelem * 0.75
    stop = t_fall + nelem * 0.2 + 0.5
    dt = "2p" if nelem < 4 else "5p"
    if mode == "square":
        ncyc = cfg.get("ncyc", 3)
        stop = p * (ncyc + 2)
    s = [f"* dll8 deck corner={corner} code={code} nelem={nelem} mode={mode}"
         f" wire={int(wire)}",
         f".TEMP {c['temp']}",
         f'.LIB "{CORNER_MOS}" {c["mos"]}',
         '* cornerMOSCAP has only the nominal (tt) section in this PDK',
         f'.LIB "{CORNER_CAP}" moscap_tt',
         f'.inc "{MOSCAP_MOD}"',
         f'.inc "{CELLS}"',
         ".inc dll8_elem.sp",
         f".PARAM CMID={'0.96f' if wire else '0f'}",
         ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12 TRTOL=15 ITL4=30",
         f"vvdd VDD 0 DC={c['vdd']}",
         "vvss VSS 0 DC=0"]
    for b in range(NBITS):
        s.append(f"vc{b} C{b} 0 DC={c['vdd'] if bits[b] else 0.0}")
    if mode == "square":
        s.append(pwl_square(p, c["vdd"], ncyc))
    else:
        s.append(pwl_pulse(c["vdd"], t_fall))

    nodes = ["IN"] + [f"x{i+1}" for i in range(nelem)]
    codes = " ".join(f"C{b}" for b in range(NBITS))
    for i in range(nelem):
        s.append(f"Xn{i} {nodes[i]} {nodes[i+1]} {codes} VDD VSS DLL8_ELEM")
        if wire:
            s.append(f"Cwire{i} {nodes[i+1]} 0 {WIRE_FF:.3f}f")
        s.append(f"Xtb{i} tb{i} {nodes[i+1]} VDD VSS sg13g2_buf_1")
        s.append(f"Xnx{i} nx{i} {nodes[i+1]} VDD VSS sg13g2_inv_4")
    s += [".control", "set filetype=ascii", "run",
          f"wrdata tran.out v(IN) v({nodes[nelem]}) v(tb0)", "quit", ".endc",
          f".TRAN {dt} {stop:.4g}n", ".end"]
    return "\n".join(s)


# ---------------------------------------------------------------- measurement
def parse_wrdata(path: Path):
    cols = []
    for line in path.read_text().split("\n"):
        if not line.strip():
            continue
        t = [float(x) for x in line.split()]
        if not cols:
            cols = [[] for _ in range(len(t))]
        for j, v in enumerate(t):
            cols[j].append(v)
    waves = {f"v{j//2}": cols[j] for j in range(1, len(cols), 2)}
    return cols[0], waves


def interp_cross(t, w, thr, rising=True):
    out = []
    for k in range(1, len(w)):
        a, b = w[k-1], w[k]
        if b == a:
            continue
        if rising and a < thr <= b:
            out.append(t[k-1] + (thr-a)/(b-a)*(t[k]-t[k-1]))
        elif (not rising) and a > thr >= b:
            out.append(t[k-1] + (thr-a)/(b-a)*(t[k]-t[k-1]))
    return out


def rise_fall_time(t, w, vdd):
    """10-90% rise and fall of the last full edges."""
    r10 = interp_cross(t, w, 0.1*vdd, True)
    r90 = interp_cross(t, w, 0.9*vdd, True)
    f90 = interp_cross(t, w, 0.9*vdd, False)
    f10 = interp_cross(t, w, 0.1*vdd, False)
    def d(lo, hi, hi_edges):
        vals = []
        for e in hi_edges:
            prev = [x for x in lo if x < e]
            if prev:
                vals.append((e - prev[-1]) * 1e12)
        return sum(vals)/len(vals) if vals else None
    return d(r10, r90, r90), d(f90, f10, f10)


def measure(cfg: dict, raw: Path) -> dict:
    c = CORNERS[cfg["corner"]]
    vdd = c["vdd"]
    thr = 0.5 * vdd
    t, w = parse_wrdata(raw)
    res = dict(cfg)
    if cfg.get("mode", "pulse") == "square":
        p = (cfg.get("period") or c["period"]) * 1e-9
        ncyc = cfg.get("ncyc", 3)
        settle, stop = 1.5 * p, (ncyc + 0.5) * p
        hi = lo = 0.0
        pt, pv = None, None
        for tt, vv in zip(t, w["v1"]):
            if tt < settle or tt > stop:
                pt, pv = tt, vv
                continue
            if pt is not None:
                dt = tt - pt
                if (pv + vv)*0.5 > thr:
                    hi += dt
                else:
                    lo += dt
            pt, pv = tt, vv
        res["duty_pct"] = 100.0*hi/(hi+lo) if hi+lo > 0 else None
        return res
    # pulse: rising (locking) and falling propagation delay
    rin = interp_cross(t, w["v0"], thr, True)
    fin = interp_cross(t, w["v0"], thr, False)
    rout = interp_cross(t, w["v1"], thr, True)
    fout = interp_cross(t, w["v1"], thr, False)
    def prop(a, b):
        # pair the output crossing that follows the input edge (the circuit
        # settles from DC before the pulse, so ignore pre-edge crossings)
        if not a or not b:
            return None
        ref = a[0]
        bb = next((x for x in b if x > ref), None)
        return (bb - ref) * 1e12 if bb is not None else None
    res["delay_ps"] = prop(rin, rout)          # rising-edge (lock) delay
    res["delay_fall_ps"] = prop(fin, fout)
    tr, tf = rise_fall_time(t, w["v1"], vdd)
    res["rise_10_90_ps"] = tr
    res["fall_10_90_ps"] = tf
    # duty distortion per element: high-time change = tphl - tplh
    if res["delay_ps"] is not None and res["delay_fall_ps"] is not None:
        res["duty_distortion_ps"] = res["delay_fall_ps"] - res["delay_ps"]
    return res


def deck_dir(cfg: dict) -> Path:
    mode = cfg.get("mode", "pulse")[0]
    return WORKDIR / (f"{mode}{cfg['nelem']}e_{cfg['corner']}_c{cfg['code']:03d}"
                      f"_p{cfg.get('period') or 0:.0f}")


def run_one(cfg: dict) -> dict:
    d = deck_dir(cfg)
    d.mkdir(parents=True, exist_ok=True)
    (d / "dll8_elem.sp").write_text(emit_elem())
    (d / "top.sp").write_text(emit_top(cfg))
    (d / ".spiceinit").write_text(
        f"set num_threads=1\nosdi {OSDI.resolve()}\nosdi {OSDI_NQS.resolve()}\n")
    raw = d / "tran.out"
    if not raw.exists():
        subprocess.run(["ngspice", "-b", "top.sp"], cwd=d, check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return measure(cfg, raw)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["elem", "sweep", "chain", "deck"])
    ap.add_argument("--corners", default="ss,tt,ff")
    ap.add_argument("--codes", default="")
    ap.add_argument("--nelem", default="1")
    ap.add_argument("--mode", default="pulse")
    ap.add_argument("--period", type=float, default=0.0)
    ap.add_argument("--jobs", type=int, default=10)
    ap.add_argument("--out", default=str(OUT / "dll8_pex.json"))
    args = ap.parse_args()

    if args.cmd == "deck":
        print(emit_elem())
        return

    if args.cmd == "sweep":
        codes = list(range(128))
    elif args.codes:
        codes = [int(x) for x in args.codes.split(",")]
    else:
        codes = [0, 16, 32, 48, 64, 80, 96, 112, 127]
    cfgs = []
    for ne in [int(x) for x in args.nelem.split(",")]:
        for corner in args.corners.split(","):
            for code in codes:
                cfgs.append(dict(corner=corner, code=code, nelem=ne,
                                 mode=args.mode, wire=True,
                                 period=(args.period or None), ncyc=3))

    def go(cfg):
        try:
            return run_one(cfg)
        except Exception as e:
            import traceback
            return {**cfg, "error": repr(e),
                    "trace": traceback.format_exc()[-1000:]}
    with ThreadPoolExecutor(args.jobs) as ex:
        results = list(ex.map(go, cfgs))
    OUT.mkdir(parents=True, exist_ok=True)
    json.dump(results, open(args.out, "w"), indent=1)
    for r in results:
        if "error" in r:
            print("ERR", r["corner"], r["code"], r.get("nelem"), r["error"])
        else:
            if "delay_ps" in r:
                print(f"{r['nelem']}e {r['corner']} c{r['code']:03d}: "
                      f"delay={r['delay_ps'] and round(r['delay_ps'],1)}ps "
                      f"fall={r['delay_fall_ps'] and round(r['delay_fall_ps'],1)} "
                      f"tr={r['rise_10_90_ps'] and round(r['rise_10_90_ps'],1)} "
                      f"tf={r['fall_10_90_ps'] and round(r['fall_10_90_ps'],1)}")
            else:
                print(f"{r['nelem']}e {r['corner']} c{r['code']:03d}: "
                      f"duty={r.get('duty_pct') and round(r['duty_pct'],1)}%")


if __name__ == "__main__":
    main()
