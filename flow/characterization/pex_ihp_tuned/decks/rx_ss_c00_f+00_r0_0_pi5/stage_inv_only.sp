* dco_stage: tuned short-ring stage (dco_tuning_design.md)
.subckt DCO_STAGE IN OUT C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS
* the ring inverter itself
* coarse bit 0: 1 unit fingers, switch m=1
* coarse bit 1: 2 unit fingers, switch m=1
* coarse bit 2: 4 unit fingers, switch m=1
* coarse bit 3: 8 unit fingers, switch m=1
* coarse bit 4: 16 unit fingers, switch m=4
Rbleed ncf VSS 1G
* fine bit 0: 1 NAND3 fingers
* fine bit 1: 2 NAND3 fingers
* fine bit 2: 4 NAND3 fingers
* fine bit 3: 8 NAND3 fingers
* fine bit 4: 16 NAND3 fingers
* fine bit 5: 32 NAND3 fingers
.ends DCO_STAGE
Xinv OUT IN VDD VSS sg13g2_inv_1
