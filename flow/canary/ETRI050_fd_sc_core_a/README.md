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
| KLayout DRC (PDK deck) | **636 markers before fill**; 2 after `finish_etri.sh` (1 NSD + 1 PSD) |
| KLayout LVS | top-pin label remap attempted; hierarchical stdcell pin mapping still fails |

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
- LVS labels are written on 13/1 but the ETRI deck reads 42/44/46.  The
  local streamout remaps top pin text to 42/44/46 and drops the LEF pin
  abstracts from DRC, but the extracted top still exposes only VDD/VSS and
  hierarchical `NAND2X1` exposes supply/bulk pins rather than A/B/Y.  A
  flat or black-box cell LVS comparison is still required.
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
  `6.PSD.S1` 103.  After `FILLX1..4`, only 2 remain (1 NSD, 1 PSD).  The
  12T GDS has a 1.3/1.4 µm halo beyond the LEF; the PDK `ACCEPTANCE.md`
  excludes the 12T library from its acceptance gate.
- **LVS:** the DEF→GDS top pin texts are on layer 13/1, but the ETRI deck reads
  labels from 42/44/46.  The local streamout now remaps pin labels and drops
  the LEF pin abstracts; the remaining failure is hierarchical stdcell pin
  naming, not the top-level labels alone.
- A clean 12T GDS/LEF or a patched label/tap flow is required before claiming
  DRC/LVS signoff.

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
