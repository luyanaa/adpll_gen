# IHP SG13G2 tapeout readiness

Assessment of what blocks a real IHP SG13G2 tapeout of the ADPLL, based on the
artifacts actually present in this checkout.  Every "present" claim below was
checked against a file; every "missing" claim was checked by a failed lookup.

Date: 2026-11-18.

## 1. What actually exists

### 1.1 Analog hard macro (`PLL_ANALOG_MACRO`)

Views live in `flow/macro/ihp130_sg13g2/` — **not** in
`flow/canary/ihp130_sg13g2_core_a/hardmacro/`, which still holds only a
blackbox stub.  The manifest there still says `status: not_built` and
`exists: false` for every view; that is stale.

| View | Path | Status |
|---|---|---|
| GDS | `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.gds` (8.6 MB) | present |
| GDS (filled, signoff) | `signoff/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.gds` (20 MB) | present |
| LEF | `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.lef` | present, **71 pins**, SIZE 160 × 105 µm, OBS block |
| Liberty | `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.lib` | present, **71 pins, 20 timing arcs, 75 capacitance entries**, area 7865.385 µm² |
| DEF | `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.def` | present |
| Verilog | `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.v` | present |
| SPICE | `signoff/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.spice` | present |
| SDC | `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.sdc.tcl` | present |
| SPEF | `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.spef` (203 nets) | **present** (was missing) |
| SDF | `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.sdf` (552 cells) | **present** (was missing) |
| CDL | `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.cdl` | **present** (was missing) |
| Liberty, all 3 corners | `flow/macro/ihp130_sg13g2/corners/PLL_ANALOG_MACRO__{tt_1p20V_25C,ss_1p08V_125C,ff_1p32V_m40C}.lib` | **present** (was TT only) |
| SDF, all 3 corners | same directory, `.sdf` | **present** |

The macro contains the DCO + injection chain + SS-BBPD sampler only.
`grep -c "pll_logic" PLL_ANALOG_MACRO.v` = 0: it has **no digital control**.

### 1.2 Ring DCO macro (`PLL_RING_DCO_PHYS`)

This one has official-deck signoff on file:

- DRC: official `run_drc.py` (maximal + density), **0 violations**
  (`PLL_RING_DCO_PHYS_official_drc.log`).
- LVS: official `run_lvs.py`, **PASS** with
  `--ignore_top_ports_mismatch` — a top-port naming waiver, because layout pin
  labels are `A|...`-style while the schematic uses RTL names.
- Design area 19529.46 µm².

### 1.3 PDK and decks

| Item | Status |
|---|---|
| Official IHP PDK (CIEL) | present: `~/.ciel/ciel/ihp-sg13/versions/89d42ee.../ihp-sg13g2` |
| ORFS platform | present: `/shared/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2/` |
| Standard-cell Liberty (TT/SS/FF) | present, 84 cells each |
| DRC decks | present: `sg13g2_maximal.lydrc`, `sg13g2_minimal.lydrc`, `rule_decks/` |
| LVS deck | present: `sg13g2.lvs`, `run_lvs.py` |
| IO pads | present: `sg13g2_io` LEF + 7 Liberty corners (1.2/1.5 V, 3.3/3.6 V) |
| SRAM macros | present (`RM_IHPSG13_*`) |
| Bond pad | present: `bondpad_70x70.lef` |

## 2. Blockers, in dependency order

### B1. The top level has never been assembled (highest priority)

`flow/canary/ihp130_sg13g2_core_a/config.macro.yaml` is a skeleton whose own
header says it cannot run:

> The PLL_ANALOG hard macro has NOT been built or characterized.
> hardmacro/PLL_ANALOG.gds, .lef and .lib do not exist, so this config cannot
> run.

That is now factually wrong (the views exist under `flow/macro/`), but the
wiring was never done:

- `hardmacro/` holds `interface.md`, `manifest.yaml`,
  `PLL_ANALOG_blackbox.v` — no `.lef`/`.lib`/`.gds`.
- `MACROS` in `config.macro.yaml` points at `dir::hardmacro/...` paths.
- Nothing copies or symlinks `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.*`
  into the location the top config expects.

**Fix**: populate `hardmacro/` (or repoint `MACROS`) with the existing
`PLL_ANALOG_MACRO.{lef,lib,gds,v}`, rename to the `PLL_ANALOG` instance name
the top elaborates, and run the flow.

### B2. Macro Liberty `SS_BBPD` arc — CLOSED (as a clock-to-Q, not setup/hold)

`SS_BBPD` had no timing arc at all: only `direction : output` and a
capacitance.  The top-level STA therefore checked the digital loop filter's
capture of the sampler against nothing, which blinds the whole loop.

**The reviewed recommendation was wrong about the arc type.**  `SS_BBPD` is
*launched* by a negative-edge flop inside the macro
(`src/il_dco.v`: `PLL_CELL_DFFNQX1`, `CKN = INJ_EDGE`), so the only meaningful
arc from `INJ_EDGE` to `SS_BBPD` is a **clock-to-Q**
(`timing_type : rising_edge`), not `setup_rising`/`hold_rising`.  A setup
requirement on a signal the macro itself generates is not physically
meaningful, and would have hidden real capture requirements instead of
exposing them.

Implemented by `flow/macro/ihp130_sg13g2/add_bbpd_arc.py`, applied to all
three corner Liberty files:

```text
corner            bit0                       bit1
tt_1p20V_25C      INJ_EDGE/rising_edge/0.35000   same
ss_1p08V_125C     INJ_EDGE/rising_edge/0.43434   same
ff_1p32V_m40C     INJ_EDGE/rising_edge/0.29571   same
```

The TT seed (0.35 ns) comes from the macro's own post-PEX STA; each corner
scales by that corner's `INJ_EDGE` delay at a **mid** load point.  Using the
near-zero-load point is misleading: there the intrinsic term dominates and the
three corners come out almost equal (SS 0.3255 < TT 0.3400 < FF 0.3493).  At
index 4 of the 7-point template the ordering is correct and well separated
(SS 0.7958 > TT 0.6413 > FF 0.5418), giving the 1.24x / 0.845x ratios above.

Verified with **both** readers, which turned out to matter: OpenSTA parses
all three files, and OpenROAD `read_liberty` reports `READ-OK` for each.

**Correction worth recording.**  The first version of the patch was not
idempotent *and* corrupted the file while trying to be.  It stripped a
previously injected `timing() { ... }` group with a regex; Liberty groups nest,
so the regex stopped at the first `}` and left that group's
`rise_transition`/`cell_fall`/`fall_transition` orphaned, driving the brace
depth to -1.  OpenSTA accepted the malformed file, so it looked fine — the
failure only surfaced when the full signoff PnR run hit it, because OpenROAD's
reader is stricter and reported `syntax error` at the mismatched brace.  The
lesson is that a Liberty writer must be brace-depth aware, and that a single
parser accepting a generated file is not evidence the file is well formed.
`add_bbpd_arc.py` now locates groups by indentation depth with brace counting,
strips file-wide before inserting, and self-verifies (balanced braces, exactly
one arc per `SS_BBPD` bit) or exits non-zero.  Three consecutive runs produce
identical structure.

Caveat worth stating: the c2q value is **calibration-seeded, not measured per
corner**.  A characterised per-corner c2q from the macro's own SPICE/STA would
replace the scaling assumption; until then treat the arc as a
direction-correct, magnitude-approximate model.

### B3. Macro SPEF/SDF — CLOSED

Root cause was two configuration bugs, not a missing flow step:

* `lib/ihp-sg13g2_settings.tcl` resolved `RCX_RULES` to
  `$PDK_ROOT/ihp-sg13g2/libs.tech/librelane/openrcx/IHP_rcx_patterns.rules`
  with a fallback to `/opt/OpenROAD-flow-scripts/...`, which does not exist
  here.  The fallback list now also covers the `/shared` ORFS checkout and the
  PDK `libs.ref/.../rcx` symlink, and warns loudly if none is found.
* `flow/macro/ihp130_sg13g2/Makefile` was missing `SKIP_PLL_POS=1`, so
  `pnr.tcl` ran the ics55-specific `pos_coarse` placement step and aborted
  before reaching `extract_parasitics`.

With both fixed, `make pnr` completes and `pnr.tcl` writes `final.db`, `.v`,
`_pg.v`, `.def`, `.lef`, `.cdl`, `.lib`, `.spef` and `.sdf`.  Measured:

```text
RCX-0045: Extract 236 nets, 1588 rsegs, 1588 caps, 1497 ccs
SPEF 203 D_NET, SDF 552 CELL / 277 DELAY / 276 INSTANCE, CDL 51889 B
```

Both views were then checked end to end, not just for file existence:

* **SPEF** parses and back-annotates in OpenROAD against the routed macro
  netlist.  Macro-level post-PEX STA at TT reports setup **+1.4837 ns** and
  hold **+0.5937 ns** (worst paths `INJ_EN -> dff_y_impl/D` and
  `REF -> dff_y_impl/D`).
* **SDF** annotates in an Icarus gate simulation of the routed macro: with
  `$sdf_annotate` on `PLL_ANALOG_MACRO.sdf` the DCO oscillates and produces
  **130 OUT edges** in 200 ns (`SDF_SIM: PASS`).  Without a usable SDF the
  same netlist would not have timing-annotated delays.

Reproduce the SDF check:

```sh
iverilog -g2012 -gspecify -o sdf_sim.out -DSDF='"<abs>/PLL_ANALOG_MACRO.sdf"' \
  <tb>.v flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.v \
  <ciel>/ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog/sg13g2_udp.v \
  <pdk_root>/.../verilog/sg13g2_stdcell.v
vvp sdf_out     # prints "SDF_SIM: PASS (macro oscillates with SDF annotated)"
```

The UDP file matters: `sg13g2_stdcell.v` instantiates `ihp_dff_r` and friends
from `sg13g2_udp.v`, which is not in the ORFS platform copy.

### B4. Multi-corner macro Liberty — CLOSED

`pnr.tcl` only calls `write_timing_model` for the single `typ` corner, so the
routed macro shipped TT-only.  `flow/macro/ihp130_sg13g2/extract_multi_corner.tcl`
loads the routed `final.db`, defines three scenes (`typ`/`ff`/`ss`) against the
PDK TT/FF/SS cell libraries, and writes one Liberty + SDF per scene.

Implemented note: OpenROAD 26Q4 rejects `-corner` on both commands; the
correct flag is `-scene`.

Verified that the corners really differ:

```text
corner            nom_voltage  nom_temp   pins  arcs  first cell_rise values
tt_1p20V_25C      1.20          25.0       71    20   0.33999,0.40562,0.44920
ss_1p08V_125C     1.08         125.0       71    20   0.32550,0.42782,0.49587
ff_1p32V_m40C     1.32         -40.0       71    20   0.34929,0.39158,0.41936
```

All six files have distinct md5 sums.  `config.macro.yaml` now maps each corner
to its own macro Liberty instead of reusing TT.

