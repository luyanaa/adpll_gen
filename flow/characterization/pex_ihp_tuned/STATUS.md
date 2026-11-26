# Tuned short-ring DCO — campaign status (2026-11-26)

Driver: `flow/characterization/dco_tuned_pex.py` (decks /tmp/opencode/dcopex/decks,
results JSON on /grid). Bug fixed 2026-11-26 per orchestrator: parse key type
(`waves["v{key}"]`), settle/stop were compared in ns against seconds (that is why
all sweep JSON metrics were empty while the tran.out waveforms were valid), real
exception strings recorded.

## Design as implemented (RTL + SPICE in lockstep)
- `src/pll_multiphase_dco.v`: NSTAGE=25 (PH_W=3, STEP=3), AND2X1 closure, taps
  at k*STEP via dont_touch BUFFX0 — geometry untouched.
- Stage inverter = **PLL_CELL_INVX4** (sg13g2_inv_4) on all 25 stages, uniform.
- Ports `COARSE[4:0]`, `FINE signed [5:0]`; global decode once: fine_idx=FINE+32.
- `dco_stage` per stage output: inv_4 + 5-bit coarse bank + 6-bit fine bank
  (both switched sg13_moscap banks, GATE-side switches) + 11 dont_touch buf_1
  + sg13g2_decap_4.
- Coarse switch map (SW_M per bit): **1,1,2,4,8** (bit4 raised 4->8 on
  2026-11-26 to kill the last up-jump). Fine group switch map: **1,1,1,2,4,8**.
- One-shot startup kick (brief risk 7): EN delayed 3x dont_touch inv_1;
  kick = AND(EN, ~EN_d3), ORed into the closure; ~3 gate delays at release only.
- Known PDK note: cornerMOSCAP.lib has only moscap_tt (no cap_wcs/bcs).
- Documented deviations from the brief: NAND3 fine bank -> switched moscap
  (nand3_1 B pin ~0.4 fF, ~0.05 fF contrast at ring edge rates); plate-side
  switching -> gate-side switching (1.3 fF/finger dead load measured).

## FINAL SS rate table (2026-11-26, with-wire deck: SPEF wire caps + m8 bit4
## + w0.15u switches + kick; driver metrics fixed)
| code | f (MHz) |  | code | f (MHz) |
|---|---|---|---|---|
| 0 | 279.4 |  | 16 | 202.0 |
| 1 | 270.6 |  | 17 | 193.5 |
| 2 | 270.0 |  | 18 | 192.5 |
| 3 | 261.1 |  | 19 | 184.3 |
| 4 | 260.5 |  | 20 | 183.2 |
| 5 | 251.6 |  | 21 | 175.2 |
| 6 | 250.9 |  | 22 | 174.2 |
| 7 | 242.0 |  | 23 | 166.4 |
| 8 | 241.2 |  | 24 | 165.2 |
| 9 | 232.2 |  | 25 | 157.8 |
| 10 | 231.5 |  | 26 | 156.7 |
| 11 | 222.6 |  | 27 | 149.5 |
| 12 | 221.8 |  | 28 | 148.4 |
| 13 | 212.9 |  | 29 | 141.6 |
| 14 | 212.1 |  | 30 | 140.5 |
| 15 | 203.5 |  | 31 | 134.1 |

- **MONOTONE: 0 up-jumps over all 31 adjacent pairs.** (c23's sweep "DEAD" was
  an 18 ns window artifact; re-run at 40 ns = 166.4 MHz.)
- **GAP-FREE: max adjacent step 8.9 MHz << fine half-span 86 MHz (measured).**
- 250 MHz bracketed by c6 (250.9) / c7 (242.0); fast end 279.4 (+29 over 250);
  slow end 134.1. Fine LSB ~2.8 MHz; >=2 fine LSB headroom at 250 both sides.
- With-wire fast end at f=-31: 336.9 MHz (L_wire_c0_f-31 deck).
- c31 dead state: fixed by the one-shot kick (init 0 and X identical).

## FINAL PER-CORNER TABLES (f=0, final config, with-wire; all PRE-layout)
FF: 658.6 (c0) -> 289.3 (c31) MHz, 0 up-jumps, max step 23.8 MHz;
    500 between c12 (505.9) and c13 (483.2) - headroom +158 / -211.
