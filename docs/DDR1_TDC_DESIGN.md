# DDR1 CK90 DLL phase detector — TDC design analysis

Date: 2026-11-28. Replaces the behavioral `$realtime` FIFO in
`src/ddr1_ck90_dll.v` (synthesis blocker, docs/DDR1_PASS2_BLOCKERS.md item 1).

## What the detector must produce

Per master_out edge (once per CK period):
1. **Sign** — bang-bang direction: is master_out early or late vs the
   CKIN edge it should coincide with?
2. **Magnitude band** — for lock/loss qualification:
   - in lock band: |phase| ≤ 192 ps master (48 ps at CK90)
   - beyond loss band: |phase| > 640 ps master (160 ps at CK90)
   - hysteresis between the bands (in-spec slew-through allowed)
3. No modulo aliasing across the 10 ns period (the behavioral FIFO's
   absolute-time property). In lock the phase is near zero by definition,
   so aliasing is a non-issue AFTER lock; during acquisition the loop only
   needs the sign — bang-bang walks toward zero regardless of magnitude.

## Structure

```
CKIN ──► tapped fine chain ──► [t0][t1][t2]...[tN]   (unit delay τ)
                │
master_out ─────┴── samples all taps in parallel (DFF array)
```
master_out clocks the tap vector; the thermometer transition position
gives the time of master_out relative to the CKIN edge that entered the
chain. Sign = which side of the chain center the transition is on (or an
arbiter DFF for the degenerate case). This is the standard flash TDC;
no CDC — everything is in the CKIN timebase because master_out is a
delayed version of it.

## Resolution from measured cells (DQS STA measurements, 2026-11-28)

Plain FINE_DELAY_CELL taps: **65 / 100 / 45 ps at TT / SS / FF**
(flow/sta/run_ddr1_dqs_corners.sh data). Implications:

| quantity | TT | SS | FF |
|---|---|---|---|
| tap step τ | 65 ps | 100 ps | 45 ps |
| lock band ±192 ps in taps | ±3.0 | ±1.9 | ±4.3 |
| loss band ±640 ps in taps | ±9.8 | ±6.4 | ±14.2 |
| quantization error vs loss band | 10% | 16% | 7% |

Consequences:
- **Tap-count thresholds cannot be corner-invariant in ps.** Options:
  (a) accept ps-threshold variation (lock/loss bands widen at FF, tighten
      at SS) — the SPEC-critical direction is the loss trip at ≤160 ps
      CK90: at SS ±6 taps = 600 ps master = 150 ps CK90 ✓ still under
      spec; at FF ±6 taps = 270 ps master — TOO tight, false loss trips.
      So fixed tap counts fail.
  (b) use MORE taps and scale the count by a corner-observable — there is
      no digital corner sensor; rejected.
  (c) **vernier chain** — two chains with ratioed delays (e.g. 1× and
      0.8× cells mixing inv_1/inv_2/inv_4 sizing), resolution = τ1−τ2.
      With 65/52 ps chains → 13 ps resolution: ±640 ps at ±49 steps,
      quantization 2% worst corner. Cost: 2× chain area + calibration of
      the ratio across corners (the ratio is a geometric sizing property,
      tracks PVT well).
  (d) **hierarchical: coarse sign+band from plain cells, and accept the
      quantization** because the loop only needs bang-bang sign for
      tracking and a loss trip "somewhere inside 100-160 ps CK90". At SS
      6 taps = 150 ps ✓; at FF pick taps so the trip lands at 100-160 ps
      across corners: with τ scaling 45-100 the SAME tap index sweeps
      270-600 ps master = 67-150 ps CK90. The FF end (67 ps) is tighter
      than necessary but NOT a false-trip hazard in normal operation
      because post-lock dither is ±2-8 ps master « 270 ps. Marginal-noise
      false trips cost a relock (~µs), not a spec violation — fail-closed
      stays fail-closed.
- **Recommendation: (d) first** — simplest, silicon-real, and the false-trip
  cost analysis is benign; upgrade to vernier only if jitter evidence in
  pass 2 shows the quantization hurting lock quality. This keeps the TDC
  a plain FINE_DELAY_CELL chain — same cells as the DQS line and the
  segment trim, already characterized.

## Sizing (option d)

- Chain length: cover ±1 ns around the CKIN edge for acquisition-time
  visibility: ±1 ns / 100 ps worst-case SS = ±10 taps minimum, use 2×16
  taps centered. Fine at FF: 16×45 = 720 ps < 1 ns — the window narrows
  at FF; acceptable because acquisition phase at FF is also faster.
  Alternatively scale chain cells per corner — no; fixed design, accept
  window variation.
