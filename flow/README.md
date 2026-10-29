# ADPLL library portfolio and LibreLane flow

See the repository root `README.md` for the consolidated English characterization and post-layout report.

Status: **skeleton + working catalogue**.  The catalogue and block-support
matrix are generated from the local `/grid` PDK trees.  The QoR sweep,
LibreLane config generation, and per-block hard macros are the next layer.

## Decisions captured

- **ETRI050 is 0.5 µm / 5 V**, not 0.35 µm.  It has only TT/5 V/25 °C Liberty
  views and a SPICE model without temperature parameters, so it is **Tier 1**.
- **OpenRule1um and TR-1um are deferred**.  They stay disabled in
  `flow/pdks.json`; OpenRule1um has no Liberty/LEF for a standard-cell flow,
  and TR-1um's standard-cell library is still experimental.
- **No product baseline.**  Every usable library is catalogued, compared, and
  exposed as an option.  The user selects the combination.  A small **CI
  canary** per PDK exists only to detect flow breakage; it is not a product
  default.
- **All usable libraries are enabled** when they have Liberty + LEF + GDS +
  CDL/Verilog and are not SRAM/IO/backup.  "Usable for a block" is a separate
  screen (`core_support`).
- **Per-block mixing is allowed**: DCO, PD, digital, TDC, divider, DSM and IO
  may come from different libraries of the same PDK.  Same voltage first;
  mixed voltage needs level shifters/UPF and explicit validation.
- **LibreLane is the default top-level flow.**  The DCO/PD/injection/symmetric
  mux are pre-hardened macros; the digital control is synthesized and
  integrated by LibreLane.  ckdur's custom OpenROAD Tcl flow is used only to
  build/characterize the hard macros, not as the default top-level flow.
- **Tier 2 flow is per library**, not per PDK.  A library with all supported
  corners can be `2-flow`; a TT-only library is `1`.  `2-flow*` means the PDK
  declares DRC/LVS pass but the evidence still has to be attached.

## Current lane status (2026-10-29)

- **sky130 `.lib.json` -> Liberty**: converter implemented; 12 files generated
  for `ms`/`lp`/`ls`/`hdll`; OpenSTA/Yosys validated.  The four libraries are
  in the catalogue as `pnr_ready=false` until fill/tap/decap/diode (and lp
  busdriver/bushold) physical cells are resolved.  See
  `sky130_lib/README.md`.
- **ics55 H7CR `PLL_ANALOG_MACRO`**: the hard macro has been built with the
  ckdur flow at **160 x 100 µm**.  LEF/Liberty/CDL/SPEF/SDF/Verilog/DEF/GDS
  are written.  The GDS streamout layer map was fixed
  (`flow/maps/ics55_lefdef.map`), and `add_density_fill.rb` adds the
  PDK-whitelisted ACT/POLY/M1-M3/T4M2 dummy fill.  KLayout DRC is
  **305 = 305 7T-cell-internal + 0 top-level** (`drc_summary.md`); the
  remaining items are library cells (FILLTAPH7R NP holes, M1DUM,
  metal-area), not macro routing.  `drc_waiver.json` +
  `waive_drc.py` record an explicit cell-internal waiver with **remaining
  0**; top-level items can never be waived by this script.  LVS **PASSES**
  (`ICS55_LVS_COMPARE=PASS`) with the flat reference from `flatten_cdl.py`
  (1570 devices / 71 ports), `run_mode=flat`, and `combine_devices=true`.
  See `macro/ics55_h7cr/README.md`.
- **ics55 H7CR + Core A canary**: `pll_logic` synthesizes to 1571 H7CR cells
  (4321.8 µm²).  LibreLane v3.0.16 (Nix store path) ran the digital-only top
  through placement, CTS, detailed routing, fill, RCX and post-PnR STA.  It
  found a real corner cell-set mismatch (`ICGNX3H7R` absent in
  `ss_cworst_1p08_m40`) and a duplicate-SPEF IR-drop issue; the canary now
  uses the three PDK-wired corners and explicit `RCX_RULESETS`.  A Magic
  streamout failure (no Magic tech) is skipped so KLayout can own streamout.
  Final digital-only run `RUN_2026-10-29_10-21-16` completed 80/80:
  `route__drc_errors=0`, no setup/hold violations, antenna 0.  The original
  KLayout DRC number (2312) was produced with the same wrong GDS map; after
  re-streaming the final DEF with `flow/maps/ics55_lefdef.map`, the true
  KLayout DRC is **5734 = 4259 7T-cell-internal + 1453 via-cell + 22 top-level**
  (top-level is density; via-cell is LEF-via M2 pad geometry).  LVS was skipped
  (no Magic/Netgen collateral).  This is a PnR canary, not signoff.  See
  `canary/ics55_h7cr_core_a/README.md`.
