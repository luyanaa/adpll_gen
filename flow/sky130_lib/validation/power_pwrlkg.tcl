read_liberty out/sky130_fd_sc_ms_ff_n40C_1v95_pwrlkg.lib
read_verilog /tmp/opencode/sta_test/seq.v
link_design top
create_clock -name clk -period 3.0 [get_ports clk]
report_power
