# Routed DLL8_FINGER unit cell: KLayout DRC 0

## Result
`DLL8_FINGER` (moscap_n + nmos, 3-layer local routing) = **KLayout 0.30.12
DRC 0**.  bbox 6.44 x 3.11 um.  Iterations 13 -> 5 -> 8 -> 4 -> 1 -> 0.

## Final construction (the CN gate contact)
The moscap gate is a full-device poly plate (0..1000 x -370..1370) with the
S/D Metal1 straps inside it and the guard ring close, so the gate contact has
no legal site inside the plate.  Solution: **extend the poly plate upward**
(add gp (300..700, 1350..1900), clear above the ring top 870 and the top S/D
contacts 1350), then cont (420..580, 1640..1800) with 90 nm poly enclosure,
M1 pad (390..610,1590..1870), V1 190 nm, and an **M2 bridge** (M2 required:
the gate is inside the guard ring, M1 cannot cross it) to the switch drain.
CTRL: cont + M1 pad on the switch gate poly.  MID (source) and VSS (cap
bottom) are abutted terminals.

## Not done
127x array (needs a 3-net x-allocation: mid on M1 column, CN on M2 local,
control on M3, plus rails), KLayout LVS, PEX.  Extracted delay/C/RC NOT
available.

## Array congestion note (the next real step)
Per finger the three nets (mid, CN, ctrl) plus VSS must be kept apart.  The
source (mid) is covered by the CN M2 bridge, so mid cannot use M2 at the
source; the drain and the switch gate are adjacent.  The workable plan is:
mid = vertical M1 bus at the source column (does not touch the drain column),
CN = local M2 (as built), control = vertical M3 strap at the gate pad column,
VDD/VSS = M1/M2 rails + the shared well taps.  This is computable per column;
it is the next step, not a design change.
