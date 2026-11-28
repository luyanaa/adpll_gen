#!/usr/bin/env python3
"""DDR1 CK90 DLL: full master+slave chain with SR regeneration, device SPICE.

Evidence deck for docs/DDR1_DLL_ELEMENT_SIZING.md decisions:

  * 32-element master cascade (4 segments x 8 elements) + 8-element slave,
    all stock sg13g2_inv_4 drivers, thermometer moscap banks with binary
    groups COLLAPSED via SPICE `m` multipliers (bit b -> m=2^(b-1) N and P
    fingers; bit0 is N-only).  Collapsing keeps the capacitive load and the
    switch resistance correct to first order while cutting device count
    ~30x vs the per-finger deck.
  * SR regeneration exactly as src/ddr1_dll_phys.v DDR1_CLK_REGEN:
    master copy:  SET = x32 rise, RESET = x16 rise (spacing T/2 at lock)
    CK90 copy:    SET = y8 rise,  RESET = x24 rise (spacing T/2 at lock)
    reset pulse:  rn = ~(RESET & ~RESET_d), d = 2x inv_1, active-low into
    sg13g2_dfrbp_1.
  * Input: 100 MHz square, duty parameterizable (default 50%, plus a 60%
    variant to prove duty independence of the regeneration).

Measurements per run (parsed in analyze()):
  * chain transport delay rise/fall at x8/x16/x24/x32/y8 (asymmetry depth)
  * high-time at each tap (duty distortion accumulation through depth 32)
  * q_m / q_ck90 high time (regenerated duty, target T/2)
  * D_set  = q_m rise - x32 rise  (latch set-path delay)
  * phase shift introduced by regeneration:
        dphi = (q_ck90 rise - q_m rise) - (y8 rise - x32 rise)
    which is the (3/4)*D_set systematic the loop cannot servo out
    (docs: measuring the regenerated master leaves D_set - D_extra/4).
  * reset pulse width at x16/x24 nodes (rn low time).

Usage:
  python3 flow/characterization/ddr1_dll_regen.py \
      --corners tt --codes 71 --jobs 1 --out /tmp/opencode/regen_smoke.json
"""

import argparse
import json
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import dll8_pex2 as P  # corner/device constants + parsers

WORKDIR = Path(os.environ.get("DDR1_REGEN_WORKDIR", "/tmp/opencode/ddr1regen/decks"))

# ---------------------------------------------------------------------------
# collapsed-finger element: same circuit as dll8_pex2 emit_elem2 with
# scheme='np', except each binary group of 2^b consecutive thermometer
# fingers collapses into ONE n-switch+moscap_n and ONE p-switch+moscap_p
# pair with m = 2^(b-1) (bit0: a single N finger, m=1, no P part).
# Per-element device count drops from ~127*(sw+cap)+... to ~90.
# ---------------------------------------------------------------------------

def emit_elem_collapsed() -> str:
    s = [".subckt DLL8E_COLL IN OUT C0 C1 C2 C3 C4 C5 C6 VDD VSS"
         " params: CMID=0.96f",
         "Xinv_in mid IN VDD VSS sg13g2_inv_4",
         "Xinv_out OUT mid VDD VSS sg13g2_inv_4",
         "Cmid mid 0 {CMID}"]
    NW, NL = P.NW, P.NL
    PW, PL = P.PW, P.PL
    CAP_W, CAP_L = P.CAP_W, P.CAP_L
    for b in range(P.NBITS):
        # g = buffered select (drives N switch gates), gb = inverted
        # (drives P switch gates) — same polarity convention as
        # dll8_pex2.emit_elem2 np scheme.
        s.append(f"Xgb{b} g{b} C{b} VDD VSS sg13g2_buf_8")
        s.append(f"Xgi{b} gb{b} C{b} VDD VSS sg13g2_inv_8")
        if b == 0:
            # finger0 only: single N finger
            s.append(f"Xtn_{b} cn{b} g{b} mid VSS sg13_lv_nmos w={NW} l={NL} m=1")
            s.append(f"Rcn_{b} cn{b} VSS 1G")
            s.append(f"Xcn_{b} cn{b} VSS sg13_moscap_n w={CAP_W} l={CAP_L} m=1")
        else:
            m = 1 << (b - 1)
            # NOTE: g/gb polarity follows the np scheme: N switch gate = g,
            # P switch gate = gb (inverted).  buf_8 gives g=C buffered,
            # inv_8 gives gb.  emit order matches dll8_pex2 (g, gb).
            s.append(f"Xtn_{b} cn{b} g{b} mid VSS sg13_lv_nmos w=0.50u l={NL} m={m}")
            s.append(f"Rcn_{b} cn{b} VSS 1G")
            s.append(f"Xcn_{b} cn{b} VSS sg13_moscap_n w={CAP_W} l={CAP_L} m={m}")
            s.append(f"Xtp_{b} cp{b} gb{b} mid VDD sg13_lv_pmos w=1.0u l={PL} m={m}")
            s.append(f"Rcp_{b} cp{b} VDD 1G")
            s.append(f"Xcp_{b} cp{b} VDD sg13_moscap_p w={CAP_W} l={CAP_L} m={m}")
    s.append(".ends DLL8E_COLL")
    return "\n".join(s)


