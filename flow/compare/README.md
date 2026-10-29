# Library comparison

This directory holds the user-decision data.  It is deliberately not a
single "best" library: the flow runs the same RTL/core/constraints against
each usable library, then the user selects a per-block combination.

## Two-stage sweep

1. **TT screen** — run every usable library at its typical corner.  Cheap,
   catches unsupported cells, mapping errors, and gross PPA differences.
2. **Full-corner shortlist** — for the libraries the user shortlists, run all
   corners the PDK actually provides (Tier 2 flow).  This is the expensive
   stage; do not run it for every library blindly.

The user can choose a TT-only library; it stays Tier 1.  The tool does not
promote a library to Tier 2 because it is popular or fast.

## Metrics

`summary.csv` columns:

| Column | Meaning |
|---|---|
| `pdk`, `library`, `core` | identity of the run |
| `voltage` | selected supply |
| `tier` | `2-flow`, `2-flow*`, `1+`, `1` |
| `corners` | number of corners run |
| `fmax_mhz` | max functional frequency from STA/SPICE |
| `jitter_rms_ps` | integrated RMS jitter from the analog/ISF flow |
| `power_mw` | typical power at the target frequency |
| `area_mm2` | hard macro + digital area, excluding pads |
| `lock_us` | lock time from behavioral/gate-level sim |
| `wns_ns`, `tns_ns` | STA at the slowest selected corner |
| `drc`, `lvs`, `antenna`, `ir`, `em`, `dft` | pass/fail/NA |
| `utilization`, `cell_count`, `runtime_s` | QoR/flow cost |
| `notes` | unsupported cells, level shifters, caveats |

## Fairness rules

- Same RTL, same core, same clock target, same utilization target, same
  constraints for every library.
- Different voltages are reported, not normalized away.  A 5 V library is not
  directly comparable to a 1.2 V library; include level-shifter cost if mixed.
- Hard-macro area/power/jitter is reported separately from the digital part.
- `partial` cell support is allowed only with a documented equivalent and a
  characterization note.
- `2-flow*` means the PDK declares DRC/LVS pass but the exact evidence is not
  attached; it is not a `2-flow` claim.

## Output

- `compare/summary.csv` — one row per PDK × library × core.
- `compare/<pdk>/<library>/<core>/report.json` — raw flow/STA/DRC/LVS data.
- `compare/comparison.md` — human-readable summary and caveats.

The final choice is `selection.json`, validated by
`flow/validate_selection.py`, then rendered into a LibreLane config.
