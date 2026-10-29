# ihp130 SG13G2 (1.2 V) + Core A canary

First canary for the ADPLL flow on **IHP SG13G2 / `sg13g2_stdcell` (1.2 V) /
Core A (IL-DCO)**.  It answers two questions:

1. Does the digital control (`pll_logic`) synthesize against the IHP 1.2 V
   standard-cell library?
2. Can the OpenROAD-based LibreLane flow place, route and time it with the
   views available in this environment?

Everything here is new and self-contained.  No file outside this directory
was modified.  The `PLL_ANALOG` hard macro is **not built**; no timing/DRC/LVS
signoff claim is made.

## Status (exact)

| Item | Status |
|---|---|
| Yosys synthesis of `pll_logic` -> `sg13g2_stdcell` | **PASS** (TT / 1.20 V / 25 C, Yosys 0.52): 1587 cells, 26 243.18 um² |
| Full `pll` top elaboration vs `PLL_ANALOG_blackbox.v` | **PASS** (`hierarchy -check -top pll`, no errors) |
| LibreLane v3.0.16 digital PnR | **LAYOUT COMPLETE, TIMING CHECK FAILED**: floorplan, placement, CTS, detailed route (0 DRC), fill, RCX, 3-corner post-PnR STA, IR drop and KLayout GDS all ran. LibreLane exits non-zero (`make` reports Error 2) at `Checker.SetupViolations`: 10 setup paths fail at `nom_ss_125C_1v08`, worst slack **-0.316 ns**, TNS **-2.534 ns**. |
| KLayout DRC / LVS / antenna | **NOT RUN / NOT CLAIMED** — official IHP signoff decks are not installed; those steps are disabled. |
| `PLL_ANALOG` hard macro | **NOT BUILT** — no GDS/LEF/Liberty/CDL/SPICE |
| `config.macro.yaml` (full `pll` top) | **SKELETON ONLY — cannot run until the macro views exist** |
| Full IHP PDK root (`libs.tech/librelane`) | **ABSENT** — a local minimal root is assembled from ORFS views; see below |

Tool versions in this environment: standalone `yosys` 0.52; LibreLane
v3.0.16 at
`/nix/store/ilpnqwsl6gvk6kvavkaljbnzaz3086fd-python3.13-librelane-3.0.16/bin/librelane`
(not in `PATH`); its bundled Yosys is 0.62 and OpenROAD is the
`openroad-2026-02-17` build.  KLayout and netgen are on `PATH`.

## Library note (important)

The library used here is **`sg13g2_stdcell`, the 1.2 V core library shipped
with OpenROAD-flow-scripts**:

```text
/opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2
```

It is **not yet a row in `flow/libraries.json`**.  That catalogue only
enumerates `/grid/<pdk>` roots, where the IHP rows are:

- `sg13g2_stdcell_hv` — 3.3 V HV cells (**not used**),
- `ez130_8t_v1p1` — 1.2 V alternative (**not used**),
- `glow_sg13g2` — not usable.

`library_manifest.yaml` records the actual row (views, corners, site, cell
counts) so this canary is reproducible without editing the shared catalogue.
The three Liberty files contain the **same 84 cell names** (checked
2026-10-29), unlike the ics55 H7CR set that had a corner-specific missing
cell.

The 3.3 V HV library is intentionally **not mixed** into this run: it would
need level shifters/UPF and a different supply interface.

## Proven

### 1. Yosys synthesis (`make synth-digital`)

```sh
yosys -s build/yosys/synth_digital.generated.ys
# source: scripts/synth_digital.ys
```

RTL list (same as the ics55 canary):

```text
src/pll_logic.v
src/digital_loop_filter.v
src/term_decoder.v
src/freq_lock.v
src/delta_sigma.v
src/fix_div.v
src/conf_div.v
```

Liberty: `/opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2/lib/sg13g2_stdcell_typ_1p20V_25C.lib`

Result (`build/yosys/stat.rpt`, `build/yosys/yosys.log`):

```text
Number of cells:                1587
  sequential:                    280   (sg13g2_dfrbpq_1 280)
  combinational:                1307   (includes 10 tie cells:
                                        sg13g2_tiehi 8, sg13g2_tielo 2)
Chip area (Liberty area):  26243.1792 um^2
Sequential area:           13716.8640 um^2 (52.27 %)
```

- 0 errors, 0 unmapped internal cells (`$...`) in the final netlist.
- The only log warning is the benign ABC message
  `The network is combinational (run "fraig" or "fraig_sweep")`.
- `hilomap` used `sg13g2_tiehi/L_HI` and `sg13g2_tielo/L_LO`, so the netlist
  has no `$false`/`$true` sources.
- The full `pll` top also elaborates against
  `hardmacro/PLL_ANALOG_blackbox.v` with `hierarchy -check -top pll`
  (no errors/warnings).  It was not mapped because there is no macro Liberty.

### 2. LibreLane digital layout (`make librelane-digital`)

Command:

