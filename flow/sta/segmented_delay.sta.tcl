# OpenSTA segmented delay min/max.
# Environment:
#   STD_LIB : ics55 stdcell Liberty (TT/SS/FF)
#   NETLIST : Yosys gate netlist of SEGMENTED_DELAY_MEAS
read_liberty $env(STD_LIB)
read_verilog $env(NETLIST)
link_design SEGMENTED_DELAY_MEAS

create_clock -name CLK_IN -period 5.0 [get_ports CLK_IN]
set_input_transition 0.05 [get_ports CLK_IN]

puts "=== MIN coarse=0 fine=0 ==="
set_case_analysis 0 [get_ports {COARSE[*]}]
set_case_analysis 0 [get_ports {FINE[*]}]
report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
    -to [get_ports CLK_OUT] -format full_clock_expanded

puts "=== MAX coarse=8 fine=27 ==="
# COARSE=8 (4'b1000), FINE=27 (5'b11011)
set_case_analysis 0 [get_ports {COARSE[0]}]
set_case_analysis 0 [get_ports {COARSE[1]}]
set_case_analysis 0 [get_ports {COARSE[2]}]
set_case_analysis 1 [get_ports {COARSE[3]}]
set_case_analysis 1 [get_ports {FINE[0]}]
set_case_analysis 1 [get_ports {FINE[1]}]
set_case_analysis 0 [get_ports {FINE[2]}]
set_case_analysis 1 [get_ports {FINE[3]}]
set_case_analysis 1 [get_ports {FINE[4]}]
report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
    -to [get_ports CLK_OUT] -format full_clock_expanded