- **IHP SG13G2 `PLL_ANALOG_MACRO`**: ported the macro build to
  `sg13g2_stdcell` 1.2 V using `pll_cells_ihp-sg13g2.v`.  P&R completed on a
  160 x 105 µm die with detailed-route DRC **0**; GDS, LEF, Liberty, CDL,
  SPEF, SDF and DEF are written.  KLayout LVS **PASSES** against the IHP
  sg13g2 deck (`Congratulations! Netlists match`) on the fill-stripped LVS
  view.  `add_density_fill.rb` uses per-layer keepout + layer-specific pitch
  and closes the ORFS minimal DRC density checks: **0 violations** on the
  filled GDS (ACT 35.45%, M1 35.95%, M2–M5 35.45–42.40%, TM1/TM2 36.70/40.17%).
  See `macro/ihp130_sg13g2/README.md`.
- **gf180mcu `PLL_ANALOG_MACRO`**: first-pass LibreLane macro on
  `gf180mcu_as_sc_mcu7t3v3`; 80/80, 85.6 x 103.6 µm, route DRC 0,
  setup +0.487 ns / hold +0.306 ns.  GDS, LEF, Liberty, CDL, DEF and
  Verilog are written.  The `~/.ciel` gf180mcuA KLayout decks run with
  KLayout 0.30.7: **DRC PASSES (0)** after die shrink + marked metal fill, and
  **LVS PASSES** with `check_ports=false` plus a flow-local fill-marker
  exclusion (unmodified LVS sees floating fill nets).  See
  `macro/gf180mcu/README.md`.
- **sky130 `PLL_ANALOG_MACRO`**: first-pass LibreLane macro on
  `sky130_as_sc_hs`; 80/80, 80.2 x 90.9 µm, route DRC 0, setup +2.463 ns /
  hold +0.158 ns.  GDS, LEF, Liberty, DEF and Verilog are written.  The
  `~/.ciel` sky130A KLayout DRC deck runs with **0 violations**.  The PDN
  power-pin map was corrected to `VPWR/VPB` and `VGND/VNB`; the rerun has zero
  `PSM-0038/0039/0069` warnings.  LVS no longer stops on must-connect PDN
  errors; it still fails at cell-subcircuit comparison because the
  Magic-extracted CDLs use separate fingers/`VNB`, while KLayout extraction
  produces combined devices/`sky130_gnd`.  Signoff is not claimed.  See
  `macro/sky130_as_sc_hs/README.md`.  A second sky130 lane on
  `sky130_fd_sc_hd` (full PDK CDL) reaches DRC 0 with the same fixed PDN;
  using `tapvpwrvgnd_1` removes the body-pin PSM errors, but KLayout LVS still
  fails cell-subcircuit pin/device comparison.  See
  `macro/sky130_fd_sc_hd/README.md`.
- **gf180mcu 3.3 V + Core A canary**: `pll_logic` synthesizes to 1690
  `gf180mcu_as_sc_mcu7t3v3` cells (49,069 µm²).  LibreLane 3.0.16 completed
  the digital-only PnR flow **80/80** (8:12, exit 0) with documented skips for
  missing signoff collateral: no KLayout/Magic decks, no OpenRCX rules, no
  GDS, no post-PnR STA/IR.  Routing DRC 0, antenna 0, 2,944 non-fill
  instances, 42.37% utilization.  Mid-PnR STA has **one r2r setup violation
  of -0.092 ns at ff/n40C/3.6 V**; hold is clean.  This is a PnR canary, not
  signoff.  See `canary/gf180mcu_as_sc_core_a/README.md`.
