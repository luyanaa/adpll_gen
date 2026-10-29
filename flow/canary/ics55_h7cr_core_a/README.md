# ics55 H7CR + Core A canary

First canary for the ADPLL flow on **ics55 / `ics55_LLSC_H7CR` / Core A
(IL-DCO)**.  It answers one question: *does the digital control synthesize
against the H7CR standard-cell library?*  It also records the interface and
LibreLane skeleton for the eventual full `pll` top with a `PLL_ANALOG` hard
macro.

Everything here is new and self-contained for the canary itself.  The
GDS-map correction also touches `settings.mk`, `signoff/Makefile`, and
`flow/maps/ics55_lefdef.map`; those are shared-flow fixes, not canary-only
changes.

## Status (exact)

| Item | Status |
|---|---|
| Yosys synthesis of `pll_logic` -> H7CR cells | **PASS** (TT / 1.2 V / 25 C, Yosys 0.52) |
| Digital timing through LibreLane | **COMPLETE (digital-only)** — final run `RUN_2026-10-29_10-21-16`, 80/80, exit 0 |
| Place / CTS / route / DRC / LVS / antenna | **ROUTE DRC 0, setup/hold 0, antenna 0; KLayout DRC after GDS-map fix: 5734 = 4259 7T-cell-internal + 1453 via-cell + 22 top-level (density); LVS skipped** |
| `PLL_ANALOG` hard macro | **NOT BUILT** — no GDS/LEF/Liberty/CDL/SPICE |
| `config.macro.yaml` (full `pll` top) | **SKELETON ONLY — cannot run until the macro views exist** |
| Multi-corner synthesis/STA | 3 PDK-wired corners enabled; 4 extra corners disabled after a cell-set mismatch (see below) |

### Runtime update (2026-10-29)

A usable LibreLane **v3.0.16** is present in the Nix store at
`/nix/store/ilpnqwsl6gvk6kvavkaljbnzaz3086fd-python3.13-librelane-3.0.16/bin/librelane`
but is not in `PATH`.  With

```sh
export LIBRELANE=/nix/store/ilpnqwsl6gvk6kvavkaljbnzaz3086fd-python3.13-librelane-3.0.16/bin/librelane
# and a /grid/ics55 -> /grid/icsprout55-pdk symlink, PDK_ROOT=/grid
```

`make librelane-digital` runs.  OpenROAD is bundled with that LibreLane; a
standalone `openroad` is not on `PATH`.

Observed run history:

1. All-seven `LIB` set: failed at `RepairDesignPostGPL` with
   `[STA-1112] ... ICGNX3H7R ... not found` (the corner cell-set mismatch
   documented above).
2. Three PDK-wired corners: completed floorplan, placement, CTS, detailed
   routing, fill insertion, RCX and post-PnR STA.  It stopped at the IR-drop
   step because the PDK's `RCX_RULESETS` `nom_*` fallback produced a second
   SPEF for the default corner.
3. The canary overrides `RCX_RULESETS` with the three specific patterns and
   skips `Magic.StreamOut`/`Magic.WriteLEF`/`Magic.DRC`/`Magic.SpiceExtraction`/
   `Netgen.LVS`/`Odb.CheckDesignAntennaProperties`/`KLayout.XOR`/`Checker.XOR`.
   Final run `RUN_2026-10-29_10-21-16` completed 80/80: route DRC 0,
   setup/hold 0, antenna 0.  LVS is N/A because the Magic/Netgen path is
   skipped.

### GDS map correction (2026-10-29)

The run's KLayout streamout used `ics55.map` (a **GDS-import** map) as the
**LEF/DEF** layer map.  All DEF routing/SPNET shapes landed on auto layers
8/10/12/14/16; the original KLayout DRC count **2312 is invalid** as a
signoff number.

Re-streaming the final DEF with `flow/maps/ics55_lefdef.map` gives a valid
GDS and the following KLayout DRC:

```text
total = 5734
standard-cell internal = 4259
  metal.m2.area 1913, M1DUM_W_1 1702, metal.m1.area 307,
  implant.np.enclosed_area 280, metal.m2.spacing 43, ...
via-cell / LEF-via = 1453
  metal.m2.area 1405, ...
top-level macro = 22
  density checks 20, metal.m2.area 5
```

