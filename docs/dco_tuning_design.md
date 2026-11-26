# Short-ring 500/250 MHz multiphase DCO — coarse+fine tuning design

Status: design brief, approved 2026-11-25. Drives the physical rebuild of
`PLL_MULTIPHASE_DCO` for the OpenSERDES PMA (RX sampler grid + TX quadrature).

## Goal

One ring that natively reaches **both 500 MHz (2 Gb/s) and 250 MHz (1 Gb/s)**
across PVT via run-time tuning alone — no re-spin, no switchable STEP, and no
pushing PVT frequency offset onto the CDR PI. Preserve the signed-off
geometry: `NSTAGE = NPHASE*STEP + 1 = 25`, AND2X1 travelling-wave closure,
taps at exactly `k*STEP` buffered by `dont_touch` BUFFX0.

## What is wrong today

`pll_multiphase_dco.v` has one frequency knob and it is a *parameter*:
`CLOSE_LOAD` hangs open-output inverters on `chain[NSTAGE]` (the
ring-boundary node only). No runtime tune ports exist — frequency is punted
onto the PI (which is wrong: a PI is a phase actuator).

## Tuning structure (approved)

### Coarse — per-stage binary MOS-cap bank, 5 bits, common word
- On **every** `chain[i+1]` (all 25 stages, including the closure node):
  5 switched caps, binary 1:2:4:8:16 in unit fingers.
- Unit finger = `sg13_moscap_n` (gate on ring node, SUB to VSS) in series with
  the drain/source of one min-width `sg13_lv_nmos` gated by `COARSE[b]`.
- Use MOS cap, **not** MIM (`cap_cmim`: 1.5 fF/µm², ≥7 µm plates, too big,
  Metal3 fights RT_MIN_LAYER) and **not** the HV varicap (3.3 V, 4-terminal,
  nonlinear, wrong supply domain). There is no usable LV varactor.
- `COARSE=0` = fast end, `COARSE=31` = slow end. Binary coding (5 buffered
  wires) — thermometer (31 wires) cannot be routed identically down the snake
  and per-stage wire-length skew becomes tap skew.
- **Buffer each coarse bit locally** with a `dont_touch` `sg13g2_buf_1` inside
  the stage cell (the `mid_delay.v` clone-kills-tuning failure: placer clones
  the driver and moves C off the tuned node).
- Sized ~9 fF/finger → ~280 fF on / 31 fF off per stage; ~7.6x C ratio
  (≈4x period requirement met with ~2x slack, since T∝C over-predicts).
  Size against the **off-state** switch residual (~1 fF/finger), not zero.

### Fine — symmetric per-stage 6-bit NAND3 switched load, DSM-dithered
- 63 `sg13g2_nand3_1` per stage, `A1` on the stage output, `A0`/`A2` driven by
  bit and complement, output open (the `fine_delay.v` two-level cap trick).
- `FINE` is **signed**, −31..+31, applied to every stage. Code 0 drives 31
  fingers on / 32 off (the fixed +1 keeps the on-count equal at both ends →
  symmetric by construction). ΔC ~2 fF/finger → ~±62 fF ≈ ±5%/stage ≈
  ±30 MHz @ 500 MHz. Must cover one coarse LSB (~8–15 MHz) with >2x margin so
  adjacent coarse codes overlap and the SAR has no hole.
- 6 bits: fine LSB ~1 MHz ≈ 4 ps of period (~0.5 ps/tap) — finer than the
  loop's 0.977 ps resolution, so **dither** the fractional part.
- Dither with the existing MASH `delta_sigma.v` (`BITS_DSM=11`): map
  `pi_frac[7:0]` in, `DSM_OUT` modulates the fine word ±1 LSB. Clock it from
  `DCO_OUT/4` (quarter rate), never the ring edge. Keep `EN_DSM_SHDT` on
  (bang-bang needs the dither out of the dead zone). Stagger the per-stage
  buffer enables by one fine clock so the 25 stages update on successive edges
  (averages period error instead of step-spurring).

