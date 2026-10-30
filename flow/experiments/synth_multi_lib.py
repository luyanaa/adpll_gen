#!/usr/bin/env python3
"""Synthesize pll_logic against several standard-cell libraries and record QoR.

This is synthesis-level only: it compares cell count and Liberty cell area for
the same Core A digital control RTL on the libraries under /grid and ~/.ciel.
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "src"


def digital_sources():
    text = (ROOT / "src" / "digital_sources.mk").read_text()
    return [p.split("/src/", 1)[1] for p in re.findall(r"\$\(ROOT_DIR\)/src/\S+\.v", text)]
SOURCES = digital_sources()
LIBS = {
    "sky130_fd_sc_hdll": "/opt/adpll_gen/flow/sky130_lib/out/sky130_fd_sc_hdll_tt_025C_1v80.lib",
    "sky130_fd_sc_ms": "/opt/adpll_gen/flow/sky130_lib/out/sky130_fd_sc_ms_tt_100C_1v80.lib",
    "sky130_osu_sc_t12": "/grid/sky130/sky130_osu_sc_t12/12T_ls/lib/sky130_osu_sc_12T_ls_tt_1P80_25C.ccs.lib",
    "sky130_fd_sc_ls": "/opt/adpll_gen/flow/sky130_lib/out/sky130_fd_sc_ls_tt_100C_1v80.lib",
    "sky130_as_sc_hs": "/grid/sky130/sky130_as_sc_hs/pdk/libs.ref/sky130_as_sc_hs/lib/sky130_as_sc_hs__tt_025C_1v80.lib",
    "sky130_rhbd": "/grid/sky130/sky130RHBDlib/sky130_rhbd/lib/sky130_rhbd_tt_1P8_25C.ccs.lib",
    "gf180mcu_osu_sc_gp12t3v3": "/grid/gf180mcu/gf180mcu_osu_sc_gp12t3v3/lib/gf180mcu_osu_sc_gp12t3v3_TT_25C.nldm.lib",
    "gf180mcu_osu_sc_gp9t3v3": "/grid/gf180mcu/gf180mcu_osu_sc_gp9t3v3/lib/gf180mcu_osu_sc_gp9t3v3_TT_25C.nldm.lib",
    "gf180mcu_as_sc_mcu7t3v3": "/grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk/libs.ref/gf180mcu_as_sc_mcu7t3v3/lib/gf180mcu_as_sc_mcu7t3v3__tt_025C_3v30.lib",
    "gf180mcu_as_ex_mcu7t5v0": "/grid/gf180mcu/gf180mcu_as_ex_mcu7t5v0/lib/gf180mcu_as_ex_mcu7t5v0__tt_025C_5v00.lib",
    "gf180mcu_ocd_sc_rt12t3v3": "/grid/gf180mcu/gf180mcu_ocd_sc_rt12t3v3/lctime/template_tt.lib",
    "ez130_8t_v1p1": "/grid/ihp130/ez130_8t_v1p1/lib/ez130_8t_tt_1p20v_25c.lib",
    "sg13g2_stdcell_hv": "/grid/ihp130/sg13g2_stdcell_hv/lib/sg13g2_stdcell_hv_typ_3p30V_25C.lib",
    "ics55_LLSC_H7CR": "/grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CR/liberty/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib",
    "ics55_LLSC_H7CH": "/grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CH/liberty/ics55_LLSC_H7CH_typ_tt_1p2_25_nldm.lib",
    "ics55_LLSC_H7CL": "/grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CL/liberty/ics55_LLSC_H7CL_typ_tt_1p2_25_nldm.lib",
    "ETRI050_fd_sc_12t": "/grid/ETRI050/libs.ref/ETRI050_fd_sc_12t/lib/ETRI050_fd_sc_12t__tt_5v00_25c.lib",
    "ETRI050_gen_sc_9t": "/grid/ETRI050/libs.ref/ETRI050_gen_sc_9t/lib/ETRI050_gen_sc_9t_9t_research.lib",
    "open_pdk_sky130_fd_sc_hd": str(Path.home() / ".ciel/ciel/sky130/versions/8afc8346a57fe1ab7934ba5a6056ea8b43078e71/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"),
    "open_pdk_gf180mcu_fd_sc_mcu7t5v0": str(Path.home() / ".ciel/ciel/gf180mcu/versions/792ef67037d74c8c51811eab3ce23cf793491296/gf180mcuA/libs.ref/gf180mcu_fd_sc_mcu7t5v0/lib/gf180mcu_fd_sc_mcu7t5v0__tt_025C_3v30.lib"),
    "open_pdk_sg13g2_stdcell": "/opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2/lib/sg13g2_stdcell_typ_1p20V_25C.lib",
}


def run_one(name: str, lib: str, work: Path) -> dict:
    work.mkdir(parents=True, exist_ok=True)
    ys = work / f"{name}.ys"
    log = work / f"{name}.log"
    lines = [f"read_liberty -lib {lib}"]
    lines += [f"read_verilog {SRC / s}" for s in SOURCES]
    lines += [
        "hierarchy -check -top pll_logic",
        "proc", "opt", "fsm", "opt", "memory", "opt", "flatten",
        "synth -run coarse", "techmap", "opt",
        f"dfflibmap -liberty {lib}",
        f"abc -liberty {lib}",
        "opt",
        f"stat -liberty {lib}",
    ]
    ys.write_text("\n".join(lines) + "\n")
    proc = subprocess.run(["yosys", "-s", str(ys)], text=True,
                          stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    log.write_text(proc.stdout)
    text = proc.stdout
    m = re.search(r"Number of cells:\s+(\d+)", text)
    a = re.search(r"Chip area for module '\\pll_logic':\s+([0-9.]+)", text)
    if not m:
        return {"library": name, "liberty": lib, "status": "FAIL", "log": str(log)}
    return {
        "library": name, "liberty": lib,
        "status": "PASS" if proc.returncode == 0 else "FAIL",
        "cells": int(m.group(1)),
        "area_um2": float(a.group(1)) if a else None,
        "log": str(log),
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=ROOT / "flow/experiments/synth_multi_lib.json")
    ap.add_argument("--only", nargs="*")
    args = ap.parse_args()
    work = ROOT / "flow/experiments/logs"
    rows = []
    for name, lib in LIBS.items():
        if args.only and name not in args.only:
            continue
        if not Path(lib).exists():
            rows.append({"library": name, "liberty": lib, "status": "MISSING"})
            continue
        print("synthesizing", name)
        rows.append(run_one(name, lib, work))
    args.out.write_text(json.dumps(rows, indent=2) + "\n")
    for r in rows:
        print(f"{r['library']:<40} {r['status']:<8} cells={r.get('cells','-')} area={r.get('area_um2','-')}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
