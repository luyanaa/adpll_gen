# PLL_ANALOG_MACRO — ics55 H7CR bring-up

First hard-macro build of the Core A `PLL_ANALOG` block with the ckdur
OpenROAD flow.  The wrapper is `pll_analog_macro.v`; the instance name
`pll_ana` preserves the `pll_ana_dco` / `pll_ana_inj` hierarchy expected by
`pnr/tcl/pll_pos.tcl`.

## Status

| Item | Status |
|---|---|
| Analog netlist (`PLL_ANALOG_MACRO_net.v`) | **PASS** — 181 instances in P&R, ~326.8 µm² instance area |
| Fixed-placement P&R | **PASS** — 160 × 100 µm die; `pnr/outputs/ics55/PLL_ANALOG_MACRO.{def,lef,lib,cdl,spef,sdf,v}` |
| GDS streamout | **PASS (layers fixed + density fill)** — `signoff/outputs/ics55/PLL_ANALOG_MACRO.gds`; MET1–MET5/SPNET on 81–85, plus dummy fill |
| KLayout DRC | **305 items = 305 7T-cell-internal + 0 top-level**.  All top-level routing/geometry/density checks pass. |
| KLayout LVS | **PASS** — flat reference, `run_mode=flat`, `combine_devices=true`; 1570 devices / 71 ports; zero unmatched nets/devices. |
| Characterization | not run yet |
| Top LibreLane integration | not run yet; views exist |

This is a **layout/views bring-up**, not a signoff-qualified macro.

## Build

The commands used (native tools; no docker image was available):

```sh
cd flow/macro/ics55_h7cr

# synth: analog wrapper + cells; pll_logic_bb is a dummy digital blackbox
make syn USE_DOCKER=0 PDK_ROOT=/grid

# P&R: 160 x 100 um; the shorter die removes the 20 um top density
# edge-window artifact.  CTS is skipped because the macro top has no clock tree.
make pnr USE_DOCKER=0 PDK_ROOT=/grid \
  OPENROAD=/nix/store/2y36a4sr078y15ick388dncqjdzmlxga-openroad-2026-02-17/bin/openroad \
  X=160 Y=100

# GDS (streamout + density fill) + flat-reference LVS
make signoff USE_DOCKER=0 PDK_ROOT=/grid \
  OPENROAD=/nix/store/2y36a4sr078y15ick388dncqjdzmlxga-openroad-2026-02-17/bin/openroad \
  X=160 Y=120

# DRC separately (it is not clean yet; see below)
make drc USE_DOCKER=0 PDK_ROOT=/grid
```

The shared flow needed three small macro-compatibility changes:

1. `pnr/tcl/pindef.tcl` now constrains only ports that exist, and adds the
   macro-only pins (`COARSE_MUX`, `MID_MUX`, `FINE_MUX`, `SS_BBPD`, etc.).
2. `pnr/tcl/pnr.tcl` honours `SKIP_CTS=1` (macro-only has no digital clock
   tree) and sources `set_rc.tcl` in that case.
3. The macro Makefile passes `TOP=PLL_ANALOG_MACRO`, `DIGTOP=pll_logic`, a
   macro-only `SYN_SRC`, and `SRC_DIR` pointing at this directory.

## GDS streamout: the layer-map root cause

The original signoff streamout used the PDK's **GDS-import** map
(`libs.tech/klayout/tech/ics55.map`) as a **LEF/DEF** map.  That map has the
format `<gds-layer> <datatype> <name>`; KLayout's LEF/DEF reader needs
`<LEF layer> <purposes> <gds-layer> <datatype>`.  The result was:

- every DEF routing/SPNET shape went to auto layers 8/10/12/14/16;
- MET1–MET5 had only a handful of cell/pin shapes;
- VDD/VSS had no top-level PDN geometry;
- the old DRC/LVS numbers were therefore not meaningful.

Fixed by:

```text
settings.mk: PDK_KLAYOUT_MAPFILE = $(ROOT_DIR)/flow/maps/ics55_lefdef.map
```

The new map covers `NET,PIN,LABEL,LEFPIN,LEFOBS,SPNET,VIA,BLOCKAGE` for
MET1–MET5, T4M2 and ALPAD, plus VIA1–VIA4.  The streamed macro now has:

