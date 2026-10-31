# Core B ring DCO on sky130_fd_sc_hd (experiment)

Physical P&R view built with LibreLane on the OpenPDK `sky130_fd_sc_hd`
library.  This is an experiment, not a signoff claim.

- Top: `PLL_RING_DCO_PHYS`
- PDK/library: `sky130_fd_sc_hd`
- Views: GDS/LEF/LIB/DEF/Verilog/CDL/SPICE
- DRC: **0 violations** (sky130A KLayout deck, `run_mode=deep`)
- GDS: the committed `PLL_RING_DCO_PHYS.gds` is the KLayout streamout view.
- LVS: **PASS (topology)** — netgen with the official sky130
  `sky130A_setup.tcl` reports `Circuits match uniquely`; layout extraction
  uses the official sky130 KLayout deck in `deep` mode.
- LVS caveat: the official KLayout deck's own numeric compare still reports a
  top-pin/net-name mismatch; see `PLL_RING_DCO_PHYS_lvs_klayout.log`.
- Timing: gate-level STA TT/SS/FF PASS; post-fix ring transient oscillates
  at **43.08/27.64/13.48 MHz** for FF/TT/SS at the minimum code (the SS
  number is a one-period estimate).  Not a production signoff.
- The ring has no REF-clocked flops, and OpenROAD 2026-02-17's CTS pass
  segfaults on the sinkless clock, so the build keeps `RUN_CTS: false` and
  routes REF as an ordinary signal.  The timing evidence is gate-level
  OpenSTA with ideal clocks, not a post-CTS clock-tree signoff.

Reproduce the physical build with
`flow/macro/sky130_fd_sc_hd/make_pdk_root.sh build/pdk_root`, then
`librelane --manual-pdk --pdk-root build/pdk_root --pdk sky130_fd_sc_hd
--scl sky130_fd_sc_hd flow/macro/ring_dco_sky130/config.yaml`.
The helper assembles the real KLayout/Magic/Netgen tech tree; the in-repo
`pdk_overlay` alone only contains the LibreLane shim.

Reproduce DRC/LVS with
`python3 flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py PLL_RING_DCO_PHYS`.
Evidence: `PLL_RING_DCO_PHYS_drc.lyrdb`,
`PLL_RING_DCO_PHYS_lvs_netgen.rpt`, `PLL_RING_DCO_PHYS_extracted.cir`.

## Functional fix (2026-11-01)

The ring was not oscillating because of the sky130 `PLL_CELL_NOR2BX1`
mapping, not because of the delay chain.  `sky130_fd_sc_hd__nor2b_2`
implements `Y = !A & B_N`.  The wrapper drove `.A(A0), .B_N(B0)`, which
produced `!DCO_EN & INJ_WIN` instead of the intended `A0 & !B0`.
`PLL_RING_DCO_PHYS` ties `INJ_WIN=1'b0`, so `DCO_EN_INJ_WIN` was stuck at 0
and the sym-mux never passed `OSC_BALANCED` to `OUT`.  The wrapper now
drives `.A(B0), .B_N(A0)`.  In the rebuilt netlist the mux instance is
`.A(constant 0), .B_N(DCO_EN)`, so `DCO_EN=1` enables the free-running ring.
A truth-table check confirms `ZN = A0 & !B0` for all four input combinations.

Post-fix cell-level transient, minimum code: **FF 43.08 MHz** (period
23.215 ns, deterministic RMS 4.4 ps), **TT 27.64 MHz** (period 36.179 ns,
RMS 36.4 ps), **SS 13.48 MHz** (period 74.180 ns, two-edge one-period
estimate).  The transient is noiseless and has no routed RC; it is not a
random-jitter or phase-noise result.
