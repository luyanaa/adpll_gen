# gf180mcu 3.3 V + Core A canary

First canary for the ADPLL flow on **gf180mcu / `gf180mcu_as_sc_mcu7t3v3`
(3.3 V, 7-track) / Core A (IL-DCO)**.  It answers two questions:

1. Does the digital control (`pll_logic`) synthesize and map to the gf180
   standard-cell library?
2. Does a LibreLane 3.0.16 digital-only PnR flow run on this PDK checkout?

It also records the interface and LibreLane skeleton for the eventual full
`pll` top with a `PLL_ANALOG` hard macro.

Everything here is new and self-contained.  No file outside this directory was
modified; the PDK is read-only and is reached through canary-local symlinks.

## Status (exact)

| Item | Status |
|---|---|
| Yosys synthesis of `pll_logic` -> `gf180mcu_as_sc_mcu7t3v3` | **PASS** — 1690 cells, 49,069.31 um², TT / 3.3 V / 25 C, Yosys 0.52 |
| Full `pll` elaboration against `hardmacro/PLL_ANALOG_blackbox.v` | **PASS** — 1 `PLL_ANALOG` instance, no errors; not mapped (no macro Liberty) |
| LibreLane 3.0.16 digital-only flow | **PASS through 80/80 steps with documented skips** — run `RUN_2026-10-29_01-45-14`, exit 0, 8:12 |
| Floorplan / tap+endcap / PDN / placement / CTS / global+detailed route / fill | **REACHED** |
| OpenROAD detailed-route DRC | **0 errors** (`route__drc_errors = 0`, 363 -> 56 -> 22 -> 0); routing DRC only, not KLayout signoff |
| OpenROAD antenna check | **0 violating nets / 0 violating pins**; KLayout antenna deck **not run** |
| KLayout/Magic DRC, Netgen LVS | **N/A** — this PDK ships no decks; the steps were skipped |
| Post-PnR STA / RCX / IR drop | **NOT RUN** — no OpenRCX rules in the PDK; RCX and `OpenROAD.STAPostPNR` were skipped |
| GDS streamout | **NOT RUN** — no KLayout/Magic tech; no GDS was produced |
| `PLL_ANALOG` hard macro | **NOT BUILT** — no GDS/LEF/Liberty/CDL/SPICE |
| `config.macro.yaml` (full `pll` top) | **SKELETON ONLY — cannot run until the macro views exist** |
| Timing corners | 3 distinct Liberty files used, **cell-identical (107 cells each)**; 3 nominal PVT corners. The PDK's 9 corner *names* are aliases over the same 3 files; no independent min/max corners. |

**This is a PnR canary, not signoff.**  A green LibreLane exit code means the
flow completed with the signoff steps skipped; it does not mean DRC, LVS,
antenna or timing closure passed.

## Proven

### Yosys synthesis

`make synth-digital` runs:

```sh
yosys -s build/yosys/synth_digital.generated.ys
# source: scripts/synth_digital.ys
```

with these RTL files (the same list as the ics55 canary):

```text
src/pll_logic.v
src/digital_loop_filter.v
src/term_decoder.v
src/freq_lock.v
src/delta_sigma.v
src/fix_div.v
src/conf_div.v
```

and the TT Liberty
`/grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk/libs.ref/gf180mcu_as_sc_mcu7t3v3/lib/gf180mcu_as_sc_mcu7t3v3__tt_025C_3v30.lib`.

Result (see `build/yosys/stat.rpt` and `build/yosys/yosys.log`):

```text
Number of cells:                1690
  sequential:                    280   (dfsrtp_2 272, dfxtp_2 8)
  combinational:                1410
Chip area (Liberty area):       49069.3056 um^2
Sequential area:               22566.656  um^2 (45.99 %)
```

- 0 errors, 0 unmapped `$...` internal cells in the final netlist.
- 1690/1690 cells are `gf180mcu_as_sc_mcu7t3v3` library cells.
- `dfflibmap` uses `dfsrtp_2` for all async-reset flops.  That is the only
  async set/reset flop in the library (both `RN` and `SN`); the unused `SN` is
  tied high, which produces 272 `tieh_4` cells.  This is legal but not a
  low-power or scan-ready netlist.
