# Core B ring-DCO signoff status

## Timing
`sta.rpt` is a nominal TT/1.2 V/25 C OpenSTA interface report.  It reports
positive setup/hold slack, but COARSE/MID/FINE are constrained as quasi-static
asynchronous controls and OUT/MID_OUT are free-running outputs.  This is not a
DCO/PVT/jitter timing signoff.

## DRC
A KLayout `ics55_drc.drc` run on the routed macro (plus density fill) reports
**281 raw violations**: mostly cell-internal metal/implant, with top-level
active/poly density and boundary items.  The cell-internal waiver reduces the
remaining unwaived set to **77** (including top-level density/boundary items).
The macro is therefore **not DRC-clean**.

Logs: `signoff/reports/ics55/PLL_RING_DCO_PHYS_drc.log`,
`signoff/reports/ics55/PLL_RING_DCO_PHYS_drc.summary`,
`drc.waiver.md`.

## LVS
The flat KLayout LVS comparison reports **MISMATCH** (many schematic nets have
no layout match; device pairs mismatch).  The macro is **not LVS-clean**.
Log: `signoff/reports/ics55/PLL_RING_DCO_PHYS_lvs_flat.log` and
`lvs.summary.txt`.

The GDS/LEF/LIB/CDL/DEF views are physically generated, but no DRC/LVS/PVT
signoff is claimed.