- Sampling: thermometer decode in CKIN-domain logic, gray-safe because
  the tap vector is captured in one shot.
- Metastability: master_out near a tap transition → one tap may capture
  metastable; the thermometer decode tolerates one bubble by design
  (majority-of-transition-position). MTBF analysis pass 2 — the loop is
  bang-bang so a single bad sample costs one wrong step, self-correcting;
  the LOCK/LOSS counters (8/3 consecutive) debounce it.

## CK90 monitor replacement (third-sample elimination)

The behavioral `assign #2.8` third sample disappears: the TDC already
measures the master phase in ps-like units every cycle. 90° correctness
= measured phase in lock band AND slave = master/4 by construction. The
180°-inverse injection case is caught structurally: an inverted CK90
FAILS the existing sample-1 (low at CK rise) half the time and sample-2 —
recheck: actually samples 1+2 pass for 180°. BUT with the TDC the monitor
can compare the SLAVE edge position directly: slave edge must land in the
TDC window at T/4 ± tolerance after CKIN. An inverted CK90 lands at T/2
or 0 — outside. This is a cleaner check than the 2.8 ns sample and uses
the same hardware. Design detail for the rewrite.

## What passes to the implementation lane

1. Rewrite `DDR1_CK90_DLL` phase detection: drop `real`/`$realtime`;
   add the tapped chain + capture array + thermometer decode; keep the
   bang-bang step, lock/loss counters, watchdog semantics identical.
2. IMPL-split: keep the behavioral fast model behind a parameter for the
   85-check TB; the structural TDC is the synthesis path.
3. The chain cells are FINE_DELAY_CELL (IMPL=1 path exists already).
4. Verification: same TB + new checks for quantization behavior at
   simulated τ of 45/65/100 ps (parameterize the behavioral chain delay).

## Capture dynamics of the flash chain (added 2026-11-28, structural design input)

The naive "launch CKIN into the chain, capture with master_out" has richer
dynamics than the quantization analysis above implies. Worked through:

**Capture types** (chain length ~1.3 ns « T/2 = 5 ns, one edge in flight):
- (a) rising wavefront mid-chain — VALID signed measurement. Capture times
  within ±1-2 ns of the CKIN edge are always type (a) or (d).
- (b) wavefront fully through, falling edge not yet entered — chain reads
  all-ones = saturated LARGE POSITIVE. Correct sign for a late master.
- (c) falling wavefront mid-chain (CKIN is 50% duty: falling edge enters
  at +5 ns) — the tap vector LOOKS like a valid partial measurement but
  encodes the falling-edge position, which is meaningless for phase. Can
  read either sign depending on how far the falling edge has propagated.
- (d) all-zero — valid negative saturation (master early) or post-passage.

**Reachability of the garbage zone (c):** capture times in (c) are master
edges arriving ≥ ~5 ns after CKIN — i.e. residuals beyond ±T/2-scale
offsets. Post-lock, the loop holds residuals within ±192 ps, and a loss
excursion trips within 3 measurements (~30 ns) while the residual is still
inside ±1 ns; the loop steps at most 1 LSB (37-50 ps master) per cycle, so
the garbage zone is UNREACHABLE in normal post-lock operation. During
acquisition the initial residual is constrained inside ±T/2 of lock by the
element sizing (docs/DDR1_DLL_ELEMENT_SIZING.md CODE_INIT retarget), and
type-(c) reads then cannot occur either: master edges arrive within ±T/2
of CKIN, i.e. before the falling wavefront enters the chain... careful:
residual approaching +T/2 means master edges close to +5 ns — the falling
edge entry. The acquisition-residual budget must actually keep initial
residual inside ±(T/2 - chain_len - margin), tighter than ±T/2. At the
N=6 sizing: initial residuals are within ±2.7 ns of zero at all corners —
inside ±(5 - 1.3 - margin) only if margin ≤ 1 ns. Marginal at SS
(+2.67 ns); chain-level SPICE + acquisition simulation must confirm the
first measurements are type-(a). If not, CODE_INIT per-corner trimming or
a shortened chain is the fix.

