# DLL8 cell/array — NEXTSTEP (re-dispatch handoff)

## Proven / committed
- Element `dll8_elem_shared_well.gds`: KLayout 0.30.12 DRC 0 (119.88x60.83).
- N finger `dll8_finger.gds` (`build_finger5.py`): KLayout DRC 0.
- P finger `dll8_finger_p.gds` (`build_finger_p.py`): **7 violations** (v2).
- KLayout deck + env:
  KL=/nix/store/1whjbzm6gw6l4h0sjxdv92lyw7lq1ar8-klayout-0.30.12/bin/klayout
  LD_LIBRARY_PATH=<qtbase-5.15.19>/lib:<klayout-0.30.12>/lib
  $KL -b -r <pdk>/libs.tech/klayout/tech/drc/ihp-sg13g2.drc \
      -rd input=<gds> -rd topcell=<cell> -rd report=<lyrdb>

## P finger remaining 7 (all pmos intrinsic geometry)
Measured pmos (1.0/0.13, nwell ring): gate poly (340..470, -180..1180) -> only
130 nm wide; S/D M1 (70..230,0..1000) and (580..740,0..1000) -> 160 nm wide.
moscap_p: gate plate (0..1000,-370..1370); S/D (20..980,-350..-90)/(1090..1350);
ring top (1570..1830).  Gate-contact fix already applied (poly to 2320, cont
2080..2240) -> now clear of the ring.

Fixes for the 7:
1. CntB.a/a1/h1 (6) at the pmos drain (3.87..4.14, 0.07..0.28): the S/D M1 is
   160 nm < min Via1 190.  Add an M1 pad adjoining the drain (same net) sized
   >=190+enclosure, then the V1; keep the ContBar M1 enclosure >=0.05.
2. V1.a (1) at the gate via (0.405..0.595,2.075..2.245): make exactly 200 nm
   (e.g. 0.40..0.60) to clear the 0.19 min/max rounding.
3. CTRL: the pmos gate poly (340..470) is <160 cont -> add a gp extension
   (e.g. 300..550) then cont+M1.

## Then
4. Array 127x (even N / odd P): mid=vertical M1 column at the source column
   (N source 70..230, P source 70..230 rel; CN M2 covers it so mid=M1 only),
   CN=local M2 (per unit), control=vertical M3 strap at the CTRL pad column,
   VDD/VSS rails, shared 31/0+32/0 over the P group (recipe proven in
   dll8_elem_shared_well).  DRC to 0.
5. KLayout LVS (run_lvs.py / sg13g2.lvs) vs element CDL (inv4 x2 + 127
   fingers even N / odd P; cap bottom N->VSS, P->VDD).  Report device counts
   and whether moscap_p in shared nBuLay extracts as sg13_moscap_p.
6. PEX (xsect if RC; else Magic PEX, caveat).  Report BASE/mid delay vs
   SS 173.6/660.6, per-node C vs 0.96 fF/node incl. code-0 wire fraction,
   mid-bus R/RC, common-mode confirmation.
