# CUSTOM_CELLS_TOP sky130 — landing harness

Lands all three sky130 custom/analog cells (`flow/custom/sky130/`) in one
top so the PnR flow proves they place, route and map to named stdcells.
This is the "落地" vehicle for the custom cell library — DLY_STAGE is not
wired into a macro delay line (it would change the DCDL granularity), so
the harness is the honest landing evidence for it.

## Cells landed

- **DLY_STAGE** — `clkbuf_1` fast leg vs `clkdlybuf4s50_1` slow leg +
  `mux2_1` tap select + `clkinv_1` output.  Netlist: `clkdlybuf4s50_1`
  (×9 across the cell's instances), `mux2_1`, `clkinv_1`.
- **ARB_CELL** — `dlxtp_1` latch resolver + `dfrtp_1` decision FF.
  Netlist: `dlxtp_1`, `dfrtp_1`.
- **DUAL_SAMPLER** — `dfrtp_1` + `dfrtn_1` matched pair.
  Netlist: `dfrtp_1`, `dfrtn_1`.

## PnR signoff — `cust_sky01` (clean)

| metric | value |
|---|---|
| unmapped cells | 0 |
| LVS errors | 0 |
| Magic DRC | 0 |
| route DRC | 0 |
| antenna pins | 0 |
| setup WNS / TNS | 0 / 0 |
| hold WNS / TNS | 0 / 0 |

Config: `DIE_AREA [0,0,60,60]`, `FP_CORE_UTIL 30`, `RUN_CTS false`,
clocks REF+CK async-grouped (`macro.sdc.tcl`).

### Caveats

- TT corner only; no SPEF, KLayout DRC skipped.
- The harness proves the cells map/route — it does not exercise them in a
  timing-critical path (DLY_STAGE's tap step is still a library delay
  difference, uncalibrated).
