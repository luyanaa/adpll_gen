# DDR1 clocking — handoff to ddr-phy

Date: 2026-11-28.  Delivers the `adpll_gen` side of
`ddr-phy/docs/ADPLL_DDR1_REQUIREMENTS.md` (DDR1, IHP sg13g2 1.2 V core).
This document is the contract the PHY integrates against: ports, timing,
semantics, evidence, and the open items that are NOT yet closed.  It
supersedes nothing in `docs/DDR1_CLOCKING.md` (architecture detail) or
`docs/DDR1_DLL_ELEMENT_SIZING.md` (element/SPICE data) — it is the
integration summary of both.

## 1. What is delivered

| block | file | state |
|---|---|---|
| clock top | `src/ddr1_clock_top.v` | RTL + 87-check regression, IHP130 synthesized/STA'd |
| ÷3 (300→100 MHz) | `src/ddr1_clk_de3.v` | real cells, TT/SS/FF STA positive |
| CK90 ratio DLL | `src/ddr1_ck90_dll.v` | behavioral + structural (`SEG_IMPL`/`REGEN`) |
| phase TDC | `src/ddr1_dll_tdc.v` | structural signed flash TDC, synth clean |
| element/regen | `src/ddr1_dll_phys.v` | `dll8_line4` macros + strap decoder + SR regen |
| DQS delay line | `src/ddr1_dqs_delay_line_phys.v` | `IMPL=1` real cells, corner CSV PASS |
| jitter evidence | `src/ddr1_jitter_tb.v` | 8/8, numbers below |

## 2. Port contract (DDR1_CLOCK_TOP)

```
MCK_IN        in   300 MHz   ADPLL DCO (FCW=3 × REF 100 MHz)
PLL_LOCKED    in             upstream PLL lock (phase lock, see §7)
RST           in   async, active high
EXT_CK/EXT_CK90/EXT_SYS_CLK  in   Phase-A bypass clocks
BYPASS        in   static strap, committed only during RST
CK_PHY        out  100 MHz, low until PHY_LOCKED
CK_PHY_N      out  100 MHz complement, length-matched path
CK90_PHY      out  100 MHz, CK + 2.5 ns ± spec, low until PHY_LOCKED
SYS_CLK       out  50 MHz = CK/2, rising edge on a CK rising edge
PHY_LOCKED    out  high only when PLL + CK90 phase + monitor all valid
ERR           out  sticky (loss, CK90 phase violation, rail, acq timeout)
DBG[15:0]     out  {dll_code, monitor state, ...} — non-functional
```

Semantics that the PHY may rely on:

- **Fail-closed**: every output is low while `PHY_LOCKED=0`; ERR is sticky
  until RST.  A CK90 phase excursion beyond 640 ps master (160 ps CK90)
  for 3 measurements (~30 ns) drops PHY_LOCKED and sets ERR — the loop can
  move at most 3 LSB in that window, so it cannot ride a violation out.
- **First valid CK already has a defined 90° relation** (registered release
  on a CK rising edge; no runt, no 180° ambiguity — the monitor rejects an
  inverted CK90 both at start-up and in operation).
- **Lock time**: behavioral 300 ns; the real limit is the DLL's 1-LSB per
  10 ns acquisition, worst case ~130 codes ≈ 1.3 µs.  Budget is 200 µs.
  The upstream PLL's own lock time dominates — see §7.
- **Continuous tracking** with a dead zone: the code holds while the
  measured residual is inside ±HOLD_PS (65 ps master = 16 ps CK90) and
  re-engages on the next measurement when drift leaves the band.

## 3. Timing evidence (behavioral/RTL + measured cells)

| item | value | source |
|---|---|---|
| CK period | 10.000 ns exactly (÷3 of 300 MHz) | clock regression |
| CK duty | 50% at 50% MCK duty; input duty error attenuated 3× (40/60% → 46.7/53.3%) | `ddr1_clk_de3.v` header + TB |
| CK90 lag | 2500 ps ± dither; dead-zone residual ≤ 16 ps CK90 | regression + `TRIM_MASTER_PS` |
| CK90 period jitter (clean input) | **0 ps pk-pk, 0 ps c2c** | `ddr1_jitter_tb.v` |
| CK90 under injected ±15 ps/half-period MCK jitter | 1:1 transfer, **0 added** | same |
| DQS line | 128 taps × 1 cell, monotonic, 65/100/45 ps per code TT/SS/FF | corner CSVs |

Jitter methodology = the spec's definitions (period jitter = max−min of
successive periods; c2c = max |T_{i+1}−T_i|), measured at the output pins
over 2000 periods.  **The production jitter number is the DCO's own** — this
chain passes it through 1:1 and adds nothing measurable.

## 4. Real-cell status

- **Segments**: 2 × `dll8_line4` hard macro per quarter segment (N=8
  elements), one shared 7-bit thermometer code, stock `sg13g2_inv_4`
  driver stages.  Chain SPICE (bare cascade, 21/21 clean): lock codes
  32.7 / 71.6 / 94.2 SS/TT/FF, monotone, FF headroom 33 codes,
  `CODE_INIT=48` puts every corner's initial residual inside the TDC's
  unambiguous window (SS +2405 ps vs +2920 ps limit — the tight one; if
  integration loading moves it past, raise CODE_INIT).