- `dyn_dfxtp_2` is excluded with `dfflibmap -dont_use` to follow the PDK's
  `synth_exclude.cells`; the 8 non-reset flops map to `dfxtp_2`.
- The only log warning is a benign ABC message (`The network is
  combinational`).  The `unmapped dff cell` list from `dfflibmap` is
  informational: the design only uses the mapped `$_DFFSR_PNN_` and
  `$_DFF_P_` types.

### Full `pll` elaboration

The full top elaborates against the blackbox with no errors:

```sh
yosys -p 'read_verilog -sv src/pll.v; read_verilog -sv src/pll_logic.v; \
          read_verilog -sv src/digital_loop_filter.v; read_verilog -sv src/term_decoder.v; \
          read_verilog -sv src/freq_lock.v; read_verilog -sv src/delta_sigma.v; \
          read_verilog -sv src/fix_div.v; read_verilog -sv src/conf_div.v; \
          read_verilog -sv hardmacro/PLL_ANALOG_blackbox.v; \
          hierarchy -check -top pll'
```

It reports one `PLL_ANALOG` instance and the expected digital submodules.  It
was not mapped because there is no macro Liberty yet.

### LibreLane digital-only flow

`make librelane-digital` runs LibreLane 3.0.16 from the Nix store:

```text
/nix/store/ilpnqwsl6gvk6kvavkaljbnzaz3086fd-python3.13-librelane-3.0.16/bin/librelane
```

with the canary-local PDK overlay (see below):

```sh
librelane --manual-pdk --pdk-root pdk_overlay --pdk gf180mcu \
          --scl gf180mcu_as_sc_mcu7t3v3 \
          [--skip ...] config.digital.yaml
```

The successful run is `runs/RUN_2026-10-29_01-45-14/` (flow log
`runs/RUN_2026-10-29_01-45-14/flow.log`, driver log
`build/librelane_digital.log`).  It completed the Classic flow 80/80 in
8:12 with exit code 0.  `error.log` is empty.

What ran:

- Verilator lint (132 lint warnings, no errors)
- Yosys synthesis / JSON header
- OpenROAD floorplan, tap+endcap insertion, PDN generation
- Global placement, IO placement, detailed placement
- CTS, post-CTS resize, global routing, detailed routing
- Fill insertion, cell-frequency tables
- OpenROAD antenna checks, disconnected-pin check, wire-length report,
  routing DRC checker, manufacturability report

What was skipped (see `LIBRELANE_SKIP` and the run history below):

- `OpenROAD.RCX` — no OpenRCX `.rules` files exist in this PDK.
- `OpenROAD.STAPostPNR`, `OpenROAD.IRDropReport` — both require the SPEF that
  RCX would have produced.
- `Magic.StreamOut`, `KLayout.StreamOut`, `KLayout.Render`,
  `Magic.WriteLEF`, `Odb.CheckDesignAntennaProperties` — no Magic/KLayout
  tech; no GDS.
- `Magic.DRC`, `KLayout.DRC`, `Checker.MagicDRC`, `Checker.KLayoutDRC`,
  `Magic.SpiceExtraction`, `Netgen.LVS`, `Checker.LVS`, `KLayout.XOR`,
  `Checker.XOR` — no decks.
- Timing checkers (`Checker.SetupViolations`, `HoldViolations`,
  `MaxSlewViolations`, `MaxCapViolations`) — they would consume the missing
  post-PnR SPEF metrics.

Final PnR metrics (from `runs/RUN_2026-10-29_01-45-14/final/metrics.json`):

