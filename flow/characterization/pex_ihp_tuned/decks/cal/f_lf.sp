* one switched fine finger C(on/off): 1V/us ramp on OUT, I = C dV/dt
.TEMP 25
.LIB /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSlv.lib mos_tt
.LIB /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSCAP.lib moscap_tt
.inc /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.tech/ngspice/models/sg13g2_moscap_mod.lib
.inc /home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice
vvdd VDD 0 DC=1.08
vvss VSS 0 DC=0
ven EN 0 PWL(0n 1.08 5n 1.08 5.01n 0 15n 0)
vout OUT 0 PWL(0n 0 100n 0 200n 1.08 300n 1.08 400n 0 500n 0)
Xsw mid EN OUT VSS sg13_lv_nmos w=0.42u l=0.45u
Rmid mid VSS 1G
Xcap ncf EN mid 0 VDD VSS sg13g2_nand3_1
Rbleed ncf VSS 1G
.tran 0.5n 510n
.control
run
wrdata fing_lf.out v(OUT) i(vout)
quit
.endc
.end