The top-level M2 area/spacing signature is a **via-pad/LEF streamout**
issue, not a 7T cell-internal issue.  The 280 NP holes are FILLTAP cells
(instance attribution; see `flow/macro/ics55_h7cr/classify_drc.py`).  Reports: `drc_remap.md`, `drc_remap.json`, `drc_remap.lyrdb`;
remapped GDS: `pll_logic_remap.gds`.

The run's OpenROAD `route__drc_errors=0` remains valid for detailed routing;
it is not a KLayout signoff DRC claim.

Tools present: `yosys` 0.52, `sta` (OpenSTA 2.0.17), `git`, `docker`,
LibreLane v3.0.16 (Nix store path).  Docker being available does **not** mean
it contains LibreLane.

## Proven

The command is `make synth-digital`, which runs:

```sh
yosys -s build/yosys/synth_digital.generated.ys
# source: scripts/synth_digital.ys
```

with these RTL files:

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
`/grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CR/liberty/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib`.

Result (see `build/yosys/stat.rpt` and `build/yosys/yosys.log`):

```text
Number of cells:                1571
  sequential:                    280   (DFFNRX0P5H7R 27, DFFQX1H7R 8,
                                        DFFRQNX1H7R 3, DFFRQX2H7R 242)
  combinational:                1291
Chip area (Liberty area):       4321.80 um^2
Sequential area:                2196.88 um^2 (50.83 %)
```

- 0 errors, 0 unmapped internal cells (`$...`) in the final netlist.
- All 65 top-level output bits are driven by real H7CR cells.
- The only log warnings are two benign ABC messages (Liberty has multi-output
  adder cells; one network is combinational).
- `dfflibmap` lists some DFF variants as "unmapped" because H7CR has no cell
  for them; the design does not use those variants.  This is informational,
  not a failure.
- The full `pll` top also elaborates against `hardmacro/PLL_ANALOG_blackbox.v`
  with `hierarchy -check -top pll` (Yosys, no errors/warnings): the blackbox
  interface matches `src/pll.v`.  It was not synthesized/mapped because there
  is no macro Liberty yet.

A standalone OpenSTA smoke check (not LibreLane, not signoff) is reproducible
with `sta -exit scripts/sta_smoke.tcl` after the synthesis.  It confirms that
the TT netlist links and `constraints/adpll.sdc` parses, with all four clocks
created.  Worst pre-layout max slack is +1.24 ns and worst min slack is
+0.10 ns with **zero interconnect parasitics and no macro**.  That is a syntax
/ structural sanity result only; do not quote it as timing signoff.

## DRC classification: 7T cell vs digital top

The original `drc_summary.md` (2312 items) was produced from the wrong GDS map.
The remapped GDS is classified with `flow/macro/ics55_h7cr/classify_drc.py`
using `dump_instances.rb`; a top-tagged polygon inside a standard cell or a
LEF via is attributed to that instance:

```text
total = 5734
standard-cell internal = 4259
  metal.m2.area 1913, M1DUM_W_1 1702, metal.m1.area 307,
  implant.np.enclosed_area 280, metal.m2.spacing 43, ...
via-cell / LEF-via = 1453
  metal.m2.area 1405, ...
top-level macro = 22
  ACT_D_1_min 5, PO_D_2_min 5, metal.m2.area 5, density 7
```

- The **4259 cell-internal** items are 7T library-cell-as-drawn DRC; they are
  not the digital P&R/routing and need a library fix/waiver or a different
  7T variant.
- The **1453 via-cell** items are LEF via pad geometry (`VIA_MET3_MET2_VIA2_6`
  etc.), not 7T cells.  They are a streamout/LEF-via issue, not a cell issue.
- The **22 top-level** items are density windows plus five M2 min-area
  fragments; there is no top-level routing geometry DRC.

Do not "fix" the 4259 cell-internal items by editing the digital layout.
Reports: `drc_remap.md`, `drc_remap.json`, `drc_remap.lyrdb`.

## Corner cell-set finding (important)

The H7CR Liberty set is **not cell-identical across all seven files**:

- six corners have 747 cells;
- `ics55_LLSC_H7CR_ss_cworst_1p08_m40_nldm.lib` has **746** and is missing
  `ICGNX3H7R`.

The TT-synthesized `pll_logic` netlist uses `ICGNX3H7R`, so an all-seven
LibreLane run fails at `RepairDesignPostGPL`:

