# DDR1 clocking subsystem — architecture, evidence, and handoff

Status: Pass 1 (behavioral RTL) complete 2026-11-28. Real-cell/PVT evidence is
Pass 2 — **no DDR1 timing margin may be claimed closed yet** (requirements §2).
Requirements source: `/grid/ddr-phy/docs/ADPLL_DDR1_REQUIREMENTS.md` (v0.1).

## What exists now

| File | Role |
|---|---|
| `src/ddr1_clock_top.v` | Integration top: MCK(200 MHz) → DE2 divider + ratio DLL → fail-closed outputs, ERR, Phase-A bypass |
| `src/ddr1_ck90_de2.v` | Dual-edge divide-by-2 (posedge/negedge) → CK + reference phase; 2-flop reset synchronizer |
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
   across all 12 injected-error cells. `USE_DLL90=1`, `USE_DCC=0` are the defaults
   (DCC kept only for candidate-A experiments; CK is 50 %-duty by toggle construction).
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

- **DLL loss detection is measured-phase, never heuristic**: timestamp-FIFO signed
  absolute measurement (no modulo aliasing); lock on |phase| ≤ 192 ps master
  (48 ps CK90) × 8 consecutive; loss on |phase| > 640 ps master (160 ps CK90) × 3
  consecutive — any beyond-spec excursion drops PHY_LOCKED in ~30 ns; hysteresis
  holds lock between the bands so correctable slews finish. Direction-run and
  fixed code-window loss detection were **removed** (both false-fire).
- **The DLL loop never freezes** — continuous tracking is the PVT-drift mechanism.
  Post-lock dither is ±1 LSB (±16 ps at CK90).
- **CK90 structural monitor** samples at CK rise (expect low), CK fall (expect high),
  and CK rise + 2.8 ns (expect high) — the third sample is what distinguishes the
  forbidden 180° inverse from correct 90° lag. Three consecutive failures → sticky
  ERR + lock drop.
- **DLL held in reset until PLL_LOCKED**; re-acquires on PLL loss/return.
- **Bypass (Phase A)**: outputs gated by a latch clocked on EXT_SYS_CLK; BYPASS is a
  static strap committed only during reset (changes outside reset are ignored).
- **DQS handshake** mirrors `ddr-phy/rtl/ddr_dqs_delay_adpll.sv`: apply on first idle
  sys edge, ready only after SETTLE_CYCLES, ack only on `tap_valid && tap_ready`,
  idle-drop waits for the next idle window **without reprogramming**. Settle gate
  forces capture low during updates (safe only under the idle-bus contract).

## Pass 2 — real-cell work (ranked)

1. **DLL tunable element**: the behavioral per-edge-latched segments must become real
   cells. `FINE_DELAY_CELL`'s MUX is a dummy load — it is NOT a tunable element.
   The repo's characterized tunable candidate is the **DLL8 switched-moscap element**
   (`src/dll8_line.v`); evaluate it first. Needs: code→delay map at TT/SS/FF, range
   covering 2.5 ns ± drift per segment at 100 MHz, per-edge code commit.
2. **Phase detector hardware**: the `$realtime` FIFO is behavioral. Real equivalent:
   free-running CKIN-cycle counter (never functionally reset) + `dll_tdc_phys`-style
   tapped sampler, capture range ≥ T, gray-coded CDC, epoch/valid tags, discard first
   measurements after reset. Monitor ±2.8 ns sample needs a real edge-order/TDC cell.
3. **IHP130 real-cell flow** (recon complete): clone `flow/sta/run_ddr_phy_corners.sh`
   → swap to `build/pdk_root/ihp-sg13g2` libs (`sg13g2_stdcell_{typ_1p20V_25C,
   slow_1p08V_125C,fast_1p32V_m40C}.lib` + `sg13g2_stdcell.v`/`sg13g2_udp.v` +
   `src/pll_cells_ihp-sg13g2.v`). Tools present: yosys 0.52, OpenSTA 2.0.17,
   iverilog 12. SDF pipeline in `run_dll_gate.sh` is PDK-agnostic.
   **Trap**: `/grid/ihp130/sg13g2_stdcell_hv` is 3.3 V — do not use for the 1.2 V core.
   New checks needed from scratch: CK-vs-CK90 phase, paired-clock duty, cross-skew
   (only a single-ended duty template exists today: `ics55_ck_pad.sta.tcl`).
4. **Frequency plan verification**: exactly-100 MHz from ADPLL integer-divided output
   at all corners. Ring SS ceiling ~340 MHz constrains DCO choice; the 200 MHz MCK
   plan (DCO 400 MHz ÷2) is infeasible at SS — pick the real plan and verify against
   the measured DCO tables in `flow/ADPLL_FREQ_DIV.md`.
5. **DQS real-cell characterization**: done at pre-layout level 2026-11-28
   (`flow/sta/run_ddr1_dqs_corners.sh` + `ddr1_dqs_taps_{TT,SS,FF}.csv`): PASS all
   corners with the 1-cell/tap resize. Remaining: routing/parasitic re-verify,
   mux select-dependent load bending, the consumer-side cap of the usable code
   window (SS range 12.65 ns > one 10 ns DQS period aliases high codes),
   first-tap input-net load, `LINE_IMPL=1` for synthesis.
6. **Jitter**: period-jitter ≤100 ps pk-pk / cycle-to-cycle ≤50 ps evidence
   (requirements §2 line 44) — no measurement exists yet.
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
