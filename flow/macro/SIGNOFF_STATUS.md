# 2026-10-31 physical DCO signoff status

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| GDS/LEF/LIB/DEF | present | present |
| Native CDL | present | no |
| STA (nominal, interface) | positive setup/hold | positive setup/hold |
| DRC | **not clean**: 281 raw / 77 unwaived after cell-internal waiver | **not clean**: 1694 raw / 1413 unwaived |
| LVS | **MISMATCH** (flat attempt) | **no passing LVS** |
| PVT / jitter / KDCO | not characterized | not characterized |

Timing reports are `flow/macro/*/sta.rpt`.  DRC/LVS logs are under
`signoff/reports/ics55/` and macro-level `SIGNOFF.md` files.  These results do
not support a DRC/LVS/timing/PVT signoff claim.
