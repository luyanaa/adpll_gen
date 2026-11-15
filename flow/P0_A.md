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
- The first high phase after a runtime ratio change was one input clock
  wide, because `conf_div` pre-loaded `fresh_high-1` and the next edge then
  satisfied `cnt+1 >= limit`.  It now starts at `cnt=0`, so the first high
  and the following low are the new ratio's full halves.  `divider_tb`
  covers `/2->/8`, `/8->/4`, `/4->/8`, `/8->/1` and `/1->/8`.  `/4->/2`
  could not see the bug: its new high is one clock wide either way.
- The DCO activity check in `pll_logic` no longer samples an 8-bit binary
  counter in the REF domain.  It counts in Gray, passes through two
  `ASYNC_REG` flops, and treats any change of the synchronized word as
  activity.  That removes the multi-bit incoherent sample; the cost is up
  to three REF cycles before the first miss, so the effective window is
  `DCO_TIMEOUT + 3`.  `pll_ref_watchdog` also samples REF through two flops
  and compares the second and third stages, instead of XORing the raw pin.
  Both are still sampled liveness checks: an exact alias or both clocks
  stopping needs an independent always-on monitor.
- `ddr_ck` keeps the combinational `locked` gate.  A ratio change or normal
  disable finishes the open high pulse because `ck_en` is sampled on the
  divided falling edge; a switch to an odd ratio emits one final high at
  that odd width before `ck_en` drops, so that transition pulse is not a
  50% DDR pulse.  A lock fault is fail-closed and truncates the last high;
  that is reported as a fault truncation, not as a tCH/tCL-compliant last
  pulse.  `ddr_ck_tb` checks both.
- The generator's `COMMON_SOURCES` now carries `ref_watchdog.v` and
  `ddr_ck.v`; `pll_logic` instantiates both, so the top-integration package
  elaborated only because those files were absent from the manifest.  All
  three cores elaborate in `test_delivery` and `test_elaboration`.
- `pll.v` still needs a full closed-loop elaboration / simulation with the
  actual `PLL_ANALOG` model.
- No full STA/CDC signoff or P&R rerun is claimed from this batch.

## Lock verification layers

| Layer | Status |
|---|---|
| FSM with injected `PHASE_LOCK` / `FREQ_OK` | covered by `lock_fsm_tb` |
| Real FLL + behavioral DCO + real BBPD | frequency reaches FCW, but the behavioral SS-BBPD emits only the positive symbol, so `PHASE_LOCK` stays 0 and full `LOCKED` is not reached without an override |
| Real macro + digital control + PEX/PVT | not started |

`pll_lock_detector` is still a quiet-run detector with a both-sides
requirement.  `seen_p`/`seen_n` have no age limit, so a detector that goes
stuck quiet after both symbols were seen can still be reported as locked.
A real phase-detector health check needs a dither or symbol-timeout
mechanism; that is not in this pass.  Layer 2 (lock, unlock and relock with
no injected detector outputs) is the next gate before any PEX/PVT claim.

## Next P0-A items

1. Closed-loop layer 2: a BBPD model that can emit both correction symbols,
   then lock, forced unlock and relock without `TB_OVERRIDE`.
2. Formal CDC test: REF/MID_OUT arbitrary phase, Gray snapshot consistency.
3. `pll_macro_top` integration with unified parameters and the real macro.
4. Negative tests: counter off-by-one, SS-BBPD polarity inversion,
   frequency step and reacquisition.
