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

**a) DCO fine bank is non-monotonic (15 rising steps).**
`flow/characterization/ihp_l3_dense/README.md`: fine 16/17/18/19 give
287.56 / 322.73 / 281.28 / 354.08 MHz at 100 ns, i.e. a 41 MHz *drop* at code
18.  This is not a startup artifact (sparse and dense agree at the overlap) and
not an averaging problem.  `src/pll_ring_dco.v` models fine as a linear
`FINE_STEP_NS * $countones(FINE_MUX)`, which cannot express the real
behaviour: the fine mux loading changes with the code and some codes may
sustain a different oscillation mode.  **This is the only defect here that
makes the PLL functionally wrong** (a non-monotonic code breaks frequency
acquisition), so it is the first thing to fix.  Needs circuit/layout-level
debug plus per-code relabelling, using the 31-point scan
`flow/characterization/ihp_l3_dense.py` already provides.

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

