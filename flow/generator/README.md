# Generator capability gate

`capability.py` is the first capability-driven gate for the ADPLL generator.
It consumes the DCO characterization manifest instead of assuming that a PDK
name implies a frequency.

## Usage

```sh
python3 flow/generator/capability.py --pdk ics55 --target-mhz 1600
python3 flow/generator/capability.py --pdk ics55 --target-mhz 1600 --signoff production
python3 flow/generator/capability.py --pdk ihp-sg13g2 --target-mhz 1600
```

## Status meanings

```text
PASS_L1_EXPERIMENTAL   Target is inside the L1 behavioral DCO range and a
                       measured code candidate exists.  The result is not
                       production/PVT/PEX/jitter verified.

FAIL_OUT_OF_RANGE      DCO target (target_mhz * out_div) is outside the
                       measured L1 range.

FAIL_UNCHARACTERIZED   No manifest for the PDK, no tuning table, non-monotonic
                       codes, or production signoff requested while the
                       characterization level is only L1.

FAIL_SYSTEM_FMAX       Target/REF/FCW exceeds the PDK planning ceiling in
                       `system_limits.json`.  This is checked before the DCO
                       manifest and is not a substitute for DCO evidence.

PASS_ARCH_SELECTED_EXPERIMENTAL
                       An architecture/library/plan was selected, but no DCO
                       manifest or signoff evidence exists.

PASS_ARCH_SELECTED_WITH_DCO
                       Architecture selected and a matching DCO manifest
                       accepts the target; still not production/PVT/jitter
                       signoff.

NEEDS_DCO_CHARACTERIZATION
                       The selected architecture/implementation has no DCO
                       manifest bound to it.  Core A data is never reused for
                       Core B/C.

NEEDS_TICK_FREQUENCY   Core C was selected but no tick_frequency_mhz was
                       supplied; no fixed 1 GHz fallback is applied.

NEEDS_NCO_RANGE        Core C DCO target exceeds the carry-toggle NCO ceiling
                       TICK/2.

FAIL_FREQUENCY_PLAN    target/REF/FCW violate the integer-N planning relation
                       f_out = FCW * f_REF / out_div.

FAIL_SIGNOFF_FMAX      --require-signoff was used and the target exceeds
                       the conservative PDK signoff ceiling.
```

The current ics55 manifest is:

```text
flow/characterization/ics55_sim/dco_capability.json
```

At 1600 MHz ics55 returns `PASS_L1_EXPERIMENTAL` with the closest
coarse/mid/fine candidates, an explicit `production_eligible: false`, and the
measured-frequency error.  IHP now has a sparse L3 manifest:

```sh
python3 flow/generator/capability.py --pdk ihp-sg13g2 --target-mhz 300
# PASS_L3_SPARSE, range 212..624 MHz, production_eligible=false

python3 flow/generator/capability.py --pdk ics55-l3 --target-mhz 1000
# PASS_L3_SPARSE, range 703..1897 MHz, dense table candidate 1000 MHz

python3 flow/generator/capability.py --pdk ics55-l3-dense --target-mhz 1000
# PASS_L3_SPARSE, 110-point dense-axis table, exact 1000 MHz candidate
```

The system ceilings are deliberately below the measured digital canary Fmax:
GF180 AS 3.3 V is 150/80 MHz (OUT/REF), FD 5 V 25/15 MHz, FD 9T 30/20 MHz,
3.3 V 7T 40/25 MHz, and ETRI050 5/5 MHz (experimental, not signoff; hold still fails).

```sh
python3 flow/generator/capability.py --pdk gf180mcu_as_sc_mcu7t3v3 \
  --target-mhz 200
# FAIL_SYSTEM_FMAX
python3 flow/generator/capability.py --pdk gf180mcu_as_sc_mcu7t3v3 \
  --target-mhz 100 --ref-mhz 50
# FAIL_UNCHARACTERIZED (no DCO table; digital ceiling is not DCO signoff)
```