### Stage cell
Replace the bare `stage_inv` with a placed macro `dco_stage`:
`inv_1` → node + coarse bank (5 groups) + fine bank (63 NAND3) + 5·buf_1 +
6·buf_1 + `sg13g2_decap_4`. All `(* keep *) (* dont_touch *)`. **Tap buffer
stays unloaded** (caps on `chain[i+1]`, tap_buf input sees only the inverter —
else tap load and tune load sum and the tap skews with code). Set
`CLOSE_LOAD=0` once the coarse bank exists.

### Ports
`input [4:0] COARSE`, `input signed [5:0] FINE`. Both pseudo-static vs the ring
(change on quarter-rate, never on a ring edge). Decode `FINE` to the 63-bit
thermometer **once** globally, buffer per stage.

## Rate / PVT math

Liberty `inv_1` min delay: SS ~28 ps, TT ~20 ps, FF ~15 ps → cell ratio 1.85x.
In-tree measured MOS spread (`pex_ihp/dco_pvt.json`): ratio 2.38x → **budget
2.0x**. Rate split is another 2.0x. Combined fast/slow = 2×2 = **4.0x period**
→ need `Ctune ≥ 3·Cfixed/stage`. The 280 fF/31 fF sizing gives ~7.6x (slack for
the concave T∝C reality). If extraction shows <5x, add a 6th coarse bit (not a
bigger bit 4 — matching risk).

Targets (replace with extraction).

**Correction 2026-11-25 (post-calibration): the macro is speed-GRADED, not
500 MHz-at-SS.** Caps only slow a ring; the old signed-off ring is 335 MHz @ SS
with ~no tuning load, so 500 MHz @ SS is architecturally impossible at
NSTAGE=25 — the earlier target table used the liberty floor (~685 MHz) instead
of the routed number (~335 MHz). Approved re-scope:

| rate | must reach at | corners where claimed | note |
|---|---|---|---|
| 2 Gb/s (500 MHz) | **FF** (TT marginal) | FF, TT | not required at SS |
| 1 Gb/s (250 MHz) | **SS** | all corners | comfortably inside range |

Report the actual achievable frequency range per corner (SS/TT/FF) as the
deliverable. Pass condition: each claimed rate inside the coarse+fine range at
its corner with ≥2 fine LSB headroom each side, monotone, adjacent-code overlap
≥2 fine LSB. Matches how real SerDes parts are speed-binned.

**Measured reconciliation 2026-11-25 (device-level SPICE, SS 1.08 V/125 C,
pre-layout).** This supersedes the earlier "the 335 is an STA artifact"
suspicion — it is NOT; both numbers are correct and reconciled:

- The old signed-off **335 MHz @ SS** = ONE routed traversal 1.49 ns × 2
  (travelling-wave period), *bankless* ring. Valid.
