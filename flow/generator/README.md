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
```

The current ics55 manifest is:

```text
flow/characterization/ics55_sim/dco_capability.json
```

At 1600 MHz the gate returns `PASS_L1_EXPERIMENTAL` with the closest
coarse/mid/fine candidates, an explicit `production_eligible: false`, and the
measured-frequency error.  IHP has no capability manifest yet, so it returns
`FAIL_UNCHARACTERIZED`.

## Why this is not a generator PASS

A real generator should only emit a production design after:

- L3/PEX DCO characterization;
- PVT corners;
- closed-loop lock/lock-loss and jitter checks;
- a real macro model in `pll_macro_top`.

The gate is deliberately conservative.  Add `FAIL_UNCHARACTERIZED` rather
than a guessed frequency when the evidence is missing.
