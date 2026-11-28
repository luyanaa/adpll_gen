# DDR1 pass-2 synthesis blockers + replacement plan

**STATUS 2026-11-28 (late): items 1-5 below are RESOLVED in RTL.**  The
synthesis-blocker inventory is kept for the record; the current state:

- item 1 (`real`/`$realtime` FIFO) — replaced by `src/ddr1_dll_tdc.v`
  (structural signed flash TDC, single chain + delayed-master offset),
  integrated as `TDC_IMPL=1` next to the behavioral emulation.  Unit TB
  11/11, DLL integration TB 25/25, yosys flatten clean.
- item 2 (`#`-delay segments) — structural segments in
  `src/ddr1_dll_phys.v` (2x `dll8_line4` hard macros + thermometer strap
  decoder).  N=8 confirmed by chain SPICE.
- item 4 (`assign #2.8` monitor) — replaced by the MCK-grid edge-order
  monitor in `src/ddr1_clock_top.v` (synthesizable, no delayed clock).
- item 5 (`ck90_inv_tb`) — now `ifdef SIMULATION`.
- Additional pass-2 hardware that did not exist when this list was
  written: SR phase regeneration (`DDR1_CLK_REGEN`, mandatory because the
  measured chain asymmetry reaches +1.5 ns), the loop dead zone (jitter
  spec), and `TRIM_MASTER_PS` (locked-target calibration for the
  EN-gate / latch-set systematic).
- Remaining real work: SPICE characterization of the regenerated chain
  (D_set, duty, regen phase shift), STA of the integrated top, and the
  jitter/DPI handoff — see docs/DDR1_CLOCKING.md pass-2 list.

Evidence: `yosys` (0.52) read+synth attempt log
`sim/outputs/ddr1/ihp130/clock_top_synth_attempt.log` — first hard error
`src/ddr1_ck90_dll.v:290: ERROR: syntax error, unexpected TOK_REAL`.
Yosys/SystemVerilog-real support is nil; everything below must go.
The DQS line is already clean (IMPL=1 synthesizes, measured — see
`flow/sta/run_ddr1_dqs_corners.sh`).

## Blocker inventory (file:line — construct — replacement)

### `src/ddr1_ck90_dll.v` — the DLL core

1. **`:290-298,382-385` — `real` timestamp FIFO + `$realtime` phase measurement.**
   The absolute-phase detector. Replacement: tapped delay-line TDC.
   - Sign (bang-bang direction): arbiter DFF, D=master_out, clocked by CKIN.
     master_out early (line too short) vs late decides the step direction;
     exactly the information the loop uses today.
   - Magnitude band (lock at ≤192 ps master / loss at >640 ps master):
     sample master_out on a thermometer-tapped fine chain launched by CKIN.
     Tap spacing options, to be characterized like the DQS line was:
       * plain FINE_DELAY_CELL taps: ~65 ps TT — 3 taps in the lock band,
         marginal resolution; usable for a first-cut.
       * vernier (two chains, unit ratio ~1.2): 13-20 ps resolution —
         comfortable, more area, more design.
     First-cut recommendation: FINE_DELAY_CELL taps covering ±1 ns around
     the CKIN edge; lock = pop inside the center ±3 taps, loss = outside
     ±10 taps for 3 consecutive measurements. Re-tune exact tap indices
     from the measured cell delay per corner.
   - The measurement FSM stays in CKIN units (no CDC — master_out is
     synchronous-ish to CKIN by construction when locked).
2. **`src/ddr1_ck90_dll.v` `DDR1_DLL_SEG` — `#((CELL_X4_MIN + ch*CELL_X4_STEP …)/4000.0)` transport-delay segments.**
   The tunable element. Replacement: chain of stock sg13g2 inverters with a
   distributed thermometer moscap trim bank, i.e. the **DLL8 element
   architecture** (`src/dll8_line.v`, SPICE-characterized by the SerDes
   session: stock inv_4 + 127-finger thermometer moscap bank,
   BASE 110 ps + 127×3 ps trim, ~1.0×1.0 µm fingers).
   - Segment target 2.5 ns nominal at 100 MHz; loop self-calibrates, so the
     trim range must cover only the *element PVT spread*, not 2.5 ns itself.
   - Delay scaling TT↔SS↔FF measured on the same cells as the DQS line:
     ~×1.54 SS/TT, ~×0.69 FF/TT. With ~2.5 ns TT base, need trim pull
     ±~1.0 ns → distribute the bank across the chain (trim per-element or
     grouped). First-cut: 20-24 inv stages (~2.3-2.8 ns TT) + thermometer
     caps distributed, sized against the SPICE dll8 per-finger data.
   - **Reuse constraint**: the dll8 element/macro is the parallel SerDes
     session's hard macro (516-pin line4). Do NOT fork its layout; either
     instantiate the published `DLL8_ELEM_PHYS` cell or build a small
     DDR1-scoped chain from stock cells + the same moscap-finger recipe.
