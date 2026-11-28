# DDR1 clocking subsystem — architecture, evidence, and handoff

Status: Pass 1 (behavioral RTL) complete 2026-11-28. Real-cell/PVT evidence is
Pass 2 — **no DDR1 timing margin may be claimed closed yet** (requirements §2).
Requirements source: `/grid/ddr-phy/docs/ADPLL_DDR1_REQUIREMENTS.md` (v0.1).

## What exists now

| File | Role |
|---|---|
| `src/ddr1_clock_top.v` | Integration top: MCK(**300 MHz**, freq-plan commit) → DE3 dual-edge ÷3 → ratio DLL → fail-closed outputs, ERR, Phase-A bypass |
| `src/ddr1_clk_de3.v` | Dual-edge divide-by-3: 300→100 MHz, period exactly 3T input-duty independent, duty error attenuated 3×; synthesizes to sg13g2 |
| `src/ddr1_ck90_de2.v` | (legacy) dual-edge ÷2 — retired from the clock top with the 200 MHz plan; kept for the compare TB |
| `src/ddr1_ck90_dll.v` | **CK90 engine (chosen architecture)**: master/slave ratio DLL, continuous bang-bang tracking, absolute-phase lock/loss detection |
| `src/ddr1_dqs_delay.v` + `src/ddr1_dqs_delay_line_phys.v` | DQS receive delay line: uniform 128-cell chain, 128 taps × 1 cell, TAP_BITS=7 |
| `src/ddr1_clock_top_tb.v` | 85-check self-checking TB (compile/run commands in header) |
| `src/ddr1_ck90_compare_tb.v` | 72-check A/B injection-matrix TB |
| `src/ddr1_dqs_delay_tb.v` | DQS handshake/glitch/monotonicity TB |

Behavioral evidence (iverilog, `sim/outputs/ddr1/`, regenerable — gitignored):
85 + 72 + all-DQS checks pass, exit 0.

## Architecture decisions (locked)

1. **CK90 = master/slave ratio DLL** (user decision 2026-11-27, after A/B comparison).
   Five identical quarter-replica segments share one code; four cascaded lock
   full-period on the 100 MHz CK itself; the slave replica outputs CK + T/4 = CK + 2.5 ns
   **by construction** — duty-immune, PVT-tracked, same-source. The A/B injection matrix
   (`ck90_ab_matrix.csv`): candidate A (dual-edge ÷2) degrades 1:1 with duty error
   (+100 ps duty → +100 ps phase error, up to +500 ps), candidate B constant +12 ps
   across all 12 injected-error cells. **2026-11-28**: with the 300 MHz frequency
   plan the candidate-A experiment path (DE2 ÷2, ADCC duty corrector) is retired
   from the clock top entirely — a DE2 at 300 MHz would output 150 MHz. The clock
   top is DE3 + ratio-DLL only; `USE_DLL90` is vestigial.
2. **×4 divide-decode is impossible**: the ring DCO SS ceiling is ~340 MHz < 400 MHz,
   so quadrature-by-divider cannot work at 100 MHz across PVT. Documented dead end.
3. **SYS_CLK** = toggle /2 of the final CK — edge-aligned and 50 % duty by construction.
4. **Fail-closed**: all outputs ANDed with PHY_LOCKED; gate *release* registered on a
   CK rising edge (no first-pulse runt), *drop* asynchronous. ERR sticky until RST.
5. **DQS line = uniform series chain** (no coarse/bypass mux → monotonic by construction,
   avoiding the `PLL_SEGMENTED_DELAY_PHYS` boundary-step problem). **Measured on real
   sg13g2 cells** (`flow/sta/run_ddr1_dqs_corners.sh` — OpenSTA per-tap extraction):
   the real FINE_DELAY_CELL is ~65/100/45 ps TT/SS/FF per cell, nearly twice the
   ics55 figures, so the first 2-cells/tap sizing exactly hit the 200 ps SS limit
   (FAIL). Resized to **128 taps × 1 cell, TAP_BITS=7** — measured per-corner:
   TT step 65 ps (range 8.22 ns), SS step 100 ps (range 12.65 ns, > one DQS
   period → consumer must cap the usable window), FF step 45 ps (range 5.69 ns,
   5 ns at code 112). All corners: step ≤ 200 ps, range ≥ 5 ns, monotone,
   max/nominal ≤ 1.12. PASS TT/SS/FF.

## Key implementation contracts (do not regress)

