# ics55 full-grid L3 DCO scan (16 ps)

This is the user-selected full 16 × 16 × 32 = **8192-point** ics55 L3 code
cube.  It uses a 16 ps transient time step, adaptive 3/4/6 ns windows, 8
parallel workers, and an incremental CSV so an interrupted run can resume.

```sh
python3 flow/characterization/ics55_l3_dense.py \
  --out flow/characterization/ics55_l3_full_16p \
  --all-grid --fine "$(seq -s, 0 31)" \
  --jobs 8 --tstep 16p --timeout 300
```

16 ps is a coarse step for a ~0.5 ns period; this table is a full-code
screening map, not the 1-4 ps signoff table.  `dco_tuning_l3.csv` and
`dco_l3.json` are written when all points complete.
