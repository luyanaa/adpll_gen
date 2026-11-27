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

### ADDLL evaluation result (2026-11-27, measured) — code usable, line must be re-made

All 7 TBs now run (previously none had evidence): **5 PASS, 2 FAIL**.
PASS: `dll_dcdl_tb` (TT 2930/11548 ps, SS 3320/18128, FF 2780/8640; boundary
step **exactly = LSB** → the EXTRA_PS DNL-gap fix is verified), `dll_full_period_tb`,
`dll_gate_tb`, `dll_tdc_phys_gl_tb`; `addll_top_tb` passes but is a **smoke test
only** (elab-stub cells are zero-delay, so its code carries no timing meaning).
FAIL: `dll_range_reval_tb` (4 checks — no re-lock at 6 ns, phase not full period,
long-edge/restore never re-lock, CODE stuck 75) and `dll_phys_tdc_tb` (SS lock
0.972 ns vs ~5.0; TT/FF pass).

**The existing DCDL does not fit this purpose** (measured, codes 0..279):
min total **3320 ps @SS / 2780 ps @FF** (830 / 695 ps per element) and
**LSB 30 ps uniform**. It was sized for DDR ~5 ns periods. We need 250–500 ps per
element with ≤20 ps LSB.

**Two derived corrections to the earlier 4-element idea:**
1. **Use 8 elements, full-period lock (8d = T).** A 4-element line locks 4d = T/2
   against the inverted edge, putting REF **duty cycle directly into d**: at
   500 MHz a 1% duty error costs **+35 ps at tap 7** (budget 30) → needs <0.85%
   duty. Full-period lock is duty-immune.
2. **Per-element trim, not one shared code.** Shared code: tap-7 = 3.5·LSB → needs
   LSB ≤ 8 ps. Per-element (independent residuals): tap-7 ≈ 1.32·LSB → **LSB ≤ 20 ps
   passes, 10 ps comfortable**.

Target: 8 elements × (base < 150 ps + fine bank), d = 250 ps (FF) / 500 ps (SS),
per-element trim, LSB ≤ 20 ps (aim 10). Reuse the stdcell `fine_delay`/`mid_delay`
cell pattern, `ssbbpd`/TDC detector, `digital_loop_filter` + `term_decoder`.
Synthesizable, no analogue bias. Verification: lock from both rails at 3 corners
and both rates, prove no false lock (exactly 8d = T), and measured
|phase_k − k·T/8| ≤ 30 ps for k=0..7.

### DLL8 digital pass — ACCEPTED (2026-11-27, `15ccd9d`)

