# OpenSTA tap-step measurement for the ics55 real-cell tap bus.
# Environment:
#   ICS55_LIB : ics55_LLSC_H7CR TT Liberty
#   NETLIST   : Yosys gate netlist of DCDL_TAP_STEP_MEAS
read_liberty $env(ICS55_LIB)
read_verilog $env(NETLIST)
link_design DCDL_TAP_STEP_MEAS

create_clock -name CLK_IN -period 5.0 [get_ports CLK_IN]
set_input_transition 0.05 [get_ports CLK_IN]
# Approximate the selector MUX input load at each tap.
set_load 0.002 [get_ports {TAP[*]}]

foreach g {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15} {
    puts "=== TAP$g ==="
    report_checks -unconstrained -path_delay max \
        -to [get_ports "TAP\[$g\]"] -format full_clock_expanded
}
