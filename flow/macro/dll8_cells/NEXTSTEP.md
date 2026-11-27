# DLL8 cell/array — NEXTSTEP (re-dispatch handoff)

## Proven / committed (KLayout 0.30.12)
- Element `dll8_elem_shared_well.gds`: DRC 0 (119.88x60.83).
- N finger `dll8_finger.gds` (`build_finger5.py`): DRC 0.
- P finger `dll8_finger_p.gds` (`build_finger_p.py`): DRC 0.
  P fixes: drain adjoining M1 pad (420..820) enclosing the S/D ContBar +
  190nm V1 (565..755); gate V1 190x190 (405..595,2070..2260); CTRL gp
  extension (280..580,1180..1620) + cont(350..510,1360..1520)+M1.
- Env:
  KL=/nix/store/1whjbzm6gw6l4h0sjxdv92lyw7lq1ar8-klayout-0.30.12/bin/klayout
  LD_LIBRARY_PATH=<qtbase-5.15.19>/lib:<klayout-0.30.12>/lib
  $KL -b -r <pdk>/libs.tech/klayout/tech/drc/ihp-sg13g2.drc \
      -rd input=<gds> -rd topcell=<cell> -rd report=<lyrdb>

## Finger pin reference (relative to device origin; DX=3400)
N finger (`DLL8_FINGER`): MID (source) M1 at (DX+70..230, 0..500);
  CTRL M1 at (DX+420..720, 80..340); CN M2 bridge gate->drain(DX+900..1060).
P finger (`DLL8_FINGER_P`): MID M1 at (DX+70..230,0..1000);
  CTRL M1 at (DX+300..560, 1320..1600); CN M2 to drain pad (DX+420..820).
Finger heights differ (N ~3.1um, P ~4.3um) -> use per-variant row pitch.

## NEXT: array 127x (even N / odd P)
1. Stack 127 fingers in one column at row pitch >= finger height + 0.5um
   (alternate DLL8_FINGER / DLL8_FINGER_P).  Sources land at x=DX+150.
2. MID bus: vertical M1 at x ~DX+120..180 connecting every source (M1 only -
   the CN M2 covers the N source and the P drain pad; do NOT put a V1 on the
   source).
3. CN: already local M2 inside each unit.
4. CTRL: each finger's CTRL M1 -> V1 -> M2 -> V2 -> vertical **M3** strap in a
   channel, one per finger at ~unit pitch, exiting one edge in thermometer
   order (finger 0..127) for the decoder.
5. VDD/VSS rails (M2/M3) + shared 31/0+32/0 over the P devices (recipe from
   dll8_elem_shared_well).  IN/OUT pins on the boundary.
6. KLayout DRC iterate to 0; COMMIT the array GDS before LVS.

## Then LVS + PEX
7. LVS: run_lvs.py / sg13g2.lvs vs CDL (inv4 x2 + 127 fingers even N/odd P;
   cap bottom N->VSS P->VDD).  Report device counts + whether moscap_p in
   shared nBuLay extracts as sg13_moscap_p.
8. PEX (xsect if RC else Magic PEX): BASE/mid delay vs SS 173.6/660.6; per-node
   C vs 0.96 fF/node incl code-0 wire fraction; mid-bus R/RC; common-mode test.
