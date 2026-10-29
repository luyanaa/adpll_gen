# Library / block support matrix

No product default is implied. `partial` means an optional cell is
missing (for example a dedicated clock buffer); use a documented
equivalent such as `buf` + `inv` after characterization.

## ETRI050

| Library | V | Corners | Tier | PnR | Core A | Core B | Core C | Digital | Notes |
|---|---|---|---|---|---|---|---|---|---|
| ETRI050_fd_sc_12t | 5.0 | 1 | 1 | - | no | full | full | partial | single corner; drc_lvs=declared |
| ETRI050_gen_sc_9t | 5.0 | 1 | 1 | - | no | full | partial | partial | single corner; drc_lvs=declared |

## gf180mcu

| Library | V | Corners | Tier | PnR | Core A | Core B | Core C | Digital | Notes |
|---|---|---|---|---|---|---|---|---|---|
| gf180mcu_ocd_sc_rt12t3v3 | 3.3,3.6 | 21 | 2-flow* | - | full | full | full | partial | drc_lvs=declared; corner cell-set mismatch in 21 corner(s) |
| gf180mcu_as_sc_mcu7t3v3 | 3.0,3.3,3.6 | 6 | 2-flow* | - | full | full | full | partial | drc_lvs=declared; corner cell-set mismatch in 3 corner(s) |
| gf180mcu_osu_sc_gp12t3v3 | 3.0,3.3,3.6 | 6 | 2-flow* | - | no | full | full | partial | drc_lvs=declared; corner cell-set mismatch in 6 corner(s) |
| gf180mcu_osu_sc_gp9t3v3 | 3.0,3.3,3.6 | 4 | 2-flow* | - | no | full | full | partial | drc_lvs=declared; corner cell-set mismatch in 1 corner(s) |
| gf180mcu_as_ex_mcu7t5v0 | 4.5,5.0,5.5 | 3 | 2-flow* | - | no | no | no | no | drc_lvs=declared |

## ics55

| Library | V | Corners | Tier | PnR | Core A | Core B | Core C | Digital | Notes |
|---|---|---|---|---|---|---|---|---|---|
| ics55_LLSC_H7CH | 1.08,1.2,1.32 | 7 | 2-flow | - | partial | partial | partial | partial | corner cell-set mismatch in 6 corner(s) |
| ics55_LLSC_H7CL | 1.08,1.2,1.32 | 7 | 2-flow | - | partial | partial | partial | partial |  |
| ics55_LLSC_H7CR | 1.08,1.2,1.32 | 7 | 2-flow | - | partial | partial | partial | partial | corner cell-set mismatch in 6 corner(s) |

## ihp130

| Library | V | Corners | Tier | PnR | Core A | Core B | Core C | Digital | Notes |
|---|---|---|---|---|---|---|---|---|---|
| ez130_8t_v1p1 | 1.08,1.2,1.32 | 3 | 2-flow* | - | partial | partial | partial | partial | drc_lvs=declared |
| sg13g2_stdcell | 1.2 | 3 | 2-flow* | yes | partial | partial | partial | partial | ORFS ihp-sg13g2 sg13g2_stdcell 1.2V; 3 cell-identical corners; official IHP PDK root and DRC/LVS decks absent; PnR canary ran with a locally authored minimal PDK config; not signoff |
| sg13g2_stdcell_hv | 3.0,3.3,3.6 | 3 | 2-flow* | - | partial | partial | partial | partial | drc_lvs=declared |

## sky130

