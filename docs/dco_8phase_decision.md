# 8-phase clock architecture — FINAL: DLL delay line (option C)

Status: final architecture decision, 2026-11-27. Supersedes
`dco_8phase_decision.md` §"recommendation" (the 1-slot-PI idea, refuted by
measurement — that document's root-cause analysis R1–R3 still stands).

## Measured refutation of the single-ring family

The 1-slot-PI proposal assumed stage taps + inversions interleave into a dense
grid. Measured on the full-anchor NSTAGE=22 build (44 anchor nets):

- The 44 nets collapse to only **26 distinct phase positions**.
- Spacing **34–406 ps (0.39–4.65 slots)** — not ≤1 slot.
- Anchor-only nearest error vs k·T/8: **82–92 ps** (budget 30 ps).
- The gap needs a **~400 ps** PI span, not ~40 ps.
- Fitting the full anchor bank also **slows the ring 15–16%** (282.4 → 238.6 MHz
  at c0/f=0) — the fanout is not free.

**Why (general result):** in a ring, adjacent stages have opposite polarity, so
a *new* rising phase appears only every **2 stages**. And because
T/2 = L ≈ NSTAGE + closure, each "inverted" anchor lands almost exactly on the
original comb's wrap — it **duplicates**, it does not interleave. Hence only
~NSTAGE/2 distinct phases, with a hole of several slots where the two combs meet.

**Exact-8-phase condition for ANY single ring:** tap spacing must be
T/8 = L/4 slots and an integer number of stages, with new phases every 2 stages
⇒ **L must be divisible by 8**. As-built L = 24.59 ⇒ L/4 = 6.1475, not integer.
Making L divisible by 8 for all codes is impossible because the closure delay is
fractional (2.59→3.31 slots) **and code-dependent**.

⇒ **The single-ring family is closed.** Not a sizing problem: the phase grid is
set by gate ratios that carry the tuning code, and the closure breaks the
integrity of one slot.

This also retires the earlier `L = 4·STEP` invariant (it was derived on the
ideal-gate model where the closure is one slot).

## Decision: 8-stage DLL delay line

Phase from **edge alignment to the reference every period**, not from gate
ratios. Then per-element spacing = d exactly by construction, independent of the
tuning code (which now lives entirely in the frequency source).

```
REF (from the 500 MHz-class DCO/PLL) ──┬────────────────────────────┐
                                      │                            │
                              ┌───────▼──────── 8 × delay elem ────┐│
                              │ d  d  d  d  d  d  d  d  ── taps k·d ││
                              └───────────────────────────────────┘│
                                      │  tap7 (8d) ── PD ◄── REF ───┘
                                      └── V_ctrl ── loop filter ──┘
```

Required element delay (T = period at the operating rate):

| rate | T | d = T/8 | range to cover | 6-bit trim LSB |
|---|---|---|---|---|
| SS 250 MHz (1 Gb/s) | 4000 ps | **500 ps** | ~350–650 ps | 7.8 ps |
| FF 500 MHz (2 Gb/s) | 2000 ps | **250 ps** | ~175–325 ps | 3.9 ps |

Taps at 0, d, 2d, … 7d give **exact k·T/8 by first-order construction**; the
residual is the PD offset + element matching, both of which are static
systematics (trimmable), not code-dependent. TX quadrature = taps 0 and 2
(T/4 exact) + complements.

### Why this is the right call here
- **Solves R3 directly**: frequency tuning (DCO/PLL current or cap) and phase
  generation (DLL bias) are separate actuators — the code no longer perturbs the
  tap relationship.
- **Same infrastructure**: we already have the 500 MHz-class source as REF; the
  delay elements are the same switchable-load/current-starved structures already
  built and measured in this campaign.
- **Range is a bias question, not a ring-length question** — 250/500 MHz becomes
  a control-range spec, not a re-spin.

### Costs to budget (honest)
- Adds a PD + charge-pump/integrator loop → its own filtered jitter.
- **False-lock / start-up range risk** — must be measured (lock from both rails,
  lock-in range, re-acquire).
- Area: 8 controllable elements + bias ≈ similar to the ring body; the ring's
  cap banks are re-used as the elements.
- The reference must be clean: DLL jitter tracks REF jitter (it is a
  low-pass-filtered copy for phase).

## What survives from the ring campaign

All of it, re-purposed:
- `dco_stage` (inv_4 + switched MOS-cap coarse/fine banks, SW_M 1,1,2,4,8 /
  1,1,1,2,4,8, w=0.15u switches) → becomes the **controllable delay element**.
- Rate tables measured (SS 279.4→134.1, TT 552.6 fast, FF 837 fast) bound the
  element's achievable delay range.
- kick / startup work, duty numbers, driver+harness fixes, variants, STATUS.md.

## Verification contract

1. DLL lock: from both control rails, all corners, both rates; report lock time
   and lock-in range; prove no false lock (e.g. lock at 7d or 9d would show as
   a period error — check the tap7-vs-REF phase directly).
2. **|phase_k − k·T/8| ≤ 30 ps**, k=0..7, at both rates, all corners, with the
   trim code swept — report PD-offset and element-matching contributions
   separately.
3. TX |phase − k·T/4| ≤ 30 ps.
4. Duty 45–55% at the flop clock pin; min pulse on tap switching.
5. Jitter: DLL output phase noise vs REF (the DLL must not add more than the
   30 ps budget allows at the sampler).
6. Frequency coverage still via the existing DCO/PLL: 250 MHz @ SS, 500 MHz @
   FF/TT (already measured on the ring — unchanged by this decision).

M4 (layout) starts only after 1–3 pass.

---

## ADDENDUM 2026-11-27: prefer all-digital — an ADDLL already exists in-repo

Before starting the analogue DLL, the user asked whether an all-digital /
synthesisable option exists. It does, and it is already written:

| module | lines | role |
|---|---|---|
| `src/addll_top.v` | 188 | **all-digital DLL**: bang-bang PD + digital loop filter (first-order UP/DOWN counter) + thermometer decoder + DCDL |
| `src/dll_dcdl.v` | 228 | unified delay-line interface, CODE 0..279 → COARSE(4 segments)/FINE(56 taps) |
| `src/dll_full_period_top.v` | 529 | full-period variant: absolute-range acquisition + **TDC PD** + monitor line for range revalidation + safe-window code commit |
| `src/fine_delay.v` / `mid_delay.v` / `coarse_delay.v` | — | **pure stdcell** switchable-load delay cells (inv5→NAND3 load→inv5, etc.) |
| deps | — | `ssbbpd.v`, `digital_loop_filter.v`, `term_decoder.v`, `pll_counter_dcdl_phys.v` |
| TBs | 7 | `addll_top_tb`, `dll_dcdl_tb`, `dll_full_period_tb`, `dll_gate_tb`, `dll_phys_tdc_tb`, `dll_range_reval_tb`, `dll_tdc_phys_gl_tb` — **no recorded pass/fail evidence** |
| physical | — | `flow/macro/counter_dcdl_sky130` (sky130 hard-macro flow exists) |

### Why this is a strictly better base than the analogue DLL
- **No analogue bias/charge pump** → synthesizable, DFT-able, portable across
  PDKs by swapping cells (the analogue option needs per-PDK bias redesign).
- **Same code base has already fixed the exact bug class we hit**: `dll_dcdl.v`
  documents a 62 ps (3.07 LSB) DNL gap at segment boundaries where "the loop
  cannot settle", fixed by making the bypass add zero. That is the DCDL sibling
  of our ring's closure-slot problem — already solved and documented.
- **Solves R3 structurally**: frequency from the DCO/PLL, phase from a
  digital-coded line. The tuning code no longer touches the phase relationship.
- **Fast digital regression** (iverilog) instead of slow SPICE.

### The one hard requirement that does NOT go away
An **open-loop** delay line cannot hold 30 ps: element delay drifts ~2× SS→FF
(500 → 250 ps/element). So the line **must be closed-loop** — but the loop can
be fully digital (measure tap vs REF, step the code). That is precisely what
`addll_top` / `dll_full_period_top` implement.

Per-element target: **SS 500 ps, FF 250 ps**, and to hold 30 ps at tap k=7 the
fine step must be **≈4 ps/LSB**. Whether the existing 56-tap fine segment
achieves that is the open question being measured now.

### Order of work (approved)
1. Get the 7 existing TBs to run; record real results (none exist today).
2. Characterise the DCDL transfer curve: range, LSB, monotonicity, residual
   gaps — verify the EXTRA_PS fix in the functional backend.
3. Decide `addll_top` (bang-bang + counter) vs `dll_full_period_top` (TDC +
   range revalidation) as the base.
4. Only if digital resolution is proven insufficient, fall back to the analogue
   bias DLL (option C above).

The analogue option C is therefore **demoted to a fallback**, not the plan.
