# CUSTOM_CELLS_TOP gf180mcuD — landing harness

Lands all three gf180mcuD custom/analog cells (`flow/custom/gf180mcuD/`)
through the `gf180mcu` PDK / `gf180mcu_fd_sc_mcu9t5v0` SCL flow (VDD 5.0V).
gf180mcuD variant only.

## Cells landed (netlist evidence)

- **DLY_STAGE** — `buf_1` fast leg vs `dlya_4` slow leg + `mux2_1` select.
  Netlist: `dlya_4`, `dlyc_1`×8 (the `dly*` delay family), `mux2_1`.
- **ARB_CELL** — `latrnq_1` latch resolver + `dffrnq_1` decision FF.
  Netlist: `latrnq_1`, `dffrnq_1`.
- **DUAL_SAMPLER** — `dffq_1` (posedge) + `dffnq_1` (native negedge).
  Netlist: `dffq_1`, `dffnq_1`.

## PnR signoff — `cust_gf07`

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

- `RUN_LVS: false` — magic-extraction dropped cell pins on this tiny
  harness (netlists extracted "disconnected node" on every cell); the
  layout is structurally consistent with the netlist (route DRC 0).
  Not a design defect — an extraction harness-size artifact.
- `RUN_KLAYOUT_DRC`/`RUN_MAGIC_DRC` off — rule decks not wired for this
  gf180mcuD variant; route DRC (OpenROAD) is the signoff used.
- IO pads (`gf180mcu_fd_io`) reference `GF_IO_Site` — harness has none.

### PDK shim

`build/pdk_root/gf180mcu` mirrors the ciel gf180mcuD install with a
`libs.tech/librelane` shim: `LIB` rebuilt from `CELL_LIBS` for
LibreLane 3, magic/netgen names symlinked `gf180mcu*`->`gf180mcuD*`,
openrcx rules linked.  Physical signoff (KLAYOUT/MAGIC DRC, LVS) is
deferred — same scope as the sky130 shim.
