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
                       Architecture selected and the DCO manifest accepts the
                       target; still not production/PVT/jitter signoff.

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
# ETRI: low frequency + area sensitive -> Core C counter
python3 flow/generator/architecture.py --pdk ETRI050_fd_sc_12t \
  --target-mhz 5 --area high

# GF180 AS: 100 MHz -> Core B ring
python3 flow/generator/architecture.py --pdk gf180mcu_as_sc_mcu7t3v3 \
  --target-mhz 100 --area medium --ref-mhz 50

# ics55: high-frequency segmented IL-DCO (experimental above the 479 MHz
# conservative SS ceiling)
python3 flow/generator/architecture.py --pdk ics55 \
  --target-mhz 800 --area medium --ref-mhz 100

# Emit a per-block selection template for validate_selection.py
python3 flow/generator/architecture.py --pdk gf180mcu_as_sc_mcu7t3v3 \
  --target-mhz 100 --area medium --ref-mhz 50 \
  --emit-selection /tmp/selection.json
python3 flow/validate_selection.py --selection /tmp/selection.json
```

Selection rules:

- `<150 MHz`: Core C counter / ring path; `--allow-low-res` enables the
  low-res TDC/bang-bang cost fallback.
- `150–500 MHz`: Core B ring / hybrid.
- `>=500 MHz`: Core A IL-DCO / segmented IL-DCO, then dual-loop or
  fractional variants when requested.
- `--area high`: limits the DCO area rank and forces Core C for `<150 MHz`.
- `--fractional`, `--low-jitter`, `--fast-lock`, `--wide-range`: hard feature
  filters, not suggestions.
- A target above the conservative PDK signoff ceiling but below the measured
  architecture ceiling is returned as experimental with an explicit warning.
- `--require-signoff` rejects targets above the conservative PDK signoff
  ceiling instead of returning an experimental architecture.
- `production_eligible` is always `false` in this layer.  It requires a DCO
  L3/PEX/PVT manifest, closed-loop lock/jitter, and DRC/LVS evidence.

`pdk_profiles.json` holds the measured architecture/signoff ceilings and
maturity.  `architecture_catalog.json` holds the structure ranges, area ranks,
PDK classes, complexity, and features.
