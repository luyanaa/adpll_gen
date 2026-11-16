# OpenSTA DCDL min/max range measurement.
# Environment:
#   STD_LIB : ics55 stdcell Liberty (TT/SS/FF)
#   NETLIST : Yosys gate netlist of DCDL_RANGE_MEAS
read_liberty $env(STD_LIB)
read_verilog $env(NETLIST)
link_design DCDL_RANGE_MEAS

create_clock -name CLK_IN -period 5.0 [get_ports CLK_IN]
set_input_transition 0.05 [get_ports CLK_IN]

puts "=== MIN all-zero codes ==="
set_case_analysis 0 [get_ports {COARSE_MUX[*]}]
set_case_analysis 0 [get_ports {MID_MUX[*]}]
set_case_analysis 0 [get_ports {FINE_MUX[*]}]
report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
    -to [get_ports CLK_OUT] -format full_clock_expanded

puts "=== MAX all-one codes ==="
set_case_analysis 1 [get_ports {COARSE_MUX[*]}]
set_case_analysis 1 [get_ports {MID_MUX[*]}]
set_case_analysis 1 [get_ports {FINE_MUX[*]}]
report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
    -to [get_ports CLK_OUT] -format full_clock_expanded
