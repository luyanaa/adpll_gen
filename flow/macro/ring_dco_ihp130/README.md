# Core B ring DCO on IHP SG13G2

Physical ring-DCO macro built with the local ckdur/OpenROAD flow.

- Top: `PLL_RING_DCO_PHYS`
- PDK/library: `ihp-sg13g2` / `sg13g2_stdcell`
- Placement: automatic (`SKIP_PLL_POS=1`), no analog symmetry claim
- Views: LEF/LIB/GDS/CDL/DEF/Verilog/SPICE/SDC
- DRC: **0 violations** with the official IHP maximal+density deck on the
  legal filled GDS
- LVS: **PASS** with the official IHP deck on the fill-stripped GDS
  (top-port naming waiver)
- STA: nominal only (`sta.rpt`); no PVT/KDCO/jitter signoff

The official IHP KLayout deck is available through the local CIEL checkout;
see `OFFICIAL_SIGNOFF.md`.  The pass still uses a top-port naming waiver and is
not a Calibre/foundry signoff.
