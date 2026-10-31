# Core B ring DCO on sky130_fd_sc_hd (experiment)

Physical P&R view built with LibreLane on the OpenPDK `sky130_fd_sc_hd`
library.  This is an experiment, not a signoff claim.

- Top: `PLL_RING_DCO_PHYS`
- PDK/library: `sky130_fd_sc_hd`
- Views: GDS/LEF/LIB/DEF/Verilog/CDL/SPICE
- DRC: **0 violations** (sky130A KLayout deck, `run_mode=deep`)
- LVS: **PASS (topology)** — netgen with the official sky130
  `sky130A_setup.tcl` reports `Circuits match uniquely`; layout extraction
  uses the official sky130 KLayout deck in `deep` mode.
- LVS caveat: the official KLayout deck's own numeric compare still reports a
  top-pin/net-name mismatch; see `PLL_RING_DCO_PHYS_lvs_klayout.log`.
- Timing: P&R completed; no signoff STA/PVT.

Reproduce with
`python3 flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py PLL_RING_DCO_PHYS`.
Evidence: `PLL_RING_DCO_PHYS_drc.lyrdb`,
`PLL_RING_DCO_PHYS_lvs_netgen.rpt`, `PLL_RING_DCO_PHYS_extracted.cir`.
