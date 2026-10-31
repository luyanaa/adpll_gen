create_clock -name REF -period 20.000 [get_ports REF]
set_clock_groups -asynchronous -group {REF}
set_clock_uncertainty -setup 0.250 [get_clocks REF]
set_clock_uncertainty -hold 0.050 [get_clocks REF]
set_false_path -from [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*] DCO_EN INJ_EN}]
set_false_path -to [get_ports {OUT MID_OUT INJ_EDGE SS_BBPD[*]}]
set_load 0.050 [all_outputs]
