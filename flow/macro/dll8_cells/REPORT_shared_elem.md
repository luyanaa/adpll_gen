# Single-element shared-well layout attempt (INTERMEDIATE, not signoff)

Tested whether removing per-device guard rings lets the PCell bank place
legally (the root of the 15,600-error macro placement).

- One element = 2 x sg13g2_inv_4 + 127 moscap/switch fingers, switches built
  with `guardRingType="none"`, 16-column grid at 4 um pitch.
- Result: **64.0 x 37.2 um, Magic DRC = 781 errors** (down from 15,600 for 8
  elements but still not clean).  The residual is device-to-device spacing and
  missing well/substrate taps, not just the guard rings.
- Not routed, LVS not run, PEX not run.  The 127 control nets from the
  in-macro thermometer decoder are not routed.

## PEX tap spread
**Not available.**  It requires a DRC-clean, routed, LVS-clean layout to
extract RC.  The element SPICE (0.96 fF/node assumption) gives SS delay
146 ps (base) / 660 ps (all-on) and LSB 3.83 ps; that is a hand-netlist
number, not extracted layout, and cannot be presented as the grid result.

## Honest status
A legal routed 4-element macro (shared wells/taps, 254 devices/element,
127-wire control fan, DRC 0 on Magic+KLayout, netgen LVS, PEX) is a
substantial analog layout job that was not completed.  **Do not start the
DLL8 tile PnR.**  The next concrete step is a properly spaced/tapped and
routed single element, then PEX; the tap spread cannot be judged before that.
