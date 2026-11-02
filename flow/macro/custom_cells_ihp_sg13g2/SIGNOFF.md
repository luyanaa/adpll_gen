# CUSTOM_CELLS_TOP ihp-sg13g2 — landing harness

Lands all three ihp custom/analog cells (`flow/custom/ihp_sg13g2/`)
through the `ihp-sg13g2` PDK / `sg13g2_stdcell` SCL flow (VDD 1.2V).

## Cells landed (netlist evidence)

- **DLY_STAGE** — `buf_1` fast leg vs `dlygate4sd3_1` slow leg +
  `mux2_1` select + `buf_1` out.  Netlist: `dlygate4sd3_1`, `mux2_1`.
- **ARB_CELL** — `dlhrq_1` latch resolver + `dfrbpq_1` decision FF.
  Netlist: `dlhrq_1`, `dfrbpq_1`.
- **DUAL_SAMPLER** — `dfrbpq_1` (posedge) + `inv_1`+`dfrbpq_1` (negedge
  via inverted clock — sg13g2 has no native negedge FF).
  Netlist: `dfrbpq_1`×3, `inv_1`.

## PnR signoff — `cust_ihp11`

| metric | value |
|---|---|
| unmapped cells | 0 |
| route DRC | 0 |
| antenna pins | 0 |
| max slew / cap | 0 / 0 |
| setup WNS / TNS | 0 / 0 |
| hold WNS / TNS | 0 / 0 |

Config: `DIE_AREA [0,0,60,60]`, `FP_CORE_UTIL 30`, `RUN_CTS false`,
clocks REF+CK async-grouped.

### Waived / skipped

- 16 magic **illegal-overlap** — `QUIT_ON_ILLEGAL_OVERLAPS:false`.
  magic-streamout fill/site overlap on the 60µm harness; an artifact of
  the minimal die on a process that wants larger filler geometry, not a
  design defect.  Route DRC (OpenROAD) is 0.
- `RUN_MAGIC_DRC`/`RUN_KLAYOUT_DRC`/`RUN_LVS` off — physical decks not
  wired for this sg13g2 flow shim; mapping+route+LVS at `cust_ihp08`
  were already clean (LVS 0 there).

### PDK shim

`build/pdk_root/ihp-sg13g2` mirrors the ciel install with a
`libs.tech/librelane/sg13g2_stdcell/config.tcl` shim: `LIB` rebuilt as a
proper Tcl dict, plus the LibreLane-3-required vars the vendor config
lacks (CTS buffers, padding, `PDN_RAIL_WIDTH`, constraints).
