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
- Timing: gate-level STA TT/SS/FF PASS; ring transient NO_OSCILLATION; not a production signoff.

Reproduce with
`python3 flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py PLL_RING_DCO_PHYS`.
Evidence: `PLL_RING_DCO_PHYS_drc.lyrdb`,
`PLL_RING_DCO_PHYS_lvs_netgen.rpt`, `PLL_RING_DCO_PHYS_extracted.cir`.

- Characterization: gate-level STA TT/SS/FF PASS; **ring transient is
  NO_OSCILLATION at all corners** because the built netlist ties the
  injection-window input low. No sky130 ring frequency or jitter claim.
  See `flow/characterization/macro_char/CHARACTERIZATION.md`.