TT: 436.7 (c0) -> 200.6 (c31) MHz, 0 up-jumps, max step 15.0 MHz;
    250 between c23 (250.5) and c24 (248.6);
    **500 NOT reachable at TT (fast end 436.7) - FLAGGED**: the approved
    corner-graded contract requires 500 at FF ("marginal OK at TT"), and TT
    misses it by 63 MHz. This is the one rate-coverage shortfall; no tuning
    change attempted around it.
SS: 279.4 (c0) -> 134.1 (c31) MHz, 0 up-jumps, max step 8.9 MHz;
    250 between c6 (250.9) and c7 (242.0); fast end at f=-31 = 336.9 MHz.



## OPEN / REMAINING (in order)
1. TT COARSE sweep (running at report time). FF table (final config, f=0,
   with-wire): **658.6 (c0) -> 289.3 (c31) MHz, STRICTLY MONOTONE (0 up-jumps,
   max step 23.8 MHz < fine half-span 86)**; 500 MHz bracketed by c12 (505.9) /
   c13 (483.2), inside the range with +158 / -211 margins. ss_sweep5_wire.json
   and ff_sweep_wire.json hold both tables.
2. Six acceptance measurements on the loaded tops (tb_rx_loaded / tb_tx_loaded
   decks generated and wired): startup x2 releases x2 inits x c0/c31; duty
   45-55% at the flop clock pin at the 250-locked code (~c6/c7) AND c31
   (pre-resize c31 SS duty 55.2% at ph0 was at the 55% edge — brief risk 5
   split-NMOS/PMOS remedy if confirmed); RX 8-tap phase <=30 ps at c0 AND c31
   (TX quadrature separate); PI-switch min pulse >=40% T/8; fine symmetry.
3. M4: regenerate MANUAL_GLOBAL_PLACEMENTS keyed on STEP (fat ~50-cell
   dco_stage, abutted, taps Metal3 downward), LibreLane macro build, post-route
   loaded tap uniformity + DRC/LVS, and the >=250 MHz ROUTED @ SS confirmation.
   The wire caps are now inside the SPICE decks, so the M4 delta is layout
   variation only — the old 1.16 penalty guess is retired.



## 2026-11-27: tap-grid geometry defect + STEP=6/NSTAGE=23 iteration (M4 held)
- Verified the tap-grid defect at NSTAGE=25/STEP=3: taps span 21 of 52 gates
  (0.404T) with T/8 = 6.5 gates -> phases 3 and 7 fall in the gaps
  (nearest-tap error ~84 ps > 30 ps). The 13.1 ps linear-fit residual was a
  tap-evenness metric, not sampler-grid conformance.
- Re-parameterized to STEP=6 / NSTAGE = 8*STEP/2 - 1 = 23 (RTL formula
  NSTAGE = NPHASE*STEP_EFF/2 - 1; cdr_top/rx_clk8/tx_clk4 STEP=6), taps now
  4 nodes n0/n6/n12/n18 + INVX4 complements (the PHASE[k] = ~PHASE[k-4]
  contract the PI/tx_clk4 already assume). Elab clean (23 stages).
- Measured with-wire (SS): NSTAGE=23 c0/f-31 = 363.5 MHz, c0/f0 = 302.4 MHz.
- BUT: the closure is not one gate-slot. AND2+OR2+kick = 6.4 slots ->
  T/8 = 7.35 slots, tap intervals -18%, conformance 0/-70/-142/-224 ps.
  AND2-only closure = 3.8 slots -> wrap interval 8.8 slots vs required 6.
  No odd NSTAGE with the AND2 closure closes the grid (21 -> +49 ps err,
  19 -> -1.2 slots); NSTAGE=20 near-exact but even -> latches.
- PROPOSED (awaiting approval): NAND2(chain, EN) single-gate inverting closure
  (~1.9 slots) + EVEN NSTAGE=22 -> loop 23.9 slots, T/8 ~= 6.0, wrap 5.9;
  delay-free kick (off-state pass on chain[0]); symmetric taps (lower 2xINVX4,
  upper 1xINVX4) rather than buf vs inv_4 (9% load asymmetry measured).


