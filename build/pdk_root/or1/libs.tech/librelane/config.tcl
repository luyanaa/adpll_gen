# LibreLane PDK shim for OR1 / OpenRule1um (or1_fd_sc), 5.0V single corner.
# libs.ref symlinks to /grid/OpenRule1um/OR1PDK/OR1/libs.ref; this config
# supplies the LibreLane-3 variable names the OR1 PDK's own OpenLane-1.x
# config.tcl predates.  Signoff decks are placeholders — synthesis-only
# landing, KLayout/Magic steps skipped.
set ::env(STD_CELL_LIBRARY) "or1_fd_sc"
set pdk_dir "$::env(PDK_ROOT)/$::env(PDK)"
set scl "$::env(STD_CELL_LIBRARY)"
set scl_dir "$pdk_dir/libs.ref/$scl"

set ::env(VDD_PIN) "vdd"
set ::env(GND_PIN) "gnd"
set ::env(VDD_PIN_VOLTAGE) "5.00"
set ::env(GND_PIN_VOLTAGE) "0.00"
# Cell LEF power pins are uppercase VDD/VSS.
set ::env(SCL_POWER_PINS) [list "VDD"]
set ::env(SCL_GROUND_PINS) [list "VSS"]

set ::env(TECH_LEFS) [dict create]
dict set ::env(TECH_LEFS) "*" "$scl_dir/lef/OR1.tlef"
set ::env(CELL_LEFS) [list "$scl_dir/lef/$scl.lef"]
set ::env(CELL_GDS) [list "$scl_dir/gds/${scl}.gds"]
# The shipped or1_fd_sc.v uses bare `if(RESET) q<=0; else q<=D;` inside
# the FF always blocks; LibreLane's naive blackboxer strips the `if`
# line (matches its cell-instantiation regex) and leaves a dangling
# `else` -> lint error, regardless of begin/end wrapping.  The PDK
# already ships a correct empty-body blackbox `or1_fd_sc_bb.v` — use it
# directly so no re-blackboxing is needed.
set ::env(CELL_VERILOG_MODELS) [list "$pdk_dir/libs.ref_local/$scl/verilog/${scl}_bb.v"]
set ::env(CELL_SPICE_MODELS) [list "$scl_dir/spice/${scl}.sp"]
set ::env(CELL_CDLS) [list "$scl_dir/cdl/${scl}.cdl"]

# OR1: 1um, 3-metal (from the PDK's own librelane config).
set ::env(RT_MIN_LAYER) "metal1"
set ::env(RT_MAX_LAYER) "metal3"
set ::env(IO_PIN_H_LAYER) "metal3"
set ::env(IO_PIN_V_LAYER) "metal2"

set ::env(PDN_RAIL_LAYER) "metal1"
set ::env(PDN_RAIL_WIDTH) 1.0
set ::env(PDN_RAIL_OFFSET) 0.0
set ::env(PDN_VERTICAL_LAYER) "metal2"
set ::env(PDN_HORIZONTAL_LAYER) "metal3"
set ::env(PDN_VWIDTH) 1.0
set ::env(PDN_HWIDTH) 1.0
# OR1 1um rule: min spacing is 1.0um — straps must be >= that apart.
set ::env(PDN_VSPACING) 1.0
set ::env(PDN_HSPACING) 1.0
set ::env(PDN_VPITCH) 20
set ::env(PDN_HPITCH) 20
set ::env(PDN_VOFFSET) 5
set ::env(PDN_HOFFSET) 5
set ::env(PDN_CORE_RING) 0
set ::env(PDN_CORE_RING_VWIDTH) 1.0
set ::env(PDN_CORE_RING_HWIDTH) 1.0
set ::env(PDN_CORE_RING_VSPACING) 0.5
set ::env(PDN_CORE_RING_HSPACING) 0.5
set ::env(PDN_CORE_RING_VOFFSET) 2.0
set ::env(PDN_CORE_RING_HOFFSET) 2.0
set ::env(FP_TAPCELL_DIST) 20
set ::env(WELLTAP_CELL) "TAP"
set ::env(ENDCAP_CELL) "ENDCAPX1"

