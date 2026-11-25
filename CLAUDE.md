# CLAUDE.md

Guidance for Claude Code (and humans) working in this repository.

## What this is

An all-digital PLL (ADPLL) generator. The PLL is written in Verilog (`src/`) on top of a small set of
technology cells (`PLL_CELL_*`). The flow synthesizes it with yosys, turns the netlists into SPICE with
openroad, characterizes the analog blocks (delay cells, injection, symmetric mux, DCO) in ngspice, and
converts those results into Verilog delay models for fast digital simulations of the whole PLL.

## Layout

- `settings.mk`: shared by `sim/` and `syn/`. PDK selection, sources, tools (native or docker), per-PDK rules.
- `lib/<PDK>_settings.tcl`: liberty/LEF/CDL/SPICE paths of each PDK (read by the tcl scripts).
- ics55 has two standard cell libraries, selected with `SCL` (exported as `STD_CELL_LIBRARY`, which the
  LibreLane configs of the PDK read): `ics55_LLSC_H7CR` (7-track, default) and `ICsprout55_9TSVT_basic`
  (private 9-track, cell map `src/pll_cells_ICsprout55_9TSVT_basic.v`). Its cells have well pins `VNW`/`VPW`,
  tied to VDD/VSS by global connections (`SCL_POWER_PINS`/`SCL_GROUND_PINS`, `syn/tcl/netlist.tcl`).