```text
[STA-1112] Liberty cell ics55_LLSC_H7CR_ff_rcbest_1p32_m40/ICGNX3H7R
for corner nom_ss_n40C_1v08/min not found.
```

The canary therefore uses the **three PDK-wired corners** (TT, SS 125 C/1.08 V,
FF -40 C/1.32 V), which all contain the cell. To enable all seven corners, one
of these is required:

1. synthesize with `ICGNX3H7R` excluded/remapped to a cell present in every
   corner; or
2. exclude `nom_ss_n40C_1v08` from the all-corner claim; or
3. obtain a corrected H7CR Liberty set.

This is exactly the kind of design-specific corner check the library catalogue
must record; a corner count alone is not enough.

## Not proven / blockers

1. **Full LibreLane signoff is not complete.** The digital-only run reached
   detailed routing, fill, RCX and post-PnR STA; the first 3-corner run stopped
   at the IR-drop step on a duplicate-SPEF issue caused by the PDK's `nom_*`
   RCX fallback.  `RCX_RULESETS` is now overridden with the three specific
   patterns; the follow-up run is in progress.  No final GDS/DRC/LVS/antenna
   report is claimed yet.
2. **OpenROAD steps are partially proven.** Placement, CTS, detailed routing,
   fill insertion, RCX and post-PnR STA ran; KLayout DRC/LVS, antenna,
   IR/EM and the final GDS are not yet a completed signoff.
3. **`PLL_ANALOG` does not exist.** `hardmacro/PLL_ANALOG.{gds,lef,lib}` and
   the CDL/SPICE views are expected, not built.  `config.macro.yaml` therefore
   cannot run.  `SS_BBPD` -> digital timing is completely unconstrained until
   the macro has a Liberty model.
4. **Internally generated clocks are not declared.** `CKR` (REF retimed by a
   `MID_OUT`-edge flop) and `DSM_CK` (`MID_OUT / DSM_DIV`) are used as clocks
   inside `pll_logic`.  They are not in the SDC because their hierarchical
   names are not stable before synthesis/CTS.  A timing claim without them is
   incomplete.
5. **Only TT was synthesized; three corners are enabled in the canary.**
   The seven H7CR Liberty views exist, but the all-seven set is not
   cell-identical (see the corner cell-set finding).  The canary uses the
   three PDK-wired corners; the extra four are not proven.
6. **PDK layout mismatch for LibreLane.** This checkout is flat:

   ```text
   /grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CR/...
   ```

   but `libs.tech/librelane/config.tcl` builds paths as
   `$PDK_ROOT/$PDK/libs.ref/...`.  A LibreLane run needs
   `$PDK_ROOT/$PDK` to resolve to `/grid/icsprout55-pdk`, e.g.
   `PDK_ROOT=/grid` plus an `/grid/ics55 -> /grid/icsprout55-pdk` symlink
   (or an equivalent local layout).  The symlink was created for the canary
   run; it is outside the repository and reversible.
7. **Licensing.** `src/delta_sigma.v` still says "No LICENSE yet".  It is
   included because the digital control needs it; resolve the license before
   redistribution.

## Commands

From this directory:

```sh
make synth-digital       # runs now; needs yosys
make librelane-digital   # blocked until librelane is installed
make librelane-macro     # blocked: librelane absent AND macro views absent
make clean               # remove build/
```

Direct equivalents:

```sh
./scripts/run_canary.sh synth-digital
yosys -s scripts/synth_digital.ys          # directly, from this directory
./scripts/run_canary.sh librelane-digital
./scripts/run_canary.sh librelane-macro
```

When LibreLane is available, point the scripts at it:

```sh
export LIBRELANE=/path/to/librelane
make librelane-digital
```

If the PDK is installed elsewhere, override `PDK_REF_ROOT` (local views) and
`PDK_ROOT`/`PDK` (LibreLane):

```sh
make synth-digital PDK_REF_ROOT=/path/to/pdk/libs.ref
```

## What is in here

