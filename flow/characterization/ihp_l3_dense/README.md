# IHP SG13G2 L3 dense fine-bank check

This is a 31-point fine-bank scan at `coarse=8, mid=0` (fine `0..31`, one point
missing).  It was added to test whether the non-monotonic sparse points were
real or caused by the 100 ns startup/measurement window.

## Data

```text
points:  31
range:   274.37 .. 301.89 MHz
fine 0:  301.89 MHz
fine 8:  278.67 MHz
fine 31: 274.37 MHz
```

The 30 ns sweep produced two obvious startup truncations:

```text
fine=9   3 edges, apparent 376.3 MHz
fine=19  3 edges, apparent 368.7 MHz
```

Longer rechecks:

```text
fine=9   100 ns -> 286.26 MHz
fine=19  200 ns -> 290.91 MHz
```

These rechecks are used in `dco_tuning_l3.csv`.  The apparent 376/369 MHz
points were not physical oscillation frequencies.

## What remains

The fine bank is still **not monotonic**:

```text
fine 0  301.89 MHz
fine 1  294.04 MHz
fine 2  281.72 MHz
fine 3  297.41 MHz
```

The sparse 100 ns scan at the same codes also differs:

```text
fine 0:  dense 301.89 vs sparse 281.46 MHz
fine 8:  dense 278.67 vs sparse 296.19 MHz
fine 31: dense 274.37 vs sparse 284.22 MHz
```

So the startup/measurement window is not fully resolved.  The sparse and dense
tables are both retained; neither is a production/PVT/jitter signoff.

## Reproduce

```sh
python3 flow/characterization/ihp_l3_dense.py \
  --out /tmp/ihp_l3_dense_run --coarse 8 --mid 0 \
  --fine "$(seq -s, 0 31)" --jobs 2
```

The 100/200 ns rechecks are recorded in `dco_capability_l3.json`.