## 2026-11-27 (later): NAND2-closure iteration - L cannot reach 4*STEP (M4 held)
Approved items built: NAND2(chain,EN) inverting closure; delay-free kick (pmos
pull-up on n0, 4-inverter delayed EN copy outside the loop; two polarity bugs
found and fixed, steady-state period verified unaffected); symmetric taps
(lower 2xINVX4 buffer, upper 1xINVX4). NSTAGE = 8*STEP/2 - 2 = 22.
Measured (SS, with-wire): c0/f0 T=3.541 ns (282.4 MHz) L=24.59 slots
(closure 2.59, residual +0.59 slots = +43 ps); c0/f-31 T=2.919 ns
(342.6 MHz) L=25.31 (closure 3.31, +1.31 slots = +75 ps).
Conformance |tap_k-k*T/8| max 96.0 ps (f0) and 108.6 ps (f-31) -> FAIL 30 ps.
Cause: closure 2.6-3.3 slots AND 0.7-slot code dependence; even-NSTAGE
granularity 2 slots => best residual +-0.4..0.7 slots; 21/23 latch.
Verdict: L = 4*STEP is unreachable within 30 ps for any valid NSTAGE with this
closure. Recommended: two-ring fallback (separate sampler-clock ring). M4 held.

## Runtime facts
- ngspice + psp103.osdi: ~30-60 s/ns; decks MUST live in /tmp/opencode
  (10x slower on /grid); 8-way parallel; ulimit -v 4000000 (KB).
- All PWL sources need finite ramps; instantaneous PWL steps stall ngspice.

