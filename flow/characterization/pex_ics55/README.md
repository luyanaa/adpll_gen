# ics55 DCO PEX-capacitance baseline

This directory extracts the **routed macro** parasitics with OpenROAD and uses
the DCO-net capacitance in a transistor-level transient.  The DCO is not yet a
standalone placed block; it is a hierarchy inside `PLL_ANALOG_MACRO`, so the
final macro database is the layout source.

## Extraction

```sh
python3 flow/characterization/pex_extract.py --pdk ics55
```

The script runs OpenROAD 2026-02-17:

```text
read_db pnr/outputs/ics55/PLL_ANALOG_MACRO.final.db
extract_parasitics -ext_model_file .../rcx.rules
write_spef PLL_ANALOG_MACRO.spef
```

and selects the nets named `pll_ana_dco/*` plus `OUT` / `MID_OUT`.

```text
SPEF nets:                 197
DCO nets:                  121
DCO total capacitance:     0.188450 pF
```

## PEX-cap transient

```sh
python3 flow/characterization/dco_pex_cap.py \
  --pdk ics55 --out flow/characterization/pex_ics55 \
  --coarse 8 --mid 8 --fine 8 --stopsim-ns 10
```

Each SPEF net capacitance is grounded and given a 1 Gohm DC path.  The include
is placed **inside** the `PLL_ILDCO` subcircuit; a top-level include would not
load the DCO internal nodes.  This is a first-order capacitance
back-annotation; **series wire resistance and lateral coupling are not
included**.

| case | frequency |
|---|---:|
| transistor baseline | 958.12 MHz |
| PEX capacitance | 362.84 MHz |
| PEX lumped RC | 335.23 MHz |
| delta (RC vs baseline) | -622.88 MHz (-65.02 %) |

## PVT frequency

```sh
python3 flow/characterization/dco_pvt.py \
  --pdk ics55 --out flow/characterization/pex_ics55 \
  --coarse 8 --mid 8 --fine 8 --stopsim-ns 20
```

| corner | supply | temp | frequency |
|---|---:|---:|---:|
| TT | 1.20 V | 25 C | 362.90 MHz |
| SS | 1.08 V | 125 C | 184.40 MHz |
| FF | 1.32 V | -40 C | 581.99 MHz |

## Status

```text
routed RCX extraction:        working
DCO-net cap back-annotation:  working, one code
series R / coupling:          not included
PEX tuning grid:              not run
jitter / phase noise:         not run
```

## Lumped series-R extension

`dco_pex_rc.py` splits each DCO top net into a driver/port side and a
gate-load side, inserts the SPEF total wire resistance in series, and splits
the total capacitance across the two sides:

```text
driver/port -- R_total -- gate-load
    C/2                     C/2
```

This is still lumped, not the full distributed SPEF tree, and coupling is
grounded.  At `c8/m8/f8` it gives 335.23 MHz (sum of all DCO-net R = 24.3 kΩ).
The capability is labelled `L3_PEX_RC_LUMPED`, not production signoff.
