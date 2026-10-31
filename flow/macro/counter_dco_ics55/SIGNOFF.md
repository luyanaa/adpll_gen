# Core C counter/NCO signoff status

## Timing
`sta.rpt` is a nominal TT/1.2 V/25 C OpenSTA report using the macro Liberty and
TICK=1 ns / REF=10 ns planning constraints.  It reports positive setup and hold
slack.  This is not a multi-corner timing/PVT signoff.

## DRC
KLayout `ics55_drc.drc` on the generated GDS reports **1694 raw violations**,
mostly cell-internal `M1DUM_W_1`, implant and metal-area rules, plus top-level
active density.  The cell-internal waiver leaves **1413** unwaived because the
library waiver list does not cover all 7T cells used by this synthesis.  The
macro is **not DRC-clean**.

Logs: `signoff/reports/ics55/PLL_COUNTER_DCO_PHYS_drc` (when generated) and
`drc.waiver.md`.

## LVS
There is no native OpenROAD CDL for this LibreLane macro.  A generated CDL was
used to attempt flat LVS; it did not produce a passing comparison.  The macro is
**not LVS-clean** and has no native CDL view.

The GDS/LEF/LIB/DEF views are physical bring-up artifacts, not signoff views.