- `src/`: RTL, testbenches (`*_tb.v`, `test_*.v`, `test_*.sp`) and the Python post-processing.
  - `pll_cells_<PDK>.v`: maps `PLL_CELL_*` to the standard cells of the PDK. The `` `ifdef YOSYS `` section
    declares those standard cells as blackboxes for synthesis.
- `syn/`: `Makefile`, `tcl/` (yosys, openroad, sta scripts), `escape_names.py`, `spice_ports.py`.
- `sim/`: `Makefile` and `tests.mk` (all the simulation targets).
- Outputs are per technology (`TECH`): `syn/outputs/<PDK>/` and `sim/outputs/<PDK>/` (`SYN_OUT`, `SIM_OUT`, also
  `pnr/` and `signoff/`), or `<PDK>-<SCL>` when the library is not the default one.

## Commands

```sh
# PDK is ics55 or ihp-sg13g2 (the default is set in settings.mk)
make PDK=ics55                                 # whole flow: syn all -> pnr all -> signoff (gds, KLayout DRC and LVS)
make PDK=ics55 SCL=ICsprout55_9TSVT_basic      # the same with the private 9-track library
make -C syn PDK=ics55 TOP=FINE_DELAY all gen   # synthesize + powered SPICE netlist
make -C sim PDK=ics55 test_fine_delay          # ngspice delay characterization (also mid/coarse)
make -C sim PDK=ics55 test_pll_injection test_sym_delay
make -C sim PDK=ics55 test_dco_noise           # DCO phase noise (ISF method, ~1h on 10 cores)
make -C sim PDK=ics55 test_pll_digital         # iverilog, uses the models made from the ngspice results
make -C sim PDK=ics55 clean                    # only this PDK; clean_all removes every PDK
```

Simulations depend on their netlists, so a `sim` target synthesizes what it needs (`make -C syn TOP=...`).

## Tools and docker

Each tool (`YOSYS`, `OPENROAD`, `STA`, `IVERILOG`, `VVP`, `NGSPICE`, `PYTHON`) runs natively when it is
installed and the PDK exists locally; otherwise it runs inside `factory.symbioticeda.com/asic-all:dev`
with the repo and the PDK mounted at the same absolute paths. Force with `USE_DOCKER=1` / `USE_DOCKER=0`.
- macOS has no openroad/sta/iverilog, so those always go through docker there.
- IHP (`ihp-sg13g2`) only exists inside the image (`/usr/local/share/OpenPDKs`), so everything runs in docker.
- `PYTHON` needs numpy, scipy, matplotlib and pandas (`requirements.txt`); docker is used if they are missing.
- Variables the tcl scripts read from the environment must be listed in `DOCKER_ENV` in `settings.mk`.

## The analog flow (things that are easy to break)

- Synthesized `_net.v` netlists have no supplies (they are also used by iverilog/SDF). `syn/tcl/netlist.tcl`
  adds `VDD`/`VSS` ports and `global_connect`s every cell supply pin before `write_cdl`.
- openroad writes subcircuit ports alphabetically. `syn/spice_ports.py` reorders them to
  `VDD VSS <verilog port order, buses MSB first>`, which is what the testbenches instantiate positionally.
- `syn/escape_names.py` sanitizes yosys escaped names (including `$paramod...` modules) and must keep the
  whitespace after them.
- The netlists are flattened, so internal nodes are like `xpll.pll_dig/flock_cnt_0_` or `xpll.pll_ana_INJ_WIN`
  (see `src/test_pll_tran.sp`), not the original hierarchy.
- The dynamic loads (`PLL_CELL_NAND3X*`) need `A0` on the NMOS next to VSS, or the fine/mid delays
  decrease with the code. Check the stack order in the CDL when mapping a new library (H7R: `A`, 9T: `C`).
- `PLL_CELL_BUFFX0` (testbench loads) is defined per PDK in the generated `models.inc`, together with the
  model `.LIB` and the standard-cell SPICE include.

## SPICE conventions (ngspice)

- Parameter expressions as `'expr'` (works in ngspice and HSPICE). No bare `(param)` or bare param values.
- `GND` is ground in ngspice: never add a `vgnd GND 0` source (it is a short).
- `.SAVE` instead of `.PROBE`, no HSPICE `.OPTION`s.
- Top-level testbenches end with a `.control` block (`run`, `write <name>.raw`, `quit`), and are run as
  `ngspice -o <name>.log <name>.sp < /dev/null` (not `-b`: it runs the analysis twice and `.meas` does not
  work with `-r`). Outputs: `<name>.raw` (waveforms) and `<name>.log` (`.meas` results).
- `src/spice_io.py` reads both. ngspice prints failed `.meas` first, so never rely on the log order
  (`meas_until_failed` sorts by name).
- `test_coarse_delay.sp` needs `.OPTION minbreak=1e-15` (coincident breakpoints abort the run).
- Thread count goes in the generated `.spiceinit` (`NGSPICE_THREADS`), not on the command line.

## DCO phase noise (ISF)

ngspice has no oscillator phase-noise analysis and no device noise in transient. `test_dco_noise` uses the
Hajimiri-Lee ISF method: `src/create_isf.py` (writes the runs), `src/isf_phase_noise.py` (analysis),
`src/spice_netlist.py` (flattens the netlist to the transistor wrappers). Knobs: `ISF_NPHASE`, `ISF_NPER`,
`ISF_DQ`, `ISF_TWARM`, `ISF_JOBS`. The reference run injects zero current on purpose (the pulse breakpoints
alone shift the edges ~80 fs). `src/dco_shape.ipynb` reads `sim/outputs/<PDK>/test_dco_noise.csv`.

## Make gotchas

- `ROOT_DIR` must be defined by the Makefile that includes `settings.mk` (`syn/Makefile`, `sim/Makefile`).
- `models.inc` and `.spiceinit` depend on `settings.mk` but are only replaced when their content changes,
  so editing `settings.mk` does not re-run the simulations. Editing `syn/Makefile` does re-synthesize
  everything (the netlists depend on it).
- Recipes run in bash with `pipefail` (through `SHELLOPTS`; `.SHELLFLAGS` does not exist in make 3.81, the
  macOS one), so a tool failing behind `| tee` fails the target.
- Long runs: the full transistor-level `test_pll` takes ~27 min per 200 ns of simulated time in ngspice.

## Known issues

- `test_pll_rcx` needs Calibre extraction outputs.
- The `view_*` targets use `WAVEVIEW` (default `gaw`) for the ngspice rawfiles.

## What is still missing, and where to fix it

Measured on 2026-11-19 against `222b70f`.  Everything below was checked on this
checkout; the tool capabilities were probed by running ngspice, not read from
docs.  Split by *what kind of work it is*, because the three groups have very
different cost structures and must not be mixed into one "fix the PLL" task.

### Group 1 — tool capability, not a code bug

**There is no phase-noise analysis in this ngspice build.**  Verified:

```text
$ strings /usr/bin/ngspice | grep -E '^(pss|pnoise)$'   -> nothing
$ strings /usr/bin/ngspice | grep -E '^(NOISE|DISTO)$'  -> both present
$ printf 'pnoise\n.end\n' | ngspice -b                  -> "pnoise: no such command"
```

So the earlier note that "`.pss` exists but `.pnoise` does not" was too
generous: **neither exists**.  A `.pss` card is silently swallowed (it prints
`PSS Points 0`, `PSS Harmonics number 0` and does nothing), which is worse than
an error because a run looks like it completed.

What *does* work: `.noise` / `onoise_total` (small-signal, driven circuit).

Consequence: `test_dco_noise` (the ISF route) is the only viable path to a
phase-noise number, and it has **never been run** — `src/create_isf.py`,
`src/isf_phase_noise.py` and `src/spice_netlist.py` exist but there are no
`sim/outputs/*/test_dco_noise*` artifacts.  That is the highest-value missing
measurement in the repo.  The ISF knob list is in the section above.

**A dangling reference to be aware of**: `flow/characterization/jitter_zerocross.py`
is a deterministic zero-crossing jitter/drift analysis (its own header is
honest that it cannot produce random jitter), but it points at
`phase_noise.py` for "the ISF-based estimate" and **that file does not exist**
in `flow/characterization/`.  The ISF implementation is `src/isf_phase_noise.py`.
Anyone following the reference will find nothing; fix the pointer, or move the
ISF script next to it.

Do not report random jitter or phase noise from transient period spread.  The
existing `macro_char` numbers are *deterministic* spread with noiseless sources
and no routed RC; they are not a jitter budget, and `JITTER_PHASE_NOISE.md` and
`README.md` §9 both say so.  `jitter_zerocross.py` gives deterministic period
jitter, drift and a period-domain PSD — useful, and still not a jitter budget.

### Group 2 — real defects, with the fix entry point

**a) ~~DCO fine bank is non-monotonic~~ — RESOLVED as a measurement artifact
(2026-11-23).**  The "15 rising steps" (e.g. f16/17/18/19 = 287.56/322.73/
281.28/354.08 MHz) were timestep-grid + `uic` startup noise, not the code
step.  Re-baselined at converged tstep (0.05/0.02, edge-interpolated) the
c4/m9 f16..f31 table is strictly monotone, and the whole fine span is only
~12.4 ps (~1.7 MHz @370 MHz, ≈0.8 ps/code) — 6–15× smaller than the reported
"inversions," which were larger than the bank's total range.  Frequency for a
fixed code is non-monotone *in tstep* (f16 = 377/334/357/366 MHz at
0.25/0.1/0.05/0.02 ns), proving the earlier tables never converged.  No
circuit respin needed for monotonicity.  See
`flow/characterization/ihp_l3_dense/README.md` "RESOLVED" for the corrected
mechanism (no DC contention — `LOAD` is a gate only; the cell is a floating
gate-cap, monotone enough at the lock point).

Remaining fine-bank facts (not defects): total authority ~1.7 MHz ≈ 55
kHz/code ≈ ~150 ppm/LSB at 370 MHz — finer than the ±1000 ppm SerDes
bang-bang band, so resolution is adequate for tracking (coarse/mid cover
acquisition).

**Gate-level closed-loop (2026-11-24, post-PNR + SDF, Icarus).**  Full report
`sim/outputs/ihp-sg13g2/gate/GATE_TRANSIENT.md`.  Repro harness in that dir
(`prepare_sim_inputs.py` fixes Icarus-vs-SG13G2 issues: `delayed_*` flop wires,
`\.` escaped instance names, separate macro SDF on `dut.pll_ana`, `-ginterconnect`
unavailable → INTERCONNECT dropped).  Headline: **no corner reaches FREQ_LOCKED**,
for two independent real reasons — NOT a DCO polarity bug:

1. **`MID_OUT` clock-domain constraint is wrong (real signoff bug).**  Both SDCs
   constrain `MID_OUT` at `period 2.5` (400 MHz), but the DCO drives it at
   0.7–1.4 GHz at code 0 and post-PNR `report_clock_min_period` says the domain
   tops out at 0.87–0.94 GHz (FF).  The counter misses edges → `cnt_cap` shows
   impossible deltas → FLL reads "too fast" → rails C/M → ERR (the FF runaway).
   A design clocked at 400 MHz can't be signed off running at 0.7–1.4 GHz.
2. **`sim_dco` is ~2× optimistic → FCW=16 is unreachable.**  The behavioral model
   counts ~1 delay/bank; the gate ring has ~9 gate delays + load, and the L3
   transistor-level map of the same cells gives only 212–624 MHz over the whole
   code range.  FCW=16 (1.6 GHz) is beyond this ring; FCW=6 is already near the top.

The "27 edges/REF = 2.7 GHz" FF state is a **measurement phantom** (glitch/parasitic
count in the overclocked domain), not a DCO mode — code-up=slower held in the
pre-runaway window (C0→2: 14→13→12).  Real fine-code dither was observed at FCW=6
(TT 30↔31 periodic, SS 28–31) proving the gate SS-BBPD is live — but unlocked, not
a post-lock limit cycle.

**Mid LOAD clobber — confirmed a real digital-opt bug, not intentional CTS.**  In the
taped `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.v`, 90 of the 120 mid NAND3
dummy-load `B` pins sit on `net1`/`net2` = outputs of two `sg13g2_inv_4` clones of
`COARSE_OUT` (`clone1`/`clone2`), only 30 on `mid/LOAD`.  Those clone nets feed ONLY
the NAND3 B pins and nothing else — i.e. the P&R tool saw a heavy `LOAD` net and
cloned buffers to share the drive, not knowing those NAND3 loads ARE the analog
delay element.  Result: mid-bank tuning is near-dead on the taped macro and the
ring runs FASTER than the 1.0/1.4/0.7 GHz the (corrected) canary copy measured —
treat those as lower bounds.  Same root cause `il_dco.v` documents for `BASE_NDELS`
(digital optimization silently rewrites an analog delay line).  The canary
`hardmacro/` copy has all 120 on `LOAD` (corrected) but its SDF/Liberty came from
the buggy netlist → the .v/SDF/Lib views are inconsistent and must be reconciled.
Fix (2026-11-24): `(* keep *) (* dont_touch = "true" *)` added in `src/mid_delay.v`
on the `LOAD` net, `inv_0`, every `inv_b`/`dyn` stage, and `inv_1` (same pattern as
`il_dco.v` BASE_NDELS / `fine_delay.v`).  Behavioral regression unchanged
(FREQ_LOCKED @578, c4/m7/f31) — attribute only affects the synth path, SIM branch
untouched.  **Caveat:** RTL `dont_touch` guards yosys synthesis, but the tape-out
clone came from the P&R/CTS stage — whether it propagates to OpenROAD's optimizer
depends on LibreLane mapping it to a physical keep/`set_dont_touch`; confirm that
in the macro flow, and reconcile the buggy `flow/macro/` vs corrected `hardmacro/`
macro views.  This precedes any new MID_OUT period (the freq numbers shift once
the load is restored).

**2026-11-24 resolved (same day).**  The P&R-level guard was missing: the macro
flow runs `SKIP_CLK_ISOLATE=1`, so `protect_analog` never ran and
`repair_design` cloned the mid LOAD driver.  `pnr/tcl/pnr.tcl` now calls
`protect_analog` for `TOP=PLL_ANALOG_MACRO`; the rebuilt macro netlist has
**120/120** mid NAND3 `B` pins on `mid/LOAD` and **0** `clone1/clone2`
(`pnr/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.v`).  All macro views
(`.v`/SDF/Lib/LEF/GDS, per corner) were regenerated from that routed database
and copied to `flow/macro/ihp130_sg13g2/` and the canary `hardmacro/`.  The
corrected open-loop ring is 0.34/0.53/0.76 GHz (SS/TT/FF) — see
`sim/outputs/ihp-sg13g2/gate/DCO_OPENLOOP_SWEEP.md`.  The FLL counter now runs
on a real MID_OUT/2 `clk_div` (`FE_CLK_DIV` declared in `adpll.sdc`), MID_OUT
periods are per corner (2.94/1.90/1.31 ns SS/TT/FF), and the gate transient
reaches `FREQ_LOCKED` at every corner with an in-range FCW (TT 5, FF 6, SS 3) —
FCW=16 is simply out of the corrected ring's range.  See
`sim/outputs/ihp-sg13g2/gate/GATE_TRANSIENT.md` and
`.../STA_MID_OUT_2026-11-24.md`.

**Gate-level signoff chain RESOLVED (2026-11-24).**  The full ordered fix landed —
`gate/GATE_TRANSIENT.md`, `STA_MID_OUT_2026-11-24.md`, `DCO_OPENLOOP_SWEEP.md`:

- **mid LOAD clobber fixed end-to-end.**  RTL `dont_touch` alone was stripped by
  `write_verilog -noattr`; added `protect_analog` (set_dont_touch) sourced in
  `pnr/tcl/pnr.tcl` before placement → **120/120 mid NAND3 B on `mid/LOAD`,
  0 clones** post-P&R.  Macro views regenerated from one routed DB; `flow/macro/`
  and `hardmacro/` netlists now byte-identical (md5 ef42e7cb), SDF/Lib/GDS match.
- **Corrected ring re-measured** (open-loop, waveform period): 0.34 / 0.53 /
  0.76 GHz at C=M=F=0 (SS/TT/FF) — slower than the buggy-load numbers, so FCW=16
  (1.6 GHz) is out of range by design, not a counter artifact.  In-range FCW locks.
- **Real /2 counter clock restored** in `frequency_counter_frontend.v`
  (`always @(posedge clk_div)`, nibble pre-decode kept, B12 enable muxes removed);
  CTS built a real `clk_div` tree.  `FE_CLK_DIV` declared `-divide_by 2`.
- **`adpll.sdc` per-corner** MID_OUT (TT 1.900 / FF 1.310 / SS 2.940 ns, guarded
  `_CURRENT_CORNER_NAME`), `OUT_DIV2_CLK` = OUT/2, uncertainty 0.250→0.050.
- **Result: MID_OUT + FE_CLK_DIV close at all corners** (period_min 0.41 ns vs
  1.31 ns constraint = ~3× margin; counter no longer overclocked → no phantom
  27-edge rail, no runaway).  **FREQ_LOCKED reached at every corner** with an
  in-range FCW (TT fcw5@598, FF fcw6@598, SS fcw3@342) — vs ZERO before.
- **STA now CLEAN at all corners** (`RUN_2026-11-24_13-12-07`): setup WNS 0.0,
  hold WNS 0, TNS 0 at TT/FF/SS, 0 vivolators.  Root cause of the old −0.33/−0.26/
  −0.52 setup + 17 hold was **NE_CLK_* (78 generated negedge clocks) in NO clock
  group** — OpenSTA does NOT inherit a generated clock into its master's group via
  `-source` (the old `adpll.sdc:343-345` comment claiming it does was wrong), so a
  clock in no group is related to everything and the CKR in-reg setup + FILTER_OUT→
  FCWF hold were timed synchronously.  Fix (SDC-only, `constraints/adpll.sdc`):
  record each NE_CLK's master in `_declare_negedge_clocks`, delete the early
  `set_clock_groups` (269-273) + the duplicate proc call (461-470) + the inert
  `_4240_/Q` DCO_EN exemption (invalid startpoint, was silently inert), add ONE
  `set_clock_groups -asynchronous` after `CK_CLK` with every NE_CLK in its master
  group (+ the previously-missing `OUT_DIV_CLK`/`CK_CLK`, −`DSM_CK_CLK`).
  Groups: REF=2 OUT=3 MID_OUT=6 INJ_EDGE=78 = 89, all once.  CKR (REF→MID_OUT
  negedge sampler, `.Q` used as a clock) is a documented async CDC; FILTER_OUT→FCWF
  is a safe bounded CDC (FCWF reloaded every DSM_CK_G edge, ±1 LSB one-cycle
  transient, MASH-reshaper absorbs) — both waiver-by-group, no RTL change.
- **dsm_run unclocked hole RESOLVED (2026-11-24).**  `dsm_run`/`dsm_run_cnt`
  were the only flops clocked by `DSM_CK` (the divider output, *not* a declared
  clock → 2 unclocked pins).  Fixed in `src/pll_logic.v` by clocking the ICG
  startup counter on **MID_OUT** instead (counts `>= 2*DSM_DIV` MID_OUT edges =
  the same 2 DSM_CK posedges, then freezes; `dsm_run` is now a combinational
  compare).  Do NOT declare `DSM_CK_CLK` for this — that reintroduces the CTS
  cascade with the `DSM_CK_G` tree (B20/B23).  Verified `RUN_2026-11-24_14-14-10`:
  unclocked **0**, unconstrained **4** (only CK/OUT/OUT_DIV/`u_dsm_icg/GATE`,
  benign), `DSM_CK` now drives only the ICG `.CLK`, **0 violators / WNS 0.0 at
  TT/FF/SS**.  Lesson: the counter must be **minimal width** (4-bit for
  `2*DSM_DIV=8`); an 8-bit counter perturbed placement and flipped an already
  ~38 ps-margin OUT-divider SS path (`div.phase_last → out_reg/high_phase`) to
  −25.6 ps — a real headroom warning even though the 4-bit version closes clean.
- **Post-lock limit cycle — RESOLVED (2026-11-24): the "rail" was a 10× under-range
  MODEL artifact, not an architecture defect. The real fine bank locks.**
  The earlier diagnosis (fine span ~2.2 ps → phase loop rails at 0/31) came from
  `sim_dco.v`'s fine table, whose whole span was only 2.24 ps (23.77→26.01 ps).  The
  converged-timestep SPICE characterization (`ihp_l3_dense/README.md`, RESOLVED
  2026-11-23, tstep 0.02) measures the real fine authority at **~0.8 ps/code,
  ~25 ps full span** (f16→f31 = 12.4 ps).  Fixing the `sim_delay_fine` table to
  monotone 0.8 ps/code (code-0 base unchanged, span 24.8 ps) makes the behavioral
  loop behave like the real bank: **`pll_macro_top` at FCW=16 now reaches `LOCKED=1`**
  (was never), COARSE=4/MID=3 static post-lock, and **FINE dithers {11,12,14,15}
  (1103 transitions in the dwell), SS-BBPD toggles 01↔11, inst_freq 15/16/17** — a
  real, stable ±2-code bang-bang limit cycle centered at FINE≈13.  **No in-path fine
  actuator redesign is needed** (and it would lose the 0.8 ps resolution — min
  in-path step is ~one gate ≈10–15 ps).
  - Still true: the **gate SDF cannot model MID/FINE** (load-trim varactor, output
    dangling; SDF IOPATH is load-independent → measured zero authority), so the gate
    phase-loop limit cycle is unmeasurable with a digital SDF netlist — it needs a
    code-dependent fine/mid delay model.  Gate `FREQ_LOCKED` is an injection-lock
    result.  Probe caveat: gate TB CSV samples `ss_bbpd` at `negedge REF` ~250 ps
    before the DLF `negedge INJ_EDGE` edge (SS misreports 01 vs real 11).
  - Frequency-alias rejection (0T/0.5T/2T counter FCW-ratio) stands.
  - Caveat: the working proof is the behavioral model with *corrected* fine authority
    (period authority is the governing parameter); a transistor-level closed loop at
    the load-trim would be the gold standard but is not cheap.  Real hardware may
    differ by the load-trim's edge-shape effects — but not by the 10× range gap.
  - **Gate code-dependent model built (2026-11-24, `gate/CODE_DEP_DELAY.md`) — gate
    still does NOT dither, for a DIFFERENT reason.**  `dly_inv_code` added to
    `fine/inv_1_impl` (BASE 35 ps + 0.8 ps/code) and `mid/inv_1_impl` (115 + 1.03),
    verified open-loop: FINE 0→31 adds ~49 ps, MID ~30 ps (2× the in-path table because
    each gate is seen on rise+fall), code 0 unchanged.  SS_BBPD probe moved to
    `negedge INJ_EDGE`.  But gate FCW=5/6 closed loop STILL rails: post-lock FINE
    frozen at 0, SS_BBPD static `01`, and augmented == un-augmented byte-identical
    (FINE pinned at code 0 → the code term never activates).  Cause: the real ring
    **injection-locks to the integer REF ratio and pins the DCO phase off the BBPD
    crossing** by more than fine range can pull → BBPD gives one symbol → DLF rails.
    Behavioral (free-running DCO, no injection lock) dithers because its phase walks
    freely.  So the gate cannot demonstrate a digital-BBPD limit cycle — either
    injection locking is the real phase mechanism (then the digital loop is
    redundant, and injection lock still = full-period phase lock), or the BBPD
    sample point must be co-designed to the injection-locked phase.
  - **DECISION (2026-11-24): accept injection locking as the phase mechanism; close the
    limit-cycle item.**  The ring injection-locks to the integer REF ratio =
    full-period phase lock (0T/0.5T/2T already rejected by the FCW-ratio counter).  The
    digital BBPD phase loop is redundant at gate level but harmless.  For the SerDes,
    the ADPLL only needs to supply a stable clock and the CDR (tap-muxed) does the data
    phase tracking; a gate-level digital-BBPD limit cycle is **not** a signoff
    requirement.  Code-dependent gate model (`dly_inv_code`, `gate/CODE_DEP_DELAY.md`)
    stays as the tools for any future phase-loop work.  Behavioral FCW=16 free-running
    still shows the digital loop *can* lock+dither with correct fine authority (record
    of what the load-trim achieves when not injection-dominated).  Note: behavioral
    FCW=5 churns (does not lock), so FCW=16 is the only behavioral lock point.
- (was: mid LOAD keep RTL only — now superseded by the full P&R protection above.)

**DCO phase noise (2026-11-23, ISF/Hajimiri method).**  Full ISF extraction on
the IHP netlist — `sim/outputs/ihp-sg13g2/ISF_NOTES.md`, `test_dco_noise.csv/pdf`.
At the **ADPLL lock point c4/m9/f25 (f0 = 359.30 MHz)** — `lock/`: L(1 MHz) =
**−98.34 dBc/Hz** (thermal floor −112.9), 1/f³ corner 27.7 MHz, 10 MHz −127.2,
100 MHz −151.9.  Reference c8/m8/f8 (275.9 MHz): L(1 MHz) = −102.4.  Measured
delta +4.04 dB at 1 MHz ≈ the f0⁴ rescale (f0² under-predicts by ~2 dB).
Two caveats on the record: (1) `psp103.osdi` emits ZERO small-signal noise in
this ngspice-44.2 build, so the 15 noise LUTs are synthesized (sfl + 4kT·(2/3)gm)
— absolute dBc/Hz is approximate, the ISF shape + per-net ranking is
timestep-accurate, the flicker corner is pessimistic (real ~0.1–1 MHz).  (2)
The dominant contributor is `xdco.mid/load` ~77% (mid-stage load) at BOTH codes
— the lever is lower gm/flicker or more swing there.  Runs at 1 ps (19 lock /
27 main nets); needed a tmpfile() LD_PRELOAD shim because /tmp tmpfs filled
(glibc ignores $TMPDIR).

**Estimated locked-jitter signoff (2026-11-24).**  pnoise cannot be run here,
so the thermal column of the lock-point ISF is signed off through a
first-order high-pass at an **assumed** 100 kHz: **4.0 ps rms**, tag
`ESTIMATED_THERMAL_HP_100kHz`.  The synthesized-flicker total is not signed
off, and the 1 MHz row is not this loop's bandwidth.  Record:
`flow/characterization/JITTER_PHASE_NOISE.md`, `lock/ISF_LOCK_NOTES.md` §7.
`FAIL_UNCHARACTERIZED` for production/PEX is unchanged.

**Model polarity fixed (2026-11-23).**  `pll_ring_dco.v` and
`pll_counter_dco.v` modelled `code-up = faster` (`period = BASE −
STEP·countones` / `increment = 5 + 2·countones`), inverted against both the
real cells (measured: code-up = slower, on all three banks — the coarse
tap-select folds the chain back through more stages; the mid/fine dangling
NANDs gate-load the shared node harder) AND the `freq_lock` loop, which
already assumes code-up = slower (it *decrements* the code to speed up).  Both
models now use code-up = slower; `arch_models_tb` asserts max-code < min-code
frequency.  `sim_dco_lock.v` was already correct (`period = BASE +
STEP·code`).  Only the behavioral Core B/C models were wrong — the transistor
`PLL_ILDCO` path was always correct.

Note this is a *different* defect from the DLL segment DNL fixed in `222b70f`
(delay line, now 0.00 LSB over 280 codes).  Do not conflate them.

**b) DSM domain setup, −6.14 ns at SS (101 of 181 paths).**
Path: `pll_dig.dsm_impl.dsm.dff_err3[11] -> pll_dig.FINE_MUX_D[14]`, both on
`DSM_CK_G`.  The path has **three** series stages, which the gap doc does not
spell out:

1. the `delta_sigma` error-feedback adder chain (`BITS_DSM = 12`, 3rd order);
2. `FILTER_DEC` through `pll_term_decoder_with_zero`, a pure combinational
   `OUT = (1 << IN) - 1` over 31 bits with no register;
3. the decoder output feeding `FINE_MUX`'s D input directly
   (`src/pll_logic.v`, the `FINE_MUX <= FINE_MUX_D` flop).

Cheapest fix, and the one that does not touch the DSM maths: **register
between the decoder and `FINE_MUX`**.  Cost is one extra `DSM_CK` of fine
update latency, which is irrelevant at a ~1 MHz loop bandwidth.  Narrowing
`BITS_DSM` also works but costs fractional resolution (12 bits ≈ 244 ppm/LSB).
Pipelining the error feedback changes the DSM noise-shaping transfer function
and needs re-verification.

**c) `SS_BBPD` has no timing arc to `INJ_EDGE`.**
Verified in all three `flow/macro/ihp130_sg13g2/corners/*.lib`:
`setup_rising: 0`, `hold_rising: 0`, and each corner lib has 20 `timing()`
groups that are **all** `timing_type : combinational` (60 total across the
three, zero sequential), referencing `REF`/`INJ_EN`/`COARSE_MUX`.  `SS_BBPD`
appears only as a `bus_type`.  (The root-level `PLL_ANALOG_MACRO.lib` has a
different count, 42 arcs — do not compare the two files' arc counts.)  The
digital loop filter's capture of the sampler is therefore checked against
nothing, which blinds top-level STA across the whole loop.

Fix is Liberty-only, no RTL risk: add `timing()` groups on `SS_BBPD[1:0]` with
`related_pin : "INJ_EDGE"` and `timing_type : setup_rising` / `hold_rising`, in
all three corner libs.  Calibrate from the macro's own STA — the TT post-PEX
number for the sibling path `INJ_EN -> dff_y_impl/D` is setup +1.4837 ns /
hold +0.5937 ns (`flow/IHP130_TAPEOUT_GAPS.md` B3) and is a reasonable seed.

### Group 3 — missing characterization rigs (not defects)

- **Lock time**: only a behavioural "~202 REF to full LOCKED" exists, with no
  PVT and no PEX.  `src/pll_macro_top_tb.v` already observes `LOCKED`; record
  `$time` at its first rising edge, but only a **gate-level/SDF run over
  TT/SS/FF** gives a number worth quoting.
- **BER**: no rig at all (needs PRBS + error injection + bathtub).
- **Injection lock range, lock time, false-lock**: `IL_NDELS=4` is fixed, so the
  range is a design constant that nobody has measured.
- **DCO full-range frequency / tuning range**: only a 27-point sparse scan and
  32 fine points; the full coarse × mid × fine grid is unmeasured.
- **Full-top power/area** with parasitics: 9.5 mW (TT) exists but without PEX
  and without corners.
- **Package/board/PDN signoff, foundry-qualified DRC/LVS**: not started.

### Group 4 — bookkeeping that will mislead the next reader

- `flow/IHP130_TAPEOUT_GAPS.md` has **two `### B4` sections**: one marked
  CLOSED (multi-corner Liberty, genuinely done — `corners/*.lib` exist) and an
  older "Zero multi-corner macro Liberty" that was never deleted.  Delete the
  second.
- `flow/generator/architecture_catalog.json` still says
  `multiphase_dco: implementation: missing, implementation_refs: []`, but
  `src/pll_multiphase_dco.v` exists and `pll_multiphase_dco_tb` passes (8
  phases uniform within 0.4 % at `PH_W=3`).  The catalog is what the generator
  consults, so this entry wrongly rejects a working architecture.
- `flow/macro/cdr_ihp130/` is the CDR back end for a multi-phase sample clock
  (`cdr_top_tb` passes: 8 phases, DCO oscillates, `REC_CLK` parked low on tap
  change, sampler tracks DATA), but it has **no `macro.sdc.tcl`** (compare
  `cdr_sky130`, which has one), **no PnR run, no DRC/LVS and no `SIGNOFF.md`**.
  It is RTL-verified and nothing more.  Do not present it as a qualified block.

  Both testbenches reproduce here, but they need the CIEL stdcell models —
  `pll_cells_ihp-sg13g2.v` instantiates real `sg13g2_*` cells, so compiling
  without them fails with `Unknown module type: PLL_CELL_INVX1`-style errors
  that look like a missing wrapper but are just the missing library.  With
  `V=<ciel>/ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog`:

  ```sh
  iverilog -g2012 -o mp.out src/pll_multiphase_dco.v src/pll_multiphase_dco_tb.v \
      src/pll_cells_ihp-sg13g2.v $V/sg13g2_stdcell.v $V/sg13g2_udp.v
  # -> pll_multiphase_dco_tb: PASS  (PH_W=3 -> 8 phases, uniform within 0.4%)

  iverilog -g2012 -o cdr.out flow/macro/cdr_ihp130/src/cdr_top.v \
      src/pll_multiphase_dco.v flow/macro/cdr_ihp130/src/cdr_top_tb.v \
      flow/macro/cdr_ihp130/src/{alexander_pd,digital_loop_filter,coarse_delay,mid_delay,fine_delay,term_decoder,pll_counter_dcdl_phys,pll_cells_ihp-sg13g2}.v \
      $V/sg13g2_stdcell.v $V/sg13g2_udp.v
  # -> cdr_top_tb: PASS
  ```

  `sg13g2_udp.v` is required: `sg13g2_stdcell.v` instantiates `ihp_dff_r` and
  friends from it, and the ORFS platform copy does not ship it.
- The root `flow/macro/ihp130_sg13g2/PLL_ANALOG_MACRO.lib` is still TT-only
  while `corners/` holds all three.  `config.macro.yaml` maps corners
  correctly, so this is packaging only.

### Review items closed on 2026-11-19 (SerDes agent)

Each of these was checked against the file before acting:

| item | state | resolution |
|---|---|---|
| `jitter_zerocross.py` pointed at `phase_noise.py`, which does not exist | confirmed | now points at `src/isf_phase_noise.py` and says so |
| `architecture_catalog.json` said `multiphase_dco: implementation: missing` | confirmed | set to `rtl_verified` with the four implementation refs and a `status_note` that the CDR backend is RTL-only |
| `IHP130_TAPEOUT_GAPS.md` had two `### B4` sections | confirmed | the stale "Zero multi-corner macro Liberty" one is removed and replaced by a comment pointing at the closed entry |
| `cdr_ihp130` had no `macro.sdc.tcl` | confirmed | added; `SDC OK`, 2 clocks (`REF` 10 ns, `REC_CLK` generated). Three real traps were found while writing it: (a) `get_ports {TAP[*]}` matches nothing — the ports are buses, so use `TAP`; (b) Yosys renames the DCO closing-gate pin to an anonymous `_xxxx_p_Pin`, so a pin-anchored generated clock silently resolves to nothing — anchor on the `REC_CLK` output port instead; (c) an unguarded `get_pins` on a missing name raises `STA-0374` and aborts the whole SDC, so wrap it in `-quiet` + `llength` |
| DSM setup path −6.14 ns at SS | confirmed, and the three stages are as described | fixed by registering `FILTER_DEC` between `delta_sigma` and the thermometer decoder, inside the `IS_DSM` branch (`DSM_CK_G` is not in scope outside it). Registering the decoder OUTPUT does not help — adder and decode stay in series. `pll_macro_top_tb` still passes (`LOCKED=1`, `FREQ_LOCKED=1`) |
| ISF phase-noise flow never run | confirmed: no `sim/outputs/*/test_dco_noise*` | in progress; see below |

**Still open from the review, not fixed**: the DCO fine-bank non-monotonicity
(Group 2a) is the only *functional* defect and needs circuit-level debug, not a
code change. `cdr_ihp130` still has no PnR run, DRC/LVS or `SIGNOFF.md`, so it
must not be presented as a qualified block.

**The ISF flow needs `PDK_ROOT` with the `ics55/` level.** The PDK on this host
is flat (`/grid/icsprout55-pdk/libs.tech/...`), but `lib/ics55_settings.tcl`
builds `$PDK_ROOT/$PDK/...`, so a direct `PDK_ROOT=/grid/icsprout55-pdk` fails
with `couldn't read file .../ics55/libs.tech/librelane/config.tcl`. Make a
symlink root instead:

