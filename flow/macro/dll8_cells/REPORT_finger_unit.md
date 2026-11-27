# DLL8_FINGER unit-cell plan + terminal geometry (status)

## Terminal geometry (measured from the PCell GDS, dbu=1nm)
nmos (0.5/0.45, psub ring), bbox (-1030,-1210;2160,1710):
  S/D Metal1: (70,0;230,500) and (900,0;1060,500)   [two 0.16 um straps]
  gate poly : (340,-180;790,680)   (gp)
  ring M1   : the 4 perimeter boxes
moscap_n (1.0x1.0), bbox (-880,-1030;1880,1370):
  gate poly : (0,-370;1000,1370)   [full-device plate, gp]
  bottom M1 : (20,-350;980,-90) and (20,1090;980,1350)  [S/D straps, = B]
  ring M1   : perimeter boxes

## The one resisting connection class
Internal finger jumper = switch drain (nmos M1 (900,0;1060,500)) -> moscap
gate (poly plate 0..1000 x -370..1370).  The gate contact must sit on the poly
*outside* the S/D M1 straps (the only clear poly is the top strip y~1350-1370
or a poly extension), and the M1 jumper must clear the S/D strap and the
switch body.  This is a ONE-TIME layout (routed once in the unit, then
replicated 127x), so it is tractable - but it needs a couple of DRC iterations
to place the gate contact and the jumper legally.  It is not a maze router
problem; it is one contact + one ~3 um M1 jumper.

After that the array is computable rectangles: abutted M1/M2 mid straps per
row (source terminals align), VDD/VSS rails, 127 vertical control straps at
unit pitch, IN/OUT on the boundary.  No maze routing.

## Status: NOT routed/LVS/PEX
KLayout DRC 0 element (119.88 x 60.83) is the base.  The routed unit + array,
KLayout LVS, and PEX (with the moscap_p-in-shared-nBuLay extraction check) are
not done.  Extracted BASE/mid delay, per-node C and tap RC are NOT available.

## Analysis note (per request)
Because all 8 elements will use the identical layout, the mid wire C is
common-mode and cannot by itself create tap-to-tap spread; the spread risk is
the tap output routing outside the bank.  This is a layout-topology statement;
PEX on the routed tap routing is still needed to confirm it.