| Library | V | Corners | Tier | PnR | Core A | Core B | Core C | Digital | Notes |
|---|---|---|---|---|---|---|---|---|---|
| sky130_osu_sc_t15 | 1.2,1.28,1.35,1.44,1.5,1.56,1.6,1.62,1.68,1.76,1.8,1.89,1.95,2.1 | 72 | 2-flow* | - | no | partial | partial | partial | drc_lvs=declared; corner cell-set mismatch in 72 corner(s) |
| sky130_osu_sc_t18 | 1.2,1.28,1.35,1.44,1.5,1.56,1.6,1.62,1.68,1.76,1.8,1.89,1.95,2.1 | 66 | 2-flow* | - | no | partial | partial | partial | drc_lvs=declared; corner cell-set mismatch in 66 corner(s) |
| sky130_osu_sc_t12 | 1.2,1.28,1.35,1.44,1.5,1.56,1.6,1.62,1.68,1.76,1.8,1.89,1.95,2.1 | 64 | 2-flow* | - | no | partial | partial | partial | drc_lvs=declared; corner cell-set mismatch in 64 corner(s) |
| sky130_fd_sc_ms | 1.28,1.8,1.95 | 5 | 2-flow* | no | full | full | partial | partial | reconstructed Liberty from .lib.json (STA-usable); pnr_ready=false until fill/tap/decap/diode (diode, fill, fill_diode, latchupcell, tap, tapmet1, tapvgnd, tapvgnd2, tapvpwrvgnd) are supplied |
| sky130_as_sc_hs | 1.7,1.8,1.9 | 3 | 2-flow* | - | full | full | full | partial | drc_lvs=declared |
| sky130_fd_sc_hdll | 1.28,1.8 | 2 | 2-flow* | no | full | full | partial | partial | reconstructed Liberty from .lib.json (STA-usable); pnr_ready=false until fill/tap/decap/diode (fill, muxb, tap, tapvgnd, tapvgnd2, tapvpwrvgnd) are supplied |
| sky130_fd_sc_lp | 1.65,1.95 | 2 | 2-flow* | no | full | full | partial | partial | reconstructed Liberty from .lib.json (STA-usable); pnr_ready=false until fill/tap/decap/diode (busdriver, busdriver2, busdrivernovlp, busdrivernovlp2, busdrivernovlpsleep, bushold, bushold0, busreceiver, decap, decapkapwr, diode, fill, sleep_pargate_plv, sleep_sergate_plv, tap, tapvgnd, tapvgnd2, tapvpwrvgnd) are supplied |
| sky130_fd_sc_ls | 1.28,1.8 | 2 | 2-flow* | no | full | full | partial | partial | reconstructed Liberty from .lib.json (STA-usable); pnr_ready=false until fill/tap/decap/diode (decaphetap, fill, latchupcell, tap, tapmet1, tapvgnd, tapvgnd2, tapvgndnovpb, tapvpwrvgnd) are supplied |
| sky130_rhbd | 1.8 | 1 | 1 | - | no | partial | partial | partial | single corner; drc_lvs=declared |

## Candidates by core

### core_a_il_dco

- ics55/ics55_LLSC_H7CH (partial)
- ics55/ics55_LLSC_H7CL (partial)
- ics55/ics55_LLSC_H7CR (partial)
- gf180mcu/gf180mcu_ocd_sc_rt12t3v3
- gf180mcu/gf180mcu_as_sc_mcu7t3v3
- sky130/sky130_fd_sc_ms
- ihp130/ez130_8t_v1p1 (partial)
- ihp130/sg13g2_stdcell (partial)
- ihp130/sg13g2_stdcell_hv (partial)
- sky130/sky130_as_sc_hs
- sky130/sky130_fd_sc_hdll
- sky130/sky130_fd_sc_lp
- sky130/sky130_fd_sc_ls

### core_b_ring_dco

- ics55/ics55_LLSC_H7CH (partial)
- ics55/ics55_LLSC_H7CL (partial)
- ics55/ics55_LLSC_H7CR (partial)
- sky130/sky130_osu_sc_t15 (partial)
- sky130/sky130_osu_sc_t18 (partial)
- sky130/sky130_osu_sc_t12 (partial)
- gf180mcu/gf180mcu_ocd_sc_rt12t3v3
- gf180mcu/gf180mcu_as_sc_mcu7t3v3
- gf180mcu/gf180mcu_osu_sc_gp12t3v3
- sky130/sky130_fd_sc_ms
- gf180mcu/gf180mcu_osu_sc_gp9t3v3
- ihp130/ez130_8t_v1p1 (partial)
- ihp130/sg13g2_stdcell (partial)
- ihp130/sg13g2_stdcell_hv (partial)
- sky130/sky130_as_sc_hs
- sky130/sky130_fd_sc_hdll
- sky130/sky130_fd_sc_lp
- sky130/sky130_fd_sc_ls
- ETRI050/ETRI050_fd_sc_12t
- ETRI050/ETRI050_gen_sc_9t
- sky130/sky130_rhbd (partial)

### core_c_counter