def emit_regen(set_node: str, rst_node: str, q: str, tag: str,
               nstage: int = 12) -> list:
    """DDR1_CLK_REGEN structural equivalent (pin order output-first).

    The async-reset pulse is generated from RESET_IN through `nstage`
    inverters: rn = ~(RESET_IN & ~RESET_IN_d).  nstage=12 (~330 ps) matches
    src/ddr1_dll_phys.v; SPICE measured that a 100 ps pulse does NOT reset
    sg13g2_dfrbp_1 while 150 ps does -- the 8-stage chain (219 ps) was only
    1.5x margin.
    """
    s = []
    prev = rst_node
    for k in range(nstage):
        s.append(f"Xrd{tag}_{k} rd{tag}_{k} {prev} VDD VSS sg13g2_inv_1")
        prev = f"rd{tag}_{k}"
    return s + [
        # rn = ~(~rdb & RESET) : active-low pulse at RESET rising edge
        f"Xrp_{tag} rn{tag} {prev} {rst_node} VDD VSS sg13g2_nand2b_1",
        f"Xtie_{tag} tiehi{tag} VDD VSS sg13g2_tiehi",
        f"Xsr_{tag} qraw{tag} qn{tag} {set_node} tiehi{tag} rn{tag} VDD VSS sg13g2_dfrbp_1",
        # matched output buffer, exactly as src/ddr1_dll_phys.v
        f"Xob_{tag} {q} qraw{tag} VDD VSS sg13g2_buf_4",
        f".ic V(qraw{tag})=0",
    ]


def emit_top(cfg: dict) -> str:
    c = P.CORNERS[cfg["corner"]]
    vdd = c["vdd"]
    code = cfg["code"]
    bits = [(code >> b) & 1 for b in range(P.NBITS)]
    nelem = cfg.get("nelem", 8)
    nm = 4 * nelem
    duty = cfg.get("duty", 0.5)
    period_ns = 10.0
    ncyc = cfg.get("ncyc", 4)
    stop = period_ns * (ncyc + 1.6)

    s = [f"* ddr1 dll regen corner={cfg['corner']} code={code} duty={duty}",
         f".TEMP {c['temp']}",
         f'.LIB "{P.CORNER_MOS}" {c["mos"]}',
         f'.LIB "{P.CORNER_CAP}" moscap_tt',
         f'.inc "{P.MOSCAP_MOD}"',
         f'.inc "{P.CELLS}"',
         ".inc elem_coll.sp",
         ".PARAM CMID=0.96f",
         ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12 TRTOL=15 ITL4=30",
         f"vvdd VDD 0 DC={vdd}", "vvss VSS 0 DC=0"]
    for b in range(P.NBITS):
        s.append(f"vc{b} C{b} 0 DC={vdd if bits[b] else 0.0}")

    # square input, parameterized duty — explicit segments for ncyc+2
    # cycles (ngspice PWL repeat syntax is unreliable across versions).
    th = period_ns * duty
    e = P.EDGE
    seg = ["0 0", f"{0.4-e:.6g}n 0"]
    ncycles = ncyc + 2
    for k in range(ncycles):
        base = 0.4 + k * period_ns
        seg += [f"{base:.6g}n {vdd}",
                f"{base+th-e:.6g}n {vdd}", f"{base+th:.6g}n 0",
                f"{base+period_ns-e:.6g}n 0"]
    seg += [f"{0.4+ncycles*period_ns:.6g}n {vdd}"]
    s.append("Vin IN 0 PWL(" + " ".join(seg) + ")")

    # master: 32 elements; slave: 8 elements from the same input
    nodes = ["IN"] + [f"x{i}" for i in range(1, nm+1)]
    ynodes = ["IN"] + [f"y{i}" for i in range(1, nelem+1)]
    for i in range(nm):
        s.append(f"Xm{i} {nodes[i]} {nodes[i+1]} C0 C1 C2 C3 C4 C5 C6 VDD VSS DLL8E_COLL")
        s.append(f"Cwm{i} {nodes[i+1]} 0 {P.WIRE_FF:.3f}f")
    for i in range(nelem):
        s.append(f"Xs{i} {ynodes[i]} {ynodes[i+1]} C0 C1 C2 C3 C4 C5 C6 VDD VSS DLL8E_COLL")
        s.append(f"Cws{i} {ynodes[i+1]} 0 {P.WIRE_FF:.3f}f")

    # regeneration: master (set=full, rst=half), ck90 (set=slave, rst=3/4)
    s += emit_regen(f"x{nm}", f"x{nm//2}", "qm", "m")
    s += emit_regen(f"y{nelem}", f"x{3*nelem}", "qc", "c")

    probes = (f"v(IN) v(x{nelem}) v(x{nm//2}) v(x{3*nelem}) v(x{nm}) v(y{nelem})"
              " v(qm) v(qc) v(rnm) v(rnc)")
    s += [".control", "set filetype=ascii", "run",
          f"wrdata tran.out {probes}", "quit", ".endc",
          f".TRAN {cfg.get('tstep', '4p')} {stop:.4g}n", ".end"]
    return "\n".join(s)


