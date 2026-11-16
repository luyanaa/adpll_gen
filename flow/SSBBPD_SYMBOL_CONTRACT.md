# SS-BBPD symbol contract (Core A)

Scope: the NAND-latch phase detector in `src/ssbbpd.v`, the default decode
in `src/digital_loop_filter.v`, and `src/lock_detector.v`.  This is a
functional contract, not a phase-noise or PVT signoff.

## 1. Bit layout

`SS_BBPD[0]` is the buffered `OUT_NANDY` output.  `SS_BBPD[1]` is the
buffered `OUT_NANDX` output.  Written as a two-bit literal the value is
`{SS_BBPD[1],SS_BBPD[0]}` = `{OUT,REF}` in the filter's names.

The latch inputs are the balanced (inverted) signals:

- `INJ_EDGE_BALANCED = !INJ_EDGE`
- `OSC_BALANCED = !FINE_OUT`

`nand_y` is driven by `INJ_EDGE_BALANCED` and `OUT_NANDX`; `nand_x` is
driven by `OSC_BALANCED` and `OUT_NANDY`.

## 2. Four states

| Code | `{OUT,REF}` | Latch condition | Meaning |
|---|---|---|---|
| `2'b01` | 1,0 | `INJ_EDGE=1`, `FINE_OUT=0` | P: oscillator low at the sampled edge |
| `2'b11` | 1,1 | `INJ_EDGE=1`, `FINE_OUT=1` | N: oscillator high at the sampled edge |
| `2'b00` | 0,0 | not a solution | invalid; both NAND outputs low cannot be stable |
| `2'b10` | 0,1 | `INJ_EDGE=0`, `FINE_OUT=1` | latch resolution outside the sampled phase; invalid at the decision edge |

`00` is not reachable as a stable state: `Y=0` requires `X=1`, while `X=0`
requires `Y=1`.  A real gate-level transition can produce a short `00`
pulse while one output is still falling, so a receiver must treat it as
invalid, not as "no correction".

`01` is a valid stable state of the latch, but it is the resolved state
while `INJ_EDGE` is low.  At the decision edge (below) only `01` and
`11` are present.

## 3. Sampling edge

`pll_digital_loop_filter` is clocked by `!INJ_EDGE`; its sampling edge is
`posedge(!INJ_EDGE)` = `negedge INJ_EDGE`.  At that edge `INJ_EDGE` has
been high, so the latch is transparent and its outputs are `01` (P) or
`11` (N).  The lock detector uses the same edge.

Sampling on `posedge INJ_EDGE` instead sees the latch state from the
`INJ_EDGE` low phase, where `10` and the held `01/11` states mix.  That
is not the phase decision and is why the previous detector saw only one
symbol.

## 4. Regression evidence

`src/ssbbpd_contract_tb.v` walks a 0.974 ns oscillator against a 10 ns
reference and counts the code at both edges over 200 cycles:

```text
posedge INJ: 00=0 01=0 10=200 11=0
negedge INJ: 00=0 01=99 10=0 11=100
```

The DLF edge never sees `00` or `10`, and sees both P and N.  The test
asserts both properties and fails if either is violated.

## 5. Lock criterion

Because every comparison produces P or N, there is no quiet code to run
a no-symbol counter on.  `pll_lock_detector` now qualifies a window of
`LOCK_COUNT` valid samples that contains both signs.  `00`, `10`, and a
saturated filter (`ILL_P`/`ILL_N`) are invalid samples: they reset the
window, and `LOSS_COUNT` consecutive invalid samples drop an existing
lock.  A window that completes with only one sign also drops an existing
lock.  `LOCK_LOST` is raised only after a qualified lock fails.

This is an activity/balance check.  It cannot detect a detector that
toggles P/N artificially, and it does not measure phase error.

## 6. Closed-loop status

`src/pll_macro_top_tb.v` now counts the real stream after `FREQ_LOCKED`.
With the behavioral `sim_*` netlist, `FCW=16`, 400 REF cycles:

```text
P=134  N=266  invalid=0  ILL=266
DLF_INT=257  FINE=0  PHASE_LOCK=0
```

Every N sample also asserts `ILL_N`.  The 16-bit filter output sits at
257 while `KP=3967`, so the N correction underflows and the fine code
sits at 0.  The phase loop cannot apply the N correction in this run;
this is not a symbol-code failure and not a lock.  The next gate is a
fine-code bias/range and gain review, then a closed-loop lock, forced
unlock and relock with the real BBPD stream.

## 7. Not claimed

- No PEX, PVT, pad-jitter or phase-noise result.
- The P/N sign has not been proven against an independent phase sweep in
  a closed loop; the table above is the functional decode.
- The behavioral `sim_*` netlist is not a transistor-level latch.
