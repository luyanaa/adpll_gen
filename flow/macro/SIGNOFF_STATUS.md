# Physical DCO signoff status (2026-10-31)

## gf180mcu (DRC/LVS clean)

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| PDK/library | gf180mcu_as_sc_mcu7t3v3 | gf180mcu_as_sc_mcu7t3v3 |
| GDS/LEF/LIB/CDL/DEF | present | present |
| DRC | **0 violations** (KLayout 0.30.7, gf180mcuD, after fill) | **0 violations** |
| LVS | **PASS** (fill-marker exclusion) | **PASS** (fill-marker exclusion) |
| STA | nominal only | nominal only |
| PVT/jitter/KDCO | not characterized | not characterized |

Evidence: `flow/macro/ring_dco_gf180mcu/` and
`flow/macro/counter_dco_gf180mcu/`.

## IHP SG13G2 (official deck, official KLayout run)

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| PDK/library | ihp-sg13g2 / sg13g2_stdcell | ihp-sg13g2 / sg13g2_stdcell |
| GDS/LEF/LIB/CDL/DEF | present | present |
| DRC | **0 violations** (official maximal+density) | **0 violations** (official maximal+density) |
| LVS | **PASS** (official deck, fill-stripped, top-port waiver) | **PASS** (same waiver) |
| STA | nominal only | nominal only |
| PVT/jitter/KDCO | not characterized | not characterized |

Evidence: `flow/macro/ring_dco_ihp130/OFFICIAL_SIGNOFF.md` and
`flow/macro/counter_dco_ihp130/OFFICIAL_SIGNOFF.md`.  The official IHP deck is
available from the local CIEL checkout; the LVS pass uses a top-port naming
waiver.

## sky130 (functional LVS topology pass; official-deck compare caveat)

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| PDK/library | sky130_fd_sc_hd | sky130_fd_sc_hd |
| GDS/LEF/LIB/CDL/DEF | present | present |
| DRC | **0 violations** | **0 violations** |
| LVS (netgen, official setup) | **PASS: Circuits match uniquely** | **PASS: Circuits match uniquely** |
| LVS (official KLayout compare) | top-pin/net-name caveat | top-pin/net-name caveat |
| STA | P&R only | P&R only |

Evidence: `flow/macro/ring_dco_sky130/` and
`flow/macro/counter_dco_sky130/`, reproduced by
`flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py`.  The layout netlist is
extracted with the official sky130 KLayout deck in `deep` mode; the native
cell CDL is normalized only for library-view differences (`VNB` vs
`sky130_gnd`, CDL `m=N` multiplicity, the `conb_1` poly-short tie view, and
the unused `INJ_EN` port).  The official KLayout deck's own numeric compare
still reports top-pin/net-name mismatches; no full production signoff is
claimed.

## FreePDK45 (planning only)

Included in `pdk_profiles.json` and `libraries.json`.  The available
`osu_soc` views include Liberty/LEF/SPICE but no GDS standard-cell physical
signoff path, so it is **not** a physical macro/Signoff target.

## ics55 (earlier attempt)

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| DRC | not clean (281 raw / 77 unwaived) | not clean (1694 raw / 1413 unwaived) |
| LVS | MISMATCH | no passing LVS |
| STA | nominal interface only | nominal only |

The ics55 results remain recorded under `flow/macro/*_dco_ics55/SIGNOFF.md`.
No PVT or production signoff is claimed for either PDK.