```text
flow/canary/ics55_h7cr_core_a/
  README.md                     this file
  Makefile                      synth-digital / librelane-* / clean
  config.digital.yaml           LibreLane skeleton, top = pll_logic (digital only)
  config.macro.yaml             LibreLane skeleton, top = pll + PLL_ANALOG macro
  constraints/
    adpll.sdc                   canary REF/OUT/MID_OUT/INJ_EDGE constraints
  hardmacro/
    PLL_ANALOG_blackbox.v       synthesizable blackbox matching src/pll.v
    interface.md                port/clock/power/timing/build-boundary contract
    manifest.yaml               machine-readable version of interface.md
  scripts/
    synth_digital.ys            Yosys synthesis + stat + netlist
    sta_smoke.tcl               optional OpenSTA netlist/SDC smoke check
    run_canary.sh               target driver, including LibreLane blockers
  build/                        generated by make; ignored by git
```

## LibreLane config caveats (both configs)

These are skeletons.  Check each key against the installed LibreLane release
and the PDK's `libs.tech/librelane` Tcl:

- `PDK` / `STD_CELL_LIBRARY` vs the `pdk::ics55*:` scoped block.  The PDK's
  validated example (`libs.tech/librelane/examples/counter/config.yaml`) uses
  the scoped block; the top-level keys are the portable form.  Keep only what
  the release accepts.
- `LIB` / `STA_CORNERS`: all seven H7CR Liberty files are listed.  The PDK
  `config.tcl` itself wires only three corners into `::env(LIB)`; the `LIB`
  override in these files is what makes seven possible.  If a per-corner
  `LIB` override is rejected, delete `LIB` and keep only the first three
  `STA_CORNERS` entries.
- RCX rules exist only for the three PDK-wired corners.  The extra four
  corners fall back to another `nom_ss_*`/`nom_ff_*` ruleset; their parasitics
  are approximate until dedicated rules are generated.
- `RUN_DRC` / `RUN_LVS` / `RUN_ANTENNA` / `RUN_STA` names and availability
  vary between LibreLane releases.
- `PNR_SDC_FILE` / `SIGNOFF_SDC_FILE`, `DIE_AREA`, `FP_CORE_UTIL`,
  `PL_TARGET_DENSITY_PCT` are canary values, not QoR targets.
- `config.macro.yaml`: `MACROS.PLL_ANALOG.lib` holds one (TT) Liberty.  A
  seven-corner run needs per-corner macro Liberty views; the mapping syntax
  depends on the release.
- `PDN_MACRO_CONNECTIONS` in `config.macro.yaml` is commented out because its
  key name/argument order differs between releases.
- `LAYERS_RC` / `VIAS_R` are copied from the PDK's validated example because
  the PDK `config.tcl` still marks them TODO.  Verify against the installed
  PDK revision.

## Interface summary (PLL_ANALOG)

Full details: `hardmacro/interface.md`, `hardmacro/manifest.yaml`.

| Port | Dir | Width | Notes |
|---|---|---|---|
| `COARSE_MUX` | in | 15 | unary coarse delay code |
| `MID_MUX` | in | 15 | unary mid delay code |
| `FINE_MUX` | in | 31 | unary fine delay code |
| `DCO_EN` | in | 1 | DCO enable |
| `REF` | in | 1 | 20 ns reference in this canary |
| `INJ_EN` | in | 1 | injection enable |
| `SS_BBPD` | out | 2 | `[0]` = REF sample, `[1]` = OUT sample |
| `OUT` | out | 1 | DCO output |
| `MID_OUT` | out | 1 | mid-delay tap |
| `INJ_EDGE` | out | 1 | delayed REF, used as a digital clock |
| `VDD`/`VSS` | inout | 1 each | optional in RTL (`WITH_POWER`), required in LEF/PDN |

The macro has **no reset pin**.  `RST_N` is digital-only.  The current
interface has a single 1.2 V domain; a separate analog supply or bias pins
would require an interface change.

Hard-macro boundary: injection chain, IL-DCO, SS-BBPD sampler, output buffers
and macro-local power grid are inside.  `pll_logic`, the lock FSM, mode
registers, divider control, top PDN/CTS/route/STA and DFT are outside.  The
macro is built by the ckdur hard-macro flow (`pnr/` + ngspice/ISF), not by
LibreLane.

## Constraints notes (`constraints/adpll.sdc`)

- `REF` = 20 ns (50 MHz).  `OUT`/`MID_OUT` are created at a nominal 2.5 ns
  (FCW=8 => 8 x REF); the real period is a DCO characterization result.
