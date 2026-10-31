# Core C counter/NCO on IHP SG13G2

Physical phase-accumulator/NCO macro built with the local ckdur/OpenROAD flow.

- Top: `PLL_COUNTER_DCO_PHYS`
- PDK/library: `ihp-sg13g2` / `sg13g2_stdcell`
- Views: LEF/LIB/GDS/CDL/DEF/Verilog/SPICE/SDC
- DRC: **0 violations** with the ORFS `sg13g2_minimal.lydrc` deck on the
  density-filled GDS
- LVS: **PASS** with the ORFS `sg13g2.lvs` deck on the fill-stripped GDS
- STA: nominal only (`sta.rpt`); no PVT/KDCO/jitter signoff

`PLL_COUNTER_DCO_PHYS` needs an external `TICK`; the macro-level SDC uses a
10 ns TICK and a 100 ns REF.  The macro is not frequency-characterized.
