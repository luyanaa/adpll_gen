# KDCO and jitter status

## KDCO

### IHP `PLL_ILDCO` L3 table (Core A / same DCO core)

`ihp_l3/kdco_jitter.json` computes local KDCO from the existing 27-point
transistor-level table, not from a behavioral model:

| axis | points | median | min | max |
|---|---:|---:|---:|---:|
| coarse | 18 | -22.996 MHz/code | -42.851 | -6.921 |
| mid | 18 | -1.039 MHz/code | -4.706 | 1.066 |
| fine | 18 | -0.177 MHz/code | -1.955 | 1.880 |

The table is sparse and non-monotonic (`mid`/`fine` have positive slopes); it
is **not** a SAR-valid map.  The physical ring macro uses the same
`PLL_ILDCO` core but has not been swept post-layout, so a ring-specific KDCO
is not claimed.

### IHP counter/NCO (physical RTL/macro, ideal TICK)

At `TICK=100 MHz`, `ACC_BITS=16`, `BASE_INC=3493`:

| axis | KDCO |
|---|---:|
| coarse (`STEP=120`) | 0.091553 MHz/code |
| mid (`STEP=60`) | 0.045776 MHz/code |
| fine (`STEP=15`) | 0.011444 MHz/code |

The RTL toggles `OUT` once per accumulator carry, so one output period takes
two carries:

```text
f_out = f_tick * increment / 2^(acc_bits + 1)
```

At `TICK=100 MHz`, `ACC_BITS=16`, `BASE_INC=3493`, code 0 is
**2.664948 MHz**, not 5.329895 MHz.  This is an exact NCO relation, not a
measured analog DCO.

## Jitter

`ihp_l3/kdco_jitter.json` also extracts **period spread** from the IHP
PEX-cap transient:

```text
mean period     5.5875 ns (178.97 MHz)
period pp       0.4349 ns
period RMS      0.1021 ns (102.1 ps)
```

This is deterministic transient period spread from a single TT/PEX-cap run.
It is **not** random jitter and **not** phase noise: the available ngspice
build has no compatible `.pnoise`, and the repository does not have a
calibrated device-noise source.  No phase-noise or integrated-jitter signoff
is claimed.

The counter path has **deterministic period quantization** even with an ideal
TICK.  At `TICK=100 MHz`, `ACC_BITS=16`, `BASE_INC=3493`, the carry interval
alternates between 18 and 19 TICK cycles (180/190 ns), and the OUT rising-edge
period alternates between 370 and 380 ns:

```text
deterministic period pp   10.0 ns
deterministic period RMS  4.994 ns (4994 ps)
```

That is quantization, not random jitter or phase noise.  External TICK jitter
is a separate source and is not modeled here.  The report keeps these three
categories separate:

1. ideal-TICK deterministic carry/period quantization;
2. external TICK-source jitter transfer;
3. device/SPICE/PVT timing noise.

## Status

```text
KDCO  : local table values available; counter model corrected by /2
jitter: counter deterministic quantization reported; no pnoise signoff
```
