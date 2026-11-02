# Per-PDK cell names for the custom/analog delay+arbiter cells.
# Verified against the installed .lib files (ciel PDK roots).

## sky130A  (SCL = sky130_fd_sc_hd)  VDD=1.8V
  delay buf : sky130_fd_sc_hd__clkdlybuf4s50_1  (matched clock delay stage)
  buf       : sky130_fd_sc_hd__clkbuf_4 / clkbuf_2 / clkbuf_1
  inv       : sky130_fd_sc_hd__clkinv_1 / inv_2
  nand      : sky130_fd_sc_hd__nand2_1, nand2b_1, nor2_1
  mux       : sky130_fd_sc_hd__mux2_1  (.A0,.A1,.S,.X)
  FF posedge: sky130_fd_sc_hd__dfrtp_1 (.D,.CLK,.RESET_B,.Q)
  FF negedge: sky130_fd_sc_hd__dfrtn_1 (.D,.CLK_N,.RESET_B,.Q)
  latch     : sky130_fd_sc_hd__dlxtp_1 / dlxtn_1 (.D,.GATE(.GATE_N),.Q)

## ihp-sg13g2  (SCL = sg13g2_stdcell)  VDD=1.2V
  delay cell: sg13g2_dlygate4sd1_1 / _4sd2_1 / _4sd3_1  (.A,.X)
  buf       : sg13g2_buf_1 / _2 / _4 / _8 ;  inv: sg13g2_inv_1/_2/_4
  nand      : sg13g2_nand2_1, nand2b_1, nor2_1, nor2b_1
  mux       : sg13g2_mux2_1 / _2   (.A0,.A1,.S,.X)
  FF        : sg13g2_dfrbpq_1 (posedge,.D,.CLK,.RESET_B,.Q)
              sg13g2_dfrbnq_1 (negedge)  -- verify exact names
  latch     : sg13g2_dlhqr_1 / dllrq_1  -- verify

## gf180mcuD  (SCL = gf180mcu_fd_sc_mcu9t5v0)  VDD=5.0V
  delay cell: gf180mcu_fd_sc_mcu9t5v0__dlya_1/_2/_4
              gf180mcu_fd_sc_mcu9t5v0__dlyb_* / dlyc_* / dlyd_*  (.A,.X)
  clk buf   : gf180mcu_fd_sc_mcu9t5v0__clkbuf_1/_2/_4/_8
  inv       : gf180mcu_fd_sc_mcu9t5v0__clkinv_1/_2/_4
  nand      : gf180mcu_fd_sc_mcu9t5v0__nand2_1/_2/_4
  mux       : gf180mcu_fd_sc_mcu9t5v0__mux2_1/_2/_4  (.I0,.I1,.S,.Z)
  FF posedge: gf180mcu_fd_sc_mcu9t5v0__dffq_1 (.D,.CK,.Q)
  FF negedge: gf180mcu_fd_sc_mcu9t5v0__dffnq_1 (.D,.CKN,.Q)
  FF w/rst  : gf180mcu_fd_sc_mcu9t5v0__dffrsnq_* (R,S), dffrnq_* (R)

## OR1 / OpenRule1um  (SCL = or1_fd_sc)  VDD=5.0V   [minimal SCL]
  buf       : BUFX2 (.A,.Y) ;  CLKBUFX2 (.A,.Y)
  inv       : INVX1 (.A,.Y)
  nand      : NAND2X1 (.A,.B,.Y) ;  NOR2X1 (.A,.B,.Y)
  FF posedge: DFFPOSX1 (.D,.CLK,.Q,.QB)         -- no reset
  FF w/rst  : DFFRX1 / DFFRX2 (.D,.CLK,.RESET,.Q,.QB)  -- active-HIGH reset
  tie       : TIEHI (.Y) / TIELO (.Y)
  fill      : FILL_*, DECAPX1, ENDCAPX1, ANTENNAX1, TAP
  -- NO delay cell, mux2, latch, or negedge FF.  Rebuild from primitives:
     DLY_STAGE = INVX1 legs + 3-NAND mux; ARB latch = NAND SR latch;
     negedge sampler = DFFRX1 on inverted clock.
  power pins: verilog models have NO VDD/VSS ports (flow injects);
     config uses VDD_PIN=vdd / SCL_POWER_PINS=VDD (LEF pins uppercase).
  lib       : or1_fd_sc_TT_5P0_25C.lib  (single corner, 5.0V)

# NOTE: exact pin names must be confirmed from each .lib before
# instantiation (e.g. mux2 order A0/A1 vs I0/I1, latch gate pin name).