```sh
librelane --manual-pdk --pdk-root build/pdk_root \
          --pdk ihp-sg13g2 --scl sg13g2_stdcell \
          --skip Odb.CheckDesignAntennaProperties \
          --skip Magic.SpiceExtraction \
          --skip Checker.IllegalOverlap \
          config.digital.yaml
```

Final run: `runs/RUN_2026-10-29_01-43-42/`

The flow reached the last stage (`Misc.ReportManufacturability`, stage 63)
and wrote final views, then exited non-zero because the setup checker found
violations.  Layout results:

| Metric | Value |
|---|---|
| Standard-cell instances after PnR (incl. CTS/repair/fill) | 1932 stdcells + 4422 fill = 6354 |
| Sequential cells | 280 |
| Core / die area | 74 593.6 / 87 070.2 um² (die bbox 285.865 x 304.585 um) |
| Detailed-routing DRC (`route__drc_errors`) | **0** |
| Routed wirelength | 49 599 um |
| Hold WNS (worst of 3 corners) | **+0.1248 ns**, TNS 0 |
| Setup WNS | TT **+0.6217 ns**, FF **+1.1450 ns**, SS **-0.3160 ns** |
| Setup TNS | SS **-2.5344 ns**, 10 violating paths |
| IR drop (VDD, TT) | worst 3.35 mV = **0.28 %**; no disconnected shapes |
| Total power (TT) | 5.62 mW |
| Final GDS | `runs/RUN_2026-10-29_01-43-42/final/gds/pll_logic.gds` (1.8 MB); parses in KLayout with top cell `pll_logic` (51 cells, 29 layers) |

The GDS read-back above is a structural check only, not a DRC/LVS check.

The failing paths are **inside the nominal `OUT` 2.5 ns (400 MHz) domain**
(example: `_2816_ -> _2559_`, both clocked by `OUT`).  The `REF` 20 ns domain
has **+11.15 ns** margin at the same corner.  In other words:

- the digital control meets the intended 50 MHz reference domain;
- the SS failure is caused by the **canary's nominal 2.5 ns DCO-rate clock
  assumption** (`OUT`/`MID_OUT` = 8 x REF), not by a measured DCO period.

This is a real timing result.  It was **not** hidden by loosening the clock or
skipping the checker.  To make the canary green, either relax the nominal
`OUT`/`MID_OUT` period once the DCO range is characterized, or close timing at
2.5 ns in the digital backend.  Do not report the current run as timing-clean.

LibreLane's own synthesis (Yosys 0.62, its default recipe) reports 1578
instances / 26 341.76 um², slightly different from the standalone Yosys 0.52
result above.  Both are cell-mapped; the difference is tool version/recipe,
not a mapping failure.

### Attempt history (all in this environment)

| Run | Result |
|---|---|
| `runs/RUN_2026-10-29_01-11-35` | config-load + `-T Yosys.Synthesis`; 1578 cells, no flow beyond synthesis |
| `runs/RUN_2026-10-29_01-12-21` | full flow reached `Magic.StreamOut`; failed because no magic tech exists (LEF layer errors, 585 DEF read errors) |
| `runs/RUN_2026-10-29_01-27-48` | `RUN_MAGIC_STREAMOUT: false`; KLayout GDS written, then failed at `Odb.CheckDesignAntennaProperties` ("missing required input 'lef'") because Magic.WriteLEF was also disabled |
| `runs/RUN_2026-10-29_01-43-42` | with the three dependent steps skipped: layout/GDS/STA/IR-drop complete; exits on 10 SS setup violations |

## PDK root / LibreLane setup (what is real and what is local)

The full IHP PDK root is **not installed**.  There is no
`/opt/ext/OpenPDKs`, and nothing on this machine provides
`<PDK_ROOT>/ihp-sg13g2/libs.tech/librelane`.  LibreLane therefore cannot use
an official IHP integration here.

`make pdk-root` assembles a **local, minimal** root under `build/pdk_root/`
(git-ignored):

```text
build/pdk_root/ihp-sg13g2/
  libs.ref/sg13g2_stdcell/
    lib       -> /opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2/lib
    lef       -> .../lef
    gds       -> .../gds
    cdl       -> .../cdl
    verilog   -> .../verilog
    rcx/IHP_rcx_patterns.rules -> .../rcx_patterns.rules
  libs.tech/librelane -> <canary>/pdk/ihp-sg13g2/libs.tech/librelane
  libs.tech/klayout/tech/{sg13g2.lyt,lyp,map} -> ORFS files
  platform -> <ORFS platform>
```

The `libs.tech/librelane` content is **authored in this repository**
(`pdk/ihp-sg13g2/libs.tech/librelane/`).  It is a bring-up config, not the
official IHP PDK config.  It sets the three ORFS corners, the 1.2 V cells,
Metal2-Metal5 routing, CoreSite (0.48 x 3.78 um), the ORFS PDN values, and
`/dev/null` placeholders for the missing magic/netgen setup.

To use the official PDK instead, install/point at a root with this layout and
delete the local assembly:

