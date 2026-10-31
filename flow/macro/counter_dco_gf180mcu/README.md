# Core C counter/NCO on gf180mcu

This is the DRC/LVS-clean second-PDK physical variant of
`PLL_COUNTER_DCO_PHYS`.

- Top: `PLL_COUNTER_DCO_PHYS`
- PDK/library: `gf180mcu_as_sc_mcu7t3v3` (3.3 V)
- Flow: LibreLane P&R + local `def2stream` + GF180 density fill
- Views: `LEF/LIB/GDS/CDL/DEF/Verilog/SPICE` in this directory
- DRC: **0 violations** (KLayout 0.30.7, `gf180mcuD`, `variant=D`, after density fill)
- LVS: **PASS** (KLayout GF180 LVS with flow-local fill-marker exclusion)
- STA: nominal only (`sta.rpt`); no PVT/jitter signoff

The macro is a digital phase accumulator/NCO and requires an external `TICK`.
Its frequency range/KDCO are not characterized by this DRC/LVS run.
