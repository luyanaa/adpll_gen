#!/usr/bin/env python3
"""Synthesis-only parameter sweep for the ADPLL digital control.

This does not claim timing: it measures the mapped cell count / Liberty area
cost of changing the frequency-counter and divider widths and the DCO
thermometer lengths.
"""
from __future__ import annotations
import json, re, subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "src"


def digital_sources():
    text = (ROOT / "src" / "digital_sources.mk").read_text()
    return [p.split("/src/", 1)[1] for p in re.findall(r"\$\(ROOT_DIR\)/src/\S+\.v", text)]
LIB = str(Path.home() / ".ciel/ciel/sky130/versions/8afc8346a57fe1ab7934ba5a6056ea8b43078e71/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib")
SOURCES = digital_sources()
CONFIGS = {
  "default_8b": {},
  "fcw_div_10b": {"FCW_BITS":10, "DIV_BITS":10},
  "fcw_div_12b": {"FCW_BITS":12, "DIV_BITS":12},
  "fine63_filter20": {"FINE_NDELS":63, "FILTER_BITS":20},
  "coarse_mid31": {"COARSE_NDELS":31, "MID_NDELS":31},
}

def run(name, params, outdir):
    ys = outdir / f"{name}.ys"
    log = outdir / f"{name}.log"
    lines = [f"read_liberty -lib {LIB}"]
    lines += [f"read_verilog {SRC / s}" for s in SOURCES]
    if params:
        lines.append("chparam " + " ".join(f"-set {k} {v}" for k,v in params.items()) + " pll_logic")
    lines += ["hierarchy -check -top pll_logic"]
    lines += ["proc","opt","fsm","opt","memory","opt","flatten","synth -run coarse","techmap","opt",f"dfflibmap -liberty {LIB}",f"abc -liberty {LIB}","opt",f"stat -liberty {LIB}"]
    ys.write_text("\n".join(lines)+"\n")
    p=subprocess.run(["yosys","-s",str(ys)],text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    log.write_text(p.stdout); t=p.stdout
    ms=re.findall(r"Number of cells:\s+(\d+)",t); m=ms[-1] if ms else None
    aa=re.findall(r"Chip area for module '\\pll_logic':\s+([0-9.]+)",t); a=aa[-1] if aa else None
    return {"name":name,"params":params,"status":"PASS" if p.returncode==0 and m else "FAIL","cells":int(m) if m else None,"area_um2":float(a) if a else None,"log":str(log)}

def main():
    out=ROOT/"flow/experiments/param_sweep_logs"; out.mkdir(parents=True,exist_ok=True)
    rows=[run(n,p,out) for n,p in CONFIGS.items()]
    (ROOT/"flow/experiments/param_sweep.json").write_text(json.dumps(rows,indent=2)+"\n")
    for r in rows: print(r)
if __name__=="__main__": main()
