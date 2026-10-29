# Post-layout OpenSTA for ics55 PLL_ANALOG_MACRO.
# Run from the repository root with: sta -exit flow/characterization/sta_ics55.tcl
set ROOT [expr {[info exists ::env(ROOT)] ? $::env(ROOT) : [pwd]}]
set env(ROOT_DIR) $ROOT
set env(PDK_ROOT) /grid
set env(PDK) ics55
set env(STD_CELL_LIBRARY) ics55_LLSC_H7CR
source $ROOT/lib/ics55_settings.tcl
read_liberty $SCL_LIB
read_verilog $ROOT/pnr/outputs/ics55/PLL_ANALOG_MACRO.v
link_design PLL_ANALOG_MACRO
read_sdc $ROOT/flow/macro/ics55_h7cr/PLL_ANALOG_MACRO.sdc.tcl
read_spef $ROOT/pnr/outputs/ics55/PLL_ANALOG_MACRO.spef
report_wns
report_tns
report_checks -path_delay max -format summary
report_checks -path_delay min -format summary
report_power
