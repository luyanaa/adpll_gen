# Physical DCO signoff status (2026-11-01)

## gf180mcu (DRC/LVS clean)

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| PDK/library | gf180mcu_as_sc_mcu7t3v3 | gf180mcu_as_sc_mcu7t3v3 |
| GDS/LEF/LIB/CDL/DEF | present | present |
| DRC | **0 violations** (KLayout 0.30.7, gf180mcuD, after fill) | **0 violations** |
| LVS | **PASS** (fill-marker exclusion) | **PASS** (fill-marker exclusion) |
| STA, TT/SS/FF | **PASS** (gate-level; WNS +8.02/+7.78/+8.17 ns) | **PASS** (TICK WNS +5.53/+3.96/+6.50 ns) |
| PVT transient | **TT/SS/FF complete** (min code): 21.07/15.74/26.60 MHz | NCO frequency is ideal-digital PVT-invariant |
| Deterministic period spread | TT 47.469 ns, pp 0.24 ps, RMS 0.11 ps | 380/370 ns quantization: pp 10 ns, RMS 4.985 ns |
| Random jitter / phase noise | **not characterized** (no Pnoise) | **not characterized** (no Pnoise) |

Ring/counter STA and PVT evidence:
`flow/characterization/macro_char/{sta_summary,ring_pvt,counter_nco}.json`
and `flow/characterization/macro_char/CHARACTERIZATION.md`.  Ring PVT is
cell-level (no routed RC); period spread is deterministic transient spread,
not random jitter.

## IHP SG13G2 (official deck, official KLayout run)

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| PDK/library | ihp-sg13g2 / sg13g2_stdcell | ihp-sg13g2 / sg13g2_stdcell |
| GDS/LEF/LIB/CDL/DEF | present | present |
| DRC | **0 violations** (official maximal+density) | **0 violations** (official maximal+density) |
| LVS | **PASS** (official deck, fill-stripped, top-port waiver) | **PASS** (same waiver) |
| STA, TT/SS/FF | **PASS** (gate-level; WNS +9.44/+9.24/+9.55 ns) | **PASS** (TICK WNS +6.87/+5.10/+7.90 ns) |
| PVT transient | **TT/SS/FF complete** (min code): 33.21/20.95/47.58 MHz | NCO frequency is ideal-digital PVT-invariant |
| Deterministic period spread | TT 30.111 ns, pp 3.26 ps, RMS 1.44 ps | 380/370 ns quantization: pp 10 ns, RMS 4.985 ns |
| Random jitter / phase noise | **not characterized** (no Pnoise) | **not characterized** (no Pnoise) |

Evidence: `flow/macro/ring_dco_ihp130/OFFICIAL_SIGNOFF.md`,
`flow/macro/counter_dco_ihp130/OFFICIAL_SIGNOFF.md`, and the shared
`macro_char` reports.  The official IHP deck is available from the local
CIEL checkout; the LVS pass uses a top-port naming waiver.

## sky130 (functional LVS topology pass; official-deck compare caveat)

| Check | Ring DCO | Counter/NCO |
|---|---|---|
| PDK/library | sky130_fd_sc_hd | sky130_fd_sc_hd |
| GDS/LEF/LIB/CDL/DEF | present | present |
| DRC | **0 violations** | **0 violations** |
| LVS (netgen, official setup) | **PASS: Circuits match uniquely** | **PASS: Circuits match uniquely** |
| LVS (official KLayout compare) | top-pin/net-name caveat | top-pin/net-name caveat |
| STA, TT/SS/FF | **PASS** (gate-level; WNS +9.51/+9.28/+9.59 ns) | **TT/FF PASS; SS FAIL** at 100 MHz TICK (WNS -0.640 ns, TNS -1.85 ns) |
| PVT transient | **NO_OSCILLATION at TT/SS/FF** | NCO frequency is ideal-digital PVT-invariant |
| Deterministic period spread | not available (ring does not oscillate) | 380/370 ns quantization: pp 10 ns, RMS 4.985 ns |
| Random jitter / phase noise | **not characterized** | **not characterized** |

The sky130 ring is the one real functional blocker in this campaign: the
built netlist ties the injection-window input low, so the sky130
`PLL_CELL_NOR2BX1` mapping does not enable the oscillator path.  The
transient probe is recorded as `NO_OSCILLATION`; no sky130 ring frequency
or jitter number is claimed.

Evidence: `flow/macro/ring_dco_sky130/SIGNOFF.md`,
`flow/macro/counter_dco_sky130/SIGNOFF.md`, and
`flow/characterization/macro_char/CHARACTERIZATION.md`.  The layout netlist
is extracted with the official sky130 KLayout deck in `deep` mode; the
native cell CDL is normalized only for library-view differences (`VNB` vs
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
