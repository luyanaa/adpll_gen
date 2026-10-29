# Minimal, locally authored LibreLane SCL config for `sg13g2_stdcell`.
#
# *** NOT the official IHP PDK integration. ***  Values are taken from the
# OpenROAD-flow-scripts ihp-sg13g2 platform (config.mk / pdn.tcl / README):
#   /opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2
#
# This is the 1.2 V core library (`sg13g2_stdcell`), NOT the 3.3 V
# `sg13g2_stdcell_hv` row that also exists under /grid/ihp130.

# Synthesis mapping files that ORFS ships.
set scl_dir "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)"
set orfs_dir "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)"

# Latch mapping from ORFS (cells_latch.v is platform-level, not in libs.ref;
# the assembly script links the whole ORFS platform as ../platform).
set ::env(SYNTH_LATCH_MAP) "$::env(PDK_ROOT)/$::env(PDK)/platform/cells_latch.v"

# ---------------------------------------------------------------------------
# Placement site (sg13g2_stdcell.lef: SITE CoreSite, 0.48 x 3.78 um)
# ---------------------------------------------------------------------------
set ::env(PLACE_SITE) "CoreSite"

# ihp-sg13g2 has no welltap / endcap cells; leave WELLTAP_CELL and ENDCAP_CELL
# unset so those insertion steps skip.  (Same as the ORFS platform.)
# set ::env(WELLTAP_CELL) "..."
# set ::env(ENDCAP_CELL) "..."

# ---------------------------------------------------------------------------
# Synthesis cells (1.2 V library)
# ---------------------------------------------------------------------------
set ::env(SYNTH_DRIVING_CELL) "sg13g2_buf_4/X"
set ::env(SYNTH_CLK_DRIVING_CELL) "sg13g2_buf_16/X"
set ::env(OUTPUT_CAP_LOAD) 6.0
set ::env(SYNTH_BUFFER_CELL) "sg13g2_buf_1/A/X"
set ::env(SYNTH_TIEHI_CELL) "sg13g2_tiehi/L_HI"
set ::env(SYNTH_TIELO_CELL) "sg13g2_tielo/L_LO"

# ---------------------------------------------------------------------------
# Fill / decap / antenna
# ---------------------------------------------------------------------------
set ::env(FILL_CELLS) [list sg13g2_fill_1 sg13g2_fill_2]
set ::env(DECAP_CELLS) [list "sg13g2_decap_*"]
set ::env(DIODE_CELL) "sg13g2_antennanp/A"

set ::env(GPL_CELL_PADDING) 0
set ::env(DPL_CELL_PADDING) 0
set ::env(CELL_PAD_EXCLUDE) [list "sg13g2_fill_*" "sg13g2_decap_*"]

# ---------------------------------------------------------------------------
# PDN
# ---------------------------------------------------------------------------
set ::env(PDN_RAIL_WIDTH) 0.44

# ---------------------------------------------------------------------------
# Clock tree synthesis
# ---------------------------------------------------------------------------
set ::env(CTS_ROOT_BUFFER) "sg13g2_buf_16"
set ::env(CTS_CLK_BUFFERS) [list "sg13g2_buf_8" "sg13g2_buf_4" "sg13g2_buf_2"]

# ---------------------------------------------------------------------------
# Constraints
# ORFS does not set these for ihp-sg13g2.  The values below are the
# LibreLane/ORFS generic defaults (the same numbers the ics55 and sky130
# configs use); they are canary assumptions, not characterised IHP limits.
# ---------------------------------------------------------------------------
set ::env(MAX_FANOUT_CONSTRAINT) 10
set ::env(CLOCK_UNCERTAINTY_CONSTRAINT) 0.25
set ::env(CLOCK_TRANSITION_CONSTRAINT) 0.15
set ::env(TIME_DERATING_CONSTRAINT) 5
set ::env(IO_DELAY_CONSTRAINT) 20

# Match ORFS: exclude the cells ORFS marks DONT_USE.  The file is local to
# this canary; see synth_exclude.cells / pnr_exclude.cells in this directory.
if { [file exists "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/synth_exclude.cells"] } {
    set ::env(SYNTH_EXCLUDED_CELL_FILE) \
        "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/synth_exclude.cells"
}
if { [file exists "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/pnr_exclude.cells"] } {
    set ::env(PNR_EXCLUDED_CELL_FILE) \
        "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/pnr_exclude.cells"
}
