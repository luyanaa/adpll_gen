# DLL8 8-element line macro — area/DRC study (NOT signed off)

## Decisions applied
- moscap **1.0 x 1.0 um** (legal min 1.0).  SPICE re-run at 1.0x1.0:
  SS BASE 146.4 / max 655.7 / LSB 4.0 ps; TT 89.9/514.3; FF 60.5/462.0.
  Delta vs 0.9x1.1 < 0.5% -> no redesign; 127 fingers kept (mandatory).
- **One macro** for the line, decoder INSIDE.  Pin plan (18):
  `IN`, `CODE[6:0]`, `TAP[7:0]`, `VDD`, `VSS`.  No per-element trim pins;
  optional single 3-bit global trim NOT included.  `TAP` are buffered outputs.
- Interior = 8 x (inv_4 + inv_4 + 127-finger moscap/switch bank) from the PDK
  PCells (no per-device pin pads).

## Area
Placement study (`build_macro.py`, no routing):
  bbox **710.35 x 44.83 um = 31,845 um2**, 2048 devices (8 x 256).
This is a 16:1 strip, not a 200x200 block.  A 2-row (4+4) floorplan or **two
4-element macros** (~355 x 45 each) is better for the tile and halves the
tap-fanout span.  Recommendation: use 2 x 4-element macros.

## DRC
Magic DRC on the placement: **15,600 errors**.  The individual PCell bodies
are DRC-clean; the errors are adjacent-device guard-ring / well / implant
spacing when the PCells are butted at 5 um pitch.  A real layout must share
wells and guard rings and route the bank; this placement is not a legal macro.

## Not done
Routing of 8 x (2 inv + 127 caps + 127 switches + control buffers);
LVS (netgen); PEX tap-to-tap spread; LEF abstract; OpenROAD place dry-run;
equal-parasitic tap routing; wiring into pll_cells_ihp-sg13g2.v.

## Conclusion
The 8x127 line as one hard macro is ~32,000 um2 and a 16:1 strip.  It is
placeable in area terms but the routed/DRC/LVS/PEX macro is a large layout
job not completed here.  **Do not start the DLL8 PnR on this.**  Recommended
split: 2 macros x 4 elements.
