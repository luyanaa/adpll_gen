# PEX / extracted RC for the 4-element gate — tooling reality + numbers

## 1. Is a real RC PEX available in this flow?  NO (genuine tooling limit)
- **KLayout**: the sg13g2 KLayout flow provides DRC + LVS only.  There is
  **no KLayout RCX / parasitic-extraction deck**.  The `xsect` folder is a
  2-D cross-section *viewer* (`README`: "Current status: BEOL + MIM"; its
  `.xs` says "No support for active devices (layers below ACTIV)"), and the
  `xsection` solver plugin is not installed for the KLayout 0.30.12 build
  (no `xsection*.so`); it would not model the FEOL moscap anyway.
- **Magic**: the PDK README explicitly lists under "Devices not extracted":
  **`sg13_moscap_n, sg13_moscap_p (not supported by Magic extraction)`**.
  The moscap bank *is the entire load* of the element, so a Magic ext2spice
  PEX would drop the bank and produce a meaningless (unloaded) delay.  The
  Magic cap generator only supports cmim/rfcmim.
- Therefore "extracted element delay code 0 / mid code vs hand netlist
  173.6 / 660.6 ps" **cannot be produced with a tool-based RC PEX** without
  PDK edits (forbidden).  This is a capability gap, not an iterative fix.

## 2. What the PDK does provide: ITF parasitic tech
`libs.tech/parasitics/itf/sg13g2_{min,typ,max}.itf`.  Typ conductor data:
| layer  | RPSQ (ohm/sq) | WMIN | SMIN |
|--------|---------------|------|------|
| Metal1 | 0.110         | 0.16 | 0.18 |
| Metal2 | 0.088         | 0.20 | 0.21 |
| Metal3 | 0.088         | 0.20 | 0.21 |
| TopMetal1 | 0.018      | 1.64 | 1.64 |
Dielectrics (typ): ox2 = 1.03 um, Er 4.1 (M3 over M2); ox1 = 0.96 um, Er 4.1
(M1 over substrate).

## 3. First-order ITF-based RC of the routed MID net (from the GDS)
Computed from the actual merged M3 geometry of the routed array
(`dll8_line_array.gds`, MID = the single tall M3 component, connectivity
verified: 128 M3 components = 1 MID + 127 independent CTRL straps):
- MID M3 area  = 215.67 um^2, perimeter = 1398 um, bus length H = 345.3 um,
  bus width 0.29 um.
- **R (per column bus) = RPSQ * L/W = 0.088 * 345.3 / 0.29 = ~105 ohm.**
  Two column buses fed from the single top tie -> worst-case tie-to-source
  ~105 ohm (plus tie), best-case ~1/2.
- **C area term** (M3 over ox2) = eps0*4.1/1.03um = 0.0352 fF/um^2
  -> 7.6 fF over 215.7 um^2.
- Sidewall fringe (0.02..0.04 fF/um x 1398 um) = 28..56 fF.
- **MID wire C ~ 35..64 fF total** (area 7.6 + fringe).  Because it is one
  net spread over two 345 um buses, this is the mid-wire load, NOT a per-tap
  node.

## 4. Comparison to the 0.96 fF/node tap assumption and the bank
- Bank load = 127 x 12.8 fF = **1.626 pF**.
- MID wire C (= 35..64 fF) = **2..4 % of the bank** -> the bank dominates the
  element delay; mid wiring is a small common term.
- Code-0 node composition: at code 0 no finger is enabled, so the mid node
  is (mid wire C) + inv_4 input cap.  The wire fraction is large (wire is
  ~10-60 fF vs a ~1 fF inv input), i.e. **the code-0/fast-end node is almost
  all wire** — this is where FF fast-end reach is limited.  (Exact inv input
  C needs an RC extractor, unavailable; the wire is the dominant, known
  term and it is identical for every element.)

## 5. Does this support the common-mode argument?  YES
All eight elements use byte-identical 127-finger layout, identical MID M3
bus geometry and identical control straps.  The MID wire R (~105 ohm) and C
(~35..64 fF) are therefore **identical per element** and add only a common
delay term; they cannot create element-to-element tap *spread*.  The bank
itself contributes no tap spread; the residual spread risk remains the
tap-output routing *outside* the bank (inv_4/tap buffers, not yet placed).

## 6. Verdict input (element spread rule <=3.5 ps PASS / >5 ps FAIL)
An absolute extracted element delay cannot be produced (Sec.1).  What the
layout can state:
- The only intra-element spread mechanism is the tap-output network; the
  capacitance bank and its mid wiring are common-mode (Sec.5).
- The element DELAY is dominated by the 1.626 pF bank (base 146 ps TT /
  173.6 ps SS hand netlist) with mid wire adding ~2..4% C and ~105 ohm in
  the supply path -- a common offset, not a spread.
=> The pre-committed tap-spread rule can only be closed once an RC PEX that
   models sg13_moscap exists (not in this PDK) OR the tap-output buffers are
   laid out identically and argued by construction.  The bank is not the
   spread source.
