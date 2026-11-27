* dco_stage: tuned short-ring stage (dco_tuning_design.md)
.subckt DCO_STAGE IN OUT C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS
* the ring inverter itself
Xinv IN OUT VDD VSS sg13g2_inv_1
* coarse bit 0: 1 unit fingers, switch m=1
Xgbuf0 C0 g0 VDD VSS sg13g2_buf_1
Xsw0 bot0 g0 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=1
XCAPDIS_Xcap0_0 OUT bot0 sg13_moscap_n w=0.72u l=1.0u
* coarse bit 1: 2 unit fingers, switch m=1
Xgbuf1 C1 g1 VDD VSS sg13g2_buf_1
Xsw1 bot1 g1 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=1
XCAPDIS_Xcap1_0 OUT bot1 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap1_1 OUT bot1 sg13_moscap_n w=0.72u l=1.0u
* coarse bit 2: 4 unit fingers, switch m=1
Xgbuf2 C2 g2 VDD VSS sg13g2_buf_1
Xsw2 bot2 g2 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=1
XCAPDIS_Xcap2_0 OUT bot2 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap2_1 OUT bot2 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap2_2 OUT bot2 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap2_3 OUT bot2 sg13_moscap_n w=0.72u l=1.0u
* coarse bit 3: 8 unit fingers, switch m=1
Xgbuf3 C3 g3 VDD VSS sg13g2_buf_1
Xsw3 bot3 g3 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=1
XCAPDIS_Xcap3_0 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap3_1 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap3_2 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap3_3 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap3_4 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap3_5 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap3_6 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap3_7 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
* coarse bit 4: 16 unit fingers, switch m=4
Xgbuf4 C4 g4 VDD VSS sg13g2_buf_1
Xsw4 bot4 g4 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=4
XCAPDIS_Xcap4_0 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_1 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_2 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_3 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_4 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_5 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_6 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_7 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_8 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_9 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_10 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_11 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_12 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_13 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_14 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
XCAPDIS_Xcap4_15 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Rbleed ncf VSS 1G
* fine bit 0: 1 NAND3 fingers
Xgbuf5 F0 g5 VDD VSS sg13g2_buf_1
Xgbufn0 g5 gbn0 VDD VSS sg13g2_inv_1
XDIS_Xfine0_0 g5 OUT gbn0 ncf VDD VSS sg13g2_nand3_1
* fine bit 1: 2 NAND3 fingers
Xgbuf6 F1 g6 VDD VSS sg13g2_buf_1
Xgbufn1 g6 gbn1 VDD VSS sg13g2_inv_1
XDIS_Xfine1_0 g6 OUT gbn1 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine1_1 g6 OUT gbn1 ncf VDD VSS sg13g2_nand3_1
* fine bit 2: 4 NAND3 fingers
Xgbuf7 F2 g7 VDD VSS sg13g2_buf_1
Xgbufn2 g7 gbn2 VDD VSS sg13g2_inv_1
XDIS_Xfine2_0 g7 OUT gbn2 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine2_1 g7 OUT gbn2 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine2_2 g7 OUT gbn2 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine2_3 g7 OUT gbn2 ncf VDD VSS sg13g2_nand3_1
* fine bit 3: 8 NAND3 fingers
Xgbuf8 F3 g8 VDD VSS sg13g2_buf_1
Xgbufn3 g8 gbn3 VDD VSS sg13g2_inv_1
XDIS_Xfine3_0 g8 OUT gbn3 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine3_1 g8 OUT gbn3 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine3_2 g8 OUT gbn3 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine3_3 g8 OUT gbn3 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine3_4 g8 OUT gbn3 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine3_5 g8 OUT gbn3 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine3_6 g8 OUT gbn3 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine3_7 g8 OUT gbn3 ncf VDD VSS sg13g2_nand3_1
* fine bit 4: 16 NAND3 fingers
Xgbuf9 F4 g9 VDD VSS sg13g2_buf_1
Xgbufn4 g9 gbn4 VDD VSS sg13g2_inv_1
XDIS_Xfine4_0 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_1 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_2 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_3 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_4 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_5 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_6 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_7 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_8 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_9 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_10 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_11 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_12 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_13 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_14 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine4_15 g9 OUT gbn4 ncf VDD VSS sg13g2_nand3_1
* fine bit 5: 32 NAND3 fingers
Xgbuf10 F5 g10 VDD VSS sg13g2_buf_1
Xgbufn5 g10 gbn5 VDD VSS sg13g2_inv_1
XDIS_Xfine5_0 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_1 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_2 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_3 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_4 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_5 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_6 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_7 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_8 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_9 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_10 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_11 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_12 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_13 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_14 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_15 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_16 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_17 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_18 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_19 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_20 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_21 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_22 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_23 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_24 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_25 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_26 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_27 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_28 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_29 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_30 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
XDIS_Xfine5_31 g10 OUT gbn5 ncf VDD VSS sg13g2_nand3_1
Xdecap VDD VSS sg13g2_decap_4
.ends DCO_STAGE