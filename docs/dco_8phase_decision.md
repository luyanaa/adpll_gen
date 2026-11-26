# 8-phase clock architecture — derivation and decision

Status: architecture decision, 2026-11-27. Resolves the M4 blocker
(`dco_tuning_design.md`, "closure is not one gate-slot"). Derived here because
the oracle models were plan-gated on this host; all numbers below are from the
campaign's measured SPICE data (`pex_ihp_tuned/STATUS.md`).

## What is actually broken

The blocker was stated as "NSTAGE=25 cannot make an 8-phase grid." That is a
symptom. The root causes, separated:

**R1. The tap grid is 2.5–3× too fine and covers only 0.40 T.**
NSTAGE=25/STEP=3: period 52 slots, taps span 21 slots. Two required phases fall
in the gaps. Fundamental: a ring of N inverters has period 2N slots, and 8
evenly spaced phases need a tap every 2N/8 = N/4 slots — with N=25 that is 6.25
slots, not an integer. **No integer tap spacing can hit k·T/8 on NSTAGE=25.**

**R2. The closure is 2.6–3.3 INV4-slots, and its ABSOLUTE delay is nearly
constant while the slot shrinks with code.**
Measured: closure = 186.5 ps at c0/f=0 (slot 72.0 ps) and 191.0 ps at c0/f=−31
(slot 57.7 ps). Absolute delay is flat to 2.4%; the *slot count* inflates from
2.59 → 3.31 purely because the logic slot gets faster with tuning. The closure
is a 1× NAND2 in a chain of 4× inverters, so it is 2.6–3.3× a slot regardless.

**R3 (the deeper one). Per-stage cap banks tune the closure too, but not by the
same ratio.**
The banks scale every inverter stage by ~the same factor, but the closure's
delay is set by a different drive/load ratio, so the closure's *fractional*
contribution changes with code. That is why the closure spread (0.7 slots)
appears: frequency tuning and phase relationship are coupled through a gate
that is not ratio-matched to the stages.

**Conclusion:** a single travelling-wave ring with a non-unity closure cannot
hit an exact 8-phase grid. Not a sizing problem — a structural one. But the
required *fix* is not necessarily a new ring.

## Why "closure = exactly 1 or 2 slots" (option B) is unreachable

- Closure = 1 slot: needs NSTAGE = 4·STEP − 1 = 23 with an inverting closure →
  total inversions 24 (even) → latches. A NAND2 cannot be starved to 1 INV4-slot
  without destroying its drive (measured 2.6–3.3× at full size).
- Closure = 2 slots: needs NSTAGE = 22, total inversions 23 (odd) → oscillates.
  This is the as-built NSTAGE=22 variant — and it lands at 2.59–3.31 slots, i.e.
  the closure is right at the boundary and drifts across it with code.
- So the closure slot count is not integer-stable across code. Option B dies on
  the code dependence, not on sizing.

## The recommendation: tap EVERY stage, let the PI interpolate (option D-extended)

This is the production-SerDes answer and it needs **no ring surgery**: keep
NSTAGE=22/NAND2 as built, but break out **all 22 stage taps** (plus their T/2
inversions) instead of 4, and let the PI synthesise the 6 phases that do not
land on a tap.

Why it works — measured, both codes:

| code | L | slot | anchors (taps + inversions) | max gap | T/8 target vs nearest anchor |
|---|---|---|---|---|---|
| c0/f=0 | 24.59 | 72.0 ps | every 1.000 slot | **1.000 slot (72 ps)** | k=0/2 exact, k=1/3 need **0.147 slot (10.6 ps)** |
| c0/f=−31 | 25.31 | 57.7 ps | every 1.000 slot | **1.000 slot (58 ps)** | k=0/2 exact, k=1/3 need **0.018 slot (1.0 ps)** |

With an anchor every slot, **every phase is within ≤0.5 slot of an anchor**, so
a 1-slot-span interpolator reaches all 8 phases. Required PI:

| rate | slot | PI span needed | max fraction | 4-bit PI LSB |
|---|---|---|---|---|
| SS 250 MHz | 81 ps | 81 ps | 41 ps | 5.1 ps |
| FF 500 MHz | 41 ps | 41 ps | 20 ps | 2.5 ps |

That is a modest interpolator, and it **absorbs the closure drift**: the
residual is bounded by the PI's own linearity, not by the ring geometry. It also
removes the need for the L = 4·STEP invariant entirely — the invariant was only
needed to make taps land on k·T/8 exactly, which is no longer required.

**TX quadrature** likewise: pick the two anchors nearest T/4 (12.29 and 12.65
slots → stages 12/13 region) and interpolate to exact T/4; no −188 ps
systematic.

## Why not the alternatives

- **A. Two-ring**: doubles the area/power of the clock macro, adds a second
  free-running ring whose phase relationship to the first is undefined (needs
  its own alignment), and does not by itself produce exact T/8 — the second
  ring has the same closure problem. Rejected: it relocates the bug.
- **C. DLL delay line**: gives exact T/8 by construction and is genuinely
  attractive, but adds a DLL loop (reference, false-lock, its own jitter), which
  is a larger new analog block than one interpolator, on a 6-week clock.
  Viable fallback if PI linearity proves inadequate.
- **E. Injection-locked / divide-by-2**: divide-by-2 gives exact 50% duty and
  0/180, but not 8 phases; injection locking adds a reference and lock range
  problem. Partial answer at best.

## Decision

1. **Keep the as-built ring** (NSTAGE=22, NAND2 inverting closure, delay-free
   kick, inv_4, banks, symmetric taps). No new ring.
2. **Break out all stage taps** (22 + 22 inverted anchors) at the PI boundary.
3. **PI: 1-slot span, ≥4 bits** (LSB ≤5 ps at 250 MHz), current-steering,
   selecting the two nearest anchors and interpolating.
4. Drop the L = 4·STEP requirement — superseded by anchor-density + PI.
5. **The code-dependent closure drift is acceptable** with this structure, but
   record it as the PI's residual budget line: the PI input codes must be
   derived from the *measured* anchor positions at the operating code (a small
   per-code calibration LUT is legitimate here — it compensates a measured
   systematic, not a guessed one).

## Verification contract (unchanged severity)

- Measured |phase_k − k·T/8| ≤ 30 ps for k=0..7 **including the PI**, at c0,
  c31 and the operating codes, all corners. Report the PI's contribution
  separately from the anchor positions.
- TX: |phase − k·T/4| ≤ 30 ps for the 4 phases.
- Startup, duty 45–55% at the flop pin, fine symmetry, rate table (250 @ SS,
  500 @ FF/TT) as before.