```text
Core bbox:                6.72, 15.68 -> 379.68, 388.08   (372.96 x 372.40 um)
Die bbox:                 0, 0 -> 386.895, 404.815        (156,621 um^2)
Core area:                138,890 um^2
Non-fill instances:       2,944   (includes 1,065 tap, 272 tie, 280 FF)
Fill cells:               4,957
Total instances:          7,901
Utilization:              42.37 %
Detailed-route DRC:       0 errors
Route wirelength:         62,101 um
Antenna violations:       0 nets / 0 pins (OpenROAD check)
Critical disconnected:    0
Power-grid violations:    0
```

Timing (last STA actually run: `OpenROAD.STAMidPNR` after global route, step
43 of the successful run; 3 corners; estimated RC, **no SPEF**):

```text
Setup r2r worst slack:   -0.092419 ns  (nom_ff_n40C_3v60, FF)
Setup r2r violations:     1             (_2738_/Q -> _2481_/D, OUT domain)
Setup TNS:                0
Hold worst slack:        +0.254554 ns   (0 hold violations)
Hold TNS:                 0
Floating nets:            2
```

The aggregate `timing__setup__ws = 1.944 ns` metric is **not** the
register-to-register worst path; use the r2r number above.  This is a
mid-PnR estimate, not post-route timing.

A standalone OpenSTA check (not LibreLane, not signoff) is reproducible with
`sta -exit scripts/sta_smoke.tcl` (Yosys netlist, TT, zero parasitics) and
with `NETLIST=.../final/nl/pll_logic.nl.v SDC_FILE=.../final/sdc/pll_logic.sdc`
(routed netlist, TT, zero parasitics).  Both link and accept the SDC, with all
four clocks created:

```text
Netlist                    worst max slack   worst min slack
Yosys (TT, no parasitics)      +1.72 ns          +0.21 ns
Routed (TT, no parasitics)     +1.70 ns          +0.47 ns
```

These numbers are optimistic: zero interconnect parasitics, no macro, TT only,
and `CKR`/`DSM_CK` are not declared.  They are a structural sanity check, not
timing signoff.

## PDK layout and the canary-local overlay

The real PDK checkout is:

```text
/grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk/
  libs.ref/gf180mcu_as_sc_mcu7t3v3/{lib,lef,techlef,gds,cdl,verilog,spice}
  libs.tech/librelane/gf180mcu_as_sc_mcu7t3v3/config.tcl
```

LibreLane's config loader requires a **top-level**
`$PDK_ROOT/$PDK/libs.tech/librelane/config.tcl`.  This PDK has only the
SCL-level `libs.tech/librelane/gf180mcu_as_sc_mcu7t3v3/config.tcl`, and that
file does not define `TECH_LEFS`, `CELL_LEFS`, `CELL_GDS`,
`CELL_VERILOG_MODELS`, `CELL_SPICE_MODELS`, `PDN_*`, `RT_*`, `IO_PIN_*`,
`RCX_RULESETS`, `FP_TRACKS_INFO`, or the Magic/KLayout/Netgen setup variables.
LibreLane validates PDK variables *before* merging a design config, so those
values must be in the PDK config, not only in `config.digital.yaml`.

The canary therefore uses this overlay (checked in under `pdk_overlay/`;
the symlinks are created by `scripts/run_canary.sh` and are gitignored):

```text
pdk_overlay/
  gf180mcu/
    libs.ref -> /grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk/libs.ref
    libs.tech/librelane/config.tcl                     # checked-in shim
    libs.tech/librelane/gf180mcu_as_sc_mcu7t3v3
        -> /grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk/libs.tech/librelane/gf180mcu_as_sc_mcu7t3v3
  placeholders/not_a_deck                              # checked-in placeholder
```

and runs with:

```text
--manual-pdk --pdk-root <canary>/pdk_overlay --pdk gf180mcu \
--scl gf180mcu_as_sc_mcu7t3v3
```

