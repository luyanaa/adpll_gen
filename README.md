# ADPLL Generator — Implementation and Characterization

This repository contains an all-digital PLL (ADPLL) generator, its standard-cell
mappings, hard-macro P&R lanes, library-screening experiments, and post-layout
characterization.  The project is intentionally multi-PDK: ics55, GF180mcu,
sky130, IHP SG13G2, and ETRI050.

The current status is **implementation characterization**, not a product
signoff.  Full analog DCO/PLL characterization (phase noise, injection range,
locked jitter, full-top power) has not been completed.

## 1. Architecture and parameterization

| Item | Value |
|---|---|
| Reference clock | 100 MHz nominal |
| Feedback ratio | `N = FCW` in the RTL (`pll_freq_lock`) |
| `FCW` width | 8 bits; valid `N = 1..255` |
| Output divider | `SET_DIV`, 8 bits; effective division `2..255` |
| DCO coarse/mid/fine | 15 / 15 / 31 thermometer delay units |
| Injection chain | 4 delay stages |
| Digital loop-filter target | 1 MHz cutoff |
| `LOCKED` wait | 64 `INJ_EDGE` cycles (0.64 µs at 100 MHz REF) |

Important: the RTL locks to `FCW` directly, while the deprecated
`src/dlf_design.py` uses `(FCW + 1 + alpha)`.  The RTL behavior is authoritative:
`FCW=15` is 15× and `FCW=16` is 16×.  This discrepancy must be resolved before
frequency planning.

The hard macro (`PLL_ANALOG_MACRO`) does **not** expose `FCW`, `SET_DIV`,
`OUT_DIV`, or `PLL_LOGIC`; it contains only the DCO/PDN/injection analog views.
Frequency-division characterization is therefore a full-top task.

Detailed parameter and limit analysis:

- `flow/ADPLL_FREQ_DIV.md`
- `flow/PERFORMANCE.md`
- `flow/PDK_ESTIMATES.md`

## 2. Implemented hard macros

| PDK | Library | Die (µm) | Area (mm²) | Components | P&R | DRC | LVS |
|---|---|---:|---:|---:|---|---|---|
| ics55 | `ics55_LLSC_H7CR` | 160 × 100 | 0.0160 | 1207 | complete | 0 top-level; 305 cell-internal waived, remaining 0 | **PASS** |
| GF180mcu | `gf180mcu_as_sc_mcu7t3v3` | 85.64 × 103.56 | 0.008869 | 452 (304 stdcells) | complete | **0** | **PASS** with fill-marker shim |
| sky130 | `sky130_as_sc_hs` | 80.21 × 90.93 | 0.007293 | 653 (517 stdcells) | complete | **0** | cell-subcircuit LVS open |
| sky130 | `sky130_fd_sc_hd` | 79.665 × 90.385 | 0.007200 | experimental | route/fill | **0** | cell-subcircuit LVS open |
| IHP SG13G2 | `sg13g2_stdcell` | 160 × 105 | 0.0168 | 805 | complete | **0** (density rules) | **PASS** on fill-stripped view |
| GF180mcu FD | `gf180mcu_fd_sc_mcu7t5v0` | — | — | 1588 synthesized | **DPL workaround PASS; route blocked at Via2** | — | — |
| ETRI050 12T | `ETRI050_fd_sc_12t` | 3050 × 3262 | 9.95 die / 1.521 instance | 2428 after P&R | **route/fill complete** | 636 deck markers | strict pin-map fail |

### 2.1 Post-layout timing

The macro constraints use `REF=20 ns`, `OUT/MID_OUT=2.5 ns`,
`INJ_EDGE=20 ns`; these are P&R planning constraints, not a 1.6 GHz signoff.

| PDK / library | Source | Setup slack | Hold slack | Power |
|---|---|---:|---:|---:|
| ics55 H7CR | OpenSTA + P&R SPEF | **+3.34 ns** | **+0.64 ns** | 47.9 µW* |
| GF180 AS 3.3 V | P&R timing report | **+0.487 ns** | **+0.306 ns** | not extracted |
| sky130 as_sc_hs | P&R timing report | **+2.463 ns** | **+0.158 ns** | not extracted |
| IHP SG13G2 | OpenSTA + P&R SPEF | **+2.35 ns** | **+0.65 ns** | 251 µW* |

`*` OpenSTA `report_power` with default activity; not vector-based and not a
power signoff.