- **DLL loss detection is measured-phase, never heuristic**: TDC-honest
  measurement — residual folded modulo T into (−T/2, +T/2] then quantized
  round-to-nearest to the tap step (parameter TDC_STEP_PS, swept 45/65/100 ps =
  FF/TT/SS measured taps; `src/ddr1_ck90_dll_tdc_tb.v` 17/17 incl. the binding
  512 ps no-false-trip at 100 ps SS taps and the +6016 ps aliasing demonstration).
  Lock on |phase| ≤ 192 ps master (48 ps CK90) × 8 consecutive; loss on |phase| >
  640 ps master (160 ps CK90) × 3 consecutive — any beyond-spec excursion drops
  PHY_LOCKED in ~30 ns; hysteresis holds lock between the bands so correctable
  slews finish. Direction-run and fixed code-window loss detection were
  **removed** (both false-fire). Modulo aliasing during acquisition is caught
  fail-closed (watchdog/loss trip); element sizing must keep the initial delay
  within ±T/2 of lock (pass-2 constraint, `docs/DDR1_DLL_ELEMENT_SIZING.md`).
- **The DLL loop tracks continuously but HOLDS in a dead zone** (contract
  change 2026-11-28, forced by the jitter spec): the loop steps ±1 LSB only
  while `|measured residual| > HOLD_PS`, where HOLD_PS = max(master step, TDC
  tap) (65 ps master = 16 ps CK90 at the defaults).  Inside the band the code
  is stationary.  Rationale: the old unconditional bang-bang dither produced a
  limit cycle measured at **128 ps pk-pk / 128 ps c2c at CK90** (jitter TB) —
  over both spec limits.  The dead zone removes the steady-state dither
  entirely (measured 0 ps pk-pk clean-input CK90 period after the fix) and any
  drift that moves the residual out of the band re-engages the loop on the
  next measurement, so PVT tracking is preserved.  HOLD_PS must be >= the
  measurement quantization or the loop wanders 5-6 codes (observed with a
  65 ps tap against a 64 ps band).  "Not frozen" is verified by perturbation
  in every TB (a 2-tap offset must move the code), not by counting dither.
- **CK90 structural monitor (MCK-grid, synthesizable since 2026-11-28)**: the
  behavioral `assign #2.8` third sample and the negedge-CK second sample are gone
  (neither synthesizes on the posedge-only sg13g2 library). CK rising edges are
  MCK-posedge aligned by the DE3 construction, so a 2-deep MCK-domain shift of CK
  detects the CK falling edge repeating once per CK period, exactly at the next CK
  rise (`det`). Each period the monitor samples CK90 twice: at `det` it must be LOW
  (correct CK90 rises +2.5 ns later), and one MCK edge later (+6.67 ns) it must be
  HIGH (correct CK90 rises +2.5 ns, falls +7.5 ns at 50% duty; the forbidden 180°
  inverse reads both LOW at the second point and HIGH at the first). Sample margins
  ≥0.8 ns by construction. Three consecutive failing periods → sticky ERR + lock
  drop (qualified by phy_lock_core; same semantics as before). The test injection
  mux (`ck90_inv_tb`) is now `ifdef SIMULATION` — absent from synthesis netlists.
- **DLL held in reset until PLL_LOCKED**; re-acquires on PLL loss/return.
- **Bypass (Phase A)**: outputs gated by a latch clocked on EXT_SYS_CLK; BYPASS is a
  static strap committed only during reset (changes outside reset are ignored).
- **DQS handshake** mirrors `ddr-phy/rtl/ddr_dqs_delay_adpll.sv`: apply on first idle
  sys edge, ready only after SETTLE_CYCLES, ack only on `tap_valid && tap_ready`,
  idle-drop waits for the next idle window **without reprogramming**. Settle gate
  forces capture low during updates (safe only under the idle-bus contract).

## Pass 2 — real-cell work (ranked)

1. **DLL tunable element — DONE 2026-11-28**: N=8 dll8-v4 elements per segment
   (2× `dll8_line4` hard-macro strips, stock `sg13g2_inv_4` stages + 127-finger
   thermometer moscap bank), shared 7-bit code, no coarse select, no mux in the
   delay path (`flow/characterization/ddr1_dll_chain.py` bare-cascade SPICE:
   lock codes 32.7/71.6/94.2 SS/TT/FF, monotone, FF headroom 33 codes).
   RTL: `DDR1_DLL_SEG_PHYS` + `DDR1_DLL_THERM_STRAP` in `src/ddr1_dll_phys.v`
   (strap polarity contract verified 8 codes × 127 bits against the macro
   contract). Selection parameters `SEG_IMPL`/`REGEN`/`REGEN_IMPL` default 0
   so the behavioral regression is untouched. Chain asymmetry measured up to
   +1.5 ns tpHL−tpLH at SS high codes → **matched SR regeneration**
   (`DDR1_CLK_REGEN`, dfrbp + narrow nand2b reset pulse) at the master
   measurement point and the CK90 output; regeneration is outside the ratio
   path, so it cancels in the loop apart from a (3/4)·D_set systematic at
   CK90 (SPICE quantification in progress, `flow/characterization/
   ddr1_dll_regen.py`). Mismatch budget: 3σ(CK90) ≈ 16 ps vs ±100 ps target
   (element matching 1.7 ps measured; layout interdigitation required).
