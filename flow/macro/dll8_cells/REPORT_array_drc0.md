# Routed 127-finger DLL8 element bank: KLayout DRC 0

`dll8_line_array.gds` (top `dll8_line_array_top`) = **KLayout 0.30.12 DRC 0**
(0 violations).  bbox 16.38 x 346.62 um.

## Construction
- 127 finger instances: 64 even N (`DLL8_FINGER`) in a column at x=0,
  63 odd P (`DLL8_FINGER_P`) in a column at x=9.0 um, per
  `DLL8_ELEM_PHYS` (even N / odd P).
- Each finger carries its own **array escape tracks** (added to the proven
  DRC-0 unit cells): the switch source (MID) is routed left into the free
  guard-ring interior and up through V1/M2/V2 to an **M3 landing**; the
  switch gate (CTRL) is routed up to a second **M3 landing**.  Both fingers
  are individually DRC 0.
- **MID**: vertical M3 bus per column (N x2.94..3.23, P x+2.28..2.61) tapping
  every finger's source landing; the two column buses are tied at the top.
- **CTRL**: one M3 horizontal per finger leaving to the right at that finger's
  own row y (distinct y -> no cross), 64 N + 63 P control exits at their row
  pitch.  (N exits at x<=6.5, P exits at x+6.5.)
- **Shared well**: one 31/0 (NWell) + 32/0 (nBuLay) rectangle fully enclosing
  the P group (no internal notch -> no NBL.b), same recipe as the proven
  element.

## Notes / deviations
- Because P source and gate pads are only 70 nm apart, MID/CTRL escapes for
  the P finger use separate guard-ring-interior regions (MID to the left,
  CTRL up); verified DRC 0.
- Control exits leave on the two column sides (N right edge at 6.5 um, P right
  edge at PX+6.5) rather than one single edge; order is N-even ascending then
  P-odd ascending.  This is a test-macro deviation from "one edge".
- The two sg13g2_inv_4 stages and VDD/VSS rails are not yet placed (next).

## Update: VDD/VSS rails added (build_array5.py, also DRC 0)
- VSS: vertical M1 strap x2400..2560 merging the N psub guard-ring left rails.
- VDD: vertical M1 strap x5360..5520 merging the P nwell guard-ring right rails.
- Boundary labels VSS/VDD/MID added (M1/M2 text).
- `dll8_line_array.gds` = KLayout DRC 0 (16.38 x 346.82 um) with rails.
Remaining: sg13g2_inv_4 IN/OUT stages (LEF pin coords known: A=(0.48..2.0,
1.52..1.9), Y right side, VDD top rail y3.56..4.0, VSS bottom rail y-0.22..0.22).
