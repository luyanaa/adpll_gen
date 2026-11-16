read_liberty $env(STD_LIB)
read_verilog $env(NETLIST)
link_design DLL_FULL_PERIOD_TOP
create_clock -name REF -period 5.0 [get_ports REF]
# OUT is the delayed line output; the TDC phase sampler is clocked by it.
create_clock -name OUT -period 5.0 [get_ports OUT]
puts "=== REF->REF ==="
report_checks -path_delay max -from [get_clocks REF] -to [get_clocks REF] \
    -format full_clock_expanded -sort_by_slack
write_sdf $env(SDF_OUT)
