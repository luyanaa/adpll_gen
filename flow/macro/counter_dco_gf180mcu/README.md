# Core C counter/NCO on gf180mcu

This is the DRC/LVS-clean second-PDK physical variant of
`PLL_COUNTER_DCO_PHYS`.

- Top: `PLL_COUNTER_DCO_PHYS`
- PDK/library: `gf180mcu_as_sc_mcu7t3v3` (3.3 V)
- Flow: LibreLane P&R + local `def2stream` + GF180 density fill
- Views: `LEF/LIB/GDS/CDL/DEF/Verilog/SPICE` in this directory
- DRC: **0 violations** (KLayout 0.30.7, `gf180mcuD`, `variant=D`, after density fill)
- LVS: **PASS** (KLayout GF180 LVS with flow-local fill-marker exclusion)
- STA: nominal `sta.rpt` plus 3-corner characterization; no transistor-level counter PVT/phase-noise claim

The macro is a digital phase accumulator/NCO and requires an external `TICK`.
Its NCO quantization and STA corners are characterized by `macro_char`; no transistor-level frequency/PVT KDCO is claimed.

- Characterization: gate-level STA TT/SS/FF PASS; NCO quantization at
  100 MHz TICK is 380/370 ns (pp 10 ns, RMS 4.985 ns). No transistor-level
  counter PVT frequency or phase-noise claim. See
  `flow/characterization/macro_char/CHARACTERIZATION.md`.
