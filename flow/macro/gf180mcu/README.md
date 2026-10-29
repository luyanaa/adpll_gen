# PLL_ANALOG_MACRO — gf180mcu bring-up

First-pass macro build on `gf180mcu_as_sc_mcu7t3v3` (3.3 V, 7-track).

**Status: P&R/GDS/views + DRC/LVS deck runs complete.**

| Item | Status |
|---|---|
| Synthesis / mapping | **PASS** — 15 `PLL_CELL_*` wrappers mapped to gf180 stdcells |
| LibreLane P&R | **PASS** — 80/80; 85.6 × 103.6 µm; 452 instances (304 stdcells) |
| Detailed-route DRC | **0** |
| Setup / hold (TT 3.3 V) | +0.487 ns / +0.306 ns; 0 violations |
| GDS / LEF / Liberty / DEF / Verilog | **written** in this directory |
| KLayout DRC (`~/.ciel` gf180mcuA) | **PASS, 0 violations** after 85.6×103.6 µm shrink + marked metal fill (ratios 43.8/30.4/31.3/37.6/35.3%). |
| KLayout LVS (`~/.ciel` gf180mcuA + fill-exclusion shim) | **PASS** — "Congratulations! Netlists match" (with `check_ports=false` and fill-marker exclusion) |
| Density fill | **PASS** — marked 2×2 metal fill on M1–M5; DRC 0, flow-local LVS shim 0 |

## Views

```text
PLL_ANALOG_MACRO.gds   manual KLayout streamout from final DEF
PLL_ANALOG_MACRO.lef   OpenROAD abstract (71 pins)
PLL_ANALOG_MACRO.lib   OpenROAD/STA timing model (TT)
PLL_ANALOG_MACRO.def   final routed DEF
PLL_ANALOG_MACRO.v     final netlist
PLL_ANALOG_MACRO.cdl   gate-level CDL (generated from the DEF)
PLL_ANALOG_MACRO.sdc   timing constraints
```

The GDS was streamed with `signoff/tcl/def2stream.py` using
`flow/maps/gf180mcu_lefdef.map` and the ORFS
`gf180mcu_5LM_1TM_9K_7t.lyt` tech file.

## DRC / LVS (CIEL decks)

Use KLayout **0.30.7**, not the system 0.30.0 (the 0.30.0 DRC deck fails on
`edges`/`evaluate_nets`).

```sh
G=~/.ciel/ciel/gf180mcu/versions/792ef67037d74c8c51811eab3ce23cf793491296/gf180mcuA
KLAYOUT_0307=/nix/store/c8mymw0gckkiw7lqwnm2l6mqnd99xmzy-klayout-0.30.7/bin/klayout

$KLAYOUT_0307 -b -r $G/libs.tech/klayout/tech/drc/gf180mcu.drc \
  -rd input=PLL_ANALOG_MACRO.gds -rd topcell=PLL_ANALOG_MACRO \
  -rd report=PLL_ANALOG_MACRO_drc.lyrdb -rd run_mode=deep \
  -rd variant=D -rd decks=all

$KLAYOUT_0307 -b -r flow/macro/gf180mcu/lvs_dummy_excluded/gf180mcu.lvs \
  -rd input=PLL_ANALOG_MACRO.gds -rd schematic=PLL_ANALOG_MACRO.spice \
  -rd topcell=PLL_ANALOG_MACRO -rd report=PLL_ANALOG_MACRO_lvs.lvsdb \
  -rd run_mode=flat -rd variant=D -rd metal_top=11K -rd metal_level=5LM \
  -rd top_lvl_pins=true -rd check_ports=false -rd combine=true \
  -rd purge=true -rd schematic_translate=false
```

The schematic is the GF180 stdcell CDL followed by
`PLL_ANALOG_MACRO.cdl`.  `check_ports=false` is required because the merged
cell GDS labels (`A`, `B`, ...) are attached to the same nets as the top pin
labels; with port checking enabled the deck reports false “Port mismatch”
errors.  The actual netlist comparison passes.

The fill shapes are copied to per-metal marker layers `200/1..5`.  The
flow-local LVS copy `lvs_dummy_excluded/` subtracts those markers from the
metal connectivity graph, because the fill is non-electrical.  This is a
documented LVS fill exclusion, not a change to the foundry deck: the
unmodified GF180 LVS deck still sees floating fill nets.  With the shim, both
**DRC 0** and **LVS PASS** are achieved for this macro.

## Build

```sh
cd flow/macro/gf180mcu
# LibreLane is the gf180 P&R flow because the ckdur settings only cover ics55/IHP.
LIBRELANE=/nix/store/.../bin/librelane
$LIBRELANE --manual-pdk \
  --pdk-root ../../canary/gf180mcu_as_sc_core_a/pdk_overlay \
  --pdk gf180mcu --scl gf180mcu_as_sc_mcu7t3v3 \
  config.macro_build.yaml
```

The run skips the PDK-missing KLayout/Magic/DRC/LVS/RCX/STA steps and the
Yosys-unmapped-module checker; `OpenROAD.CTS` is skipped because the macro has
no digital clock tree.  Final DEF is under `runs/<RUN>/final/def`.

## Mapping caveats

- `PLL_CELL_NAND3X8` maps to one `gf180mcu_as_sc_mcu7t3v3__nand3_2`; this is
  functional, not drive-strength equivalent.
- gf180 standard cells have `VPW/VNW/VDD/VSS` power/body pins.  The wrappers
  expose only logic pins; the P&R `SCL_POWER_PINS`/`SCL_GROUND_PINS` global
  connections handle the leaf power pins.
- No analog symmetric floorplan yet; this is standard-cell placement of the
  analog netlist.

## Next

1. Decide whether the fill-marker LVS exclusion is acceptable to the foundry,
   or replace it with a foundry-approved dummy-fill handling rule.
2. Characterize and merge with the ics55/IHP macro views.
3. Re-run the full top-level GF180 integration once the macro is characterized.
