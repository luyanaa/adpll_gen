# Core C counter/NCO on sky130_fd_sc_hd (experiment)

Physical P&R view built with LibreLane on `sky130_fd_sc_hd`.

- Top: `PLL_COUNTER_DCO_PHYS`
- Views: GDS/LEF/LIB/DEF/Verilog/CDL/SPICE
- DRC: **0 violations** (sky130A KLayout deck)
- LVS: **PASS (topology)** — netgen with the official sky130
  `sky130A_setup.tcl` reports `Circuits match uniquely`; layout extraction
  uses the official sky130 KLayout deck in `deep` mode.
- LVS caveat: the official KLayout deck's own numeric compare still reports a
  top-pin/net-name mismatch; see `PLL_COUNTER_DCO_PHYS_lvs_klayout.log`.
- Timing: gate-level STA TT/FF PASS, SS FAIL at 100 MHz TICK; not a production signoff.

Reproduce with
`python3 flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py PLL_COUNTER_DCO_PHYS`.
Evidence: `PLL_COUNTER_DCO_PHYS_drc.lyrdb`,
`PLL_COUNTER_DCO_PHYS_lvs_netgen.rpt`, `PLL_COUNTER_DCO_PHYS_extracted.cir`.

- Characterization: gate-level STA TT/FF PASS; **SS FAIL at 100 MHz
  TICK** (WNS -0.640 ns, TNS -1.85 ns). NCO quantization is 380/370 ns
  (pp 10 ns, RMS 4.985 ns). See
  `flow/characterization/macro_char/CHARACTERIZATION.md`.
