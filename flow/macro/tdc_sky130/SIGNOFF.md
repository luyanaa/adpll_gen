# TDC_TOP sky130 status

- Functional model verified (`tdc_top_tb`): SAR binary-searches the DCDL
  code until the delayed REF edge meets SIG; 0.9 ns injected -> code 63
  = 945 ps, within ~3 LSB at the 15 ps/LSB model.

## PnR signoff — `tdc_pnr01` (clean, first pass)

| metric | value |
|---|---|
| unmapped cells | 0 |
| LVS errors | 0 |
| Magic DRC | 0 |
| route DRC | 0 |
| antenna pins | 0 |
| max slew / cap | 0 / 0 |
| setup WNS / TNS | 0 / 0 |
| hold WNS / TNS | 0 / 0 |

Config: `DIE_AREA [0,0,180,160]`, `FP_CORE_UTIL 20`,
`PL_TARGET_DENSITY_PCT 40`, `RUN_CTS false`, clocks `TICK`/`REF`
async-grouped (`macro.sdc.tcl`).

### Caveats (not claimed)

- TT corner only; no SS/FF/MCSTA, no SPEF, KLayout DRC skipped (Magic
  used).  Delay cells flattened to std cells, so the measured LSB is a
  library-cell delay, not the matched 15 ps model.
- The `sig_q` sampler is a plain DFF — no metastability/arbiter cell,
  so real resolution is ±1 LSB, not sub-LSB.
- Assumes a repetitive REF/SIG pair (one fresh edge per SAR step).
