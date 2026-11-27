# DLL8 cell/array — NEXTSTEP (re-dispatch handoff)

## DONE (KLayout 0.30.12, sole signoff deck)
- Element `dll8_elem_shared_well.gds`: DRC 0.
- N finger `dll8_finger.gds` (`build_finger6.py`): DRC 0, WITH array escape
  tracks (MID via left guard-interior, CTRL via up) -> M3 landings.
- P finger `dll8_finger_p.gds` (`build_finger_p6.py`): DRC 0, same escapes.
- **Routed 127-finger array `dll8_line_array.gds` (`build_array4.py`):
  DRC 0** (16.38 x 346.62 um).  64 N + 63 P, MID = vertical M3 bus per
  column + top tie, CTRL = 127 M3 horizontals (one per finger, own row y),
  shared 31/0+32/0 fully enclosing the P group.
- Connectivity verified: merged M3 = **128 components = 1 MID + 127 CTRL**
  (no shorts).  MID taps every source landing; every CTRL strap separate.
- **KLayout LVS extraction** (net_only, deck sg13g2.lvs):
  64 sg13_moscap_n + 63 sg13_moscap_p (w=1u l=1u) + 64 nmos + 63 pmos
  switches.  **moscap_p inside the shared nBuLay DOES extract as
  sg13_moscap_p** (does not collapse/vanish).  See REPORT_lvs_extraction.md.
- PEX: see REPORT_pex_tooling.md (genuine tooling limit + ITF first-order
  RC: MID bus R ~105 ohm, mid wire C ~35..64 fF = 2..4% of 1.626 pF bank,
  common-mode -> no element tap spread from the bank).

## Env
  KL=/nix/store/1whjbzm6gw6l4h0sjxdv92lyw7lq1ar8-klayout-0.30.12/bin/klayout
  LD_LIBRARY_PATH=<qtbase-5.15.19>/lib:<klayout-0.30.12>/lib
  DRC: $KL -b -r <pdk>/libs.tech/klayout/tech/drc/ihp-sg13g2.drc \
        -rd input=<gds> -rd topcell=<cell> -rd report=<lyrdb>
  LVS: $KL -b -r <pdk>/libs.tech/klayout/tech/lvs/sg13g2.lvs \
        -rd input=<gds> -rd topcell=<cell> -rd run_mode=deep \
        -rd net_only=true -rd target_netlist=<cir> -rd log=<log>

## REMAINING (bounded, arithmetic)
1. Place the two `sg13g2_inv_4` stages (IN -> inv1 -> MID -> inv2 -> OUT) and
   VDD/VSS rails on the routed array; DRC to 0.  NOTE: the stdcell GDS gives
   only one M1 pin box for inv_4 (no explicit A/Y/VDD/VSS), so wiring must
   use the LEF/pin data (libs.ref LeF) or place inv_4 with its documented
   rail y-positions.  This is the same class of coordinate work as the
   fingers.
2. Full LVS compare vs element CDL (inv4 x2 + 127 fingers even N/odd P, cap
   bottom N->VSS / P->VDD).  net_only counts already confirmed; add CDL and
   compare.  Gate subcells have no explicit pins in the finger cell -> the
   deep extraction black-boxes them; either add pin labels or run with a CDL
   that mirrors the hierarchical structure, or flatten the array before LVS.
3. PEX: no RC tool in this PDK flow (REPORT_pex_tooling.md).  To get a real
   extracted delay you must add an external field-solver step (Raphael/Starrc
   using libs.tech/parasitics/itf) -- outside the allowed no-PDK-edit scope.
   The ITF first-order numbers are in REPORT_pex_tooling.md.
4. Split into 2 x 4-element macros per the earlier plan; the one-element
   routed bank above is the building block.

## Constraints unchanged
127 fingers / 1.0x1.0 um / element topology frozen / no PDK edits /
KLayout sole DRC deck.
