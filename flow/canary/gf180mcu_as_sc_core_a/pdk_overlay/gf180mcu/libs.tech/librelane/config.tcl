# Canary-local top-level LibreLane PDK config for gf180mcu_as_sc_mcu7t3v3.
#
# WHY THIS FILE EXISTS
# --------------------
# The PDK at
#   /grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk
# ships only the standard-cell-level config:
#   libs.tech/librelane/gf180mcu_as_sc_mcu7t3v3/config.tcl
# It has no top-level libs.tech/librelane/config.tcl, and its SCL config does
# not define the view/PDN/routing variables LibreLane 3.0.16 requires from a
# PDK.  LibreLane validates PDK variables *before* merging a design config, so
# these values must live in the PDK config, not only in config.digital.yaml.
#
# This file is a canary-local shim.  It is NOT part of the PDK and does not
# modify it.  scripts/run_canary.sh creates these symlinks next to it:
#   pdk_overlay/gf180mcu/libs.ref -> <PDK>/libs.ref
#   pdk_overlay/gf180mcu/libs.tech/librelane/gf180mcu_as_sc_mcu7t3v3
#       -> <PDK>/libs.tech/librelane/gf180mcu_as_sc_mcu7t3v3
#
# SIGN-OFF CAVEAT
# ---------------
# The PDK has no Magic tech, KLayout tech/DRC/LVS decks, Netgen setup or
# OpenRCX rules.  The MAGIC*/KLAYOUT*/NETGEN_SETUP variables below point at
# pdk_overlay/placeholders/not_a_deck only so PDK validation passes.  The
# canary driver skips every step that would consume them.  Do not run those
# steps against this overlay and do not claim DRC/LVS/streamout signoff.

set ::env(STD_CELL_LIBRARY) "gf180mcu_as_sc_mcu7t3v3"

set pdk_dir "$::env(PDK_ROOT)/$::env(PDK)"
set scl "$::env(STD_CELL_LIBRARY)"
set scl_dir "$pdk_dir/libs.ref/$scl"
set scl_tech "$pdk_dir/libs.tech/librelane/$scl"
set placeholder "$::env(PDK_ROOT)/placeholders/not_a_deck"

# --- Power / ground ---------------------------------------------------------
set ::env(VDD_PIN) "VDD"
set ::env(GND_PIN) "VSS"
# VNW is the n-well bias (VDD) and VPW the p-well bias (VSS).  They are
# USE POWER/GROUND pins in the LEF; without global connections OpenROAD's
# disconnected-pin checker flags every cell's VNW/VPW as critical.
set ::env(SCL_POWER_PINS) [list "VDD" "VNW"]
set ::env(SCL_GROUND_PINS) [list "VSS" "VPW"]

# --- Views -----------------------------------------------------------------
set ::env(TECH_LEFS) [list \
    "nom_*" "$scl_dir/techlef/${scl}__nom.tlef" \
    "min_*" "$scl_dir/techlef/${scl}__min.tlef" \
    "max_*" "$scl_dir/techlef/${scl}__max.tlef" \
]
set ::env(CELL_LEFS) [list "$scl_dir/lef/$scl.lef"]
set ::env(CELL_GDS) [list "$scl_dir/gds/$scl.gds"]
set ::env(CELL_VERILOG_MODELS) [list "$scl_dir/verilog/$scl.v"]
set ::env(CELL_SPICE_MODELS) [list "$scl_dir/cdl/$scl.cdl"]
set ::env(CELL_CDLS) [list "$scl_dir/cdl/$scl.cdl"]
set ::env(SYNTH_EXCLUDED_CELL_FILE) "$scl_tech/synth_exclude.cells"
set ::env(PNR_EXCLUDED_CELL_FILE) "$scl_tech/pnr_exclude.cells"
set ::env(FP_TRACKS_INFO) "$scl_tech/tracks.info"

# --- Routing ---------------------------------------------------------------
# gf180mcu layer names are Metal1..Metal5.
set ::env(RT_MIN_LAYER) "Metal2"
set ::env(RT_MAX_LAYER) "Metal5"
set ::env(IO_PIN_H_LAYER) "Metal3"
set ::env(IO_PIN_V_LAYER) "Metal2"
set ::env(GRT_LAYER_ADJUSTMENTS) [list 0.99 0 0 0 0]

# --- PDN -------------------------------------------------------------------
# Canary values from the tech LEF.  The SCL config sets FP_PDN_RAIL_WIDTH 0.6;
# PDN_RAIL_WIDTH is repeated here so validation sees the current name.
set ::env(PDN_RAIL_LAYER) "Metal1"
set ::env(PDN_RAIL_WIDTH) 0.6
set ::env(PDN_RAIL_OFFSET) 0.0
set ::env(PDN_VERTICAL_LAYER) "Metal4"
set ::env(PDN_HORIZONTAL_LAYER) "Metal5"
set ::env(PDN_VWIDTH) 1.12
set ::env(PDN_HWIDTH) 0.90
set ::env(PDN_VSPACING) 0.56
set ::env(PDN_HSPACING) 0.90
set ::env(PDN_VPITCH) 20
set ::env(PDN_HPITCH) 20
set ::env(PDN_VOFFSET) 5
set ::env(PDN_HOFFSET) 5
set ::env(PDN_CORE_RING) 0
set ::env(PDN_CORE_RING_VWIDTH) 2.0
set ::env(PDN_CORE_RING_HWIDTH) 2.0
set ::env(PDN_CORE_RING_VSPACING) 1.0
set ::env(PDN_CORE_RING_HSPACING) 1.0
set ::env(PDN_CORE_RING_VOFFSET) 2.0
set ::env(PDN_CORE_RING_HOFFSET) 2.0

# The SCL config sets WELLTAP_CELL/ENDCAP_CELL; this one is required with them.
set ::env(FP_TAPCELL_DIST) 20

# --- RCX -------------------------------------------------------------------
# No OpenRCX .rules files exist in this PDK.  Empty dict: RCX has no corners
# and produces no SPEF.  OpenROAD.RCX is skipped by the canary driver.
set ::env(RCX_RULESETS) [dict create]

# --- Signoff collateral that this PDK does not ship ------------------------
# Placeholders only; the corresponding steps are skipped.  See caveat above.
set ::env(MAGICRC) "$placeholder"
set ::env(MAGIC_TECH) "$placeholder"
set ::env(MAGIC_PDK_SETUP) "$placeholder"
set ::env(KLAYOUT_TECH) "$placeholder"
set ::env(KLAYOUT_PROPERTIES) "$placeholder"
set ::env(KLAYOUT_DEF_LAYER_MAP) "$placeholder"
set ::env(NETGEN_SETUP) "$placeholder"
set ::env(PRIMARY_GDSII_STREAMOUT_TOOL) "klayout"

# --- Timing corners --------------------------------------------------------
# The SCL config sets LIB / STA_CORNERS / DEFAULT_CORNER (3 Liberty files,
# 9 alias corner names).  The design config narrows STA_CORNERS/PNR_CORNERS
# to the three nominal PVT corners.
set ::env(TIMING_VIOLATION_CORNERS) [list "*"]
