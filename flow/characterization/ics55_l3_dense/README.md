# ics55 L3 dense-axis DCO baseline

This extends the 27-point sparse ics55 L3 scan with a full fine-bank sweep at
selected coarse/mid boundaries.

## Data

```text
points: 110
range:  703.235 .. 1895.735 MHz
fine-bank coverage:
  c0/m0    fine 0..31
  c0/m15   fine 0..31
  c8/m0    fine 0..26 and 31
  remaining coarse/mid combinations: sparse fine {0, 8, 31}
```

All measured fine sweeps are monotonic; zero fine inversions.

`c8/m0:fine=27..30` exceeded the 300 s per-point timeout in the parallel batch.
That is recorded as a run-time limitation, not as a valid/invalid code claim.
`coarse=15` is still represented by the sparse corner points only.

## Reproduce

```sh
python3 flow/characterization/ics55_l3_dense.py \
  --pairs 0:0,0:15,8:0 --fine "$(seq -s, 0 31)" --jobs 2
```

The script writes each point incrementally to `dco_tuning_l3_partial.csv`; the
final tracked table is `dco_tuning_l3.csv`.

## Status

```text
L3 transistor:       dense-axis, pre-PEX
L3 PEX:              one code in ../pex_ics55
PVT:                 one code in ../pex_ics55
jitter/phase noise:  not run
```

This is still not a production/PVT/jitter signoff.
