# Per-corner post-route STA for the assembled IHP top.
#
# Why not LibreLane's own STA step: this design has 22900 instances, and with
# three *distinct* macro Liberty files per corner (9 loads total) LibreLane's
# bundled `sta` runs for well over 15 minutes per corner while emitting no log
# line, which looks like a hang.  Running OpenROAD directly per corner gives a
# controllable timeout, parallel execution and per-corner logs.
#
# Environment:
#   TOP        top module name (pll_macro_top)
#   TECH_LEF   sg13g2_tech.lef
#   CELL_LEF   sg13g2_stdcell.lef
#   MACRO_LEF  PLL_ANALOG.lef
#   STD_LIB    sg13g2_stdcell_<corner>.lib
#   MACRO_LIB  PLL_ANALOG_MACRO__<corner>.lib
#   NET        post-route netlist
#   SDC        constraints
#   TAG        corner tag for printing
set TAG $env(TAG)

read_lef $env(TECH_LEF)
read_lef $env(CELL_LEF)
read_lef $env(MACRO_LEF)
read_liberty $env(STD_LIB)
read_liberty $env(MACRO_LIB)

read_verilog $env(NET)
link_design $env(TOP)
read_sdc $env(SDC)

puts "=== $TAG : setup ==="
report_checks -path_delay max -group_count 1 -format summary -digits 4
puts "=== $TAG : hold ==="
report_checks -path_delay min -group_count 1 -format summary -digits 4
puts "=== $TAG : tns ==="
report_tns
puts "=== $TAG : wns ==="
report_wns
puts "=== $TAG : max slew/cap ==="
report_check_types -max_slew -max_cap -violators
exit
