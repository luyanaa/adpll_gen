# OpenSTA muxed delay-line min/max.
# Environment:
#   STD_LIB : ics55 stdcell Liberty (TT/SS/FF)
#   NETLIST : Yosys gate netlist of MUXED_DELAY_MEAS
read_liberty $env(STD_LIB)
read_verilog $env(NETLIST)
link_design MUXED_DELAY_MEAS

create_clock -name CLK_IN -period 5.0 [get_ports CLK_IN]
set_input_transition 0.05 [get_ports CLK_IN]

puts "=== SEL0 bypass ==="
set_case_analysis 0 [get_ports {SEL[*]}]
report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
    -to [get_ports CLK_OUT] -format full_clock_expanded

puts "=== SEL223 all stages ==="
# 223 = 0b11011111
set_case_analysis 1 [get_ports {SEL[0]}]
set_case_analysis 1 [get_ports {SEL[1]}]
set_case_analysis 1 [get_ports {SEL[2]}]
set_case_analysis 1 [get_ports {SEL[3]}]
set_case_analysis 1 [get_ports {SEL[4]}]
set_case_analysis 0 [get_ports {SEL[5]}]
set_case_analysis 1 [get_ports {SEL[6]}]
set_case_analysis 1 [get_ports {SEL[7]}]
report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
    -to [get_ports CLK_OUT] -format full_clock_expanded
