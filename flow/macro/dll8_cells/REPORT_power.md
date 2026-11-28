# DLL8 power integrity audit + respin spec (2026-11-28)

## Measured power (ngspice, full 127-finger bank ON, worst usage)

| corner | freq | per element | per line4 strip | peak/elem |
|---|---|---|---|---|
| TT 1.20V/25C | 500 MHz | 0.42 mW / 0.350 mA | 1.4 mA | 0.94 mA |
| FF 1.32V/-40C | 500 MHz | 0.66 mW / 0.501 mA | 2.0 mA | 1.49 mA |
| SS 1.08V/125C | 250 MHz | 0.19 mW / 0.178 mA | 0.71 mA | 0.50 mA |

(1-element deck `dll8_pex2.emit_elem2(nfixed=127)` + square input; consumption
current averaged over 4 steady-state periods.  Decks: /tmp/opencode/dll8pwr,
regenerate via the harness in git history if needed.)

## Verdict: the signed-off macro FAILS power integrity at the 2 Gb/s design point — bounded respin required

EM worst case co-occurs at high temperature: SS 125 °C operation is only
guaranteed at 250 MHz (0.71 mA/strip), but nothing stops 500 MHz operation at
elevated temperature in the TT/FF envelope — design must sustain
**1.0 mA avg + 1.5 mA peak per strip at 125 °C**.  With M1 DC EM ≈ 1–1.5 mA/µm
(125 °C), every series cross-section must be ≥ 0.7–1.0 µm effective.

### Measured bottleneck inventory (signed-off dll8_line4.gds)

| location | present | required | verdict |
|---|---|---|---|
| array vertical VDD/VSS rails | 0.16 µm M1 × 353 µm | — | parallel-fed by rungs, see below |
| inter-rung bridges in array | 0.30 µm M1, ~3 µm spans | ≥ 0.7 µm | **FAIL** |
| strip exit tie-out (horizontal) | 9.16 µm long × 0.30 µm tall | ≥ 1.0 µm tall | **FAIL** |
| strip exit vertical drop to pin pad | 0.16 µm × 5.28 µm | ≥ 1.0 µm | **FAIL** |
| inter-strip VDD hops | 1 × V1 (0.19 µm) + 0.44 µm M2 hop | ≥ 4 vias + ≥ 1.2 µm | **FAIL** |
| VDD boundary pin shape | 0.16 × 5.28 µm pad | wider + multi-window | **FAIL** |
| VSS rail/stubs | 0.25 µm horizontal rail | ≥ 0.8 µm | **FAIL** (same order) |

The array interior is a mesh (3.43 µm guard-ring rungs every ~3 µm vertically
in parallel with the 0.16/0.30 µm rails) — interior current spreading is
acceptable.  **All fatal bottlenecks are in the exit/interconnect structures
added at elem/line4 level**, not in the frozen finger array itself.  This is
what makes the respin bounded: array interior geometry does not need to
change if spacing allows the rail widening.

## Respin spec (bounded edits)

1. `build_array5.py`: widen VDD/VSS vertical rails 0.16 → 0.8 µm; widen
   inter-rung bridge segments 0.30 → 0.7 µm.  (Verify DRC spacing to the
   moscap columns — N pitch is 5 µm, rail sits in the guard-ring column;
   expected to fit, MUST be re-measured.)
2. `build_macro_elem.py`: strip exit tie-out height 0.30 → 1.0 µm; vertical
   exit drop 0.16 → 1.0 µm; widen inv supply join straps to match.
3. `build_line4.py`: inter-strip hops — single V1 → 2×2 via array, M2 hop
   0.44 → 1.2 µm, end pads widened; VSS rail 0.25 → 0.8 µm + stubs widened;
   VDD/VSS boundary pin pads ≥ 1 µm wide.
4. Re-run the full signoff loop: KLayout DRC (array/elem/line4) +
   LVS compare with `-rd ignore_top_ports_mismatch=true` (see
   REPORT_signoff.md — strict mode is a proven false-negative generator).
5. Regenerate the derived views: `flow/macro/dll8_line4_macro/` —
   make_gds_view.py, extract_pins.py, gen_lef.py (scripted, minutes).

## Why this does NOT block the digital integration work

The respin changes only power-network geometry; signal pins (IN/OUT/TAP/EN)
are untouched, so the LEF/blackbox/floorplan integration validates against
the current macro and only the power pin shapes in the final LEF change.
