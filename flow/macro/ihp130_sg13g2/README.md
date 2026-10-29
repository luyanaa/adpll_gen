# PLL_ANALOG_MACRO — IHP SG13G2 bring-up

Second-PDK port of the ics55 `PLL_ANALOG_MACRO` build.  The analog RTL is the
same; the standard-cell wrappers are `src/pll_cells_ihp-sg13g2.v`
(`sg13g2_inv_*`, `sg13g2_nand*`, `sg13g2_dfrbp_1`, ...).

## Status

| Item | Status |
|---|---|
| Analog synthesis → sg13g2_stdcell | **PASS** |
| Fixed-placement P&R | **PASS** — 160 × 105 µm die; `pnr/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.{def,lef,lib,cdl,spef,sdf,v}` |
| Detailed-route DRC | **0** violations (OpenROAD) |
| GDS | **written + filled** — `signoff/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.gds` |
| KLayout LVS (IHP sg13g2 deck) | **PASS** — “Congratulations! Netlists match.” on `PLL_ANALOG_MACRO_lvs.gds` (density fill stripped) |
| KLayout minimal DRC | **0 violations** with density rules enabled (ACT/M1–M5/M*Fil) |
| Characterization / top | not run |

This proves the macro flow is not ics55-specific: the same wrapper/analog RTL
maps to a second standard-cell library and reaches P&R, GDS and LVS.

## Build

The local IHP PDK root is the one assembled by the IHP canary:

```sh
cd flow/macro/ihp130_sg13g2

PDK_ROOT=/opt/adpll_gen/flow/canary/ihp130_sg13g2_core_a/build/pdk_root

make syn  USE_DOCKER=0 PDK_ROOT=$PDK_ROOT
make pnr  USE_DOCKER=0 PDK_ROOT=$PDK_ROOT \
  OPENROAD=/nix/store/2y36a4sr078y15ick388dncqjdzmlxga-openroad-2026-02-17/bin/openroad \
  X=160 Y=105
make gds  USE_DOCKER=0 PDK_ROOT=$PDK_ROOT
make lvs-view USE_DOCKER=0 PDK_ROOT=$PDK_ROOT
```

The Makefile sets `NO_IO=1` and limits LEF/GDS/CDL to `sg13g2_stdcell`; the
macro uses no IO cells and the compact local PDK root does not carry a
`sg13g2_io` LEF.  `lib/ihp-sg13g2_settings.tcl` honours `NO_IO` and falls back
to the ORFS `rcx_patterns.rules` when the local `IHP_rcx_patterns.rules` path
is absent.

## LVS

```sh
klayout -b \
  -r /opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2/lvs/sg13g2.lvs \
  -rd input=signoff/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO_lvs.gds \
  -rd schematic=signoff/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.spice \
  -rd topcell=PLL_ANALOG_MACRO \
  -rd report=signoff/reports/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO_lvs.lvsdb \
  -rd run_mode=flat -rd threads=10
```

The schematic is the IHP std-cell CDL followed by
`pnr/.../PLL_ANALOG_MACRO.cdl`.  The IHP deck reports a match; this is a
KLayout check, not an official IHP/Calibre signoff.

`PLL_ANALOG_MACRO_lvs.gds` is the canonical filled GDS with the FILL/NODRC
dummy removed by `strip_density_fill.rb`.  The IHP LVS deck does not reliably
ignore dummy fill that overlaps real lower-layer geometry, so the LVS view is
the unfilled layout.  This is a flow-level dummy-fill exclusion, not a
foundry-approved fill deck.

## DRC

The ORFS minimal deck with density rules reports **0 violations** on the
canonical filled GDS:

```text
ACT 35.45%   M1 35.95%
M2  39.12%   M3 35.45%   M4 42.40%   M5 38.60%
TM1 36.70%   TM2 40.17%
```

`add_density_fill.rb` clears old filler/NODRC, places 0.5 µm tiles on the IHP
FILL layers (1/22, 5/22, 8/22, 10/22, 30/22, 50/22, 67/22, 126/22, 134/22)
with layer-specific pitch (0.75–1.00 µm), keeps each layer clear of its own
real metal/pin geometry and via layers, and marks every tile with NODRC
(62/0).  The previous free-area-only fill reached only 10.6% filler coverage
and left 10 global-density items; the per-layer keepout + pitch version
closes the global-density checks.

The deck is the ORFS `sg13g2_minimal.lydrc`; the full commercial IHP deck was
not available.

## Notes / next steps

1. Use the official IHP KLayout/Calibre decks for signoff; the local root has
   only the ORFS minimal decks.
2. Characterize the IHP macro and add per-corner Liberty views before using it
   in the full `pll` top.
3. `PLL_CELL_NAND3X8` uses eight parallel `sg13g2_nand3_1` instances; the
   mapping is functional but not yet timing/area characterized against the
   ics55 NAND3X8 cell.
