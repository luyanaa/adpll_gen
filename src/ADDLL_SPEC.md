# ADDLL (All-Digital DLL) — interface & control-word spec

Derived from `PLL_COUNTER_TOP` by breaking the DCO ring into a tapped
delay line (DCDL).  Target use: DDR PHY clock deskew (write leveling,
read DQS centering).  The loop controls **phase (delay)**, not frequency.

## Architecture

```
CLK_IN ──┬──────────────────────────────────────────────► (PD ref)
         │   ┌──────────┐ ┌──────────┐ ┌──────────┐
         └──►│ COARSE 15│►│ MID 15   │►│ FINE 31  │──► CLK_OUT
             │  taps    │ │  taps    │ │  taps    │    (PD fbk)
             └──────────┘ └──────────┘ └──────────┘
                  ▲            ▲            ▲
                  │   thermometer MUX words │
        ┌─────────┴─────────────────────────┴──────────┐
        │  term decoders ◄── binary DLY_CODE            │
        │      ▲                                        │
        │  up/down counter (DLF, KP=0, KI=step) ◄── SSBBPD early/late
        └──────────────────────────────────────────────┘
```

Reused from ADPLL (unchanged): `PLL_SSBBPD`, `pll_digital_loop_filter`,
`pll_term_decoder_with_zero`, `pll_lock_detector`, `COARSE_DELAY`,
`MID_DELAY_BUFFERED`, `FINE_DELAY_BUFFERED`.
New: `PLL_COUNTER_DCDL_PHYS` (cascade wrapper), `PLL_COUNTER_DCDL`
(functional model), `ADDLL_TOP` (loop shell).

## Ports (`ADDLL_TOP`)

| Port | Dir | Width | Description |
|---|---|---|---|
| `CLK_IN` | in | 1 | Reference clock to be delayed (CK/WCK/DQS). |
| `RST_N` | in | 1 | Async reset, active low. Clears accumulator + lock counters. |
| `TICK` | in | 1 | Loop sampling clock (PD/filter). Independent of `CLK_IN` phase. |
| `EN` | in | 1 | Loop enable. `0` freezes control word at `DLY_INIT` (open-loop mode). |
| `KI` | in | `FILTER_BITS` | Integral step per PD update. `1` = minimum (recommended). |
| `PHASE_OFFS` | in | 8 | Static phase offset added to the delay code, in FINE LSBs. |
| `DLY_INIT` | in | 8 | Preload delay code while `EN=0` / at reset (coarse-start seed). |
| `CLK_OUT` | out | 1 | Delayed clock to the PHY. |
| `LOCKED` | out | 1 | `LOCK_COUNT` consecutive "no-symbol" PD samples. |
| `ERR` | out | 1 | Lock lost (`LOSS_COUNT` misses) or accumulator saturated. |
| `DLY_CODE` | out | 8 | Current binary delay code (observability / readback). |

## Control word

The delay code is a single binary number; on-chip decoders expand it to
three thermometer words. Units are FINE LSBs.

| Field | Taps | Step (model) | Weight (FINE LSBs) | Range |
|---|---|---|---|---|
| COARSE_MUX | 15 | ~120 ps | `COARSE_W` = 8 | 0–15 |
| MID_MUX | 15 | ~60 ps | `MID_W` = 4 | 0–15 |
| FINE_MUX | 31 | ~15 ps | 1 | 0–31 |

**Saturating small-to-large decode** (`ADDLL_TOP`), monotonic in fine-LSB
delay units — fine fills first, then mid, then coarse:

```
fine_n   = min(DLY_CODE, 31)
rem1     = DLY_CODE - fine_n
mid_n    = min(rem1 / MID_W, 15)
rem2     = rem1 - mid_n*MID_W
coarse_n = min(rem2 / COARSE_W, 15)
```

So `DLY_CODE = fine_n + 4·mid_n + 8·coarse_n` exactly equals the realised
delay in fine LSBs. `TOTAL_STEPS = 31 + 4·15 + 8·15 = 211` codes of range
(≈3165 ps at the model steps). Division/modulo use constant divisors and
synthesise to subtractors — no real divider is needed.

**Delay model** (functional): `t_d = T0 + 120·|COARSE| + 60·|MID| + 15·|FINE|`
with `T0 ≈ 4 ns` insertion delay. Total span ≈ 15·120 + 15·60 + 31·15 =
**3165 ps programmable** + insertion.

## Phase-target / lock behaviour

- Bang-bang PD gives sign only → loop converges to the **nearest
  full-period alignment** (minimum-delay lock). For a fixed phase (90°/180°)
  use `PHASE_OFFS`, or seed `DLY_INIT` near the target and let the loop
  dither ±1 LSB around it.
- Lock = `DLF_OUT` stays inside a ±`DITHER_BAND` (4) window for
  `LOCK_COUNT` (16) consecutive `TICK`s — the bang-bang dither criterion.
  `ERR` on window exit after lock or accumulator rail (`ILL_P`/`ILL_N`).
- The PD bits are **bit-swapped for the filter only** so a late `CLK_OUT`
  edge increments the delay (pushed toward the *next* `CLK_IN` edge);
  the loop therefore settles at `t_d ≈ T_CLK_IN`, the minimum-delay
  full-period lock used by DDR write leveling.
- MUX words are only updated through the accumulator; during lock the
  dither is ±1 LSB → tap switching is thermometer-adjacent, no glitches
  (delay cells are non-inverting; the chain preserves phase polarity).
- Verified by `addll_top_tb` (iverilog `-DSIMULATION`): loop locks in
  <20 TICKs, `DLY_CODE` dithers 0↔2, insertion = 2 fine steps.

## Notes / limitations

- Step sizes (120/60/15 ps) are **model defaults** matching the DCO
  params; real per-stage delays come from PnR characterization — update
  `MID_PER_COARSE`/`FINE_PER_MID` weights to match silicon ratios.
- `DLY_CODE` is 8-bit and saturates at `TOTAL_STEPS`; raise
  `FILTER_BITS`/port width if a longer chain is built.
- PVT drift: delay cells are uncalibrated; the loop tracks drift
  continuously while `EN=1`.
- PnR: planned next round — `flow/macro/counter_dcdl_sky130/` modeled on
  `flow/macro/counter_dco_sky130/` (hard macro for DCDL cells + digital
  loop), then top-level integration.
