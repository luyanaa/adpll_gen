# Cap/switch overlap fix + remaining NBL (KLayout 0.30.12)

## Root cause of the 513 (confirmed)
The moscap (bbox x -0.88..+1.88) and its switch (bbox -1.03..+2.16) placed at
a +2.0 um intra-column offset OVERLAP by 0.91 um -> merged guard-ring contacts
-> CntB.a1 254 / CntB.a 192 (array-level) + per-device Cnt.b.  Pitch-independent
because the +2.0 offset is constant.

## Fix 1 (works): separate cap and switch
Switch offset must be > 1.88+1.03 = 2.91 um.  At +3.5 um:
- single moscap 1.0x1.0: KLayout DRC **0** (0.30.12)
- element: KLayout DRC **568 -> 171**.  Contact families (CntB/Cnt.b/Cnt.g)
  are GONE.  Remaining: NBL.e 56, NBL.f 56, NBL.c 55, Act.b 2, M1.b 2.
Element size 111.85 x 59.83 um.

## Remaining 171 are NBL (nBuLay) well-sharing, not pitch
NBL.c = PWell width between *different-net* nBuLay 3.2 um; NBL.e/f = nBuLay to
unrelated N+/P+ activ.  The P-device nBuLay regions are 4.13 um wide, so the
cap_p and its pmos switch (and adjacent P columns) can only be separated if
centres are >= 4.13+3.2 = 7.33 um.  A pitch sweep to 7.5/9 um DOES separate
them but the switch then overruns the next column's cap (overlap returns) ->
4302 violations.  So it cannot be fixed by pitch alone at this density: the
P devices must SHARE one nwell/nBuLay (same net, NBL.b 1.5 um applies).

## Next (shared guard ring = approved option 1)
Draw the P-side (moscap_p + pmos) devices inside ONE shared nwell with a
shared nBuLay tied to VDD (and the N-side in shared psub), i.e. merge the
same-net wells.  That turns NBL.c (different-net 3.2) into NBL.b (same-net
1.5) and should clear the 167 NBL.  This is a scripted layout step, not a
device change.

## Not done
Routed element, LVS, PEX.  PEX tap spread still unavailable.
