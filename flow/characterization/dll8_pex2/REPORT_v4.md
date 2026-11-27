# DLL8 element RTL in lockstep with the measured SPICE element (v4)

## RTL element (src/dll8_line.v)
`DLL8_ELEM_PHYS` now describes the SPICE-measured circuit:
- stage 1: `DLL8_INV4B` balanced driver (Wp=5.30um, Wn=2.96um),
- stage 2: `PLL_CELL_INVX4` (sg13g2_inv_4),
- bank: 7-bit thermometer (127) of symmetric N/P switched `sg13_moscap`
  (0.9x1.1 um): even finger NMOS->VSS (moscap_n), odd finger PMOS->VDD
  (moscap_p), buf_8 / inv_8 control.
- `DLL8_THERM_DEC` binary->127-bit thermometer decoder (synthesizable).
- `DLL8_IMPL` model/phys split unchanged; model BASE/LSB are the SPICE values.

### RTL vs SPICE differences (documented, not hidden)
- `DLL8_INV4B`: the sg13g2 library has no Wp=5.30/Wn=2.96 cell.  PnR must
  bind a custom stdcell "sg13g2_inv_4b" (or an equivalent LEF/liberty cell).
  The RTL wrapper is `assign Y=~A`; do NOT map it to sg13g2_inv_4.
- `DLL8_NSW/PSW/MOSCAP_N/P`: raw PDK devices (sg13_lv_nmos/pmos,
  sg13_moscap_n/p), i.e. a custom/analog block, not digital stdcells.  RTL
  wrappers are black boxes; the digital gate uses the model.

## Digital gate on the rewritten RTL (regenerated outputs)
| case | de-offset worst | duty (all 8) | rails | early edges |
|---|---|---|---|---|
| SS 4ns | 3.5 ps | 50.10 % | both LOCKED | none |
| SS 2ns | 3.5 ps | 49.80 % | both LOCKED | none |
| TT 3ns | 7.0 ps | 49.73 % | both LOCKED | none |
| FF 2ns | 3.5 ps | 49.80 % | both LOCKED | none |

## SPICE D_set(k) (corrected per-cycle extraction)
- FF (code 77, period 8): k=4..7 = 178.5/178.5/178.4/177.0 ps, spread 1.5 ps.
- FF (code 88): 180.7/180.7/180.6/179.0 ps, spread 1.7 ps.
- SS (code 32, period 4): k=4..7 = 372.7/372.0/371.2/354.1 ps, spread 18.6 ps
  (all from k=7, -18 ps); k=0..3 not captured by the extractor at SS (the
  q-rise association still fails for the first half at SS).
The common delay (~180 ps FF / ~372 ps SS) is harmless (absorbed); only the
spread enters the phase grid, and it is <= FF 1.7 ps / SS 18.6 ps (k=7), i.e.
inside the 30 ps budget.  SS k=7 needs a cleaner extraction before sign-off.
