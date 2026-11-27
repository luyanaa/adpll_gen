# One-element legal placement + DRC status (INTERMEDIATE, not signoff)

## What worked: the DRC fix
The 15,600 (macro) / 781 (no-ring element) errors were from deleting the
PCell guard rings.  Keeping them (guardRingType psub/nwell = the well and
substrate taps) and spacing to 7.0 um pitch:

- one element = 2 x sg13g2_inv_4 + 127 moscap/switch fingers (1.0x1.0 moscap)
- **110.35 x 59.83 um**, **Magic DRC = 0** (PDK ihp-sg13g2-drc.tech).

The problem was never the 127 fingers; it was removing the taps and butting
the rings.  At 7 um the ringed PCells tile cleanly.  (A tighter pitch may also
pass; 7 um is the verified value.)

## KLayout DRC: BLOCKED BY TOOL VERSION
`libs.tech/klayout/tech/drc/run_drc.py` requires KLayout >= 0.30.7; the
installed KLayout is 0.30.0.  It exits before running any rule.  This is a
tooling blocker (not a layout result): the KLayout half of DRC 0 is unverified.

## Not done (so NOT signoff)
- Routing: mid bus, VDD/VSS rails, drain->cap-gate, and the 127 local control
  nets per element from the per-element thermometer decoder.  The placement is
  DRC-0 but UNROUTED, so extraction has no connectivity.
- netgen LVS (needs the routed layout netlist vs the element CDL).
- PEX (extresist+ext2spice).  **Extracted element delay and PEX tap spread
  are therefore NOT available.**
- The 0.96 fF/node assumption is therefore still unvalidated by extraction.

## Next
1. Install/locate KLayout >= 0.30.7 (or run the KLayout DRC elsewhere).
2. Route one element: per-element decoder adjacent, 127 control nets as a
   local strap in a channel; shared mid bus / rails.
3. LVS, then PEX; report extracted element delay, per-node C, tap spread.