```text
81/1: 49 shapes   82/1: 1145   83/1: 486   84/1: 106   85/1: 50
```

This also supplies the VDD/VSS MET4/MET5 PDN shapes and the pin labels on the
conductor layers, so `fix_pin_labels.rb` is no longer required for this
build.  It remains as a fallback for a PDK whose DEF reader still drops pin
geometry.

## LVS: flat reference is required

KLayout's SPICE reader does not resolve parameters on subcircuit instances.
The ics55 cell CDL is parameterized:

```spice
.SUBCKT INV A VDD VSS Y
MMN0 Y A VSS VSS nm1p2_svt_lp W=nw L=nl
...
.SUBCKT INVX5H7R A VDD VSS Y
XXI0 A VDD VSS Y / INV pl=6e-08 pw=9.5e-07 nl=6e-08 nw=7.5e-07
```

KLayout reports `Not a known parameter for circuit 'INV': 'PL'`; adding
`.PARAM` declarations does not help.  `flatten_cdl.py` recursively expands
`X` instances and substitutes `nw/nl/pw/pl` into `W/L`.  It emits a flat
`PLL_ANALOG_MACRO` with **1570 devices and 71 ports** (69 signal + VDD/VSS)
for the 160 × 100 µm build.

The flattener also assigns a unique global node to every **cell-internal**
net.  That is essential: without it, all instances of a cell share its local
`net90`/`net_25` names, and LVS cannot match the topology even though the
device count looks right.

The layout extraction combines parallel PMOS fingers (2 × W=1.14/1.52 µm →
W=2.66 µm).  Use `combine_devices=true` so both sides combine identically.

Working command:

```sh
cd /opt/adpll_gen

python3 flow/macro/ics55_h7cr/flatten_cdl.py \
  --cells /grid/ics55/libs.ref/ics55_LLSC_H7CR/cdl/ics55_LLSC_H7CR.cdl \
  --macro pnr/outputs/ics55/PLL_ANALOG_MACRO.cdl \
  --top PLL_ANALOG_MACRO \
  --out /tmp/PLL_ANALOG_MACRO_flat.spice

PDK_ROOT=/grid PDK=ics55 klayout -b \
  -r /grid/icsprout55-pdk/libs.tech/lvs/ics55.lvs \
  -rd input=/opt/adpll_gen/signoff/outputs/ics55/PLL_ANALOG_MACRO.gds \
  -rd schematic=/tmp/PLL_ANALOG_MACRO_flat.spice \
  -rd topcell=PLL_ANALOG_MACRO \
  -rd report=/opt/adpll_gen/signoff/reports/ics55/PLL_ANALOG_MACRO.lvsdb \
  -rd target_netlist=/opt/adpll_gen/signoff/reports/ics55/PLL_ANALOG_MACRO_extracted.cir \
  -rd run_mode=flat -rd combine_devices=true -rd threads=10
```

Result (kept in `signoff/reports/ics55/PLL_ANALOG_MACRO_lvs_flat.log`):

```text
PORT DEPTH 0: direct_texts=73 ports=71
ICS55_LVS_COMPARE=PASS
CONGRATULATIONS! Netlists match.
```

The extracted layout has 1525 devices after finger combining; the reference
also reduces to 1525 after the same combination.  `grep -c 'not matching'`
on the report is 0.

## DRC: 7T cell-internal vs macro top level

`classify_drc.py` now accepts the absolute instance boxes from
`dump_instances.rb`, so a top-tagged polygon that is physically inside a
standard-cell instance is attributed to that cell.

The final 160 × 100 µm build has **no top-level DRC**:

```text
total = 305
standard-cell internal = 305
  FILLTAPH7R 219  (215 implant.np.enclosed_area + 4 M1DUM)
  DFFNQX1H7R 8, NAND3X1H7R 7, NAND2X1H7R 6, ... (M1DUM / metal-area)
macro top-level = 0
```

- The **305 cell-internal** items are 7T library-cell-as-drawn issues:
  `FILLTAPH7R` NP holes, `M1DUM_W_1` (72), metal-area (16), etc.  They are
  not macro routing and cannot be fixed by editing the macro DEF.
- The top-level density rules are satisfied by the dummy fill described
  below.  There is **no top-level routing or geometry DRC**.
- A commercial signoff still needs a library DRC fix/waiver for the 7T cells;
  the macro itself is not introducing these errors.