# ---------------------------------------------------------------------------
# measurement
# ---------------------------------------------------------------------------

def xings(t, w, thr, rising=True):
    return P.interp_cross(t, w, thr, rising)


def measure(cfg, raw):
    c = P.CORNERS[cfg["corner"]]
    vdd = c["vdd"]
    thr = 0.5 * vdd
    t, w = P.parse_wrdata(raw)
    res = dict(cfg)
    vin, vx8, vx16, vx24, vx32, vy8, vqm, vqc, vrnm, vrnc = (
        w["v0"], w["v1"], w["v2"], w["v3"], w["v4"], w["v5"], w["v6"], w["v7"], w["v8"], w["v9"])

    # use the LAST input rising edge with a full following cycle
    rin = xings(t, vin, thr, True)
    fin = xings(t, vin, thr, False)
    if len(rin) < 2:
        res["error"] = "no input edges"
        return res
    # Reference cycle: the master chain delays by ~T, so the edge that lands
    # (and completes its pulse) inside the window is usually the THIRD-to-last
    # input edge.  Using rin[-2] clips the master pulse for any corner where
    # the locked delay is close to T (observed: x32 rise with no fall).
    t0 = rin[-3] if len(rin) >= 3 else (rin[-2] if len(rin) >= 2 else rin[-1])
    t1 = rin[-1]
    period = (t1 - t0) * 1e12
    res["period_ps"] = period

    def last_pair(wv):
        """LAST complete pulse in the window: the last rise plus the first
        fall after it.  (Taking the first rise and first fall independently
        pairs a reset fall with the following set rise for a latch output —
        observed as negative high times.)  Every node here has the same
        period, so comparing "last pulses" is cycle-consistent."""
        rs = [x for x in xings(t, wv, thr, True) if x > t0 + 0.2e-9]
        allf = xings(t, wv, thr, False)
        # walk back to the last rise that has a fall after it, so every node
        # yields a complete pulse even when the window cuts the final one
        # (topologies where the reset tap precedes the set tap produce a
        # near-full-period pulse that straddles the window end).
        for r in reversed(rs):
            fs = [x for x in allf if x > r + 1e-12]
            if fs:
                return r, fs[0]
        return None, None

    nelem = cfg.get("nelem", 8)
    nm = 4 * nelem
    for name, wv in ((f"x{nelem}", vx8), (f"x{nm//2}", vx16), (f"x{3*nelem}", vx24),
                     (f"x{nm}", vx32), (f"y{nelem}", vy8), ("qm", vqm), ("qc", vqc)):
        r, f = last_pair(wv)
        if r:
            res[f"{name}_rise_after_in_ps"] = (r - t0) * 1e12
        if r and f:
            res[f"{name}_high_ps"] = (f - r) * 1e12 if f > r else None
        if r and f and f < r:
            res[f"{name}_high_ps"] = (f - r) * 1e12  # fall before rise (duty<50)

    # input reference high time
    r0, f0 = last_pair(vin)
    # input first rise IS at t0; use fin list
    fin_after = [x for x in fin if x > t0 + 1e-12]
    if fin_after:
        res["in_high_ps"] = (fin_after[0] - t0) * 1e12

    # D_set per regenerator, cycle-consistent by construction: each Q rise is
    # caused by the nearest tap rise BEFORE it, so pair them locally instead
    # of hoping both nodes' "last complete pulse" lands in the same cycle.
    rqm, _ = last_pair(vqm)
    rqc, _ = last_pair(vqc)
    rx32, _ = last_pair(vx32)
    ry8, _ = last_pair(vy8)

    def nearest_before(node_w, tq):
        xs = [x for x in xings(t, node_w, thr, True) if x <= tq + 1e-12]
        return xs[-1] if xs else None

    if rqm:
        a = nearest_before(vx32, rqm)
        if a:
            res["d_set_master_ps"] = (rqm - a) * 1e12
            res["d_set_ps"] = res["d_set_master_ps"]
    if rqc:
        b = nearest_before(vy8, rqc)
        if b:
            res["d_set_ck90_ps"] = (rqc - b) * 1e12
    if "d_set_master_ps" in res and "d_set_ck90_ps" in res:
        # THE number that matters: the two regenerators must be matched, since
        # any difference lands on CK90 directly (it is not divided by 4).
        res["regen_phase_shift_ps"] = res["d_set_ck90_ps"] - res["d_set_master_ps"]

    # chain-level slave-vs-master spacing (informational; same-cycle safe
    # because both are taps of the same chain and periods are identical)
    T = res["period_ps"]
    if rx32 and ry8:
        d = (ry8 - rx32) * 1e12
        res["chain_slave_minus_master_ps"] = ((d + T/2.0) % T) - T/2.0

    # reset pulse widths (low time of rn at the last reset edge)
    for tag, wrn in (("rnm", vrnm), ("rnc", vrnc)):
        falls = xings(t, wrn, thr, False)
        rises = xings(t, wrn, thr, True)
        if falls and rises:
            fl = falls[-1]
            nxt = [x for x in rises if x > fl]
            if nxt:
                res[f"{tag}_low_ps"] = (nxt[0] - fl) * 1e12
    return res


