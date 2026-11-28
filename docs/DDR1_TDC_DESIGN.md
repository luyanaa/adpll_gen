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
