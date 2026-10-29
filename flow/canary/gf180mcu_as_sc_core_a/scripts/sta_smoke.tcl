# Optional OpenSTA smoke check for the gf180mcu digital-only canary netlist.
#
# This is NOT signoff: zero interconnect parasitics, no PLL_ANALOG macro, and
# the internally generated clocks (CKR, DSM_CK) are not declared.  It only
# proves that the netlist links and that the SDC is accepted by OpenSTA.
#
# Default: the Yosys netlist from `make synth-digital` and constraints/adpll.sdc.
# To check the LibreLane-routed netlist instead:
#   NETLIST=runs/RUN_.../final/nl/pll_logic.nl.v \
#   SDC_FILE=runs/RUN_.../final/sdc/pll_logic.sdc \
#   sta -exit scripts/sta_smoke.tcl
#
# Run from flow/canary/gf180mcu_as_sc_core_a.

if {[info exists ::env(NETLIST)]} {
    set netlist $::env(NETLIST)
} else {
    set netlist "build/yosys/pll_logic_net.v"
}
if {[info exists ::env(SDC_FILE)]} {
    set sdc_file $::env(SDC_FILE)
} else {
    set sdc_file "constraints/adpll.sdc"
}
if {[info exists ::env(LIBERTY)]} {
    set liberty $::env(LIBERTY)
} else {
    set liberty "/grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk/libs.ref/gf180mcu_as_sc_mcu7t3v3/lib/gf180mcu_as_sc_mcu7t3v3__tt_025C_3v30.lib"
}

read_liberty $liberty
read_verilog $netlist
link_design pll_logic
read_sdc $sdc_file

puts "=== clocks ==="
report_clock_properties
puts "=== worst max paths (TT, no parasitics) ==="
report_checks -path_delay max -format summary -group_count 5
puts "=== worst min paths (TT, no parasitics) ==="
report_checks -path_delay min -format summary -group_count 5
