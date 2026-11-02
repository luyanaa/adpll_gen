# TDC_TOP sky130 — custom-cell variant

Lands the **custom ARB_CELL** (`flow/custom/sky130/arbiter_sky130.v`) as
the edge-comparison arbiter, replacing the bare stdcell DFF.  The
custom cells are "落地"d — wired into the macro RTL and through PnR.

## Custom cells landed

- **ARB_CELL** (`u_arb`): the main `ref_d`/`SIG` comparator is now a
  `dlxtp_1` transparent-latch resolver + `dfrtp_1` decision FF — a real
  latch+FF arbiter, better MTBF and a narrower indeterminate band than
  a bare DFF.  Confirmed in netlist: `dlxtp_1` mapped.
- **Half-LSB interpolator** retained: second `dfrtp` sampler on a
  `clkbuf_4`-offset `ref_d` stub → `TDC_HALF`.  Netlist: `clkbuf_4`.
  (This is the manufactured-uncertainty trick; the ARB_CELL handles the
  coarse verdict, the offset pair handles sub-LSB.)

## PnR signoff — `tdc_cust01` (clean)

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

Config: `DIE_AREA [0,0,180,160]`, `FP_CORE_UTIL 20`, `RUN_CTS false`,
clock `TICK`+`REF`.  `arbiter_sky130.v` added to VERILOG_FILES.

### Caveats

- TT corner only; no SS/FF/MCSTA, no SPEF, KLayout DRC skipped.
- The arbiter's resolution band is set by the `dlxtp_1` aperture at one
  corner — not characterised; true sub-aperture resolution still wants
  a sized comparator (custom analog layout).
- Delay cells still flatten to stdcells — LSB is a library delay.
- The `clkbuf_4` interp offset drifts with PVT (uncalibrated).