3. **Per-edge code commit (`ch <= CODE` inside the segment) is already
   RTL-clean** — keep this discipline in the real element (shadow register
   per segment, updated on the segment input edge).

### `src/ddr1_clock_top.v` — integration top

4. **`:260` — `assign #2.8 ck_a_qtr = ck_a` (CK90 monitor 3rd sample).**
   Replacement: the same TDC chain as the DLL phase detector is already
   measuring the master phase — derive the quadrant check digitally:
   at lock, the slave output IS CKIN + measured/4. 90° correctness =
   measured master phase within the lock band AND slave consistent.
   The 180°-inverse case is caught because an inverted CK90 fails the
   structural low-at-rise/high-at-fall samples already; the third sample
   only disambiguates 90°-lag from 180° for *in-range* phases. In real
   hardware the edge-order comparator on (CK rise, CK90 rise) inside one
   T period gives the same information: CK90 rise must land in the
   (T/4 ± tolerance) window after CK rise. Fold into the TDC design.
5. **`ck90_inv_tb` test scaffolding (`:231` area)** — sim-only fault
   injection; guard with `ifndef SYNTHESIS or keep as a tie-off. It is
   a mux on a clock — in real silicon this must not exist (or be
   scan/test-only behind a locked fuse). Pass 2: remove or tie to 0.
6. Everything else in the top (fail-closed gates, bypass latch, ERR
   logic) is plain RTL. **UPDATE 2026-11-28**: DE2 and DCC are retired
   from the clock top (300 MHz migration, commit 5eb91c6); DDR1_CLK_DE3
   synthesizes clean AND maps to sg13g2 real cells (dfflibmap/abc),
   TT/SS/FF STA slacks all positive (worst 0.13 ns FF,
   `sim/outputs/ddr1/ihp130/de3_sta_*.log`). The posedge-only-library
   blocker pattern is solved: inverted clock net + async-reset /
   sync-enable discipline (see ddr1_clk_de3.v header).

### DQS line — DONE, no blockers

`DDR1_DQS_DELAY_LINE_PHYS` with `IMPL=1` synthesizes clean through
yosys→sg13g2 (`flow/sta/run_ddr1_dqs_corners.sh`, TAP measurements at
TT/SS/FF PASS). The behavioral `IMPL=0` path and the cell
`DDR1_DQS_DELAY_CELL_BEH` are sim-only by construction (parameter-gated).
The wrapper FSM is plain RTL.

## Frequency-plan dependency — RESOLVED 2026-11-28

DCO=300 MHz ÷3 GO verdict committed (docs/DDR1_FREQ_PLAN.md): endpoints
TT 212-624, SS 111.8-370.0, FF 262.2-903.2 MHz, all corners cover 300
(FF margin -38 MHz thin). Integration done (commit 5eb91c6, 86/86
integration regression).

## Order of work (updated 2026-11-28)

1. ~~FF endpoint verdict~~ DONE (GO, FF margin −38 MHz).
2. ~~Element chain sizing SPICE~~ DONE (`ddr1_dll_chain.py`: N=8,
   lock codes 32.7/71.6/94.2, monotone, CODE_INIT=48).
3. ~~TDC resolution~~ DONE (taps 65/100/45 ps TT/SS/FF, swept in every TB).
4. ~~Rewritable segments + phase detector in synthesizable RTL~~ DONE
   (`SEG_IMPL`/`TDC_IMPL`/`REGEN` split; default keeps the 87-check
   regression).
5. **NEXT**: regenerated-chain SPICE (D_set / duty / phase shift), then
   yosys+STA of the integrated top at TT/SS/FF, then lock-time and
   jitter signoff numbers into the ddr-phy handoff.