```text
<PDK_ROOT>/ihp-sg13g2/
  libs.ref/sg13g2_stdcell/{lib,lef,gds,cdl,verilog}
  libs.tech/librelane/config.tcl
  libs.tech/librelane/sg13g2_stdcell/config.tcl
  libs.tech/klayout/...        (tech + DRC decks)
  libs.tech/drc/...            (KLayout DRC runsets)
  libs.tech/lvs/...            (KLayout/netgen LVS)
  libs.tech/netgen/...         (netgen setup)
  libs.tech/magic/...          (magic tech, if Magic signoff is used)
```

## Not proven / blockers

1. **Setup is not closed.**  10 SS paths fail by up to 0.316 ns under the
   nominal 2.5 ns `OUT`/`MID_OUT` assumption.  LibreLane exits non-zero
   (`make` reports Error 2) on `Checker.SetupViolations`.  This is the exact
   current status.
2. **No DRC, LVS or antenna signoff.**  KLayout DRC, netgen LVS, Magic
   DRC/streamout and the antenna-property checks are disabled or skipped
   because the official IHP decks are absent.  The IR-drop report ran
   (0.28 % worst drop) but is not an EM/IR signoff.  The
   `route__drc_errors = 0` number is OpenROAD detailed-routing DRC only.
3. **`PLL_ANALOG` does not exist.**  `hardmacro/PLL_ANALOG.{gds,lef,lib}` and
   the CDL/SPICE views are expected, not built.  `config.macro.yaml` cannot
   run.  `SS_BBPD` -> digital timing is completely unconstrained until the
   macro has a Liberty model.
4. **Internally generated clocks are not declared.**  `CKR` (a flop retiming
   REF into the `MID_OUT` domain) and `DSM_CK` (`MID_OUT / DSM_DIV`) are used
   as clocks inside `pll_logic`.  They are not in `constraints/adpll.sdc`
   because their hierarchical names are not stable before synthesis/CTS.  A
   timing claim without them is incomplete.
5. **Only the 1.2 V library is used.**  No 3.3 V IO/HV cells, no level
   shifters, no padframe.  This is a core digital canary.
6. **The local PDK root is not the IHP PDK.**  It is a symlink assembly plus
   a minimal config; the official `libs.tech/librelane` and signoff decks are
   still missing.
7. **The analog macro build (ckdur flow) has not been run** for IHP.  The
   interface and manifest are contracts, not results.

## Commands

```sh
cd /opt/adpll_gen/flow/canary/ihp130_sg13g2_core_a

make synth-digital       # Yosys 0.52 -> build/yosys/{pll_logic_net.v,stat.rpt,yosys.log}
make pdk-root            # assemble build/pdk_root/ihp-sg13g2 from ORFS + local config
make librelane-digital   # full LibreLane digital run (needs the Nix-store librelane)
make librelane-macro     # blocked until hardmacro/PLL_ANALOG.{gds,lef,lib} exist
make clean               # remove build/
```

Overrides: `ORFS_PLATFORM`, `SRC_DIR`, `SG13G2_LIB`, `YOSYS`, `LIBRELANE`,
`PDK_ROOT`, `PDK`, `SCL`.  No container image is assumed.

`make librelane-digital` sets `LIBRELANE` to the Nix-store v3.0.16 binary if
it exists; otherwise it uses `librelane` from `PATH`.

## Files

```text
README.md                         this file
Makefile                          synth / pdk-root / librelane targets
config.digital.yaml               LibreLane v3.0.16 digital-only config
config.macro.yaml                 full-pll + PLL_ANALOG skeleton (not runnable)
library_manifest.yaml             local record of the ORFS sg13g2_stdcell row
constraints/adpll.sdc             canary SDC (4 clocks, macro paths open)
hardmacro/PLL_ANALOG_blackbox.v   elaboration stub (matches src/pll.v)
hardmacro/interface.md            macro contract
hardmacro/manifest.yaml           machine-readable macro contract
scripts/synth_digital.ys          Yosys script (standalone proof)
scripts/run_canary.sh             target driver + blockers
scripts/assemble_pdk_root.sh      local minimal PDK-root assembly
pdk/ihp-sg13g2/libs.tech/librelane/{config.tcl,sg13g2_stdcell/...}
                                  locally authored minimal LibreLane PDK config
runs/RUN_2026-10-29_01-43-42/     latest LibreLane run (GDS/DEF/SPEF/SDF/logs)
build/                            Yosys outputs + assembled PDK root (git-ignored)
```

## Open items (next steps)

1. Characterize the DCO range; replace the nominal 2.5 ns `OUT`/`MID_OUT`
   periods (or close timing at 2.5 ns if that is the real target).
2. Declare `CKR` and `DSM_CK` as generated clocks after CTS names are stable.
3. Build/characterize `PLL_ANALOG`, then run `make librelane-macro`.
4. Install the official IHP PDK root (or the missing `libs.tech` collateral)
   to enable KLayout DRC/LVS, netgen LVS and antenna signoff.
5. Add `sg13g2_stdcell` (ORFS 1.2 V) as a row in `flow/libraries.json`,
   including the `core_a_il_dco` support check, so the shared catalogue sees
   the library this canary actually uses.
