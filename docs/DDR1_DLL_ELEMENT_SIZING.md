# DDR1 CK90 DLL segment sizing — analysis from measured dll8 element data

Date: 2026-11-28. Input data: `flow/characterization/dll8_pex/REPORT.md`
(SPICE-measured, real sg13g2 with wire caps, all three corners).

## The problem

Each quarter-replica segment of the CK90 ratio DLL must present exactly
T/4 = 2500 ps at lock, at every corner, with the loop trimming a shared
code. The segment is a chain whose fixed part dominates and whose trim
must cover the corner spread.

## Measured element facts (dll8_pex/REPORT.md)

In-chain element delay (×1.17-1.23 interconnect loading on the isolated
element):

| corner | element delay @c0 | trim span c0→c127 | LSB |
|---|---:|---:|---:|
| SS | ~457 ps | +88 ps | 0.69 ps |
| TT | ~285 ps | +60 ps | 0.47 ps |
| FF | ~193 ps | +44 ps | 0.35 ps |

Element structure (SPICE version): INVX4 → mid → INVX4, 7-bit binary
NAND3-switched cap bank on mid. **Trim contrast is tiny** (~0.05 fF/finger
effective) — the bank adds much more to BASE (always-on B-pin cap ~51 fF)
than to the tunable range. A single element trims only ~15-23% of its own
delay.

## Corner reachability arithmetic

2500 ps reachable per corner (chain of N elements, trim at one code):

| corner | N needed | chain range @ that N | lock code |
|---|---:|---:|---:|
| SS | 5 | 2284–2724 ps | ~62/127 |
| TT | 8 | 2283–2763 ps | ~57/127 |
| FF | 12 | 2316–2844 ps | ~44/127 |

**No single N covers all corners** (N=5 spans 965–2724 across corners but
not at any fixed N — the corner spread is 2.4×, the trim only ~20%).

## Architecture consequence: coarse length + fine trim

The segment needs a 2-bit coarse length select in addition to the shared
fine code:

1. **Coarse length** N ∈ {5, 8, 12} (or a binary 4/8/0 added-element bank).
   Selection is quasi-static: set at initial acquisition per corner, or
   updated only when the fine code rails (saturate-and-carry). Coarse
   transitions necessarily lose lock → PHY_LOCKED drops (fail-closed by
   design) and the loop re-acquires — acceptable because corners don't
   drift across the full SS↔FF spread in operation.
2. **Fine trim** distributed across the chain or concentrated. With the
   measured per-element trim, distributing the bank over all N elements
   gives 440-1200 ps of chain trim — more than needed; concentrating on
   fewer elements saves area but reduces range proportionally.

## Open sizing questions (need SPICE, pass 2)

1. **Trim bank redesign**: the NAND3-finger contrast is too weak. Options:
   (a) true sg13 moscap fingers (the original dll8 concept, ~12.8 fF/finger
   — but the SPICE report shows NAND3 was what got built/measured; need to
   check why), (b) larger/stronger switched-cap driver, (c) accept the weak
   trim and use finer coarse steps (more coarse levels). Decision needs a
   SPICE iteration loop on the element.
2. **Area**: 5 replicas × N elements × (2×INVX4 + 127-finger bank). The
   bank dominates. If trim concentrates on 2-3 elements per segment, area
   drops ~4×. Slave replica must match master segments exactly (ratio
   accuracy!) — mismatch goes directly into CK90 error. Per-segment
   matching, not just per-element, matters.
3. **Edge-rate / pulse integrity**: the chain must propagate 5 ns-wide
   pulses without droop; element tr/tf ~106/108 ps TT is fine. The final
   slave element drives the CK90 output buffer — output edge rate affects
   the monitor sampling.
4. **Coarse-mux glitching**: the length-select mux is inside the delay
   path. Coarse changes are only legal during re-acquisition (lock already
   dropped); the mux itself must be break-before-make or the control
   sequenced through reset. Simplest correct scheme: change coarse only
   while RST_DLL is asserted.
5. **Alternative worth one evaluation round**: resistor-style degeneration
   is not available in pure digital flow, but a **supply/starved inverter
   chain** (current-starved elements with bias from a digital-to-bias
   ladder) gives wide smooth tuning with few elements. IHP130 analog
   collateral exists in the repo for the DCO; a starved-inverter segment
   is a smaller analog block than a 5×12-element digital chain. This is
   the classic DLL cell — evaluate against the digital area/effort.

## Interaction with the loop parameters (behavioral model today)

- Behavioral segment law today: CELL_X4_MIN=96 (24 ps×4) + step 1 ps×4 per
  LSB, 64 cells/segment, code init 40 → per-segment range ~1.5-2.6 ns×…
  The behavioral law need NOT match the real law; what must match is
  lock/loss detection scaling (LOCK_TOL 192/LOSS_TOL 640 ps master).
  Fine LSB at lock with the measured bank: chain-level LSB ≈ 0.5-0.7 ps
  per element × N elements ÷ shared — i.e. 2.5-8 ps master per LSB step.
  Post-lock bang-bang dither ±1 LSB → ±2.5-8 ps master = ±0.6-2 ps CK90.
  Well within spec; the behavioral model's ±16 ps CK90 dither was
  pessimistic, which is fine for verification margin.

## Recommendation for pass 2 sequencing

1. SPICE-evaluate the starved-inverter alternative vs the dll8-bank chain
   for one segment at TT/SS/FF (1-2 days of iteration, reuses existing
   characterization harness).
2. Whichever wins, build the segment as a structural Verilog module with
   IMPL-split like the DQS line; characterize per-corner.
3. Only then rewrite the phase detector (TDC) — its resolution requirement
   (≤64 ps taps) is independent and can proceed in parallel with the
   FINE_DELAY_CELL tap measurement flow already proven for DQS.
