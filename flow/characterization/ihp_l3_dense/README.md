# IHP SG13G2 L3 dense fine-bank check

This is the **100 ns** fine-bank scan at `coarse=8, mid=0` (fine `0..31`).
It replaces the earlier 30 ns exploratory sweep, whose 376/369 MHz points were
startup transients.

## Data

```text
points:  32
range:   275.64 .. 354.08 MHz
fine 0:  281.46 MHz
fine 8:  296.19 MHz
fine 31: 284.22 MHz
```

The 100 ns values at fine 0/8/31 match the sparse 100 ns table exactly:

```text
sparse f0  281.455160
sparse f8  296.189492
sparse f31 284.222519
```

## Residual non-monotonicity

The fine bank is still not monotonic at 100 ns:

```text
fine 16  287.56 MHz
fine 17  322.73 MHz
fine 18  281.28 MHz
fine 19  354.08 MHz
fine 23  306.98 MHz
```

There are 15 rising steps in the fine sweep.  This is no longer a simple
30 ns startup artifact: the sparse and dense 100 ns points agree at the
overlap, while the interior fine codes have large local outliers.  The likely
causes are the fine-bank mux mapping/loading or a stable but different
oscillation mode; this needs circuit-level debug, not more averaging.

## Reproduce

```sh
python3 flow/characterization/ihp_l3_dense.py \
  --out /tmp/ihp_dense_100 --coarse 8 --mid 0 \
  --fine "$(seq -s, 0 31)" --jobs 4 --stopsim-ns 100
```

## Status

```text
L3 transistor frequency:  measured, 100 ns
monotonic fine bank:      FAIL (15 rising steps)
PEX/PVT:                  c8/m8/f8 only, ../pex_ihp
jitter/phase noise:       not run
```
