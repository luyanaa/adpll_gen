# ETRI050 Core A digital canary

This is the first full route attempt for the Core A digital control on
`ETRI050_fd_sc_12t` (0.5 µm, 2P3M, 5 V).  It is a **flow qualification**
result, not a timing-signoff result.

## Result

| Item | Value |
|---|---|
| Synthesis / mapping | **PASS** — 1654 synthesized cells |
| Cell mapping | `PLL_CELL_*` wrappers with `nand2b/nor2b` built from NAND2/NOR2 + INV |
| P&R | **route complete; fill missing in the archived run** — 2428 instances; 16,305 filler cells were added by `finish_etri.sh` |
| Die | 3050.35 × 3261.55 µm = **9.95 mm²** |
| Instance area | 1.521 mm² |
| OpenROAD detailed-route DRC | **0** |
| Timing @ 20 ns `OUT` | setup **-158.85 ns**, hold **-16.73 ns**; not closed |
| KLayout DRC (PDK deck) | **not clean**: 2 well/implant markers plus VIA1/VIA2 enclosure and via-stack errors (see below) |
| KLayout LVS | **PASS** — 2428 cell instances, 127 top pins (KLayout 0.30.0) |

## What worked

- `VERILOG_DEFINES: [WITH_POWER]` exposes VDD/VSS in `pll_logic`.
- `PDN_CFG=/grid/ETRI050/libs.tech/librelane/pdn_rails_only.tcl` lets PDN
  generation, placement, CTS and detailed routing complete.
- `OpenROAD.RepairDesignPostGPL` is skipped because this library/PDN pair makes
  `repair_design` fail; route remains DRC-clean.
- `klayout_check_local.sh` adds the cell LEF to `macro_layout_files`; the PDK
  script omits it, which otherwise causes “Macro not found in LEF” warnings.

## Why this is not a completed PnR/signoff

The route itself completed: detailed routing converged to 0 OpenROAD route DRC
errors and the DEF/GDS/CDL were emitted.  The archived flow stopped at
`--to OpenROAD.DetailedRouting`, before `OpenROAD.FillInsertion`; it was never
a full signoff run.

Continuing would still fail for independent reasons:

- The 12T GDS extends 1.3–1.4 µm beyond the LEF at cell boundaries.  Empty
  placement sites therefore produce the original 636 NWL/NSD/PSD markers;
  adding the vendor `FILLX` cells removes 634 of them.  The PDK's
  `ACCEPTANCE.md` still excludes this library from its acceptance gate.
- The archived route left every empty site unfilled.  Because the 12T GDS has
  a 1.3–1.4 µm NW/NSD/PSD halo, the gaps produced 636 markers.  Running
  `finish_etri.sh` (OpenROAD `filler_placement` with `FILLX1..4`) reduces the
  vendor DRC to **1 NSD + 1 PSD marker**; a normal rerun with
  `RUN_FILL_INSERTION` must include fill before DRC.
- The rails-only PDN has no top-level VDD/VSS terminal (`PSM-0038/0069`);
  adding MET2/MET3 straps makes placement/repair fail.
- LVS is now closed in KLayout; see “KLayout LVS closure” below.  Calibre
  LVS was not run because Calibre is unavailable in this environment.  This
  is not a Calibre signoff.
- Timing is not close at 20 ns: unpadded setup -158.85 ns / hold -16.73 ns;
  the padded final metrics are worse (setup -342.957 ns / hold -14.575 ns).
  Critical path is ~179 ns, and there is only one TT/5 V/25 °C corner.

So this is a **route-qualified, signoff-incomplete** result, not a route
failure.

## Remaining blockers

- **Timing:** 20 ns gives setup -158.85 ns / hold -16.73 ns.  The critical path
  is about 179 ns, so ~200–250 ns closes setup only; hold does not improve with
  a slower clock and is still about -16.7 ns.  The library has one
  TT/5 V/25 °C corner and no temperature model.
- **PDN:** rails-only has no top-level VDD/VSS terminal; PSM reports
  `PSM-0038/PSM-0069`; power checker is skipped.
