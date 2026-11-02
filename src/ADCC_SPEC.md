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

- RTL smoke (`adcc_top_tb`, 30% input duty): the loop converges to a
  *wrong* equilibrium — `DUTY_CODE` settles at a parasitic-lock value
  and `CLK_OUT` shows sub-period pulses (period < T).  **The PD
  reference is architecturally wrong** (see below); the earlier
  "50.9% lock" was an artefact of the unrealistic `T0_PS=4000`
  insertion delay making `fall_d` in-phase with `~CLK_IN`.
- **Architecture issue (root cause)**: a bang-bang PD comparing
  `~CLK_OUT` rise (corrected falling edge) against `~CLK_IN` rise
  (input falling edge) measures the corrected fall against the
  *uncorrected* input fall — which sits at the input's own duty point
  (e.g. 30%), **not** at T/2.  The corrected fall should land at T/2,
  which is `clk_in fall + (T - 2·t_high)/2` — always *after* the input
  fall for any under-50% input, so the PD sign is permanently "late"
  and the loop rails.  A rising-edge PD needs a **quadrature (T/2)
  reference**, which the single BBPD cannot supply.
- **What does work / reuse**: the delay path is correct —
  `CLK_OUT = CLK_IN | ~fall_d` with `fall_d = ~CLK_IN` delayed by `d`
  places the output fall at `clk_in rise + t_high + d`; setting `d`
  so that sum hits T/2 corrects the duty (verified analytically:
  30% input needs `d ≈ 0.8 ns` ≈ code 40 at 15 ps/LSB + 200 ps T0).
  The two-stage decode pipeline and `duty_sar_search` are kept and
  are reusable once the PD is fixed.
- **Real fix (next lane)**: give the duty detector a true T/2
  reference.  Options: (a) a second half-DLL generating `clk_in + T/2`
  (quadrature) and compare `~CLK_OUT` against *that*; (b) an
  integrator/averaging PD (charge-pump style duty-to-voltage, then a
  comparator) instead of edge-bang-bang; (c) measure `CLK_OUT` vs
  `CLK_OUT` delayed T/2 — still needs a T/2 element.  All three need
  one more delay element, i.e. real DCCs invariably use a quadrature
  reference or an RC/averaging PD, not a bare BBPD on the two edges.
- **Open (physical)**: parasitic second pulse when `fall_d`'s delay is
  comparable to the low period — the OR recombine re-exposes the
  previous high pulse if `fall_d` hasn't settled within the low window.
  A pulse-swallow / SR-latch combiner gated by `~CLK_IN` is needed, and
  tap updates must be frozen to a quiet boundary (`fall_d` settled).
  `T0_PS` was dropped to 200 for the corrector's falling-edge path so
  the delay range actually covers the low half-period.
