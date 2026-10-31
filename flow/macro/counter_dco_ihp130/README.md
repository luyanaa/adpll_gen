# Core C counter/NCO on IHP SG13G2

Physical phase-accumulator/NCO macro built with the local ckdur/OpenROAD flow.

- Top: `PLL_COUNTER_DCO_PHYS`
- PDK/library: `ihp-sg13g2` / `sg13g2_stdcell`
- Views: LEF/LIB/GDS/CDL/DEF/Verilog/SPICE/SDC
- LVS: **PASS** with the official IHP deck on the fill-stripped GDS
  (top-port naming waiver)
- DRC: **PASS, 0 violations** with official maximal+density rules after
  legal M2/M3 bar fill (M2 40.61%, M3 40.99%)
- STA: nominal only (`sta.rpt`); no PVT/KDCO/jitter signoff

`PLL_COUNTER_DCO_PHYS` needs an external `TICK`; the macro-level SDC uses a
10 ns TICK and a 100 ns REF.  The macro is not frequency-characterized.