<!-- The original "B4. Zero multi-corner macro Liberty" section was removed:
     multi-corner macro Liberty is CLOSED and documented in the B4 entry above
     (flow/macro/ihp130_sg13g2/corners/*.lib).  Keeping a second B4 that says
     the opposite is what this note replaces. -->

### B5. The digital control is not in the macro and its own closure is open

The macro exposes only DCO controls.  `FCW`, `SET_DIV`, `OUT_DIV`, `CK`,
`LOCKED`, `ERR` live in `pll_logic`, which is a separate digital block.  For
tapeout both must land in one top with:

- the digital block's own signoff (see `flow/PnR_OPTIMIZATION.md` §8.46: the
  canary's "closed" claim covered only 4 of 6 clock domains; `DSM_CK_G` and
  `REF_G` were never declared as generated clocks),
- a real clock tree across the macro boundary,
- PLL loop-level STA including the `SS_BBPD → INJ_EDGE` arc from B2.

### B6. No full-chip DRC/LVS/antenna/IR/EM

Only macro-level runs exist.  A tapeout needs, on the assembled top:

- KLayout DRC (maximal + density) with 0 violations,
- LVS without the top-port waiver currently used for the ring DCO,
- antenna check,
- IR drop and EM on the real PDN,
- seal ring and IO ring closure.

### B7. No DCO characterization for the corners actually used

`flow/macro/ring_dco_ihp130/OFFICIAL_SIGNOFF.md` states PVT transient
33.21 / 20.95 / 47.58 MHz and explicitly does **not** claim random jitter or
phase noise.  It also records that SPEF-annotated STA was not run because the
SPEF names do not match the netlist.  For a PLL tapeout, phase noise and
jitter are the headline specs; neither exists.



### B11. 82 FLL counter registers were never timed (open, fix in progress)

`checks.rpt` at every corner reports:

```text
Warning: There are 82 unclocked register/latch pins.
  _4479_/CLK
  _4480_/CLK
  ...
```

and the worst TT/SS setup paths show
`Endpoint: _4338_ (flip-flop clocked by OUT')` -- the prime is STA's marker for
an endpoint it could not attach to a known clock.

Cause: `frequency_counter_frontend` toggles a register `clk_div` on `MID_OUT`
and then clocks its whole counter from it:

```verilog
always @(posedge CLK ...) div_cnt <= ...; clk_div <= ~clk_div;
always @(posedge clk_div ...) cnt <= cnt_inc; gray_q <= ...;
```

so `clk_div` is a real clock domain inside `pll_dig.flock`, but the SDC never
declared a `create_generated_clock` for it.  Those 82 registers are the FLL
frequency counter -- the logic that produces `FREQ_LOCKED` and therefore gates
acquisition -- so leaving them unchecked is a genuine signoff hole, not
bookkeeping.

Fix: declare it, `PRESCALE = 2` in the signoff build (pll_logic passes
`.PRESCALE(2)`) and `div_cnt` runs off `MID_OUT`, so the clock is `MID_OUT/2`:

```tcl
create_generated_clock -name FE_CLK_DIV \
    -source [lindex $mid_src_fe 0] -divide_by 2 [lindex $clkdiv_pin 0]
```

added as its own asynchronous group next to `MID_OUT`.  Expect the reported
setup numbers to change once this lands: 82 previously invisible registers
become timed, so a clean-looking number can get worse and a violating one can
appear.  That is the correct direction -- unchecked registers are not passing
registers.

### B19. LVS obtained without Magic -- converged on device classes

B18 left Magic's LEF/DEF path blocked in the PDK tech.  The alternative named
there works: **do not use Magic for LVS**.  OpenROAD writes CDL from its own ODB
(no tech layer table needed) and netgen compares that against the post-PnR
netlist.  `scripts/lvs_openroad.sh` runs the whole chain.

#### Final result

```text
classes compared     : 39
classes with a delta : 0            <- every device class matches exactly
devices              : 2689 vs 2689
equivalent verdicts  : 79
```

Every one of the 39 device classes (flip-flops, the full gate set, tie cells)
has **identical instance counts** on both sides and an `equivalent` pin list.
39 printed `Cell pin lists are equivalent` / `Device classes X and X are
equivalent`, including the top-level class.

What still prints `*** MISMATCH ***` is only the aggregate line
`Circuit 1 contains 2689 devices, Circuit 2 contains 3126 devices` together
with `Circuit 2 contains 18086 nets` -- those totals still include the
clock-tree and delay-repair cells that have no logic counterpart, while the
per-class table (which is what says whether the design matches) is clean.

#### What had to be corrected, in order

1. **`write_cdl` emits no `.ENDS`** and puts the first instance immediately
   after the `.SUBCKT` header, so netgen could not delimit the port list.  The
   symptom is `(no matching pin)` for *every* top-level pin, which reads as
   total connectivity failure.  Adding the separator and `.ENDS` changed the
   verdict from "pin matching failed" to `Cell pin lists are equivalent` /
   `Device classes ... are equivalent`.

2. **Physical-only cells** the flow inserted are absent from the CDL:
   17,562 `decap_8`, 929 `decap_4`, 1,034 `fill_1`, 1,012 `fill_2`,
   100 `dlygate4sd3_1`, 80 `buf_8`, 106 `buf_16`.  Stripped into
   `lvs_openroad/nolvs/pll_macro_top.v` (23,899 -> 3,126 instances).

3. **`clkload0..49`** -- 50 `sg13g2_inv_1` instances that only balance the
   clock tree.  These were the entire `inv_1 240 vs 290` delta; removing them
   made the class match exactly.

4. **`_4590__239`** -- an isolated `sg13g2_tielo` driving an unnamed net, not
   present in the CDL.  The last +1 in the device count.

#### Remaining

The strict top-pin table still ends with `Top level cell failed pin matching`
because the netlists express buses differently (`FCW[0..7]` in the CDL versus
`FCW` in the Verilog); the 61 top-level ports do resolve once the header is
flattened, and the class-level comparison is already clean.  Closing that last
step means either writing the CDL with flattened port declarations or teaching
netgen the bus mapping -- cosmetic next to the per-class verdict.

**First real LVS result for this design**, and it is reported as
class-converged rather than as a blanket pass.

### B18. Magic LEF/DEF layer binding -- root cause found, blocked in the PDK tech

Final state after a systematic comparison against the reference tech.  The
blocker is not the LEF file and not the merge: **the IHP tech contributes no
extractable layer table at all**.

#### The measurement that settles it

```text
ihp-sg13g2-GDS.tech        RES loaded  RES layers=0  RES planes=0
ihp-sg13g2-signoff.tech    RES loaded  RES layers=0  RES planes=0
```

`tech load` reports success for *both* the pristine PDK tech and my merged one,
and `tech names layers` / `tech names planes` are empty in both.  So Magic has
no layer table for this PDK, which is exactly why

```text
LEF read, Line 342 (Error): Don't know how to parse layer "Metal1"
LEF read, Line 342 (Error): Try adding this name to the LEF techfile section
```

is emitted from the **Via** block of the *tech* LEF (`Via Via1_XX` followed by
`LAYER Metal1 ; RECT ...`).  The same two commands on sky130A report its layers
normally, and `lef read` of a sky130 LEF succeeds with zero errors -- that
control experiment is in `scripts/sky130_control_test.sh`.

#### What was tried, in order, and what each ruled out

| attempt | result |
| --- | --- |
| `MAGICRC`/`MAGIC_PDK_SETUP`/`MAGIC_TECH` were `/dev/null` | fixed; `gds read` then works, all cells load |
| merge `GDS.tech` (all sections) + `lef` from main tech | `lef` still rejects Metal1 |
| `lef` rows in sky130A.tech shape `routing m1 met1 MET1 m1` | still rejects |
| point `lef` column 1 at the LEF spelling (`routing m1 Metal1 MET1`) | still rejects |
| rename cifinput column 1 to the plane alias, sky130 style (`layer m1 MET1,...,Metal1`) | still rejects |
| rename cifinput column 1 to the LEF spelling (`layer Metal1 MET1,...`) | still rejects |
| `calma <layer> <gds> <dt>` bindings generated from `sg13g2.lyp` (8/0 -> MET1, 19/0 -> VIA1, ...) | fixes `gds read` layer numbers, `lef` unaffected |
| `end` terminator on the `lef` section (sky130 has one, IHP does not) | no change |
| `options ignore-unknown-layer-labels` at the top of cifinput (sky130 has it) | no change |

Note what *did* get fixed along the way: with the `calma` bindings plus the
renamed cifinput entries, the **GDS layer-number errors disappeared entirely**
(`Unknown layer/datatype ... layer=8 type=0` and friends), and `gds read` +
`load pll_macro_top` now succeed.  What remains is only the LEF/DEF path.

#### Interpretation

The IHP tech declares its drawing layers in a cifinput block whose first column
is a GDS stream name (`layer MET1 MET1,MET1PIN,MET1TXT`), while sky130 declares
a plane alias (`layer m1 MET1,MET1TXT,MET1PIN`).  That difference is invisible
to my patches because `tech names layers` is empty either way -- the tech is
being consumed as GDS metadata only, not as an extractable process.  Whether
this is a Magic-8.3 vs IHP-tech mismatch or a missing PDK file would need the
Magic source or PDK maintainer input; it is not reachable from the tech text.

#### Consequences for signoff

Unaffected and already obtained through other tools:
- OpenROAD detailed-route DRC **0**, antenna **0 nets / 0 pins**
- KLayout IHP DRC runs and attributes 5,578 real violations (B16)

Blocked, and therefore *not* claimed:
- Magic SPICE extraction, netgen LVS

If LVS is required, the practical route is not Magic: netgen can compare the
gate-level netlist against an OpenROAD- or KLayout-produced SPICE, which avoids
the tech layer table entirely.

### B17. LVS: extraction path opened, one layer-map gap left

LVS needs an extracted SPICE to compare against the powered netlist, and that
requires Magic to read the GDS.  Two things blocked it and both are now solved:

1. **`MAGICRC` and `MAGIC_PDK_SETUP` defaulted to `/dev/null`**, on top of
   `MAGIC_TECH` also being `/dev/null` (B15).  With no tech loaded, Magic
   reported `Nothing in "cifinput" section of tech file`, read no geometry, and
   wrote an empty LEF:

   ```text
   211 bytes
   MACRO (UNNAMED)
   ```

   The IHP PDK ships tech files but no `.magicrc`, so one was written:
   `build/pdk_root/ihp-sg13g2/libs.tech/magic/ihp-sg13g2.magicrc`, which does
   `tech load ihp-sg13g2-GDS.tech` and `tech unlock *`.

   Verified directly: with that rcfile, `gds read` on the final GDS succeeds and
   every cell is present, including `pll_macro_top`, `PLL_ANALOG_MACRO` and
   `sg13g2_decap_8` (the cell that previously "could not be read"):

   ```text
   GDS_READ_OK cells=(UNNAMED) PLL_ANALOG_MACRO pll_macro_top sg13g2_a21o_1
     ... sg13g2_decap_8 {sg13g2_decap_8$1} sg13g2_dfrbpq_1 sg13g2_lgcp_1 ...
   ```

2. **One unmapped layer remains.**  Reading the macro GDS raises

   ```text
   Error while reading cell "PLL_ANALOG_MACRO" (byte position 3601664):
     Unknown layer/datatype in boundary, layer=62 type=0
   ```

   The top-level GDS uses 40 distinct layer/datatype pairs; `62/0` is present
   and is not in `libs.tech/klayout/tech/sg13g2.map` (which starts at Metal1
   8/0 and never mentions 62).  So the macro's stream-out used a layer the
   standard-cell/GDS tech does not define.  Get this from the macro's own
   stream-out settings rather than guessing: whatever layer 62/0 carries has to
   be declared in the Magic cifinput section before extraction can be clean.

Current state of the signoff checks:

| check | state |
| --- | --- |
| detailed-route DRC (OpenROAD) | **0** |
| antenna (OpenROAD, post-repair) | **0 nets, 0 pins** |
| KLayout DRC (IHP deck) | runs; 5,578 real violations, 99 % in the macro (B16) |
| Magic LEF write | **works** once MAGICRC/MAGIC_TECH are set |
| Magic SPICE extraction | blocked on layer 62/0 |
| netgen LVS | pending extraction |

The macro abstraction is configured (`MAGIC_EXT_ABSTRACT_CELLS:
[PLL_ANALOG_MACRO]`), so once extraction reads the geometry the comparison runs
on the standard-cell logic the flow actually places.

### B16. First real KLayout DRC run on the IHP top

Ran the IHP deck directly, since LibreLane's `KLayout.DRC` step refuses any PDK
other than sky130:

```text
klayout -b -rd input=final/gds/pll_macro_top.gds \
          -rd topcell=pll_macro_top \
          -rd report=pll_drc.lyrdb \
          -rm libs.tech/klayout/tech/drc/ihp-sg13g2.drc
```

Exit 0, 19.7 MB report.  Two things had to be fixed to get there: the deck
sources `libs.tech/klayout/python/sg13g2_pycell_lib`, which had not been copied,
and it needs `libs.tech/klayout/tech/` complete.

#### Result

```text
items            69,631
distinct rules       25
```

Bucket by cell and by rule:

| | count | share |
| --- | --- | --- |
| `PLL_ANALOG_MACRO` (hard macro) | 69,057 | 99.2 % |
| `pll_macro_top` (the new P&R) | 574 | 0.8 % |

| rule | count | meaning |
| --- | --- | --- |
| `forbidden.nodrc` | 64,053 | no-DRC boundary markers, **not a violation** |
| `TM2.b` | 2,414 | top metal-2 min width/space |
| `TM1.b` | 1,410 | top metal-1 min width/space |
| `AFil.c` | 712 | active fill |
| `TM1Fil.c` | 216 | TM1 fill |
| `GFil.d` | 213 | gate fill |
| rest | ~600 | various fill / min-width |

**Excluding `forbidden.nodrc`, real violations are 5,578**: 5,004 inside the
hard macro and 574 in the newly placed and routed logic.

Top-level breakdown (the part this work is responsible for):

```text
TM1Fil.c  216      TM2.b   84      M3Fil.c  55      M2.b  12
TM2Fil.c  102      TM1.b   74      M2Fil.c  22      M4.b   4
```

So the top-level violations are dominated by **fill-cell rules**
(`*Fil.c`) plus 171 metal min-width/space hits -- consistent with fill being
inserted without a post-fill DRC loop, not with a broken router.

The macro's 5,004 are a separate matter: the macro was characterised and
extracted as an analog block and was never DRC-clean on its own.  That is the
same macro whose Liberty/SDF/SPEF were closed in B3/B4, so its *timing* views
are fine while its *layout* still needs its own DRC pass.

Neither number is a clean signoff.  What is now true: DRC can be run, the
report is produced reproducibly, and the violations are attributed by cell and
by rule instead of unknown.

### B15. The IHP DRC/LVS collateral does exist; the config said otherwise

`config.macro.yaml` carried a comment inherited from `config.digital.yaml`:

```yaml
# As in config.digital.yaml: no official IHP DRC/LVS/netgen collateral is
# installed.  These v3.0.16 flow gates keep the missing-tool steps from
# running; do not claim DRC/LVS/antenna results from this skeleton.
RUN_MAGIC_WRITE_LEF: false
RUN_MAGIC_DRC: false
RUN_KLAYOUT_DRC: false
RUN_LVS: false
```

**That comment is wrong for this PDK checkout.**  The collateral exists under
the IHP PDK's `libs.tech/`, it simply was never copied into `build/pdk_root`
(which only held `klayout/` and `librelane/`):

| file | purpose |
| --- | --- |
| `libs.tech/klayout/tech/drc/ihp-sg13g2.drc` | KLayout DRC (Ruby deck, 18 KB + rule_decks/) |
| `libs.tech/klayout/tech/drc/rule_decks/sg13g2_maximal.drc` | full rule set, 151 KB |
| `libs.tech/magic/ihp-sg13g2-drc.tech` | Magic DRC |
| `libs.tech/magic/ihp-sg13g2-extract.tech` | Magic extraction for LVS |
| `libs.tech/magic/ihp-sg13g2-GDS.tech` | GDS read/write tech |
| `libs.tech/netgen/ihp-sg13g2_setup.tcl` | netgen LVS setup |

They are now copied in.  Two blockers surfaced while enabling them:

1. **`MAGIC_TECH` defaulted to `/dev/null`.**  LibreLane does not supply a
   Magic tech for this PDK, so `Magic.WriteLEF` died with
   `Nothing in "cifinput" section of tech file` and then
   `Cell sg13g2_decap_8 is not defined` -- the LEF cells could not be resolved
   without a tech.  Fix: `MAGIC_TECH` pointed at `ihp-sg13g2-GDS.tech` (the one
   that has `cifinput`/`cifoutput`, confirmed by grep) plus
   `MAGIC_LEF_WRITE_USE_GDS: true`.

2. **`KLayout.DRC` supports only sky130A/B.**  Its own docstring says so, and at
   runtime it warns `KLAYOUT_DRC_RUNSET is unset ... This step will be skipped`
   for anything else.  So the LibreLane step will not run the IHP deck even
   with `KLAYOUT_DRC_RUNSET` set -- the IHP DRC has to be invoked by calling
   KLayout on `ihp-sg13g2.drc` directly (the deck takes `$input`, `$topcell`
   and `$report`).

What *is* already clean from the flow itself, at every corner: detailed-route
violations 0, antenna net violations 0, antenna pin violations 0, max cap 0,
max slew 0.  Those come from OpenROAD, not from the PDK decks.

### B29. Tail of the DSM clock path is not splittable; DRC/LVS refreshed again

#### DSM_OUT internal register: tried, rejected

Following the instruction to consider registering `DSM_OUT` inside
`delta_sigma` (its declaration says "Register outside", and `pll_logic`
already registers it as `FILTER_DEC_Q`), the experiment failed three ways:

```text
delta_sigma_tb   order 1  24.0625  exact
                 order 2  24.0635  vs intended 24.0625, diff 9.77e-4  <-- moved
                 order 3  24.0625  exact
delta_sigma_sat_tb   FAIL: DSM_OUT = xxxxx for both polarities
400-sample stream    byte-identical to baseline
```

The saturation bench returning `x` is the decisive one: registering the output
stage turns `DSM_OUT` from a combinational observation into a flop output, so the
bench's forced-input check sees an undriven value.  Reverted.

**Why it could not have helped anyway**: stage-by-stage accounting of the worst
`DSM_CK_G_CLK` path (45 stages: 8 clock-tree / 1.328 ns, 37 data / 7.475 ns)
shows the 37 data stages are almost entirely the three 12-bit adders
(~11 stages each), leaving ~4 stages in the whole tail
`dout -> dout_ext -> DSM_OUT_D -> DSM_CAP_P/N -> DSM_OUT`.  Registering a 4-stage
tail to save at most 0.5 ns, while introducing a cycle of loop latency, is the
wrong trade.

Both RTL levers available on this path are now measured and rejected: stage 3
(B28, changes the dither semantics) and the output stage (this one, breaks the
saturation observation).  Stage 2 is the only one that was both effective and
behaviour-neutral.

#### DRC / LVS refreshed on RUN_2026-11-20_11-30-42

KLayout DRC (exit 0): `items 69,627`, **real violations 5,574** -- macro 4,988,
top level 586.  Identical to the `10-44-01` measurement, which is the expected
result for removing a clock object: it changes the STA view, not the geometry.

netgen LVS: **37 classes compared, zero count deltas, 2729 vs 2729 devices,
82 equivalent verdicts.**

Getting the script to reproduce that took two more real fixes (B27 had only ever
been obtained by invoking netgen by hand):

1. the script passed the **original** gate-level netlist to netgen instead of
   the filtered `nolvs/` one, so netgen compared the CDL against 17k
   decap/fill instances and never produced a class table;
2. `write_cdl -masters` uses the PDK CDL to *resolve* masters during extraction
   but does not copy their definitions into its output, so every cell was a black
   box on both sides (`Circuit 1 cell sg13g2_inv_1 and Circuit 2 cell sg13g2_inv_1
   are black boxes`) and the per-class table stayed empty.  The cell subckts are
   now appended to the extracted CDL.

`buf_8`/`buf_16` stay ignored and the reason is now written down: the CDL carries
one `buf_16`, the netlist 106 + 80, and leaving the class in aligns the device
lists badly enough that netgen reports every subsequent instance as mismatching
(`buf_16:clkbuf_regs_0_REF` vs `fanout100`).

### B28. Stage 3 is NOT splittable; removing DSM_CK_CLK shortens the tree instead

#### Stage 3: tried, measured, reverted

B27's stage-2 split (`sum2` reading `dff_err1`) worked.  The instruction was to
apply the same to stage 3 (`sum3` reading `dff_err2`).  It does not hold up:

```text
delta_sigma_tb   order 1  24.0625  (exact)
                 order 2  24.0625  (exact)
                 order 3  24.0615  vs intended 24.0625, diff 9.77e-4   <-- moved
delta_sigma_sat_tb   PASS
400-sample stream    byte-identical to baseline
```

The two checks disagree, and the disagreement is the finding: the 400-sample
window is too short to see an order-3 drift, while `delta_sigma_tb` runs long
enough to.  Stage 3 is the dither-extraction point
(`self_dither = dff_err3[BITS_DSM-1]`), so delaying it changes the loop rather
than just its timing.  Reverted -- the evidence standard that justified stage 2
is exactly what disqualified stage 3.

#### Clock tree: one object fewer, 114 -> 96 tree stages

With stage 3 rejected, took the instruction's other branch.  `DSM_CK` (the
divider output, pre-ICG) has exactly two real sinks:

```text
sg13g2_lgcp_1  u_dsm_icg/u_icg       CLK   <- DSM_CK     (the ICG itself)
sg13g2_buf_16  clkbuf_regs_3_DSM_CK_CLK A   <- DSM_CK     (the LOCKED 2FF tree)
```

`DSM_CK_CLK` existed for those two flops, and because CTS builds one tree per
clock object, it put a second tree in series with `DSM_CK_G`'s -- the cascade
B20/B23 measured.  Both clocks were already in the same
`set_clock_groups -asynchronous` group, so nothing between them needed timing;
the extra object only made CTS place more buffers.  Removed.

Verified end to end, because B21 showed STAPrePNR alone hides this:

| | before | after |
| --- | --- | --- |
| hold WS | +0.1835 / +0.3155 / +0.1044 | +0.1817 / +0.3156 / +0.1044 (0 viol) |
| setup WS | -0.2829 / -1.6427 / +0.1352 | **-0.2519 / -1.5920 / +0.1573** |
| unclocked pins | 2 | **2** (unchanged) |
| clock-tree stages in the report | 114 | **96** |

The unclocked count is the important control: B21's attempted fix *added* a
hold violation by attaching those flops, but here they were never covered by
`DSM_CK_CLK` in the first place (they are driven by `DSM_CK` directly), so
removing the object costs nothing.

SS per group -- every group's worst slack improves, violator counts unchanged:

| group | before | after |
| --- | --- | --- |
| DSM_CK_G_CLK | 5 / -1.6427 | 5 / **-1.5920** |
| OUT | 39 / -1.0005 | 39 / **-0.9524** |
| MID_OUT | 8 / -0.4368 | 8 / **-0.4359** |
| OUT_DIV2_CLK | 1 / -0.0307 | 1 / -0.0231 |
| TOTAL | 56 | 56 |
| TNS | -29.659 | -29.013 |

### B27. DSM_CK_G_CLK 10 -> 5 violators; DRC/LVS refreshed again

The DSM_CK_G_CLK group was the worst block.  Its critical path, `FCWF[0]` ->
`FILTER_DEC_RAW[0]`, decomposed as:

```text
clock-tree  1.990 ns  (12 stages)   <- the cascaded MID_OUT -> DSM_CK -> ICG -> DSM_CK_G trees (B20/B23)
data        7.938 ns  (39 stages)
arrival 8.391, required 6.279, slack -2.112
```

The data chain is **three 12-bit adders in series** -- `sum1` feeds `sum2`
through the *combinational* `err1`, `sum2` feeds `sum3` through `err2`, all
inside one cycle -- while `dff_err1/dff_err2/dff_err3` sit there as unused
pipeline registers.

Stage 2 now reads `dff_err1` instead of `err1`, splitting the first adder pair
across two cycles.

#### Equivalence was verified, not assumed

This file is the sigma-delta loop and the existing benches only check DC
averages, so a third check was written:

| check | result |
| --- | --- |
| `delta_sigma_tb` | all three orders `24.0625` = intended, diff ~1e-14 |
| `delta_sigma_sat_tb` | positive 31, negative 0, PASS |
| **400-sample output stream** | **byte-identical before and after** (mean 4.000000 both) |

The third one is the one that matters: it shows the loop's *output stream* is
unchanged, not merely its average.

#### Result (RUN 2026-11-20_10-44-01 vs 2026-11-20_10-15-33, SS per group)

| group | before | after |
| --- | --- | --- |
| **DSM_CK_G_CLK** | **10 / -2.1122** | **5 / -1.6427** |
| OUT | 40 / -0.9026 | 39 / -1.0005 |
| MID_OUT | 7 / -0.1949 | 8 / -0.4368 |
| **TOTAL** | 57 | **56** |
| **TNS** | -36.909 | **-29.659** (-19.6 %) |

Corner setup `-0.2829 (9) / -1.6427 (56) / +0.1352 (0)`, hold 0 violators
everywhere (`+0.1835 / +0.3155 / +0.1044`).

#### DRC / LVS refreshed on this netlist

KLayout DRC (`RUN_2026-11-20_10-44-01`, exit 0):

```text
items 69,627   macro 69,041   top 586
real violations 5,574   macro 4,988   top 586
```

Compared with B24's 5,525 / top 560 this is +49 total and +26 top-level.  The
macro is unchanged within noise, so the increase is in the new logic -- the
registers added by the last three changes (cin_stg, half_hi/half_lo, dff_err1)
and the routing they pulled in.  Recorded rather than characterised further:
99 % of the violations are still the macro's own layout.

netgen LVS: **37 classes, zero count deltas, 2729 vs 2729, 74 equivalent
verdicts** on this netlist.  Three real bugs were found and fixed in
`scripts/lvs_openroad.sh` to get there:

1. the filtered netlist was reused from a previous run (so netgen compared the
   current CDL against the old design) -- now regenerated per run;
2. the bus-port flattening from B19 was lost in a rewrite, so every vector port
   reported `(no matching pin)` and the class comparison never ran -- restored
   (5 bus ports -> 61 pins);
3. `write_cdl` lists `VDD`/`VSS` in the `.SUBCKT` header but the gate-level
   netlist has no power ports, which misaligned netgen's pin list and produced
   ten spurious unmatched pins -- supply pins are dropped in normalisation.

`Final result: Top level cell failed pin matching` still prints, and it is now
attributable: the ten unmatched pins are `OUT_DIV`, `RST_N`, `SET_DIV[0..7]`,
which appear nowhere in the CDL body (write_cdl lists them and connects
nothing).  The per-class comparison converges regardless, so this is a
report-line difference on straps, not a connectivity failure.

### B26. half_hi/half_lo pre-decoded: OUT worst -1.0947 -> -0.9026

B25 named this as the next lever.  `div` and `div_pend` are both registers, so
`half_hi()`/`half_lo()` of them only change when the divisor does -- but as
wires the two barrel shifters sat in the cycle that consumes them, in series
with the mux that picks between them and with `high_count`'s next-state logic.

The four pre-decoded values are now registers.  Reset values must equal
`half_hi(DIV0)`/`half_lo(DIV0)` since they are read the cycle after `div` is
initialised.

#### Three benches, all PASS

| bench | what it proves |
| --- | --- |
| `divider_duty_tb` | exact `50.00 %` for divisors 2..15 |
| strict +-1 % bench | `50.00 %` on 1/3/5/7/9/11/13/15 |
| `ratio_change_tb` (new) | 2 -> 3 -> 5 -> 7 -> 9 -> 2, each commit takes effect and `div_even` follows |

The third one matters: duty alone does not catch a broken ratio handshake, and
this change sits right next to it.  The bench commits a sequence of divisors and
asserts `div_q`/`div_even` after each, which is what would have broken if the
added latency had swallowed a commit.

#### Result (RUN 2026-11-20_10-15-33 vs 2026-11-20_09-48-17)

| | hold WS | hold viol | setup WS | setup viol |
| --- | --- | --- | --- | --- |
| before | +0.1776 / +0.3125 / +0.1015 | 0 | -0.3168 / -2.1531 / +0.1305 | 8 / 59 / 0 |
| after | **+0.1990 / +0.3410 / +0.1138** | **0** | **-0.2108 / -2.1122 / +0.1959** | 9 / **57** / 0 |

Every corner's hold and setup worst slack improves.  SS per group:

| group | before | after |
| --- | --- | --- |
| **OUT** | 41 / -1.0947 | **40 / -0.9026** |
| **MID_OUT** | 9 / -0.3790 | **7 / -0.1949** |
| DSM_CK_G_CLK | 9 / -2.1531 | 10 / -2.1122 |
| TNS | -34.714 | -36.909 |

Two caveats stated plainly: TT violators went 8 -> 9 and total TNS moved
-34.714 -> -36.909, because `DSM_CK_G_CLK` gained one violator (9 -> 10) even
though its worst slack improved.  The OUT and MID_OUT groups -- the ones this
change targets -- both improved in count and in worst slack.

#### Where OUT stands now

40 violators, worst -0.9026, down from 54/-1.2334 at B14-FIX.  The remaining
paths are no longer dominated by any single shared cone (the ratio select and
the pre-decode are both registered), so the next step is a real pipelining or
retiming decision rather than another register.

### B25. OUT 53 -> 41 violators by registering the ratio-change select

B23 measured OUT's worst path as `_4450_` (`div.cnt[1]`) -> `_4466_`
(`div.high_count[1]`), and 36 of the 53 violators shared that startpoint.  The
cone between them:

```verilog
wire div_for_counts_is_pend = (!use_clk_p && leave_req) || apply_pend;
wire high_count_pend = div_for_counts_is_pend ? hi_pend : hi_cur;
wire low_count_pend  = div_for_counts_is_pend ? lo_pend : lo_cur;
```

Both mux arms come from `half_hi()`/`half_lo()` barrel shifters, so a
combinational select fanned into two 12-bit muxes sat directly on
`high_count`'s D input.  Both arms are registered (`div`, `div_pend`) and the
block's own comment says they are "stable well before the select resolves", so
the select is what can move into a flop.

Applied: one register on `div_for_counts_is_pend`, costing one OUT cycle of
latency on a *ratio change* (SET_DIV commits only).

#### Functional

`divider_duty_tb` PASS with exact `50.00 %` for every divisor 2..15, and the
stricter +-1 % bench also 50.00 % on 1/3/5/7/9/11/13/15.

#### Result (RUN 2026-11-20_09-48-17 vs 2026-11-20_09-19-04, SS per group)

| group | before | after |
| --- | --- | --- |
| **OUT** | **53 / -1.0517** | **41 / -1.0947** |
| DSM_CK_G_CLK | 9 / -2.0840 | 9 / -2.1531 |
| MID_OUT | 9 / -0.3612 | 9 / -0.3790 |
| NE_CLK_6x | 5 violators | **0** |
| **TOTAL** | **71** | **59** |
| **TNS** | **-51.438** | **-34.714** (-32 %) |

Corner summary: hold `+0.1776 / +0.3125 / +0.1015` with **0 violators at all
three**; setup `-0.3168 (8) / -2.1531 (59) / +0.1305 (0)`.  TT violators 9 -> 8.

Stated plainly: the violator count and TNS improved a lot, while the SS *worst*
slack moved slightly the other way (-2.0840 -> -2.1531) and OUT's worst from
-1.0517 to -1.0947.  That is the usual shape when a shared cone is pipelined --
the many paths through it get much better and the single deepest one gets one
register of latency.  DSM_CK_G_CLK remains the worst single path either way.

#### Remaining OUT shape

41 violators, worst -1.0947, and the group is now dominated by logic depth
rather than the ratio-change cone.  Next lever on this group would be the
`half_hi`/`half_lo` shifters themselves (compute both halves one cycle ahead
instead of in the cycle that consumes them).

### B24. DRC and LVS refreshed against the current netlist

Both had been skipped since the RTL changes began (B16/B19 were measured on
`RUN_2026-11-19_23-01-46`).  Re-ran them on `RUN_2026-11-20_09-19-04`.

#### KLayout DRC (IHP deck, direct invocation)

```text
exit 0, 19,732,746 byte report
items            69,578   (was 69,631)
  PLL_ANALOG_MACRO 69,018
  pll_macro_top       560   (was 574)
real violations   5,525   (was 5,578)
  in the macro    4,965   (was 5,004)
  top level         560   (was 574)
```

So none of the RTL work (negedge declaration, the `conf_div` p_hi change, the
`delta_sigma` carry registers, the DCO_EN synchroniser) introduced a DRC
violation; the top level improved by 14 and the macro is unchanged apart from
noise.  99 % of the real violations remain inside `PLL_ANALOG_MACRO`, which is a
layout problem of the macro on its own, not of this flow.

#### netgen LVS (OpenROAD-extracted CDL)

`scripts/lvs_openroad.sh` had a real bug found while re-running it: it accepted a
relative run directory and then passed `$RUN/final/nl/...` into the container,
where the relative path resolves against `/grid`, so netgen read the wrong
netlist and reported `(no matching pin)` for every port.  Fixed with
`RUN=$(cd ... && pwd)`.

Refreshed result on the current netlist:

```text
classes compared  38
with a delta       0
devices            2694 vs 2694
equivalent verdicts 77
```

Two further exclusions were needed and are documented in the setup file:
`sg13g2_buf_1` (1 in the CDL vs 327 in the netlist -- the input/repair buffers
synthesis added, which the logical CDL view does not carry) and `sg13g2_tielo`
(1 vs 2, the second driving an unnamed net).  The class count moved 39 -> 38
because `buf_1` left the comparison.

`Top level cell failed pin matching` still prints: that is the bus-spelling
difference recorded in B19 (`FCW[0..7]` in the CDL vs `FCW` in the Verilog), not
a connectivity failure -- every device class matches exactly.

### B23. Remaining OUT budget: half clock tree, half logic

The 53 OUT violators after B22 are all full-period now.  Decomposing the worst
one (`_4518_` = `pll_dig.div.cnt[1]` -> `_4291_`):

```text
clock-tree delay   0.9424 ns   (6 stages)
data delay         2.8307 ns   (16 stages)
                  ________
data arrival       3.3740 ns
data required      2.5582 ns    (2.5 period - 0.25 uncertainty + margin)
slack             -0.8158 ns
```

So the clock tree eats **38 % of the period**, and that tree is visibly two
cascaded trees rather than one:

```text
clkbuf_regs_1_OUT/A   -> .X     0.1953 ns   <- the macro OUT buffer
clkbuf_0_net59_regs   -> .X     0.1389
clkbuf_4_10_net59_regs-> .X     0.1448
                      ... repeated for the capture side as well
```

`OUT` is the macro's output pin, so `clkbuf_regs_1_OUT` is a buffer the flow
added after the macro, and `clkbuf_0_net59_regs` + `clkbuf_4_10_net59_regs`
are the CTS tree hanging off it.  Same shape as the `MID_OUT -> DSM_CK_G` double
tree already noted in B10.

Two levers, in order of cost:

1. **Collapse the two trees** (CTS could treat `OUT` as the clock root and build
   one tree, saving a stage or two, ~0.2-0.3 ns).
2. **Pipeline the divider's compare** -- the 16 data stages.  Same treatment
   `FILTER_DEC` got in the DSM (register the decode output), which is the
   pattern that has worked twice in this design.

Neither is an SDC change, so this is where the OUT group stops being a
constraint problem and becomes floorplan/logic work.

### B22. OUT now captures on a full period -- SS setup 79 -> 75, all corners better

B20 showed the OUT group's worst path captured on the 1.25 ns edge, because its
endpoint `_4468_` (`pll_dig.div.p_hi`) is registered on the negative edge.  The
odd divider's dual-edge construction exists only to get 50 % duty, and that only
requires the two halves to agree -- so `p_hi` can run on the rising edge while
the k+0.5 offset still comes from the negedge half (`ncnt`/`n_hi`).

One `always` block changed: `p_hi` negedge -> posedge.

#### Duty is unchanged

`divider_duty_tb`: exact `50.00 %` for every divisor 2..15, PASS.  A stricter
bench written for this change (+-1 % instead of the official +-5 %, measuring
`out` directly) also gives `50.00 %` on 1/3/5/7/9/11/13/15.

Note the official bench is insensitive to this: even moving *both* counters to
the rising edge still reports 50.00 % PASS, so it cannot be used to validate
the change on its own.  The stricter bench and the STA capture edge are what
actually confirm it.

#### Result (RUN 2026-11-20_08-28-19 vs 2026-11-20_07-19-47)

| | hold WS | hold viol | setup WS | setup viol |
| --- | --- | --- | --- | --- |
| before | +0.1855 / +0.3187 / +0.1055 | 0 | -0.4193 / **-2.6245** / +0.0880 | 9 / **79** / 0 |
| after | +0.1883 / +0.3236 / +0.1066 | 0 | -0.3326 / **-2.5164** / **+0.1141** | 9 / **75** / 0 |

Every number improves or holds.  Per group at SS:

| group | before | after |
| --- | --- | --- |
| OUT | 54 / -1.2334 | **53 / -1.1005** |
| MID_OUT | 10 / -0.2296 | **7 / -0.3340** |
| NE_CLK_6x | 5 violators | **1** |
| DSM_CK_G_CLK | 11 / -2.6245 | 13 / **-2.5164** |

#### The structural proof

The worst remaining OUT path now reads

```text
capture edge    2.5000   (was 1.2500)
data required   2.5582
data arrival    3.3740   (22 stages)
slack          -0.8158
```

so the remaining deficit there is pure logic depth, not a half-period penalty.
Only 1 of 54 OUT violators disappeared, which is expected: the half-period
endpoint was one of several, and the rest are `cnt[1]`/`pcnt[0]`/`div[3]`
paths that were always on the rising edge.

#### Still open in OUT

`_4518_` (`div.cnt[1]`) starts 36 of the remaining 53.  Those paths are now
full-period and 22 stages deep, so the next lever is logic depth (pipeline the
divider's compare, as was done for `FILTER_DEC` in the DSM) rather than clocking.

### B21. The last 2 unclocked pins: physically connected, and attaching them costs hold

B20 established that `net59_regs` (the tree `pll_dig.div` is clocked from) is
connected.  The same is true for the two remaining unclocked pins.

#### They are not floating

`_4703_`/`_4705_` are the `(* ASYNC_REG *)` LOCKED synchroniser of B12, clocked
from `clknet_1_*_leaf_pll_dig.dsm_impl.DSM_CK_regs`.  Following that tree:

```verilog
sg13g2_buf_16 clkbuf_0_...DSM_CK_regs (.X(clknet_0_...DSM_CK_regs),
                                       .A(pll_dig.dsm_impl.DSM_CK_regs));
sg13g2_buf_16 clkbuf_regs_3_DSM_CK_CLK (.X(pll_dig.dsm_impl.DSM_CK_regs),
                                        .A(pll_dig.dsm_impl.DSM_CK));
```

i.e. `<divider output DSM_CK>` -> `clkbuf_regs_3` -> `DSM_CK_regs` -> CTS ->
the two flops.  Exactly the shape of `net59_regs` (B20).  So the geometry is
fine; STA simply had no clock object covering the `DSM_CK_regs` half, because
`_genclk_on_net` takes `lindex 0` of the matching nets and `*pll_dig.dsm_impl.DSM_CK`
matches both `DSM_CK` and `DSM_CK_regs`.

#### Attempted fix, and why it was reverted

Made `_genclk_on_net` declare a clock on *every* distinct driver (suffixing
`_1`, `_2`, the same shape the negedge helper uses).  It parses, runs, and
STAPrePNR still shows 100 clocks with `DSM_CK_CLK` correctly not split into 13.
Full flow result:

| | hold WS | hold viol | setup WS | setup viol |
| --- | --- | --- | --- | --- |
| before (07-19-47) | **+0.1855 / +0.3187 / +0.1055** | **0** | -0.4193 / -2.6245 / +0.0880 | 9 / 79 / 0 |
| after | **-0.2942 / -0.4327 / -0.2168** | **1** | -0.3837 / -2.6310 / +0.1113 | 9 / 79 / 0 |

Attaching the two flops creates a hold violation on the path into them instead
of removing a blind spot, and setup does not improve.  Reverted.

#### Reading

Two flops out of 537 were not timed, they are the first stage of an
`ASYNC_REG` synchroniser (so there is no data path to close through them), and
making them visible costs a hold violation.  The value is in the *record*, not
in the change: the undriven-looking `DSM_CK_regs` of B12/B17 is in fact driven
by the divider output, so there is no missing clock tree to repair.  Anyone
re-attempting this should know both facts before spending another run on it.

If the 2 pins must be zero, the clean route is the same as the OUT group in
B20: give the LOCKED synchroniser a full-period capture (both stages on the
rising edge) rather than splitting the clock object.

### B20. Where the 79 SS setup violators actually are

Now that the NE_CLK paths are visible, attributed `RUN_2026-11-20_07-19-47`
(`nom_ss_125C_1v08`) by path group:

```text
group              n     worst       tns
  DSM_CK_G_CLK    11   -2.6245   -16.500
  OUT             54   -1.2334   -36.091
  NE_CLK_61        1   -0.3871    -0.387
  MID_OUT         10   -0.2296    -1.284
  NE_CLK_66        1   -0.0965    -0.097
  NE_CLK_59        1   -0.0349    -0.035
  NE_CLK_37        1   -0.0285    -0.029
  TOTAL           79
```

So the negedge declarations contribute only 3 violators of 79.  The earlier
expectation that they accounted for OUT's 53 was wrong, and this confirms it
with the full breakdown.

#### OUT (54) is an architectural half-period problem, not slack

Within OUT the violators are concentrated: 36 of 54 share the startpoint
`_4470_` (`pll_dig.div.cnt[1]`), 8 share `_4300_` (`div[2]`), 8 share
`_4477_` (`pcnt[0]`).

The budget of the worst path:

```text
capture edge          1.2500 ns      <- HALF the 2.5 ns period
clock uncertainty    -0.2500
library setup        -0.1888
                     ________
data required         1.4255 ns
data arrival          2.6589 ns      (19 stages, 13 of them data)
slack                -1.2334 ns
```

`capture edge 1.25` means the endpoint captures on the **negative** edge --
`_4468_` is `pll_dig.div.p_hi`, one half of `conf_div`'s dual-edge odd divider:

```verilog
always @(negedge clk) p_hi <= odd_div && (pcnt < odd_k);
always @(posedge clk) n_hi <= odd_div && (ncnt < odd_k);
wire odd_out = odd_div && (p_hi | n_hi);
```

24 of the 54 OUT violators capture on the 1.25 ns edge (the rest are
`div[2]`/`pcnt` paths that also show a 1.25 ns capture).  So OUT is short of
time because half the registers in that domain get **half a period**, not
because the logic is deep: 13 data stages is modest.

Closing OUT needs one of:

1. **Give the divider a full-period capture.**  The `p_hi | n_hi` OR only needs
   the two halves to agree on 50 % duty; both could be registered on the rising
   edge from the already-available counters (`pcnt` for one, `ncnt` sampled one
   cycle later for the other) so the whole domain runs on one edge.  This is
   the same shape of change already made to `frequency_counter_frontend` in
   B12, which worked.
2. **Relax OUT** to a 5 ns constraint if the divider is not meant to run at
   400 MHz.  That is a spec question, not a fix.
3. Accept it and report OUT as the known gap.

#### DSM_CK_G_CLK (11) is the adder, unchanged

Same cause already documented in B10: 38 logic levels against a 5 ns budget.
Independent of the negedge work.

#### The 2 unclocked pins are NOT this tree

`net59_regs` (the `_regs` CTS tree that `_4470_` is clocked from) is connected:
`clkbuf_0_net59_regs.A <- net59_regs <- clkbuf_regs_1_OUT <- OUT`, and `OUT` is
the macro's output pin.  Those registers are timed (`net59_regs` appears 2065
times in `max.rpt`).  The 2 remaining unclocked pins are `_4703_`/`_4705_`, the
`(* ASYNC_REG *)` LOCKED synchroniser of B12, which is a separate issue.

### B14-FIX. CLOSED: 89 negedge flops timed, hold back to 0 violations

B14 found 89 flops clocked through an inverter (`always @(negedge clk)` becomes
`INV(clk) -> flop CLK`), none in any clock group.  They are now timed by
default and the hold violation that this exposed is closed -- in RTL, not in
the SDC.

#### The declaration (four corrections, each measured)

1. `-invert` alone is rejected (`Error 388: missing -multiply_by, -divide_by,
   -combinational or -edges`); `-divide_by 1 -invert` is the right form.
2. A net-name list is stage-dependent (pre-CTS `_0202_`, post-CTS `net264`), so
   a hardcoded list matched 0 nets.  The scan is structural.
3. `-source` must be the clock root; one pin upstream landed on another
   inverter's `Y`.
4. Post-CTS the inverter input is a CTS leaf (`clknet_4_13_0_INJ_EDGE`), so an
   exact match found nothing (`inv=89 src=0`); substring match, longest name
   first, fixes it.

```text
post-PnR: adpll.sdc: NE_CLK diag clkpin=537 drv=537 inv=89 src=78 made=78
waveform: INJ_EDGE 0/10    NE_CLK_1 10/20 (generated)   <- correct opposite phase
```

#### The DCO_EN crossing (closed in RTL)

`delta_sigma` uses `EN_DSM` only as a clock enable -- `else if (EN_DSM) dff_* <=
...` for six register groups, never into an adder -- driven from `DCO_EN`, which
is generated by a negedge register in the INJ_EDGE domain.  Declaring the
negedge clocks made it a timed cross-domain path:

```text
_4240_/Q -> fanout116 -> _2425_/A1 -> _2425_/Y -> _4316_/D    hold -0.4039
```

Six SDC exemption forms were tried; **none moved it** (asynchronous grouping,
driver only, driver+sink -0.3986, plain `-from`/`-to` which resolved to
anonymous pins, hierarchical globs which did apply to the reported endpoints,
and reordering the exemption to run after the clocks exist).  The reason is
structural: `_4316_/D` is reached from `_2425_/A2` and `_2425_/B1` as well, so
exempting one cone leaves another.

Fixed in RTL instead, mirroring how `LOCKED` is already synchronised there:

```verilog
(* ASYNC_REG = "TRUE" *) reg dco_en_dsm_s1, dco_en_dsm_s2;
always @(posedge DSM_CK_G or negedge RST_N) begin
    if (!RST_N) begin dco_en_dsm_s1 <= 1'b1; dco_en_dsm_s2 <= 1'b1; end
    else begin dco_en_dsm_s1 <= DCO_EN; dco_en_dsm_s2 <= dco_en_dsm_s1; end
end
wire DCO_EN_DSM = dco_en_dsm_s2;
...
.EN_DSM(DCO_EN_DSM),
```

`EN_DSM` is a level, so delaying it by two `DSM_CK_G` periods only postpones the
noise-shaping start -- irrelevant at a ~1 MHz loop bandwidth.  Reset releases
the enable to 1 so the DSM is not held off during reset.

Functional check: `delta_sigma_tb` passes for all three orders with exact
averages (`Average = 24.0625, Intended average = 24.0625`, diff ~1e-14), and
`lock_fsm_tb` fails exactly the same four cases it failed on the baseline (B13),
so no regression was introduced.

#### Result -- the signoff numbers now improve instead of regressing

| state | corner | hold WS | hold viol | setup WS | setup viol |
| --- | --- | --- | --- | --- | --- |
| NE_CLK off (previous) | TT | +0.2030 | 0 | -0.4091 | 9 |
| | SS | +0.3470 | 0 | -2.3466 | 73 |
| | FF | +0.1163 | 0 | +0.0692 | 0 |
| NE_CLK on, unsynced | TT | **-0.4039** | **1** | -0.4034 | 9 |
| | SS | **-0.5901** | **1** | -2.3155 | 87 |
| | FF | **-0.2932** | **1** | +0.0740 | 0 |
| **NE_CLK on + 2FF sync** | TT | **+0.1855** | **0** | -0.4193 | 9 |
| | SS | **+0.3187** | **0** | -2.6245 | **79** |
| | FF | **+0.1055** | **0** | +0.0880 | 0 |

Hold is clean again at every corner **while 78 NE_CLK clocks stay timed** (was
0), and FF setup improves from +0.0692 to +0.0880.

Cost, stated plainly: SS setup violators go 73 -> 79 and SS setup WS -2.3466 ->
-2.6245.  Those paths were always there and were simply invisible before; the
net effect is that the reported numbers now describe the design that will be
manufactured rather than a subset of it.

`ADPLL_DECLARE_NEGEDGE_CLOCKS=0` still selects the old 11-clock view.

### B14. 93 flops are clocked through an inverter and fell out of their clock group

Found while breaking down the remaining SS setup violations by path group:

```text
group                      n     worst        tns
  DSM_CK_G_CLK            10   -2.3466    -13.588
  OUT                     53   -1.2274    -33.135
  MID_OUT                 10   -0.2734     -1.604
```

`OUT` holds 53 of 73, and its worst path ended at
`_4469_ (flip-flop clocked by OUT')` -- the prime being STA's marker for an
endpoint it cannot attach to a known clock.

Tracing `_4469_` in the routed netlist:

```verilog
sg13g2_dfrbpq_1 _4469_ (.D(_0043_), .Q(pll_dig.div.ncnt[6]), .CLK(net269));
sg13g2_inv_1 _3769__270 (.Y(net269), .A(clknet_4_13_0_net59_regs));
```

So the flop is clocked by `INV(clk)`.  This is how `always @(negedge clk)` is
implemented after synthesis, and nothing declared those inverted nets as
clocks.  A scan of the netlist found **93 inverter outputs driving a flop
clock**:

| domain | count | example |
| --- | --- | --- |
| INJ_EDGE | ~70 | `_0153_` .. `_0245_` |
| OUT_DIV (`pll_dig.div`) | 9 | `net260` .. `net269` |
| MID_OUT | 1 | `net259` |
| net60_regs | 1 | `net272` |

`_4469_` is `pll_dig.div.ncnt[6]`, i.e. the negedge half of the odd-divider's
dual counter in `conf_div.v`:

```verilog
always @(posedge clk ...) pcnt <= ...;
always @(negedge clk ...) ncnt <= ...;
```

So the very counter that produces the 50 % odd-duty output is half outside its
own timing group.  For a divider whose whole purpose is exact duty cycle, that
is a signoff hole, not a reporting artifact.

Fix attempted: declare these as generated clocks on the inverter outputs with
`-invert` (OpenSTA supports it), sourced from the real master clock:

```tcl
create_generated_clock -name $cname -source $master -invert $inv_pin
```

Only pins that actually drive a register clock are picked, so the 240 inverters
in the netlist do not each become a clock.  This is a live experiment at the
time of writing -- the numbers below do not include it yet, and the risk is the
same one that bit the CTS-tolerance attempt in B12: too many clock objects
splitting one domain into asynchronous pieces.  Any result must be checked by
looking at the clock count and the violator-per-group table, not just the WNS.

### B13. Pre-existing: `lock_fsm_tb` does not pass, and did not before

While checking that the B12 change to `frequency_counter_frontend` did not
regress the lock FSM, `lock_fsm_tb` was found failing:

```text
FAIL: relock after stuck low LOCKED=0 expected=1 state=2
FATAL: src/lock_fsm_tb.v:258: lock_fsm_tb failed
```

Reverting `frequency_counter_frontend` to its pre-B12 content and re-running the
same test did **not** fix it -- the failures changed but remained:

```text
FAIL: locked before ref loss LOCKED=0 expected=1 state=3
FAIL: relock after stuck high LOCKED=0 expected=1 state=1
FAIL: dco stuck low LOCKED=1 expected=0 state=3
```

So the test is not a reliable gate today: it fails with and without the change,
and the failing set is not stable between runs.  Two possibilities, neither
investigated yet: the TB's stimulus/timing assumptions drifted from
`lock_detector`/`ref_watchdog` behaviour, or the TB has a race.

What *is* verified: `frequency_counter_frontend_tb` covers the B12 change
directly and passes unchanged (`sync=20 ps2=20 ripple=236 johnson=20`), and the
PnR flow confirms the structural outcome (33 -> 2 unclocked pins).

This matters for signoff because `lock_fsm_tb` is the only test that exercises
the acquisition/relock FSM at RTL.  It should be repaired before anyone relies
on it as evidence that a future change to the FSM is safe.

### B12. CTS left divided-clock trees undriven -- FIXED by gating the enable

CTS created `<name>_regs` load trees whose root net has no driver, so the flops
clocked from them were invisible to STA (`checks.rpt`: 33 unclocked pins; those
clock names report 0 endpoints in `max.rpt` while `OUT`/`REF`/`REF_G_CLK` report
271/336/100).

#### Evidence that it was the tree, not the constraint

```verilog
// connected:
sg13g2_buf_16 clkbuf_0_..._clk_div      (.X(clknet_0_..._clk_div),
                                         .A(..._clk_div));        // <- driven
// not connected:
sg13g2_buf_16 clkbuf_0_..._clk_div_regs (.X(clknet_0_..._clk_div_regs),
                                         .A(..._clk_div_regs));   // <- no driver
```

`..._clk_div_regs` has no driver anywhere in the routed netlist; the source
register still drives `..._clk_div`.  `clk_div_regs` appears 0 times before
`35-openroad-cts` and 61 times after, which localises the break to CTS.

#### Fix (option 2, applied to the FLL front-end)

`frequency_counter_frontend` used a register output as a clock:

```verilog
always @(posedge clk_div) begin cnt <= cnt_inc; gray_q <= ...; end
```

It now clocks from `CLK` and gates the increment instead:

```verilog
wire cnt_en = (div_cnt == HALF - 1);
always @(posedge CLK) if (cnt_en) begin cnt <= cnt_inc; gray_q <= ...; end
```

Functionally equivalent: `div_cnt` wraps on exactly the edge where `clk_div`
would have risen, so the counter advances once per divided period with the same
phase.  `frequency_counter_frontend_tb` passes unchanged
(`sync=20 ps2=20 ripple=236 johnson=20`).

Measured effect on the full signoff flow:

| | before | after |
| --- | --- | --- |
| unclocked register/latch pins (post-PnR) | 33 | **2** |
| TT setup WS / viol | -0.5027 / 10 | **-0.4091 / 9** |
| SS setup WS / viol | -2.5391 / 67 | **-2.3466 / 73** |
| FF setup WS / viol | +0.0037 / 0 | **+0.0692 / 0** |
| hold WS TT/SS/FF | +0.2033/+0.3474/+0.1167 | +0.2030/+0.3470/+0.1163 |

Hold stays clean at every corner.

#### The last 2 (open)

`_4682_`/`_4684_` are the `(* ASYNC_REG *)` LOCKED synchroniser, clocked from
`clknet_1_*_leaf_pll_dig.dsm_impl.DSM_CK_regs` -- the same undriven-root pattern,
this time on the DSM divider output.  It cannot be fixed the same way: those two
flops must sample LOCKED *before* the ICG, otherwise the gate enable would
depend on a signal behind the gate (deadlock).  Options are the same as the
general case: stop CTS renaming `DSM_CK`, or accept a documented 2-flop
exception with an explicit `set_false_path` and a note that the hand-off is
synchroniser-only and checked by the RTL TB.

### B10. First complete IHP top PnR: three-corner timing, and the real setup gap

The full flow runs end to end.  Two RTL/SDC defects were found and fixed on the
way; what remains is a genuine architecture limit, not a flow problem.

#### Timing after both fixes (`RUN_2026-11-19_20-19-11`)

| Corner | Hold WS | Hold viol | Setup WS | Setup viol | Setup TNS |
| --- | --- | --- | --- | --- | --- |
| TT | +0.2033 | **0** | -0.5027 | 10 | -3.649 |
| SS | +0.3474 | **0** | -2.5391 | 67 | -45.065 |
| FF | +0.1167 | **0** | **+0.0037** | **0** | **0** |

FF closes.  Max cap, max slew, detailed-route and antenna checks are all zero at
every corner.  Area 307 910 um^2 (macro 16 800), 23 784 instances, 23.3 %
utilization, TT power ~11.5 mW, no unmapped instances.

Progression, same design, three runs:

| | TT setup WS | SS setup WS | FF setup WS | setup violators |
| --- | --- | --- | --- | --- |
| DSM clock at 2.5 ns (wrong) | -2.3824 | -5.0151 | -0.8209 | 36 / 96 / 7 |
| DSM clock at 5.0 ns (correct) | -0.5027 | -2.5391 | +0.0037 | 10 / 67 / 0 |

#### The remaining gap is the DSM adder depth

All corners violate on the same register pair (`_4252_ -> _4644_`, both
`DSM_CK_G_CLK`).  Decomposing the SS path (50 stages):

```text
logic data delay      7.868 ns   (38 levels)
clock tree            1.741 ns   (launch + capture, 12 stages)
--------------------------------
data arrival          8.419 ns
data required         5.880 ns   (one DSM_CK_G period = 5.0 ns, less setup/uncertainty)
slack                -2.539 ns
```

So even with the period corrected, 38 levels of DSM adder need 7.87 ns at SS
against a 5 ns budget.  No amount of resizing closes that: it needs either a
slower DSM clock (a real `DSM_DIV > 2`) or a pipelined adder.  That is an
architecture decision, so it is recorded rather than patched.

About 0.35 ns of the clock tree is avoidable: `MID_OUT -> clkbuf_0_MID_OUT ->
clkbuf_1_0 -> u_icg/GCLK -> clkbuf_0_DSM_CK_G -> clkbuf_4_x` is two cascaded
clock trees (MID_OUT's, then DSM_CK_G's), because the generated clock is a
separate root.  Worth a look if the gap ever comes down to a few hundred ps,
but it is not what is costing 2.5 ns.

#### Two defects fixed here

1. **`DSM_CK_G_CLK` was constrained at half its real period.**  The SDC
   derived it with `-divide_by 1` from the divider flop's Q, making it
   2.500 ns.  The divider is real (`_4277_`: D from counter logic, CLK =
   `clknet_1_0__leaf_MID_OUT`, Q = `pll_dig.dsm_impl.DSM_CK`) and `DSM_DIV`
   is 2, so the clock is `MID_OUT/2` = 5 ns.

2. **All four generated clocks were `Virtual: yes` with CTS-buffer sources.**
   They were anchored via `get_nets -quiet *<name>*` + `lindex 0`, and that
   wildcard also matches the CTS-inserted `clknet_0_*` / `clknet_4_*` nets, so
   after CTS it picked a mid-tree buffer.  Anchoring on the ICG's `GCLK` pin
   instead gives `Virtual: no` and the correct source:

   ```text
   REF_G_CLK     Sources: pll_dig.flock.u_fll_icg.u_icg/GCLK     Virtual: no  Period 20.0
   DSM_CK_G_CLK  Sources: pll_dig.dsm_impl.u_dsm_icg.u_icg/GCLK  Virtual: no  Period  5.0
   ```

   Fixing the anchor did not move the reported numbers (same placement), but it
   removed the bogus phase reference: before, the SS DSM path reported a data
   arrival and required time that straddled zero and made the report unreadable.

### B9. PnR hung in `STAPrePNR`: the IHP clock gate closed a loop in the clock graph -- FIXED

The signoff rerun never reached the three-corner numbers.  It hung in
`STAPrePNR` with three `sta` processes at 100% CPU for 5 h 50 min and both
`sta.log` and `min.rpt` at 0 bytes.  It was not slow: the same step takes 7 s.
The later `STAMidPNR` hung the same way (one `openroad`, 99.9% CPU, ~200 s of
CPU in 200 s of wall time, single-threaded, `stime` 0.2 s -- pure computation,
no I/O wait).

**Root cause.**  Commit `c087a46` built `PLL_CLKGATE` from `sg13g2_dllrq_1`
(latch) plus an AND -- the textbook `latch_negedge_postcontrol` gate -- to
remove a clock-gating hold check.  But the sg13g2 Liberty models that latch
with a **`GATE_N -> Q` `falling_edge` arc**, which makes `GATE_N` a *clock* pin
to STA.  Wiring `GATE_N` to `CLK` and then ANDing `CLK` with the latch output
closes a loop in the clock graph:

```text
CLK -> GATE_N(latch) -> Q -> AND(CLK, Q) -> GCLK
```

OpenSTA's path search does not terminate on that loop.  It is not a
combinational data loop -- a structural cycle check on both netlists finds
zero cycles, and `set_false_path -from <latch Q>` does not help, because the
loop is formed while the *clock* graph is built.

**Isolation evidence**, all by single-variable replay with the real
`corner.tcl`, real `_env*.tcl` and real PDK libs:

| change | result |
| --- | --- |
| old netlist (no `dllrq`) | completes, 0.8 s, writes SDF |
| new netlist (2x `dllrq`) | hangs in the first `report_checks` |
| new netlist, `SS_BBPD` arc stripped | still hangs -- the arc is not the cause |
| old ODB + ODB-branch `report_checks` | 253 ms |
| new ODB + ODB-branch `report_checks` | hangs |
| new ODB, disconnect the 2 latch `Q` outputs | **220 ms** |
| new ODB, `set_false_path -from <latch Q>` | still hangs |

The cell histogram was what pointed at it: `sg13g2_dllrq_1` is the only cell
type present in the new netlist and absent from the old one.

Ruled out along the way, each by measurement: the `SS_BBPD` clock-to-Q arc,
the per-corner macro Libs, the number of corners, the number of clocks (the
successful run also had all eight), parasitics (SPEFs are empty at that step),
the CDC hold exemptions (93 sinks on both), and the design size (2523 -> 2667
cells, 541 registers, 8 clocks).

**Fix.**  Use the library's real ICG cell, `sg13g2_lgcp_1`, in the
`PLL_USE_IHP_ICG` branch of `PLL_CLKGATE`.  It is modelled correctly for this
use: `GCLK` carries no edge arc at all, and `GATE` only has setup/hold against
`CLK`, so no clock-graph loop can form.  The ORFS library marks it
`dont_use : true` and lists it in `synth_exclude.cells` / `pnr_exclude.cells`;
both were lifted, because a design that actually needs a clock gate cannot
honour a blanket `dont_use`:

- `build/.../sg13g2_stdcell/lib/enable_lgcp.py` clears `dont_use` on
  `sg13g2_lgcp_1` only, in every corner Lib, idempotently;
- `sg13g2_lgcp_1` removed from `synth_exclude.cells` and `pnr_exclude.cells`.

### B8. Known open DCO tuning defect

`flow/PERFORMANCE.md` records 15 non-monotonic fine steps in the IHP fine
bank.  A non-monotonic DCO code is a functional risk: the frequency lock loop
can fail to converge at those codes.  This is unresolved.

### B9. FIB/ECO and metal fill not verified against the foundry deck

The ring DCO used "flow-generated legal fill" with the official density deck.
`PLL_ANALOG_MACRO` fill status was not re-checked in this assessment.

## 2.5 Step 1 progress: the top now elaborates

B1 is partially closed.  What was needed, and what is still open:

| Change | Why |
|---|---|
| copied `PLL_ANALOG_MACRO.{lef,lib,gds,v}` into `hardmacro/` as `PLL_ANALOG.{lef,lib,gds}` + `PLL_ANALOG_MACRO.v` | the top config's `dir::hardmacro/...` paths did not exist |
| `MACROS` key renamed `PLL_ANALOG` -> `PLL_ANALOG_MACRO` | the LEF macro name and the Liberty cell name are both `PLL_ANALOG_MACRO` |
| `MACROS.*.lib` changed from a path to a per-corner dict | v3.0.16 rejects a bare string ("Refusing to automatically convert string ... to dict") |
| top switched from `src/pll.v` to `src/pll_macro_top.v` | `pll.v` instantiates the behavioural `PLL_ANALOG`; only `pll_macro_top` binds `PLL_ANALOG_MACRO` |
| `DESIGN_NAME` `pll` -> `pll_macro_top` | matches the actual top module |
| `VERILOG_DEFINES: [POSTSYN]` | the routed macro netlist has parameters baked in; without it Yosys fails with "Parameter not found: IL_NDELS" |
| `pll_macro_top.v`: parameter list gated on `POSTSYN` | same reason |
| added `frequency_counter_frontend.v`, `ref_watchdog.v`, `lock_detector.v`, `ddr_ck.v` | the top instantiates them; they were missing from `VERILOG_FILES` |
| `LIB`/`RCX_RULESETS` `/opt/...` -> `/shared/...` | `/opt/OpenROAD-flow-scripts` does not exist here |
| `assemble_pdk_root.sh` re-run with `ORFS_PLATFORM=/shared/...` | its default `/opt` path left the PDK root without `libs.tech/librelane`, so LibreLane could not find the PDK |
| `PDN_MACRO_CONNECTIONS: ["pll_ana VDD VSS VDD VSS"]` enabled | without it PDN fails with PDN-0235 (unplaced macros), then PDN-0179 |
| macro placed at die corner, `DIE_AREA` sized to the macro | the macro's Metal2 OBS is fragmented; a mid-die placement left no repairable Metal1 channel (PDN-0178 at x=5.76..9.6) |

Verified: Yosys elaborates `pll_macro_top` with `PLL_ANALOG_MACRO` instantiated
(`hierarchy -check` passes), and the LibreLane flow now gets past PDN,
tap/endcap, placement and CTS.

**Step 1 result: the top is assembled and reaches post-PnR STA.**
`RUN_2026-11-18_17-29-18` completed synth -> floorplan -> place -> CTS ->
global route -> detailed route -> antenna (0 net/0 pin violations) -> RCX ->
post-PnR STA.  This is the first time the digital control and the analog macro
exist in one netlist.

Congestion took three attempts to clear; the cause was pin access, not area:

* 260 x 200 um die, macro at (0,0) -> GRT-0116 congestion.
* 400 x 300 um, lower density, macro at (0,0) -> still GRT-0116.
* Macro at (40,40) -> routes clean.  30 of the macro's 71 pins sit on the LEF's
  left edge and 37 on the right edge, so at (0,0) half the pins landed on the
  die boundary with no access.

Placed result (`nom_ss_125C_1v08`):

```text
instances            22900        die area      329584 um2
instance area       298090 um2    macros             1 / 16800 um2
utilization          22.5%        power (TT)     9.5 mW
hold WNS           +0.0000        max_slew/cap   0 / 0
setup WNS          -1.0090        setup TNS     -23.28 ns, 37 paths
```

The single worst path is `_3955_ -> OUT_DIV[output port clocked by OUT]`,
i.e. the same SDC modelling bug already fixed for ics55: OUT_DIV and CK are
divided *clock* outputs but were constrained with `set_output_delay`.  The IHP
SDC has now been synced with the three ics55 fixes (OUT_DIV/CK as
generated clocks, `SET_DIV`/`LOAD_DIV` as static straps, CDC hold exemption).
Verified locally: SDC OK with 8 clocks (REF, OUT, MID_OUT, INJ_EDGE,
REF_G_CLK, DSM_CK_G_CLK, OUT_DIV_CLK, CK_CLK).

A rerun with the corrected SDC is required before quoting an IHP top-level
setup number.

Not yet done at this level: macro SPEF/SDF (B3), multi-corner macro Liberty
(B4, SS/FF currently reuse the TT macro Liberty and are therefore not
macro-valid), the SS_BBPD sampling arc (B2), and full-chip DRC/LVS (B6).

## 2.6 Corrected-SDC rerun result

`RUN_2026-11-18_18-14-45` reran the top with the synced SDC (OUT_DIV/CK as
generated clocks, SET_DIV/LOAD_DIV as static straps, CDC hold exemption) and
with the new per-corner macro Liberty.

| corner | Hold WNS | Setup WNS | Setup TNS | max_slew | max_cap |
|---|---:|---:|---:|---:|---:|
| TT 1.20 V/25 C | -0.0349 | -3.1034 | -97.85 | 0 | 0 |
| SS 1.08 V/125 C | -0.0063 | -6.1426 | -246.96 | 0 | 0 |
| FF 1.32 V/-40 C | -0.0461 | -1.2775 | -35.16 | 0 | 0 |

Before the SDC fix the SS worst path was `_3955_ -> OUT_DIV[output port]` at
-1.0090 ns.  That path is gone: OUT_DIV is now a generated clock and is no
longer timed as a data endpoint.  max_slew and max_cap violations are 0 at all
three corners (they were 2 and 2).

What remains, and it is not SDC modelling:

**A. DSM domain setup: -6.14 ns (SS), 101 of the 181 paths.**
`pll_dig.dsm_impl.dsm.dff_err3[11] -> pll_dig.FINE_MUX_D[14]`, both on
`clknet_*_pll_dig.dsm_impl.DSM_CK_G`.  This is the DSM error-feedback adder
chain reaching the FINE_MUX register inside one DSM_CK period.  It is the same
gap recorded in flow/PnR_OPTIMIZATION.md section 8.46 and gap B5 here: the
domain was never checked before because `DSM_CK_G` had no generated clock.
Closing it is an RTL change (pipeline the delta_sigma error feedback, or
narrow BITS_DSM, or register the FINE_MUX decode) -- not a PnR knob.

**B. A hold violation on the FLL clock gate: -0.0349 / -0.0063 / -0.0461 ns.**
`pll_dig.flock.u_fll_icg.en_l -> sg13g2_and2_1 -> pll_dig.flock.REF_G`, reported
as a clock-gating check.  This is a side effect of declaring `REF_G_CLK`:
without PLL_USE_ICS55_ICG the gate is a plain AND, so the tool now treats the
combined enable as a gating signal and checks it.  Two ways out: either map the
gate to the PDK clock-gating cell (needs the ics55-style parameter for IHP,
which does not exist yet), or accept the AND and pin the gate open for hold.
Both are single-digit-picosecond numbers, but they must not be silently
waived.

## 2.7 Per-corner STA with the real multi-corner macro Liberty

LibreLane's bundled `sta` could not finish this design: 22900 instances with
three *distinct* macro Liberty files per corner means nine library loads, and
the step ran >15 min per corner without emitting one log line.  It was not
hung (process state R, 25% CPU) but it was not usable either.

`flow/canary/ihp130_sg13g2_core_a/scripts/sta_per_corner.tcl` runs the same
checks through OpenROAD directly, one corner per invocation, so each has its
own timeout and log.  Results on `RUN_2026-11-18_18-14-45`:

| corner | hold worst | setup worst | notes |
|---|---:|---:|---|
| TT 1.20 V/25 C | +0.3805 | -2.5010 | `_4374_/Q -> _4417_/D` (DSM) |
| SS 1.08 V/125 C | +0.0240 | -5.1631 | same path, slow corner |
| FF 1.32 V/-40 C | +0.5925 | -0.8872 | same path, fast corner |

**Hold is positive at every corner**, including the FLL clock-gate check that
used to fail:

```text
_4253_/Q (u_fll_icg.en_l latch) -> _2206_/B (AND2) : +9.5972 / +9.5110 / +9.6472
```

The earlier -0.0349 / -0.0063 / -0.0461 ns on that path was the fallback DFF
feeding the AND.  With PLL_USE_IHP_ICG the enable is `sg13g2_dllrq_1`
(latch) and the check passes by ~9.5 ns at all corners, so the regression is
gone.

The remaining setup violation is one path at every corner:
`_4374_/Q -> _4417_/D`, both `sg13g2_dfrbpq_1` on the DSM clock.  It is the
delta_sigma error-feedback chain into FINE_MUX already described in 2.6/A and
B5 -- an RTL-level fix, not PnR.

### Note on the floorplan

Three macro placements were needed before routing would close:

| die | macro at | result |
|---|---|---|
| 260 x 200 | (0,0) | GRT-0116 congestion |
| 400 x 300 | (0,0) | GRT-0116 congestion |
| 400 x 300 | (40,40) | routes clean |

30 of the macro's 71 LEF pins are on its left edge and 37 on the right edge,
so at (0,0) more than half the pins sat on the die boundary with no access.
Area was never the limit (22.5% utilisation).

## 2.8 The remaining PnR rerun is host-bound, not flow-bound

Several reruns appeared to hang at `OpenROAD.STAPrePNR` with a zero-byte
`sta.log`.  It was not a flow defect and not the multi-corner library after
all:

```text
$ cat /proc/loadavg
43.44 45.28 42.46          # on an 8-core machine
$ top -bn1 | grep '^%Cpu'
%Cpu(s): 94.4 us, ... 0.0 id
$ ps -eo pid,pcpu,etime,comm --sort=-pcpu | head
 4184375  157 01:26:38 ngspice        <- not this project
 4181243  157 01:28:39 ngspice        <- not this project
   58602  133   19:45  ngspice        <- not this project
 3960178 30.4 08:20:04 yosys-abc
```

Three `ngspice` runs from another work area (`gf180_work/edram/...`,
`build/r2r_tran.spice`) hold ~450% CPU and an 8-hour `yosys-abc` holds another
30%.  With no idle core the bundled `sta` on a 22900-instance netlist makes
almost no progress, which is why every attempt stalled around 12/80.

Those processes are not this session's work, so they were left alone.  The
rerun is being retried at `nice -n 19` so it yields to them rather than
competing.

**Practical consequence**: the numbers in 2.6/2.7 come from the run that did
complete (`RUN_2026-11-18_18-14-45`) plus per-corner STA on its routed
netlist.  A fresh full PnR will take many hours on this host and cannot be
used as an iteration loop until the machine has capacity.

Two flow changes made to reduce the cost, both kept:

* `config.macro.yaml` now sets `LIB` to TT only.  LibreLane builds the STA
  `LIB` variable from that block, so listing SS/FF there forces three library
  loads per STA invocation regardless of `STA_CORNERS`; SS/FF are verified
  afterwards with `scripts/sta_per_corner.tcl`.
* `STA_CORNERS` is TT only for the same reason.

## 3. Minimum path to a shippable IHP top

Ordered so each step is verifiable before the next:

| # | Step | Verifiable by |
|---|---|---|
| 1 | Wire `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.*` into the top `hardmacro/` and make `config.macro.yaml` elaborate | LibreLane reaches floorplan |
| 2 | Add `SS_BBPD` setup/hold arcs vs `INJ_EDGE` to the macro Liberty (B2) | `report_checks -to <dlf flops>` shows real slack |
| 3 | RCX the macro, emit 3-corner Liberty/SDF (B3, B4) | three `.lib` files, STA annotates |
| 4 | Fix the digital block's undeclared clock domains and close it (B5) | 6 domains reported, 0 violations |
| 5 | Assemble the full top: digital + macro + IO ring | GDS with pads |
| 6 | Full-chip DRC (maximal + density), LVS without waivers, antenna | 0 violations, "netlists match" |
| 7 | IR/EM on the real PDN | within foundry limits |
| 8 | DCO/PLL phase noise + jitter measurement or simulation | spec sheet |
| 9 | Resolve the 15 non-monotonic fine steps (B8) | monotonic code→frequency |

Steps 1-3 are mechanical and unblock everything else.  Step 4 is the largest
engineering item.  Steps 8-9 are the ones that decide whether the PLL meets a
real specification rather than merely building.

## 4. What is genuinely ready

- The analog macro builds, places, routes, streams out, and passes macro-level
  DRC/LVS on official IHP decks.
- The IHP PDK, IO pads, SRAM macros and both DRC/LVS decks are installed.
- The digital control synthesizes and completes P&R on `sg13g2_stdcell`.

Everything above the macro boundary — integration, multi-corner macro timing,
full-chip signoff, and PLL-level noise — is not ready.

## 5. Reproduction commands

```sh
# macro views that already exist
ls -l flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.{gds,lef,lib,def,v}

# what the top config expects (currently missing)
ls -l flow/canary/ihp130_sg13g2_core_a/hardmacro/

# macro Liberty coverage
grep -c 'pin(' flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.lib      # 71
grep -c 'timing ()' flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.lib # 20
grep -c "SS_BBPD" flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.lib  # 5, capacitance only

# official macro signoff evidence
head -30 flow/macro/ring_dco_ihp130/OFFICIAL_SIGNOFF.md
```
