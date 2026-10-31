# Core C counter DCO / NCO (ics55 H7CR)

This is the physical Core C counter/NCO macro.  It is a standard-cell
phase accumulator, not a behavioral delay model.

- Top: `PLL_COUNTER_DCO_PHYS`
- Clocking: external `TICK`; its frequency is a required spec input. `OUT` toggles on accumulator carry
- Control: unary `COARSE_MUX`, `MID_MUX`, `FINE_MUX`
- Default mapping: `BASE_INC=3493`, `COARSE_STEP=120`, `MID_STEP=60`,
  `FINE_STEP=15`, `ACC_BITS=16`; more unary delay bits reduce the increment,
  matching `pll_logic`'s tuning direction (simulated range about 26.6-2.5 MHz
  at a 1 GHz TICK; the generator requires the actual tick_frequency_mhz and
  applies the /2 carry-toggle factor)
- Views: `PLL_COUNTER_DCO_PHYS.lef`, `.lib`, `.def`, `.gds`, `.v`
- Size: 96.303 x 102.703 um
- Build: `librelane flow/macro/counter_dco_ics55/config.yaml` (or the recorded
  inventory build command)

The LibreLane bring-up completed placement/routing and generated views, but
reported KLayout DRC errors (about 1,588 at the time of the run) and no LVS.
There is no CDL view and no timing/PVT/jitter characterization.  This is a
physical bring-up artifact, not a signoff-qualified hard macro.

A clean checkout must rebuild the ignored generated views before claiming
`BUILT` in `macro_inventory.json`.