`robust.py` always emits `PVT_FREQUENCY_SCREEN` and `production_eligible:
false`; it never grants production.  It separately reports
`evidence_complete` for the required TT/SS/FF set, PEX/PVT data, lock/STA/
injection checks, jitter, DRC/LVS, and an evidence key.  A production decision
belongs to an external evidence review, not this module.

A target that is inside the range but more than the default 10 MHz tolerance
from a measured code returns `FAIL_NO_CODE_WITHIN_TOLERANCE`; use a measured
code or a denser scan.  Production signoff still returns
`FAIL_UNCHARACTERIZED` because L3 sparse has no PEX/PVT.

## Why this is not a generator PASS

A real generator should only emit a production design after:

- L3/PEX DCO characterization;
- PVT corners;
- closed-loop lock/lock-loss and jitter checks;
- a real macro model in `pll_macro_top`.

The gate is deliberately conservative.  Add `FAIL_UNCHARACTERIZED` rather
than a guessed frequency when the evidence is missing.

## Architecture selection

`architecture.py` implements the structure-selection matrix.  It selects a
primary architecture from target frequency, PDK class, area sensitivity, and
optional features, then returns fallbacks, the best library for the selected
core, the DCO capability result, and the remaining signoff evidence.

```sh
# Default buildable mode: only PHYSICAL_IMPLEMENTABLE/CHARACTERIZED entries.
python3 flow/generator/architecture.py --pdk ics55 \
  --target-mhz 800 --area medium --ref-mhz 100 --fcw 8

# Planning/exploration: RTL-only variants for a PDK without a core-specific
# physical macro are allowed, but never returned as a physical build.
python3 flow/generator/architecture.py --pdk ETRI050_fd_sc_12t \
  --target-mhz 5 --area high --mode explore
python3 flow/generator/architecture.py --pdk gf180mcu_as_sc_mcu7t3v3 \
  --target-mhz 100 --area medium --ref-mhz 50 --mode explore

# --allow-unimplemented is only legal with --mode explore.
python3 flow/generator/architecture.py --pdk ics55 \
  --target-mhz 800 --area medium --ref-mhz 100 --fcw 8 \
  --mode explore --allow-unimplemented

# Emit a per-block selection template for validate_selection.py.  Buildable
# mode only accepts a physical backend; use an architecture with one.
python3 flow/generator/architecture.py --pdk ics55 \
  --target-mhz 800 --area medium --ref-mhz 100 --fcw 8 \
  --emit-selection /tmp/selection.json
python3 flow/validate_selection.py --selection /tmp/selection.json
```

Selection rules:

- `--mode buildable` is the default and only selects
  `PHYSICAL_IMPLEMENTABLE` (Core A/B/C where a core-specific macro entry exists)
  or `CHARACTERIZED` entries.
- `--mode explore` permits `MODEL_ONLY`/`RTL_SYNTHESIZABLE` candidates, but
  reports `NEEDS_DCO_CHARACTERIZATION` unless a matching DCO manifest exists.
- `--allow-unimplemented` is an explicit planning override and requires
  `--mode explore`.
- `<150 MHz`: Core C counter / ring path; `--allow-low-res` enables the
  low-res TDC/bang-bang cost fallback.
- `150–500 MHz`: Core B ring / hybrid.
- `>=500 MHz`: Core A IL-DCO / segmented IL-DCO, then dual-loop or
  fractional variants when requested.
- `--area high`: limits the DCO area rank and forces Core C for `<150 MHz`.
- `--fractional`, `--low-jitter`, `--fast-lock`, `--wide-range`: hard feature
  filters, not suggestions.
- `fractional_n_dsm` is `DCO_FINE_CODE_DSM`; true fractional feedback is a
  separate, currently unimplemented `fractional_n_feedback` candidate.
- A target above the conservative PDK signoff ceiling but below the measured
  architecture ceiling is returned as experimental with an explicit warning.
- `--require-signoff` rejects targets above the conservative PDK signoff
  ceiling instead of returning an experimental architecture.
- `production_eligible` is always `false` in this layer.  It requires a DCO
  L3/PEX/PVT manifest, closed-loop lock/jitter, and DRC/LVS evidence.

