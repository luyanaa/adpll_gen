# PLL_ANALOG_MACRO — sky130 bring-up

First-pass macro build on `sky130_as_sc_hs` using the aggregate views from
`/grid/sky130/sky130_as_sc_hs/pdk`.

**Status: P&R/GDS/views written; PDN fixed; LVS still fails at cell-subcircuit comparison.**

| Item | Status |
|---|---|
| Synthesis / mapping | **PASS** — 15 `PLL_CELL_*` wrappers mapped to sky130 cells |
| LibreLane P&R | **PASS** — 80/80; 80.2 × 90.9 µm; 653 instances (517 stdcells) |
| Detailed-route DRC | **0** |
| Setup / hold (TT 1.8 V) | +2.463 ns / +0.158 ns; 0 timing violations |
| GDS / LEF / Liberty / DEF / Verilog | **written** |
| PDN connectivity | **FIXED** — no `PSM-0038/0039/0069`; `VPWR/VPB` power and `VGND/VNB` ground global connections |
| KLayout DRC (`~/.ciel` sky130A) | **0 violations** |
| LVS | **executed, FAIL** — PDN no longer blocks; cell subcircuits fail device/pin comparison after `write_cdl` |
| Density fill | not implemented |

## Views

```text
PLL_ANALOG_MACRO.gds
PLL_ANALOG_MACRO.lef
PLL_ANALOG_MACRO.lib
PLL_ANALOG_MACRO.def
PLL_ANALOG_MACRO.v
PLL_ANALOG_MACRO.sdc
```

The GDS was streamed with `signoff/tcl/def2stream.py`, using
`flow/maps/sky130_lefdef.map`.

## DRC (CIEL sky130A deck)

```sh
S=~/.ciel/ciel/sky130/versions/8afc8346a57fe1ab7934ba5a6056ea8b43078e71/sky130A
KLAYOUT_0307=/nix/store/c8mymw0gckkiw7lqwnm2l6mqnd99xmzy-klayout-0.30.7/bin/klayout
$KLAYOUT_0307 -b -r $S/libs.tech/klayout/drc/sky130A.lydrc \
  -rd input=PLL_ANALOG_MACRO.gds -rd topcell=PLL_ANALOG_MACRO \
  -rd report=PLL_ANALOG_MACRO_drc.lyrdb -rd run_mode=deep
```

Result: **0 DRC violations**.

### Cell CDL generation

`sky130_as_sc_hs` ships no CDL, so the 17 used cell types were extracted from
their `.mag` files with Magic 8.3 and the sky130A tech:

```sh
PDK_ROOT=~/.ciel/.../8afc... magic -dnull -noconsole \
  -rcfile .../sky130A/libs.tech/magic/sky130A.magicrc
# load <cell>.mag; extract do local; extract all; ext2spice lvs; write .spice
```

The resulting files are:

```text
sky130_as_sc_hs_cells.cdl     # 17 extracted cell subcircuits
PLL_ANALOG_MACRO.cdl          # OpenROAD write_cdl top (DEF-based)
PLL_ANALOG_MACRO.spice        # cell CDL + top, for sky130 LVS
```

The power-pin mapping was corrected to
`SCL_POWER_PINS: [VPWR, VPB]` / `SCL_GROUND_PINS: [VGND, VNB]`.  The rerun has
**zero** `PSM-0038/0039` unconnected-shape/instance warnings and no
`PSM-0069`; the DEF special nets are `VGND ( * VNB )` and `VPWR ( * VPB )`.

LVS no longer stops on must-connect PDN errors.  It still fails at the
cell-subcircuit level: Magic-extracted cell CDLs contain separate finger
devices / a `VNB` body node, while KLayout extraction produces combined
devices and a `sky130_gnd` substrate node.  This is a **cell-CDL/LVS-view
issue**, not a macro routing or PDN connectivity failure.  A full signoff LVS
for this library needs foundry-style cell CDLs or a blackbox/device-combine
flow; it is not claimed.

## Build

```sh
cd flow/macro/sky130_as_sc_hs
LIBRELANE=/nix/store/.../bin/librelane
$LIBRELANE --manual-pdk \
  --pdk-root pdk_overlay --pdk sky130_as_sc_hs --scl sky130_as_sc_hs \
  -S Checker.YosysUnmappedCells -S OpenROAD.CTS \
  -S OpenROAD.STAPostPNR -S OpenROAD.IRDropReport \
  config.macro_build.yaml
```

`pdk_overlay/` is a local LibreLane shim: aggregate LEF/GDS/Liberty/Verilog
exist in the library, but no LibreLane PDK config.  The flow skips the
Yosys-unmapped checker, CTS and post-PnR STA/IR steps; GDS is streamed from
the final DEF with `signoff/tcl/def2stream.py`.

## Mapping caveats

- `PLL_CELL_INVX9` and `PLL_CELL_NAND3X8` are functional mappings to
  `inv_6` / `nand3_2`, not drive-strength equivalents.
- Leaf `VPWR/VGND/VPB/VNB` pins are handled by global connections; the
  wrapper itself has no power pins.
- LVS cell CDLs are Magic-extracted (17 used cells) and were reordered to the
  KLayout extraction pin order; the remaining failure is cell device merging
  / substrate-node naming, not PDN must-connect.
- The standard-cell placement is not the symmetric analog floorplan.

## Next

1. Replace the Magic-extracted cell CDLs with a sky130 LVS-clean CDL set (or
   explicitly blackbox standard cells) to close cell-subcircuit LVS.
2. Add density fill and a real sky130 DRC deck.
3. Characterize and integrate the macro.