- **ihp130 1.2 V + Core A canary**: `pll_logic` synthesizes to 1587
  `sg13g2_stdcell` cells (26,243 µm²).  LibreLane 3.0.16 ran a locally
  assembled minimal PDK root through floorplan, CTS, detailed route (0 routing
  DRC), fill, RCX, 3-corner STA, IR drop and KLayout GDS.  Hold is +0.125 ns;
  setup is TT +0.622 ns, FF +1.145 ns, **SS -0.316 ns (10 paths, TNS -2.534
  ns)** under the nominal 2.5 ns OUT/MID_OUT assumption, so the flow exits
  non-zero at the setup checker.  DRC/LVS/antenna are not claimed; the
  official IHP PDK root/decks are absent.  See
  `canary/ihp130_sg13g2_core_a/README.md`.

- **Multi-library synthesis matrix**: `flow/experiments/` maps the same
  `pll_logic` with 21 library/corner candidates (17 PASS).  It covers `/grid`
  sky130 hdll/ms/ls/OSU/RHBD, gf180 OSU gp12/gp9 and AS/OCD/ex, IHP 8T and HV,
  ics55 H7CH/H7CL, ETRI050, and the `~/.ciel` OpenPDK defaults
  (`sky130_fd_sc_hd`, `gf180mcu_fd_sc_mcu7t5v0`, `sg13g2_stdcell`).  Four
  failures are recorded with causes (async DFF mapping or ABC crash), not
  dropped.  The OpenPDK FD 3-metal P&R canary is also recorded: synthesis and
  global placement complete, detailed placement fails `DPL-0036` on 272/280
  sequential cells.  This matches OpenROAD issue 11511: the older DPL blocks
  sites whose cell pins sit on a PDN via-stack layer; the bundled OpenROAD
  2026-02-17 predates the orientation-aware fix.  See
  `experiments/README.md` and `canary/gf180mcu_fd_core_a/README.md`.

## Performance snapshot

`flow/PERFORMANCE.md` records the current traceable ADPLL architecture targets, macro areas, digital-canary timing/power, and post-PnR smoke numbers, with explicit “not characterized” items.  It is not a full top-level ADPLL signoff report.  `flow/ADPLL_FREQ_DIV.md` covers the FCW/divider parameterization, RTL vs design-script semantics, and the measured REF/DCO timing ceilings.  `flow/PDK_ESTIMATES.md` gives the per-PDK GF180/sky130/IHP/ETRI feasibility estimates and the GF180 FD blocker.

## Post-PnR simulation

`sim/post_pnr/` contains a gate-level smoke test for the ics55
`PLL_ANALOG_MACRO` P&R netlist with `$sdf_annotate` and Icarus 12.
SDF annotation materially changes the observed period; see
`sim/post_pnr/README.md` for the current numbers and the important limits
(Icarus ignores SDF corner arguments, and this is not transistor-level DCO
or full-PLL simulation).

## What is in this directory

```text
flow/
  pdks.json                 PDK roots and library globs (OpenRule1um/TR-1um off)
  enumerate_libs.py         scans libs, parses Liberty/LEF, emits the catalogue
  screen_libs.py            builds the library × block support matrix
  libraries.json/.yaml/.md  generated catalogue
  screening.json/.md        generated block-support matrix
  validate_selection.py     per-block selection checker
  selection.schema.json     per-block selection schema
  selection.example.json    same-voltage mixed-library example
  compare/                  QoR comparison schema and notes
  ci/canary.json            smoke combinations (not product defaults)
  librelane/                LibreLane config skeleton / integration notes
  sky130_lib/               .lib.json -> Liberty converter + generated out/
  maps/                     LEF/DEF layer maps (ics55; not GDS-import maps)
  overlays/                 library rows outside /grid/<pdk> (IHP ORFS 1.2V)
  macro/ics55_h7cr/         PLL_ANALOG_MACRO ics55 build (views; top DRC 0, waiver, LVS PASS)
  macro/ihp130_sg13g2/      PLL_ANALOG_MACRO IHP build (views; DRC 0, LVS PASS on fill-stripped view)
  macro/gf180mcu/           PLL_ANALOG_MACRO gf180 build (views; DRC 0, LVS PASS)
  macro/sky130_as_sc_hs/    PLL_ANALOG_MACRO sky130 build (views; DRC 0, PDN fixed, cell-CDL LVS open)
  macro/sky130_fd_sc_hd/   sky130_fd_sc_hd experiment (DRC 0, PDN fixed, LVS open)
  canary/ics55_h7cr_core_a/ ics55 H7CR Core A canary
  canary/gf180mcu_as_sc_core_a/ gf180mcu 3.3V Core A canary
  canary/ihp130_sg13g2_core_a/  ihp130 1.2V Core A canary
  canary/gf180mcu_fd_core_a/ gf180mcu OpenPDK FD 3-metal canary (DPL 0036, experiment)
  experiments/              20-library Yosys synthesis matrix + logs
```

