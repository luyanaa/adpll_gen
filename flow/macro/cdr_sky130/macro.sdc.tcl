# CDR_TOP: two clocks.
#   TICK    - loop filter / decode / FSM domain
#   rec_clk - recovered data-phase clock = TICK pushed through the DCDL
#             phase shifter.  It now drives the real sampler FFs (data +
#             edge phases), so it must be declared a clock; before the
#             samplers existed it was a dead stub and could be ignored.
create_clock -name TICK -period 10.000 [get_ports TICK]
# rec_clk is a DCDL phase-shift of TICK.  Declare it on the DCDL output
# pin (the final fine-stage output inverter drives both the REC_CLK port
# and the internal sampler FFs on net47).  Anchoring on the internal pin
# — not the output port — makes STA put the sampler FFs and the DCDL
# stage-select gating checks into the rec_clk domain.
create_generated_clock -name REC_CLK \
    -source [get_ports TICK] \
    -divide_by 1 \
    [get_pins -hierarchical {dcdl.u_fine.stage[30].impl.inv_1.impl/Y}]
# TICK and rec_clk are related (same source) but the serial DATA they
# sample is asynchronous and the loop hand-off is through the quasi-
# static PHASE_CODE — treat the domains as asynchronous for STA so the
# cross-domain sampler/decode paths are not checked.
set_clock_groups -asynchronous -group {TICK} -group {REC_CLK}
set_clock_uncertainty -setup 0.100 [all_clocks]
set_clock_uncertainty -hold  0.020 [all_clocks]

# DATA is an async serial input sampled by the recovered phases — a data
# port, not a clock, and not synchronous to either domain.
set_false_path -from [get_ports DATA]

# Config/loop controls are quasi-static on TICK.
set_input_delay -max 1.000 -clock TICK [get_ports {EN KI[*] PHASE_OFFS[*] PHASE_INIT[*] RST_N}]
set_output_delay -max 1.000 -clock TICK [get_ports {DATA_OUT LOCKED ERR PHASE_CODE[*]}]
set_load 0.020 [all_outputs]

# REC_CLK is an output clock, not a synchronous data output.
set_false_path -to [get_ports REC_CLK]

# Quasi-static config into the decode pipeline.
set_multicycle_path 4 -setup -from [get_ports {PHASE_OFFS[*] PHASE_INIT[*] KI[*]}]
set_multicycle_path 3 -hold  -from [get_ports {PHASE_OFFS[*] PHASE_INIT[*] KI[*]}]

# The DCDL delay-line tap selects (driven by the registered coarse_n /
# mid_n / fine_n decode) are quasi-static configuration, not a timed data
# path.  STA performs a clock-gating hold check on them because the
# select drives the nand gates that gate rec_clk inside each delay stage.
# They only ever change on the slow TICK domain while rec_clk is being
# re-locked, so waive the reg -> mux-select gating check.  Each delay
# stage's select feeds a nand: `mid.impl` is a nand2b with the select on
# `A_N`, `upp.impl` is a nand2 with the select on `A`.  Disable only
# those select-input arcs — never the chain-signal arc.
set_disable_timing [get_cells -hierarchical -regexp {.*\.mid\.impl}] -from {A_N}
set_disable_timing [get_cells -hierarchical -regexp {.*\.upp\.impl}] -from {A}