Reproduced independently by the orchestrator (not just the lane's report):

| config | worst \|phase_k−k·T/8\| | E (lock point) | element matching | duty | verdict |
|---|---|---|---|---|---|
| SS / 4 ns (250 MHz) | **0.0 ps** | +0.0 ps | 3.9 ps | 50.0% | PASS |
| FF / 2 ns (500 MHz) | **0.0 ps** | +0.0 ps | 3.9 ps | 50.0% | PASS |
| TT / 3 ns | **0.0 ps** | +0.0 ps | 3.9 ps | 50.0% | PASS |
| SS / 2 ns (500 MHz) | 16.0 ps | −16 ps | 2.2 ps | 50.0% | PASS |

- Locks from **both code rails**, 0.4–3.1 µs, final code 94/95.
- **No false lock**: tap7−REF = 0 / ±16 ps (a 7d/9d lock would read ±T/8 = ±500/±250 ps).
- TDC resolution T/1024 = 3.9 / 2.9 / 2.0 ps vs the derived requirement **E ≤ 34 ps**
  → measured **E ≤ 16 ps**.
- **Measurement-based trim** demonstrated: injected +6/+4/−5/+3/−4/+5/−3/+2 code
  offsets → untrimmed worst 32 ps → **TDC-calibrated worst 4 ps**, matching 7.8 ps.
  (The 32 ps "FAIL" line in the log is that deliberate pre-calibration demo.)

Files (no shared module touched): `src/dll8_line.v` (element + 8-element line,
per-element codes, `DLL8_IMPL` model/phys split), `src/dll8_tdc.v` (coherent
phase TDC — counter and both edge captures in the TICK domain, avoiding the
split-handshake ±1-period error of the older `DLL_TDC`), `src/dll8_top.v`
(TDC-default loop, half-code-step dead band, update every 3 REF cycles,
absolute-range acquisition clocked REF/8 with TICK=16×REF so 8d=T reads 16
counts — the harmonic-lock guard), `src/dll8_tb.v`.

**Known range limit (accepted, matches the spec table):** with the 7-bit sizing
the element maxima are SS 628 / TT 466 / FF 314 ps, so **TT and FF cannot reach
d = 500 ps at 4 ns** (they rail at code 127). The corner-graded contract is
SS@250 MHz and FF@500 MHz — both covered — plus TT@3 ns. Supporting TT/FF at
250 MHz would need an 8-bit (255-finger) bank; not required by the contract.

**`PD_MODE=0` (bang-bang latch)** is kept selectable but is *not* a valid lock
detector here (settles at the anti-phase equilibrium 8d≈T/2), consistent with
the derived dead-zone limit (>56 ps) that forced the TDC swap.

**Remaining gate before M4**: SPICE confirmation with real sg13g2 cells + routed
wire caps — BASE/LSB per corner (the digital BASE/LSB are optimistic
placeholders), element headroom at 500 ps (SS) and 250 ps (FF), and the
conformance re-run with measured delays substituted.

### DLL8 SPICE pass (2026-11-27, `0449538`, `d75778e`, `b776580`)

**Element sizing resolved** (device-level SPICE, real sg13g2 + OSDI PSP103-NQS +
0.96 fF/node wire caps):
- First stage `INVX4-B` **Wp=5.30 µm / Wn=2.96 µm** — the stock inv_4
  (4.48/2.96) is PMOS-under-sized under load and was the source of the
  tpHL−tpLH asymmetry (+45…+64 ps → **≤4 ps** after the fix).
- Bank: 7-bit **thermometer**, symmetric N/P switched `sg13_moscap`
  0.9×1.1 µm (~12.7 fF/finger), half NMOS→VSS / half PMOS→VDD, `buf_8`/`inv_8`
  control. Two measured corrections: buf_1 cannot drive 64 gates, and the
  **binary** code was non-monotone at −28 ps carries → thermometer it is.
- **BASE 62.1 / 42.2 / 30.9 ps** (bare), ~148 / 88 / 59 ps with the bank all-off
  — still < 200 ps. **LSB ~5.0 / 4.0 / 3.5 ps**. Range 62→700 / 42→545 / 31→470 ps,
  monotone. 8-element line additivity ~1.2× → spans **2000–4000 ps at every
  corner**, ≥1.40× delay margin at the operating codes.

**Closed-loop with measured timing** (line-scaled BASE/LSB SS 74.5/6.0,
TT 50.4/4.75, FF 37.2/4.15 ps): LOCKED both rails in all four cases,
E ≤ 16 ps, worst |phase_k − k·T/8| = 5–16 ps, no false lock.

**Duty is load-bearing, so regeneration stays.** Raw tap duty is 58–61 %.
This is not tolerable: TX's 4:1 latch-MUX uses `clk_ph[i]` as the latch
transparency window, so 58 % high time holds the latch open 0.08 UI into the
next phase's slot and corrupts data. **SR/DFF regeneration** (SET on tap_k
rising, RESET on tap_(k+4) rising = k·d + T/2 since 8d = T) gives high time
exactly 4d = T/2 → **50 % by construction**, and both edges are rising so the
bank's tpHL/tpLH cannot enter duty.

**Open (being closed):** per-phase **set-path SPREAD** measured 31 ps over
k=0..3, at the budget edge and not certified for k=4..7. Note the *absolute*
0.45 ns set delay is harmless (a common offset across all k is absorbed by the
sampler/CDR); only the k-to-k spread enters |phase_k − k·T/8|. Suspected
extraction artefact (0.45 ns set delay vs a 0.2 ns pairing window); all 8
regenerators are the same cell with the same load, so the physical spread
should be ~1–2 ps. Being re-extracted with a per-cycle edge association and
load-symmetry enumeration over all 8 phases.

### M4 readiness (2026-11-27, `0fdcac3`)

**Custom driver eliminated by measurement.** The `sg13g2_inv_4b` (Wp 5.30/Wn 2.96)
existed only to balance tpHL/tpLH for duty. Since SR regeneration produces duty
independently, the asymmetry no longer reaches any output. Measured with **stock
`sg13g2_inv_4`**: BASE 146.4 / 89.9 / 60.5 ps, max 654.3 / 511.6 / 458.7 ps,
LSB 4.0 / 3.32 / 3.14 ps (SS/TT/FF) — **within 2 ps of the custom driver at every
corner**, all corners reach their d with ≥1.31× margin. Custom cell deleted; the
"cell does not exist in the library" risk is gone. Element output duty IS worse
(up to 286 ps asymmetry at c32) and is now purely diagnostic — regeneration holds
49.7–50.0 % at all 8 outputs.

Regenerated gate with the stock element: de-offset ≤7 ps, duty 49.8–50.0 %,
both rails, no early edges, no false lock.

**k=7 outlier diagnosed as deck load asymmetry, not silicon.** The test deck
loaded taps x1..x7 with a real next-element input *plus* a dummy, but x8 had only
the dummy — tap7 was under-loaded by one element input. Fixed in the deck
(dummy only on tap7, same cell as the real input). **The real netlist must carry
that matched dummy** so all eight regenerator loads are symmetric.

### Remaining before M4 can start (ordered)

1. **moscap/nmos PnR views — NEW, previously unidentified.** No macro in this
   repo has ever been through LibreLane with `sg13_moscap_n/p` +
   `sg13_lv_nmos/pmos`: the signed-off `cdr_ihp130` uses the *old* cell file
   (0 moscap refs) and the tuned version has only ever run in SPICE. Those
   primitives are Yosys blackboxes, so PnR has no LEF/GDS for them. **This must
   be built (Magic GDS + extracted LEF/abstract) before layout**, or LibreLane
   will fail to place the bank. Precedent exists (`MAGICRC`/`MAGIC_TECH` worked
   for the ring; the sibling PDK ships a Magic generator for these caps).
