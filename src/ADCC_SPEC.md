# ADCC (All-Digital Duty-Cycle Corrector) — interface spec

Shares the ADDLL infrastructure: `PLL_SSBBPD` as a **duty detector**,
`pll_digital_loop_filter` degraded to an up/down counter (KP=0),
`pll_term_decoder_with_zero`, `PLL_COUNTER_DCDL`/`_PHYS` as the
single-edge delay, and a dither-window lock detector.

## Concept

A 50%-duty clock has its rising edge exactly T/2 before the rising edge
of its own inverse.  Feeding `~CLK_IN` and `CLK_OUT` into the SSBBPD
turns the PD into a signed duty-error detector (>50% / <50%).  The loop
then delays only the **falling** edge through the DCDL until the output
high time equals T/2.

## Ports (`ADCC_TOP`)

| Port | Dir | Width | Description |
|---|---|---|---|
| `CLK_IN` | in | 1 | Input clock with duty error. |
| `RST_N` | in | 1 | Async reset. |
| `TICK` | in | 1 | Loop sampling clock. |
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

## Status / open items

- RTL smoke (`adcc_top_tb`, 30% input duty): output duty corrects to
  ~50.9%, but the loop drives `DUTY_CODE` to the rail (211) and does not
  assert LOCKED — the bang-bang PD loses its useful early/late sign when
  the error is large, so it runs to saturation rather than settling.
- **Fixed**: the PD must compare the *inverted* outputs — `~CLK_OUT` rise
  (= CLK_OUT fall, code-controlled) vs `~CLK_IN` rise (= CLK_IN fall, the
  fixed T/2 midpoint).  Comparing the raw rising edges fed a code-
  independent sign and saturated the loop; with `out_n`/`clk_n` it tracks
  the high-pulse width.
- **Added** `duty_sar_search`: on `EN` rising, a binary search on the
  code (PD sign as comparison) seeds the loop near the 50% point, then
  bang-bang tracking holds it.  Smoke: 30% input, `LOCKED` in ~268 TICKs,
  code dithers around the lock point (vs railing at 211 without SAR).
- **Open (physical)**: the recombine `CLK_IN | ~fall_d` produces short
  glitches when the code updates mid-cycle (observed <T periods while the
  code dithers 31..42).  Needs a glitchless edge-combiner (SR-latch /
  symmetric-MUX cell) and to freeze tap updates at a clean boundary —
  the same caveat as ADDLL MUX switching.