2. **Phase detector hardware — DONE 2026-11-28**: behavioral TDC semantics
   (modulo-T fold + tap quantization) in the default path, PLUS the structural
   signed flash TDC (`src/ddr1_dll_tdc.v`, single chain + delayed-master offset:
   zero residual reads the center tap, deep offsets clamp correct-sign, one
   master period of loop latency = physically irreducible). Unit TB 11/11;
   DLL integration TB 22/22 incl. TDC_IMPL=1 acquisition/dither/512-ps-no-trip/
   1024-ps-trip; clock-top regression 86/86. yosys `synth -flatten` clean
   (5498 cells, 32+16 chain cells preserved as black boxes). Monitor third
   sample replaced by the MCK-grid edge-order check (above).
3. **IHP130 real-cell flow** (recon complete): clone `flow/sta/run_ddr_phy_corners.sh`
   → swap to `build/pdk_root/ihp-sg13g2` libs (`sg13g2_stdcell_{typ_1p20V_25C,
   slow_1p08V_125C,fast_1p32V_m40C}.lib` + `sg13g2_stdcell.v`/`sg13g2_udp.v` +
   `src/pll_cells_ihp-sg13g2.v`). Tools present: yosys 0.52, OpenSTA 2.0.17,
   iverilog 12. SDF pipeline in `run_dll_gate.sh` is PDK-agnostic.
   **Trap**: `/grid/ihp130/sg13g2_stdcell_hv` is 3.3 V — do not use for the 1.2 V core.
   New checks needed from scratch: CK-vs-CK90 phase, paired-clock duty, cross-skew
   (only a single-ended duty template exists today: `ics55_ck_pad.sta.tcl`).
4. **Frequency plan — RESOLVED 2026-11-28** (`docs/DDR1_FREQ_PLAN.md`): DCO=300 MHz
   FCW=3 ÷3. Measured ring endpoints TT 212-624 / SS 111.8-370 / FF 262.2-903 MHz;
   300 covered all corners, FF margin −38 MHz thin. Integration into the clock top
   done (DE3). Remaining: locked-loop jitter evidence.
5. **DQS real-cell characterization**: done at pre-layout level 2026-11-28
   (`flow/sta/run_ddr1_dqs_corners.sh` + `ddr1_dqs_taps_{TT,SS,FF}.csv`): PASS all
   corners with the 1-cell/tap resize. Remaining: routing/parasitic re-verify,
   mux select-dependent load bending, the consumer-side cap of the usable code
   window (SS range 12.65 ns > one 10 ns DQS period aliases high codes),
   first-tap input-net load, `LINE_IMPL=1` for synthesis.
6. **Jitter — measurement built 2026-11-28**: `src/ddr1_jitter_tb.v` measures
   output period/c2c jitter at CK_PHY/CK90_PHY over 2000 periods, two
   configurations (clean input; ±15 ps/half-period injected MCK edge jitter),
   explicit methodology (spec §2 line 44). Verdicts gate on the 100/50 ps limits;
   the injected run bounds the chain's own added jitter separately from the DCO
   budget it must pass through.
7. **STA/SDF gate-level smoke** for both blocks at TT/SS/FF; lock time < 100 µs
   (target) within the 200 µs DDR1 power-up window.

## ddr-phy-side integration gaps (their repo — handoff list)

- `ddr1_top.sv` has no `update_idle` port (§3.1 requires it), defaults `TAP_BITS=4`
  (must be ≥5, we now use 7), no `tap_error`, no `PHY_LOCKED`/`ERR` inputs —
  `controller_reset = rst || !init_done` does not include clock loss (§2 line 46
  requires treating it as a fault).
- `ddr1_phy.sv:39-40` derives `pad_ck_n = ~ck` locally — the matched CK_PHY/CK_PHY_N
  pair (≤100 ps crossover requirement) is never consumed; wire the pair through.
- `ddr1_ihp130_io.sv:174` still has the behavioral `#(DQS_CAPTURE_DELAY_PS)` fake
  delay — replace with `DDR1_DQS_DELAY` (TAP_BITS=7, LINE_NTAPS=128, CELLS_PER_TAP=1).
- `ddr_dqs_delay_adpll.sv` instantiates the old one-cell-per-tap primitive; with
  TAP_BITS=7 that yields only half the required range — use the new wrapper or rebind.

## Forbidden-pattern compliance checklist

| Forbidden | Status |
|---|---|
| CK_PHY_N as CK90 (180°) | Not used; monitor actively detects the inversion (check18) |
| fractional OUT_DIV for DDR clocks | Not used; clocks derive from integer-divided MCK |
| 16-tap SEL_REQ fine taps as 90° shifter | Not used; CK90 from the ratio DLL |
| independent free-running delay line for CK90 | Not independent: slave shares the master loop's code, same clock source |
| outputs running while unlocked | All outputs ANDed with PHY_LOCKED; bypass also gated |