# Liberty: the PDK's only characterized corner is TT 5.0V 25C.  The
# LibreLane-3 LIB dict maps corner->lib; synthesise a nom_* key.
set ::env(LIB) [dict create "*_tt_5P0_25C" [list "$scl_dir/lib/${scl}_TT_5P0_25C.lib"]]
set ::env(STA_CORNERS) [list "nom_tt_5P0_25C"]
set ::env(PNR_CORNERS) [list "nom_tt_5P0_25C"]
set ::env(DEFAULT_CORNER) "nom_tt_5P0_25C"
set ::env(TIMING_VIOLATION_CORNERS) [list "*"]
set ::env(RCX_RULESETS) [dict create]

# Placement site from the SCL config.
set ::env(PLACE_SITE) "unit"
set ::env(FP_TRACKS_INFO) "$pdk_dir/libs.tech/librelane/$scl/tracks.info"
set ::env(GRT_LAYER_ADJUSTMENTS) [list 0.99 0 0]
set ::env(DPL_CELL_PADDING) 0
set ::env(GPL_CELL_PADDING) 0

# Clock tree: only BUFX2 / CLKBUFX2 exist.
set ::env(CTS_ROOT_BUFFER) "BUFX2"
set ::env(CTS_CLK_BUFFERS) [list "BUFX2" "CLKBUFX2"]
set ::env(CELL_CLK_PORT) "CLK"

# Fill / tie / driving cells for synthesis (OpenLane-1.x names the OR1
# config already uses, mapped to LibreLane-3 equivalents).
set ::env(FILL_CELLS) [list "FILL_*" "DECAPX1"]
set ::env(DECAP_CELLS) [list "DECAPX1"]
set ::env(CELL_PAD_EXCLUDE) [list "FILL_*" "ENDCAPX1" "DECAPX1" "ANTENNAX1"]
set ::env(OUTPUT_CAP_LOAD) 0.05
set ::env(SYNTH_DRIVING_CELL) "INVX1/Y"
set ::env(SYNTH_BUFFER_CELL) "BUFX2/A/Y"
set ::env(SYNTH_TIEHI_CELL) "TIEHI/Y"
set ::env(SYNTH_TIELO_CELL) "TIELO/Y"

# Signoff decks: real OR1 assets exist, point at them (steps skipped in
# the flow anyway).  DRC/LVS runsets are placeholders.
set placeholder "$::env(PDK_ROOT)/placeholders/not_a_deck"
set ::env(PRIMARY_GDSII_STREAMOUT_TOOL) "klayout"
set ::env(MAGICRC) "$pdk_dir/libs.tech/magic/OR1.magicrc"
set ::env(MAGIC_TECH) "$pdk_dir/libs.tech/magic/OR1.tech"
set ::env(MAGIC_PDK_SETUP) "$pdk_dir/libs.tech/magic/OR1.tcl"
set ::env(KLAYOUT_TECH) "$pdk_dir/libs.tech/klayout/tech/OR1.lyt"
set ::env(KLAYOUT_PROPERTIES) "$pdk_dir/libs.tech/klayout/tech/OR1.lyp"
set ::env(KLAYOUT_DEF_LAYER_MAP) "$pdk_dir/libs.tech/klayout/tech/OR1.map"
set ::env(NETGEN_SETUP) "$pdk_dir/libs.tech/netgen/OR1_setup.tcl"
set ::env(KLAYOUT_DRC_RUNSET) "$placeholder"
set ::env(KLAYOUT_DENSITY_RUNSET) "$placeholder"
set ::env(KLAYOUT_ANTENNA_RUNSET) "$placeholder"
set ::env(KLAYOUT_LVS_SCRIPT) "$placeholder"

# Cell exclude lists + synthesis constraint vars (OR1's own files).
set ::env(SYNTH_EXCLUDED_CELL_FILE) "$pdk_dir/libs.tech/librelane/$scl/no_synth.cells"
set ::env(PNR_EXCLUDED_CELL_FILE) "$pdk_dir/libs.tech/librelane/$scl/drc_exclude.cells"
set ::env(MAX_FANOUT_CONSTRAINT) 10
set ::env(MAX_TRANSITION_CONSTRAINT) 1.0
set ::env(MAX_CAPACITANCE_CONSTRAINT) 0.2
set ::env(CLOCK_UNCERTAINTY_CONSTRAINT) 0.25
set ::env(CLOCK_TRANSITION_CONSTRAINT) 0.15
set ::env(IO_DELAY_CONSTRAINT) 0.4
set ::env(TIME_DERATING_CONSTRAINT) 0.05
