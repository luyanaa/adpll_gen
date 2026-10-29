# Multi-library synthesis experiments

Same Core A digital RTL (`pll_logic` + 6 submodules), same Yosys 0.52 script, one TT/typ Liberty per library. `cells` is the mapped standard-cell count; `area` is the Liberty cell-area sum. This is synthesis screening, not P&R, STA, or signoff.

Reproduce:

```sh
python3 flow/experiments/synth_multi_lib.py
```

| # | Library | PDK/source | Status | Cells | Area (µm²) | Note |
|---:|---|---|---|---:|---:|---|
| 1 | `ics55_LLSC_H7CR` | `/grid/icsprout55-pdk` | **PASS** | 1466 | 4243.12 |  |
| 2 | `ics55_LLSC_H7CH` | `/grid/icsprout55-pdk` | **PASS** | 1466 | 4243.12 |  |
| 3 | `ics55_LLSC_H7CL` | `/grid/icsprout55-pdk` | **PASS** | 1466 | 4243.12 |  |
| 4 | `open_pdk_sky130_fd_sc_hd` | `~/.ciel` OpenPDK default | **PASS** | 1402 | 13809.4944 |  |
| 5 | `sky130_fd_sc_hdll` | `/grid/sky130` | **PASS** | 1530 | 15561.1744 |  |
| 6 | `ez130_8t_v1p1` | `/grid/ihp130` | **PASS** | 1473 | 17321.0688 |  |
| 7 | `sky130_fd_sc_ms` | `/grid/sky130` | **PASS** | 1386 | 19295.8848 |  |
| 8 | `sky130_fd_sc_ls` | `/grid/sky130` | **PASS** | 1389 | 19375.8048 |  |
| 9 | `sky130_osu_sc_t12` | `/grid/sky130` | **PASS** | 1695 | 24001.9989 |  |
| 10 | `open_pdk_sg13g2_stdcell` | `~/.ciel` OpenPDK default | **PASS** | 1591 | 26118.2124 |  |
| 11 | `open_pdk_gf180mcu_fd_sc_mcu7t5v0` | `~/.ciel` OpenPDK default | **PASS** | 1559 | 43390.3232 |  |
| 12 | `gf180mcu_as_sc_mcu7t3v3` | `/grid/gf180mcu` | **PASS** | 1355 | 45484.544 |  |
| 13 | `gf180mcu_ocd_sc_rt12t3v3` | `/grid/gf180mcu` | **PASS** | 1446 | 47791.6992 |  |
| 14 | `gf180mcu_osu_sc_gp9t3v3` | `/grid/gf180mcu` | **PASS** | 1688 | 72678.06 |  |
| 15 | `gf180mcu_osu_sc_gp12t3v3` | `/grid/gf180mcu` | **PASS** | 1694 | 90696.06 |  |
| 16 | `sky130_rhbd` | `/grid/sky130` | **PASS** | 1827 | 130651.6606 |  |
| 17 | `ETRI050_fd_sc_12t` | `/grid/ETRI050` | **PASS** | 1654 | 1205913.6 |  |
| 18 | `sky130_as_sc_hs` | `/grid/sky130` | **FAIL** | - | - | async-reset DFF cannot be legalized by `dfflibmap` |
| 19 | `gf180mcu_as_ex_mcu7t5v0` | `/grid/gf180mcu` | **FAIL** | - | - | async-reset DFF cannot be legalized by `dfflibmap` |
| 20 | `sg13g2_stdcell_hv` | `/grid/ihp130` | **FAIL** | - | - | Yosys ABC crash (return 134) |
| 21 | `ETRI050_gen_sc_9t` | `/grid/ETRI050` | **FAIL** | - | - | Yosys ABC crash (return 134) |

## Observations

- All 17 passing libraries map the same RTL; no library needs a different `pll_logic` architecture.
- The 55 nm `ics55` H7CR/H7CH/H7CL result (1466 cells, 4243 µm²) is the area floor, but it is a 7-track 1.2 V library and not area-comparable with 130/180 nm results without normalization.
- `sky130_fd_sc_ms` and `sky130_fd_sc_ls` are the smallest 130 nm candidates in cell count; `sky130_fd_sc_hd` is the OpenPDK default and is slightly larger in cell count but smaller in Liberty area than `ms/ls`.
- `gf180mcu_ocd_sc_rt12t3v3` is materially smaller than the OSU gp12/gp9 and AS libraries in this screening; the AS default is in between.
- `ez130_8t_v1p1` (8T) is close to `sky130_fd_sc_hd` area with fewer cells; it remains a candidate for the IHP 1.2 V flow.
- Failures are library/flow-integration issues (async DFF mapping, ABC), not RTL changes. They are listed rather than silently dropped.

## P&R canary follow-up

`flow/canary/gf180mcu_fd_core_a/` is a LibreLane canary for the OpenPDK default `gf180mcu_fd_sc_mcu7t5v0` (5 V, 7-track, 3-metal FD library). It synthesizes 1588 cells / 44,167 µm² and reaches floorplan/global placement, but detailed placement currently fails (`DPL-0036`). It is recorded as an experiment, not a passed canary. The existing `/grid` AS/OCD and ics55/IHP canaries remain the completed P&R evidence.


## Parameter sweep

`flow/experiments/param_sweep.py` is a synthesis-only sweep of the digital
control parameters (FCW/divider width, fine thermometer length, coarse/mid
length).  It writes `param_sweep.json` and per-config Yosys logs under
`param_sweep_logs/`.  Results and the timing caveats are summarized in
`flow/ADPLL_FREQ_DIV.md`; the sweep does not claim post-PnR STA.
