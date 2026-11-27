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
