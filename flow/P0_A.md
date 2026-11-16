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
  SS-BBPD.  It is an activity/balance detector, not a no-symbol run
  detector: `src/ssbbpd.v` cannot produce a stable `2'b00`, and at the
  DLF edge it produces only `2'b01` (P) and `2'b11` (N).  The previous
  quiet-`2'b00` criterion waited for an unreachable state and could never
  assert.  The detector now samples the same edge as the DLF
  (`negedge INJ_EDGE`), qualifies a `LOCK_COUNT` window only when both
  signs occur, and treats `00`, `10` and a saturated filter as invalid.
  See `flow/SSBBPD_SYMBOL_CONTRACT.md` and `src/ssbbpd_contract_tb.v`.
  `LOCK_COUNT`/`LOSS_COUNT` are still fixed in `pll_logic` (16/4).  The FSM
  also requires `FREQ_OK`, the live raw per-REF count inside
  `FCW +/- LOCK_TOL`.  A phase-lock indication whose count is outside the
  window cannot enter the locked state, and a lock already taken drops back
  to frequency acquisition.  `FREQ_OK` uses the raw delta, not `cnt_filt`:
  the IIR settles a code or two off the same ratio depending on the side
  it came from.  It waits `FREQ_LOSS` (default 4) consecutive misses
  before falling.  Sticky `FREQ_LOCKED` is unchanged and is not this flag.
- The CDC test covers an independent 1.5 GHz MID_OUT / 100 MHz REF phase
  relationship with no-X checks, but still needs randomized phase sweeps and
  a full snapshot-valid scoreboard.
- `pll_macro_top` with the behavioral `sim_*` models reaches full
  `LOCKED=1` at `FCW=16`; over the next 32 REF cycles the bench counted 528
  `MID_OUT` edges (16.5 per REF), inside `FCW +/- 2`.  The path that made
  this possible: the phase-filter integrator starts at mid-scale, the phase
  loop swaps the P/N correction direction for the delay-increasing DCO, and
  the FLL is stopped only when `PHASE_LOCK & FREQ_OK` (it restarts when the
  live window leaves).  The stream is P=200, N=200, invalid=0, `ILL=0`,
  `DLF_INT=36623`.  This is not a PEX, pad-jitter or PVT result.
- `CKR` high time, measured in `src/ckr_tb.v` with a 10 ns `MID_OUT` and a
  REF high covering two falling edges, is 20 ns: from the falling edge
  that samples REF=1 to the next falling edge that samples REF=0.  It is
  not one `MID_OUT` high time (5 ns).  One `IN` rising edge into
  `sim_delay_coarse` at code 0, with the code written 10 ps later (the
  in-flight delay is 31.320 ps), produces exactly one output edge, at
  31 ps.  The written code (133.300 ps) does not schedule a second edge.
  Mid and fine each follow with one edge.  The time-0 initial `OUT` is
  not counted.
- The SS-BBPD contract is `{OUT,REF}`: `2'b01` P, `2'b11` N, `2'b00`
  invalid (both NAND outputs low is not a stable state), `2'b10` invalid
  at the decision edge (latch resolution outside the sampled phase).
  `ssbbpd_contract_tb` walks the phase and confirms the DLF edge sees
  only P/N, both present, and never `00`.  A build that defines
  `WITH_REF_TRIG_OUT` still has to override `SYMBOL_P_CODE` and
  `SYMBOL_N_CODE` together.
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
- `flow/generator/cdc.py` now emits a contract per channel, not one
  frequency-counter template: `freq_count` (MID_OUT->REF Gray),
  `dco_activity` (OUT->REF Gray, `out_edges_gray` -> `out_edges_g1`) and
  `ref_level` (REF->OUT single bit).  The first two get max-skew and
  max-delay constraints; the level channel carries an explicit waiver
  instead of a max-delay.  `design.lock.json` carries all three channel
  entries.
