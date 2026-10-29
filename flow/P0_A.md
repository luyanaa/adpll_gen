# P0-A correctness fixes (first batch)

This is the first implementation pass from the P0 review.  It changes RTL and
testbenches only; no P&R, PDK or DCO characterization is changed.

## Fixed

| Item | File | Change |
|---|---|---|
| DSM positive saturation | `src/delta_sigma.v` | `{(BITS_INT){1'b1}}`; also handles `BITS_INT<4` without a negative repeat width |
| Divider /1 ambiguity | `src/conf_div.v`, `src/fix_div.v` | `DIV<2` is rejected/clamped; a registered divider cannot produce true /1 |
| Parameter passing | `src/pll.v` | `pll_logic` parameters are no longer behind `SIMULATION`; post-synth still uses the baked netlist |
| Locked semantics | `src/pll_logic.v`, `src/pll.v`, `src/pll_logic_bb.v` | added `PHASE_LOCK` / `LOCK_LOST`; `LOCKED` is no longer a constant wait counter |
| Frequency-count CDC | `src/freq_lock.v` | MID_OUT binary count is Gray-coded; toggle handshake + 2FF synchronizer + REF-domain binary conversion |
| Stale freq-lock TB | `src/freq_lock_tb.v` | updated to `MID_OUT`/`OUT`/`LOCK`/`FORCE_*` ports |

## Tests

```sh
cd sim
make test_p0 PDK=ihp-sg13g2 USE_DOCKER=0
```

Current result:

```text
delta_sigma_sat_tb: PASS
divider_tb: PASS
lock_fsm_tb: PASS
```

The focused tests are:

```text
src/delta_sigma_sat_tb.v
src/divider_tb.v
src/lock_fsm_tb.v
src/sim_dco_lock.v (frequency-lock smoke model)
```

## Still open in P0-A

- `PHASE_LOCK` is an input; a real fine-stage phase detector / lock-loss
  detector is not implemented yet.  The FSM now refuses to assert `LOCKED`
  without it, but the source is still a testbench/interface signal.
- The CDC test should be extended with random phase relationships and a
  snapshot-valid monitor, not just the current lock-FSM smoke.
- `pll.v` still needs a full closed-loop elaboration / simulation with the
  actual `PLL_ANALOG` model.
- No full STA/CDC signoff or P&R rerun is claimed from this batch.

## Next P0-A items

1. Formal CDC test: REF/MID_OUT arbitrary phase, Gray snapshot consistency.
2. `pll_macro_top` integration with unified parameters and the real macro.
3. Negative tests: DCO freeze, counter off-by-one, SS-BBPD polarity inversion,
   frequency step and reacquisition.