- **Chain asymmetry** (tpHL−tpLH) accumulates to +1.5 ns at SS high codes,
  so **SR regeneration is mandatory**, not optional: `DDR1_CLK_REGEN`
  (dfrbp + 8-inverter reset pulse, ~400 ps; a 2-inverter 47 ps pulse does
  not reset the flop — measured) sits at the master measurement point and
  at CK90.  Regeneration is outside the ratio path, so it cancels in the
  loop except for a **(3/4)·D_set + D_EN_gate** systematic at CK90, which
  `TRIM_MASTER_PS` nulls once SPICE/STA gives the numbers.
- **Mismatch**: σ(CK90) ≈ √10 × 1.7 ps ≈ 5.4 ps → 3σ ≈ 16 ps vs the
  ±100 ps target.  Requires common-centroid/interdigitated placement of
  the five segments; cross-die gradients are outside the measured
  same-macro number.

## 5. DQS line — what the consumer must know

- 128 codes, one `FINE_DELAY_CELL` per tap, `TAP_BITS=7`.
- Range exceeds one 10 ns DQS period at SS (12.65 ns) — **cap the usable
  code window per corner**; codes above the period alias.
- Update protocol mirrors `ddr_dqs_delay_adpll.sv`: apply on the first
  idle sys edge, ready after `SETTLE_CYCLES`, ack only on
  `tap_valid && tap_ready`; capture is forced low during the settle window
  (only safe under the idle-bus contract).  `UPDATE_IDLE=0` with an
  in-flight apply sets sticky `TAP_ERROR`.
- Monotonicity: measured monotone at TT/SS/FF pre-layout; routing
  parasitics are the remaining re-verification (pass 2).

## 6. Integration checklist for ddr-phy

1. Drive `PLL_LOCKED` from the ADPLL macro's `LOCKED` (see §7) and `RST`
   from the power-on reset; assert `BYPASS` only if the board drives all
   three external clocks.
2. `CK_PHY`/`CK_PHY_N` go to the CK pad macro; `CK90_PHY` is core-only
   (used by `ddr_edge_out`), per the requirements doc.
3. `SYS_CLK` may be used as the DQS-line sys clock; its rising edge is
   aligned to a CK rising edge (≤0.2 ns budget, STA item).
4. Treat `ERR` as a fatal, latched fault: it requires RST to clear.
5. Do not gate/qualify `CK90_PHY` externally — the block already
   fail-closes it.

## 7. Open items (honest list)

- **Upstream `PLL_LOCKED` semantics**: the macro's RTL is phase-locked by
  construction (`LOCK = PHASE_LOCK & FREQ_OK`; the FSM requires
  `PHASE_LOCK` before asserting `LOCKED`), so a frequency-only assertion
  would be a simulation artifact, not the intent.  But the reviewer's
  observation stands: **the macro has never asserted LOCKED in
  behavioral simulation**.  The DDR1 requirement's 200 µs budget will be
  dominated by this, and the DDR chain's own ÷3+DLL adds ~1.3 µs at most.
  Resolve on the ADPLL macro side before claiming the power-up window.
- **D_set / regen phase shift / regenerated duty**: SPICE harness written
  (`flow/characterization/ddr1_dll_regen.py`), first numbers pending.
  This is the last systematic-phase unknown; `TRIM_MASTER_PS` consumes it.
- **STA of the integrated top** at TT/SS/FF: structural elaboration is DONE
  (`flow/sta/synth_ddr1_dll.sh`: 1286 cells, 10 dll8_line4 macros, no
  errors); liberty-mapped timing with the macro .lib files and parasitics
  is NOT.
- **Systematic-phase calibration**: `TRIM_MASTER_PS` must be set from
  SPICE/STA.  With REGEN=1 the residual is (3/4)·D_set + D_EN_gate, i.e.
  `TRIM_MASTER_PS = 3·D_set + 4·D_EN`.  A first SPICE point measures
  D_set ≈ 205 ps before the output buffer (≈275 ps with it) and a
  master-vs-CK90 regeneration skew of 0.1 ps — so the raw systematic is
  ≈250 ps at CK90, OUTSIDE the ±200 ps spec: TRIM is mandatory, not
  optional.  Corner sweep running; `flow/characterization/
  ddr1_regen_trim.py` converts the results into the TRIM table.
- **DCO jitter**: the period/c2c budget for the 300 MHz DCO itself is not
  measured in this repo; the DDR1 chain is transparent to it (1:1).
- **DQS post-route** monotonicity and select-dependent load bending.

## 8. What changed 2026-11-28 (so the PHY side does not chase stale docs)

- Frequency plan: DCO 300 MHz ÷3 (200 MHz / ÷2 / DCC / ADCC retired).
- CK90 source: ratio DLL only; DE2 candidate A removed from the top.
- Measurement: TDC-honest (modulo-T + tap quantization) behaviorally, plus
  a structural signed flash TDC behind `TDC_IMPL=1`.
- Loop: dead-zone hold (jitter), `TRIM_MASTER_PS` calibration.
- Monitor: MCK-grid edge-order, synthesizable; injection mux is
  `ifdef SIMULATION` only.
