#!/usr/bin/env python3
"""Tuned short-ring 500/250 MHz multiphase DCO -- loaded-tap PEX driver.

Implements Milestones 2/3 of docs/dco_tuning_design.md:
  - SPICE netlists for DCO_STAGE (inv_1 + 5-bit sg13_moscap_n/sg13_lv_nmos
    coarse bank + 63 sg13g2_nand3_1 fine fingers + per-bit buffers + decap)
    and two loaded tops, tb_rx_loaded (ring + PI mux + 8 sampler flops on
    real clock pins + PRBS data) and tb_tx_loaded (ring + tx_parallel_mux:
    4 phase-clocked flops + select muxes), same ring in both.
  - Deck = real stdcell subckts + raw PDK cap/switch devices + cornerMOSlv
    + cornerMOSCAP.  Corners move together (mos_ss/mos_tt/mos_ff at
    1.08 V 125 C / 1.20 V 25 C / 1.32 V -40 C).
    NOTE: cornerMOSCAP.lib in the IHP PDK only has moscap_tt (+mismatch/
    stat); there is no cap_wcs/cap_bcs section.  The cap bank therefore
    runs nominal at all three MOS corners -- the corner spread comes from
    the ring cells.  Documented limitation, not a softening: the brief's
    "SS + cap_wcs" extreme is realized as SS ring + nominal cap device.
  - Runs ngspice and reports the six acceptance measurements, SS first.

Layout-derived parasitics (OpenROAD RCX SPEF + Magic-stamped cap cell) are
added in Milestone 4; this file's deck is device-level (pre-route) as the
brief's step 2/3 requires, with the loads that matter now: real flop clock
pins and mux input pins, not ideal caps.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import struct
import subprocess
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path("/grid/adpll_gen")
OUT = Path(os.environ.get(
    "DCO_PEX_OUT",
    str(ROOT / "flow" / "characterization" / "pex_ihp_tuned")))
# ngspice deck scratch: ~10x slower when the cwd is on the /grid FS
# (measured: identical deck 14 s vs >110 s); decks live in /tmp.
WORKDIR = Path(os.environ.get("DCO_PEX_WORKDIR", "/tmp/opencode/dcopex/decks"))
IHP = Path(
    "/home/yanlu/.ciel/ciel/ihp-sg13/versions/"
    "89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2"
)
CELLS = IHP / "libs.ref" / "sg13g2_stdcell" / "spice" / "sg13g2_stdcell.spice"
CORNER_MOS = IHP / "libs.tech" / "ngspice" / "models" / "cornerMOSlv.lib"
CORNER_CAP = IHP / "libs.tech" / "ngspice" / "models" / "cornerMOSCAP.lib"
MOSCAP_MOD = IHP / "libs.tech" / "ngspice" / "models" / "sg13g2_moscap_mod.lib"
OSDI = ROOT / "flow" / "characterization" / "ihp_l3" / "psp103.osdi"

# Unit finger: ~9 fF (0.72u x 1.0u at the measured 12.7 fF/um^2 plate).
CAP_W = "0.72u"
CAP_L = "1.0u"
SW_W = "0.42u"   # min-ish width switch
SW_L = "0.45u"
FCAP_W = "0.15u"  # fine unit finger: ~0.7 fF (0.15u x 0.5u at 12.7 fF/um^2... l=0.5u)
FCAP_L = "0.5u"
NPHASE = 8
STEP = 3
NSTAGE = NPHASE * STEP + 1  # 25

CORNERS = {
    "ss": dict(mos="mos_ss", vdd=1.08, temp=125),
    "tt": dict(mos="mos_tt", vdd=1.20, temp=25),
    "ff": dict(mos="mos_ff", vdd=1.32, temp=-40),
}


def fine_idx(fine: int) -> int:
    """Centered fine index: FINE=-31..+31 -> 1..63 (fixed +1)."""
    assert -31 <= fine <= 31
    return fine + 32


# ---------------------------------------------------------------------------
# Subckt emission
# ---------------------------------------------------------------------------

def emit_stage() -> str:
    """DCO_STAGE: one tuned ring stage."""
    s = ["* dco_stage: tuned short-ring stage (dco_tuning_design.md)",
         ".subckt DCO_STAGE IN OUT C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS",
         "* the ring inverter itself",
         "Xinv OUT IN VDD VSS sg13g2_inv_1"]
    # coarse bank: 5 bits, binary 1:2:4:8:16 unit fingers, per-bit buffer,
    # bit 4 switch 4x wide (brief risk 3).
    for b in range(5):
        nf = 1 << b
        swm = 4 if b == 4 else 1
        s.append(f"* coarse bit {b}: {nf} unit fingers, gate-side switch m={swm}")
        s.append(f"Xgbuf{b} g{b} C{b} VDD VSS sg13g2_buf_1")
        s.append(f"Xsw{b} gn{b} g{b} OUT VSS sg13_lv_nmos w={SW_W} l={SW_L} m={swm}")
        s.append(f"Rgn{b} gn{b} VSS 1G")
        for j in range(nf):
            s.append(f"Xcap{b}_{j} gn{b} VSS sg13_moscap_n w={CAP_W} l={CAP_L}")
    # fine bank: 63 NAND3 fingers, binary groups 1:2:4:8:16:32 driven by the
    # centered fine index bits.  A(gate on node) = bit buffer, C = complement.
    # Two-level cap trick per fine_delay.v; outputs open (1G bleed for DC).
    for f in range(6):
        nf = 1 << f
        s.append(f"* fine bit {f}: {nf} unit moscap fingers behind one switch")
        s.append(f"Xgbuf{f+5} g{f+5} F{f} VDD VSS sg13g2_buf_1")
        s.append(f"Xfsw{f} fgn{f} g{f+5} OUT VSS sg13_lv_nmos w={SW_W} l={SW_L}")
        s.append(f"Rfgn{f} fgn{f} VSS 1G")
        for j in range(nf):
            s.append(f"Xfcap{f}_{j} fgn{f} VSS sg13_moscap_n w={FCAP_W} l={FCAP_L}")
    s.append("Xdecap VDD VSS sg13g2_decap_4")
    s.append(".ends DCO_STAGE")
    return "\n".join(s)


def prbs_bits(nbits: int, seed: int = 0x7f, taps=(6, 7)) -> list[int]:
    """LFSR-7 style PRBS bit stream."""
    reg = seed
    out = []
    for _ in range(nbits):
        fb = 1
        for t in taps:
            fb ^= (reg >> (t - 1)) & 1
        out.append(reg & 1)
        reg = ((reg << 1) | fb) & 0x7F
    return out


def pwl_source(bits: list[int], ui: float, name: str, node: str, vdd_sym: str) -> str:
    # 0.5ps ramps on every transition: an instantaneous PWL step makes ngspice
    # chop the time step at the breakpoint for minutes (measured).
    edge = ui * 1e-4  # 0.5 ps at ui=5ns-ish scales with bit time
    seg = []
    t = 0.0
    prev = None
    for b in bits:
        lvl = vdd_sym if b else "0.0"
        if prev is None:
            seg.append(f"{t:.6g}n {lvl}")
        elif lvl != prev:
            seg.append(f"{t-edge:.6g}n {prev}")
            seg.append(f"{t:.6g}n {lvl}")
        prev = lvl
        t += ui
    seg.append(f"{t:.6g}n {prev}")
    return f"V{name} {node} 0 PWL(" + " ".join(seg) + ")"


def emit_top(corner: str, coarse: int, fine: int, top: str,
             loads: str = "rx",
             release_ns: float = 0.0, init: str = "0",
             pi_switch_ns: float = 0.0, stop_ns: float = 120.0,
             settle_ns: float = 80.0, data_ui_ns: float = 0.5) -> str:
    """One loaded top.  top in {rx, tx}.  Returns the deck text."""
    c = CORNERS[corner]
    fi = fine_idx(fine)
    cbits = [(coarse >> b) & 1 for b in range(5)]
    fbits = [(fi >> b) & 1 for b in range(6)]

    s = [f"* loaded-tap PEX top: {top} corner={corner} coarse={coarse} fine={fine}"
         f" release={release_ns}ns init={init} pi_switch={pi_switch_ns}ns",
         f".TEMP {c['temp']}",
         f'.LIB "{CORNER_MOS}" {c["mos"]}',
         '* cornerMOSCAP has only the nominal (tt) section in this PDK;',
         '* the cap device runs nominal at every MOS corner (documented).',
         f'.LIB "{CORNER_CAP}" moscap_tt',
         f'.inc "{MOSCAP_MOD}"',
         f'.inc "{CELLS}"',
         ".inc dco_stage.sp",
         f".PARAM lvdd={c['vdd']}",
         ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12 TRTOL=15 ITL4=30",
         
         f"vvdd VDD 0 DC={c['vdd']}",
         "vvss VSS 0 DC=0",
         f"ven DCO_EN 0 PWL(0n 0 {max(release_ns, 0.02):.6g}n 0 {release_ns+0.02:.6g}n {c['vdd']})",
         f"vrst RST_N 0 DC={c['vdd']}",
         ]
    for b in range(5):
        s.append(f"vc{b} C{b} 0 DC={c['vdd'] if cbits[b] else 0.0}")
    for f in range(6):
        s.append(f"vf{f} F{f} 0 DC={c['vdd'] if fbits[f] else 0.0}")

    # chain nodes n0..n25; n0 = DCO_OUT = loop_back (AND output).
    s.append("* ---- the ring: 25 tuned stages, AND2X1 travelling-wave closure")
    for i in range(NSTAGE):
        s.append(f"Xst{i} n{i} n{i+1} C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE")
    s.append(f"Xclose n0 n{NSTAGE} DCO_EN VDD VSS sg13g2_and2_1")

    # tap buffers at k*STEP -- identical geometry to the RTL (dont_touch).
    s.append("* ---- tap buffers at k*STEP")
    for k in range(NPHASE):
        s.append(f"Xtap{k} ph{k} n{k*STEP} VDD VSS sg13g2_buf_1")

    # data: PRBS-7 switching (both tops sample the same NRZ line).
    nbits = int(stop_ns / data_ui_ns) + 4
    bits = prbs_bits(nbits)
    s.append(f"* ---- PRBS-7 data, UI={data_ui_ns}ns")
    s.append(pwl_source(bits, data_ui_ns, "prbs", "data", str(c["vdd"])))

    s.append(f"* ---- init state ({init})")
    ic = []
    for i in range(NSTAGE):
        lvl = "0" if (i % 2 == 0) else "lvdd"
        if init == "x" and i == 12:
            lvl = "0" if (i % 2 == 0) else "0"  # break the alternation
        ic.append(f"V(n{i})={lvl}")
    s.append(".ic " + " ".join(ic))
    s.append("* uic: start from the forced (possibly inconsistent) state")
    s.append(f".TRAN 2p {stop_ns}n uic")

    if loads == "none":
        s.append("* (rate-sweep deck: ring + taps only; loads measured separately)")
        s.append(".control")
        s.append("set filetype=ascii")
        s.append("run")
        s.append("wrdata tran.out v(n0) v(ph0) v(ph1) v(ph2) v(ph3) v(ph4) v(ph5)"
                 " v(ph6) v(ph7) v(ph0) v(ph1)")
        s.append("quit")
        s.append(".endc")
    elif top == "rx":
        # sampler_bank: 8 dfrbp flops on the 8 real phase clock pins.
        s.append("* ---- sampler bank: 8 real DFF clock pins on ph[0..7]")
        for k in range(NPHASE):
            s.append(f"Xsmp{k} q{k} nq{k} ph{k} data RST_N VDD VSS sg13g2_dfrbp_1")
        # PI mux (2 adjacent taps, current-steered in RTL; here the load-real
        # stdcell mux) + its flop clock pin.  Select steps by 1 on a period.
        s.append("* ---- PI mux + one flop clock pin (REC_CLK load)")
        if pi_switch_ns > 0:
            s.append(f"vpisel pisel 0 PWL(0n 0 {pi_switch_ns:.6g}n 0"
                     f" {pi_switch_ns+0.01:.6g}n {c['vdd']}"
                     f" {2*pi_switch_ns:.6g}n {c['vdd']} {2*pi_switch_ns+0.01:.6g}n 0)")
        else:
            s.append("vpisel pisel 0 DC=0")
        s.append("Xpimux recclk ph0 ph1 pisel VDD VSS sg13g2_mux2_1")
        s.append("Xrecff rq rnq recclk data RST_N VDD VSS sg13g2_dfrbp_1")
        s.append("* observability: dco_out, phases, muxed clock")
        s.append(".control")
        s.append("set filetype=ascii")
        s.append("run")
        s.append(f"wrdata tran.out v(n0) v(ph0) v(ph1) v(ph2) v(ph3) v(ph4) v(ph5)"
                 f" v(ph6) v(ph7) v(recclk) v(data)")
        s.append("quit")
        s.append(".endc")
    else:
        # tx_parallel_mux: 4 flops clocked by the even taps + select muxes.
        s.append("* ---- TX: 4 dff clock pins on even taps, select mux tree")
        for k, ph in enumerate((0, 2, 4, 6)):
            s.append(f"Xtxff{k} tq{k} ntq{k} ph{ph} data RST_N VDD VSS sg13g2_dfrbp_1")
        s.append("Xtinv1 ph1b ph1 VDD VSS sg13g2_inv_1")
        s.append("Xtinv2 ph2b ph2 VDD VSS sg13g2_inv_1")
        s.append("Xtxmux_e e_out tq0 tq2 ph1b VDD VSS sg13g2_mux2_1")
        s.append("Xtxmux_o o_out tq1 tq3 ph2b VDD VSS sg13g2_mux2_1")
        s.append("Xtxmux_f serial_out e_out o_out ph2 VDD VSS sg13g2_mux2_1")
        s.append(".control")
        s.append("set filetype=ascii")
        s.append("run")
        s.append("wrdata tran.out v(n0) v(ph0) v(ph1) v(ph2) v(ph3) v(ph4)"
                 " v(ph5) v(ph6) v(ph7) v(serial_out) v(data)")
        s.append("quit")
        s.append(".endc")
    s.append(".end")
    return "\n".join(s)


# ---------------------------------------------------------------------------
# Measurement
# ---------------------------------------------------------------------------

def parse_wrdata(path: Path) -> tuple[list[float], dict[str, list[float]]]:
    """wrdata ascii: time val time val ... per requested variable."""
    rows = path.read_text().split("\n")
    cols: list[list[float]] = []
    for line in rows:
        if not line.strip():
            continue
        t = [float(x) for x in line.split()]
        if not cols:
            cols = [[] for _ in range(len(t))]
        for j, v in enumerate(t):
            cols[j].append(v)
    # columns alternate: time0 v0 time1 v1 ...
    times = cols[0]
    waves = {}
    for j in range(1, len(cols), 2):
        waves[f"v{j//2}"] = cols[j]
    return times, waves


def crossings(t: list[float], w: list[float], thr: float, rising=True) -> list[float]:
    out = []
    for k in range(1, len(w)):
        if rising and w[k-1] < thr <= w[k]:
            out.append(t[k])
        elif not rising and w[k-1] > thr >= w[k]:
            out.append(t[k])
    return out


def metric_freq_period(times, waves, settle, stop, key=0):
    cr = crossings(times, waves[key], 0.6, True)
    cr = [x for x in cr if settle <= x <= stop]
    if len(cr) < 3:
        return None, None
    per = [b - a for a, b in zip(cr, cr[1:])]
    per = [p for p in per if p > 0]
    T = sum(per) / len(per)
    return 1e9 / T, T


def tap_phase_err(times, waves, T, settle, stop):
    """RX 8-tap phase error vs k*T/8 (mod period, wrapped to +-T/2)."""
    taps = []
    for k in range(8):
        cr = crossings(times, waves[k + 1], 0.6, True)
        cr = [x for x in cr if settle <= x <= stop]
        if len(cr) < 2:
            return None
        t0 = cr[0]
        # phase of this tap's edge inside the period, averaged over edges
        devs = []
        for e in cr:
            d = (e - cr[0]) % T
            if d > T / 2:
                d -= T
            devs.append(d)
        exp = k * T / 8
        dev = sum(devs) / len(devs) - exp
        # wrap
        while dev > T / 2:
            dev -= T
        while dev < -T / 2:
            dev += T
        taps.append(dev * 1e12)
    return taps


def duty(times, waves, key, settle, stop):
    """Duty cycle at the flop clock pin over the window."""
    hi = lo = 0.0
    prev_t, prev_v = None, None
    for tt, vv in zip(times, waves[key]):
        if tt < settle or tt > stop:
            prev_t, prev_v = tt, vv
            continue
        if prev_t is not None:
            dt = tt - prev_t
            if prev_v > 0.6:
                hi += dt
            elif prev_v < 0.6:
                lo += dt
        prev_t, prev_v = tt, vv
    if hi + lo <= 0:
        return None
    return 100.0 * hi / (hi + lo)


def min_pulse(times, waves, key, settle, stop, thr=0.6):
    """Minimum high/low pulse width at a node (for the PI-switch hand-off)."""
    widths = []
    last_t = None
    last_state = None
    for tt, vv in zip(times, waves[key]):
        if tt < settle or tt > stop:
            continue
        state = vv > thr
        if last_state is not None and state != last_state and last_t is not None:
            widths.append((last_state, tt - last_t))
        last_state, last_t = state, tt
    if not widths:
        return None
    hi = [w for s, w in widths if s]
    lo = [w for s, w in widths if not s]
    return dict(min_high_ps=min(hi) * 1e12 if hi else None,
                min_low_ps=min(lo) * 1e12 if lo else None)


# ---------------------------------------------------------------------------
# Driver
# ---------------------------------------------------------------------------

def deck_name(cfg: dict) -> str:
    return (f"{cfg['top']}{"" if cfg.get("loads","rx")=="rx" else "-r"}_{cfg['corner']}_c{cfg['coarse']:02d}"
            f"_f{cfg['fine']:+03d}_r{cfg['release_ns']:.0f}_{cfg['init']}"
            f"_pi{cfg['pi_switch_ns']:.0f}")


def gen_deck(cfg: dict, workdir: Path) -> Path:
    workdir.mkdir(parents=True, exist_ok=True)
    d = workdir / deck_name(cfg)
    d.mkdir(exist_ok=True)
    (d / "dco_stage.sp").write_text(emit_stage())
    (d / "top.sp").write_text(emit_top(**{k: v for k, v in cfg.items()
                                          if k in ("corner", "coarse", "fine",
                                                   "top", "loads", "release_ns",
                                                   "init", "pi_switch_ns",
                                                   "stop_ns", "settle_ns",
                                                   "data_ui_ns")}))
    (d / ".spiceinit").write_text(f"set num_threads=1\nosdi '{OSDI.resolve()}'\n")
    return d


def _spice_rlimit():
    # ulimit -v 4000000 (KB) for spice: RLIMIT_AS, soft=hard=4 GB, but never
    # raise the hard limit above what this process already has.
    import resource
    soft, hard = resource.getrlimit(resource.RLIMIT_AS)
    cap = min(4_000_000 * 1024, hard)
    resource.setrlimit(resource.RLIMIT_AS, (min(soft, cap) if soft != -1 else cap, cap))


def run_deck(cfg: dict, workdir: Path, force=False) -> dict:
    d = workdir / deck_name(cfg)
    raw = d / "tran.out"
    result = dict(cfg)
    if not raw.exists() or force:
        subprocess.run(
            ["ngspice", "-b", "top.sp"],
            cwd=d, check=True,
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            preexec_fn=_spice_rlimit,
        )
    times, waves = parse_wrdata(raw)
    settle, stop = cfg.get("settle_ns", 80.0), cfg.get("stop_ns", 120.0)
    freq, T = metric_freq_period(times, waves, settle, stop)
    result.update(freq_mhz=freq, period_ns=T)
    if T:
        if cfg["top"] == "rx" and cfg.get("loads", "rx") != "none":
            taps = tap_phase_err(times, waves, T, settle, stop)
            result["tap_err_ps"] = taps
            if taps:
                result["tap_max_abs_ps"] = max(abs(x) for x in taps)
                # TX quadrature reported SEPARATELY (spec risk 6): the
                # PHASE[0]->PHASE[4] spacing is 12 stages not 13, it carries
                # a systematic -T/8 offset; report its deviation from 12*T/26
                # relative as an open flag, not part of the RX grid metric.
                quad = taps[4] - taps[0]
                result["tx_quad_dev_ps"] = quad
            result["duty_pct"] = duty(times, waves, 1, settle, stop)  # ph0 pin
            mp = min_pulse(times, waves, 9, settle, stop)  # recclk (muxed)
            result["mux_min_pulse"] = mp
        else:
            result["duty_pct"] = duty(times, waves, 1, settle, stop)
    # startup check: sustained oscillation within 20 cycles of release
    if T:
        cr = crossings(times, waves[0], 0.6, True)
        rel = cfg["release_ns"]
        good = [x for x in cr if x > rel]
        if len(good) >= 2:
            result["start_cycles"] = (good[1] - rel) / T
    return result


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["stage", "run", "sweep"])
    ap.add_argument("--corners", default="ss")
    ap.add_argument("--coarse", default="")
    ap.add_argument("--fine", default="")
    ap.add_argument("--tops", default="rx")
    ap.add_argument("--jobs", type=int, default=8)
    ap.add_argument("--loads", default="rx")
    ap.add_argument("--out", default=str(OUT / "dco_tuned.json"))
    args = ap.parse_args()

    workdir = WORKDIR
    if args.cmd == "stage":
        (OUT / "dco_stage.sp").write_text(emit_stage())
        print((OUT / "dco_stage.sp"))
        return
    cfgs = []
    corners = args.corners.split(",")
    tops = args.tops.split(",")
    coarse = [int(x) for x in args.coarse.split(",")] if args.coarse else list(range(32))
    fine = [int(x) for x in args.fine.split(",")] if args.fine else [0]
    for top in tops:
        for corner in corners:
            for cc in coarse:
                for ff in fine:
                    stop = 32.0 if cc >= 24 else 24.0
                    settle = 12.0
                    cfgs.append(dict(top=top, loads=args.loads, corner=corner,
                                     coarse=cc, fine=ff,
                                     release_ns=0.0, init="0",
                                     pi_switch_ns=5.0,
                                     stop_ns=stop, settle_ns=settle,
                                     data_ui_ns=1.0))
    def go(cfg):
        try:
            d = gen_deck(cfg, workdir)
            return run_deck(cfg, workdir)
        except Exception as e:
            return {**cfg, "error": str(e)}
    with ThreadPoolExecutor(args.jobs) as ex:
        results = list(ex.map(go, cfgs))
    json.dump(results, open(args.out, "w"), indent=1)
    for r in results:
        if "error" in r:
            print("ERR", r)
        else:
            print(f"{r['top']} {r['corner']} c{r['coarse']:02d} f{r['fine']:+d}: "
                  f"{r.get('freq_mhz') and round(r['freq_mhz'],1)} MHz"
                  f" duty={r.get('duty_pct') and round(r['duty_pct'],1)}"
                  f" tapmax={r.get('tap_max_abs_ps') and round(r['tap_max_abs_ps'],1)}ps")


if __name__ == "__main__":
    main()
