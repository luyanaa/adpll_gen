# DDR1 frequency plan — go/no-go analysis and verdict

Date: 2026-11-28. Method: IL-DCO ring free-running frequency endpoints,
unit-level transistor netlist (no wire RC), ngspice against
`cornerMOSlv.lib` mos_tt/mos_ss/mos_ff, same harness as the TT campaigns
(`flow/characterization/ihp_l3_corners.py`, 100 ns window, tstep 0.1 ns
at FF — 0.25 aborts on FF slow codes, see note below).

## Verdict: DCO = 300 MHz (FCW=3 × REF 100 MHz) ÷3 → 100 MHz is GO

Decision 2026-11-28 (user: ADPLL-in-path, endpoints measured first).

| corner | measured range endpoints | 300 MHz inside? | margin to near rail |
|---|---|---|---|
| TT (mos_tt, 1.20 V, 27 °C) | 212.1 (c15/m15/f31) – 624.3 (c0/m0/f0) MHz | YES, mid-range | comfortable both sides |
| SS (mos_ss, 1.08 V, 125 °C) | 111.8 – 370.0 MHz | YES | +70 MHz (+23%) to fast rail |
| FF (mos_ff, 1.32 V, −40 °C) | **262.2** – 903.2 MHz | YES | **−38 MHz (−13%) to slow rail** |

All three corners cover 300 MHz ⇒ the loop can hold exactly 100 MHz at the
pin at every corner. The binding margin is FF: the lock code sits in the
top ~13% of the tuning range there. Temperature/voltage drift within
operation is much smaller than the full corner-to-corner swing, so the
residual in-corner margin is adequate but thin — the jitter measurement
(pass 2 item) must include a code-drift sanity check.

Raw data: `sim/outputs/ihp-sg13g2/l3_corners/{tt_check,ff,ff_t010,ss}/dco_tuning_l3.csv`
+ this file's companion table below. TT endpoints from the existing dense
campaign `flow/characterization/ihp_l3/dco_tuning_l3.csv` (sparse axes).

## Measured points

TT reference (methodology check): c8/m8/f8 = 292.7 MHz vs sparse-table
287.9 MHz — agreement within windowing error.

SS (tstep 0.25 converged everywhere):

| code | f MHz |
|---|---:|
| c0/m0/f0 | 370.0 |
| c8/m8/f8 | 160.4 |
| c12/m0/f0 | 145.0 |
| c15/m0/f0 | 114.1 |
| c15/m15/f31 | 111.8 |

FF (tstep 0.1 required — see trap note):

| code | f MHz |
|---|---:|
| c0/m0/f0 | 903.2 |
| c15/m15/f31 | 262.2 |
| (c8/m8/f8, c15/m0/f0, c12/m0/f0 refill in progress) | — |

## Dead alternatives (for the record)

- DCO=200÷2: 200 < TT minimum 212 — dead across the board, not marginal.
- DCO=400÷4: 400 > SS maximum 370 — dead at SS rail.
- DCO≥500: dead at SS. Anything below 300: dead at TT or FF.
  300÷3 is the *only* 100·N frequency inside the three-corner intersection.
- REF-direct (bypassing the ADPLL): viable fallback, rejected by user
  decision in favor of ADPLL-in-path.

## Derived requirements for pass 2

1. **÷3 dual-edge divider** for 50 %-duty MCK: DDR1_CK90_DE2-style
   posedge+negedge structure, extended to mod-3. The DLL locks on the
   resulting 100 MHz CK regardless of its exact shape, but the DDR1 spec
   needs CK duty 45-55 % — dual-edge construction gives 50 % by toggle.
2. **FCW=3 integer injection locking** — within the documented IL limit
   (REF 100 MHz, N ≤ 8 for OUT ≤ 836 MHz; flow/ADPLL_FREQ_DIV.md §4).
3. **Jitter evidence** (requirements §2: period jitter ≤ 100 ps pk-pk,
   c2c ≤ 50 ps) must come from the locked loop, not the free-running
   ring — pass-2 open item, measurement path TBD.
4. Watch: the fine bank is non-monotone at interior codes (documented in
   `flow/characterization/ihp_l3_dense/README.md`) — the loop hunts with
   bang-bang dither anyway, but monotonicity matters for the lock
   transient; keep to coarse/mid-heavy operating points if this bites.

## Trap notes for reproduction

- **tstep must be 0.1 ns at FF for slow codes**: tstep 0.25 converges at
  TT/SS everywhere but aborts "Timestep too small" mid-run on FF c8/c12/c15
  (sharp ring edges + fast corner). FF c0/m0/f0 converged even at 0.25.
- `ring_pvt.csv` 20-48 MHz numbers are a DIFFERENT oscillator
  (BASE_NDELS=256), not the IL-DCO — do not use them for range reasoning.
- The earlier "FF min ≈ 325 MHz" extrapolation from the single c8/m8/f8
  PEX point was wrong because PEX includes wire RC and this harness is
  unit-level — measured unit-level FF min is 262.2 MHz. The consistent
  comparator is like-for-like within one harness.
