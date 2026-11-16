# OpenSTA duty/phase measurement for the ics55 differential CK pad.
# Environment:
#   IO_LIB  : ics55 IO Liberty (TT/SS/FF)
#   NETLIST : Yosys gate netlist of ICS55_CK_PAD_MEAS
read_liberty $env(IO_LIB)
read_verilog $env(NETLIST)
link_design ICS55_CK_PAD_MEAS

create_clock -name CK_PHY -period 5.0 [get_ports CK_PHY]
set_input_transition 0.05 [get_ports CK_PHY]
set_input_transition 0.05 [get_ports CK_PHY_N]
set_load 2.0 [get_ports {CK_T}]
set_load 2.0 [get_ports {CK_C}]

puts "=== CK_T ==="
report_checks -unconstrained -path_delay min_max \
    -from [get_ports CK_PHY] -to [get_ports {CK_T}] \
    -format full_clock_expanded
puts "=== CK_C ==="
report_checks -unconstrained -path_delay min_max \
    -from [get_ports CK_PHY_N] -to [get_ports {CK_C}] \
    -format full_clock_expanded
