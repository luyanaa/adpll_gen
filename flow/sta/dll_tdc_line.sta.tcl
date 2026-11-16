read_liberty $env(STD_LIB)
read_verilog $env(NETLIST)
link_design DLL_TDC_LINE_MEAS
create_clock -name CLK_IN -period 5.0 [get_ports CLK_IN]
set_input_transition 0.05 [get_ports CLK_IN]
puts "=== LINE MIN ==="
report_checks -unconstrained -path_delay min -from [get_ports CLK_IN] \
    -to [get_ports {TAP[320]}] -format full_clock_expanded
puts "=== LINE MAX ==="
report_checks -unconstrained -path_delay max -from [get_ports CLK_IN] \
    -to [get_ports {TAP[320]}] -format full_clock_expanded
