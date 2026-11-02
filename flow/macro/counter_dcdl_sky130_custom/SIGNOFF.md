# ADDLL_TOP sky130 — custom-cell DCDL variant

Lands the custom **DLY_STAGE** (`flow/custom/sky130/dly_stage_sky130.v`)
as the MID-stage delay cell inside the real `PLL_COUNTER_DCDL` tapped
delay line — not a standalone harness, the actual working DCDL.

## Custom cell landed

- **DLY_STAGE** replaces `MID_DELAY_CELL`'s internals: `clkbuf_1` fast
  leg vs `clkdlybuf4s50_1` slow leg + `mux2_1` select (`SEL`=MUX) +
  `clkinv_1` output.  `B_IN` continues the chain so each stage's fast
  leg is the cumulative path.  59 `clkdlybuf4s50_1` + `mux2_1` +
  `clkinv_1` in the netlist — the whole MID bank is the matched custom
  tap.  The tap step is a *designed* offset between two matched legs,
  not a synthesised NAND3+INV accident.

## PnR signoff — `addll_cust04` (clean)

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

Config: same as `counter_dcdl_sky130` (`DIE_AREA [0,0,180,160]`,
`RUN_CTS false`, TICK+CLK_IN async).  `dly_stage_sky130.v` added.

## SDC addition

The tap-code registers (`coarse/mid/fine_n`, `code_q`) drive the DCDL
MUX selects; the code path ripples **through the delay cells** into the
tap FFs — a quasi-static analog-select path (changes only while EN=0,
settles over many TICKs) misclassified by STA as reg-reg.  Added
`set_disable_timing` on the delay-stage internals (`u_slow`/`u_sel`/
`u_out`/`upp`) so the real reg-reg paths are checked.  Earlier runs
(-9.2/-6.7 WNS) were this same select path before the disable.

### Caveats

- TT corner only; no SS/FF/MCSTA, no SPEF, KLayout DRC skipped.
- The mid tap LSB is now a `clkdlybuf4s50`−`clkbuf_1` delay difference —
  a designed, repeatable offset but still ~hundreds of ps at TT, not a
  calibrated fine LSB.  True matched-bank layout + calibration needed.
- Coarse/fine stages still use the legacy PLL_CELL NAND3/INV taps.
