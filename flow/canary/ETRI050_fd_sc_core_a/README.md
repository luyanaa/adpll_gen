# ETRI050 Core A digital canary

This is the first full route attempt for the Core A digital control on
`ETRI050_fd_sc_12t` (0.5 µm, 2P3M, 5 V).  It is a **flow qualification**
result, not a timing-signoff result.

## Result

| Item | Value |
|---|---|
| Synthesis / mapping | **PASS** — 1654 synthesized cells |
| Cell mapping | `PLL_CELL_*` wrappers with `nand2b/nor2b` built from NAND2/NOR2 + INV |
| P&R | **route/fill complete** — 2428 instances after P&R |
| Die | 3050.35 × 3261.55 µm = **9.95 mm²** |
| Instance area | 1.521 mm² |
| OpenROAD detailed-route DRC | **0** |
| Timing @ 20 ns `OUT` | setup **-158.85 ns**, hold **-16.73 ns**; not closed |
| KLayout DRC (PDK deck) | **636 markers** (NWL/NSD/PSD categories) |
| KLayout LVS | strict top-level pin mapping fails |

## What worked

- `VERILOG_DEFINES: [WITH_POWER]` exposes VDD/VSS in `pll_logic`.
- `PDN_CFG=/grid/ETRI050/libs.tech/librelane/pdn_rails_only.tcl` lets PDN
  generation, placement, CTS and detailed routing complete.
- `OpenROAD.RepairDesignPostGPL` is skipped because this library/PDN pair makes
  `repair_design` fail; route remains DRC-clean.
- `klayout_check_local.sh` adds the cell LEF to `macro_layout_files`; the PDK
  script omits it, which otherwise causes “Macro not found in LEF” warnings.

## Remaining blockers

- **Timing:** 20 ns gives setup -158.85 ns / hold -16.73 ns.  The critical path
  is about 179 ns, so ~200–250 ns closes setup only; hold does not improve with
  a slower clock and is still about -16.7 ns.  The library has one
  TT/5 V/25 °C corner and no temperature model.
- **PDN:** rails-only has no top-level VDD/VSS terminal; PSM reports
  `PSM-0038/PSM-0069`; power checker is skipped.
- **DRC:** the 636 markers are cell-boundary context, not top-level route:
  `1.NWL.S.2` 267, `1.NWL.S.1` 156, `5.NSD.S1` 110, `6.PSD.S1` 103.  The 12T
  GDS has a 1.3/1.4 µm halo beyond the LEF, so abutted cells violate
  NW/NSD/PSD spacing.  The PDK `ACCEPTANCE.md` excludes the 12T library from
  its acceptance gate.
- **LVS:** the DEF→GDS top pin texts are on layer 13/1, but the ETRI deck reads
  labels from 42/44/46; the extracted `.SUBCKT pll_logic` therefore has no pin
  list.  In addition all 26 stdcell subcircuits fail because the extracted
  bulk/tap nodes are not merged into VDD/VSS.
- A clean 12T GDS/LEF or a patched label/tap flow is required before claiming
  DRC/LVS signoff.

## Reproduce

```sh
cd flow/canary/ETRI050_fd_sc_core_a
librelane --manual-pdk --pdk-root /grid --pdk ETRI050 \
  --scl ETRI050_fd_sc_12t \
  -S OpenROAD.CheckAntennas -S Checker.PowerGridViolations \
  -S Checker.DisconnectedPins -S OpenROAD.RepairDesignPostGPL \
  --to OpenROAD.DetailedRouting config.digital.yaml
```

The generated DEF/GDS/CDL and `final/metrics_unpadded.json` are local artifacts
and are excluded from git.
