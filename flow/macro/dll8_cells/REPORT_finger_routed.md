# Routed DLL8_FINGER unit cell — progress (13 DRC, not 0 yet)

## What was built (3-layer local plan)
`DLL8_FINGER` = moscap_n + nmos at DX=3000, with:
- CN (switch drain -> moscap gate): gate cont on the poly at (950,250) (the only
  clear poly between the S/D straps), M1 pad, V1, **M2 bridge** over the moscap
  guard ring to the switch drain (M2 is required because the cap gate sits
  inside the ring; M1 cannot cross it).
- CTRL: cont + M1 pad on the switch gate poly.
- MID (switch source) and VSS (cap bottom) left as labelled M1 terminals for
  the abutted bus.

## DRC status: 13 violations (KLayout 0.30.12)
  M1.b 7, Act.b 3, Cnt.b 2, V1.c 1
Cause: (a) DX=3000 leaves a 0.09 um moscap->nmos activ gap (rule 0.21 um) ->
the 3 Act.b; (b) the added M1 gate pad is 0.17-0.18 um from the switch S/D M1
(rule 0.18) and similar local pads -> M1.b; (c) cont/via enclosure -> Cnt.b/V1.c.
These are exact-coordinate fixes (DX->3400, narrower gate pad, cont/via
enclosure), 1-2 iterations expected.  Not a topology problem.

## Not done
Array (127x) + abutted buses/rails/control straps, KLayout LVS, PEX.
Extracted delay/C/RC NOT available.

## Confirmed the architecture reduces the problem
With the finger routed once, the array is abutted buses + computed vertical
control straps (127) + rails; no maze routing.  The remaining work is the
finger spacing convergence, then arithmetic array placement.
