#!/usr/bin/env python3
"""DLL8 v2 element: switched sg13_moscap bank (ring-campaign device).

Replaces the sg13g2_nand3_1 finger bank (0.05 fF switched contrast, NMOS-stack
duty asymmetry) with switched moscap fingers:

  finger = CMOS transmission gate (nmos+pmos driven by g/~g) from `mid` to `cn`,
           plus a moscap_n (cn->VSS) and moscap_p (cn->VDD) for a more
           voltage-linear, symmetric load.

Two-element stages INVX4 -> mid -> INVX4 with the bank on mid.  Binary 7-bit
code (1:2:4:...:64) for the final element; a thermometer `nfixed` mode is used
to measure the per-finger delay and the duty asymmetry before sizing.

Methods identical to dll8_pex.py: cornerMOSlv, OSDI PSP103-NQS, 0.96 fF/node
wire caps, same pulse/square measurement.
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
WORKDIR = Path(os.environ.get("DLL8_PEX2_WORKDIR", "/tmp/opencode/dll8pex2/decks"))
IHP = Path("/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
           "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2")
CELLS = IHP / "libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice"
CORNER_MOS = IHP / "libs.tech/ngspice/models/cornerMOSlv.lib"
CORNER_CAP = IHP / "libs.tech/ngspice/models/cornerMOSCAP.lib"
MOSCAP_MOD = IHP / "libs.tech/ngspice/models/sg13g2_moscap_mod.lib"
OSDI = ROOT / "flow/characterization/ihp_l3/psp103.osdi"
OSDI_NQS = IHP / "libs.tech/ngspice/osdi/psp103_nqs.osdi"
CMOMF_LIB = IHP / "libs.tech/ngspice/models/cap_cmomf.lib"
CMOMF_OSDI = IHP / "libs.tech/ngspice/osdi/cap_cmomf.osdi"

CORNERS = {
    "ss": dict(mos="mos_ss", vdd=1.08, temp=125, period=4.0),
    "tt": dict(mos="mos_tt", vdd=1.20, temp=25,  period=3.0),
    "ff": dict(mos="mos_ff", vdd=1.32, temp=-40, period=2.0),
}
NBITS = 7
WIRE_FF = 0.96
EDGE = 0.03

# finger sizing (from the ring campaign; one moscap_n 0.72x1.0 ~ 9.2 fF)
CAP_W, CAP_L = "1.0u", "1.0u"
NW, NL = "0.15u", "0.45u"      # nmos switch
PW, PL = "0.30u", "0.13u"      # pmos switch


def emit_fingers(tag: str, sel: str, selb: str, n: int, scheme: str = "np") -> list[str]:
    """scheme='np': alternate NMOS->VSS(moscap_n) and PMOS->VDD(moscap_p).
       scheme='tg': CMOS TG to a node with moscap_n + moscap_p to the rails.
    """
    s = []
    for j in range(n):
        cn = f"cn_{tag}_{j}"
        if scheme in ("lin", "mom"):
            sw_n = "0.50u" if scheme in ("lin", "mom") else NW
            sw_p = "1.00u" if scheme in ("lin", "mom") else PW
            s.append(f"Xtn_{tag}_{j} {cn} {sel} mid VSS sg13_lv_nmos w={sw_n} l={NL}")
            s.append(f"Xtp_{tag}_{j} {cn} {selb} mid VDD sg13_lv_pmos w={sw_p} l={PL}")
            s.append(f"Rcn_{tag}_{j} {cn} VSS 1G")
            if scheme == "mom":
                s.append(f"Xcm_{tag}_{j} {cn} VSS cap_cmomf w=2.5u l=2.5u mmin=1 mmax=5")
            else:
                if scheme == "npcap":
                    s.append(f"Xcm_{tag}_{j} {cn} VSS cap_cmomf w=2.5u l=2.5u mmin=1 mmax=5")
                else:
                    s.append(f"Ccn_{tag}_{j} {cn} 0 10f")
        elif scheme == "np" and (j % 2 == 1):
            s.append(f"Xtp_{tag}_{j} {cn} {selb} mid VDD sg13_lv_pmos w=1.0u l={PL}")
            s.append(f"Rcp_{tag}_{j} {cn} VDD 1G")
            s.append(f"Xcp_{tag}_{j} {cn} VDD sg13_moscap_p w={CAP_W} l={CAP_L}")
        elif scheme in ("nplin", "npcap"):
            if j % 2 == 1:
                s.append(f"Xtp_{tag}_{j} {cn} {selb} mid VDD sg13_lv_pmos w=1.0u l={PL}")
                s.append(f"Rcp_{tag}_{j} {cn} VDD 1G")
                if scheme == "npcap":
                    s.append(f"Xcm_{tag}_{j} {cn} VDD cap_cmomf w=2.5u l=2.5u mmin=1 mmax=5")
                else:
                    s.append(f"Ccp_{tag}_{j} {cn} 0 10f")
            else:
                s.append(f"Xtn_{tag}_{j} {cn} {sel} mid VSS sg13_lv_nmos w=0.5u l={NL}")
                s.append(f"Rcn_{tag}_{j} {cn} VSS 1G")
                if scheme == "npcap":
                    s.append(f"Xcm_{tag}_{j} {cn} VSS cap_cmomf w=2.5u l=2.5u mmin=1 mmax=5")
                else:
                    s.append(f"Ccn_{tag}_{j} {cn} 0 10f")
        else:
            sw = "0.50u" if scheme in ("np", "npstrong") else NW
            s.append(f"Xtn_{tag}_{j} {cn} {sel} mid VSS sg13_lv_nmos w={sw} l={NL}")
            s.append(f"Rcn_{tag}_{j} {cn} VSS 1G")
            s.append(f"Xcn_{tag}_{j} {cn} VSS sg13_moscap_n w={CAP_W} l={CAP_L}")
    return s


# custom first-stage driver: Wp raised from 4.48u to 5.30u so mid rise/fall
# match under the bank load (INVX4's native Wp/Wn=1.51 is too low when loaded).
INVB_WP = 5.30e-6
INVB_WN = 2.96e-6


def emit_invb() -> str:
    return (".subckt DLL8_INV4B A Y VDD VSS\n"
            f"XP0 Y A VDD VDD sg13_lv_pmos w={INVB_WP:.3e} l=130.00n ng=4 "
            "ad=1.007e-12 as=1.404e-12 pd=7.10e-06 ps=1.046e-05 m=1\n"
            f"XN0 Y A VSS VSS sg13_lv_nmos w={INVB_WN:.3e} l=130.00n ng=4 "
            "ad=5.624e-13 as=7.844e-13 pd=4.48e-06 ps=6.56e-06 m=1\n"
            ".ends DLL8_INV4B")


def emit_elem2(nbits: int = NBITS, nfixed: int = -1, scheme: str = "np",
              driver: str = "custom") -> str:
    inv1 = "DLL8_INV4B" if driver == "custom" else "sg13g2_inv_4"
    s = [".subckt DLL8_ELEM IN OUT C0 C1 C2 C3 C4 C5 C6 VDD VSS"
         " params: CMID=0.96f",
         ("Xinv_in IN mid VDD VSS DLL8_INV4B" if inv1=="DLL8_INV4B"
         else "Xinv_in mid IN VDD VSS sg13g2_inv_4"),
         "Xinv_out OUT mid VDD VSS sg13g2_inv_4",
         "Cmid mid 0 {CMID}"]
    if nfixed >= 0:
        # thermometer characterisation: all nfixed fingers hard on
        s += emit_fingers("f", "VDD", "VSS", nfixed, scheme)
    else:
        for b in range(nbits):
            s.append(f"Xgb{b} g{b} C{b} VDD VSS sg13g2_buf_8")
            s.append(f"Xgi{b} gb{b} g{b} VDD VSS sg13g2_inv_8")
            s += emit_fingers(f"b{b}", f"g{b}", f"gb{b}", 1 << b, scheme)
    s.append(".ends DLL8_ELEM")
    s.append(emit_invb())
    return "\n".join(s)


def pwl_pulse(vdd: float, t_fall: float) -> str:
    seg = ["0 0", f"{0.4-EDGE:.6g}n 0", "0.4n %s" % vdd,
           f"{t_fall-EDGE:.6g}n {vdd}", f"{t_fall:.6g}n 0",
           f"{t_fall+0.4:.6g}n 0"]
    return "Vin IN 0 PWL(" + " ".join(seg) + ")"


def pwl_square(period_ns: float, vdd: float, ncyc: int) -> str:
    seg = ["0 0"]
    for k in range(1, 2*ncyc+2):
        t = 0.5*period_ns*k
        prev, lvl = (0.0, vdd) if k % 2 == 1 else (vdd, 0.0)
        seg.append(f"{t-EDGE:.6g}n {prev}")
        seg.append(f"{t:.6g}n {lvl}")
    return "Vin IN 0 PWL(" + " ".join(seg) + ")"


def emit_top(cfg: dict) -> str:
    c = CORNERS[cfg["corner"]]
    nelem = cfg["nelem"]
    mode = cfg.get("mode", "pulse")
    wire = cfg.get("wire", True)
    p = cfg.get("period") or c["period"]
    code = cfg.get("code", 0)
    bits = [(code >> b) & 1 for b in range(NBITS)]
    exp = max(nelem*0.95, (cfg.get("nfixed", -1) or 0)*0.045)
    t_fall = 0.4 + exp + 0.8
    stop = t_fall + 0.6
    dt = "2p" if nelem < 4 else "5p"
    if mode == "square":
        ncyc = cfg.get("ncyc", 3)
        stop = p*(ncyc+2)
    s = [f"* dll8 v2 corner={cfg['corner']} code={code} nelem={nelem} nfixed={cfg.get('nfixed',-1)} mode={mode}",
         f".TEMP {c['temp']}",
         f'.LIB "{CORNER_MOS}" {c["mos"]}',
         f'.LIB "{CORNER_CAP}" moscap_tt',
         f'.inc "{MOSCAP_MOD}"',
         f'.inc "{CELLS}"',
         f'.inc "{CMOMF_LIB}"',
         ".inc dll8_elem.sp",
         f".PARAM CMID={'0.96f' if wire else '0f'}",
         ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12 TRTOL=15 ITL4=30",
         f"vvdd VDD 0 DC={c['vdd']}", "vvss VSS 0 DC=0"]
    for b in range(NBITS):
        s.append(f"vc{b} C{b} 0 DC={c['vdd'] if (cfg.get('nfixed',-1) < 0 and bits[b]) else 0.0}")
    s.append(pwl_square(p, c["vdd"], ncyc) if mode == "square" else pwl_pulse(c["vdd"], t_fall))
    nodes = ["IN"] + [f"x{i+1}" for i in range(nelem)]
    for i in range(nelem):
        s.append(f"Xn{i} {nodes[i]} {nodes[i+1]} C0 C1 C2 C3 C4 C5 C6 VDD VSS DLL8_ELEM")
        if wire:
            s.append(f"Cwire{i} {nodes[i+1]} 0 {WIRE_FF:.3f}f")
        s.append(f"Xtb{i} tb{i} {nodes[i+1]} VDD VSS sg13g2_buf_1")
        s.append(f"Xnx{i} nx{i} {nodes[i+1]} VDD VSS sg13g2_inv_4")
    s += [".control", "set filetype=ascii", "run",
          f"wrdata tran.out v(IN) v({nodes[nelem]}) v(tb0)", "quit", ".endc",
          f".TRAN {dt} {stop:.4g}n", ".end"]
    return "\n".join(s)


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


def measure(cfg, raw):
    c = CORNERS[cfg["corner"]]; vdd = c["vdd"]; thr = 0.5*vdd
    t, w = parse_wrdata(raw)
    res = dict(cfg)
    if cfg.get("mode", "pulse") == "square":
        p = (cfg.get("period") or c["period"])*1e-9
        settle, stop = 1.5*p, (cfg.get("ncyc", 3)+0.5)*p
        hi = lo = 0.0; pt = pv = None
        for tt, vv in zip(t, w["v1"]):
            if tt < settle or tt > stop:
                pt, pv = tt, vv; continue
            if pt is not None:
                dt = tt-pt
                if (pv+vv)*0.5 > thr: hi += dt
                else: lo += dt
            pt, pv = tt, vv
        res["duty_pct"] = 100.0*hi/(hi+lo) if hi+lo > 0 else None
        return res
    rin = interp_cross(t, w["v0"], thr, True)
    fin = interp_cross(t, w["v0"], thr, False)
    rout = interp_cross(t, w["v1"], thr, True)
    fout = interp_cross(t, w["v1"], thr, False)
    def prop(a, b):
        if not a or not b: return None
        bb = next((x for x in b if x > a[0]), None)
        return (bb-a[0])*1e12 if bb is not None else None
    res["delay_ps"] = prop(rin, rout)
    res["delay_fall_ps"] = prop(fin, fout)
    if res["delay_ps"] is not None and res["delay_fall_ps"] is not None:
        res["tpHL_minus_tpLH"] = res["delay_fall_ps"]-res["delay_ps"]
    # 10-90 rise/fall on the last node
    def e(frac, rising):
        return interp_cross(t, w["v1"], frac*vdd, rising)
    r10, r90 = e(0.1, True), e(0.9, True)
    def d(lo, hi):
        if not lo or not hi: return None
        bb = next((x for x in hi if x > lo[0]), None)
        return (bb-lo[0])*1e12 if bb is not None else None
    res["rise_10_90_ps"] = d(r10, r90)
    res["fall_10_90_ps"] = d(e(0.9, False), e(0.1, False))
    return res


def deck_dir(cfg):
    return WORKDIR / (f"v2_{cfg['nelem']}e_{cfg['corner']}"
                      f"_c{cfg.get('code',0):03d}_n{cfg.get('nfixed',-1)}"
                      f"_{cfg.get('scheme','np')}_{cfg.get('driver','custom')}_{cfg.get('mode','pulse')[0]}")


def run_one(cfg):
    d = deck_dir(cfg); d.mkdir(parents=True, exist_ok=True)
    (d / "dll8_elem.sp").write_text(
        emit_elem2(NBITS, cfg.get("nfixed", -1), cfg.get("scheme", "np"),
                   cfg.get("driver", "custom")))
    (d / "top.sp").write_text(emit_top(cfg))
    (d / ".spiceinit").write_text(
        f"set num_threads=1\nosdi {OSDI.resolve()}\nosdi {OSDI_NQS.resolve()}"
        f"\nosdi {CMOMF_OSDI.resolve()}\n")
    raw = d / "tran.out"
    if not raw.exists():
        subprocess.run(["ngspice", "-b", "top.sp"], cwd=d, check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return measure(cfg, raw)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["diag", "sweep", "chain", "duty"])
    ap.add_argument("--corners", default="ss,tt,ff")
    ap.add_argument("--codes", default="")
    ap.add_argument("--nfixed", default="0,8,16,32,64")
    ap.add_argument("--nelem", default="1")
    ap.add_argument("--mode", default="pulse")
    ap.add_argument("--period", type=float, default=0.0)
    ap.add_argument("--jobs", type=int, default=8)
    ap.add_argument("--scheme", default="np", choices=["np","npstrong","tg","lin","mom","nplin","npcap"])
    ap.add_argument("--driver", default="custom", choices=["custom","stock"])
    ap.add_argument("--out", default=str(OUT / "dll8_v2.json"))
    args = ap.parse_args()

    cfgs = []
    corners = args.corners.split(",")
    if args.cmd == "diag":
        nf = [int(x) for x in args.nfixed.split(",")]
        for n in nf:
            for c in corners:
                cfgs.append(dict(corner=c, code=0, nelem=1, mode="pulse",
                                 nfixed=n, scheme=args.scheme, driver=args.driver,
                                 wire=True, period=None))
    else:
        codes = ([int(x) for x in args.codes.split(",")] if args.codes
                 else list(range(128)))
        for ne in [int(x) for x in args.nelem.split(",")]:
            for c in corners:
                for code in codes:
                    cfgs.append(dict(corner=c, code=code, nelem=ne,
                                     mode=args.mode, nfixed=-1,
                                     scheme=args.scheme, driver=args.driver, wire=True,
                                     period=(args.period or None), ncyc=3))
    def go(cfg):
        try:
            return run_one(cfg)
        except Exception as ex:
            import traceback
            return {**cfg, "error": repr(ex), "trace": traceback.format_exc()[-800:]}
    with ThreadPoolExecutor(args.jobs) as ex:
        res = list(ex.map(go, cfgs))
    OUT.mkdir(parents=True, exist_ok=True)
    json.dump(res, open(args.out, "w"), indent=1)
    for r in res:
        if "error" in r:
            print("ERR", r)
        elif "delay_ps" in r:
            print(f"{r['nelem']}e {r['corner']} c{r['code']:03d} n{r.get('nfixed',-1)}: "
                  f"delay={r['delay_ps'] and round(r['delay_ps'],1)} "
                  f"fall={r['delay_fall_ps'] and round(r['delay_fall_ps'],1)} "
                  f"asym={r.get('tpHL_minus_tpLH') and round(r['tpHL_minus_tpLH'],1)}")
        else:
            print(f"{r['nelem']}e {r['corner']} c{r['code']:03d}: duty={r.get('duty_pct')}")


if __name__ == "__main__":
    main()
