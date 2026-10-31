# Ring DCO sky130 experiment result

- DRC: sky130A KLayout DRC, **0 violations**
- LVS: **FAIL**; no signoff claim.  The shipped `macro_sparecell` CDL had a
  pin-count error and was removed from the flow-local schematic; the
  remaining top/cell device comparison still mismatches.
- Evidence: `PLL_RING_DCO_PHYS_drc.lyrdb`, `PLL_RING_DCO_PHYS_drc.log`,
  `PLL_RING_DCO_PHYS_lvs.log`, `PLL_RING_DCO_PHYS_extracted.cir`
