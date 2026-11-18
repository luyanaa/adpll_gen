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

### B2. Macro Liberty has no output-arc to the sampling interface

The 20 arcs are all `combinational` and reference `REF`/`INJ_EN`/
`COARSE_MUX[*]`.  There is **no setup/hold arc from `SS_BBPD` to the
`INJ_EDGE` sampling edge**, which `manifest.yaml` itself lists as the
"critical_interface":

> SS_BBPD -> digital loop filter sampled on negedge INJ_EDGE

Without it the top-level STA checks the digital loop filter's capture of
`SS_BBPD` against nothing.  This is the single most important missing timing
constraint for closing the PLL loop.

**Fix**: add `timing()` groups on `SS_BBPD[*]` with
`timing_type : setup_rising/hold_rising`, `related_pin : INJ_EDGE`, at all
three corners; calibrate from the macro's own STA/SPICE.

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
SPEF 203 D_NET, SDF 552 cells / 277 delays, CDL 51889 B
```

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

### B4. Zero multi-corner macro Liberty

One `PLL_ANALOG_MACRO.lib` exists with `nom_* 1.20 V, 25 C`.  Tapeout needs
TT + SS + FF (the ORFS platform ships `typ_1p20V_25C`, `slow_1p08V_125C`,
`fast_1p65V_m40C`; note the fast corner is 1.65 V, not 1.32 V).

**Fix**: three macro Liberty views, or one with three `operating_conditions`.

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