Run:

```sh
python3 flow/enumerate_libs.py
python3 flow/screen_libs.py
python3 flow/screen_libs.py --pdk ics55 --core core_a_il_dco
python3 flow/validate_selection.py --selection flow/selection.example.json
python3 flow/sky130_lib/make_overlay.py   # after regenerating sky130 out/
```

## Current catalogue snapshot

`enumerate_libs.py` currently sees **25 library directories**, **22 usable**
and **19 Tier-2-flow candidates** (4 of the usable rows are reconstructed
sky130 Liberty with `pnr_ready=false`; the IHP `sg13g2_stdcell` 1.2 V row is
an overlay from the ORFS platform).  Important caveats:

- `sky130_fd_sc_ms`, `sky130_fd_sc_lp`, `sky130_fd_sc_ls` and
  `sky130_fd_sc_hdll` originally had only `.lib.json` timing data.  The
  converter in `flow/sky130_lib/` now reconstructs STA-usable Liberty files
  (12 validated files, OpenSTA/Yosys checked).  They are listed as
  `pnr_ready=false`: the source JSON has no fill/tap/decap/diode (and lp
  busdriver/bushold) cells, so they are **STA/PPA comparison libraries, not
  drop-in PnR libraries** until those physical cells are supplied.
  `sky130_as_sc_hs` and the OSU t12/t15/t18 libraries remain the PnR-ready
  sky130 options.
- `ihp130/glow_sg13g2` has no Liberty/LEF in this checkout; it is not usable
  as a standard-cell library yet.
- `gf180mcu_as_ex_mcu7t5v0` is file-level usable but the current screen finds
  no core support; it is not a PLL candidate without a cell-mapping study.
- `ETRI050` 12T and 9T are usable but Tier 1: one corner, no temperature
  model.  12T is the safer choice; 9T is research.
- `ics55` H7CL/H7CR/H7CH and `ihp130` libraries show `partial` for some blocks
  because a dedicated `clkbuf` is absent; `buf` + `inv` are the documented
  fallback, but the equivalent must be characterized.  `partial` is not
  "unusable".  `ihp130` now qualifies as `2-flow*` because its three
  TT/SS/FF corners are the complete set the PDK provides.
- `sky130_osu_sc_*` supports Core B/C but not Core A in the current screen;
  do not force IL-DCO onto them without a cell study.

The generated `libraries.md` and `screening.md` are the source of truth for
the current run.  The catalogue is a **screen**, not a DRC/LVS guarantee.

## Library eligibility

A library is `usable` when all of the following exist:

1. at least one Liberty `.lib`;
2. at least one LEF (with `MACRO` definitions);
3. at least one GDS;
4. at least one CDL or Verilog model;
5. at least one parsed `cell (...)`;
6. it is not an SRAM/ROM/IO/pad/backup directory.

DRC/LVS status comes from `pdks.json`:

- `pass` — the exact library/PDK evidence is attached (currently only ics55).
- `declared` — the PDK is believed usable, but the evidence must be attached
  before a `2-flow` claim.
- `unknown` — do not claim Tier 2.

The block screen checks the cells needed by the PLL:

| Block | Required (examples) | Optional |
|---|---|---|
| Core A IL-DCO | inv, nand2, nand2b, nand3, nor2, buf, dff | inv_strong, and2, clkbuf |
| Core B ring DCO | inv, nand2, buf, mux2, dff | clkbuf |
| Core C counter DCO | inv, nand2, nor2, buf, dff | tie, clkbuf |
| Digital | inv, nand2, nor2, buf, dff | mux2, tie, clkbuf, scan DFF |
| SS-BBPD | nand2, nor2, buf, dff | clkinv |
| SR TDC | dff, inv, buf | — |

If a required cell is missing, the block is `no`; if only optional cells are
missing, it is `partial`.  `partial` still needs an equivalence/characterization
note before tapeout.