2. **Tap routing symmetry under real placement.** The 1.7 ps spread assumes
   matched tap loads/routing. The ring campaign already demonstrated a single
   ~38 µm route on one tap destroying uniformity.
3. **Full 8-element SPICE at the exact lock code** — the conformance runs used
   line-scaled BASE/LSB (×1.2 element→line), not a fully extracted line.
4. **SS D_set extraction** (k=0..3 association, k=7 noise) — extraction-limited;
   FF is clean at 1.5–1.7 ps.

### M4 prerequisite approved — moscap PnR cell library (2026-11-27)

Decision: build the fixed-size custom cells **before** the DLL8 macro PnR.

Why it is needed: no macro in this repo has ever been through LibreLane with
`sg13_moscap_n/p` + `sg13_lv_nmos/pmos`. The signed-off `cdr_ihp130` uses the
*old* cell file (zero moscap refs) and the tuned version has only ever run in
SPICE; those primitives are Yosys blackboxes, so PnR has no LEF/GDS and would
fail to place the bank.

Why it is tractable (not uncharted): the PDK ships a Magic generator
(`libs.tech/magic/ihp-sg13g2-cap.tcl`, `ihp-sg13g2-cifin.tech`) and this repo
already ran the identical chain for `tx_macro`
(`OpenSERDES/build/verify/ihp_tx_macro/`: `.gds`, `.cdl`, `.pex.spice`).

Cells to produce (fixed drawn sizes matching the measured element):
- `sg13g2_moscap_n` / `sg13_moscap_p` — 0.9 × 1.1 µm (~12.7 fF/finger);
  if that geometry is illegal, the nearest legal size with the C consequence
  reported (do not silently resize the element).
- `sg13_lv_nmos` / `sg13_lv_pmos` — the switch size used by the element.
- optional combined "switched finger" cell if it simplifies layout.

Each: GDS (Magic generator) + LEF/abstract + CDL, **DRC clean** (Magic and/or
KLayout, same decks as `cdr_ihp130`) and **LVS clean** (netgen). No fabricated
timing arcs — these are analog/custom cells.

Acceptance: cells placeable by OpenROAD (pin geometry, no overlap), wired into
`pll_cells_ihp-sg13g2.v` replacing the Yosys blackboxes while **keeping the
SPICE path working** (`dll8_pex2.py` must still run), and the element topology /
bank size / finger count unchanged.

Then, and only then, the DLL8 macro PnR (M4) with post-route tap-routing
symmetry re-measurement and the full 8-element SPICE at the exact lock code.

### Cell-library attempt → better packaging decision (2026-11-27, `6f6a68b`)

The per-device PnR cell attempt was stopped honestly at "not DRC/LVS clean", and
it produced two findings that changed the plan:

**1. Legal PCell geometry.** `sg13_moscap_n/p` legal range is w,l ∈ [1.0, 30] µm,
so the design-intent **0.9 µm width is illegal**. Of the legal options,
**1.0 × 1.0 µm (+1 %, ~12.8 fF)** is essentially the verified element, versus
1.0 × 1.1 µm (+11 %, ~14.1 fF). Chosen: **1.0 × 1.0 µm**.

**2. The bank size cannot be reduced.** LSB is a *device* property (~4.0 ps/finger
at SS), not a free parameter, so finger count sets **range**. Measured/derived:
- 7-bit (127): SS max 654 ps vs 575 needed (1.15× headroom) — PASS at every corner.
- 6-bit (63): SS max 398 ps vs 575 — **FAIL**.
- 5-bit (31): SS max 270 ps — FAIL.
So **127 fingers is mandatory**. (An earlier note in this file claiming 6-bit
would pass was wrong — it treated LSB as tunable. Retracted.)

**3. Packaging changed: one hard macro, not 2032 cells.** The DRC violations in
the cell attempt all came from the pin pads added to make raw devices
placeable as stdcell-like cells — the PCell bodies themselves are DRC-clean. So
the line becomes **one hard macro** in the `cdr_ihp130` pattern:
- interior = 8 × (inv_4 + inv_4 + 127-finger moscap bank) as PCell bodies,
- **LEF abstract with boundary pins only** (`IN`, `TAP[0..7]`, `CODE`, `VDD`, `VSS`),
- the digital remainder (thermometer decoder, TDC, loop filter, regen DFFs) stays
  as ordinary stdcells around it.

That is the right split — the line is custom/analog layout, the rest is
synthesisable logic — and it deletes the per-device placement question entirely
(OpenROAD places 1 macro, not 2032 cells).

**Remaining, ordered:** element SPICE re-confirm at 1.0×1.0 → line macro DRC 0 →
netgen LVS → **PEX tap-to-tap spread** (the real timing number; sim used an
assumed 0.96 fF/node) → LEF place dry-run → macro binding with the SPICE path
preserved. The full DLL8 tile PnR follows that.
