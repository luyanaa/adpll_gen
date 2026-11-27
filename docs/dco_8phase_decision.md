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

### Macro packaging (2026-11-27, `9243adf`)

**1.0 × 1.0 µm confirmed.** Element SPICE at 1.0×1.0 vs 0.9×1.1: BASE 146.4 ps,
max 655.7 / 514.3 / 462.0 ps (SS/TT/FF) — **<0.5 % change**. Range clears 1.15×
at every corner with 127 fingers.

**Pin plan (18 pins):** `IN`, `CODE[6:0]`, `TAP[7:0]`, `VDD`, `VSS`. The
thermometer decoder goes **inside** the macro so the 127-wire fan never crosses
the boundary (127 boundary pins would be a routing disaster). No per-element trim
pins — measured matching is 1.5–1.7 ps, so trims only buy range headroom; the
trim logic stays in the RTL model for the digital calibration demo.

**Area/shape:** naive 8-element placement = **710 × 44.8 µm (31.8k µm²), a 16:1
strip**, 2048 devices — bad for the tile. **Decision: 2 macros × 4 elements**
(~355×45 each), which fixes the aspect ratio and halves the tap-fanout span
(the main threat to tap symmetry).

**DRC 15,600 on the placement** — correctly diagnosed as adjacent-device guard
ring/well/implant spacing when PCells are butted. A legal macro must **share
wells and guard rings**, which is real analog layout, not spacing.

**Finger count is not fixed by physics — only total switched C is.** With
N ≥ 23 fingers satisfying both LSB ≤ 22.7 ps and range ≥ 508 ps, device count
scales as N at constant total capacitance:

| N | LSB | finger | devices |
|---|---|---|---|
| 127 | 4.0 ps | 1.0×1.0 µm | 2032 |
| 63 | 8.1 ps | 1.4×1.4 µm | 1008 |
| **31** | **16.4 ps** | **~2.0×2.0 µm** | **496** |

**Measured 2026-11-27 (`85e71d9`, `finger_test.json`) — the 4× reduction does NOT
exist. Total switched capacitance is not conserved:**

| N | finger | SS BASE | SS max | range | contrast/finger | vs 575 ps |
|---|---|---|---|---|---|---|
| **127** | 1.0×1.0 | 173.6 | **660.6** | 487.0 | 3.83 ps | **PASS (1.32×)** |
| 63 | 1.4×1.4 | 140.5 | 510.9 | 370.4 | 5.88 | FAIL (1.02×) |
| 31 | 2.0×2.0 | 117.5 | 403.7 | 286.3 | 9.24 | FAIL (0.81×) |

Per-finger contrast grows **sub-linearly** (3.83 → 5.88 → 9.24 ps for 1×/1.4×/2×
size) because `sg13_moscap` is voltage-dependent and the larger switch adds series
R — so a bigger finger buys less delay than its area. **127 fingers / 1.0×1.0 µm
is required, and the margin is not close** (63 fingers reaches only 1.02× where
1.15× is needed). The 2 × 4-element macro split stands.

