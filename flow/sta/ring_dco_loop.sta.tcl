# SPEF-annotated loop-delay measurement for the extracted ring DCO.
#
# The ring is a combinational loop, so the driver cuts it at the oscillator's
# closing gate and exposes LOOP_IN/LOOP_OUT.  One traversal LOOP_IN->LOOP_OUT
# is half an oscillation period; the driver adds the max (rise) and min (fall)
# traversals to get the period.
#
# Environment:
#   LIB      : corner Liberty
#   SPEF     : extracted parasitics (names already flattened to match NETLIST)
#   NETLIST  : loop-cut, name-flattened macro netlist
#   CODES    : Tcl list of FINE codes to sweep
read_liberty $env(LIB)
read_verilog $env(NETLIST)
link_design PLL_RING_DCO_PHYS
if {[info exists env(SPEF)] && $env(SPEF) ne ""} { read_spef $env(SPEF) }

set_case_analysis 1 [get_ports DCO_EN]
set_case_analysis 0 [get_ports INJ_EN]
set_case_analysis 0 [get_ports REF]
# Coarse/mid are muxed delay lines: an all-zero code leaves the bank open.
# Default to the lowest closed tap; override with COARSE/MID.
set coarse [expr {[info exists env(COARSE)] ? $env(COARSE) : 0}]
set mid    [expr {[info exists env(MID)] ? $env(MID) : 0}]
foreach b {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14} {
  set_case_analysis [expr {$b < $coarse ? 1 : 0}] [get_ports "COARSE_MUX\[$b\]"]
  set_case_analysis [expr {$b < $mid ? 1 : 0}] [get_ports "MID_MUX\[$b\]"]
}
set_input_transition 0.020 [get_ports LOOP_IN]
set_load 0.001 [get_ports LOOP_OUT]

foreach c $env(CODES) {
  for {set b 0} {$b < 31} {incr b} {
    set_case_analysis [expr {$b < $c ? 1 : 0}] [get_ports "FINE_MUX\[$b\]"]
  }
  puts "RINGSTA_BEGIN fine=$c"
  report_checks -unconstrained -path_delay max -from [get_ports LOOP_IN] \
      -to [get_ports LOOP_OUT] -format full -digits 5 -group_count 1
  puts "RINGSTA_MID fine=$c"
  report_checks -unconstrained -path_delay min -from [get_ports LOOP_IN] \
      -to [get_ports LOOP_OUT] -format full -digits 5 -group_count 1
  puts "RINGSTA_END fine=$c"
}
exit