```sh
mkdir -p /tmp/opencode/pdkroot
ln -sfn /grid/icsprout55-pdk /tmp/opencode/pdkroot/ics55
make -C syn PDK=ics55 TOP=PLL_ILDCO all gen USE_DOCKER=0 PDK_ROOT=/tmp/opencode/pdkroot
```

### ngspice 44.2 defect found while wiring the ISF flow (2026-11-19)

**A netlist whose only content is comments/`.param` plus a `.op`/`.tran` card
aborts ngspice 44.2 once the transient/op phase is entered:**

```text
$ printf '* comment only\n.param x=1\n.op\n.end\n' > c1.sp
$ ngspice -n -b c1.sp
ngspice: ../../../../../src/frontend/dotcards.c:225: ft_cktcoms:
Assertion `plot_cur->pl_dvecs != NULL' failed.
```

The same deck with the analysis inside a `.control` block runs fine.  This is
what the existing convention in this file ("`.control` block, not `-b`") is
protecting against; it is a crash, not a warning.

**`BUFX*`/`INVX*` cells in the ics55 CDL cannot be parsed as shipped.**  The
CDL calls the transistor-level inverter with the HSPICE slash form and passes
sizing parameters:

```text
.SUBCKT BUFX0P5H7R A VDD VSS Y
XXI1 net6 VDD VSS Y / INV pl=6e-08 pw=1.9e-07 nl=6e-08 nw=1.5e-07
.ENDS
```

but `.SUBCKT INV A VDD VSS Y` declares no formal parameters, so ngspice stops
with `Too many parameters for subcircuit type "inv"`.  There are **1473** such
calls in the ics55 CDL, so this blocks every transistor-level ics55
simulation, not just the ISF flow.

Fix (done in a patched copy, not in the PDK):

```text
.SUBCKT INV A VDD VSS Y pl=6e-08 pw=1.9e-07 nl=6e-08 nw=1.5e-07
```

Applied to `/tmp/opencode/pdkroot/ics55/libs.ref/ics55_LLSC_H7CR/cdl/ics55_LLSC_H7CR_patched.cdl`; point `models.inc` at that file.  Verify with a
minimal deck: with the patched header the `Too many parameters` error is gone
with or without the `/` separator.

**Status: blocked.**  `test_dco_isf_wave.sp` gets through model loading and
into the transient, but the ics55 CDL cannot be parsed by this ngspice build,
so no transistor-level ics55 number can be produced on this host.  A CDL patch
that adds default values to `.SUBCKT INV` fixes a two-line reproduction but NOT
the real file: the same `Too many parameters` still fires for `BUFX*`, and
ngspice reports the name lower-case even though the CDL contains only one
upper-case `INV` definition.  `params:` as the formal-parameter keyword makes it
report `.subckt ... .ends` mismatch instead.

Options, in order of cost:

1. use a different ngspice build (the PDK's own wrapper targets a specific one);
2. convert the CDL to ngspice-native form once (drop `/`, push `pl/pw/nl/nw`
   into explicit device widths) — mechanical but touches 1473 calls;
3. characterise the DCO on IHP instead, whose PSP103 OSDI path does work.

Also fixed in `src/spice_netlist.py`: `_split_params` now drops the bare `/`
token, so the HSPICE form `X... Y / INV pl=...` no longer leaves the real
master name in the parameter list (master became `/` and `INV` was read as a
parameter).

### Two rules worth not relearning

Both from `a9f51f7`/`222b70f`, and both cost real debug time:

- **An odd-divisor clock must be 50 % duty before a DLL sees it.**  A
  posedge-only divider gives 2:1 at div=3 (66.7 %), 3:2 at div=5 (60 %), 8:7 at
  div=15 (53.3 %), and the DLL then walks on unequal phase steps.  The
  two-counter (one per edge, OR-ed) construction is exactly 50 %.
- **Freeze a tap commit to a boundary every period is guaranteed to reach**,
  never to a "quiet window".  Once the delay exceeds the low half-period there
  is no quiet window at all and the loop deadlocks; the working rule is the
  rising input edge.

Also: the 5 ns DLL closures (DNL 0, every corner) are **behavioural** —
`src/dll_full_period_tb.v` says "not silicon" itself.  They do not overturn the
measured ics55 DCDL range (SS 6.43–7.98 ns, so 5 ns is still blocked at SS).
Both statements are true at once.

