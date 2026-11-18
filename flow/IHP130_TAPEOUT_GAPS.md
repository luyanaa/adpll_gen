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
| **SPEF** | — | **missing** |
| **SDF** | — | **missing** |
| **CDL** | — | **missing** (SPICE exists, CDL for LVS does not) |

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

### B3. No macro SPEF/SDF, so there is no post-layout macro timing

The macro was placed, routed and GDS'd, but no parasitics were extracted into
a view the top can consume.  `PLL_RING_DCO_PHYS.spef` exists for the ring DCO
only, and `OFFICIAL_SIGNOFF.md` notes its names do not match the netlist.

**Fix**: run RCX on `PLL_ANALOG_MACRO` for the three corners and emit
per-corner Liberty or SDF.

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
