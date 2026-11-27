* dco_stage: tuned short-ring stage (dco_tuning_design.md)
.subckt DCO_STAGE IN OUT C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS
* the ring inverter itself
Xinv OUT IN VDD VSS sg13g2_inv_1
* coarse bit 0: 1 unit fingers, switch m=1
Xgbuf0 g0 C0 VDD VSS sg13g2_buf_1
* coarse bit 1: 2 unit fingers, switch m=1
Xgbuf1 g1 C1 VDD VSS sg13g2_buf_1
* coarse bit 2: 4 unit fingers, switch m=1
Xgbuf2 g2 C2 VDD VSS sg13g2_buf_1
* coarse bit 3: 8 unit fingers, switch m=1
Xgbuf3 g3 C3 VDD VSS sg13g2_buf_1
* coarse bit 4: 16 unit fingers, switch m=4
Xgbuf4 g4 C4 VDD VSS sg13g2_buf_1
Rbleed ncf VSS 1G
* fine bit 0: 1 switched NAND3 fingers
Xgbuf5 g5 F0 VDD VSS sg13g2_buf_1
Xgbufn0 gbn0 g5 VDD VSS sg13g2_inv_1
Xfsw0_0 mid0_0 g5 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid0_0 mid0_0 VSS 20Meg
Xfine0_0 ncf g5 mid0_0 gbn0 VDD VSS sg13g2_nand3_1
* fine bit 1: 2 switched NAND3 fingers
Xgbuf6 g6 F1 VDD VSS sg13g2_buf_1
Xgbufn1 gbn1 g6 VDD VSS sg13g2_inv_1
Xfsw1_0 mid1_0 g6 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid1_0 mid1_0 VSS 20Meg
Xfine1_0 ncf g6 mid1_0 gbn1 VDD VSS sg13g2_nand3_1
Xfsw1_1 mid1_1 g6 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid1_1 mid1_1 VSS 20Meg
Xfine1_1 ncf g6 mid1_1 gbn1 VDD VSS sg13g2_nand3_1
* fine bit 2: 4 switched NAND3 fingers
Xgbuf7 g7 F2 VDD VSS sg13g2_buf_1
Xgbufn2 gbn2 g7 VDD VSS sg13g2_inv_1
Xfsw2_0 mid2_0 g7 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid2_0 mid2_0 VSS 20Meg
Xfine2_0 ncf g7 mid2_0 gbn2 VDD VSS sg13g2_nand3_1
Xfsw2_1 mid2_1 g7 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid2_1 mid2_1 VSS 20Meg
Xfine2_1 ncf g7 mid2_1 gbn2 VDD VSS sg13g2_nand3_1
Xfsw2_2 mid2_2 g7 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid2_2 mid2_2 VSS 20Meg
Xfine2_2 ncf g7 mid2_2 gbn2 VDD VSS sg13g2_nand3_1
Xfsw2_3 mid2_3 g7 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid2_3 mid2_3 VSS 20Meg
Xfine2_3 ncf g7 mid2_3 gbn2 VDD VSS sg13g2_nand3_1
* fine bit 3: 8 switched NAND3 fingers
Xgbuf8 g8 F3 VDD VSS sg13g2_buf_1
Xgbufn3 gbn3 g8 VDD VSS sg13g2_inv_1
Xfsw3_0 mid3_0 g8 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid3_0 mid3_0 VSS 20Meg
Xfine3_0 ncf g8 mid3_0 gbn3 VDD VSS sg13g2_nand3_1
Xfsw3_1 mid3_1 g8 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid3_1 mid3_1 VSS 20Meg
Xfine3_1 ncf g8 mid3_1 gbn3 VDD VSS sg13g2_nand3_1
Xfsw3_2 mid3_2 g8 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid3_2 mid3_2 VSS 20Meg
Xfine3_2 ncf g8 mid3_2 gbn3 VDD VSS sg13g2_nand3_1
Xfsw3_3 mid3_3 g8 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid3_3 mid3_3 VSS 20Meg
Xfine3_3 ncf g8 mid3_3 gbn3 VDD VSS sg13g2_nand3_1
Xfsw3_4 mid3_4 g8 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid3_4 mid3_4 VSS 20Meg
Xfine3_4 ncf g8 mid3_4 gbn3 VDD VSS sg13g2_nand3_1
Xfsw3_5 mid3_5 g8 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid3_5 mid3_5 VSS 20Meg
Xfine3_5 ncf g8 mid3_5 gbn3 VDD VSS sg13g2_nand3_1
Xfsw3_6 mid3_6 g8 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid3_6 mid3_6 VSS 20Meg
Xfine3_6 ncf g8 mid3_6 gbn3 VDD VSS sg13g2_nand3_1
Xfsw3_7 mid3_7 g8 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid3_7 mid3_7 VSS 20Meg
Xfine3_7 ncf g8 mid3_7 gbn3 VDD VSS sg13g2_nand3_1
* fine bit 4: 16 switched NAND3 fingers
Xgbuf9 g9 F4 VDD VSS sg13g2_buf_1
Xgbufn4 gbn4 g9 VDD VSS sg13g2_inv_1
Xfsw4_0 mid4_0 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_0 mid4_0 VSS 20Meg
Xfine4_0 ncf g9 mid4_0 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_1 mid4_1 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_1 mid4_1 VSS 20Meg
Xfine4_1 ncf g9 mid4_1 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_2 mid4_2 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_2 mid4_2 VSS 20Meg
Xfine4_2 ncf g9 mid4_2 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_3 mid4_3 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_3 mid4_3 VSS 20Meg
Xfine4_3 ncf g9 mid4_3 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_4 mid4_4 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_4 mid4_4 VSS 20Meg
Xfine4_4 ncf g9 mid4_4 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_5 mid4_5 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_5 mid4_5 VSS 20Meg
Xfine4_5 ncf g9 mid4_5 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_6 mid4_6 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_6 mid4_6 VSS 20Meg
Xfine4_6 ncf g9 mid4_6 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_7 mid4_7 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_7 mid4_7 VSS 20Meg
Xfine4_7 ncf g9 mid4_7 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_8 mid4_8 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_8 mid4_8 VSS 20Meg
Xfine4_8 ncf g9 mid4_8 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_9 mid4_9 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_9 mid4_9 VSS 20Meg
Xfine4_9 ncf g9 mid4_9 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_10 mid4_10 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_10 mid4_10 VSS 20Meg
Xfine4_10 ncf g9 mid4_10 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_11 mid4_11 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_11 mid4_11 VSS 20Meg
Xfine4_11 ncf g9 mid4_11 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_12 mid4_12 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_12 mid4_12 VSS 20Meg
Xfine4_12 ncf g9 mid4_12 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_13 mid4_13 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_13 mid4_13 VSS 20Meg
Xfine4_13 ncf g9 mid4_13 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_14 mid4_14 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_14 mid4_14 VSS 20Meg
Xfine4_14 ncf g9 mid4_14 gbn4 VDD VSS sg13g2_nand3_1
Xfsw4_15 mid4_15 g9 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid4_15 mid4_15 VSS 20Meg
Xfine4_15 ncf g9 mid4_15 gbn4 VDD VSS sg13g2_nand3_1
* fine bit 5: 32 switched NAND3 fingers
Xgbuf10 g10 F5 VDD VSS sg13g2_buf_1
Xgbufn5 gbn5 g10 VDD VSS sg13g2_inv_1
Xfsw5_0 mid5_0 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_0 mid5_0 VSS 20Meg
Xfine5_0 ncf g10 mid5_0 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_1 mid5_1 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_1 mid5_1 VSS 20Meg
Xfine5_1 ncf g10 mid5_1 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_2 mid5_2 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_2 mid5_2 VSS 20Meg
Xfine5_2 ncf g10 mid5_2 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_3 mid5_3 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_3 mid5_3 VSS 20Meg
Xfine5_3 ncf g10 mid5_3 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_4 mid5_4 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_4 mid5_4 VSS 20Meg
Xfine5_4 ncf g10 mid5_4 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_5 mid5_5 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_5 mid5_5 VSS 20Meg
Xfine5_5 ncf g10 mid5_5 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_6 mid5_6 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_6 mid5_6 VSS 20Meg
Xfine5_6 ncf g10 mid5_6 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_7 mid5_7 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_7 mid5_7 VSS 20Meg
Xfine5_7 ncf g10 mid5_7 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_8 mid5_8 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_8 mid5_8 VSS 20Meg
Xfine5_8 ncf g10 mid5_8 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_9 mid5_9 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_9 mid5_9 VSS 20Meg
Xfine5_9 ncf g10 mid5_9 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_10 mid5_10 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_10 mid5_10 VSS 20Meg
Xfine5_10 ncf g10 mid5_10 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_11 mid5_11 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_11 mid5_11 VSS 20Meg
Xfine5_11 ncf g10 mid5_11 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_12 mid5_12 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_12 mid5_12 VSS 20Meg
Xfine5_12 ncf g10 mid5_12 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_13 mid5_13 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_13 mid5_13 VSS 20Meg
Xfine5_13 ncf g10 mid5_13 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_14 mid5_14 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_14 mid5_14 VSS 20Meg
Xfine5_14 ncf g10 mid5_14 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_15 mid5_15 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_15 mid5_15 VSS 20Meg
Xfine5_15 ncf g10 mid5_15 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_16 mid5_16 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_16 mid5_16 VSS 20Meg
Xfine5_16 ncf g10 mid5_16 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_17 mid5_17 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_17 mid5_17 VSS 20Meg
Xfine5_17 ncf g10 mid5_17 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_18 mid5_18 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_18 mid5_18 VSS 20Meg
Xfine5_18 ncf g10 mid5_18 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_19 mid5_19 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_19 mid5_19 VSS 20Meg
Xfine5_19 ncf g10 mid5_19 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_20 mid5_20 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_20 mid5_20 VSS 20Meg
Xfine5_20 ncf g10 mid5_20 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_21 mid5_21 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_21 mid5_21 VSS 20Meg
Xfine5_21 ncf g10 mid5_21 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_22 mid5_22 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_22 mid5_22 VSS 20Meg
Xfine5_22 ncf g10 mid5_22 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_23 mid5_23 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_23 mid5_23 VSS 20Meg
Xfine5_23 ncf g10 mid5_23 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_24 mid5_24 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_24 mid5_24 VSS 20Meg
Xfine5_24 ncf g10 mid5_24 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_25 mid5_25 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_25 mid5_25 VSS 20Meg
Xfine5_25 ncf g10 mid5_25 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_26 mid5_26 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_26 mid5_26 VSS 20Meg
Xfine5_26 ncf g10 mid5_26 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_27 mid5_27 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_27 mid5_27 VSS 20Meg
Xfine5_27 ncf g10 mid5_27 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_28 mid5_28 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_28 mid5_28 VSS 20Meg
Xfine5_28 ncf g10 mid5_28 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_29 mid5_29 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_29 mid5_29 VSS 20Meg
Xfine5_29 ncf g10 mid5_29 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_30 mid5_30 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_30 mid5_30 VSS 20Meg
Xfine5_30 ncf g10 mid5_30 gbn5 VDD VSS sg13g2_nand3_1
Xfsw5_31 mid5_31 g10 OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid5_31 mid5_31 VSS 20Meg
Xfine5_31 ncf g10 mid5_31 gbn5 VDD VSS sg13g2_nand3_1
Xdecap VDD VSS sg13g2_decap_4
.ends DCO_STAGE