The ics55 and IHP SPEF reads report many unmatched hierarchical instance/net
names in the assembled netlist.  The timing values are useful post-layout
evidence, but they are **not clean signoff STA** until the SPEF/netlist naming is
made consistent.

### 2.2 DRC/LVS details

- **ics55**: top-level DRC 0.  The 305 remaining KLayout items are all
  `7T-cell-internal`; `drc_waiver.json` records them and `waive_drc.py` refuses
  to waive any top-level item.  LVS passes with the flat reference.
- **GF180mcu**: KLayout DRC 0 after die shrink and marked metal fill.  LVS
  passes only with `check_ports=false` and the flow-local fill-marker
  exclusion; the unmodified deck sees floating fill nets.
- **sky130 `as_sc_hs`**: DRC 0.  PDN power-pin mapping was fixed
  (`VPWR/VPB` power, `VGND/VNB` ground), but LVS still fails on cell
  subcircuit pin/device comparison.
- **sky130 `fd_sc_hd`**: DRC 0.  Uses the full PDK CDL and
  `tapvpwrvgnd_1`; PDN PSM errors are gone, but KLayout LVS still fails at
  cell-subcircuit comparison.
- **IHP**: minimal-deck DRC 0 with density rules enabled; LVS passes on the
  fill-stripped `PLL_ANALOG_MACRO_lvs.gds`.
- **ETRI050**: no P&R signoff; see blockers below.

## 3. Digital-control canaries

These are `pll_logic` only, not the complete PLL.

| PDK / library | Cells | Area (µm²) | Corner | `REF` Fmax | `OUT` Fmax | `MID_OUT` Fmax | `INJ_EDGE` Fmax |
|---|---:|---:|---|---:|---:|---:|---:|
| ics55 H7CR | 1571 | 4321.8 | TT 1.2 V | 994.87 | **835.87** | 1002.43 | 452.09 |
| GF180 AS 3.3 V | 1690 | 49069.3 | SS 3.0 V | 163.53 | **196.37** | 306.87 | 96.70 |
| IHP SG13G2 | 1587 | 26243.2 | TT 1.2 V | 379.10 | **525.42** | 653.44 | 237.33 |
| ETRI050 12T | 1654 | 1,206,913.6 | TT 5 V | — | **~90 MHz** pre-layout | — | — |


Fmax is the OpenROAD `report_clock_min_period` value from the canary clock
report.  It is a digital-logic limit, not the analog DCO limit.

- **ics55** setup/hold 0 in its digital canary.
- **GF180** has no post-Route SPEF/STA; the SS clock report is the best
  available digital timing.  One r2r setup violation of -0.092 ns was reported
  at `ff/n40C/3.6 V`.
- **IHP** has TT power **5.62 mW** for the digital canary; SS setup is
  **-0.316 ns / TNS -2.534 ns** at nominal 2.5 ns `OUT`, while the 20 ns `REF`
  domain has about +11.15 ns margin.
- **ETRI050** is now **route/fill complete**: 2428 instances, 9.95 mm² die,
  1.521 mm² instance area, OpenROAD detailed-route DRC **0**.  Timing at
  20 ns `OUT` is still far from closed (setup **-158.85 ns**, hold
  **-16.73 ns**), KLayout DRC reports 636 NWL/NSD/PSD markers, and KLayout LVS
  fails on a strict top-level pin map.  This is a flow result, not signoff.

## 4. Post-PnR SDF smoke simulation

`sim/post_pnr` runs the ics55 gate-level P&R netlist with optional SDF:

| Case | Edges | Last period | Average period |
|---|---:|---:|---:|
| SDF annotated | 38 | 2284 ps | 4926 ps |
| No SDF | 52 | 5000 ps | 3568 ps |

The stimulus toggles `REF` every 5 ps to kick-start injection lock; it is not a
100 MHz system reference.  This is a smoke test, not a calibrated DCO period or
jitter measurement.  Icarus uses only the SDF file/instance arguments and
ignores corner selection.

## 5. Frequency envelope

Using the measured logic limits above:

```text
N = FCW, f_MID = N * f_REF
f_REF <= min(F_REF_domain, F_INJ_domain, f_MID_max/N)
f_MID <= min(F_MID_domain, F_DCO_analog)
```

Current evidence does **not** support a 1.6 GHz complete loop:

- ics55: `OUT` 836 MHz TT / 479 MHz SS; `REF` limited to ~452/244 MHz by
  `INJ_EDGE`
- GF180: `OUT` ~196 MHz SS / ~330 MHz TT pre-layout
- sky130: ~570 MHz pre-layout, no post-route digital canary
- IHP: 525 MHz TT / <400 MHz SS
- ETRI050: ~90 MHz pre-layout

