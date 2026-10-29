# Optional OpenSTA smoke check for the digital-only canary netlist.
#
# This is NOT signoff: zero interconnect parasitics, no macro, no CTS, and the
# internally generated clocks (CKR, DSM_CK) are not declared.  It only proves
# that the synthesized H7CR netlist links and that constraints/adpll.sdc is
# accepted by OpenSTA.
#
# Run from flow/canary/ics55_h7cr_core_a after `make synth-digital`:
#   sta -exit scripts/sta_smoke.tcl

read_liberty /grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CR/liberty/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib
read_verilog build/yosys/pll_logic_net.v
link_design pll_logic
read_sdc constraints/adpll.sdc

puts "=== clocks ==="
report_clock_properties
puts "=== worst max paths (TT, no parasitics) ==="
report_checks -path_delay max -format summary -group_count 5
puts "=== worst min paths (TT, no parasitics) ==="
report_checks -path_delay min -format summary -group_count 5
