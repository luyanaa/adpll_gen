# gf180mcuD FD Core A canary

This lane tests the wafer-space `gf180mcuD` PDK with
`gf180mcu_fd_sc_mcu7t5v0` (5 V, 7-track, **5-metal** FD library) and the same
`pll_logic` RTL.  It is the digital-only canary, not the complete PLL.

## Status

| Item | Result |
|---|---|
| Synthesis | **PASS** — 1588 cells, 44,167 µm² |
| Floorplan / PDN / placement / CTS / route | **PASS** |
| Detailed-route DRC | **0** — 11,180 single-cut vias, 0 multi-cut |
| GDS streamout | **PASS** — Magic and KLayout |
| Magic DRC | **0** |
| KLayout DRC | **0** (full `gf180mcuD` deck) |
| LVS | **PASS** (Netgen) |
| Antenna | **PASS** — 0 violating nets/pins |
| Die / standard-cell area | 483.375 × 501.295 µm, 0.2423 mm²; 61,410.7 µm² stdcell; 28.0% utilization |
| Instances | 1,790 standard cells + 1,393 tap + 238 endcap + 5,720 fill (9,141 total) |
| Post-route power | 35.3 mW (default activity) |
| IR drop | 7.01 mV worst, 1.08 mV average at 5.0 V |

The run is a complete Classic-flow P&R and DRC/LVS/antenna signoff.  Timing is
reported below; it is **not** a complete ADPLL characterization.

### 9-track FD variant

`config.digital_gf180mcuD_9t.yaml` repeats the same flow with
`gf180mcu_fd_sc_mcu9t5v0`.  It also completes 80/80:

| Item | 9-track result |
|---|---|
| Die / area | 534.455 × 561.335 µm / 0.300008 mm² |
| Stdcell area / utilization | 77,381.7 µm² / 28.6% |
| Route DRC | 0; 11,121 single-cut vias, 0 multi-cut |
| Magic / KLayout DRC | 0 / 0 |
| Netgen LVS / antenna | PASS / PASS |
| Setup WNS | **+0.752 ns TT / -2.646 ns SS / +2.219 ns FF** |
| Hold WNS | +0.396 / +0.732 / +0.249 ns |
| Power / IR | 43.3 mW default activity / 6.78 mV worst |
| Instances | 1,744 standard cells + 1,367 tap + 206 endcap + 5,198 fill |

At 20 ns the TT corner passes and SS is still -2.646 ns; the 9-track view is
not a 50 MHz signoff either.  The 9-track run uses the same `gf180mcuD` decks
and therefore also closes route, DRC and LVS.

## Why `gf180mcuA` failed and `gf180mcuD` works

The previous canary used the CIEL `gf180mcuA` FD library.  That view is
**3-metal** and its technology LEF only contains 2×2 `Via2` default vias.  It
has no single-cut Via2, so TritonRoute stops with:

```text
[DRT-0234] Via2 does not have single-cut via
```

The wafer-space `gf180mcuD` FD library is **5-metal** and ships
`Via2_HH/HV/VH/VV` single-cut default vias in the technology LEF.  The same
flow routes M2–M4 with **11,180 single-cut vias and 0 multi-cut vias**.  This is
a library/PDK view fix, not a PDN workaround.

The chipathon example that uses `gf180mcuD` +
`gf180mcu_fd_sc_mcu7t5v0` is the reference for the working configuration:
<https://github.com/Mauricio-xx/chipathon-gf180mcu-librelane-examples>.

## Working configuration

`config.digital_gf180mcuD.yaml` uses:

```text
PDK: gf180mcuD
STD_CELL_LIBRARY: gf180mcu_fd_sc_mcu7t5v0
RT_MIN_LAYER: Metal2
RT_MAX_LAYER: Metal4
PDN_MULTILAYER: true
PDN_CORE_RING: false
PDN_ENABLE_PINS: true
```

The PDN is the `gf180mcuD` default: Metal1 rails, Metal4 vertical straps,
Metal5 horizontal straps.  `WITH_POWER` exposes VDD/VSS for the canary top.

`config.digital.yaml` is the legacy `gf180mcuA` 3-metal experiment; it is kept
for the DPL/via history and is not the signoff config.

## Post-route timing

OpenROAD post-route STA with RCX/extracted parasitics, 20 ns clock:

| Corner | Setup WNS | Setup violations | Hold WNS | Hold violations | Max cap / slew |
|---|---:|---:|---:|---:|---:|
| TT / 5.0 V / 25 °C | **-0.169 ns** | 3 | +0.662 ns | 0 | 0 / 0 |
| SS / 4.5 V / 125 °C | **-4.516 ns** | 25 | +1.071 ns | 0 | 0 / 0 |
| FF / 5.5 V / -40 °C | **+1.719 ns** | 0 | +0.390 ns | 0 | 0 / 0 |

The 20 ns (50 MHz) run is the archived characterization result and is not
closed at SS/TT.  The current SDC uses 40 ns (25 MHz) OUT/MID and 66.667 ns
(15 MHz) REF/INJ as planning constraints.  The equivalent single-clock
estimate is about **49.6 MHz at TT** and **40.8 MHz at SS**; hold is positive
at all three corners.  Use a relaxed period (about 25 ns) or
fix the slow-corner path before claiming 50 MHz signoff.

## DPL history (legacy 3-metal view)

The original `gf180mcuA` via-stack PDN caused 272/280 sequential cells to fail
`DPL-0036` (OpenROAD issue #11511).  A rails-only PDN plus `WITH_POWER`
made DPL pass, but the 3-metal view still had no single-cut Via2.  Those
workarounds are retained in `pdn_rails_only.tcl` and the legacy config only as
a recorded experiment; the working `gf180mcuD` run uses the normal PDN.

## Reproduce

The `gf180mcuD` PDK is external (the repository does not vendor PDKs).
`fetch_gf180mcuD.sh` clones the wafer-space PDK at the tested commit and
checks out the required sparse paths:

```sh
./fetch_gf180mcuD.sh /tmp/gf180mcu-wafer
```

Run the full flow (DRC/LVS/antenna included):

```sh
cd flow/canary/gf180mcu_fd_core_a
LIBRELANE=/nix/store/abmh7jj4bkf725p7rrrr98r9ax077v6d-python3.13-librelane-3.0.17/bin/librelane
$LIBRELANE --manual-pdk --pdk-root /tmp/gf180mcu-wafer \
  --pdk gf180mcuD --scl gf180mcu_fd_sc_mcu7t5v0 \
  -S Checker.SetupViolations -S Checker.HoldViolations \
  -S Checker.MaxSlewViolations -S Checker.MaxCapViolations \
  config.digital_gf180mcuD.yaml
```

The tested flow completed 80/80, with `KLayout.DRC`, `Magic.DRC`,
`Netgen.LVS`, antenna checks and `OpenROAD.RCX`/`STAPostPNR` all executed.
The timing checkers are skipped because the 20 ns setup constraint is not
closed; the DRC/LVS/antenna steps are **not** skipped.  The timing table above
is the honest result.

## Next

1. Close the slow-corner setup path or rerun at 25 ns and record the accepted
   frequency.
2. Integrate this digital view with a hard macro in the full `pll` top.