The shim sets `STD_CELL_LIBRARY`, the actual view paths, `VDD_PIN`/`GND_PIN`,
`SCL_POWER_PINS [VDD VNW]`, `SCL_GROUND_PINS [VSS VPW]`, the PDN/routing
layers, `FP_TRACKS_INFO`, and `RCX_RULESETS {}`.  It also points
`MAGICRC`, `MAGIC_TECH`, `MAGIC_PDK_SETUP`, `KLAYOUT_TECH`,
`KLAYOUT_PROPERTIES`, `KLAYOUT_DEF_LAYER_MAP` and `NETGEN_SETUP` at
`pdk_overlay/placeholders/not_a_deck` only so PDK validation passes.

**The placeholder is not a deck.**  Every step that would consume it is in
`LIBRELANE_SKIP`; no DRC, LVS, streamout or antenna signoff is claimed.  If
you run those steps manually against this overlay, expect them to fail.  The
PDK itself was not modified.

### Why VNW/VPW matter

The gf180 cells expose `VDD`/`VSS` plus `VNW`/`VPW` well-bias pins
(`USE POWER`/`USE GROUND` in the LEF).  With only `VDD`/`VSS` in
`SCL_POWER_PINS`/`SCL_GROUND_PINS`, OpenROAD's disconnected-pin checker sees
every cell's `VNW`/`VPW` as a critical disconnected pin.  The first LibreLane
attempt reported **1864** critical disconnected pins for this reason.  The
canary connects `VNW` to `VDD` and `VPW` to `VSS` through
`SCL_POWER_PINS [VDD VNW]` / `SCL_GROUND_PINS [VSS VPW]`; the final run
reports 0.  This is a real library-integration requirement for
`gf180mcu_as_sc_mcu7t3v3`, not a checker workaround.

## Commands

From this directory:

```sh
make synth-digital       # Yosys synthesis of pll_logic (runs now)
make librelane-digital   # LibreLane digital-only run (runs now, with skips)
make librelane-macro     # blocked: PLL_ANALOG views absent
make clean               # remove build/
```

Direct equivalents:

```sh
./scripts/run_canary.sh synth-digital
yosys -s scripts/synth_digital.ys          # from this directory
./scripts/run_canary.sh librelane-digital
./scripts/run_canary.sh librelane-macro
sta -exit scripts/sta_smoke.tcl            # Yosys netlist, TT, no parasitics
```

Point at another LibreLane or PDK location:

```sh
export LIBRELANE=/path/to/librelane
make librelane-digital

make synth-digital PDK_REF_ROOT=/path/to/pdk/libs.ref
```

`LIBRELANE_SKIP` (default in `Makefile`/`run_canary.sh`) is the list of
signoff steps that need missing collateral.  `LIBRELANE_PDK_ROOT` can be
relocated; the driver copies the shim and placeholder there and creates the
symlinks.

## Run history (exact errors)

1. **PDK config validation** (before any run): LibreLane reported
   `Required PDK variable ... did not get a specified value` for `TECH_LEFS`,
   `CELL_LEFS`, `PDN_*`, `MAGIC*`, `KLAYOUT*`, `NETGEN_SETUP`, etc.  Cause:
   this PDK has no top-level `libs.tech/librelane/config.tcl` and its SCL Tcl
   does not define the required variables.  Fixed with the canary-local
   `pdk_overlay/` shim.
2. **`RUN_2026-10-29_01-16-27`**: reached detailed routing, then
   `Checker.DisconnectedPins` failed with `1864 critical disconnected pins`.
   Cause: `VNW`/`VPW` well pins were not globally connected.  Fixed with
   `SCL_POWER_PINS [VDD VNW]` / `SCL_GROUND_PINS [VSS VPW]`.
3. **`RUN_2026-10-29_01-27-16`**: reached fill and then
   `STAPostPNR: missing required input 'spef'`.  Cause: `RCX_RULESETS` is
   empty (no OpenRCX rules), so RCX produced no SPEF.  Fixed by skipping
   `OpenROAD.RCX`, `OpenROAD.STAPostPNR`, `OpenROAD.IRDropReport` and the
   timing checkers.
4. **`RUN_2026-10-29_01-36-46`**: reached `Odb.CheckDesignAntennaProperties`
   and failed with `missing required input 'lef'`.  Cause: `Magic.WriteLEF`
   was skipped (no Magic tech), but the antenna-property check consumes its
   LEF.  Fixed by skipping the check.
