# IHP SG13G2 L3 dense fine-bank check

This is the **100 ns** fine-bank scan at `coarse=8, mid=0` (fine `0..31`).
It replaces the earlier 30 ns exploratory sweep, whose 376/369 MHz points were
startup transients.

## Data

```text
points:  32
range:   275.64 .. 354.08 MHz
fine 0:  281.46 MHz
fine 8:  296.19 MHz
fine 31: 284.22 MHz
```

The 100 ns values at fine 0/8/31 match the sparse 100 ns table exactly:

```text
sparse f0  281.455160
sparse f8  296.189492
sparse f31 284.222519
```

## Residual non-monotonicity

The fine bank is still not monotonic at 100 ns:

```text
fine 16  287.56 MHz
fine 17  322.73 MHz
fine 18  281.28 MHz
fine 19  354.08 MHz
fine 23  306.98 MHz
```

There are 15 rising steps in the fine sweep.  This is no longer a simple
30 ns startup artifact: the sparse and dense 100 ns points agree at the
overlap, while the interior fine codes have large local outliers.  The likely
causes are the fine-bank mux mapping/loading or a stable but different
oscillation mode; this needs circuit-level debug, not more averaging.

## 2026-11-22: partial raw + solver-convergence correction

Two confounds in the table above were debugged down to root cause:

- **The 322.73 / 354.08 MHz outliers at fine 17/19 are mid-run solver aborts,
  not oscillation frequencies.**  The default `.tran 10n` runs hit
  `Timestep too small ... trouble with node xdco.coarse_out` at ~33 ns /
  ~23 ns; the harness then measured `period_of` on the *partial* `.raw`,
  whose early edges are still in the 1.1-1.4 ns startup transient.  With
  `--tstep 1` those same codes complete 100 ns and read 294.97 / 286.07 MHz.
  `ihp_l3_dense.py` now rejects partial raws (`t_end < 0.9*stopsim`) and
  defaults to a 1 ns tstep; even so, several codes still abort at 1 ns and
  need solver options (reltol/method/gshunt) — convergence work in progress.
- **A residual non-monotonicity is real, not an artifact.**  At 1 ns tstep,
  fully-converged: fine 16/17/18/19 = 287.74 / 294.97 / 285.02 / 286.08 MHz,
  i.e. a ~10 MHz drop 17->18 (same countones=2) plus code 16 below 17.  Root
  cause (@explorer): the fine bank is 31x `sg13g2_nand3_1` sharing a single
  `LOAD` wire; each set `MUX` bit turns on a NAND3 NMOS stack and adds a
  weak parallel pull-down on `LOAD` — a *non-linear DC resistive load*, not
  a per-bit capacitive step.  At `c8/m0` the SS-BBPD symmetric ring sits near
  an oscillation-mode boundary, so two same-countones codes can settle into
  different modes.  `ics55` uses the identical RTL/harness at `c8/m0` and is
  monotonic, so the defect is IHP-specific (cell strength + ring delay), not
  a systematic RTL bug.
- **Model gap:** `pll_ring_dco.v` uses `period = BASE - FINE_STEP*countones(FINE)`
  (linear, monotonic by construction); it cannot express this curve.

Decision: fix the fine cell (strengthen the bank / move the ring off the mode
boundary), pending a clean full sweep.

## Reproduce

```sh
python3 flow/characterization/ihp_l3_dense.py \
  --out /tmp/ihp_dense_100 --coarse 8 --mid 0 \
  --fine "$(seq -s, 0 31)" --jobs 4 --stopsim-ns 100 --tstep 1
```

## Convergence fix (2026-11-22, validated 32/32)

The remaining aborts were **not** a solver-options problem.  ngspice caps the
transient step at `tmax = min(tstep, tstop/50)`, so `tstep` is the max-step
cap: at `tstep >= 0.5` the allowed step between quiet stretches is too large
for the ring's sharp edges and the LTE controller collapses to minstep.
Screened and rejected: `itl4/itl5` (no effect — LTE, not iterations),
`trtol=20` (aborts earlier), looser `reltol` (only delays),
`method=gear` (converges but flattens the whole bank to ~281 MHz and breaks
f19).  **`--tstep 0.25` converges all 32 codes to 100 ns, 0 aborts.**

Clean table, c8/m0, 100 ns, tstep 0.25 (every point converged):

```text
f0 293.72  f1 295.85  f2 295.97  f3 288.02  f4 312.49  f5 299.15  f6 292.95  f7 293.18
f8 282.21  f9 295.71  f10 322.33 f11 297.74 f12 301.02 f13 296.66 f14 294.08 f15 286.75
f16 296.39 f17 292.18 f18 290.94 f19 301.48 f20 304.17 f21 298.94 f22 298.17 f23 300.17
f24 295.03 f25 293.13 f26 298.14 f27 298.11 f28 297.31 f29 282.71 f30 296.33 f31 295.03
```