- ics55/ics55_LLSC_H7CH (partial)
- ics55/ics55_LLSC_H7CL (partial)
- ics55/ics55_LLSC_H7CR (partial)
- sky130/sky130_osu_sc_t15 (partial)
- sky130/sky130_osu_sc_t18 (partial)
- sky130/sky130_osu_sc_t12 (partial)
- gf180mcu/gf180mcu_ocd_sc_rt12t3v3
- gf180mcu/gf180mcu_as_sc_mcu7t3v3
- gf180mcu/gf180mcu_osu_sc_gp12t3v3
- sky130/sky130_fd_sc_ms (partial)
- gf180mcu/gf180mcu_osu_sc_gp9t3v3
- ihp130/ez130_8t_v1p1 (partial)
- ihp130/sg13g2_stdcell (partial)
- ihp130/sg13g2_stdcell_hv (partial)
- sky130/sky130_as_sc_hs
- sky130/sky130_fd_sc_hdll (partial)
- sky130/sky130_fd_sc_lp (partial)
- sky130/sky130_fd_sc_ls (partial)
- ETRI050/ETRI050_fd_sc_12t
- ETRI050/ETRI050_gen_sc_9t (partial)
- sky130/sky130_rhbd (partial)

### digital

- ics55/ics55_LLSC_H7CH (partial)
- ics55/ics55_LLSC_H7CL (partial)
- ics55/ics55_LLSC_H7CR (partial)
- sky130/sky130_osu_sc_t15 (partial)
- sky130/sky130_osu_sc_t18 (partial)
- sky130/sky130_osu_sc_t12 (partial)
- gf180mcu/gf180mcu_ocd_sc_rt12t3v3 (partial)
- gf180mcu/gf180mcu_as_sc_mcu7t3v3 (partial)
- gf180mcu/gf180mcu_osu_sc_gp12t3v3 (partial)
- sky130/sky130_fd_sc_ms (partial)
- gf180mcu/gf180mcu_osu_sc_gp9t3v3 (partial)
- ihp130/ez130_8t_v1p1 (partial)
- ihp130/sg13g2_stdcell (partial)
- ihp130/sg13g2_stdcell_hv (partial)
- sky130/sky130_as_sc_hs (partial)
- sky130/sky130_fd_sc_hdll (partial)
- sky130/sky130_fd_sc_lp (partial)
- sky130/sky130_fd_sc_ls (partial)
- ETRI050/ETRI050_fd_sc_12t (partial)
- ETRI050/ETRI050_gen_sc_9t (partial)
- sky130/sky130_rhbd (partial)

### pd_ssbbpd

- ics55/ics55_LLSC_H7CH (partial)
- ics55/ics55_LLSC_H7CL (partial)
- ics55/ics55_LLSC_H7CR (partial)
- sky130/sky130_osu_sc_t15 (partial)
- sky130/sky130_osu_sc_t18 (partial)
- sky130/sky130_osu_sc_t12 (partial)
- gf180mcu/gf180mcu_ocd_sc_rt12t3v3 (partial)
- gf180mcu/gf180mcu_as_sc_mcu7t3v3 (partial)
- gf180mcu/gf180mcu_osu_sc_gp12t3v3
- sky130/sky130_fd_sc_ms
- gf180mcu/gf180mcu_osu_sc_gp9t3v3
- ihp130/ez130_8t_v1p1 (partial)
- ihp130/sg13g2_stdcell (partial)
- ihp130/sg13g2_stdcell_hv (partial)
- sky130/sky130_as_sc_hs (partial)
- sky130/sky130_fd_sc_hdll
- sky130/sky130_fd_sc_lp
- sky130/sky130_fd_sc_ls
- ETRI050/ETRI050_fd_sc_12t (partial)
- ETRI050/ETRI050_gen_sc_9t (partial)
- sky130/sky130_rhbd (partial)

### tdc_sr

- ics55/ics55_LLSC_H7CH
- ics55/ics55_LLSC_H7CL
- ics55/ics55_LLSC_H7CR
- sky130/sky130_osu_sc_t15
- sky130/sky130_osu_sc_t18
- sky130/sky130_osu_sc_t12
- gf180mcu/gf180mcu_ocd_sc_rt12t3v3
- gf180mcu/gf180mcu_as_sc_mcu7t3v3
- gf180mcu/gf180mcu_osu_sc_gp12t3v3
- sky130/sky130_fd_sc_ms
- gf180mcu/gf180mcu_osu_sc_gp9t3v3
- ihp130/ez130_8t_v1p1
- ihp130/sg13g2_stdcell
- ihp130/sg13g2_stdcell_hv
- sky130/sky130_as_sc_hs
- sky130/sky130_fd_sc_hdll
- sky130/sky130_fd_sc_lp
- sky130/sky130_fd_sc_ls
- ETRI050/ETRI050_fd_sc_12t
- ETRI050/ETRI050_gen_sc_9t
- sky130/sky130_rhbd

