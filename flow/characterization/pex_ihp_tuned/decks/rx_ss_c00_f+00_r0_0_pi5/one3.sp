.TEMP 125
.LIB /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSlv.lib mos_ss
.LIB /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSCAP.lib moscap_tt
.inc /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/sg13g2_moscap_mod.lib
.inc /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice
.inc stage_nocap.sp
.PARAM lvdd=1.08
vvdd VDD 0 DC=1.08
vin IN 0 PWL(0n 0 0.5n 0 0.6n 1.08 1.6n 1.08 1.7n 0 2.7n 0)
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
Xst IN OUT C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
.tran 5p 3n
.end
.control
run
wrdata one.out v(IN) v(OUT)
quit
.endc