5. **`RUN_2026-10-29_01-45-14`**: complete, Classic 80/80, exit code 0,
   `error.log` empty.  This is the run quoted in the status table.

## Not proven / blockers

1. **No GDS, no DRC/LVS/antenna signoff.**  This PDK checkout ships no
   KLayout tech/DRC/LVS decks, no Magic tech, and no Netgen setup.  The
   `as_sc` tree has only `libs.tech/{librelane,xschem}`.  The canary's
   placeholder is not a deck.  `KLayout.DRC`, `Magic.DRC`, `Netgen.LVS`,
   `KLayout.XOR`, streamout and the KLayout antenna deck were all skipped.
   The "Antenna Passed" line in the manufacturability report is
   OpenROAD's in-flow antenna check, not the KLayout deck.
2. **No post-PnR STA / RCX / IR drop.**  There are no OpenRCX `.rules` files
   in the PDK and no `LAYERS_RC`/`VIAS_R` Tcl.  The canary supplies
   LEF-derived `LAYERS_RC`/`VIAS_R` for PnR estimates (via resistance is a
   5 ohm/cut placeholder), but `RCX_RULESETS` is empty, so no SPEF exists.
   The last STA is mid-PnR after global route, with estimated parasitics:
   one FF register-to-register setup violation of -0.092 ns and zero hold
   violations.  Post-route timing is unproven.
3. **No timing closure claim.**  The current SDC uses 6.667 ns
   (150 MHz) OUT/MID_OUT and 12.5 ns (80 MHz) REF/INJ, below the measured
   196.37 MHz SS digital Fmax.  The RTL's FCW=8 nominal is 2.5 ns
   (400 MHz), which is not claimed at 180 nm.  `CKR` and `DSM_CK` are
   internally generated clocks and are not declared; `SS_BBPD` is not
   constrained because there is no macro Liberty.  A timing claim without
   these is incomplete.
4. **`PLL_ANALOG` does not exist.**  `hardmacro/PLL_ANALOG.{gds,lef,lib}`,
   CDL and SPICE are expected, not built.  `config.macro.yaml` cannot run.
   `SS_BBPD` -> digital timing is unconstrained until the macro has a
   Liberty model.
5. **The 3.3 V cell library is not a product library.**  It has 107 cells:
   one positive DFF family (`dfxtp_2`/`dfxtp_4`, plus the PDK-excluded
   `dyn_dfxtp_2`), one negative DFF (`dfxtn_2`), one async set/reset DFF
   (`dfsrtp_2`), four latch cells (`dlx*`), no scan flops and no enable
   flops.
   All async-reset flops map to `dfsrtp_2` with a tied-off set pin; 272
   tie-high cells are inserted.  A scan/DFT or low-power product port needs
   a different library or reset strategy.
6. **Only 3 nominal PVT corners are used.**  The three Liberty files are
   cell-identical (107 cells each), which is better than the ics55 H7CR set,
   but there are no independent min/max Liberty views.  The PDK Tcl declares
   9 corner *names* (`nom_/min_/max_` x `tt/ff/ss`); every alias resolves to
   the same three files.  The canary does not claim 6 or 9 independent
   corners.  If you enable the aliases, they reuse the same Liberty data.
