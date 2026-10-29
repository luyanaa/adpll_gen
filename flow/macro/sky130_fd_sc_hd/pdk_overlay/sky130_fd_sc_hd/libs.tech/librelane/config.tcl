# Minimal LibreLane PDK shim for sky130_fd_sc_hd.  The library tree has
# aggregate LEF/GDS/Liberty/Verilog but no LibreLane config.  Signoff
# placeholders are deliberately fake and the flow skips KLayout/Magic steps.
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"
set pdk_dir "$::env(PDK_ROOT)/$::env(PDK)"
set scl "$::env(STD_CELL_LIBRARY)"
set scl_dir "$pdk_dir/libs.ref/$scl"
set placeholder "$::env(PDK_ROOT)/placeholders/not_a_deck"

set ::env(VDD_PIN) "VPWR"
set ::env(GND_PIN) "VGND"
set ::env(SCL_POWER_PINS) [list "VPWR" "VPB"]
set ::env(SCL_GROUND_PINS) [list "VGND" "VNB"]

set ::env(TECH_LEFS) [list \
  "nom_*" "$scl_dir/techlef/${scl}__nom.tlef" \
  "min_*" "$scl_dir/techlef/${scl}__min.tlef" \
  "max_*" "$scl_dir/techlef/${scl}__max.tlef" ]
set ::env(CELL_LEFS) [list "$scl_dir/lef/$scl.lef"]
set ::env(CELL_GDS) [list "$scl_dir/gds/${scl}.gds"]
set ::env(CELL_VERILOG_MODELS) [list "$scl_dir/verilog/$scl.v"]
set ::env(CELL_SPICE_MODELS) [list "$scl_dir/spice/${scl}.spice"]
set ::env(CELL_CDLS) [list "$scl_dir/cdl/${scl}.cdl"]

set ::env(RT_MIN_LAYER) "met1"
set ::env(RT_MAX_LAYER) "met5"
set ::env(IO_PIN_H_LAYER) "met3"
set ::env(IO_PIN_V_LAYER) "met2"

set ::env(PDN_RAIL_LAYER) "met1"
set ::env(PDN_RAIL_WIDTH) 0.48
set ::env(PDN_RAIL_OFFSET) 0.0
set ::env(PDN_VERTICAL_LAYER) "met4"
set ::env(PDN_HORIZONTAL_LAYER) "met5"
set ::env(PDN_VWIDTH) 0.96
set ::env(PDN_HWIDTH) 1.6
set ::env(PDN_VSPACING) 0.48
set ::env(PDN_HSPACING) 1.6
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
set ::env(WELLTAP_CELL) "sky130_fd_sc_hd__tapvpwrvgnd_1"
set ::env(ENDCAP_CELL) "sky130_fd_sc_hd__tapvpwrvgnd_1"

set ::env(LIB) [dict create "*_tt_025C_1v80" [list "$scl_dir/lib/${scl}__tt_025C_1v80.lib"]]
set ::env(STA_CORNERS) [list "nom_tt_025C_1v80"]
set ::env(PNR_CORNERS) [list "nom_tt_025C_1v80"]
set ::env(DEFAULT_CORNER) "nom_tt_025C_1v80"
set ::env(RCX_RULESETS) [dict create]

set ::env(MAGIC_TECH) "$placeholder"
set ::env(MAGIC_PDK_SETUP) "$placeholder"
set ::env(KLAYOUT_TECH) "$placeholder"
set ::env(KLAYOUT_PROPERTIES) "$placeholder"
set ::env(KLAYOUT_DEF_LAYER_MAP) "$placeholder"
set ::env(NETGEN_SETUP) "$placeholder"
set ::env(PRIMARY_GDSII_STREAMOUT_TOOL) "klayout"

set ::env(PLACE_SITE) "unithd"
set ::env(CELL_PAD_EXCLUDE) [list "sky130_fd_sc_hd__fill_*" "sky130_fd_sc_hd__tap_*"]
set ::env(FP_TRACKS_INFO) "$pdk_dir/libs.tech/librelane/tracks.info"
set ::env(GRT_LAYER_ADJUSTMENTS) [list 0.99 0 0 0 0]
set ::env(DPL_CELL_PADDING) 0
set ::env(GPL_CELL_PADDING) 0
set ::env(CTS_ROOT_BUFFER) "sky130_fd_sc_hd__clkbuf_4"
set ::env(CTS_CLK_BUFFERS) [list "sky130_fd_sc_hd__clkbuf_4" "sky130_fd_sc_hd__clkbuf_8"]
set ::env(MAGICRC) "$placeholder"
set ::env(TIMING_VIOLATION_CORNERS) [list "*"]
set ::env(FILL_CELLS) [list "sky130_fd_sc_hd__fill_*"]
set ::env(DECAP_CELLS) [list "sky130_fd_sc_hd__decap_*"]

set ::env(SYNTH_EXCLUDED_CELL_FILE) "$pdk_dir/libs.tech/librelane/synth_exclude.cells"
set ::env(PNR_EXCLUDED_CELL_FILE) "$pdk_dir/libs.tech/librelane/pnr_exclude.cells"
set ::env(OUTPUT_CAP_LOAD) 0.05
set ::env(SYNTH_DRIVING_CELL) "sky130_fd_sc_hd__inv_2/Y"
set ::env(SYNTH_BUFFER_CELL) "sky130_fd_sc_hd__buf_2/A/X"
set ::env(SYNTH_TIEHI_CELL) "sky130_fd_sc_hd__conb_1/HI"
set ::env(SYNTH_TIELO_CELL) "sky130_fd_sc_hd__conb_1/LO"