`pdk_profiles.json` holds the measured architecture/signoff ceilings and
maturity.  `architecture_catalog.json` holds the structure ranges, area ranks,
PDK classes, complexity, and features.

## Implementation gate

The selector does not select a structure whose implementation is only a
roadmap item.  Each catalog entry carries:

```text
implementation       rtl / rtl_partial / simulation / missing / roadmap
implementation_refs  source paths that must exist
implementation_ready all refs exist and implementation is not missing
implementation_state MODEL_ONLY / RTL_SYNTHESIZABLE /
                     PHYSICAL_IMPLEMENTABLE / CHARACTERIZED
```

`MODEL_ONLY` is simulation-only.  `RTL_SYNTHESIZABLE` can make a netlist but
has no verified physical backend.  `PHYSICAL_IMPLEMENTABLE` has a physical
generation path.  `CHARACTERIZED` also has the matching evidence bundle.
Default `--mode buildable` never selects MODEL_ONLY.  Use `--mode explore`
for behavioral planning, and `--allow-unimplemented` only for roadmap
exploration; no mode grants production eligibility.

Current implementation status:

| Architecture | Status | Artifact |
|---|---|---|
| Core A IL-DCO | RTL/macro | `src/il_dco.v`, `src/pll_analog.v`, `src/pll_macro_top.v` |
| Core B ring DCO | RTL + physical macro | `src/pll_ring_dco_phys.v`, `src/pll_ring_top.v`, `flow/macro/ring_dco_gf180mcu/` and `flow/macro/ring_dco_ihp130/` (DRC/LVS clean), `flow/macro/ring_dco_ics55/` (bring-up), `flow/macro/ring_dco_sky130/` (DRC 0, LVS fail) |
| Core C counter DCO | RTL + physical macro | `src/pll_counter_dco_phys.v`, `src/pll_counter_top.v`, `flow/macro/counter_dco_gf180mcu/` and `flow/macro/counter_dco_ihp130/` (DRC/LVS clean), `flow/macro/counter_dco_ics55/` (bring-up), `flow/macro/counter_dco_sky130/` (DRC 0, LVS fail) |
| Core A dual loop | partial RTL | `src/freq_lock.v`, `src/digital_loop_filter.v` |
| Fractional / DSM | partial RTL | `src/delta_sigma.v`, `src/pll_logic.v` |
| Segmented / hybrid / low-res TDC / multi-phase | roadmap | not selectable by default |

Core B/C are now physical implementations: a fixed-inverter-ring macro and a
synthesizable phase-accumulator/NCO macro.  The gf180mcu and IHP variants have
DRC 0 and LVS PASS in `flow/macro/*_dco_{gf180mcu,ihp130}/`; IHP uses the ORFS
minimal deck.  The ics55 variants remain non-signoff bring-up artifacts; the
sky130 variants have DRC 0 but LVS still fails and are not inventory entries.  The old behavioral modules remain
under `src/pll_ring_dco.v` and `src/pll_counter_dco.v` only for historical
simulation, and are not referenced by the delivery source set.  The physical
catalog bands are 20–300 MHz and 2.5–26.5 MHz; these are architecture/physical
targets, not measured silicon limits.  FreePDK45 is included as a
planning-only predictive profile/library: it has no GDS standard-cell views or
DRC/LVS path in this checkout, so it remains `RTL_SYNTHESIZABLE` and can only
be packaged with `--mode explore --allow-experimental`.  Core C requires an external TICK whose frequency is a required specification
input; it is an NCO/digital clock synthesizer candidate, not a standalone DCO
claim.
Neither macro has a DCO/PVT manifest; buildable selection returns
`PASS_ARCH_SELECTED_PHYSICAL` and the DCO evidence remains a separate blocker
unless `allow_unverified_dco` explicitly permits a physical bring-up package.

DCO characterization is bound to `architecture_id + implementation_id +
PDK/library + structural parameters + physical hash + extraction fidelity +
PVT corner`.  A Core A manifest cannot be reused for Core B/C; the selector
returns `NEEDS_DCO_CHARACTERIZATION` instead.

## System-limit identity

