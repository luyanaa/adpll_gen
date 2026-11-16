# OpenSTA 4-segment bypass delay min/max.
# Environment:
#   STD_LIB : ics55 stdcell Liberty
#   NETLIST : Yosys gate netlist of SEGMENTED_DELAY4_MEAS
read_liberty $env(STD_LIB)
read_verilog $env(NETLIST)
link_design SEGMENTED_DELAY4_MEAS

create_clock -name CLK_IN -period 5.0 [get_ports CLK_IN]
set_input_transition 0.05 [get_ports CLK_IN]

puts "=== MIN coarse=0 fine=0 ==="
set_case_analysis 0 [get_ports {COARSE[*]}]
set_case_analysis 0 [get_ports {FINE[*]}]
report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
    -to [get_ports CLK_OUT] -format full_clock_expanded

puts "=== MAX coarse=4 fine=55 ==="
# COARSE=4 (3'b100), FINE=55 (6'b110111)
set_case_analysis 0 [get_ports {COARSE[0]}]
set_case_analysis 0 [get_ports {COARSE[1]}]
set_case_analysis 1 [get_ports {COARSE[2]}]
set_case_analysis 1 [get_ports {FINE[0]}]
set_case_analysis 1 [get_ports {FINE[1]}]
set_case_analysis 1 [get_ports {FINE[2]}]
set_case_analysis 0 [get_ports {FINE[3]}]
set_case_analysis 1 [get_ports {FINE[4]}]
set_case_analysis 1 [get_ports {FINE[5]}]
report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
    -to [get_ports CLK_OUT] -format full_clock_expanded