18 down-steps (biggest: f10->f11 -24.6, f28->f29 -14.6, f4->f5 -13.3,
f7->f8 -11.0 MHz).  The non-monotonicity is real and *distributed*, not at
isolated codes — consistent with mode-switching near an SS-BBPD boundary,
not a smooth load curve.  (f17->f18 is only -1.2 MHz here; the earlier -10 MHz
was trajectory wander.  Within-run windows wander +/-5-10%, so sub-few-MHz
deltas are noise; the 10-25 MHz drops are real.)

## Status

```text
L3 transistor frequency:  measured, 100 ns, tstep 0.25 (32/32 converged)
monotonic fine bank:      RESOLVED — measurement artifact, not a defect.
                          At converged tstep (0.05, edge-interpolated) the
                          f16..f31 table is strictly monotone; the whole
                          fine span is only ~12.4 ps (~1.7 MHz @370 MHz), so
                          the 10-25 MHz "inversions" at tstep 0.25 were
                          solver/startup noise, not the code step.
PEX/PVT:                  c8/m8/f8 only, ../pex_ihp
jitter/phase noise:       not run
```

## Lock-point check (2026-11-22): the defect reaches the operating code

The verified closed loop (`pll_macro_top_tb`, FCW=16, LOCKED=1) settles at
countones `COARSE=4 / MID=9 / FINE~25` — NOT at the c8/m0 point the dense
sweep uses.  Re-scanned the actual lock neighbourhood at c4/m9 (tstep 0.25,
all converged):

```text
f20 370.66  f21 366.60  f22 375.00  f23 373.14  f24 366.89  f25 370.40
f26 372.44  f27 367.16  f28 369.05  f29 366.72  f30 376.77  f31 374.06
```

The fine bank is **non-monotonic at the loop's own lock code** too (the
366-377 MHz band hops up/down with code), so the mode-switching follows the
ring, it is not a c8/m0 corner case.  A fine filter that must track frequency
across these codes will hit inversions.  This is the argument for the circuit
fix over accepting the data as-is.

## RESOLVED (2026-11-23): the "defect" was a measurement-resolution artifact

Converged-timestep re-baseline settles it — **there is no fine-bank
non-monotonicity; no circuit respin is needed for it.**

- **Converged tables are monotone.**  At tstep 0.05 (edge-interpolated) the
  B=0 c4/m9 f16..f31 table is strictly monotone (357.14 → 353.02 MHz).  At
  tstep 0.02 the whole fine span f16→f31 is **12.4 ps** (~1.7 MHz at 370 MHz),
  ≈0.8 ps/code — matching the expected ~1 ps/code LSB.  The 10–25 MHz
  "inversions" seen at tstep 0.25 are 6–15× the *entire* fine range: they were
  timestep-grid + `uic` startup noise, not the code step.  Frequency for a
  given code is non-monotone *in tstep* (f16 = 377/334/357/366 MHz at
  0.25/0.1/0.05/0.02 ns) — proof the earlier tables never converged.
- **Corrected root-cause note.**  The earlier "weak parallel pull-down on
  `LOAD` / DC resistive load" is wrong: in `sg13g2_nand3_1`, `LOAD` is only
  the middle NMOS *gate* (no DC path to it).  The real mechanism is the
  dangling `UNCONNECTED` output → one side of the NMOS channel floats
  (`net2`/`net3`), a history-dependent gate capacitance.  It is a physically
  ugly cell but, per converged data, **monotone enough at the lock point**.
- **Direct proof — the isolated cell is monotone.**  Open-loop edge-delay
  sweep of the fine block alone (loop broken, MID_OUT driven with a 50 ps PWL
  edge, tstep 0.5 ps): both `t_PLH` and `t_PHL` increase monotonically across
  code 0..31 (~0.42 / ~0.26 ps per code).  `V(xdco.fine/UNCONNECTED_16_)` sits
  statically at VDD — a driven NAND3 output, not a drifting mid-rail node — so
  even the floating-charge mechanism is not supported by measurement.  The
  "inversions" were ~70–180 ps period error, i.e. exactly the tstep=0.25
  solver-step quantization, ~12× the true ~15 ps fine range.
- **`BASE_NDELS` confirmed not a fix and is reverted to a band knob.**  It
  adds constant loop delay T0 (`f(k)=1/(T0+T_fine(k))`): shifts frequency
  ~130 ps/buffer, shrinks fine Hz authority ∝ f², cannot change dT/dk sign.
  At c4/m9 the injection/BBPD inputs are DC-static, so "push off the mode
  boundary" was inapplicable.  Kept in RTL only as an optional tuning-range
  knob (`BASE_NDELS=0` default = legacy).
- **Open follow-up (different concern, not monotonicity):** the fine bank has
  only ~1.7 MHz authority at the lock point.  Whether that is *enough* LSB
  resolution for the SerDes bang-bang tracking band is a separate tuning-range
  question.  Also fix the polarity mismatch: the cell's set bits are heavy
  (countones up = slower) while `pll_ring_dco.v:41-44` models
  `period = BASE - STEP*countones` (countones up = faster).
