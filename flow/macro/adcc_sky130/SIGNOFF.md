# ADCC_TOP sky130 status

- Functional model verified (`adcc_top_tb`): async averaging duty
  sampler + DCDL falling-edge correction; 30% input -> 49.6% output at
  code 40, clean 4.0 ns period, no glitches.

## Stdcell substitutions (this revision)

- **Pulse-swallow combiner**: `CLK_IN | ~fall_d` replaced by a NOR
  SR-latch (`setb=~CLK_IN`, `rstb=~(fall_d & clk_n)`).  S/R are mutually
  exclusive by construction and an overshoot edge is swallowed rather
  than re-exposing the old high pulse.  Synthesises to `dlxtn` + NOR
  cells — all std cells.  `/* verilator lint_off LATCH */` wraps the
  intentional latch.
- **Quiet-window tap gating**: tried (`upd_ok = EN && CLK_IN~^fall_d`)
  and reverted — once the loop overshoots the delay past the low
  half-period the idle window vanishes and the taps freeze
  mid-acquisition (deadlock).  Taps update every TICK; the pulse-swallow
  combiner removes the observable glitch.  Physical matched-MUX
  switching is what keeps tap changes clean in silicon.
- The latch-D input path (`CLK_IN -> dlxtn`) is a level path, not a
  synchronous input: `set_false_path -from CLK_IN -to [all_registers]`
  in `macro.sdc.tcl` waives it.

## PnR signoff — `adcc_pnr04` (clean)

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
