#!/usr/bin/env python3
"""Standard-cell switched-cap finger evaluation for the DLL8 delay element.

Measurement only.  Candidate finger as requested:

    MID --[sg13g2_ebufn_4]-- X --[input of sg13g2_inv_16]   (the cap)

IMPORTANT MEASURED RESULT: `sg13g2_ebufn_4` is a tri-state *buffer* (Z = A),
not a series switch.  Its output X is an actively driven copy of MID, so the
load-inverter gate capacitance on X never loads MID.  Measured switched
contrast is 0.00-0.02 ps at every corner/cap size.  `sg13g2_mux2_*` was also
checked (0.43 ps at TT) and is likewise actively driven, not a pass gate.

The harness therefore also supports a real CMOS transmission gate built from
the same PDK devices (`switch=tg`) to measure what a corrected pass cell would
give, plus `tgideal` (behavioural switch) as a physics check.

The element is the stock two-inv_4 DLL8 element (INVX4 -> mid -> INVX4) with
the same 0.96 fF/node wire cap used by dll8_pex2.py.  Corners, OSDI
PSP103-NQS models, pulse/square measurement and the wrdata parsing are taken
from the reference harness flow/characterization/dll8_pex2.py.

Commands
  cal       delay vs known Cmid -> ps/fF sensitivity (to infer fF swing)
  contrast  delay with finger ON vs tri-stated, per termination/cap size
  residual  transient enable->disable: X/Y state, off capacitance vs absent
  bank      N-finger thermometer range / monotonicity / LSB
  power     average supply power, square wave, per termination/state
  crowbar   DC current of the cap inverter forced to a bias (X mid-rail risk)
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path("/grid/adpll_gen")
sys.path.insert(0, str(ROOT / "flow/characterization"))
import dll8_pex2 as ref  # noqa: E402  (shared corners/paths/measure)

HERE = ROOT / "flow/characterization/stdcell_finger"
WORK = Path(os.environ.get("STDCELL_FINGER_WORK", "/tmp/opencode/stdcell_finger/decks"))
OUT = Path(os.environ.get("STDCELL_FINGER_OUT", str(HERE)))

CORNERS = ref.CORNERS
WIRE_FF = ref.WIRE_FF
CAPCELLS = {"inv_4": "sg13g2_inv_4", "inv_8": "sg13g2_inv_8",
            "inv_16": "sg13g2_inv_16"}
EBUFN = {"2": "sg13g2_ebufn_2", "4": "sg13g2_ebufn_4", "8": "sg13g2_ebufn_8"}


# --------------------------------------------------------------------- netlist
def finger(tag: str, en: str, enb: str, mid: str, cap: str, term: str,
           switch: str) -> list[str]:
    x, y = f"x_{tag}", f"y_{tag}"
    if switch == "ebufn":
        s = [f"Xsw_{tag} {x} {mid} {enb} VDD VSS sg13g2_ebufn_4"]
    elif switch == "tg":
        # real CMOS transmission gate (PDK devices, the intended ebufn pass
        # path if it were brought out as a passive cell)
        s = [f"Xtn_{tag} {x} {en} {mid} VSS sg13_lv_nmos w=2.96u l=130n",
             f"Xtp_{tag} {x} {enb} {mid} VDD sg13_lv_pmos w=4.48u l=130n"]
    elif switch == "tgideal":
        s = [f"Ssw_{tag} {x} {mid} {en} 0 SWMOD"]
    elif switch == "mux":
        # A0=MID (selected when S=0), A1=VSS.  If mux2 were pass-gate based
        # the cap on X would load MID when S=0.
        s = [f"Xsw_{tag} {x} {mid} VSS {en} VDD VSS sg13g2_mux2_1"]
    else:
        raise ValueError(switch)
    s.append(f"Xcap_{tag} {y} {x} VDD VSS {cap}")
    if term == "load":          # (a) small fixed load on the inverter output
        s.append(f"Xld_{tag} z_{tag} {y} VDD VSS sg13g2_inv_1")
    elif term == "res":         # (b) output pulled to VDD via a large resistor
        s.append(f"Rt_{tag} {y} VDD 1G")
    elif term == "resgnd":      # (b') same, to VSS
        s.append(f"Rt_{tag} {y} VSS 1G")
    elif term == "diode":       # (c) input-drain shorted (2-terminal)
        s.append(f"Vd_{tag} {y} {x} 0")
    elif term == "open":
        pass
    else:
        raise ValueError(term)
    return s


def flat_lines(cfg) -> list[str]:
    """Emit the two-inv element + all fingers at the top level (nodes global)."""
    s = ["Xinv_in mid IN VDD VSS sg13g2_inv_4",
         "Xinv_out OUT mid VDD VSS sg13g2_inv_4",
         f"Cmid mid 0 {cfg['cmid']:.6g}f"]
    cap = CAPCELLS[cfg.get("capcell", "inv_16")]
    switch = cfg.get("switch", "ebufn")
    for k, on in enumerate(cfg["states"]):
        s += finger(f"f{k}", f"en{k}", f"enb{k}", "mid", cap,
                    cfg.get("term", "load"), switch)
    return s


def control_sources(cfg) -> list[str]:
    s = []
    for k, on in enumerate(cfg["states"]):
        sw = cfg.get("switch", "ebufn")
        if sw == "ebufn":
            # ebufn TE_B is active low: enabled = 0 V, tri-stated = VDD
            s.append(f"venb{k} enb{k} 0 DC={0.0 if on else cfg['_vdd']}")
            s.append(f"ven{k} en{k} 0 DC=0")
        else:
            # TG / ideal switch: en high = on
            s.append(f"ven{k} en{k} 0 DC={cfg['_vdd'] if on else 0.0}")
            s.append(f"venb{k} enb{k} 0 DC={0.0 if on else cfg['_vdd']}")
        if cfg.get("switch") == "mux":
            # mux2: X=A0 when S=0 -> on = S low
            s[-2] = f"ven{k} en{k} 0 DC={0.0 if on else cfg['_vdd']}"
    return s


def deck(cfg, mode: str, extra_ctl: list[str] | None = None) -> str:
    c = CORNERS[cfg["corner"]]
    vdd = c["vdd"]
    cfg["_vdd"] = vdd
    lines = [f"* stdcell finger {cfg.get('name','')} corner={cfg['corner']} "
             f"term={cfg.get('term')} cap={cfg.get('capcell')} mode={mode}",
             f".TEMP {c['temp']}",
             f'.LIB "{ref.CORNER_MOS}" {c["mos"]}',
             f'.inc "{ref.CELLS}"',
             ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12 "
             "TRTOL=15 ITL4=30",
             f"vvdd VDD 0 DC={vdd}", "vvss VSS 0 DC=0"]
    if mode == "pulse":
        t_fall = cfg.get("t_fall", 4.0)
        lines.append(ref.pwl_pulse(vdd, t_fall))
        stop = t_fall + 1.5
        lines.append(f".TRAN {cfg.get('dt','2p')} {stop:.4g}n")
    elif mode == "square":
        p = cfg.get("period", 2.0)
        ncyc = cfg.get("ncyc", 6)
        lines.append(ref.pwl_square(p, vdd, ncyc))
        stop = p * (ncyc + 1)
        lines.append(f".TRAN {cfg.get('dt','2p')} {stop:.4g}n")
    lines += flat_lines(cfg)
    if cfg.get("switch") == "tgideal":
        lines.append(".model SWMOD SW(Ron=50 Roff=1e12 Vt=0.5 Vh=0)")
    lines += control_sources(cfg)
    if extra_ctl:
        lines += extra_ctl
    lines += [".control", "set filetype=ascii", "run"]
    if mode == "pulse":
        lines.append("wrdata tran.out v(IN) v(OUT)")
    else:
        lines.append("wrdata tran.out v(IN) v(OUT) i(vvdd)")
    lines += ["quit", ".endc", ".end"]
    return "\n".join(lines)


def write_and_run(cfg, mode, extra_ctl=None, extra_files=None, dt="2p"):
    d = WORK / cfg["name"]
    d.mkdir(parents=True, exist_ok=True)
    cfg = dict(cfg)
    cfg.setdefault("dt", dt)
    (d / "top.sp").write_text(deck(cfg, mode, extra_ctl))
    (d / ".spiceinit").write_text(
        f"set num_threads=1\nosdi {ref.OSDI.resolve()}\n"
        f"osdi {ref.OSDI_NQS.resolve()}\n")
    raw = d / "tran.out"
    if not raw.exists() or os.environ.get("STDCELL_FINGER_RERUN"):
        subprocess.run(["bash", "-lc",
                        f"ulimit -v 4000000; ngspice -b top.sp"],
                       cwd=d, check=True, stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL)
    return d, raw


# ------------------------------------------------------------------- measuring
def parse_multi(path: Path):
    """ngspice wrdata with N vectors: columns are (scale, val) repeated."""
    cols = []
    for line in path.read_text().split("\n"):
        if not line.strip():
            continue
        t = [float(x) for x in line.split()]
        if not cols:
            cols = [[] for _ in range(len(t))]
        for j, v in enumerate(t):
            cols[j].append(v)
    return cols[0], cols


def meas_delay(raw: Path) -> dict:
    return ref.measure(dict(corner="tt", code=0, nelem=1, mode="pulse"), raw)


def meas_square(raw: Path, vdd: float, period_ns: float, ncyc: int,
                skip_cycles: int = 2) -> dict:
    t, cols = parse_multi(raw)
    # vectors: v(IN)=col1, v(OUT)=col3, i(vvdd)=col5
    i_vdd = cols[5]
    out = cols[3]
    p_s = period_ns * 1e-9
    t0 = skip_cycles * p_s
    t1 = (ncyc - 1) * p_s
    pw, n = 0.0, 0
    # trapezoidal average of VDD * (-i(vvdd)) over (t0,t1)
    for k in range(1, len(t)):
        if t[k] < t0 or t[k-1] > t1:
            continue
        dt = t[k] - t[k-1]
        pav = 0.5 * (i_vdd[k] + i_vdd[k-1])
        pw += -vdd * pav * dt
        n += 1
    span = t1 - t0
    hi = lo = 0.0
    pt = pv = None
    thr = 0.5 * vdd
    for tt, vv in zip(t, out):
        if tt < t0 or tt > t1:
            pt, pv = tt, vv
            continue
        if pt is not None:
            if (pv + vv) * 0.5 > thr:
                hi += tt - pt
            else:
                lo += tt - pt
        pt, pv = tt, vv
    return dict(power_w=(pw / span if span > 0 else None),
                duty_pct=100.0 * hi / (hi + lo) if hi + lo > 0 else None,
                avg_i_a=(pw / span / vdd if span > 0 else None))


def dc_state(raw: Path, t_end_ps: float, last_ps: float = 20.0):
    t, cols = parse_multi(raw)
    # v(IN), v(OUT) only in pulse mode; caller may add more vectors separately
    return t, cols


# ----------------------------------------------------------------- modes/cases
def case_cal(corner, cmid):
    return dict(name=f"cal_{corner}_{cmid:g}f", corner=corner, cmid=cmid,
                states=[], term="open", capcell="inv_16", t_fall=4.0)


def run_cal(args):
    cmids = [float(x) for x in args.cmid.split(",")]
    cfgs = [case_cal(c, v) for c in args.corners.split(",") for v in cmids]
    def go(cfg):
        try:
            d, raw = write_and_run(cfg, "pulse")
            r = meas_delay(raw)
            return {**{k: v for k, v in cfg.items() if k != "_vdd"},
                    "delay_ps": r.get("delay_ps"),
                    "delay_fall_ps": r.get("delay_fall_ps")}
        except Exception as ex:
            return {**{k: v for k, v in cfg.items() if k != "_vdd"}, "error": repr(ex)}
    with ThreadPoolExecutor(args.jobs) as ex:
        res = list(ex.map(go, cfgs))
    return res


def case_contrast(corner, term, capcell, switch):
    return dict(name=f"ctr_{corner}_{term}_{capcell}_{switch}", corner=corner,
                cmid=0.96, states=[True], term=term, capcell=capcell,
                switch=switch, t_fall=4.0)


def run_contrast(args):
    terms = args.terms.split(",")
    caps = args.caps.split(",")
    switches = args.switch.split(",")
    cfgs = []
    for c in args.corners.split(","):
        for term in terms:
            for cap in caps:
                for sw in switches:
                    cfgs.append(case_contrast(c, term, cap, sw))
                    cfgs.append(dict(case_contrast(c, term, cap, sw),
                                     name=f"ctr_{c}_{term}_{cap}_{sw}_off",
                                     states=[False]))
    def go(cfg):
        try:
            d, raw = write_and_run(cfg, "pulse")
            r = meas_delay(raw)
            return {**{k: v for k, v in cfg.items() if k != "_vdd"},
                    "delay_ps": r.get("delay_ps"),
                    "delay_fall_ps": r.get("delay_fall_ps"),
                    "rise_ps": r.get("rise_10_90_ps"),
                    "fall_ps": r.get("fall_10_90_ps")}
        except Exception as ex:
            return {**{k: v for k, v in cfg.items() if k != "_vdd"}, "error": repr(ex)}
    with ThreadPoolExecutor(args.jobs) as ex:
        res = list(ex.map(go, cfgs))
    return res


def case_power(corner, term, capcell, switch, on):
    return dict(name=f"pwr_{corner}_{term}_{capcell}_{switch}_{'on' if on else 'off'}",
                corner=corner, cmid=0.96, states=[on], term=term,
                capcell=capcell, switch=switch, period=2.0, ncyc=6)


def run_power(args):
    caps = args.caps.split(",")
    terms = args.terms.split(",")
    cfgs = []
    for c in args.corners.split(","):
        for term in terms:
            for cap in caps:
                for on in (False, True):
                    cfgs.append(case_power(c, term, cap, args.switch, on))
    # plus no-finger baseline
    for c in args.corners.split(","):
        cfgs.append(dict(name=f"pwr_{c}_none", corner=c, cmid=0.96, states=[],
                         term="open", capcell="inv_16", period=2.0, ncyc=6))
    def go(cfg):
        try:
            d, raw = write_and_run(cfg, "square")
            r = meas_square(raw, CORNERS[cfg["corner"]]["vdd"],
                            cfg["period"], cfg["ncyc"])
            return {**{k: v for k, v in cfg.items() if k != "_vdd"}, **r}
        except Exception as ex:
            return {**{k: v for k, v in cfg.items() if k != "_vdd"}, "error": repr(ex)}
    with ThreadPoolExecutor(args.jobs) as ex:
        res = list(ex.map(go, cfgs))
    return res


def case_crowbar(corner, bias_frac, capcell="inv_16"):
    return dict(name=f"cb_{corner}_{bias_frac:g}_{capcell}", corner=corner,
                bias_frac=bias_frac, capcell=capcell)


def run_crowbar(args):
    cfgs = [case_crowbar(c, float(b), args.capcell)
            for c in args.corners.split(",") for b in args.bias.split(",")]
    def go(cfg):
        c = CORNERS[cfg["corner"]]
        vdd = c["vdd"]
        d = WORK / cfg["name"]
        d.mkdir(parents=True, exist_ok=True)
        # a bare inverter with its input forced to bias, measure supply current
        txt = "\n".join([
            f"* crowbar corner={cfg['corner']} bias={cfg['bias_frac']}",
            f".TEMP {c['temp']}",
            f'.LIB "{ref.CORNER_MOS}" {c["mos"]}',
            f'.inc "{ref.CELLS}"',
            ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12",
            f"vvdd VDD 0 DC={vdd}", "vvss VSS 0 DC=0",
            f"vx x 0 DC={vdd*cfg['bias_frac']:.6g}",
            f"Xcap y x VDD VSS {CAPCELLS[cfg['capcell']]}",
            ".control", "op", "print i(vvdd)", "quit", ".endc", ".end"])
        (d / "top.sp").write_text(txt)
        (d / ".spiceinit").write_text(
            f"set num_threads=1\nosdi {ref.OSDI.resolve()}\n"
            f"osdi {ref.OSDI_NQS.resolve()}\n")
        out = subprocess.run(["bash", "-lc",
                              "ulimit -v 4000000; ngspice -b top.sp"],
                             cwd=d, capture_output=True, text=True).stdout
        cur = None
        for line in out.split("\n"):
            if "i(vvdd)" in line and "=" in line:
                try:
                    cur = float(line.split("=")[-1])
                except ValueError:
                    pass
        return {**{k: v for k, v in cfg.items()}, "i_vdd_a": cur}
    with ThreadPoolExecutor(args.jobs) as ex:
        res = list(ex.map(go, cfgs))
    return res


def case_bank(corner, n_total, n_on, capcell, term, switch):
    return dict(name=f"bank_{corner}_{n_total}_{n_on}_{capcell}_{term}_{switch}",
                corner=corner, cmid=0.96, states=[k < n_on for k in range(n_total)],
                term=term, capcell=capcell, switch=switch,
                t_fall=6.0, n_total=n_total, n_on=n_on)


def run_bank(args):
    caps = args.caps.split(",")
    terms = args.terms.split(",")
    switches = args.switch.split(",")
    counts = [int(x) for x in args.non.split(",")]
    n_total = args.ntotal
    cfgs = []
    for c in args.corners.split(","):
        for cap in caps:
            for term in terms:
                for sw in switches:
                    for n in counts:
                        cfgs.append(case_bank(c, n_total, n, cap, term, sw))
    def go(cfg):
        try:
            d, raw = write_and_run(cfg, "pulse")
            r = meas_delay(raw)
            return {**{k: v for k, v in cfg.items() if k != "_vdd"},
                    "delay_ps": r.get("delay_ps"),
                    "delay_fall_ps": r.get("delay_fall_ps")}
        except Exception as ex:
            return {**{k: v for k, v in cfg.items() if k != "_vdd"}, "error": repr(ex)}
    with ThreadPoolExecutor(args.jobs) as ex:
        res = list(ex.map(go, cfgs))
    return res


def resid_deck(cfg) -> tuple[str, str]:
    """Enable for t<t_dis, then tri-state; keep driving the element."""
    c = CORNERS[cfg["corner"]]
    vdd = c["vdd"]
    x, y = "x_f0", "y_f0"
    vdd_period = cfg.get("period", 2.0)
    ncyc = cfg.get("ncyc", 8)
    sw = cfg.get("switch", "tg")
    lines = [f"* residual {cfg['name']}",
             f".TEMP {c['temp']}",
             f'.LIB "{ref.CORNER_MOS}" {c["mos"]}',
             f'.inc "{ref.CELLS}"',
             ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12 TRTOL=15 ITL4=30",
             f"vvdd VDD 0 DC={vdd}", "vvss VSS 0 DC=0",
             ref.pwl_square(vdd_period, vdd, ncyc),
             "Xinv_in mid IN VDD VSS sg13g2_inv_4",
             "Xinv_out OUT mid VDD VSS sg13g2_inv_4",
             "Cmid mid 0 0.96f",
             f"Xcap_f0 {y} {x} VDD VSS sg13g2_inv_16"]
    t_dis = cfg["t_dis"]
    if sw == "ebufn":
        lines += [f"Xsw_f0 {x} mid enb0 VDD VSS sg13g2_ebufn_4",
                  f"venb0 enb0 0 PWL(0 0 {t_dis:.4g}n 0 {t_dis+0.02:.4g}n 0 "
                  f"{t_dis+0.04:.4g}n {vdd})"]
    elif sw == "tg":
        lines += [f"Xtn_f0 {x} en0 mid VSS sg13_lv_nmos w=2.96u l=130n",
                  f"Xtp_f0 {x} enb0 mid VDD sg13_lv_pmos w=4.48u l=130n",
                  f"ven0 en0 0 PWL(0 {vdd} {t_dis:.4g}n {vdd} "
                  f"{t_dis+0.02:.4g}n 0)",
                  f"venb0 enb0 0 PWL(0 0 {t_dis:.4g}n 0 "
                  f"{t_dis+0.02:.4g}n {vdd})"]
    stop = vdd_period * (ncyc + 1)
    lines += [".control", "set filetype=ascii", "run",
              f"wrdata tran.out v(IN) v(OUT) v({x}) v({y}) i(vvdd)",
              "quit", ".endc", f".TRAN 2p {stop:.4g}n", ".end"]
    return "\n".join(lines), x


def run_resid(args):
    periods = [float(x) for x in args.periods.split(",")]
    cfgs = []
    for c in args.corners.split(","):
        for sw in args.switch.split(","):
            for tdis in periods:
                cfgs.append(dict(name=f"resid_{c}_{sw}_td{tdis:g}", corner=c,
                                 switch=sw, t_dis=tdis, period=2.0, ncyc=8))
    def go(cfg):
        d = WORK / cfg["name"]
        d.mkdir(parents=True, exist_ok=True)
        txt, x = resid_deck(cfg)
        (d / "top.sp").write_text(txt)
        (d / ".spiceinit").write_text(
            f"set num_threads=1\nosdi {ref.OSDI.resolve()}\n"
            f"osdi {ref.OSDI_NQS.resolve()}\n")
        raw = d / "tran.out"
        if not raw.exists() or os.environ.get("STDCELL_FINGER_RERUN"):
            subprocess.run(["bash", "-lc", "ulimit -v 4000000; ngspice -b top.sp"],
                           cwd=d, check=True, stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL)
        t, cols = parse_multi(raw)
        vx, vy, iv = cols[5], cols[7], cols[9]
        t_dis = cfg["t_dis"] * 1e-9
        # post-disable window: skip 50 ps settling, look at remaining cycles
        idx = [k for k in range(len(t)) if t[k] > t_dis + 0.05e-9]
        post = dict(
            x_end=vx[-1], x_min=min(vx[k] for k in idx),
            x_max=max(vx[k] for k in idx),
            y_end=vy[-1], y_min=min(vy[k] for k in idx),
            y_max=max(vy[k] for k in idx),
            x_midrail_frac=sum(0.3 * CORNERS[cfg["corner"]]["vdd"] < vx[k]
                               < 0.7 * CORNERS[cfg["corner"]]["vdd"]
                               for k in idx) / max(1, len(idx)),
            i_vdd_end=iv[-1])
        # crowbar: average supply current over post-disable
        return {**{k: v for k, v in cfg.items()}, **post}
    with ThreadPoolExecutor(args.jobs) as ex:
        res = list(ex.map(go, cfgs))
    return res


def run_ac(args):
    """Small-signal capacitance at the mid node (bias=0.5 VDD), finger ON/OFF,
    versus no finger, to get an explicit fF for the switched load."""
    caps = args.caps.split(",")
    switches = args.switch.split(",")
    cfgs = []
    for c in args.corners.split(","):
        for cap in caps:
            cfgs.append(dict(name=f"ac_{c}_{cap}_none", corner=c, capcell=cap,
                             switch="none", on=0))
            for sw in switches:
                for on in (0, 1):
                    cfgs.append(dict(name=f"ac_{c}_{cap}_{sw}_{'on' if on else 'off'}",
                                     corner=c, capcell=cap, switch=sw, on=on))
    def go(cfg):
        c = CORNERS[cfg["corner"]]
        vdd = c["vdd"]
        d = WORK / cfg["name"]
        d.mkdir(parents=True, exist_ok=True)
        lines = [f"* ac cap {cfg['name']}",
                 f".TEMP {c['temp']}",
                 f'.LIB "{ref.CORNER_MOS}" {c["mos"]}',
                 f'.inc "{ref.CELLS}"',
                 ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12",
                 f"vvdd VDD 0 DC={vdd}", "vvss VSS 0 DC=0",
                 f"Vmid mid 0 DC={0.5*vdd:.6g} AC=1",
                 "Xinv_out OUT mid VDD VSS sg13g2_inv_4",
                 "Cmid mid 0 0.96f",
                 "Rout OUT 0 1G"]
        sw = cfg["switch"]
        if sw == "tg":
            lines += ["Xtn x en mid VSS sg13_lv_nmos w=2.96u l=130n",
                      "Xtp x enb mid VDD sg13_lv_pmos w=4.48u l=130n",
                      "Xcap y x VDD VSS " + CAPCELLS[cfg["capcell"]],
                      f"ven en 0 DC={vdd if cfg['on'] else 0.0}",
                      f"venb enb 0 DC={0.0 if cfg['on'] else vdd}",
                      "Rx x 0 1G"]
        elif sw == "ebufn":
            lines += ["Xsw x mid enb VDD VSS sg13g2_ebufn_4",
                      "Xcap y x VDD VSS " + CAPCELLS[cfg["capcell"]],
                      f"venb enb 0 DC={0.0 if cfg['on'] else vdd}"]
        elif sw == "mux":
            lines += ["Xsw x mid VSS en VDD VSS sg13g2_mux2_1",
                      "Xcap y x VDD VSS " + CAPCELLS[cfg["capcell"]],
                      f"ven en 0 DC={0.0 if cfg['on'] else vdd}"]
        lines += [".control", "set filetype=ascii",
                  "ac lin 1 1e6 1e6",
                  "print imag(i(vmid))", "quit", ".endc", ".end"]
        (d / "top.sp").write_text("\n".join(lines))
        (d / ".spiceinit").write_text(
            f"set num_threads=1\nosdi {ref.OSDI.resolve()}\n"
            f"osdi {ref.OSDI_NQS.resolve()}\n")
        out = subprocess.run(["bash", "-lc",
                              "ulimit -v 4000000; ngspice -b top.sp"],
                             cwd=d, capture_output=True, text=True).stdout
        val = None
        for line in out.split("\n"):
            if "imag(i(vmid))" in line and "=" in line:
                try:
                    val = float(line.split("=")[-1])
                except ValueError:
                    pass
        return {**cfg, "imag_i": val}
    with ThreadPoolExecutor(args.jobs) as ex:
        res = list(ex.map(go, cfgs))
    return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["cal", "contrast", "power", "crowbar",
                                    "bank", "resid", "ac"])
    ap.add_argument("--corners", default="ss,tt,ff")
    ap.add_argument("--cmid", default="0,5,10,20,40,80")
    ap.add_argument("--terms", default="load,res,diode,open")
    ap.add_argument("--caps", default="inv_16")
    ap.add_argument("--switch", default="ebufn,tg",
                    help="comma list: ebufn, tg, tgideal")
    ap.add_argument("--non", default="0,1,2,4,8,16,32")
    ap.add_argument("--ntotal", type=int, default=32)
    ap.add_argument("--periods", default="5,5.25,5.5,5.75",
                    help="disable time (ns) sweep for residual")
    ap.add_argument("--bias", default="0,0.25,0.5,0.75,1.0")
    ap.add_argument("--capcell", default="inv_16")
    ap.add_argument("--jobs", type=int, default=8)
    ap.add_argument("--out", default="")
    args = ap.parse_args()
    fn = {"cal": run_cal, "contrast": run_contrast,
          "power": run_power, "crowbar": run_crowbar,
          "bank": run_bank, "resid": run_resid, "ac": run_ac}[args.cmd]
    res = fn(args)
    out = Path(args.out) if args.out else OUT / f"{args.cmd}.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    json.dump(res, open(out, "w"), indent=1)
    for r in res:
        if "error" in r:
            print("ERR", r.get("name"), r["error"])
        elif args.cmd == "cal":
            print(f"{r['corner']} Cmid={r['cmid']:g}f delay={r.get('delay_ps')}")
        elif args.cmd == "contrast":
            print(f"{r.get('name')}: delay={r.get('delay_ps')}")
        elif args.cmd == "power":
            print(f"{r.get('name')}: P={r.get('power_w')}")
        elif args.cmd == "crowbar":
            print(f"{r.get('name')}: I={r.get('i_vdd_a')}")
        elif args.cmd == "bank":
            print(f"{r.get('name')}: delay={r.get('delay_ps')}")
        elif args.cmd == "resid":
            print(f"{r.get('name')}: x_end={r.get('x_end')} "
                  f"x_min={r.get('x_min')} x_max={r.get('x_max')} "
                  f"midfrac={r.get('x_midrail_frac')} y_end={r.get('y_end')}")
        elif args.cmd == "ac":
            print(f"{r.get('name')}: imag_i={r.get('imag_i')}")


if __name__ == "__main__":
    main()
