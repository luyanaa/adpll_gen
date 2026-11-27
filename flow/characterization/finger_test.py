#!/usr/bin/env python3
"""Finger-count / finger-size sweep for the DLL8 element.

Total switched cap is held ~constant; only the finger count changes:
  N=127 cap 1.0x1.0 (sw 0.5/1.0)   -> ~1626 fF
  N=63  cap 1.4x1.4 (sw 0.7/1.4)   -> ~1580 fF
  N=31  cap 2.0x2.0 (sw 1.0/2.0)   -> ~1580 fF
Measures BASE (all fingers present, all OFF), MAX (all ON) and the
per-finger ON-OFF contrast at SS/TT/FF.
"""
import json
import os
import subprocess
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

import dll8_pex2 as m

OUT = Path("/tmp/opencode/finger_test.json")
WORK = Path("/tmp/opencode/finger_test/decks")


def elem(cap_w, cap_l, sw_n, sw_p, n_total):
    s = [".subckt DLL8_ELEM IN OUT VDD VSS params: CMID=0.96f",
         "Xinv_in mid IN VDD VSS sg13g2_inv_4",
         "Xinv_out OUT mid VDD VSS sg13g2_inv_4",
         "Cmid mid 0 {CMID}"]
    return s


def emit_elem(cap_w, cap_l, sw_n, sw_p, n_total, n_on):
    s = [".subckt DLL8_ELEM IN OUT VDD VSS params: CMID=0.96f",
         "Xinv_in mid IN VDD VSS sg13g2_inv_4",
         "Xinv_out OUT mid VDD VSS sg13g2_inv_4",
         "Cmid mid 0 {CMID}"]
    for j in range(n_total):
        cn = f"cn{j}"
        on = j < n_on
        if j % 2 == 0:   # NMOS -> VSS, moscap_n
            g = "VDD" if on else "VSS"
            s.append(f"Xtn{j} {cn} {g} mid VSS sg13_lv_nmos w={sw_n} l=0.45u")
            s.append(f"Rcn{j} {cn} VSS 1G")
            s.append(f"Xcn{j} {cn} VSS sg13_moscap_n w={cap_w} l={cap_l}")
        else:            # PMOS -> VDD, moscap_p
            g = "VSS" if on else "VDD"
            s.append(f"Xtp{j} {cn} {g} mid VDD sg13_lv_pmos w={sw_p} l=0.13u")
            s.append(f"Rcp{j} {cn} VDD 1G")
            s.append(f"Xcp{j} {cn} VDD sg13_moscap_p w={cap_w} l={cap_l}")
    s.append(".ends DLL8_ELEM")
    s.append(m.emit_invb())
    return "\n".join(s)


def emit_top(corner, t_fall=8.0):
    c = m.CORNERS[corner]
    return "\n".join([
        f".TEMP {c['temp']}",
        f'.LIB "{m.CORNER_MOS}" {c["mos"]}',
        f'.LIB "{m.CORNER_CAP}" moscap_tt',
        f'.inc "{m.MOSCAP_MOD}"',
        f'.inc "{m.CELLS}"',
        ".inc elem.sp",
        ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12 TRTOL=15 ITL4=30",
        f"vvdd VDD 0 DC={c['vdd']}", "vvss VSS 0 DC=0",
        m.pwl_pulse(c["vdd"], t_fall),
        "X0 IN x1 VDD VSS DLL8_ELEM",
        "Xtb tb x1 VDD VSS sg13g2_buf_1",
        "Xnx nx x1 VDD VSS sg13g2_inv_4",
        "Cw x1 0 0.96f",
        ".control", "set filetype=ascii", "run",
        "wrdata tran.out v(IN) v(x1) v(tb)", "quit", ".endc",
        f".TRAN 2p {t_fall+1.0:.3g}n", ".end"])


def run(cfg):
    d = WORK / cfg["name"]
    d.mkdir(parents=True, exist_ok=True)
    (d / "elem.sp").write_text(emit_elem(cfg["capw"], cfg["capl"], cfg["swn"],
                                         cfg["swp"], cfg["n"], cfg["non"]))
    (d / "top.sp").write_text(emit_top(cfg["corner"], 8.0 if cfg["n"] > 40 else 4.0))
    (d / ".spiceinit").write_text(
        f"set num_threads=1\nosdi {m.OSDI.resolve()}\nosdi {m.OSDI_NQS.resolve()}\n")
    raw = d / "tran.out"
    if not raw.exists():
        subprocess.run(["ngspice", "-b", "top.sp"], cwd=d, check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    r = m.measure(dict(corner=cfg["corner"], code=0, nelem=1, mode="pulse"), raw)
    return {**cfg, "delay_ps": r.get("delay_ps")}


def main():
    cases = {
        "n127_1p0": dict(capw="1.0u", capl="1.0u", swn="0.5u", swp="1.0u", n=127),
        "n63_1p4":  dict(capw="1.4u", capl="1.4u", swn="0.7u", swp="1.4u", n=63),
        "n31_2p0":  dict(capw="2.0u", capl="2.0u", swn="1.0u", swp="2.0u", n=31),
    }
    cfgs = []
    for name, c in cases.items():
        for corner in ("ss", "tt", "ff"):
            for non in (0, c["n"]):
                cfgs.append({**c, "name": f"{name}_{corner}_on{non}",
                             "corner": corner, "non": non})
    with ThreadPoolExecutor(8) as ex:
        res = list(ex.map(run, cfgs))
    json.dump(res, open(OUT, "w"), indent=1)
    # summarise
    for name, c in cases.items():
        print(f"== {name}: {c['n']} finger, cap {c['capw']}")
        for corner in ("ss", "tt", "ff"):
            off = next(r["delay_ps"] for r in res
                       if r["name"] == f"{name}_{corner}_on0")
            onm = next(r["delay_ps"] for r in res
                       if r["name"] == f"{name}_{corner}_on{c['n']}")
            if off is None or onm is None:
                print(f"  {corner}: off={off} on={onm}")
                continue
            print(f"  {corner}: BASE(off)={off:.1f} MAX(on)={onm:.1f} "
                  f"range={onm-off:.1f} contrast/finger={(onm-off)/c['n']:.2f} "
                  f"max/500={onm/500:.2f}")


if __name__ == "__main__":
    main()
