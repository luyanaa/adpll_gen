# DCO tuning / KDCO / PVT analysis

`dco_tuning.py` consumes measured tuning data; it does not generate or infer
missing measurements.  It validates complete 16-code coarse/mid maps, checks
monotonic direction, reports code-to-code step and KDCO, checks coarse/mid
overlap, and summarizes KDCO spread across supplied PVT corners.

```sh
python3 src/dco_tuning.py --input measured_maps.json \
  --require-corners TT/25C/1.2V SS/-40C/1.08V FF/125C/1.32V \
  --json-out dco_tuning.json --md-out dco_tuning.md
```

A successful run is only a data-validity result.  It is not a silicon/PVT
signoff.  `freq_search_sar.v` must keep `MONOTONIC_MAP_VALID=0` until the map
has been measured for the intended corners and the overlap/step checks pass.