- `ref_watchdog_tb` reproduces the sampled-liveness boundary: normal 8:1
  and non-integer ratios keep `alive`; a stopped REF drops it; an exact
  1:1 (`FCW=1`) or any exact integer OUT/REF ratio aliases and drops
  `alive` while REF is still running.  A hard clock-fault contract needs
  an independent always-on monitor; the current check is liveness only.
- `flow/generator/clock_ir.py` now also declares `DSM_CK` (MID_OUT /
  `DSM_DIV`), `CK` (nominal `out_div`, gated by `LOCKED`), `INJ_EDGE`
  (Core A delayed REF copy) and `CKR`.  `CKR` is emitted as a comment, not
  a fixed-period clock; it is a REF-sampled enable on MID_OUT.
- `pll_macro_top` reports a steady-state metric separate from
  `FREQ_LOCKED`: 6600 `MID_OUT` edges over 400 REF = 16.5/REF, about
  +3.1% from `FCW=16`.  `FREQ_LOCKED` only means the filtered count is
  inside `FCW +/- LOCK_TOL`; it is not a SoC ppm budget.
- `flow/DDR_CLOCK_PHY_PATH.md` records the fixed-configuration path
  (ADPLL -> CK divider -> DCC -> phase selector/DLL -> PHY clock).
  Standalone selector path, 200 MHz, 30% input: `CK_DCC`/`CK_PHY` duty
  50.0%, tap 4 phase 240 ps, pad/load `PAD_CK_T` duty 50.0% and phase
  375 ps, complementary pair and fail-closed shutdown pass.  The
  non-SIMULATION selector tap bus is bound to `PLL_DCDL_TAP_BUS_PHYS`
  (fine-delay cells) and passes both the PDK-independent stub check and
  the real ics55 H7CR check: Icarus elaboration, Yosys synthesis (191
  cells; 16 `FINE_DELAY_CELL`, 32 `INVX5H7R`, 16 `NAND3X1H7R`) and OpenSTA
  tap steps 35.3/60.7/24.0 ps at TT/SS/FF (50 ps input, 2 fF tap load).
  `src/ics55_ddr_ck_pad.v` wraps two real `P65_1233_PBMUX` IO cells as
  CK_T/CK_C; the IO Verilog simulation gives 50.0% duty / 240 ps, and
  OpenSTA with the real IO Liberty (2 pF load) gives TT/SS/FF rise/fall
  2.57/2.44, 4.22/4.22, 1.77/1.67 ns and single-ended duties 47.4/52.6,
  50.0/50.0, 48.0/52.0%.
- The ADPLL divider + DCC + selector integration (`USE_DLL=0`) passes:
  full `LOCKED` after 202 REF, `DCC_LOCKED=1`, `CK_PHY` period 4.870 ns
  and duty 50.0%, tap 4 phase 240 ps.  The raw `OUT_DIV` is a fractional
  divider clock with non-uniform edge spacing, so it is not a valid
  full-period DLL reference; the Route B DLL correctly refuses to lock it.
  The old `ADDLL_TOP` `DLL_LOCKED=1` / 843 ps offset / 41.4% duty false
  lock is removed from the PHY.
- Route B full-period DLL (`src/dll_full_period_top.v`) is implemented and
  verified behaviorally at TT/SS/FF: 5 ns lock at -40/-94/-60 ps residual,
  a 4 ns input locks at its measured 40-tick period, and a 2T-start DUT
  converges to 1T.  0T/0.5T/2T DUTs assert `ACQ_FAIL`, rail the code, and
  never assert `LOCKED`/`PHASE_OK`/`RANGE_OK`.  `LOCKED = RANGE_OK &
  PHASE_OK & !CODE_RAILED & ALIVE`; `PHASE_OK` counts consecutive valid
  edge comparisons.  The `src/ddr_clock_phy_dll_tb.v` PHY test with a
  uniform 200 MHz input gives `DLL_LOCKED=1`, code 58, 4.960 ns delay and
  50.0% `CK_PHY` duty.
