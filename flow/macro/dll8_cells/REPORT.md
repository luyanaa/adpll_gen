# DLL8 moscap/switch PnR cell library (IHP SG13G2) — status

## Legal-size finding (reported before proceeding, per instruction)
PDK PCell legal range: `moscap_n/p` w,l in **[1.0, 30] um**.  The element was
drawn 0.9 x 1.1 um -> the 0.9 um width is **illegal**.  Nearest legal size used:
**1.0 x 1.1 um** (area 0.99 -> 1.10 um^2, **+11%**).  C per finger therefore
scales ~12.7 -> **~14.1 fF** (PEX confirmation pending); with 127 fingers the
bank range/LSB grow ~11% (SS max 654 -> ~726 ps), still covers the spec.
Alternative if a smaller C is wanted: 1.0 x 1.0 um (area +1%, ~12.8 fF).

## Cells built (PDK KLayout PCells + Metal2 pin pads)
| cell | device | drawn | bbox (um) | pins |
|---|---|---|---|---|
| sg13g2_moscap_n | moscap_n | 1.0x1.1 | 2.86 x 2.90 | G, B |
| sg13g2_moscap_p | moscap_p | 1.0x1.1 | 3.28 x 2.71 | G, B |
| sg13g2_lv_nmos | nmos | 0.5x0.45 | 3.19 x 2.92 | G,D,S,B |
| sg13g2_lv_pmos | pmos | 1.0x0.13 | 4.13 x 4.32 | G,D,S,B |

Files: `dll8_cells.gds`, `dll8_cells.layout.json`, `out/<cell>.lef`,
`out/<cell>.cdl`.  Generator: `build_cells.py` (run `klayout -zz -r`).

## Flow notes (reproduced from the tx_macro precedent)
- PCell creation requires `Layout.technology_name="sg13g2"` and unit-string
  params (`"1.0u"`); without the tech set the PCell returns empty geometry.
- `Layout.write` needs a top cell containing the cells (otherwise the GDS is
  empty) and `SaveLayoutOptions` (GDS2).
- Magic: `gds read` -> `load <cell>` -> `extract all` -> `ext2spice lvs` (CDL)
  -> `lef write` (LEF) -> `drc check`.  Works; LEF pins land on Metal1 with
  Via1/Metal2.

## DRC status — NOT CLEAN (blocker for acceptance)
Magic DRC (CIF style, PDK `ihp-sg13g2-drc.tech`) counts:
| cell | DRC errors |
|---|---|
| sg13g2_moscap_n | 6 |
| sg13g2_moscap_p | 3 |
| sg13g2_lv_nmos | 21 |
| sg13g2_lv_pmos | 42 |
The PDK PCell bodies are DRC-clean; the violations come from the added pin
pads/gate-poly pad (Metal1 too close to the device, poly pad over diffusion,
via enclosure).  Fix = move the pads outside the device bbox and keep the
gate contact on the PCell's own poly, or use the PDK-pcell LEF directly.

## LVS status — NOT RUN
The moscap extracts as `X0 B a_0_n74# B B sg13_lv_nmos w=1u l=1.1u` (S/D tied,
2 terminals) as expected.  LVS needs a schematic CDL with the matching
`sg13_moscap_n` model/subckt mapping; netgen not run yet.

## Remaining to close acceptance
1. Fix the pin-pad DRC (move pads off-device) -> DRC 0 for all 4.
2. netgen LVS layout-CDL vs schematic-CDL (moscap model mapping).
3. PEX C per finger for the 1.0x1.1 moscap.
4. LEF placeability check in OpenROAD (`lef read` + `place` dry run).
5. Wire the cells into `src/pll_cells_ihp-sg13g2.v` (keep the SPICE path).
This task is **not** complete: the cells exist as GDS/LEF/CDL but are not yet
DRC/LVS clean, so they are not signed off for the DLL8 PnR.
