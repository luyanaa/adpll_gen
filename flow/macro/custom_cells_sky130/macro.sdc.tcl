create_clock -name REF -period 10.000 [get_ports REF]
create_clock -name CK  -period 10.000 [get_ports CK]
set_clock_groups -asynchronous -group {REF} -group {CK}
set_clock_uncertainty -setup 0.100 [all_clocks]
set_clock_uncertainty -hold  0.020 [all_clocks]
set_input_delay  -max 1.000 -clock CK [get_ports {IN_A SEL SIG RST_B}]
set_output_delay -max 1.000 -clock CK [get_ports {DLY_OUT ARB_OUT SAMP_POS SAMP_NEG}]
set_load 0.020 [all_outputs]
