# Core C counter/NCO on sky130_fd_sc_hd (experiment)

Physical P&R view built with LibreLane on `sky130_fd_sc_hd`.

- Top: `PLL_COUNTER_DCO_PHYS`
- Views: GDS/LEF/LIB/DEF/Verilog/CDL/SPICE
- DRC: **0 violations** (sky130A KLayout deck)
- GDS: the committed `PLL_COUNTER_DCO_PHYS.gds` is the Magic streamout
  view.  The KLayout streamout view is retained in the build run directory;
  its flattened decap hierarchy does not close the topology LVS on this
  macro.
- LVS: **PASS (topology)** — netgen with the official sky130
  `sky130A_setup.tcl` reports `Circuits match uniquely`; layout extraction
  uses the official sky130 KLayout deck in `deep` mode.
- LVS caveat: the official KLayout deck's own numeric compare still reports a
  top-pin/net-name mismatch; see `PLL_COUNTER_DCO_PHYS_lvs_klayout.log`.
- Timing: gate-level STA TT/SS/FF **PASS** at the 100 MHz TICK
  planning point (WNS +5.93/+1.47/+7.59 ns; SS max TICK ~117.2 MHz).

Reproduce the physical build with
`flow/macro/sky130_fd_sc_hd/make_pdk_root.sh build/pdk_root`, then
`librelane --manual-pdk --pdk-root build/pdk_root --pdk sky130_fd_sc_hd
--scl sky130_fd_sc_hd flow/macro/counter_dco_sky130/config.yaml`.
The helper assembles the real KLayout/Magic/Netgen tech tree; the in-repo
`pdk_overlay` alone only contains the LibreLane shim.

Reproduce DRC/LVS with
`python3 flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py PLL_COUNTER_DCO_PHYS`.
Evidence: `PLL_COUNTER_DCO_PHYS_drc.lyrdb`,
`PLL_COUNTER_DCO_PHYS_lvs_netgen.rpt`, `PLL_COUNTER_DCO_PHYS_extracted.cir`.

- Characterization: gate-level STA TT/SS/FF **PASS**; the former SS
  failure (WNS -0.640 ns, TNS -1.85 ns) is closed by the carry-select
  phase accumulator.  NCO quantization remains 380/370 ns (pp 10 ns,
  RMS 4.985 ns).  See
  `flow/characterization/macro_char/CHARACTERIZATION.md`.

## Timing change (2026-11-01)

The previous RTL let synthesis build a single 16-bit ripple-carry adder for
`phase + increment`; the SS TICK path was a 9-stage `maj3` carry chain plus
the output-toggle logic.  The accumulator is now a 16-bit carry-select adder:
the low byte propagates its carry directly, the high byte is computed with
carry-in 0 and 1 in parallel, and the result is selected by the low-byte
carry.  The unary MUX decode is also rewritten as three popcounts plus one
arithmetic update instead of 61 serial conditional subtracts.  The exact
`phase_sum`/overflow semantics and the NCO contract are unchanged; the
120k-cycle RTL equivalence check in `tb_accumulator_equivalence.v` against
the original serial-subtract model passes.

OpenROAD 2026-02-17's CTS pass segfaults in `separateMacroRegSinks` on this
two-clock macro, so the experiment keeps `RUN_CTS: false`.  The timing
evidence is gate-level OpenSTA with ideal clocks, not a post-CTS clock-tree
signoff.