- New tuned ring, **controlled** measurement (identical init/release/stop/
  corner/OSDI/extraction; only stage content differs — the earlier "inv-only
  154 MHz" was a mislabeled deck, retracted):
  - inv-only (no banks) traversal 1.282 ns → **390 MHz** (14% faster than the
    routed 335, correct sign for pre-layout);
  - tuned fastest code c0/f−31 → **185 MHz** (the real usable SS fast end).
- Root cause of the 185 vs 335 gap: the banks' **fixed load = 5.7 fF/stage**
  (direct extraction) ≈ 30 ps/stage at SS. Load-trim alone (only ~2 fF
  removable) caps the fast end at ~205 MHz. NAND3 fine bank already replaced
  by switched `sg13_moscap` (nand3 B-pin ~0.4 fF was unusable); switches are
  gate-side (plate-side leaked 1.3 fF/finger).
- c31/f0 startup **dead state is real** (init 0 == init X: one edge then
  DC-latch) — brief risk 7; needs the one-shot kick.

**Decision: stage drive inv_1 → inv_4 (uniform, all 25 stages; topology/taps/
closure untouched), + one-shot startup kick.** `inv_2` gives ~250 MHz @ SS
*pre-layout*, and the routing penalty (~16%, from the 1.282→1.49 ns traversal)
drops it to ~215 routed → **fails 250 @ SS**. `inv_4` gives ~310 pre-layout →
~267 routed ≥ 250 with margin, and clears 500 @ FF. The ≥250 **routed** number
is confirmed at M4 post-route.

**Verified with inv_4 + one-shot kick (SS pre-layout):** inv-only 433 MHz;
tuned c0/f−31 (fastest) **333.8 MHz**; c31/f0 **134.7 MHz and no longer dead**
(oscillates at init 0 and X identically — risk 7 fixed). SS COARSE sweep
0..31 = 325.9 → 134.8 MHz, so **250 MHz sits inside the SS range with
headroom** (bracketed near c13/c14). Kick is 3 `dont_touch` inv_1 delay +
`AND(EN, ~EN_d3)`, ORed into the closure; inversion count unchanged (an even
delay count pinned the ring — use odd, 3).

**CLOSED 2026-11-26 — M3 SS gate met, with routed wire in the deck.**
The non-monotone sweep (c7→c8 +45, c19→c20 +15, c23→c24 +34) was fixed at the
source, not by a LUT (a code-remap is PVT-fragile). Three changes together:

1. `SW_M` scaled with finger count: coarse `1,1,2,4,8`, fine `1,1,1,2,4,8`.
2. Switched-cap switch width narrowed `w=0.42u → 0.15u` (−3.5 fF
   junction/overlap; the ~2 fF recovery target exceeded). On-R checked:
   bit4 147 fF behind m=8×0.15u → τ≈130 ps ≪ T/2, c31 slow end unchanged.
3. **Routed SPEF wire caps in the deck** (`DCO_PEX_WIRE=1`, per-stage mean
   0.96 fF, max 2.66 fF from the actual STEP=3 routed snake). The 1.16
   routed-penalty guess is **retired** — it was measured on the bankless
   inv_1 ring and does not transfer to the inv_4 + cap-bank stage.

Verified (`ss_sweep5_wire.json`, 32/32 codes, SS pre-layout with wire):
- COARSE 0→31: **279.4 → 134.1 MHz, monotone (0 up-jumps / 31 pairs)**;
  max adjacent step **8.9 MHz ≪ fine half-span 86 MHz** (gap-free, ~10×).
- **250 bracketed c6=250.9 / c7=242.0**; fast end +29 MHz over 250; f=−31
  = 336.9 MHz. ≥2 fine LSB headroom both sides (fine LSB ~2.8 MHz).
- duty **43.6–52.1%** all codes (c31 52.1% < 55%); startup ≤1.06 ns at c0 and
  c31, init 0 == init X.

Remaining: FF/TT coverage, six loaded-top measurements, M4 (placement regen,
LibreLane, post-route tap uniformity + DRC/LVS + routed-250 confirm).

**FF gate closed too (2026-11-26, `ff_sweep_wire.json`, 32/32 codes):**
COARSE 0→31 = **658.6 → 289.3 MHz, monotone (0 up-jumps)**, max adjacent step
**23.8 MHz < fine half-span 86** (gap-free). **500 MHz bracketed
c12=505.9 / c13=483.2** — inside the FF range. Duty **48.2–52.6%** (inside
45–55%). SS/FF ratio **2.36**, consistent with the measured MOS spread budget
(2.0–2.38) from the recon. So the corner-graded contract is met pre-layout in
both corners: **250 @ SS (c6/c7), 500 @ FF (c12/c13)**, both monotone and
gap-free. TT sweep running; six loaded-top measurements and M4 next.

## PI stays a phase actuator (separate)

Ring taps span a **half period** → they are not the 8 sampler phases.
`pi_code[2:0]` muxes two adjacent taps (upper half of code space uses the
**inverted** tap `~PHASE[k-4]`, the `tx_clk4` trick — no second ring).
`pi_frac[7:0]` is the interpolate weight: a **current-steering interpolator**
(2 differential pairs into one load, 4-bit thermometer tail) — not a delay line
(that re-introduces PVT-variable delay). ~4 bits real (16 steps ~8 ps) + DSM
dithering the rest into the fine bank. Frequency = set at lock, nudged only
within fine range for ppm; phase = mux+interpolator only.

TX uses no PI: `tx_clk4` keeps `USE_TAP_PAIR=1` (`PHASE[0]/PHASE[4]` +
complements). Requirement: tuning must not move the PHASE[0]→PHASE[4] 90°
spacing beyond 30 ps — holds as long as every stage gets the same code.

## Loaded-tap PEX plan

Measure at the **sampler/latch-MUX clock pin**, not at `PHASE[t]`.
- Two tops same ring: `tb_rx_loaded` (ring + PI mux + `sampler_bank` 8 flops,
  PRBS data so they switch), `tb_tx_loaded` (ring + `tx_parallel_mux` 4 flops
  + muxes). Real load, not an ideal cap.
- Extraction: OpenROAD RCX for stdcell/route (3 corners, `nom_ss_125C_1v08` /
  `nom_tt_025C_1v20` / `nom_ff_n40C_1v32`, `IHP_rcx_patterns.rules`); Magic
  `extresist`+`ext2spice` for the cap bank (RCX doesn't know moscap/nmos).
  Magic segmentation is **non-deterministic** across runs (port response
  stable to 5%) → extract the cap-bank cell **once, check it in, stamp it**.
- Corners move together: SS ring + `cap_wcs` (max C) = slow extreme; FF ring +
  `cap_bcs` = fast extreme.

### Six acceptance measurements
1. **Starts**: release DCO_EN at 0 ns and 20 ns, chain[NSTAGE] initialized X
   and 0; sustained oscillation within 20 cycles, all 3 corners, COARSE=0 and 31.
2. **Both rates**: sweep COARSE 0..31; 500 MHz reachable @SS + headroom, 250 MHz
   @FF + headroom, monotone, adjacent-code overlap ≥2 fine LSB.
3. **Duty**: 45-55% at the flop clock pin, all corners, at the locked code.
4. **Phase vs 30 ps**: 8 sampler clocks over 256 cycles, max dev from k·T/8
   ≤30 ps, **at COARSE=0 and COARSE=31** (uniformity must not be code-dependent).
5. **PI switch min pulse**: step pi_code by 1 and 4 on PRBS; no runt; min
   high/low ≥40% of T/8 during hand-off (reuse `cdr_top.v` `mux_ready` park).
6. **Fine symmetry**: sweep FINE −31..+31 at 3 coarse codes; slope positive,
   mid-code within 1 LSB of coarse point, no sign-boundary discontinuity.

## Risks

1. **Code-dependent tap skew** — the whole ballgame. 23.9 ps was measured with
   identical unloaded stages; per-stage buffer-wire mismatch makes the error
   grow with code. Keep per-stage routed-cap mismatch <1% (~1 ps/stage). Test
   uniformity at both range ends.
2. **Closure is the AND stage** — tap7→0 interval carries an AND2 + return
   wire; load it with the same bank (necessary) but measure it separately; if
   >10 ps slower, drop one coarse LSB's cap on that stage only (documented
   intentional asymmetry).
3. **Binary weighting error** — bottom two bits may be 20-30% off (switch
   parasitics); OK only because fine overlaps a full coarse LSB. Extract bits
   3/4 individually; bit 4 (16 fingers behind one min switch) → 4x switch width.
4. **Supply bounce** from coherent cap switching looks like phase noise →
   `sg13g2_decap_4` per stage; change coarse one bit at a time (SAR already does).
5. **Duty vs trip** — check at COARSE=31; if >55%, split fingers into
   NMOS-to-VSS + PMOS-to-VDD on the same bit.
6. **TX quadrature −1 stage** ((NSTAGE+1)/4 = 6.5) is systematic, scales with
   stage delay (~40 ps @500, ~80 ps @250), tuning cannot fix it — separate TX
   ring if it ever needs <30 ps; do not block RX on it.
7. **Startup at max cap** — heavily loaded ring can sit metastable; if
   requirement 1 fails, one-shot kick (force chain[0] one gate delay), not a
   topology change.
8. **DSM feed-through** — stagger per-stage buffer enables; keep EN_DSM_SHDT.

## Implementation order

1. New `pll_multiphase_dco` with `dco_stage`, `COARSE[4:0]`/`FINE[5:0]`.
2. Two loaded PEX tops + extraction (RCX + stamped Magic cap cell).
3. Six measurements at SS first (if 250 MHz missed there, nothing else matters).
4. Regenerate `MANUAL_GLOBAL_PLACEMENTS` (fat ~80-cell stage; one placed cell
   per stage, abutted, taps break out on Metal3 downward as today).
5. LibreLane to placed macro; post-route loaded tap uniformity + DRC/LVS.