- The old COARSE-only ics55 DCDL is blocked at 5 ns: TT 4.71-5.55 ns,
  SS 6.43-7.98 ns, FF 3.97-4.52 ns.  The 4-segment bypass + 56-tap
  structure (`src/pll_segmented_delay_phys.v`) covers 4.5-5.5 ns at all
  corners: TT 2.93-11.55, SS 3.32-18.13, FF 2.78-8.64 ns.  The 8-segment
  version failed SS (5.12 ns minimum).  The real PD sign is confirmed: at
  negedge INJ the ics55 latch gives only P=01 / N=11, matching the model.
  The selector-only path remains the verified fallback; the remaining DLL
  blocker is gate-level/PEX/PVT, not the DCDL range.
- The differential CK_T/CK_C crossing, package/board load, SI and
  PVT/jitter are not measured.  The IO corner spread (1.77/2.57/4.22 ns at
  FF/TT/SS for a 5 ns period) means a static tap cannot hold the pad phase
  across PVT; the DLL/phase-tracking path is required, but its real DCDL
  range is the blocker above.
- The divider and CK gate in `pll_logic` are clocked by `OUT`, which starts
  after `RST_N` is already high.  Their async reset never saw a clock edge
  in integration and `OUT_DIV` stayed X.  A 16-`OUT`-edge local reset
  (`div_rst_n`) now initializes both blocks; the ADPLL divider output runs
  in the integration smoke.
- `pll.v` still needs a full closed-loop elaboration / simulation with the
  actual `PLL_ANALOG` model.
- No full STA/CDC signoff or P&R rerun is claimed from this batch.

## Frequency metrics

| Metric | Current result | Nature |
|---|---|---|
| Acquisition range | `FREQ_LOCKED` when `cnt_filt` is inside `FCW +/- LOCK_TOL` (default ±1 count/REF) | behavioral FLL flag, not SoC accuracy |
| Steady-state frequency | 6600 `MID_OUT` / 400 REF = 16.5/REF, about +3.1% from `FCW=16` | behavioral sim_* netlist |
| Phase error | behavioral phase lock reached (P=200/N=200); no calibrated phase-error/jitter number | open measurement |
| Lock time | ~202 REF to full `LOCKED` in the behavioral integration | behavioral, not PVT |
| Reacquisition time | FSM-level tests only; no real BBPD closed-loop reacquisition | open |

`FREQ_LOCKED=1` must not be read as "the output meets an SoC ppm budget".

## Lock verification layers

| Layer | Status |
|---|---|
| FSM with injected `PHASE_LOCK` / `FREQ_OK` | covered by `lock_fsm_tb` |
| Real FLL + behavioral DCO + real BBPD | full `LOCKED=1` reached; P/N balanced, no ILL; phase-loop sign/init/FLL-gating fixes applied |
| Route B DLL, behavioral TT/SS/FF | 5 ns lock, 4 ns adaptive lock, 0T/0.5T/2T rejection, PHY uniform-clock test pass |
| Real macro + digital control + PEX/PVT | not started; DLL gate-level/PEX/PVT and pad SI remain |

`pll_lock_detector` is an activity/balance window, not a quiet-run
detector.  It cannot detect a detector that toggles P/N artificially;
that needs a dither or an independent monitor.  The next blocker is the
real DCDL range, not the phase detector.

## Next P0-A items

1. Take the Route B DLL through gate-level/SDF and placed/PEX at TT/SS/FF;
   the behavioral T0/STEP map is a linear surrogate of the 4-seg STA
   endpoints, not the full nonlinear code-to-delay surface.
2. Feed the DLL a uniform integer-divided reference and verify the PHY path
   with the real IO pad, differential CK_T/CK_C crossing and SI.
3. Formal CDC test: REF/MID_OUT arbitrary phase, Gray snapshot consistency,
   and a per-channel OpenSTA audit of the new `dco_activity` path.
4. `pll_macro_top` integration with unified parameters and the real macro.
5. Negative tests: counter off-by-one, SS-BBPD polarity inversion,
   frequency step and reacquisition.