A PDK/library name is not a complete timing identity.  `system_limits.json`
stores an `evidence_identity` per entry and `check_system()` accepts an
explicit identity file/argument:

```sh
python3 flow/generator/architecture.py --pdk gf180mcu_as_sc_mcu7t3v3 \
  --target-mhz 100 --ref-mhz 50 --fcw 2 \
  --evidence-identity /tmp/limit_identity.json
```

With `--require-evidence-identity` (or `check_system(..., require_identity=True)`),
missing or mismatched `process_id`, `pdk_release`, `standard_cell_library`,
`technology_view`, `metal_stack`, `physical_flow`, `implementation_hash`, or
`timing_corner` returns `FAIL_EVIDENCE_IDENTITY`.  Unverified values are
stored as `null`, so a caller cannot accidentally claim them.  The old
OSU/OCD/AS-EX aliases to the AS canary were removed for the same reason.

## Delivery generator (P1-3)

`spec.py` resolves a JSON specification into a `ResolvedDesign`; `delivery.py`
writes the build package.  The boundary is explicit:

```text
Specification -> ResolvedDesign -> RTL source set + top wrapper
              -> macro config/rebuild plan + SDC + validation plan
              -> design.lock.json + optional .tar.gz
```

```sh
python3 flow/generator/delivery.py \
  --spec flow/generator/spec.example.json \
  --out build/adpll_ics55 --package

python3 flow/generator/delivery.py --out build/adpll_ics55 --verify
```

### Frequency semantics and emit targets

`target_mhz` is the **post-divider `OUT_DIV`** contract.  The raw DCO output
is `dco_target_mhz = target_mhz * out_div`, and the generated SDC uses
different periods for `OUT` (raw DCO), `OUT_DIV`, the internal `MID_OUT`, and
`TICK`.  `out_div` is bound to the generated `DIV_INIT` parameter.  The generated
`adpll_top` does not expose `SET_DIV/LOAD_DIV`; it ties `SET_DIV` to
`DIV_INIT` and `LOAD_DIV` to zero.  The underlying physical top retains those
pins for bring-up, but changing the divisor requires regenerating the wrapper.

Core C requires `tick_frequency_mhz`.  There is no fixed 1 GHz assumption:
missing tick is `NEEDS_TICK_FREQUENCY`, and a DCO target above `TICK/2` is
`NEEDS_NCO_RANGE`.  The counter RTL toggles `OUT` once per accumulator carry,
so the plan uses `f_out = f_tick * increment / 2^(ACC_BITS+1)` and reports
`increment_for_dco_target`; a `BASE_INC` that disagrees is a warning, not a
silent frequency assumption.

The delivery command accepts three source-set targets:

```sh
python3 flow/generator/delivery.py --spec spec.json --out build/sim --target simulation
python3 flow/generator/delivery.py --spec spec.json --out build/macro --target macro-build
python3 flow/generator/delivery.py --spec spec.json --out build/top --target top-integration
```

`top-integration` copies a generated hard-macro blackbox and does **not**
copy the physical DCO RTL, so it cannot silently re-synthesize the macro.
Add `--elaborate` to compile the generated wrapper with Icarus Verilog.

The example resolves to Core A on ics55 and writes:

```text
resolved.json
rtl/adpll_top.v
rtl/src/*.v + sources.f
macro/config.yaml
macro/build.sh
constraints/adpll.sdc
constraints/clock_ir.json
constraints/freq_lock_cdc.sdc
validation/plan.json
design.lock.json
README.md
```

`design.lock.json` records the spec/resolved hashes, source hashes, macro
parameter hash, per-view hashes, and generated-file hashes.  The package is a
template: it does not run synthesis/PnR/DRC/LVS and never claims production.

`spec.schema.json` documents accepted fields.  `allow_experimental=true`
permits MODEL_ONLY/RTL_SYNTHESIZABLE template generation with `mode=explore`;
`allow_macro_rebuild=true` permits a package with a rebuild plan when a
physical view or structural parameter does not match the built macro.
`allow_unverified_dco=true` permits a physical bring-up package with
`READY_PHYSICAL_UNCHARACTERIZED`; it never grants production eligibility.  Add
`--run-macro-build` to execute the recorded command and re-resolve the macro
identity; without it, the generated `macro/build.sh` is the explicit trigger.