## 2026-11-27 VERBATIM MEASURED TAP MAP - NSTAGE=22 / NAND2 closure build
(Corner SS 1.08 V / 125 C, with-wire deck = routed-SPEF wire caps in the
netlist, m8 coarse map, w=0.15 u switches, inv_4 stages, kick active. All
positions in ps relative to tap0's first rising edge, single-edge capture.)

Variant on disk: `variants/nstage22_nand2_ss_c0_f0/`, `..._c0_fm31/` (decks).
Rebuild selector: `NSTAGE_ADJ=2` (default) -> NSTAGE=22;
`NSTAGE_ADJ=1` -> NSTAGE=23 paired with the AND2 closure
(`variants/nstage23_and2_ss_c0_f0/`).

### c0 / FINE=0
T = 3541 ps   f = 282.4 MHz
tap positions      : 0, 432, 836, 1232, 1710, 2226, 2619, 3003
tap intervals      : 432, 404, 396, 478, 516, 393, 384, wrap 538
slot (lower step/6): 72.0 ps
L = T/2 / slot     : 24.59   (4*STEP = 24)
closure slot cost  : 2.59 slots
residual           : +0.59 slots = +43 ps
conformance k*T/8  : 0, 442.6, 885.3, 1327.9, 1770.5, 2213.1, 2655.8, 3098.4
|tap_k - k*T/8| ps : 0.0, -10.6, -49.3, -96.0, -60.6, +12.8, -36.7, -95.4
max |dev|          : 96.0 ps  (budget 30) -> FAIL

### c0 / FINE=-31
T = 2919 ps   f = 342.6 MHz
tap positions      : 0, 346, 670, 986, 1410, 1828, 2144, 2451
tap intervals      : 346, 324, 316, 424, 418, 316, 307, wrap 468
slot               : 57.7 ps
L                  : 25.31   (4*STEP = 24)
closure slot cost  : 3.31 slots
residual           : +1.31 slots = +75 ps
conformance k*T/8  : 0, 364.9, 729.9, 1094.8, 1459.8, 1824.7, 2189.6, 2554.6
|tap_k - k*T/8| ps : 0.0, -18.9, -59.7, -108.6, -49.4, +3.7, -45.1, -103.2
max |dev|          : 108.6 ps  (budget 30) -> FAIL

### Verdict
L = 4*STEP is unreachable within 30 ps for any valid NSTAGE: the closure costs
2.6-3.3 slots AND varies ~0.7 slot with code; even-NSTAGE granularity is 2
slots => best residual +-0.4..0.7 slots (+-30..50 ps); NSTAGE=21/23 latch with
the inverting closure. Two-ring fallback recommended; M4 held.

## Closure structure as built (NSTAGE=22 variant)
- Closure gate: `PLL_CELL_NAND2X1` = sg13g2_nand2_1 (X1 drive), inputs
  chain[22] and DCO_EN, output drives chain[0] (n0). Inverting => 22 inv +
  1 NAND = 23 inversions (odd), oscillates.
- Startup kick: one PMOS pass device, sg13_lv_pmos w=1.0u l=0.13u, D=n0
  (chain[0]), S=B=VDD, G=kick_n. Pulls chain[0] HIGH. No series element in
  the loop -- only its drain junction capacitance remains on n0.
- Kick pulse logic (OUTSIDE the loop): 4 x `PLL_CELL_INVX1` (sg13g2_inv_1)
  dont_touch chain from DCO_EN; kick_n = output of the 4th inverter
  (low ~4 gate delays after release = pull-up ON, high = OFF steady state).
- Extra static load on n0: stage0 input + tap0 front-end (1x INVX4 input)
  + kick PMOS drain junction + the NAND2 closure output. This is why the
  wrap interval exceeds the other intervals and why closure_slots is
  code-dependent (the tap front-end and stage0 load move with FINE/COARSE).
- Taps: lower k=0..3 = chain[n0,n6,n12,n18] through 2x INVX4 (buffer);
  upper k=4..7 = same nodes through 1x INVX4 (inverted). Equal input load
  (one INVX4) per node; 1-gate delay difference between the two paths.

## Two polarity bugs fixed during the kick integration (recorded so the
## work is not lost)
1. First kick (series OR2 in the loop): enable gating used AND(EN, delayed EN)
   with an EVEN (4-)inverter delay chain, so the "delayed copy" was
   non-inverted and the kick stayed HIGH forever -> loop pinned, n0 latched.
   Fixed by using the odd (3-)inverter delayed signal (AND(EN, ~EN_d3)).
2. Second kick (PMOS pull-up, kick_n = AND(EN, end3) with end3 = ~EN delayed):
   that AND is 0 for all t > release+3 delays, i.e. the pull-up stuck ON and
   n0 sat at mid-rail (0.76 V). Fixed: kick_n = the 4th delay-inverter output
   (en_d4), which is low only during the ~4-gate release window.
Steady-state verification: after the fix every oscillation run shows constant
edge-to-edge intervals (equal to <1 ps over 6-8 cycles), i.e. the kick path
contributes nothing to the steady-state period; and the 22-stage ring starts
from init 0 (and init X in earlier NSTAGE=23 runs with the same kick).

## 2026-11-27 ANCHOR-BANK + 1-SLOT-PI MEASUREMENT (decision doc test)
Build: ANCHOR bus = 22 stage taps (buf_1) + 22 inversions (inv_1), RTL+SPICE,
elab clean. SS, with-wire, m8/w0.15/inv_4/kick unchanged.

### Ring cost of the full anchor bank (vs the 4-tap build)
| code | 4-tap build | full-anchor build | delta |
|---|---|---|---|
| c0/f=0   | 282.4 MHz (T=3.541 ns) | 238.6 MHz (T=4.191 ns) | -15.5% |
| c0/f=-31 | 342.6 MHz (T=2.919 ns) | 286.0 MHz (T=3.496 ns) | -16.5% |

### Anchor grid (measured, ps rel first anchor in period)
c0/f=0 (T=4183 ps): 44 nets -> **26 distinct positions** (dedup 20 ps),
spacing 34.0..406.0 ps = 0.39..4.65 stage-slots.
c0/f=-31 (T=3496 ps): 26 distinct positions, spacing 28..376 ps = 0.38..5.16.
Cause: adjacent stages alternate polarity (rising edges 2 stage-slots apart)
and T/2 = NSTAGE stage-slots, so each inversion duplicates a tap phase; the
two combs meet in a 4-5.7-slot gap. The decision doc's "anchor every 1.000
slot / max gap 1 slot" does not hold as built.

### PI conformance (ideal linear 4-bit PI applied to measured waveforms)
| code | PI spans used | anchor-only max | PI-corrected max |
|---|---|---|---|
| c0/f=0   | 6..280 ps (0.08..2.94 slots) | 91.5 ps | **63.5 ps** |
| c0/f=-31 | 2..376 ps | 82.0 ps | **52.7 ps** |
Per-phase (c0/f0), k=0..7 (ps): -4.0, -16.7, -44.1, +19.1, -63.5, -13.1,
-43.7, +14.4. (c0/f-31): -4.2, -26.5, +25.1, -21.6, -52.7, -19.0, +32.5,
-18.2. TX (k=0/2/4/6): max -63.5 / -52.7 ps vs T/4 (the -188 ps polarity
systematic is removed; the residual is the anchor grid).
Verdict: FAILS 30 ps; anchor-only error alone exceeds it and the PI would need
2-5-slot spans. Recommendation: option C (DLL delay line).