Reports: `drc_summary.json`, `drc_summary.md`.

Reproduce:

```sh
klayout -b -r flow/macro/ics55_h7cr/dump_instances.rb \
  -rd gds=signoff/outputs/ics55/PLL_ANALOG_MACRO.gds \
  -rd top=PLL_ANALOG_MACRO -rd out=/tmp/macro_instances.json

python3 flow/macro/ics55_h7cr/classify_drc.py \
  --lyrdb signoff/reports/ics55/PLL_ANALOG_MACRO.lyrdb \
  --top PLL_ANALOG_MACRO --instances /tmp/macro_instances.json \
  --json-out flow/macro/ics55_h7cr/drc_summary.json \
  --md-out flow/macro/ics55_h7cr/drc_summary.md
```

### DRC waiver

`drc_waiver.json` and `waive_drc.py` implement an explicit **cell-internal**
waiver.  The script attributes top-tagged geometry to the containing instance
(so the 215 `implant.np.enclosed_area` holes in `FILLTAPH7R` are treated as
cell-internal), but it will **never** waive a top-level item.

```text
total = 305
waived (cell-internal) = 305
remaining = 0
```

The waiver is a documented library-cell waiver, not a claim that the 7T cells
are DRC-clean.  A foundry signoff must still replace it with a library fix or
an approved waiver.  Reproduce with `make waiver`.

### Density fill (production issue)

The 160 × 100 µm die is still sparse.  `add_density_fill.rb` adds
PDK-whitelisted dummy rectangles on:

```text
ACTDUM 2/2, POLYDUM 41/2, MET1DUM 81/2, MET2DUM 82/2, MET3DUM 83/2,
T4M2DUM 103/2
```

`FILL_LAYERS` in the macro Makefile selects these.  M4/M5 fill is deliberately
not added: the baseline 160 × 100 build did not violate their local-density
rules, and adding it creates floating metal nets that the provisional LVS
deck reports as unmatched.  The fill generator:

- uses exact 3×3, 2.4×2.4, 2×2 and 1×1 dummy rectangles from
  `ics55_rules.json`;
- keeps dummy fill out of standard-cell/via instance bboxes and expands real
  ACT/POLY/MET/CT/via keepouts by 0.5 µm;
- adds only shapes whose whole area is free.

This is a flow-level fill, not a Calibre-qualified fill deck: the KLayout
density checks and LVS both pass, but a production signoff must also check
dummy spacing, slotting and gradient rules.

## Views

```text
pnr/outputs/ics55/PLL_ANALOG_MACRO.lef   160 x 100 um abstract, pins + VDD/VSS
pnr/outputs/ics55/PLL_ANALOG_MACRO.lib   Liberty cell "PLL_ANALOG_MACRO"
pnr/outputs/ics55/PLL_ANALOG_MACRO.v     gate-level Verilog
pnr/outputs/ics55/PLL_ANALOG_MACRO.cdl   LVS schematic
pnr/outputs/ics55/PLL_ANALOG_MACRO.spef  extracted parasitics
pnr/outputs/ics55/PLL_ANALOG_MACRO.sdf   gate-level delays
signoff/outputs/ics55/PLL_ANALOG_MACRO.gds
```

The LEF/Liberty cell name is `PLL_ANALOG_MACRO`.  For top-level integration
either instantiate that cell or rename the wrapper/cell to `PLL_ANALOG`.

## Current blockers / next steps

1. **7T library DRC**: 305 cell-internal items need a library fix/waiver;
   they are not macro-routing errors.  Track them separately from macro DRC.
2. **Fill qualification**: the dummy fill is checked by the provisional KLayout
   density/LVS deck, but should be replaced or confirmed by the foundry fill
   deck (spacing/gradient/slot rules).
3. **LVS deck maturity**: the KLayout LVS deck is provisional.  For commercial
   signoff use Calibre/PVS or an equivalent qualified deck; the flat-reference
   PASS is a strong flow check, not a foundry seal.
4. **Characterization**: DCO tuning/monotonicity, injection range, SS-BBPD
   offset, ISF/phase noise, PVT/MC are not run.
5. **Top integration**: add `pll_macro_top.v` or rename the views to
   `PLL_ANALOG`, then run the ics55 `config.macro.yaml` with the real macro
   views.
