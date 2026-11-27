# P finger + array status (after N finger DRC 0)

## N finger: DRC 0 (committed)
DLL8_FINGER = moscap_n + nmos, 6.44x3.11 um, KLayout 0.30.12 DRC 0.

## P finger: 11 violations, NOT 0 yet
DLL8_FINGER_P = moscap_p + pmos, built with the same 3-layer CN recipe.
11 violations (Cnt.b 4, CntB.h1 3, CntB.a 2, Cnt.c 1, CntB.a1 1) all at the
gate-contact region (x~0.42-0.59, y~1.62-1.80) and the pmos drain (3.98,
0.08-0.27).  Cause: the moscap_p S/D contacts/ring sit at different y than
moscap_n, so the N-finger gate-contact poly extension (y 1350-1900) collides
with the moscap_p S/D contacts.  The P finger needs its own gate-contact site
(higher, y>=1.85, the moscap_p bbox goes to 2.66 um) - a coordinate fix, but
not a free copy of the N finger.

## Array / LVS / PEX: not done
Needs: P finger to 0; 127x placement (even=N/odd=P) with mid M1 column, CN M2
local, control M3 straps, rails, shared 31/0+32/0 over the P group (proven);
KLayout LVS; PEX.  Extracted delay/C/RC NOT available.

## What is proven
N finger DRC 0; element shared-well DRC 0 (119.88x60.83); the 3-layer CN
approach is valid for the N device.  The P device's different geometry needs
its own contact coordinates.
