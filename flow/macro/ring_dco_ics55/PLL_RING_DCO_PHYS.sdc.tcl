# Planning constraints for the physical ring-DCO macro.
create_clock -name REF -period 10.000 [get_ports REF]
# OUT/MID_OUT are the free-running ring outputs; no timing relationship to REF
# is assumed before characterization.
set_clock_uncertainty -setup 0.100 [get_clocks REF]
set_input_delay -max 5.000 -clock REF [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*] DCO_EN INJ_EN}]
set_load 0.050 [all_outputs]
