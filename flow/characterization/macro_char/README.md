# Physical DCO macro characterization

`macro_char.py` is the reproducible runner for the three built DCO macro
families:

| Macro | gf180mcu | sky130 | ihp-sg13g2 |
|---|---|---|---|
| `PLL_RING_DCO_PHYS` | `ring_dco_gf180mcu` | `ring_dco_sky130` | `ring_dco_ihp130` |
| `PLL_COUNTER_DCO_PHYS` | `counter_dco_gf180mcu` | `counter_dco_sky130` | `counter_dco_ihp130` |

Run from the repository root:

```sh
python3 flow/characterization/macro_char.py sta --pdk all --jobs 4
python3 flow/characterization/macro_char.py ring-pvt --pdk all --jobs 3
python3 flow/characterization/macro_char.py ring-tune --pdk all --jobs 2
python3 flow/characterization/macro_char.py counter
python3 flow/characterization/macro_char.py report
```

Outputs:

- `sta_summary.{json,csv}` and `CHARACTERIZATION.md`
- `ring_pvt.{json,csv}` and `ring_tuning.{json,csv}`
- `counter_nco.{json,csv}`
- `work/` — generated decks, logs and raw waves (ignored by git)

## Evidence level

- STA: gate-level OpenSTA on the built macro Verilog, with the PDK corner
  Liberty and the macro SDC. The IHP SPEF exists but its instance naming does
  not match the gate netlist, so it is not silently forced into this run.
- Ring PVT: the built macro cell-level SPICE transient. These views have no
  routed RC parasitics. `gf180mcu` and `ihp-sg13g2` use ngspice; `sky130`
  uses Xyce because the ngspice run does not converge.
- Jitter: deterministic transient period spread. The transient has no device
  noise, so this is **not** random jitter and **not** phase noise. No
  PSS/Pnoise result is claimed.
- Counter/NCO: exact digital TICK quantization plus STA PVT. The ideal
  digital output frequency is PVT-invariant.

## Current headline results

- gf180mcu and IHP ring PVT complete at TT/SS/FF (minimum delay code):
  gf180mcu 21.07/15.74/26.60 MHz and IHP 33.21/20.95/47.58 MHz for
  TT/SS/FF. Period spread is sub-ps to a few ps and is deterministic.
- The sky130 ring RTL `PLL_CELL_NOR2BX1` mapping was corrected (the old
  wrapper produced `!DCO_EN & INJ_WIN` and held `DCO_EN_INJ_WIN` at 0 with
  `INJ_WIN` tied low).  The post-fix minimum-code transient is
  **43.08/27.64/13.48 MHz** for FF/TT/SS (SS is a two-edge one-period
  estimate).  Deterministic period RMS is 4.4 ps (FF) and 36.4 ps (TT);
  do not reuse the old `NO_OSCILLATION` rows.
- sky130 counter setup **passes** all three corners at the 100 MHz TICK
  planning point after the carry-select accumulator change (WNS
  +5.93/+1.47/+7.59 ns; SS max TICK ~117.2 MHz).  gf180mcu and IHP counters
  also pass all three corners.
- No phase-noise or random-jitter signoff is available.
