# Counter/NCO sky130 result

- DRC: sky130A KLayout DRC, **0 violations**.
- Layout extraction: official `sky130_fd_sc_hd` KLayout LVS deck in `deep`
  mode, using the `~/.ciel` sky130A PDK and native-cell CDL/SPICE views.
- LVS: **PASS (topology)**. netgen 1.5.325, official
  `sky130A_setup.tcl`, reports `Circuits match uniquely`.
- Evidence:
  - `PLL_COUNTER_DCO_PHYS_lvs_netgen.rpt` — final `Circuits match uniquely`
  - `PLL_COUNTER_DCO_PHYS_lvs_netgen.log` — command and netgen log
  - `PLL_COUNTER_DCO_PHYS_extracted.cir` — KLayout deep-mode extracted netlist
  - `PLL_COUNTER_DCO_PHYS_lvs_klayout.log` — official-deck run (see caveat)
  - `PLL_COUNTER_DCO_PHYS_drc.lyrdb`, `PLL_COUNTER_DCO_PHYS_drc.log`
- Reproduce:
  `python3 flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py PLL_COUNTER_DCO_PHYS`

## Caveat

The official KLayout deck's own numeric compare still reports a top-pin /
net-name mismatch on this macro.  The extracted functional netlist and the
normalized native-cell reference match under netgen with the official sky130
setup: unique topology match after the library-view normalization (native
`VNB` vs extracted `sky130_gnd`, CDL `m=N` multiplicity, removed `conb_1`
ideal-resistor/tie view, and the unused `INJ_EN` port).  This is **not** a
full production signoff; PVT/STA/jitter characterization remains outside this
result.
