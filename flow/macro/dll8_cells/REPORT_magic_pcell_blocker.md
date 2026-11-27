# Magic-PCell path for the DLL8 bank — PDK limitation (scope decision)

## Decisive finding
The PDK Magic README (`libs.tech/magic/README.md`, "Devices not extracted")
lists:
    sg13_moscap_n, sg13_moscap_p (not supported by Magic extraction)
and the Magic cap generator `ihp-sg13g2-cap.tcl` only defines `cmim` and
`rfcmim`.  So the approved option 1 ("127 fingers of sg13_moscap via the
Magic cap generator") is **not possible**: Magic has no moscap generator and
cannot extract a `sg13_moscap` device.  The cdr_ihp130 flow that passes both
decks used stdcells/cmim, not moscap.

## Viable path without PDK changes
Draw the cap as a **MOSFET with S/D tied** using the Magic FET PCell
(`sg13_lv_nmos` / `sg13_lv_pmos`, w=l=1.0 um), which Magic CAN extract.  Then:
- KLayout DRC: Magic-drawn device (cdr_ihp130 proves Magic-drawn geometry is
  KLayout-clean) -> expected 0 (to be verified).
- LVS: the CDL must model the cap as `sg13_lv_nmos/pmos` with S/D tied, not
  `sg13_moscap`.  Electrically identical (gate capacitance); device-model name
  changes.
- PEX: the gate capacitance of the S/D-tied MOS is captured -> element delay
  and per-node C are extractable.
This changes the *device model name* used in the bank (moscap -> nmos-cap),
not the physical structure, finger count (127) or size (1.0x1.0).

## Alternatives
1. MOSFET-as-cap in Magic (above) -> the only path to KLayout 0 + extraction
   without touching PDK source.
2. KLayout PCell -> ContBar mismatch (568), or patch PDK (disallowed).
3. Reassess the capacitor device (e.g. cmim) -> a design change.

## Status
No layout/routing/LVS/PEX produced this turn.  Need the decision: proceed
with the MOSFET-as-cap-in-Magic bank (recommended), or other.
