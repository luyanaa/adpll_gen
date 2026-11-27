.TEMP 125
.LIB /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSlv.lib mos_ss
.inc /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice
vvdd VDD 0 DC=1.08
vvss VSS 0 DC=0
ven DCO_EN 0 DC=1.08
.ic V(n0)=0 V(n1)=1.08 V(n2)=0 V(n3)=1.08
Xi0 n0 n1 VDD VSS sg13g2_inv_1
Xi1 n1 n2 VDD VSS sg13g2_inv_1
Xi2 n2 n3 VDD VSS sg13g2_inv_1
Xclose n0 n3 DCO_EN VDD VSS sg13g2_and2_1
.tran 2p 6n uic
.control
run
wrdata INT_ss.out v(n0)
quit
.endc
.end
