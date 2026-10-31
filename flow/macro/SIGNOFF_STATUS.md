# Physical DCO signoff status (2026-10-31)

## gf180mcu (DRC/LVS clean)

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| PDK/library | gf180mcu_as_sc_mcu7t3v3 | gf180mcu_as_sc_mcu7t3v3 |
| GDS/LEF/LIB/CDL/DEF | present | present |
| DRC | **0 violations** (KLayout 0.30.7, gf180mcuD, after fill) | **0 violations** |
| LVS | **PASS** (fill-marker exclusion) | **PASS** (fill-marker exclusion) |
| STA | nominal only | nominal only |
| PVT/jitter/KDCO | not characterized | not characterized |

Evidence: `flow/macro/ring_dco_gf180mcu/` and
`flow/macro/counter_dco_gf180mcu/`.

## ics55 (earlier attempt)

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| DRC | not clean (281 raw / 77 unwaived) | not clean (1694 raw / 1413 unwaived) |
| LVS | MISMATCH | no passing LVS |
| STA | nominal interface only | nominal only |

The ics55 results remain recorded under `flow/macro/*_dco_ics55/SIGNOFF.md`.
No PVT or production signoff is claimed for either PDK.