## Physical identity (P1-2)

`physical.py` binds a selection to `macro_inventory.json` and checks:

- selected PDK/cell library against the built macro library;
- `COARSE_NDELS/MID_NDELS/FINE_NDELS/IL_NDELS` parameter hash;
- SHA-256 of LEF/Liberty/CDL/GDS/SPICE views.

It returns `BUILT`, `MISSING_VIEWS`, `LIBRARY_MISMATCH`, or
`PARAMETER_MISMATCH`; only the last three set `needs_rebuild`.  When allowed,
`delivery.py` emits `macro/build.sh` with the rebuild command.  The
architecture selector also prefers the library named by the macro inventory,
so an ics55 build does not silently select H7CH when the built macro is H7CR.
`flow/selection.example.json` is aligned with the H7CR macro identity.

## Frequency measurement (P0-5)

`freq_lock.v` now uses the filtered count for acquisition/lock, defaults
`LOCK_TOL=1`, and exposes a measurement interface separate from control:

```text
SAMPLE_VALID
MEASURED_COUNT
CNT_EXTRA_BITS   (default 8; internal counter is CNT_BITS + extra)
MEAS_PERIODS     (default 1; completed measurement window)
```

The 16-bit default source counter avoids the old 8-bit wrap at ratio >255;
`freq_lock_overflow_tb.v` checks a 300:1 MID/REF ratio and a four-period
window.  `spec.py` also computes the maximum acquisition ratio from the PDK
architecture ceiling and REF, and blocks generation (`NEEDS_COUNTER_RANGE`) if
`FCW_BITS + CNT_EXTRA_BITS` is too small.  Gray-bus skew/reset requirements
and starter SDC constraints are in `cdc.py` and are emitted as
`constraints/freq_lock_cdc.sdc`.  This is still a
template: a placed CDC extraction/rule check and a multi-corner timing review
remain required.

## Residual limits

- Full PVT/lock/jitter/PEX/DRC/LVS signoff is not claimed for any architecture.
- `macro/build.sh` is generated but not executed automatically by
  `delivery.py`; the caller chooses when to run a long macro build.
- CDC skew values are starter constraints, not post-layout measurements.
- `--elaborate` checks generated wrapper connectivity with Icarus Verilog; it
  is not synthesis, place-and-route, or OpenSTA signoff.
- `top-integration` treats the selected top as one hard-macro blackbox; a
  partition that needs internal Gray-bus constraints must apply the
  macro-build/simulation constraint set inside that partition.

## Frequency acquisition research candidates

`src/frequency_counter_frontend.v` makes the DCO-domain counter replaceable:
synchronous binary (default), asynchronous ripple, or a 4-stage Johnson
prescaler/extension.  Only the synchronous mode is marked `CDC_SAFE`; the
alternate modes are explicit experiments because their multi-bit state can be
asynchronous/glitchy at a REF capture.  `freq_lock.v` defaults to
`FRONTEND_MODE=0` and preserves the existing Gray-sample handshake.

`src/freq_search_sar.v` is an optional two-stage binary-search controller.  It
refuses to start unless `MONOTONIC_MAP_VALID` is high, and it reports
`FALLBACK` rather than taking ownership of the DCO codes for an unproven map.
Eight comparison decisions for 16x16 is not eight REF cycles to lock; settling,
observation windows, retries and phase acquisition remain.

`src/dco_tuning.py` validates measured coarse/mid maps, computes code-to-code
KDCO and reports PVT spread.  It does not synthesize missing corners.
`src/dco_tuning_map.schema.json` defines the evidence contract.  No production
DCO/PVT map is committed.

`src/isf_sampling.py` adds edge-dense adaptive ISF phase sampling and a reuse
gate based on RMS/integrated `h^2` error.  The DCO is not a simple symmetric
ring, so 2*pi/M ISF reuse is not assumed.
