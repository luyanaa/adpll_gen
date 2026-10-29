read_liberty out/sky130_fd_sc_ms_ss_n40C_1v28.lib
read_verilog /tmp/opencode/sta_test/sta_test.v
link_design top
create_clock -name clk -period 5.0 [get_ports clk]
set_input_delay 0.5 -clock clk [get_ports d]
set_output_delay 0.5 -clock clk [get_ports q]
report_checks -path_delay max -format summary
report_checks -path_delay min -format summary
report_power
