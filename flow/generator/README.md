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

FAIL_OUT_OF_RANGE      Target is outside the measured L1 range.

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

# Planning/exploration: MODEL_ONLY Core B/C are allowed, but never returned
# as a physical build.
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
  `PHYSICAL_IMPLEMENTABLE` (currently Core A) or `CHARACTERIZED` entries.
- `--mode explore` permits `MODEL_ONLY` Core B/C simulation candidates, but
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
| Core B ring DCO | simulation model | `src/pll_ring_dco.v`, `src/arch_models_tb.v` |
| Core C counter DCO | simulation model | `src/pll_counter_dco.v`, `src/arch_models_tb.v` |
| Core A dual loop | partial RTL | `src/freq_lock.v`, `src/digital_loop_filter.v` |
| Fractional / DSM | partial RTL | `src/delta_sigma.v`, `src/pll_logic.v` |
| Segmented / hybrid / low-res TDC / multi-phase | roadmap | not selectable by default |

Core B/C models are behavioral RTL, not hardened macros and not DCO/PVT
signoff.  Their catalog model ranges are 20–109 MHz and 2.5–26.5 MHz,
respectively; the wider catalog bands are architecture targets, not measured
model limits.  Core C additionally requires an external 1 GHz tick and is
therefore an NCO/digital clock synthesizer candidate, not a standalone DCO
claim.

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

## Remaining generator gaps

The following are intentionally still open; this repository is a planner and
capability gate, not a closed-loop GDS generator:

- `Specification -> ResolvedDesign -> RTL/macro/SDC/validation -> package`
  does not exist yet (P1-3).
- There is no automatic re-build of a hard macro when structural parameters
  change, and no `design.lock.json` physical-view hash (P1-2).
- `pll.v` does not yet expose every new lock parameter, and the canary
  selection/demo manifest is not reconciled with a built macro identity.
- Frequency measurement still uses a fixed-width counter; the measured ratio
  must remain below the `CNT_BITS` wrap limit.  A separate
  `freq_measure`/`sample_valid`/`overflow` interface is the next refactor (P0-5).
  `freq_lock.v` now exposes `SAMPLE_VALID`/`MEASURED_COUNT`, but does not yet
  detect overflow or provide a multi-period measurement window.
- Gray-bus physical skew, synchronizer placement/reset constraints, and a
  CDC rule check are not automated; the RTL CDC test is not a layout signoff.
- Full PVT/lock/jitter/PEX signoff is not claimed for any architecture.
