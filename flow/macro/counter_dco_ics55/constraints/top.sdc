create_clock -name TICK -period 1.0 [get_ports TICK]
create_clock -name REF -period 10.0 [get_ports REF] -add
set_clock_uncertainty 0.05 [get_clocks TICK]
set_false_path -from [get_clocks TICK] -to [get_clocks REF]
set_false_path -from [get_clocks REF] -to [get_clocks TICK]
