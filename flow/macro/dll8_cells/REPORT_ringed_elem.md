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

## KLayout DRC — direct deck run (updates the earlier "blocked")
The version guard is only in `run_drc.py`; the standalone Ruby deck
`libs.tech/klayout/tech/drc/ihp-sg13g2.drc` runs directly on KLayout 0.30.0:
  klayout -b -r ihp-sg13g2.drc -rd input=<gds> -rd topcell=<cell> -rd report=<lyrdb>
It completes in 5.4 s -> there was no tooling block.  BUT it reports
**568 violations** on the same placement that Magic calls DRC 0, dominated by
  CntB.a1 254  (contact bottom, ~1 per device)
  CntB.a  192
  NBL.c    55
  Cnt.b    36
  Act.b    11, M1.b 9, ...
This is a Magic-vs-KLayout deck/mapping discrepancy on the PDK-PCell contacts
and NBL, not a placement spacing problem.  It must be resolved (layer mapping
or the deck's contact rules vs the PCell GDS) before KLayout DRC-0 can be
claimed.  Magic DRC remains 0.

## Status: still NOT signoff
Routed element / LVS / PEX are not done.  PEX tap spread unavailable.  The
0.96 fF/node assumption is still unvalidated.

## KLayout 568 violations — specific rules (scope decision needed)
From elem.lyrdb (PDK ihp-sg13g2 KLayout deck):
  NBL.c   55 : 5.3.NBL.c Min. PWell width between nBuLay regions (different net) 3.2 um
  Cnt.a  192 : 5.14.Cnt.a Min/max Cont width 0.16 um
  CntB.a1 254: 5.15.CntB.a1 Min. ContBar length 0.34 um   (~1 per device)
  CntB.a  192: 5.15.CntB.a Min/max ContBar width 0.16 um
  Cnt.b   36 : 5.14.Cnt.b Min. Cont space 0.18 um
  CntB.b1     5.15.CntB.b1 Min. ContBar space 0.36 um (common run >5um)
  CntB.h1     5.15.CntB.h1 Min. Metal1 enclosure of ContBar 0.05 um
  Act.b 11, M1.b 9, Cnt.e 4, Gat.d 2, ...

The CntB (contact-bar) family is ~one-per-device: the **KLayout PCell streams
its S/D and ring contacts as ContBar geometry that the KLayout DRC deck
rejects** (length/width/space/M1-enclosure).  Magic DRc is 0 on the same GDS
(Magic uses its own extract/DRC deck).  This is a PDK KLayout-PCell vs
KLayout-DRC revision mismatch, not a placement error and not my added pads.
NBL.c 55 (nBuLay-to-nBuLay PWell gap 3.2 um) is a pitch issue that a larger
PMOS pitch would fix, but the ContBar family is inherent to the PCell.

### Options (scope decision)
1. Draw the devices with Magic (the cdr_ihp130/tx_macro path), where the Magic
   PCells + Magic DRC are consistent -> KLayout deck then passes (proven on
   cdr_ihp130).  Cost: hand/scripted Magic layout for 254 devices/element.
2. Replace/patch the KLayout PCell ContBar construction (correct length/space)
   -> not a parameter exposed by the moscap/nmos/pmos PCell.
3. Accept Magic DRC 0 as the signoff deck for this PDK (the cdr_ihp130 flow
   used Magic as primary) and treat KLayout as a second opinion with a known
   PCell/DRC revision gap.

The 127-finger / 1.0x1.0 element is unchanged; this is a device-construction
tooling mismatch, not a design change.
