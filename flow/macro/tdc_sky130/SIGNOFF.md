# TDC_TOP sky130 status

- Functional model verified (`tdc_top_tb`): SAR binary search over the
  shared DCDL; injected 900 ps -> code 63 (945 ps), and the new
  multi-threshold interpolator flags TDC_HALF=1 (resolved 952.5 ps).

## Stdcell substitutions (this revision)

- **Sub-LSB interpolation via manufactured uncertainty** (replaces the
  "needs a custom arbiter" position): instead of one razor-edge arbiter,
  `ref_d` is fanned to TWO samplers through deliberately unequal clock
  stubs — the late tap goes through a `clkbuf_4` delay stage, an
  intentional/designed timing offset `delta`.  A SIG edge landing
  between the two sampling instants makes the samplers disagree
  (`sig_e & ~sig_l`), interpolating the edge position to ~1/2 LSB.
  All standard cells: 2x `dfrtp` + `clkbuf_4` (confirmed in netlist).
  Coarse verdict still uses the main `ref_d` sampler; the offset one
  only supplies the half bit.
- This is the stdcell realisation of the "use a designed setup/hold
  window as an interpolator" idea — a 1-bit flash-dither TDC.  Widening
  to K staggered taps -> thermometer code -> finer sub-LSB is the same
  pattern, more DFFs.

## PnR signoff — `tdc_pnr02` (clean)

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

Config: `DIE_AREA [0,0,180,160]`, `FP_CORE_UTIL 20`, `RUN_CTS false`.

### Caveats (not claimed)

- TT corner only; no SS/FF/MCSTA, no SPEF, KLayout DRC skipped.
- Delay cells flatten to std cells — the LSB is a library-cell delay,
  not a matched 15 ps.
- The interpolation offset `delta` is a `clkbuf_4` cell delay at one
  corner — not calibrated, so the half-LSB boundary drifts with PVT.
  A matched multi-threshold interpolator would want the offset taps
  drawn from the same matched cell bank as the line.
- A true sub-LSB arbiter (resolution < the sampler aperture) is still a
  custom metastability cell; this interpolator works *around* that by
  spreading the uncertainty across designed offsets instead.
