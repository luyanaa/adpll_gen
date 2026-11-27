* loaded-tap PEX top: rx corner=ss coarse=23 fine=0 release=0.0ns init=0 pi_switch=5.0ns
.TEMP 125
.LIB "/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSlv.lib" mos_ss
* cornerMOSCAP has only the nominal (tt) section in this PDK;
* the cap device runs nominal at every MOS corner (documented).
.LIB "/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSCAP.lib" moscap_tt
.inc "/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/sg13g2_moscap_mod.lib"
.inc "/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice"
.inc dco_stage.sp
.PARAM lvdd=1.08
.OPTIONS RELTOL=3e-3 ABSTOL=1e-12 VNTOL=1e-6 GMIN=1e-12 TRTOL=15 ITL4=30
vvdd VDD 0 DC=1.08
vvss VSS 0 DC=0
ven DCO_EN 0 PWL(0n 0 0n 0 0.01n 1.08)
vrst RST_N 0 DC=1.08
vc0 C0 0 DC=1.08
vc1 C1 0 DC=1.08
vc2 C2 0 DC=1.08
vc3 C3 0 DC=0.0
vc4 C4 0 DC=1.08
vf0 F0 0 DC=0.0
vf1 F1 0 DC=0.0
vf2 F2 0 DC=0.0
vf3 F3 0 DC=0.0
vf4 F4 0 DC=0.0
vf5 F5 0 DC=1.08
* ---- the ring: 25 tuned stages, AND2X1 travelling-wave closure
Xst0 n0 n1 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst1 n1 n2 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst2 n2 n3 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst3 n3 n4 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst4 n4 n5 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst5 n5 n6 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst6 n6 n7 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst7 n7 n8 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst8 n8 n9 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst9 n9 n10 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst10 n10 n11 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst11 n11 n12 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst12 n12 n13 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst13 n13 n14 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst14 n14 n15 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst15 n15 n16 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst16 n16 n17 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst17 n17 n18 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst18 n18 n19 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst19 n19 n20 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst20 n20 n21 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst21 n21 n22 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst22 n22 n23 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst23 n23 n24 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xst24 n24 n25 C0 C1 C2 C3 C4 F0 F1 F2 F3 F4 F5 VDD VSS DCO_STAGE
Xclose n0 n25 DCO_EN VDD VSS sg13g2_and2_1
* ---- tap buffers at k*STEP
Xtap0 ph0 n0 VDD VSS sg13g2_buf_1
Xtap1 ph1 n3 VDD VSS sg13g2_buf_1
Xtap2 ph2 n6 VDD VSS sg13g2_buf_1
Xtap3 ph3 n9 VDD VSS sg13g2_buf_1
Xtap4 ph4 n12 VDD VSS sg13g2_buf_1
Xtap5 ph5 n15 VDD VSS sg13g2_buf_1
Xtap6 ph6 n18 VDD VSS sg13g2_buf_1
Xtap7 ph7 n21 VDD VSS sg13g2_buf_1
* ---- PRBS-7 data, UI=1.0ns
Vprbs data 0 PWL(0n 1.08 28n 1.08)
* ---- init state (0)
.ic V(n0)=0 V(n1)=lvdd V(n2)=0 V(n3)=lvdd V(n4)=0 V(n5)=lvdd V(n6)=0 V(n7)=lvdd V(n8)=0 V(n9)=lvdd V(n10)=0 V(n11)=lvdd V(n12)=0 V(n13)=lvdd V(n14)=0 V(n15)=lvdd V(n16)=0 V(n17)=lvdd V(n18)=0 V(n19)=lvdd V(n20)=0 V(n21)=lvdd V(n22)=0 V(n23)=lvdd V(n24)=0
* uic: start from the forced (possibly inconsistent) state
.TRAN 2p 24.0n uic
* (rate-sweep deck: ring + taps only; loads measured separately)
.control
set filetype=ascii
run
wrdata tran.out v(n0) v(ph0) v(ph1) v(ph2) v(ph3) v(ph4) v(ph5) v(ph6) v(ph7) v(ph0) v(ph1)
quit
.endc
.end