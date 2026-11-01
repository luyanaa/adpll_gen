# ADDLL_TOP on sky130_fd_sc_hd

All-digital DLL for DDR PHY clock deskew, reusing the ADPLL blocks:
bang-bang `PLL_SSBBPD`, `pll_digital_loop_filter` degraded to an up/down
counter (KP=0), `pll_term_decoder_with_zero`, and the `COARSE`/`MID`/`FINE`
delay cells cascaded into a real tapped delay line
(`pll_counter_dcdl_phys.v`) — the DCO ring broken open.

- Top: `ADDLL_TOP` (interface/control-word spec: `src/ADDLL_SPEC.md`)
- Clocks: `TICK` (loop) + `CLK_IN` (delayed reference), asynchronous
- Functional model + closed-loop smoke: `src/addll_top_tb.v` (iverilog `-DSIMULATION`)

PnR run pending — config cloned from `counter_dco_sky130`.