**Divergence from the behavioral modulo-fold model:** the behavioral model
(fold into ±T/2 then quantize) makes deep positive residuals read negative
(wrong-way walk, caught fail-closed — verified in ddr1_ck90_dll_tdc_tb.v
check7). The real chain SATURATES positive for moderately late masters
(type b) and reads garbage only in the unreachable-in-practice zone (c).
The behavioral model is thus PESSIMISTIC for deep offsets — a conservative
verification stance: silicon will behave no worse than the model. Keep as
is; document, don't "fix".

**Sign at the zero crossing:** within ±1 tap the capture position is the
measurement.  The loop's dead zone is NOT "the quantization itself" any
more (that assumption was wrong — the measured limit cycle was 128 ps pk-pk at
CK90; see docs/DDR1_CLOCKING.md "The DLL loop tracks continuously but HOLDS
in a dead zone" and src/ddr1_jitter_tb.v): it is the
explicit HOLD_PS parameter, which must be >= max(master step, TDC tap) or
an unlucky phase leaves no reachable code inside the band.  Metastability
of the capture flops near the transition is debounced by the LOCK_N/LOSS_N
counters — MTBF analysis is a pass-2 signoff item.

**As built (final parameters):** NTAP=32 measurement cells, NOFF=16 offset
cells (D0 = 16·τ), one-bubble leading-ones decode, signed E_MEAS in
master-scale ps.  TDC_STEP_PS is swept 45/65/100 (FF/TT/SS) in the TBs.
The dead zone is `HOLD_PS = max(NQ_SEG·CELL_X4_STEP, TDC_STEP_PS)` — 65 ps
master = 16 ps CK90 at the defaults — and it must cover the MEASUREMENT
granularity too: with a 65 ps tap against a 64 ps band the loop wandered
5-6 codes (80 ps at CK90) before the fix.

**Structural implementation shape (TDC_IMPL=1) — first sketch, superseded
by the single-chain form below:**
- reference chain: 2×M FINE_DELAY_CELLs, center tap defines zero; sizing
  M from measured τ per corner so the ±loss band (640 ps) is inside the
  chain at SS (M·100 ≥ 2×640+margin → 2M ≈ 16-20 cells).
- capture: master_out (inverted edge sense) clocks the tap-vector flops.
- decode: thermometer position of the 1→0 transition relative to center,
  one bubble tolerated; saturate at the ends.
- downstream interface identical to the behavioral model: signed e_meas in
  ps units (position × TDC_STEP_PS parameter), so loop/lock/loss logic is
  shared verbatim.
The as-built version keeps the decode and interface but replaces the
"reference chain + inverted edge sense" with ONE chain plus a delayed
master capture clock (next section), which removes the negative-time
problem without a second chain or a CDC.

## Structural implementation landed (2026-11-28): single-chain + delayed-master

`src/ddr1_dll_tdc.v` implements the signed flash TDC. The two-chain
start/stop-swap structure considered above was REJECTED during design:
the stop-chain capture overwrite window is only ~the residual itself
(hundreds of ps) and the CKIN->master CDC of its reading would add two
flops = up to 2 master periods of measurement latency, retuning the whole
loop's lock dynamics. Instead:

- ONE measurement chain started by CKIN; capture clocked by master_d =
  MASTER delayed through an offset chain of NTAP/2 identical cells.
- zero residual reads the CENTER tap; signed range ±(NTAP/2)·τ; negative
  residuals of ANY depth clamp at −(NTAP/2)·τ with correct sign (capture
  before wavefront entry = all-zero).
- positive saturation (correct sign) for e ∈ [+(NTAP/2)·τ, +(T/2 − D0 −
  chain_len)] ≈ [+1040, +2920] ps at TT/NTAP=32. Past that lies the
  falling-wavefront interference zone and then the periodic ±T/2 aliasing
  that NO periodic measurement can avoid.
- consumption one master period after capture (T − D0 ≈ 8.7 ns of
  metastability settling) — single domain, no synchronizers.
- IMPL=0 behavioral transport-delay cells exercise the full capture/
  decode path in RTL; IMPL=1 binds FINE_DELAY_CELL for synthesis/STA.

**Acquisition budget consequence** (with N=6 element sizing): initial
residuals −1800…+2670 ps across corners are correct-sign everywhere
(negative side clamps correctly at any depth; SS +2670 is inside the
positive saturation window ending +2920). Marginal at SS: if chain-level
SPICE moves the SS initial residual past +2920, CODE_INIT must rise.

Unit verification `src/ddr1_dll_tdc_tb.v`: 11/11 PASS — signed residuals
±192/±640 ps within ±2 taps, tap quantization, correct-sign clamps,
no modulo aliasing inside the documented window, return-to-zero.
