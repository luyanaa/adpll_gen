create_clock -name TICK -period 10.000 [get_ports TICK]
create_clock -name REF -period 100.000 [get_ports REF]
set_clock_groups -asynchronous -group {TICK} -group {REF}
set_clock_uncertainty -setup 0.100 [all_clocks]
set_clock_uncertainty -hold 0.020 [all_clocks]
set_false_path -from [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*] DCO_EN INJ_EN}]
set_false_path -to [get_ports {OUT MID_OUT INJ_EDGE SS_BBPD[*]}]
set_load 0.020 [all_outputs]
