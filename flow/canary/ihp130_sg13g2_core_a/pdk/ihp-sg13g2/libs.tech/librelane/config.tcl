# Minimal, locally authored LibreLane PDK config for the ihp130 canary.
#
# *** NOT the official IHP SG13G2 PDK integration. ***
# The full IHP PDK root (with `libs.tech/librelane` and KLayout signoff decks)
# is not installed in this environment.  This file only encodes the values
# needed to try the digital flow against the OpenROAD-flow-scripts
# `ihp-sg13g2` platform views:
#
#   /opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2
#
# Every path below resolves through $PDK_ROOT/$PDK/libs.ref/sg13g2_stdcell,
# which scripts/assemble_pdk_root.sh symlinks to the ORFS platform.
#
# Deliberately NOT provided (so LibreLane must skip, not fake, signoff):
#   - official IHP KLayout DRC/LVS runsets and netgen setup
#   - magic tech
#   - PDK-level LAYERS_RC/VIAS_R (RCX uses the ORFS OpenRCX rules file)
#
# 1.2 V core library only.  The 3.3 V `sg13g2_stdcell_hv` row in /grid/ihp130
# is a different library and must not be mixed into this run.

set ::env(PROCESS) 130
set ::env(DEF_UNITS_PER_MICRON) 1000

if { ![info exist ::env(STD_CELL_LIBRARY)] } {
    set ::env(STD_CELL_LIBRARY) "sg13g2_stdcell"
}

set ::env(VDD_NET) "VDD"
set ::env(GND_NET) "VSS"
set ::env(VDD_PIN) "VDD"
set ::env(GND_PIN) "VSS"

# ---------------------------------------------------------------------------
# Technology / cell views
# ---------------------------------------------------------------------------
set scl_dir "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)"

set ::env(TECH_LEFS) [list \
    "nom_*" "$scl_dir/lef/sg13g2_tech.lef" \
]

set ::env(CELL_LEFS)         [list "$scl_dir/lef/sg13g2_stdcell.lef"]
set ::env(CELL_GDS)          [list "$scl_dir/gds/sg13g2_stdcell.gds"]
set ::env(CELL_VERILOG_MODELS) [list "$scl_dir/verilog/sg13g2_stdcell.v"]
set ::env(CELL_SPICE_MODELS) [list "$scl_dir/cdl/sg13g2_stdcell.cdl"]
set ::env(CELL_CDLS)         [list "$scl_dir/cdl/sg13g2_stdcell.cdl"]

set ::env(SCL_POWER_PINS)  [list "VDD"]
set ::env(SCL_GROUND_PINS) [list "VSS"]

# ---------------------------------------------------------------------------
# Timing corners (the three corners the ORFS platform ships)
# ---------------------------------------------------------------------------
set ::env(DEFAULT_CORNER) "nom_tt_025C_1v20"
set ::env(TIMING_VIOLATION_CORNERS) [list \
    "nom_tt_025C_1v20" \
    "nom_ss_125C_1v08" \
    "nom_ff_n40C_1v32" \
]
set ::env(STA_CORNERS) [list \
    "nom_tt_025C_1v20" \
    "nom_ss_125C_1v08" \
    "nom_ff_n40C_1v32" \
]

set ::env(LIB) [dict create]
dict set ::env(LIB) "nom_tt_025C_1v20" \
    "$scl_dir/lib/sg13g2_stdcell_typ_1p20V_25C.lib"
dict set ::env(LIB) "nom_ss_125C_1v08" \
    "$scl_dir/lib/sg13g2_stdcell_slow_1p08V_125C.lib"
dict set ::env(LIB) "nom_ff_n40C_1v32" \
    "$scl_dir/lib/sg13g2_stdcell_fast_1p32V_m40C.lib"

# ---------------------------------------------------------------------------
# Routing / pin layers
# ---------------------------------------------------------------------------
set ::env(RT_MIN_LAYER) "Metal2"
set ::env(RT_MAX_LAYER) "Metal5"

set ::env(IO_PIN_H_LAYER) "Metal3"
set ::env(IO_PIN_V_LAYER) "Metal2"