def deck_dir(cfg):
    return WORKDIR / (f"rg_{cfg['corner']}_c{cfg['code']:03d}_d{int(cfg.get('duty',0.5)*100)}"
                      f"_n{cfg.get('nelem',8)}_{cfg.get('tstep','4p')}")


def run_one(cfg):
    d = deck_dir(cfg)
    d.mkdir(parents=True, exist_ok=True)
    (d / "elem_coll.sp").write_text(emit_elem_collapsed())
    (d / "top.sp").write_text(emit_top(cfg))
    (d / ".spiceinit").write_text(
        f"set num_threads=1\nosdi {P.OSDI.resolve()}\nosdi {P.OSDI_NQS.resolve()}\n")
    raw = d / "tran.out"
    if not raw.exists():
        subprocess.run(["ngspice", "-b", "top.sp"], cwd=d, check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return measure(cfg, raw)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--corners", default="tt")
    ap.add_argument("--codes", default="71")
    ap.add_argument("--duties", default="0.5")
    ap.add_argument("--nelem", type=int, default=8)
    ap.add_argument("--tstep", default="4p")   # 8p is ~3.5x faster; 50% edges
                                               # interpolate within ~2 ps
    ap.add_argument("--ncyc", type=int, default=4)
    ap.add_argument("--jobs", type=int, default=3)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    cfgs = []
    for corn in args.corners.split(","):
        for code in [int(x) for x in args.codes.split(",")]:
            for du in [float(x) for x in args.duties.split(",")]:
                cfgs.append(dict(corner=corn, code=code, duty=du, nelem=args.nelem,
                                 tstep=args.tstep, ncyc=args.ncyc))

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
    for r in res:
        if "error" in r:
            print("ERR", r["corner"], r["code"], r["error"][:120])
        else:
            print(f"{r['corner']} c{r['code']} d{r['duty']}: "
                  f"qm_high={r.get('qm_high_ps') and round(r['qm_high_ps'])} "
                  f"qc_high={r.get('qc_high_ps') and round(r['qc_high_ps'])} "
                  f"d_set={r.get('d_set_ps') and round(r['d_set_ps'],1)} "
                  f"shift={r.get('regen_phase_shift_ps') and round(r['regen_phase_shift_ps'],1)}")
    print(f"{len(cfgs)} runs -> {out}")


if __name__ == "__main__":
    main()
