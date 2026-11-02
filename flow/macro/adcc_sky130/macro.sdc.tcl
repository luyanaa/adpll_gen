# ADCC_TOP: three asynchronous clock domains.
#   TICK   - loop filter / lock counters
#   CLK_IN - input clock corrected through the DCDL
#   SAMP   - incommensurate duty-sampling clock (async by design)
create_clock -name TICK   -period 10.000 [get_ports TICK]
create_clock -name CLK_IN -period 10.000 [get_ports CLK_IN]
create_clock -name SAMP   -period 11.100 [get_ports SAMP]
set_clock_groups -asynchronous -group {TICK} -group {CLK_IN} -group {SAMP}
set_clock_uncertainty -setup 0.100 [all_clocks]
set_clock_uncertainty -hold  0.020 [all_clocks]

# Config/loop controls are quasi-static on TICK.
set_input_delay -max 1.000 -clock TICK [get_ports {EN KI[*] DUTY_OFFS[*] DUTY_INIT[*] RST_N}]
set_output_delay -max 1.000 -clock TICK [get_ports {LOCKED ERR DUTY_CODE[*]}]
set_load 0.020 [all_outputs]

# CLK_OUT is a *corrected clock*, not a synchronous data output.
set_false_path -to [get_ports CLK_OUT]

# Quasi-static config into the decode pipeline.
set_multicycle_path 4 -setup -from [get_ports {DUTY_OFFS[*] DUTY_INIT[*] KI[*]}]
set_multicycle_path 3 -hold  -from [get_ports {DUTY_OFFS[*] DUTY_INIT[*] KI[*]}]
