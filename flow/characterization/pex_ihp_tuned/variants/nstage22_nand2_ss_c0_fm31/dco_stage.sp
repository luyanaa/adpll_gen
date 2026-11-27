* dco_stage: tuned short-ring stage (dco_tuning_design.md)
.subckt DCO_STAGE IN OUT C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS
* the ring inverter itself
Xinv OUT IN VDD VSS sg13g2_inv_4
* coarse bit 0: 1 unit fingers, gate-side switch m=1
Xgbuf0 g0 C0 VDD VSS sg13g2_buf_1
Xsw0 gn0 g0 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=1
Rgn0 gn0 VSS 1G
Xcap0_0 gn0 VSS sg13_moscap_n w=0.72u l=1.0u
* coarse bit 1: 2 unit fingers, gate-side switch m=1
Xgbuf1 g1 C1 VDD VSS sg13g2_buf_1
Xsw1 gn1 g1 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=1
Rgn1 gn1 VSS 1G
Xcap1_0 gn1 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap1_1 gn1 VSS sg13_moscap_n w=0.72u l=1.0u
* coarse bit 2: 4 unit fingers, gate-side switch m=2
Xgbuf2 g2 C2 VDD VSS sg13g2_buf_1
Xsw2 gn2 g2 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=2
Rgn2 gn2 VSS 1G
Xcap2_0 gn2 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap2_1 gn2 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap2_2 gn2 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap2_3 gn2 VSS sg13_moscap_n w=0.72u l=1.0u
* coarse bit 3: 8 unit fingers, gate-side switch m=4
Xgbuf3 g3 C3 VDD VSS sg13g2_buf_1
Xsw3 gn3 g3 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=4
Rgn3 gn3 VSS 1G
Xcap3_0 gn3 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap3_1 gn3 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap3_2 gn3 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap3_3 gn3 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap3_4 gn3 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap3_5 gn3 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap3_6 gn3 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap3_7 gn3 VSS sg13_moscap_n w=0.72u l=1.0u
* coarse bit 4: 16 unit fingers, gate-side switch m=8
Xgbuf4 g4 C4 VDD VSS sg13g2_buf_1
Xsw4 gn4 g4 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=8
Rgn4 gn4 VSS 1G
Xcap4_0 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_1 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_2 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_3 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_4 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_5 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_6 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_7 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_8 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_9 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_10 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_11 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_12 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_13 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_14 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
Xcap4_15 gn4 VSS sg13_moscap_n w=0.72u l=1.0u
* fine bit 0: 1 unit moscap fingers behind one switch
Xgbuf5 g5 F0 VDD VSS sg13g2_buf_1
Xfsw0 fgn0 g5 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=1
Rfgn0 fgn0 VSS 1G
Xfcap0_0 fgn0 VSS sg13_moscap_n w=0.15u l=0.5u
* fine bit 1: 2 unit moscap fingers behind one switch
Xgbuf6 g6 F1 VDD VSS sg13g2_buf_1
Xfsw1 fgn1 g6 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=1
Rfgn1 fgn1 VSS 1G
Xfcap1_0 fgn1 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap1_1 fgn1 VSS sg13_moscap_n w=0.15u l=0.5u
* fine bit 2: 4 unit moscap fingers behind one switch
Xgbuf7 g7 F2 VDD VSS sg13g2_buf_1
Xfsw2 fgn2 g7 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=1
Rfgn2 fgn2 VSS 1G
Xfcap2_0 fgn2 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap2_1 fgn2 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap2_2 fgn2 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap2_3 fgn2 VSS sg13_moscap_n w=0.15u l=0.5u
* fine bit 3: 8 unit moscap fingers behind one switch
Xgbuf8 g8 F3 VDD VSS sg13g2_buf_1
Xfsw3 fgn3 g8 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=2
Rfgn3 fgn3 VSS 1G
Xfcap3_0 fgn3 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap3_1 fgn3 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap3_2 fgn3 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap3_3 fgn3 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap3_4 fgn3 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap3_5 fgn3 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap3_6 fgn3 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap3_7 fgn3 VSS sg13_moscap_n w=0.15u l=0.5u
* fine bit 4: 16 unit moscap fingers behind one switch
Xgbuf9 g9 F4 VDD VSS sg13g2_buf_1
Xfsw4 fgn4 g9 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=4
Rfgn4 fgn4 VSS 1G
Xfcap4_0 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_1 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_2 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_3 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_4 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_5 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_6 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_7 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_8 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_9 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_10 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_11 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_12 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_13 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_14 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap4_15 fgn4 VSS sg13_moscap_n w=0.15u l=0.5u
* fine bit 5: 32 unit moscap fingers behind one switch
Xgbuf10 g10 F5 VDD VSS sg13g2_buf_1
Xfsw5 fgn5 g10 OUT VSS sg13_lv_nmos w=0.15u l=0.45u m=8
Rfgn5 fgn5 VSS 1G
Xfcap5_0 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_1 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_2 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_3 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_4 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_5 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_6 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_7 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_8 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_9 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_10 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_11 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_12 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_13 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_14 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_15 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_16 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_17 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_18 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_19 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_20 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_21 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_22 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_23 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_24 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_25 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_26 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_27 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_28 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_29 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_30 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xfcap5_31 fgn5 VSS sg13_moscap_n w=0.15u l=0.5u
Xdecap VDD VSS sg13g2_decap_4
.ends DCO_STAGE