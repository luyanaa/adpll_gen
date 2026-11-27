# Finger-count / finger-size sweep (SS/TT/FF, 1.0x1.0 vs 1.4 vs 2.0)

Total switched area held ~constant; only the finger count changed.  Measured
BASE (all fingers present, all OFF) and MAX (all ON):

| N | finger | corner | BASE | MAX | range | contrast/finger | max/500 |
|---|---|---|---|---|---|---|---|
| 127 | 1.0x1.0 | ss | 173.6 | 660.6 | 487.0 | 3.83 | 1.32 |
| 127 | 1.0x1.0 | tt | 106.2 | 511.7 | 405.5 | 3.19 | 1.02 |
| 127 | 1.0x1.0 | ff | 73.5 | 477.3 | 403.8 | 3.18 | 0.95 |
| 63 | 1.4x1.4 | ss | 140.5 | 510.9 | 370.4 | 5.88 | 1.02 |
| 63 | 1.4x1.4 | tt | 87.5 | 379.9 | 292.4 | 4.64 | 0.76 |
| 63 | 1.4x1.4 | ff | 61.4 | 343.0 | 281.7 | 4.47 | 0.69 |
| 31 | 2.0x2.0 | ss | 117.5 | 403.7 | 286.3 | 9.24 | 0.81 |
| 31 | 2.0x2.0 | tt | 74.5 | 292.2 | 217.7 | 7.02 | 0.58 |
| 31 | 2.0x2.0 | ff | 52.8 | 257.4 | 204.5 | 6.60 | 0.51 |

## Verdict: stay at 127 fingers
- 31 fingers: SS MAX 403.7 ps < 500 -> cannot reach d=500 (let alone +15%).
- 63 fingers: SS MAX 510.9 ps -> reaches 500 with only 1.02x headroom (needs
  >=1.15x / 575 ps) -> fails the headroom rule.
- 127 fingers: SS MAX 660.6 ps -> 1.32x, PASS; LSB 3.83 ps <= 22.7 ps.

The premise that total delay range is proportional to total cap does NOT hold:
contrast/finger is sub-linear (3.83 -> 5.88 -> 9.24 for 1x, 1.5x, 2x linear
size; not 4x).  Bigger moscap fingers give less effective delay per area
(voltage-dependent C + larger switch series R), so the 4x device saving is
not realisable at the required range.

Keep 127 fingers, moscap 1.0x1.0, 2032 raw devices.  The 2 x 4-element macro
split (Decision 1) still applies for the floorplan.

## Remaining (not done)
Route one 4-element macro with shared wells/guard rings, DRC 0 (Magic +
KLayout), netgen LVS, PEX tap-to-tap spread, LEF + OpenROAD place dry-run,
equal-parasitic tap routing.  This is the large layout step; not completed.
