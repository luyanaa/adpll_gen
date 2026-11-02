# ADCC (All-Digital Duty-Cycle Corrector) — interface spec

Shares the ADDLL infrastructure: `pll_digital_loop_filter` degraded to an
up/down counter (KP=0), `pll_term_decoder_with_zero`,
`PLL_COUNTER_DCDL`/`_PHYS` as the single-edge delay, and a dither-window
lock detector.  The duty detector is an **asynchronous averaging
sampler**, not the edge bang-bang PD (see "Detector" below).

## Concept

The loop delays only the **falling** edge of `CLK_IN` through the DCDL
(`CLK_OUT = CLK_IN | ~fall_d`) until the output high time equals T/2.
Duty is measured by sampling `CLK_OUT` on a clock `SAMP` that is
asynchronous to `CLK_IN`: statistically the fraction of `1` samples
equals the duty.  Each sample is a 1-bit vote — `1` = high pulse too
long → shrink it (decrease fall delay), `0` = too short → increase.
The DLF integrator averages votes until the vote rate is 50%.

## Ports (`ADCC_TOP`)

| Port | Dir | Width | Description |
|---|---|---|---|
| `CLK_IN` | in | 1 | Input clock with duty error. |
| `RST_N` | in | 1 | Async reset. |
| `TICK` | in | 1 | Loop sampling clock. |
| `SAMP` | in | 1 | Async duty-sampling clock — **must be incommensurate** with `CLK_IN` (a spare ring oscillator or divided reference). |
| `EN` | in | 1 | Loop enable; `0` = open-loop at `DUTY_INIT`. |
| `KI` | in | `FILTER_BITS` | Step per PD update (1 = min). |
| `DUTY_OFFS` | in | 8 | Static duty-code offset (fine LSBs). |
| `DUTY_INIT` | in | 8 | Preload while `EN=0`. |
| `CLK_OUT` | out | 1 | Duty-corrected clock. |
| `LOCKED`/`ERR` | out | 1 | Dither-window lock / loss / saturation. |
| `DUTY_CODE` | out | 8 | Current correction code (readback). |

## Control word

Identical decode to ADDLL — `code = fine_n + 4·mid_n + 8·coarse_n` in
fine LSBs (~15 ps/step model), total 211 codes ≈ 3165 ps of falling-edge
adjustment.  One code LSB trims the high pulse by ~15 ps.

## Detector — averaging sampler (why not edge bang-bang)

A BBPD comparing `~CLK_OUT` (corrected fall) against `~CLK_IN` (input
fall) measures the fall against the **input's own duty point** (e.g.
30%), not T/2 — so its sign is permanently "late" and the loop
parasitic-locks (the earlier "50.9% lock" was an artefact of the fake
`T0_PS=4000` making `fall_d` in-phase).  A rising-edge PD needs a T/2
quadrature reference, which a single BBPD cannot supply.

The fix: **integrate the output level instead of comparing edges**.
Sample `CLK_OUT` on a clock `SAMP` asynchronous to `CLK_IN`; the
fraction of `1` samples equals the duty.  `SAMP` must be
*incommensurate* with `CLK_IN` — a coherent sampler aliases to a single
point on the waveform.  Each sample is a 1-bit vote encoded onto the
DLF symbol set (`01`=+code, `11`=−code); the integrator averages to
50%.  This is the standard digital-DCC detector — no second DLL, no
quadrature reference, and it is *monotonic* so no SAR seed is needed.

## Status / open items

- **Verified** (`adcc_top_tb`, 30% input): `SAMP` = 1.11 ns async clock;
  the loop climbs monotonically to `DUTY_CODE=40` and the output
  settles at **49.6% duty, clean 4.000 ns period, no glitches**.  This
  matches the analytic prediction (0.8 ns fall shift = code 40 at
  15 ps/LSB + 200 ps T0).  PASS.
- `CLK_OUT = CLK_IN | ~fall_d` with `fall_d = ~CLK_IN` delayed by `d`:
  output fall lands at `clk_in rise + t_high + d`; `d` chosen so the
  sum hits T/2.  Delay path and decode pipeline unchanged and correct.
- The level-integrating detector replaced the earlier `duty_sar_search`
  acquisition path — convergence is monotonic, no seed needed.
- **Open (physical)**: parasitic second pulse when `fall_d`'s delay is
  comparable to the low period — the OR recombine re-exposes the
  previous high pulse if `fall_d` hasn't settled within the low window.
  A pulse-swallow / SR-latch combiner gated by `~CLK_IN` plus freezing
  tap updates to a quiet boundary (`fall_d` settled) is still the
  silicon requirement.  `T0_PS=200` keeps the corrector's falling-edge
  delay range covering the low half-period.
