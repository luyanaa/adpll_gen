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
| Fine-stage lock detector | `src/lock_detector.v` | SS-BBPD no-symbol run detector; loss on repeated non-no-symbol / filter saturation |
| Detector regression | `src/lock_detector_tb.v` | lock, loss, relock and saturation-loss checks |
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
lock_detector_tb: PASS
lock_fsm_tb: PASS
freq_lock_tb: PASS
```

The focused tests are:

```text
src/delta_sigma_sat_tb.v
src/divider_tb.v
src/lock_detector_tb.v
src/lock_fsm_tb.v
src/freq_lock_tb.v (with src/sim_dco_lock.v)
```

## Still open in P0-A

- `PHASE_LOCK` is now driven by the on-chip `pll_lock_detector` from
  SS-BBPD; the detector is a no-symbol run detector, not a phase-noise or
  calibrated phase-error measurement.  Its LOCK_COUNT/LOSS_COUNT are still
  fixed in `pll_logic` (16/4).
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