7. **RTL parameter propagation bug.**  In `src/pll.v`, the `pll_logic`
   instance parameters are only passed under `` `ifdef SIMULATION ``.  A
   synthesised top with non-default parameters silently uses `pll_logic`'s
   defaults.  This canary uses defaults, so the netlist is consistent, but a
   parameterized product build would be wrong.
8. **License.**  `src/delta_sigma.v` still says "No LICENSE yet".  It is
   included because the digital control needs it; resolve the license before
   redistribution.

## Corner notes (3 / 6 / 9)

| Set | What it means | Claimed? |
|---|---|---|
| 3 | The three nominal PVT corners actually used: `nom_tt_025C_3v30`, `nom_ff_n40C_3v60`, `nom_ss_125C_3v00` | **Yes** for the digital canary |
| 6 | Add the three `min_*` or three `max_*` aliases; they resolve to the same three Liberty files | Not independent; not claimed |
| 9 | All `nom_/min_/max_` aliases declared by the PDK Tcl; same three files | Not independent; not claimed |

The three files were verified to contain the same 107 cell names.  There are
no separate min/max Liberty files and no RCX rules for any corner.

## Interface summary (PLL_ANALOG)

Full details: `hardmacro/interface.md`, `hardmacro/manifest.yaml`.

| Port | Dir | Width | Notes |
|---|---|---|---|
| `COARSE_MUX` | in | 15 | unary coarse delay code |
| `MID_MUX` | in | 15 | unary mid delay code |
| `FINE_MUX` | in | 31 | unary fine delay code |
| `DCO_EN` | in | 1 | DCO enable |
| `REF` | in | 1 | 12.5 ns (80 MHz) reference in this canary |
| `INJ_EN` | in | 1 | injection enable |
| `SS_BBPD` | out | 2 | `[0]` = REF sample, `[1]` = OUT sample |
| `OUT` | out | 1 | DCO output |
| `MID_OUT` | out | 1 | mid-delay tap |
| `INJ_EDGE` | out | 1 | delayed REF, used as a digital clock |
| `VDD`/`VSS` | inout | 1 each | optional in RTL (`WITH_POWER`), required in LEF/PDN |

The macro has **no reset pin**.  `RST_N` is digital-only.  The interface is a
single 3.3 V domain; a separate analog supply or bias pins would require an
interface change.

Hard-macro boundary: injection chain, IL-DCO, SS-BBPD sampler, output buffers
and macro-local power grid are inside.  `pll_logic`, the lock FSM, mode
registers, divider control, top PDN/CTS/route/STA and DFT are outside.  The
macro is built by the ckdur hard-macro flow (`pnr/` + ngspice/ISF), not by
LibreLane.

## Constraints notes (`constraints/adpll.sdc`)

- `REF` = 12.5 ns (80 MHz).  `OUT`/`MID_OUT` are created at 6.667 ns
  (150 MHz) as a planning value below the 196.37 MHz SS digital Fmax; the real
  period is a DCO characterization result.  The RTL's FCW=8 nominal is
  2.5 ns / 400 MHz, not claimed here.
- `INJ_EDGE` is created as a 12.5 ns clock, but it is physically a delayed
  `REF`.  It is grouped asynchronous for now; replace with a generated clock
  + edge shift once the macro Liberty provides the insertion delay.
- Input delays: REF-sampled controls max 5.0 / min 1.0 ns; OUT-sampled divider
  controls max 0.5 / min 0.1 ns.  Output delays: `LOCKED`/`ERR` 12.5 ns
  (INJ_EDGE domain), `OUT_DIV` 0.5 ns (OUT domain), DCO buses 0.5 ns in the
  digital-only top (min 0 for outputs).  These are planning values, not
  board-level numbers.
- `RST_N` is a false path.  `INJ_EN` is a false path when it exists.
- `SS_BBPD` is **not** constrained.  It must become a real setup/hold check
  against `negedge INJ_EDGE` when `PLL_ANALOG.lib` exists.
- `CKR` and `DSM_CK` are not declared; add `create_generated_clock` after
  synthesis/CTS names are stable.

## What is in here

```text
flow/canary/gf180mcu_as_sc_core_a/
  README.md                     this file
  Makefile                      synth-digital / librelane-* / clean
  config.digital.yaml           LibreLane digital-only config, top = pll_logic
  config.macro.yaml             LibreLane full-top skeleton, top = pll + PLL_ANALOG
  constraints/
    adpll.sdc                   canary REF/OUT/MID_OUT/INJ_EDGE constraints
  hardmacro/
    PLL_ANALOG_blackbox.v       synthesizable blackbox matching src/pll.v
    interface.md                port/clock/power/timing/build-boundary contract
    manifest.yaml               machine-readable version of interface.md
  scripts/
    synth_digital.ys            Yosys synthesis + stat + netlist
    sta_smoke.tcl               optional OpenSTA netlist/SDC smoke check
    run_canary.sh               target driver, PDK overlay, LibreLane skips
  pdk_overlay/
    gf180mcu/libs.tech/librelane/config.tcl   PDK shim (checked in)
    placeholders/not_a_deck                   not a deck; see caveat
  build/                        generated by make; ignored by git
  runs/                         LibreLane run directories; ignored by git
