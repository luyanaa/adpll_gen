# ics55 DCO L1 behavioral characterization

This directory contains the first **L1** DCO tuning scan.  It uses
`src/sim_dco.v`, whose delay tables came from the existing ics55 delay
characterization.  It is not a PEX/transistor-level, PVT, jitter or phase-noise
signoff result.

## Data

```text
dco_tuning.csv   512 points
dco_tuning.json  model/grid metadata
```

Scan grid:

```text
coarse_code = 0, 5, 10, 15
mid_code    = 0, 5, 10, 15
fine_code   = 0 .. 31
```

Codes are thermometer codes: a code of `k` sets the low `k` bits.  Increasing
coarse/mid creates more delay and lowers the frequency; increasing fine also
lowers the frequency.  The full range in this sparse scan is:

```text
f_min = 779.392853 MHz
f_max = 4186.377528 MHz
```

Example points:

```text
coarse=0,  mid=0,  fine=0   -> 4186.38 MHz
coarse=5,  mid=0,  fine=0   -> 1704.65 MHz
coarse=10, mid=0,  fine=0   -> 1084.33 MHz
coarse=15, mid=0,  fine=0   ->  801.52 MHz
```

## Re-run

```sh
python3 flow/characterization/dco_sim_scan.py \
  --output flow/characterization/ics55_sim
```

The script generates a temporary testbench from `src/sim_dco.v`, compiles it
with Icarus, and writes the CSV/JSON.

## What is missing

- Dense scan of all `16 x 16 x 32 = 8192` codes.
- PVT corners (the behavioral model has no temperature/supply dependence).
- PEX/transistor-level DCO and injection response.
- Startup time, duty cycle, current, and jitter/phase noise.
- A generator capability manifest that rejects codes outside the measured
  monotonic/valid range.

The data is suitable for L1 control-algorithm exploration and for selecting
candidate codes; it is not suitable for a PVT or noise signoff.
