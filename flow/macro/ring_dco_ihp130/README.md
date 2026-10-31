# Core B ring DCO on IHP SG13G2

Physical ring-DCO macro built with the local ckdur/OpenROAD flow.

- Top: `PLL_RING_DCO_PHYS`
- PDK/library: `ihp-sg13g2` / `sg13g2_stdcell`
- Placement: automatic (`SKIP_PLL_POS=1`), no analog symmetry claim
- Views: LEF/LIB/GDS/CDL/DEF/Verilog/SPICE/SDC
- DRC: **0 violations** with the ORFS `sg13g2_minimal.lydrc` deck on the
  density-filled GDS
- LVS: **PASS** with the ORFS `sg13g2.lvs` deck on the fill-stripped GDS
- STA: nominal only (`sta.rpt`); no PVT/KDCO/jitter signoff

The local PDK root does not include the official IHP DRC/LVS decks.  These
checks use the ORFS minimal deck and a flow-local dummy-fill exclusion; they
are not a foundry/Calibre signoff.