set ::env(FP_TRACKS_INFO) \
    "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/librelane/$::env(STD_CELL_LIBRARY)/tracks.info"

# ---------------------------------------------------------------------------
# Stream-out
# ---------------------------------------------------------------------------
# No magic tech is installed; KLayout is present.
set ::env(PRIMARY_GDSII_STREAMOUT_TOOL) "klayout"

set ::env(KLAYOUT_TECH) \
    "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/tech/sg13g2.lyt"
set ::env(KLAYOUT_PROPERTIES) \
    "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/tech/sg13g2.lyp"
set ::env(KLAYOUT_DEF_LAYER_MAP) \
    "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/tech/sg13g2.map"

# Deliberately unset -> KLayout DRC/LVS must be skipped, not claimed:
#   KLAYOUT_DRC_RUNSET, KLAYOUT_LVS_SCRIPT, NETGEN_SETUP, MAGIC_PDK_SETUP

# ---------------------------------------------------------------------------
# RC extraction
# ---------------------------------------------------------------------------
# ORFS ships one OpenRCX pattern file for all three corners.  The assembly
# script links it to $scl_dir/rcx/IHP_rcx_patterns.rules.
set ::env(RCX_RULESETS) [list \
    "nom_tt_025C_1v20" "$scl_dir/rcx/IHP_rcx_patterns.rules" \
    "nom_ss_125C_1v08" "$scl_dir/rcx/IHP_rcx_patterns.rules" \
    "nom_ff_n40C_1v32" "$scl_dir/rcx/IHP_rcx_patterns.rules" \
]

# ---------------------------------------------------------------------------
# PDN
# ---------------------------------------------------------------------------
set ::env(PDN_MULTILAYER) 1
set ::env(PDN_RAIL_LAYER) "Metal1"
set ::env(PDN_RAIL_WIDTH) 0.44
set ::env(PDN_RAIL_OFFSET) 0.0

set ::env(PDN_VERTICAL_LAYER) "TopMetal1"
set ::env(PDN_VWIDTH) 2.2
set ::env(PDN_VSPACING) 2.0
set ::env(PDN_VPITCH) 75.6
set ::env(PDN_VOFFSET) 13.6

set ::env(PDN_HORIZONTAL_LAYER) "TopMetal2"
set ::env(PDN_HWIDTH) 2.2
set ::env(PDN_HSPACING) 2.0
set ::env(PDN_HPITCH) 75.6
set ::env(PDN_HOFFSET) 13.6

set ::env(PDN_CORE_RING) 0
# Required by LibreLane even when the ring is disabled.
set ::env(PDN_CORE_RING_VWIDTH) 5.0
set ::env(PDN_CORE_RING_HWIDTH) 5.0
set ::env(PDN_CORE_RING_VSPACING) 2.0
set ::env(PDN_CORE_RING_HSPACING) 2.0
set ::env(PDN_CORE_RING_VOFFSET) 4.5
set ::env(PDN_CORE_RING_HOFFSET) 4.5

set ::env(MACRO_BLOCKAGES_LAYER) "Metal1 Metal2 Metal3 Metal4 Metal5"

# 7 routing layers in the tech LEF: Metal1-5, TopMetal1-2.  No capacity
# reduction (canary values).
set ::env(GRT_LAYER_ADJUSTMENTS) [list 0 0 0 0 0 0 0]

# ---------------------------------------------------------------------------
# Signoff collateral placeholders
# ---------------------------------------------------------------------------
# The official IHP PDK magic tech, netgen setup and KLayout DRC/LVS decks are
# NOT installed.  LibreLane nevertheless requires these variables to be set.
# /dev/null makes the absence explicit: any Magic/Netgen/KLayout signoff step
# must be skipped, and no DRC/LVS result may be claimed from this canary.
# Replace with the real IHP PDK paths before running any signoff step.
set ::env(MAGICRC) "/dev/null"
set ::env(MAGIC_TECH) "/dev/null"
set ::env(MAGIC_PDK_SETUP) "/dev/null"
set ::env(NETGEN_SETUP) "/dev/null"
