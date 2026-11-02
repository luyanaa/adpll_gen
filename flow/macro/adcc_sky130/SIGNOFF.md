# ADCC_TOP sky130 status

- Functional model verified (`adcc_top_tb`): async averaging duty
  sampler + DCDL falling-edge correction; 30% input -> 49.6% output at
  code 40, clean 4.0 ns period, no glitches.

## PnR signoff — `adcc_pnr01` (clean, first pass)

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
three async clock domains `TICK`/`CLK_IN`/`SAMP` (`macro.sdc.tcl`);
`CLK_OUT` false-pathed (a corrected clock, not sync data).

### Caveats (not claimed)

- TT corner only; no SS/FF/MCSTA, no SPEF, KLayout DRC skipped.
- Delay cells flattened to std cells — real fall-delay LSB is a
  library-cell delay, not the 15 ps model.
- `SAMP` must be incommensurate with `CLK_IN` (a coherent sampler
  aliases the duty readout); the macro relies on the system providing
  it.  Averaging PD assumes `SAMP`/`CLK_IN` have no rational relation.
- OR recombine `CLK_IN | ~fall_d` can re-expose a stale high pulse if
  `fall_d` delay exceeds the low half-period — the functional model
  keeps the code in range, but silicon needs a pulse-swallow combiner
  and quiet-window tap updates (documented in ADCC_SPEC).
