# TDC_TOP: two clock domains.  TICK clocks the SAR FSM / decoders; REF is
# the measured reference edge through the DCDL.  Async -> group them.
create_clock -name TICK -period 10.000 [get_ports TICK]
create_clock -name REF  -period 10.000 [get_ports REF]
set_clock_groups -asynchronous -group {TICK} -group {REF}
set_clock_uncertainty -setup 0.100 [all_clocks]
set_clock_uncertainty -hold 0.020 [all_clocks]

# SIG is the (asynchronous) measured input, START the conversion strobe.
set_input_delay -max 1.000 -clock TICK [get_ports {START RST_N}]
set_output_delay -max 1.000 -clock TICK [get_ports {DONE BUSY TDC_CODE[*]}]
set_load 0.020 [all_outputs]
