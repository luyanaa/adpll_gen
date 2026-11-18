# Multi-corner macro Liberty / SDF extraction for an already-routed macro.
#
# Why this exists: pnr/tcl/pnr.tcl calls `write_timing_model` with only the
# `typ` corner defined, so the routed macro ships a TT-only Liberty.  The IHP
# top then has to reuse TT at SS/FF, which is not macro-valid
# (flow/IHP130_TAPEOUT_GAPS.md gap B4).
#
# This script loads the routed final database plus all three PDK cell
# libraries, defines typ/min/max corners against the same physical design, and
# writes one Liberty + SDF per corner.
#
# Environment:
#   PDK_ROOT     IHP SG13G2 PDK root (the CIEL checkout)
#   TOP          macro top name (default PLL_ANALOG_MACRO)
#   FINAL_DB     routed database (pnr/outputs/<tech>/<TOP>.final.db)
#   OUTDIR       output directory
set TOP $env(TOP)
set PDK_ROOT $env(PDK_ROOT)
set FINAL_DB $env(FINAL_DB)
set OUTDIR $env(OUTDIR)

set LIBDIR "$PDK_ROOT/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib"
set LIB_TT "$LIBDIR/sg13g2_stdcell_typ_1p20V_25C.lib"
set LIB_SS "$LIBDIR/sg13g2_stdcell_slow_1p08V_125C.lib"
set LIB_FF "$LIBDIR/sg13g2_stdcell_fast_1p32V_m40C.lib"

foreach f [list $LIB_TT $LIB_SS $LIB_FF] {
    if {![file exists $f]} {
        puts "ERROR: missing $f"
        exit 1
    }
}

file mkdir $OUTDIR

read_db $FINAL_DB

# typ = the corner the design was optimized against.  min uses the fast
# library, max uses the slow library; that is the standard SS/FF pairing for
# this PDK (matching the ORFS platform corners).
# define_corners creates STA *scenes*; write_timing_model/write_sdf take
# -scene, not -corner (OpenROAD 26Q4: "-corner is not a known keyword").
define_corners typ ff ss
read_liberty -corner typ $LIB_TT
read_liberty -corner ff  $LIB_FF
read_liberty -corner ss  $LIB_SS

foreach scene {typ ff ss} {
    set tag [expr {$scene eq "typ" ? "tt_1p20V_25C" : \
                  ($scene eq "ff" ? "ff_1p32V_m40C" : "ss_1p08V_125C")}]
    set lib "$OUTDIR/${TOP}__${tag}.lib"
    set sdf "$OUTDIR/${TOP}__${tag}.sdf"
    puts "=== writing $scene : $lib"
    if {[catch {write_timing_model -scene $scene $lib} err]} {
        puts "  write_timing_model failed: $err"
    } else {
        puts "  ok [file size $lib] bytes"
    }
    if {[catch {write_sdf -scene $scene -include_typ -divider . $sdf} err]} {
        puts "  write_sdf failed: $err"
    } else {
        puts "  ok [file size $sdf] bytes"
    }
}

puts "=== done"
exit
