# Planning constraints for the physical ring-DCO macro.
create_clock -name REF -period 10.000 [get_ports REF]
# COARSE/MID/FINE are quasi-static tuning inputs.  They are asynchronous to the
# SS-BBPD sample and are not a synchronous control path in this macro.
set_false_path -from [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*] DCO_EN INJ_EN}] -to [get_clocks REF]
# OUT/MID_OUT are free-running ring outputs.  They are not timing-closed
# against REF; a real DCO/PVT characterization is a separate step.
set_false_path -to [get_ports {OUT MID_OUT}]
set_clock_uncertainty -setup 0.100 [get_clocks REF]
set_input_delay -max 1.000 -clock REF [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*] DCO_EN INJ_EN}]
set_output_delay -max 1.000 -clock REF [get_ports {SS_BBPD[*] INJ_EDGE}]
set_load 0.050 [all_outputs]