Note this is the second time a "constant total capacitance" assumption failed in
this campaign (the first was the ring's NAND3 finger bank) — on this PDK, switched
MOS-cap delay must be measured, never scaled by area.

Then: route one 4-element macro with shared wells/rings → DRC 0 → netgen LVS →
**PEX tap-to-tap spread** → LEF + place dry-run. The tile PnR follows only after
that single macro is clean.

### Honest schedule assessment (2026-11-27)

What is **verified today** (RTL + device-level simulation, reproducible):

| item | evidence |
|---|---|
| 8-phase architecture | all-digital DLL8; the single-ring family proven structurally impossible |
| element | stock inv_4 ×2 + thermometer switched-moscap bank; BASE 146/90/61 ps, LSB ~4 ps, monotone |
| range | ≥1.31× headroom at 250 MHz (SS) and 1.83× at 500 MHz (FF) |
| loop | coherent TDC (T/1024 = 3.9/2.9/2.0 ps); locks both rails; no false lock; **E ≤ 16 ps** |
| phase grid | **5–16 ps** vs the 30 ps budget (SS/4 ns, SS/2 ns, TT/3 ns, FF/2 ns) |
| duty | **50.0 % by construction** (SR regen), all 8 outputs, all corners |
| matching | 1.5–1.7 ps element-to-element (measured); no per-element trims needed |
| complexity | stock cells only — the custom driver was measured unnecessary and deleted |

What is **NOT done**, and is real analog layout (first time in this project):

1. A legal **routed** 4-element macro: shared wells/guard rings (the naive butted
   placement produced **15,600 DRC errors**), bank routing, DRC 0 on Magic *and*
   KLayout, netgen LVS.
2. **PEX tap-to-tap spread** — the decisive number. Everything above assumes
   matched tap parasitics (the sim used 0.96 fF/node); the ring campaign already
   showed one ~38 µm route can destroy tap uniformity.
3. LEF abstract + OpenROAD place dry-run; macro binding with the SPICE path kept.
4. Full 8-element extracted-line SPICE at the exact lock code (conformance runs
   used line-scaled BASE/LSB, ×1.2 element→line).
5. SS D_set clean extraction (FF is clean at 1.5–1.7 ps; SS is extractor-limited).

**Positioning recommendation for the MPW.** Do not claim a silicon-verified
8-phase clock this shuttle. The defensible claim is:

> "All-digital 8-phase DLL, RTL + device-level simulation verified to ≤16 ps phase
> error and 50 % duty at 1 and 2 Gb/s across SS/TT/FF; **hard macro in progress**;
> 2 × 4-element split chosen; **open**: routed DRC/LVS and PEX tap spread."

That is honest and still strong — the architecture question is settled with
evidence, which is the part that usually goes wrong late. The remaining risk is
concentrated in one measurable item (**PEX tap spread**), not spread across the
design.

**Decision point:** if the 4-element macro cannot reach DRC-0 + a tap spread
inside ~30 ps in the available time, ship the DLL8 as RTL + verified simulation
(this cycle) and carry the macro to the next shuttle — rather than tape out an
unrouted or PEX-unverified clock block.

### Layout: three stops, obstacle identified (2026-11-27, `e030acb`)

Attempts to place/route the macro stopped three times at the same step. The lane's
own diagnosis names the obstacle, and it is architectural, not a matter of effort:

**1. The control fan.** A thermometer bank needs 127 control nets *per element*;
4 elements = 508 long nets inside the macro. That, not the device count, is what
makes routing intractable.
**Fix (keeps the thermometer, which monotonicity requires): replicate the
thermometer decoder per element.** Only the 7-bit `CODE` bus crosses the macro;
each element has its own 127-output decoder placed adjacent to its bank, so the
127 nets become **local** (decoder→bank, ~10–20 µm) laid as a regular strap in a
dedicated channel — the standard cap-bank layout. Decoder area is trivial against
the routing it saves.

**2. The DRC residual is mechanical, not architectural.** Removing per-device
guard rings dropped 15,600 → **781** errors, and the residual is exactly
*"device-to-device spacing plus missing well/substrate taps"* — i.e. the rings were
deleted but no psub/nwell taps were added. Needed: explicit psub + nwell tap rings
at legal spacing, legal device spacing, and a regular bank (shared `mid` bus,
VDD/VSS rails, control strap). Standard layout, not research.

**3. Scope reduced: one element first.** Deliver one element at DRC-0 (Magic *and*
KLayout) → netgen LVS → **PEX extracted element delay + per-node C**. That single
number answers the decisive question — **how far real parasitics sit from the
0.96 fF/node assumption** — and feeds straight back into the grid budget. The
4-element macro and the 2-macro split follow only after that.

**Current status: the PEX tap-spread judgement is NOT available**, and the DLL8
tile PnR must not start. Design and simulation are closed (E ≤ 16 ps, 50 % duty,
5–16 ps grid); the open item remains the physical macro.

### Pre-committed decision rule for the PEX result

Worst tap error = k × (element spread), so for the full 8-phase line at k=7 with
the simulation baseline (5–16 ps) already spent against the 30 ps budget:

| element extracted spread | verdict |
|---|---|
| **≤ 3.5 ps** | **PASS** — macro proceeds this cycle (7 × 3.5 = 24.5, + ~5 baseline ≈ 29.5 < 30) |
| 3.5 – 5 ps | marginal — attempt equal-parasitic tap routing, re-measure once |
| **> 5 ps** | **FAIL** — the 8-phase grid cannot hold 30 ps; ship DLL8 as RTL + verified simulation, carry the macro to the next shuttle |

This is fixed in advance so the outcome is a measurement, not a judgement call.

### First DRC milestone — and the "tooling block" may be spurious (2026-11-27, `dad0a33`)

**Magic DRC = 0 on one element** (2 × inv_4 + 127 moscap/switch, 1.0×1.0 µm),
size **110.35 × 59.83 µm**. The obstacle was exactly as diagnosed: the guard rings
*are* the well/substrate taps. `guardRingType=psub/nwell` kept, spaced to
**7.0 µm pitch** → clean. Removing the rings (which produced the 15,600 / 781
errors) also removed the taps; that was the whole problem, not the 127 fingers.

**The KLayout requirement is in the Python wrapper, not the rule deck.**
`run_drc.py::_get_required_klayout_version()` reads a repo-level `versions.txt`
which **does not exist** in this PDK tree (`find` confirms), and the actual deck
`libs.tech/klayout/tech/drc/ihp-sg13g2.drc` is a **standalone KLayout Ruby deck
with no version guard of its own**. So the "needs KLayout ≥ 0.30.7" report is a
consequence of the missing versions.txt, not of the rules — the deck should be
runnable directly on the installed 0.30.0 via
`klayout -b -r <deck> -rd input=... -rd report=...`. Being tested; if it runs
clean, the KLayout half of DRC-0 closes with no upgrade.

**Still open before the decisive number:** routing one element (mid bus, rails,
drain→cap-gate, per-element decoder with its 127 outputs as a local strap),
then netgen LVS, then Magic PEX. Only then is the **extracted element delay and
per-node C** available to test the 0.96 fF/node assumption and feed the
pre-committed ≤3.5 ps / >5 ps rule.

### KLayout discrepancy RESOLVED — it is our GDS, not the deck (2026-11-27, `22da56f`)

The KLayout "version block" was indeed only the Python wrapper (missing
`versions.txt`); the standalone Ruby deck runs on the installed 0.30.0 in 5.4 s.
But it then reported **568 violations** on our element while Magic reported 0.

**Discriminator run decided the question:** the *same* deck on the **signed-off
`cdr_ihp130` GDS reports 0 violations** (18.7 s, `main` table complete). So the
deck, layer map and flow are correct, and **our element's GDS is genuinely not
KLayout-clean**. Deck reconciliation is a dead end; the fault is in the GDS we
generate.

Violation profile: `CntB.a1` 254 (**≈1 per device**), `CntB.a` 192, `NBL.c` 55,
`Cnt.b` 36, `Act.b` 11, `M1.b` 9 — i.e. the **PCell's contact/NBL construction**
as streamed out does not match what the deck expects, consistently across every
device. This is a device-construction/streaming-parameter issue, not placement
spacing (placement has no overlaps, and Magic is clean).

Being fixed at the source (PCell contact/NBL generation or a corrected cell),
after which the requirement is **both decks at 0 on the same GDS** — "Magic says
0" alone is not acceptable given this evidence.

**Scope flag if it cannot be fixed by PCell parameters:** correcting 254 device
constructions by hand is a scope decision, not something to absorb silently.

### Scope decision: draw the devices with Magic PCells (2026-11-27, `4d45c4f`)

The KLayout 568 were attributed to the **PDK's KLayout PCell** streaming S/D and
guard-ring contacts as ContBar geometry that the KLayout DRC deck rejects
(`CntB.a1` 254 ≈ 1 per device; `Cnt.a`/`CntB.a` 192 each; `NBL.c` 55 from the
nW/nBuLay pitch). Magic uses a different extract/DRC path and reports 0 on the
*same* GDS, and the Magic-drawn `cdr_ihp130` passes the KLayout deck too — so it
is a **PDK KLayout-PCell vs KLayout-DRC revision mismatch**, not a placement error.

**Decision: draw the element with the Magic PCells** (`ihp-sg13g2-cap.tcl`,
`ihp-sg13g2-fet.tcl`), scripted and reproducible — the same flow that produced
`cdr_ihp130`, which is the only artefact in this repo that passes *both* decks
at zero. Rejected alternatives:
- patching the KLayout PCell / PDK source (would edit foundry files silently);
- declaring Magic the sole signoff deck — **not acceptable**, because I verified
  the KLayout deck catches real differences (0 on `cdr_ihp130`, 568 here).

Acceptance stays **both decks at 0 on the same GDS**, then route → LVS → PEX.

**Status: the decisive number (PEX tap spread / per-node C vs 0.96 fF/node) is
still unavailable, and the ≤3.5 ps PASS / >5 ps FAIL rule cannot be applied.**
This is the fourth iteration on the physical side; the design remains closed and
verified, so the open risk is concentrated entirely in first-time-for-this-project
analog layout.

### Diagnosis corrected — no Magic redraw needed (2026-11-27, orchestrator direct)

The lane's "KLayout-PCell vs deck revision mismatch → must redraw in Magic" was
**refuted by measurement** before any redraw happened:

1. **KLayout version irrelevant**: 0.30.12 (nix store) gives the identical 568 as 0.30.0.
2. **Single parameterized PCell devices are KLayout-clean**: the round-1
   `sg13g2_lv_nmos` / `sg13g2_moscap_n` cells → **0 violations**. The PCells are
   not inherently broken.
3. **Pitch sweep**: 7 µm → 568, 10 µm → 513, 14 µm → 513. Only ~55 violations
   (NBL.c) are spacing-driven; **513 are pitch-independent device/array-level**.
4. Contacts are exactly at the rule edge: 0.160 µm wide, minimum edge gaps of
   exactly 0.180 µm. Suspects: guard-ring corner contacts, cap/switch interaction
   at the 2 µm intra-column offset, or a parameter difference between the
   round-1 (passing) and round-2 (failing) instantiations.
5. **KLayout LVS deck natively extracts `sg13_moscap`**
   (`libs.tech/klayout/tech/lvs/rule_decks/cap_connections.lvs`) — Magic was never
   needed even for LVS. New preferred flow: **KLayout for DRC + extraction + LVS**,
   no Magic redraw, no PDK patching, no waiving KLayout.

The lane is now diagnosing the 513 to root cause at the shape level, then
routing one element → both-decks DRC 0 → KLayout LVS → PEX.

### Fallback noted, not pursued (documented for contingency)

If the moscap layout path fails again, the stdcell-only fallback is a
**drive-strength-tuned element** (parallel tri-state inverter slices / DCCA-style
current control) — fully synthesizable, no custom devices at all. Its known cost:
resolution is non-uniform (coarse at the fast end) and range trades against BASE.
Not pursued while the moscap path is alive, since the element is already
SPICE-verified with moscap and a redesign would restart verification.

### Root cause of the 568/513 found (2026-11-27, orchestrator direct)

**The cap and its series switch overlap by 0.91 µm in every finger column.**
Measured from `dll8_elem_ringed.gds` bboxes: `moscap_n` placed at x=0 extends to
+1.88; `nmos` placed at x=+2.0 starts at +0.97 → the two guard rings intersect
but are slightly offset, generating the ~20 nm slivers that KLayout reports as
`CntB.a1`/`CntB.a` (254+192, array level) plus the device-local `Cnt.b` corner
interactions. Explains all three observations: pitch-independence (intra-column
offset is constant), single-device cleanliness, and sliver-scale edge pairs.

No PDK bug, no deck mismatch, no Magic redraw. Fix: build the finger as **one
unit cell with a shared guard ring** (moscap + switch inside a single ring),
which also tightens row packing. In progress.