```

## Findings while building the canary

1. **The PDK is not a drop-in LibreLane PDK.**  It has no top-level
   `libs.tech/librelane/config.tcl`, and its SCL Tcl lacks the required
   view/PDN/routing variables.  A local overlay is required.  The PDK's
   `libs.tech` contains only `librelane` and `xschem`; there are no
   KLayout/Magic/Netgen decks.
2. **`VNW`/`VPW` must be globally connected.**  Otherwise 1864 critical
   disconnected pins.  See the status section.
3. **`synth_exclude.cells` is meaningful.**  It excludes `dyn_dfxtp_2`
   (leaving `dfxtp_2`/`dfxtp_4`), the `clkbuff_*` cells from synthesis, the
   latches, the diode and `hcf_7`.  The standalone Yosys flow excludes
   `dyn_dfxtp_2` explicitly; LibreLane applies the whole file.  The two
   synthesis results differ slightly:
   - standalone: 1690 cells, 49,069.31 um²;
   - LibreLane: 1673 cells, 48,814.66 um².
   Both have 280 sequential cells (272 `dfsrtp_2` + 8 `dfxtp_2`).
4. **`Odb.CheckDesignAntennaProperties` depends on `Magic.WriteLEF`.**  If
   streamout is skipped, this check must be skipped too, or the flow fails
   with `missing required input 'lef'`.
5. **No OpenRCX rules.**  `RCX_RULESETS` is empty and `OpenROAD.RCX` produces
   no SPEF.  `OpenROAD.STAPostPNR` and IR drop then fail/skip.  Generate
   OpenRCX rules (or an ITF-based deck) before claiming post-route timing.
6. **Two floating nets and 132 lint warnings** were reported
   (`timing__drv__floating__nets = 2`).  The flow completed, but these are
   not investigated in this canary.
7. **`delta_sigma`/`term_decoder` width assumptions** are unchanged from the
   ics55 canary: `delta_sigma`'s sign extension assumes `BITS_INT >= 4`;
   `term_decoder` uses a 32-bit shift and is safe only for `NDELS <= 31`.
   The canary uses the defaults (`FINE_NDELS = 31`).
8. **The 180 nm DCO range is not characterized.**  The ics55 delay-code
   widths are carried over unchanged; they may not match gf180mcu device
   speeds.  Re-size from the analog characterization before any frequency
   claim.

## Next steps

1. Build and characterize `PLL_ANALOG` (GDS/LEF/Liberty/CDL/SPICE) with the
   ckdur hard-macro flow; fill `hardmacro/` and update `manifest.yaml`.
2. Obtain or generate gf180mcu KLayout DRC/LVS/antenna decks and a Netgen
   setup; remove the placeholder and rerun without the signoff skips.
3. Generate OpenRCX rules (or an ITF-based extraction deck) for the three
   Liberty corners; rerun RCX, post-PnR STA and IR drop.
4. Fix the FF register-to-register setup violation (-0.092 ns) or confirm it
   is an artifact of the estimated parasitics; do not claim timing closure
   from the no-SPEF run.
5. Add `SS_BBPD` setup/hold constraints and `create_generated_clock` for
   `CKR`/`DSM_CK` once the macro Liberty and post-CTS names exist.
6. Decide on a scan/reset strategy; the current 107-cell library has no scan
   flops and only one async set/reset flop.
7. Resolve the `delta_sigma.v` license and the `pll.v` parameter-propagation
   bug before product use.
