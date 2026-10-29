read_liberty /opt/adpll_gen/flow/sky130_lib/out/sky130_fd_sc_ms_ss_n40C_1v28.lib
read_verilog /tmp/opencode/sta_test/seq.v
link_design top
create_clock -name clk -period 3.0 [get_ports clk]
report_checks -path_delay max -format summary
report_checks -path_delay min -format summary
