* dco_stage: tuned short-ring stage (dco_tuning_design.md)
.subckt DCO_STAGE IN OUT C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS
* the ring inverter itself
Xinv OUT IN VDD VSS sg13g2_inv_1
* coarse bit 0: 1 unit fingers, switch m=1
Xgbuf0 g0 C0 VDD VSS sg13g2_buf_1
Xsw0 bot0 g0 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=1
Xcap0_0 OUT bot0 sg13_moscap_n w=0.72u l=1.0u
* coarse bit 1: 2 unit fingers, switch m=1
Xgbuf1 g1 C1 VDD VSS sg13g2_buf_1
Xsw1 bot1 g1 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=1
Xcap1_0 OUT bot1 sg13_moscap_n w=0.72u l=1.0u
Xcap1_1 OUT bot1 sg13_moscap_n w=0.72u l=1.0u
* coarse bit 2: 4 unit fingers, switch m=1
Xgbuf2 g2 C2 VDD VSS sg13g2_buf_1
Xsw2 bot2 g2 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=1
Xcap2_0 OUT bot2 sg13_moscap_n w=0.72u l=1.0u
Xcap2_1 OUT bot2 sg13_moscap_n w=0.72u l=1.0u
Xcap2_2 OUT bot2 sg13_moscap_n w=0.72u l=1.0u
Xcap2_3 OUT bot2 sg13_moscap_n w=0.72u l=1.0u
* coarse bit 3: 8 unit fingers, switch m=1
Xgbuf3 g3 C3 VDD VSS sg13g2_buf_1
Xsw3 bot3 g3 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=1
Xcap3_0 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
Xcap3_1 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
Xcap3_2 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
Xcap3_3 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
Xcap3_4 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
Xcap3_5 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
Xcap3_6 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
Xcap3_7 OUT bot3 sg13_moscap_n w=0.72u l=1.0u
* coarse bit 4: 16 unit fingers, switch m=4
Xgbuf4 g4 C4 VDD VSS sg13g2_buf_1
Xsw4 bot4 g4 VSS VSS sg13_lv_nmos w=0.42u l=0.45u m=4
Xcap4_0 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_1 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_2 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_3 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_4 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_5 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_6 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_7 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_8 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_9 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_10 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_11 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_12 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_13 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_14 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
Xcap4_15 OUT bot4 sg13_moscap_n w=0.72u l=1.0u
* fine bit 0: 1 NAND3 fingers
Xgbuf5 g5 F0 VDD VSS sg13g2_buf_1
Xgbufn0 gbn0 g5 VDD VSS sg13g2_inv_1
* fine bit 1: 2 NAND3 fingers
Xgbuf6 g6 F1 VDD VSS sg13g2_buf_1
Xgbufn1 gbn1 g6 VDD VSS sg13g2_inv_1
* fine bit 2: 4 NAND3 fingers
Xgbuf7 g7 F2 VDD VSS sg13g2_buf_1
Xgbufn2 gbn2 g7 VDD VSS sg13g2_inv_1
* fine bit 3: 8 NAND3 fingers
Xgbuf8 g8 F3 VDD VSS sg13g2_buf_1
Xgbufn3 gbn3 g8 VDD VSS sg13g2_inv_1
* fine bit 4: 16 NAND3 fingers
Xgbuf9 g9 F4 VDD VSS sg13g2_buf_1
Xgbufn4 gbn4 g9 VDD VSS sg13g2_inv_1
* fine bit 5: 32 NAND3 fingers
Xgbuf10 g10 F5 VDD VSS sg13g2_buf_1
Xgbufn5 gbn5 g10 VDD VSS sg13g2_inv_1
Xdecap VDD VSS sg13g2_decap_4
.ends DCO_STAGE