## Per-block mixing

`selection.example.json` shows the intended shape:

```json
{
  "pdk": "ics55",
  "core": "core_a_il_dco",
  "blocks": {
    "dco":     {"library": "ics55_LLSC_H7CH", "voltage": 1.2, "kind": "hard_macro"},
    "pd":      {"library": "ics55_LLSC_H7CH", "voltage": 1.2, "kind": "hard_macro"},
    "digital": {"library": "ics55_LLSC_H7CL", "voltage": 1.2, "kind": "soft"}
  },
  "tier": "2-flow",
  "corners": "all"
}
```

Rules for the validator (next step):

1. Every selected library must exist, be `usable`, and support the block/core.
2. All blocks must be the same PDK and the same voltage, unless level
   shifters/UPF are explicitly selected and validated.
3. `dco`/`pd` are hard macros for Core A/B; `digital` is soft.  Core C can be
   fully soft.
4. Mixed libraries are allowed only when the cell mapping and timing/hold
   corners have been checked; the flow reads all selected Liberty/LEF files.
5. `tier` is the **minimum** tier of the selected blocks; do not claim
   `2-flow` if any selected library is TT-only.

## LibreLane flow

The default top-level flow is LibreLane:

1. **Hard macro build (per PDK × DCO/PD library)** — use the ckdur
   OpenROAD/Magic/ngspice flow, or an equivalent, to produce GDS/LEF/Liberty/
   CDL/SPICE and the characterization database.  This is outside LibreLane.
2. **Digital control synthesis + integration** — LibreLane reads the selected
   digital library and the hard-macro LEF/Liberty/GDS, places the macro, and
   runs PDN/CTS/route/STA/DRC/LVS/antenna.
3. **Analog/mixed-signal verification** — ngspice/ISF and iverilog co-sim,
   outside LibreLane; the generator orchestrates both.
4. **Signoff per selected library** — all supported corners, DRC/LVS, IR/EM,
   DFT; the report is per PDK × library × core.

`flow/librelane/config.example.yaml` is a **skeleton**, not a guaranteed
LibreLane-version config.  Adapt the keys to the installed LibreLane and the
PDK's `libs.tech/librelane` config.

## Comparison, not automatic selection

The workflow is:

1. **Static screen** — `libraries.json` / `screening.json`.
2. **TT QoR sweep** — same RTL/core/constraints, one library at a time.
3. **Shortlist** — user reviews `compare/summary.csv` and
   `compare/comparison.md`.
4. **Full-corner run** — only the shortlisted combinations; Tier 2 flow per
   selected library.
5. **User selection** — `selection.json`; the generator writes the LibreLane
   config and runs the final signoff.

Suggested comparison fields: Fmax, jitter RMS, power, area, lock time,
WNS/TNS, DRC/LVS, antenna, IR/EM, DFT, runtime, cell count, utilization,
voltage/level-shifter needs, and hard-macro area/power.

## CI canaries

`flow/ci/canary.json` contains one smoke combination per PDK.  They are
**not** product defaults.  They answer only: "did the flow still run after the
last change?"  The product decision remains the user's selection.

## Next implementation steps

1. Attach DRC/LVS evidence per library and change `declared` to `pass` where
   justified.
2. For the reconstructed sky130 libraries, supply the missing physical-cell
   Liberty (fill/tap/decap/diode, lp busdriver/bushold) or confirm which are
   LEF-only in LibreLane; keep `pnr_ready=false` until then.
3. Extend the selection validator with corner cell-set consistency and
   mixed-voltage/level-shifter checks (the schema and same-voltage checks are
   in place).
4. Build the first hard macro for each Core A/B library, starting with the
   ics55 H7CR canary; the digital-only LibreLane canary is the current gate.
5. Run the TT library sweep and the full-corner shortlist.
6. Add the comparison collector (`compare/summary.csv`,
   `comparison.md`).
7. Add per-block mixed-voltage support only after same-voltage mixing is
   proven.

## Licensing

Do not copy code from unlicensed (Enanter, Tsai) or GPL (wwagner,
filipamator) repositories.  Use ideas and clean-room implementations.
ckdur is Apache-2.0 except `src/delta_sigma.v` ("No LICENSE yet"); resolve
that before redistribution.  The ics55 7T library is licensed; the private 9T
library is not required.