For 100 MHz REF, ics55 `N=16` would require 1.6 GHz, above the current `OUT`
domain.  The current macro P&R at 2.5 ns `OUT` (400 MHz) is the closed timing
point, not 1.6 GHz.

## 6. Current blockers

### GF180 FD DPL

The original FD PDN caused 272/280 sequential cells to fail `DPL-0036`.
Rails-only PDN (`pdn_rails_only.tcl`) plus `WITH_POWER` makes DPL pass, but
detailed routing now stops at `DRT-0234 Via2 does not have single-cut via`.
The canary is therefore not routed, DRC/LVS-clean, or signed off.  The
underlying DPL issue is OpenROAD #11511; LibreLane 3.0.17 still binds the
2026-02-17 OpenROAD binary.

### sky130 LVS

Both sky130 lanes reach DRC 0, but neither has cell-subcircuit LVS closure:

- `as_sc_hs`: Magic-extracted cell CDLs produce finger/device mismatches.
- `fd_sc_hd`: complete PDK CDL exists, but KLayout still reports pin/device
  mismatches; `netgen` gets closer but top device counts differ.

A clean LVS cell view or an explicit blackbox flow is still required.

### ETRI050

- Core A originally lacked `nand2b`; the canary now maps `NAND2BX1`/`NOR2BX1`
  to NAND/NOR + INV.  Core B/C remain the full-cell configurations.
- A rails-only PDN lets route/fill finish, but it has no top-level VDD/VSS
  terminal; PSM reports `PSM-0038/0069` and the power checker is skipped.
- Timing at 20 ns `OUT` is not closed: setup -158.85 ns, hold -16.73 ns.
- No clean KLayout DRC/LVS: 636 NWL/NSD/PSD markers, and the LVS deck cannot
  build a strict top-level pin map.
- Only one TT/5 V/25 °C corner; no SS/FF or temperature model.
- 5 V, 0.5 µm, ~1.2 mm² synthesized digital area / 9.95 mm² die; not suitable
  for a high-frequency, area-sensitive ADPLL.

### Full PLL

The complete `pll` top has not been assembled with the hard macro and
digital-control views.  There is no full-top lock-time, jitter, phase-noise,
or power characterization yet.

## 7. Reproduce

```sh
# Library screening / synthesis matrix
python3 flow/experiments/synth_multi_lib.py

# Parameter sweep (FCW/DIV/NDELS, synthesis only)
python3 flow/experiments/param_sweep.py

# Post-layout macro STA
STA=/usr/bin/sta
$STA -exit flow/characterization/sta_ics55.tcl
$STA -exit flow/characterization/sta_ihp.tcl

# ETRI050 route/fill qualification
cd flow/canary/ETRI050_fd_sc_core_a
librelane --manual-pdk --pdk-root /grid --pdk ETRI050 \
  --scl ETRI050_fd_sc_12t \
  -S OpenROAD.CheckAntennas -S Checker.PowerGridViolations \
  -S Checker.DisconnectedPins -S OpenROAD.RepairDesignPostGPL \
  --to OpenROAD.DetailedRouting config.digital.yaml

# Post-PnR SDF smoke
ROOT=/opt/adpll_gen PDK_ROOT=/grid bash sim/post_pnr/run.sh
```

Machine-readable characterization data:

```text
flow/characterization/post_layout.json
```

Macro build and signoff commands are in each directory's `README.md`:

```text
flow/macro/ics55_h7cr/
flow/macro/gf180mcu/
flow/macro/sky130_as_sc_hs/
flow/macro/sky130_fd_sc_hd/
flow/macro/ihp130_sg13g2/
flow/canary/gf180mcu_fd_core_a/
flow/canary/ETRI050_fd_sc_core_a/
```

## 8. What is not characterized

- DCO measured frequency, tuning range, monotonicity
- Injection lock range, lock time, false-lock behavior
- DCO phase noise / ISF analysis
- Full ADPLL RMS jitter and integrated phase noise
- Full-top power, area, lock time, BER
- Package/board/PDN signoff
- Foundry-qualified DRC/LVS for GF180, sky130, IHP, or ETRI050

Generated GDS/OASIS, SPEF/SDF, extracted SPICE, run directories, and signoff
databases are intentionally excluded from git (see `flow/.gitignore`); the
configuration, scripts, reports that are small, and characterization tables
needed to reproduce them are tracked.
