# Core C counter/NCO on sky130_fd_sc_hd (experiment)

Physical P&R view built with LibreLane on `sky130_fd_sc_hd`.

- Top: `PLL_COUNTER_DCO_PHYS`
- Views: GDS/LEF/LIB/DEF/Verilog/CDL/SPICE
- DRC: **0 violations** (sky130A KLayout deck)
- LVS: **FAIL** — top/cell netlist mismatch in the sky130 KLayout deck;
  no passing LVS is claimed.
- Timing: P&R completed; no signoff STA/PVT.

Evidence: `PLL_COUNTER_DCO_PHYS_drc.lyrdb`, `PLL_COUNTER_DCO_PHYS_lvs.log`,
`PLL_COUNTER_DCO_PHYS_extracted.cir`.
