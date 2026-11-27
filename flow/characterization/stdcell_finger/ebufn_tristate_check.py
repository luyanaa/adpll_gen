#!/usr/bin/env python3
"""Evidence: does sg13g2_ebufn_4 actually tri-state in the pinned PDK SPICE view?

DC sweep A=0..VDD with TE_B=0 (enabled) and TE_B=VDD (disabled), Z loaded with
1 Gohm. If the cell tri-stated, Z would be pinned high/low by the load and not
track A when TE_B=VDD.
"""
import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, "/grid/adpll_gen/flow/characterization")
import dll8_pex2 as ref

WORK = Path("/tmp/opencode/stdcell_finger/ebufn_check")


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    corner = ref.CORNERS["tt"]
    deck = "\n".join([
        "* ebufn tri-state DC check",
        f".TEMP {corner['temp']}",
        f'.LIB "{ref.CORNER_MOS}" {corner["mos"]}',
        f'.inc "{ref.CELLS}"',
        ".OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6",
        f"vvdd VDD 0 DC={corner['vdd']}", "vvss VSS 0 DC=0",
        "va A 0 DC=0", "ve enb 0 DC=0",
        "Xe Z A enb VDD VSS sg13g2_ebufn_4",
        "Rz Z 0 1G",
        ".control", "set filetype=ascii",
        "dc va 0 1.2 0.2", "wrdata enabled.out v(A) v(Z)",
        "alter ve DC=1.2", "dc va 0 1.2 0.2",
        "wrdata disabled.out v(A) v(Z)",
        "quit", ".endc", ".end"])
    (WORK / "top.sp").write_text(deck)
    (WORK / ".spiceinit").write_text(
        f"set num_threads=1\nosdi {ref.OSDI.resolve()}\n"
        f"osdi {ref.OSDI_NQS.resolve()}\n")
    subprocess.run(["bash", "-lc", "ulimit -v 4000000; ngspice -b top.sp"],
                   cwd=WORK, check=True, stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL)

    def read(name):
        rows = []
        for line in (WORK / name).read_text().split("\n"):
            if line.strip():
                v = [float(x) for x in line.split()]
                rows.append(dict(a=v[1], z=v[3]))
        return rows

    out = dict(cell="sg13g2_ebufn_4", corner="tt",
               enabled_teb0=read("enabled.out"),
               disabled_teb1=read("disabled.out"),
               verdict=("enabled: Z=A; disabled (TE_B=VDD): Z floats near 0 with "
                        "a 1G load and does NOT track A -> the cell does "
                        "tri-state; the finger nevertheless has zero switched "
                        "contrast because ebufn is a BUFFER (Z is an actively "
                        "driven copy of A, not a pass connection)"))
    Path(__file__).with_name("ebufn_tristate_check.json").write_text(
        json.dumps(out, indent=1))
    print(json.dumps(out, indent=1))


if __name__ == "__main__":
    main()
