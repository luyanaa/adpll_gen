# CDR_TOP — all-digital clock-data recovery (functional model spec)

## Concept

An Alexander (2×-oversampling bang-bang) PD steers a tapped delay line
that phase-shifts a baud-rate reference `TICK` onto the eye centre of the
incoming NRZ `DATA`.  Reuses the ADDLL infrastructure verbatim:
`PLL_COUNTER_DCDL` (phase shifter), `pll_digital_loop_filter` (up/down,
KP=0), `pll_term_decoder_with_zero`, and a dither-window lock detector.

## Architecture

```
                 ┌──────────────────────┐
   TICK ────────►│ PLL_COUNTER_DCDL     ├──► REC_CLK (data phase)
                 │  COARSE→MID→FINE     │
                 └──────────▲───────────┘
                            │ COARSE/MID/FINE_MUX
   DATA ──► sampler FFs ──► ALEXANDER_PD ──► DLF(up/dn) ──► PHASE_CODE
            D,E samples      early/late       (KP=0)
```

- **Data phase** = `REC_CLK` rising edge (DCDL output).
- **Edge phase** = `REC_CLK` falling edge in this functional model (a
  real implementation uses a second DCDL tap at a fixed 0.5 UI offset,
  or a quadrature phase from the same line).
- `ALEXANDER_PD` emits `10` = early (push delay up), `01` = late (pull
  down); it is re-encoded onto the shared DLF's `{OUT,REF}` symbol set
  (`01` → `11`) before the filter.

## Ports

| Port | Dir | Description |
|---|---|---|
| `DATA` | in | NRZ serial data stream. |
| `RST_N`,`TICK`,`EN`,`KI` | in | Standard loop controls. |
| `PHASE_OFFS`,`PHASE_INIT` | in | Static code offset / preload. |
| `DATA_OUT` | out | Recovered data (centre sample). |
| `REC_CLK` | out | Recovered data-phase clock. |
| `LOCKED`/`ERR` | out | Dither-window lock / loss / saturation. |
| `PHASE_CODE` | out | Current DCDL phase code. |

## Status / open items

- Functional model only: the "samplers" are behavioural delay taps of
  `DATA`, not real FFs, and `PLL_COUNTER_DCDL` `T0_PS=0` makes the code
  directly the sampling phase in ~15 ps LSBs.  A smoke (`cdr_top_tb`,
  PRBS-7 at 0.35 UI offset) shows the loop converging and the lock
  detector asserting; `DATA_OUT` tracks the stream.
- **Open — Alexander sign/phase mapping**: the exact early/late
  convention versus `code` direction, and the 0.5-UI edge-sample
  alignment, are only validated to "loop converges" level.  A real
  signoff needs a mixed-signal sim (real sampler FFs + a quadrature
  edge tap) — the behavioural PD decode is kept deliberately simple.
- **Open — silicon**: needs two matched sampler FFs driven by two DCDL
  taps at 0.5 UI offset plus a retimer; the second tap/FF is the part
  not yet modelled.  Loop latency is 2 TICK (same decode pipeline as
  ADDLL_TOP).
- Lock detector asserts on `PHASE_CODE` dither within ±4; it does not
  prove the eye is centred (same caveat as the ADDLL min-delay lock).
