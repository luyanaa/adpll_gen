# Post-layout OpenSTA for IHP PLL_ANALOG_MACRO (TT, no IO).
# Run from the repository root with: sta -exit flow/characterization/sta_ihp.tcl
set ROOT [expr {[info exists ::env(ROOT)] ? $::env(ROOT) : [pwd]}]
set env(ROOT_DIR) $ROOT
set env(PDK_ROOT) $ROOT/flow/canary/ihp130_sg13g2_core_a/build/pdk_root
set env(PDK) ihp-sg13g2
set env(NO_IO) 1
source $ROOT/lib/ihp-sg13g2_settings.tcl
read_liberty [lindex $LIBS 0]
read_verilog $ROOT/pnr/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.v
link_design PLL_ANALOG_MACRO
read_sdc $ROOT/flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.sdc.tcl
read_spef $ROOT/pnr/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.spef
report_wns
report_tns
report_checks -path_delay max -format summary
report_checks -path_delay min -format summary
report_power
