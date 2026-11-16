read_liberty $env(STD_LIB)
read_verilog $env(NETLIST)
link_design DLL_TDC_PHYS_MEAS
create_clock -name REF -period 5.0 [get_ports REF]
create_clock -name ACQ -period 80.0 [get_ports ACQ_CLK]
create_clock -name OUT -period 5.0 [get_ports OUT]
create_clock -name MON -period 80.0 [get_ports MON_OUT]
create_clock -name PHASE -period 5.0 [get_ports PHASE_IN]
set_input_transition 0.05 [get_ports PHASE_IN]
# The phase sampler intentionally samples the delay-line wavefront with the
# measured OUT edge; this is a TDC aperture, not a synchronous data path.
set_clock_groups -asynchronous -group {REF ACQ PHASE} -group {OUT MON}
# Encoder/capture paths inside REF must fit one REF period.
set_max_delay 5.0 -from [get_clocks OUT] -to [get_clocks REF]
puts "=== PERIOD ENCODER (REF) ==="
report_checks -path_delay max -from [get_clocks REF] -to [get_clocks REF] \
    -format full_clock_expanded -sort_by_slack
puts "=== OUT->REF CAPTURE ==="
report_checks -path_delay max -from [get_clocks OUT] -to [get_clocks REF] \
    -format full_clock_expanded
puts "=== LINE PHASE TO SAMPLER D ==="
report_checks -unconstrained -path_delay max -from [get_ports PHASE_IN] \
    -to [get_pins u_tdc/u_phase/stage[319].u_cell/*]
write_sdf $env(SDF_OUT)
