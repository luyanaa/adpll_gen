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

---

# Respin COMPLETED + re-signed-off (2026-11-28 evening)

## Authoritative EM limits (SG13G2 process spec §2.15, 11 y @ 105 °C)

| layer | rule |
|---|---|
| Metal1 | w ≤ 0.36 µm → 0.36 mA total; w > 0.36 µm → 1.0 mA/µm |
| Metal2–Metal5 | w > 0.3 µm → 2.0 mA/µm |
| Via1–Via4 | 0.4 mA per via |

(The earlier "M1 ≈ 1–1.5 mA/µm @125 °C" estimate was conservative-wrong in
both directions; the spec numbers above are what the respin is sized against.
TT/FF power at 105 °C, not SS-250, is the EM worst case: 0.50 mA/elem,
2.0 mA per line4 strip.)

## As-built respin (supersedes the "spec" section above — the inter-strip
hop topology was abandoned entirely)

- **array** (`build_array5.py`): VDD rail 0.16 → 0.60 µm wide (east side),
  VSS rail 0.16 → 0.66 µm (west side). Capacity 0.60/0.66 mA vs 0.50 mA
  worst per-element draw; interior mesh unchanged.
- **elem** (`build_macro_elem.py`): VDD vertical drop 0.16 → 1.16 µm wide;
  VSS connector+out merged single piece y[-2120,-1360] (0.76 µm tall),
  VSS vertical drop 1.06 µm wide westward.
- **line4** (`build_line4.py`): independent per-strip feeds from two M4
  trunks — VDD y[-2600,-1400], VSS y[-4400,-3400], both x[5000 or -1700 ..
  67500] — each strip taps the trunks through M1→M2→M3→M4 stacks of 2×3
  via arrays (6 vias/level = 2.4 mA/level capacity ≥ 2.0 mA demand).
  Trunk cross-section 1.2/1.0 µm × 2 mA/µm = 2.4/2.0 mA ≥ 2.0 mA demand.
  End pads are full M1..M5 stacks with 2×3 via arrays at every level at
  x[65900,67500]; **power pin labels moved to the M5 pads** (VDD y-2000,
  VSS y-3900). The old inter-strip VDD hops and the M1 VSS rail are
  deleted. New line4 bbox: (-1760,-13670;67500,344860) nm = 69.26 µm wide.

## Re-signoff results (KLayout 0.30.12, 2026-11-28 17:43–17:55)

| artifact | DRC | LVS (flat, ignore_top_ports_mismatch=true) |
|---|---|---|
| dll8_line_array.gds | **ZERO** (out/kl/pr_arr.lyrdb) | — |
| dll8_elem_macro.gds | **ZERO** (out/kl/pr_elem.lyrdb) | **MATCH** (out/lvs/pr_elem_lvs.log 17:52) |
| dll8_line4.gds | **ZERO** (out/kl/pr_line4.lyrdb) | **MATCH** (out/lvs/pr_line4_lvs.log 17:54) |

## Process trap that cost one iteration — record for all future work

**Same-layer overlaps of different nets are invisible to KLayout DRC
spacing checks**: same-net-merged polygons are unioned before spacing is
evaluated, so M1-on-M1 overlap of VDD and VSS shapes produces no spacing
violation. Only LVS extraction catches it (nets merge into `VDD|VSS`).
The first respin build shorted exactly this way: the widened VSS-out piece
(bottom edge y=-2660) overlapped inv1's *internal* VDD rail
(abs x[0.4,3.28] y[-4.29,-2.50] — the stdcell's own top rail, not anything
the macro builder drew). DRC was clean on all three levels while the
circuit was dead-shorted. Diagnosis path that worked: extract with
`-rd run_mode=flat -rd target_netlist=...` and grep the extracted netlist
for merged-net names, then flood-fill probe the M1 seed polygons.
Fixed by keeping the VSS connector bottom at y=-2120 (380 nm gap to the
inv1 rail top). **Rule: after any power-network edit, the signoff evidence
is the extracted flat netlist — DRC alone is insufficient.**

Also learned: `run_mode` must be **flat** for LVS here — deep mode emits a
hierarchical netlist with internal `\$I`/`\$2.` node names and collapsed
pins that cannot match the flat reference cdl, another false-negative
generator distinct from the strict-ports one.