- **DRC:** before fill, the 636 markers were cell-boundary context, not
  top-level route: `1.NWL.S.2` 267, `1.NWL.S.1` 156, `5.NSD.S1` 110,
  `6.PSD.S1` 103.  After `FILLX1..4`, 2 remain (1 NSD, 1 PSD).  In addition,
  restoring the real top-level MET1/2/3 routing exposes the via macros:
  `9.VIA1.E1/E3` (8047/8831), `11.VIA2.E1/E3` (4177/4927),
  `11.VIA2.S` (302) and `11.VIA2.S_Stack` (1171).  The fixed LEF
  `VIA V12/V23` macros put 1.2 µm metal around a 0.8 µm cut (0.2 µm
  enclosure), while the vendor deck requires 0.6 µm; the stack errors are
  stacked VIA2-on-VIA1 placements.  These are real P&R/via-macro issues, not
  label remap issues.
- **LVS:** KLayout LVS passes; Calibre LVS remains unrun.  The old Netgen
  “551 vs 2428” observation was from the period when top MET2/MET3 routing
  was accidentally deleted; it is not the current state.

## KLayout LVS closure

The failing path was not a single label bug.  The KLayout deck and the
DEF→GDS streamout had several Calibre-semantics mismatches:

1. Top pin text was copied onto all three text layers, creating duplicate
   pins (`VDD` and `VDD$1`).  Each pin label is now moved one-to-one:
   `9/1→42`, `11/1→44`, `13/1→46`.
2. KLayout maps DEF MET1/2/3 routes to `9/0`, `11/0`, `13/0`.  Clearing those
   layers deleted the real top routing.  They are now preserved and remapped
   to `32/34/36`; pin abstracts `9/2`, `11/2`, `13/2` map to the same metal.
3. The LEF VIA macros use layer ordinals `9→MET1`, `10→VIA1`, `11→MET2` and
   `11→MET2`, `12→VIA2`, `13→MET3`.  The previous V12 map was shifted and
   produced widespread MET2/MET3 DRC errors.
4. `etri_05um.lvs` wrote numeric pin names.  It now uses
   `spice_writer.use_net_names = true`.
5. The routed top CDL only instantiates standard cells.  The runner appends
   the vendor `ETRI050_fd_sc_12t.cdl`; otherwise KLayout treats each cell as
   an implicit black box with numeric pins.
6. In deep mode KLayout does not carry the contacted PTAP/NTAP connection
   into a parent cell.  MOS bulk now uses `tB => PTAP/NTAP` plus
   `connect_global(PTAP, VSS)` / `connect_global(NTAP, VDD)`, matching the
   vendor `SCONNECT ... BY CONT` intent for this single-supply core.
7. Multi-finger cells are emitted as parallel MOS devices by the extractor,
   while the vendor CDL uses `m=N`.  `netlist.combine_devices` reconciles
   them.
8. Symmetric gate inputs (`A/B`, `C/D`, and NAND/NOR/XOR/XNOR inputs) are
   declared with `equivalent_pins`; OAI21/AOI21 extraction is otherwise
   topologically swapped against the CDL.
9. One-pin VIA macro instances are flattened into the top cell before deep
   LVS; the standard cells remain hierarchical.

The versioned deck is
`flow/canary/ETRI050_fd_sc_core_a/etri_05um.lvs`; the runner uses it instead
of the mutable PDK copy when present.

## Reproduce

```sh
cd flow/canary/ETRI050_fd_sc_core_a
librelane --manual-pdk --pdk-root /grid --pdk ETRI050 \
  --scl ETRI050_fd_sc_12t \
  -S OpenROAD.CheckAntennas -S Checker.PowerGridViolations \
  -S Checker.DisconnectedPins -S OpenROAD.RepairDesignPostGPL \
  --to OpenROAD.FillInsertion config.digital.yaml
```

To finish the existing routed ODB without rerunning placement/route:

```sh
OPENROAD=/nix/store/2y36a4sr078y15ick388dncqjdzmlxga-openroad-2026-02-17/bin/openroad \
  ./finish_etri.sh
```

This writes `final/etri_filled/` with the filled DEF/GDS/DRC/LVS.  The
generated DEF/GDS/CDL and `final/metrics_unpadded.json` are local artifacts
and are excluded from git.
