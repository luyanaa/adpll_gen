# Counter/NCO sky130 experiment result

- DRC: sky130A KLayout DRC, **0 violations**
- LVS: **FAIL**; no signoff claim.  Top/cell netlist comparison still
  mismatches with the native cell CDL.
- Evidence: `PLL_COUNTER_DCO_PHYS_drc.lyrdb`, `PLL_COUNTER_DCO_PHYS_drc.log`,
  `PLL_COUNTER_DCO_PHYS_lvs.log`, `PLL_COUNTER_DCO_PHYS_extracted.cir`
