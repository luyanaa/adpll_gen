# gf180mcu OpenPDK FD Core A canary (experiment)

This lane tests the `~/.ciel` OpenPDK default `gf180mcu_fd_sc_mcu7t5v0`
(5 V, 7-track, **3-metal** FD library) with the same `pll_logic` RTL.

## Status

| Item | Result |
|---|---|
| Synthesis | **PASS** — 1588 cells, 44,167 µm² |
| PDN workaround | **PASS for DPL** — rails-only PDN (`pdn_rails_only.tcl`) + `WITH_POWER` |
| Detailed placement | **PASS after PDN workaround** — the previous `DPL-0036` 272/280 failure is gone |
| Detailed routing | **FAIL** — `DRT-0234 Via2 does not have single-cut via` |
| DRC / LVS / GDS / STA | not reached |

This is a recorded experiment, not a passed P&R canary.  The completed P&R
evidence remains `/grid` `gf180mcu_as_sc_mcu7t3v3`, ics55 H7CR, IHP sg13g2 and
the sky130 `as_sc_hs` macro.

## Why the config differs from the AS canary

- `gf180mcu_fd_sc_mcu7t5v0` is a **3-metal** library: only
  `Metal1/Metal2/Metal3` exist.  `tracks_3m.info` removes the PDK's stale
  `Metal4/Metal5` track entries.
- `PDN_HORIZONTAL_LAYER` is `Metal3`; its minimum width is 2.2 µm, so
  `PDN_HWIDTH`/`PDN_HSPACING` are 2.2 µm.
- `WELLTAP_CELL` is `__filltie` and `ENDCAP_CELL` is `__endcap`; this FD
  library has no `tap_1` cell.
- `DEFAULT_CORNER` must be explicit because this SCL config does not set it.
- The design uses a local `pdk_overlay/gf180mcu` with `libs.ref` and the SCL
  `libs.tech/librelane` symlinked to the CIEL `gf180mcuA` tree.  This avoids
  the CIEL top-level RCX path that does not exist.
- **DPL workaround:** `PDN_CFG: dir::pdn_rails_only.tcl` replaces the
  M1/M2/M3 via-stack PDN with rails only; `VERILOG_DEFINES: [WITH_POWER]`
  exposes VDD/VSS.  This avoids the DPL blocked-via-pin failure but is not a
  power-signoff PDN.

## Run

```sh
cd flow/canary/gf180mcu_fd_core_a
LIBRELANE=/nix/store/abmh7jj4bkf725p7rrrr98r9ax077v6d-python3.13-librelane-3.0.17/bin/librelane
$LIBRELANE --manual-pdk --pdk-root "$PWD/pdk_overlay" \
  --pdk gf180mcu --scl gf180mcu_fd_sc_mcu7t5v0 \
  -S Magic.StreamOut -S KLayout.StreamOut -S KLayout.Render \
  -S Magic.WriteLEF -S Odb.CheckDesignAntennaProperties \
  -S KLayout.XOR -S Checker.XOR -S Magic.DRC -S KLayout.DRC \
  -S Checker.MagicDRC -S Checker.KLayoutDRC -S Magic.SpiceExtraction \
  -S Netgen.LVS -S Checker.LVS -S OpenROAD.RCX -S OpenROAD.STAPostPNR \
  -S OpenROAD.IRDropReport -S Checker.SetupViolations \
  -S Checker.HoldViolations -S Checker.MaxSlewViolations \
  -S Checker.MaxCapViolations -S OpenROAD.RepairDesignPostGPL \
  -S Checker.PowerGridViolations -S Checker.DisconnectedPins \
  config.digital.yaml
```

## DPL-0036 diagnosis

The failure is **specific to the sequential cells**, not PDN or tap cells:

- 272 of 280 DFFs are reported as placement failures.
- Every failing DFF overlaps a fixed tap cell in the GPL result (run with taps);
  however, the same 272 failures occur with `OpenROAD.TapEndCapInsertion`
  skipped, so the tap overlap is not the root cause.
- Snapping all cells to the 0.56 × 3.92 µm site/row grid, setting the row
  orientation, lowering the target density, and even hand-packing all cells
  into legal rows does not change the 272 count.
- The same failure appears with `gf180mcu_fd_sc_mcu9t5v0` (9-track FD), so it
  is not unique to the 7-track library.

This matches OpenROAD issue 11511 (`dpl: check pin shapes against power via
metal geometrically`): the older DPL marks a full site/row blocked when a cell
has a pin on a via-stack metal layer.  FD DFFs have wide M2 pin shapes under
the PDN via stack, so all 280 sequential cells are rejected.  The issue is
closed with an orientation-aware pin-geometry check.  Rechecked with LibreLane
3.0.17: its `nix-store` references still resolve to the same OpenROAD
`2026-02-17` binary, and the FD run still fails with 272/280 DPL failures.
The bundled OpenROAD therefore still does not contain the fix.

### Current PDN workaround result

`pdn_rails_only.tcl` removes the M1/M2/M3 via stacks, and DPL now completes.
The next failure is in detailed routing:

```text
[DRT-0234] Via2 does not have single-cut via
```

So the DPL blocker is worked around, but the FD canary still needs a
via2/single-cut route rule fix or a 2-metal routing experiment.  The current
canary remains non-signoff.

## Next

1. Fix the `DRT-0234` via2 route rule (or route with a technology LEF that
   defines a single-cut via2).
2. Do not reuse the AS 4/5-metal PDN assumptions for FD parts.
