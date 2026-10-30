# IHP SG13G2 DCO PEX-capacitance baseline

This is the IHP counterpart of `flow/characterization/pex_ics55`.  The routed
`PLL_ANALOG_MACRO` database contains the complete DCO hierarchy; the OpenRCX
nominal rules extract its nets, and the DCO-net capacitance is applied to the
PSP103 transient.  The include is inserted **inside** `PLL_ILDCO`, and the
100 ns window is required for a settled measurement.

## Extraction

```sh
python3 flow/characterization/pex_extract.py --pdk ihp-sg13g2
```

The script reads:

```text
pnr/outputs/ihp-sg13g2-sg13g2_stdcell/PLL_ANALOG_MACRO.final.db
libs.tech/librelane/openrcx/ihp-sg13g2.nom.magic.rules
```

Result:

```text
SPEF nets:                 201
DCO nets:                  125
DCO total capacitance:     0.844663 pF
```

## PEX-cap transient

```sh
python3 flow/characterization/dco_pex_cap.py \
  --pdk ihp-sg13g2 --out flow/characterization/pex_ihp \
  --coarse 8 --mid 8 --fine 8 --stopsim-ns 30
```

| case | frequency |
|---|---:|
| transistor baseline | 287.85 MHz |
| PEX capacitance | 178.97 MHz |
| delta | -108.88 MHz (-37.83 %) |

## PVT frequency

```sh
python3 flow/characterization/dco_pvt.py \
  --pdk ihp-sg13g2 --out flow/characterization/pex_ihp \
  --coarse 8 --mid 8 --fine 8 --stopsim-ns 40
```

| corner | supply | temp | frequency |
|---|---:|---:|---:|
| TT | 1.20 V | 25 C | 178.97 MHz |
| SS | 1.08 V | 125 C | 115.41 MHz |
| FF | 1.32 V | -40 C | 274.15 MHz |

## Status

```text
routed RCX extraction:        working
DCO-net cap back-annotation:  working, one code
series R / coupling:          not included
PEX tuning grid:              not run
jitter / phase noise:         not run
```

This is **L3_PEX_CAP**, not production signoff.
