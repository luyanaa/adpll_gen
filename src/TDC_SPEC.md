# TDC_TOP — SAR time-to-digital converter spec

## Concept

Measures the delay of `SIG` relative to `REF` by pushing `REF` through
the shared DCDL and **binary-searching** the tap code until the delayed
`REF` edge coincides with the `SIG` edge.  `TDC_CODE × LSB` is then the
measured interval.  This is the cheap SAR/TDC variant — one delay line
plus a linear search engine — against the expensive flash-TDC option
(per-tap arbiter chain) in the research table.

## Architecture

```
   REF ──► PLL_COUNTER_DCDL ──► ref_d ──┐
            (tap = mid code)            │ DFF: sample SIG at ref_d edge
   SIG ────────────────────────────────►│ sig_q  ->  pd_late
                                        │
            SAR FSM ◄── pd_late ────────┘
            (binary-search mid over 0..TOTAL_STEPS)
```

- Each SAR step sets `mid`, waits `SETTLE` TICKs, then samples
  `pd_late` (SIG already high when `ref_d` rises ⇒ delayed edge is
  late ⇒ shrink `hi`; else raise `lo`).
- Requires a **repetitive** `REF`/`SIG` pair — each step consumes the
  next `REF` edge.  A single-shot conversion needs a held edge and a
  re-armed delay line (not modelled).
- Decode is the same shift/saturate `code → COARSE/MID/FINE` tap map
  as ADDLL (`code = fine + 4·mid + 8·coarse`).

## Ports

| Port | Dir | Description |
|---|---|---|
| `REF` | in | Reference edge (repetitive). |
| `SIG` | in | Edge to measure vs `REF`. |
| `RST_N`,`TICK` | in | Reset / SAR clock. |
| `START` | in | Begin a conversion. |
| `TDC_CODE` | out | Converged code (× LSB = measured interval). |
| `DONE`/`BUSY` | out | Conversion done / in progress. |

## Status / open items

- Verified (`tdc_top_tb`): periodic `REF`, `SIG = REF + 0.9 ns`,
  converges to `TDC_CODE=63` → 945 ps, within ~45 ps (3 LSB) of the
  injected value at the 15 ps/LSB model.  **PASS.**
- Resolution = FINE LSB (~15 ps model); range = `TOTAL_STEPS` = 211
  codes ≈ 3.2 ns.
- **Open**: single-shot operation needs an edge-hold + re-arm (a real
  TDC measures one transition, then resets); the current engine assumes
  the REF/SIG pair repeats so each SAR step sees a fresh edge.  Also
  needs a metastability/arbiter cell on the `sig_q` sampler for
  sub-LSB resolution — bang-bang only gives ±1 LSB.
- Silicon view uses `PLL_COUNTER_DCDL_PHYS`; the `T0_PS=0` behavioural
  line makes `code` directly the delay in the functional model.
