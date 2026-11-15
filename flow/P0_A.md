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
| Macro integration wrapper | `src/pll_macro_top.v` | binds `pll_logic` to `PLL_ANALOG_MACRO` with a single parameter set |
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
freq_lock_cdc_tb: PASS (100 checks, no X)
pll_macro_top smoke: PASS, LOCKED=1 (behavioral sim_* models)
```

The focused tests are:

```text
src/delta_sigma_sat_tb.v
src/divider_tb.v
src/lock_detector_tb.v
src/lock_fsm_tb.v
src/freq_lock_tb.v (with src/sim_dco_lock.v)
src/freq_lock_cdc_tb.v
src/pll_macro_top_tb.v (behavioral smoke only)
```

## Still open in P0-A

- `PHASE_LOCK` is now driven by the on-chip `pll_lock_detector` from
  SS-BBPD; the detector is a no-symbol run detector, not a phase-noise or
  calibrated phase-error measurement.  Its LOCK_COUNT/LOSS_COUNT are still
  fixed in `pll_logic` (16/4).  The FSM also requires `FREQ_OK`, the live
  raw per-REF count inside `FCW +/- LOCK_TOL`.  A quiet BBPD with that
  count outside the window cannot enter the locked state, and a lock
  already taken drops back to frequency acquisition.  `FREQ_OK` uses the
  raw delta, not `cnt_filt`: the IIR settles a code or two off the same
  ratio depending on the side it came from.  It waits `FREQ_LOSS` (default
  4) consecutive misses before falling.  Sticky `FREQ_LOCKED` is unchanged
  and is not this flag.  Filter saturation (`ILL_P`/`ILL_N`) is still a
  separate force path, not part of this window.
- The CDC test covers an independent 1.5 GHz MID_OUT / 100 MHz REF phase
  relationship with no-X checks, but still needs randomized phase sweeps and
  a full snapshot-valid scoreboard.
- `pll_macro_top` with the behavioral `sim_*` models reaches
  `FREQ_LOCKED=1` at `FCW=16`.  Over the next 32 REF cycles the bench
  counted 534 `MID_OUT` edges (16.7 per REF), inside `FCW +/- 2`, so the
  integer target is 16× and not 8× or 32×.  `PHASE_LOCK` stays 0 in that
  netlist: the behavioral SS-BBPD produced the positive symbol and not
  the negative one, so `LOCKED` stays 0.  This is not a PEX, pad-jitter
  or PVT result.
- `CKR` high time, measured in `src/ckr_tb.v` with a 10 ns `MID_OUT` and a
  REF high covering two falling edges, is 20 ns: from the falling edge
  that samples REF=1 to the next falling edge that samples REF=0.  It is
  not one `MID_OUT` high time (5 ns).  One `IN` rising edge into
  `sim_delay_coarse` at code 0, with the code written 10 ps later (the
  in-flight delay is 31.320 ps), produces exactly one output edge, at
  31 ps.  The written code (133.300 ps) does not schedule a second edge.
  Mid and fine each follow with one edge.  The time-0 initial `OUT` is
  not counted.
- The default-polarity quiet code is `2'b00`.  Positive is `2'b01` and
  negative is `2'b11`, matching `pll_digital_loop_filter` without
  `WITH_REF_TRIG_OUT`.  A build that defines that macro has to override
  `NO_SYMBOL_CODE`, `SYMBOL_P_CODE` and `SYMBOL_N_CODE` together.  A quiet
  run locks only after both correction symbols have been seen.
- `pll.v` still needs a full closed-loop elaboration / simulation with the
  actual `PLL_ANALOG` model.
- No full STA/CDC signoff or P&R rerun is claimed from this batch.

## Next P0-A items

1. Formal CDC test: REF/MID_OUT arbitrary phase, Gray snapshot consistency.
2. `pll_macro_top` integration with unified parameters and the real macro.
3. Negative tests: DCO freeze, counter off-by-one, SS-BBPD polarity inversion,
   frequency step and reacquisition.
