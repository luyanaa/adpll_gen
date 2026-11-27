.TEMP 125
.LIB /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSlv.lib mos_ss
.LIB /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSCAP.lib moscap_tt
.inc /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/sg13g2_moscap_mod.lib
.inc /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice
.inc dco_stage.sp
vvdd VDD 0 DC=1.08
vvss VSS 0 DC=0
ven DCO_EN 0 PWL(0n 0 0.01n 0 0.02n 1.08)
.ic V(n0)=0 V(n1)=1.08 V(n2)=0 V(n3)=1.08 V(n4)=0
Xs0 n0 n1 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xs1 n1 n2 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xs2 n2 n3 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xs3 n3 n4 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
v0 C0 0 DC=0
v1 C1 0 DC=0
v2 C2 0 DC=0
v3 C3 0 DC=0
v4 C4 0 DC=0
v5 F0 0 DC=0
v6 F1 0 DC=0
v7 F2 0 DC=0
v8 F3 0 DC=0
v9 F4 0 DC=0
v10 F5 0 DC=0
Xclose n4 DCO_EN n0 VDD VSS sg13g2_and2_1
.tran 5p 10n uic
.control
run
wrdata r3.out v(n0) v(n1)
quit
.endc
.end
