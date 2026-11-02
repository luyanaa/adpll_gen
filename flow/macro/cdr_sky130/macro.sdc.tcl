# CDR_TOP: single synchronous domain on TICK.  DATA is an async serial
# input (sampled by the recovered phases, not a synchronous input), so it
# gets no clock constraint -- it is a data port, not a clock.
create_clock -name TICK -period 10.000 [get_ports TICK]
set_clock_uncertainty -setup 0.100 [get_clocks TICK]
set_clock_uncertainty -hold  0.020 [get_clocks TICK]

# Config/loop controls are quasi-static on TICK.
set_input_delay -max 1.000 -clock TICK [get_ports {EN KI[*] PHASE_OFFS[*] PHASE_INIT[*] RST_N}]
set_output_delay -max 1.000 -clock TICK [get_ports {DATA_OUT LOCKED ERR PHASE_CODE[*]}]
set_load 0.020 [all_outputs]

# REC_CLK is a *recovered clock* — TICK pushed through the DCDL phase
# shifter — not a synchronous data output.  It is an output clock, so it
# carries no output-delay/setup constraint against TICK.
set_false_path -to [get_ports REC_CLK]

# Quasi-static config into the decode pipeline.
set_multicycle_path 4 -setup -from [get_ports {PHASE_OFFS[*] PHASE_INIT[*] KI[*]}]
set_multicycle_path 3 -hold  -from [get_ports {PHASE_OFFS[*] PHASE_INIT[*] KI[*]}]
