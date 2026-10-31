# Core B ring DCO on sky130_fd_sc_hd (experiment)

Physical P&R view built with LibreLane on the OpenPDK `sky130_fd_sc_hd`
library.  This is an experiment, not a signoff claim.

- Top: `PLL_RING_DCO_PHYS`
- PDK/library: `sky130_fd_sc_hd`
- Views: GDS/LEF/LIB/DEF/Verilog/CDL/SPICE
- DRC: **0 violations** (sky130A KLayout deck, `run_mode=deep`)
- LVS: **FAIL** — the sky130 KLayout deck reports a top/netlist mismatch
  with the native cell CDL; this reproduces the historical sky130 cell-view
  limitation and is not claimed as passing.
- Timing: P&R completed; no signoff STA/PVT.

The LVS attempt also removes the known broken `macro_sparecell` subcircuit
from the combined cell CDL (it has a pin-count mismatch in the shipped file);
the remaining mismatch is at top/cell device comparison.  Evidence:
`PLL_RING_DCO_PHYS_drc.lyrdb`, `PLL_RING_DCO_PHYS_lvs.log`,
`PLL_RING_DCO_PHYS_extracted.cir`.