- `INJ_EDGE` is created as a 20 ns clock, but it is physically a delayed
  `REF`.  It is grouped asynchronous for now; replace with a generated clock
  + edge shift once the macro Liberty provides the insertion delay.
- Input delays: REF-sampled controls max 5.0 / min 1.0 ns; OUT-sampled divider
  controls max 0.5 / min 0.1 ns.  Output delays: `LOCKED`/`ERR` 5.0 ns
  (INJ_EDGE domain), `OUT_DIV` 0.5 ns (OUT domain), DCO buses 0.5 ns in the
  digital-only top (min 0 for outputs).  These are planning values, not
  board-level numbers.
- `RST_N` is a false path.  `INJ_EN` is a false path when it exists.
- The ckdur `src/pll.sdc.tcl` was used as a starting point.  Its internal
  1 ns `OUT`/`MID_OUT` clocks are not signoff-grade and it does not cover
  `INJ_EDGE`, `CKR` or `DSM_CK`; it is not copied into a signoff claim.
- `SS_BBPD` is **not** constrained.  It must become a real setup/hold check
  against `negedge INJ_EDGE` when `PLL_ANALOG.lib` exists.

## Findings while building the canary

These are observations, not fixes.  No existing RTL was modified.

1. **RTL parameter propagation bug (real).** In `src/pll.v` the
   `pll_logic` instance gets `COARSE_NDELS`, `MID_NDELS`, `FINE_NDELS`,
   `FILTER_BITS`, `IS_DSM`, `DSM_DIV`, `LOCKED_WAIT`, `FILTER_ILL`,
   `DIV_BITS`, `FCW_BITS` only under `` `ifdef SIMULATION ``.  A synthesised
   top with non-default parameters silently uses `pll_logic`'s defaults.  The
   canary uses defaults, so the netlist is consistent, but a parameterized
   product build would be wrong.
2. **Divide-by-1 semantics bug (real, not hit).** `pll_fix_divider` and
   `pll_mod_divider` implement `DIV == 1` / `set_div == 1` as `out <= ~out`,
   i.e. divide by 2, while the comments say the output follows the input
   (divide by 1).  The canary uses `DSM_DIV = 2`, so it is not exercised.
3. **`delta_sigma` width assumption.** The sign-extension
   `{{(BITS_INT+1-5){dout[4]}}, dout}` is only valid for `BITS_INT >= 4`.
   `pll_logic` uses `$clog2(31) = 5`, so it is fine here; a smaller
   `FINE_NDELS` would produce an invalid/negative repetition.
4. **`term_decoder` 32-bit shift.** `((1 << IN) - 1)` uses a 32-bit integer;
   `NDELS = 31` is the maximum safe value.  `NDELS = 32` would overflow.
5. **PDK exclusion files look wrong.** `synth_exclude.cells` and
   `pnr_exclude.cells` for `ics55_LLSC_H7CR` contain `sg13g2_*` names, not
   H7CR cells.  Effectively nothing is excluded today.  If H7CR needs a
   don't-use list, this is a PDK bug to fix before signoff.
6. **Only three of seven corners are wired in the PDK Tcl.** See the caveat
   above.  `STA_CORNERS` can list seven, but `LIB` and RCX need explicit
   work; do not treat a seven-corner run as validated until it is.
7. **Yosys `check` quirk.** In Yosys 0.52, running `check` after `abc`
   reports every top-level output as "used but has no driver" because the
   Liberty cells are blackboxes.  The netlist is actually driven.  The script
   runs `check -assert` *before* mapping instead; the post-map connectivity
   was verified by inspecting the 65 output bits in the netlist.

## Next steps

1. Install LibreLane (+ OpenROAD) or provide its path via `LIBRELANE`, and fix
   the `PDK_ROOT/$PDK` layout for the PDK Tcl.
2. Run `make librelane-digital` at TT first; then add generated-clock
   constraints for `CKR`/`DSM_CK` and rerun.
3. Build/characterize `PLL_ANALOG` (GDS/LEF/Liberty/CDL/SPICE) with the
   ckdur hard-macro flow; fill the expected views in `hardmacro/`.
4. Only then run `make librelane-macro`, and only claim the corners for which
   the macro has Liberty views.
5. Resolve the `delta_sigma.v` license and the `pll.v` parameter-propagation
   bug before product use.
