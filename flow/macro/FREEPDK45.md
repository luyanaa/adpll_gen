# FreePDK45 in the generator flow

FreePDK45 is included as a **planning-only predictive PDK**:

- `flow/generator/pdk_profiles.json` -> `freepdk45` (high class, 300 MHz
  architecture ceiling, no signoff ceiling)
- `flow/libraries.json` -> `freepdk45`/`osu_soc` (`pnr_ready: false`,
  `drc_lvs: not-run`)
- `src/pll_cells_freepdk45.v` -> functional `PLL_CELL_*` wrappers for the OSU
  `gscl45nm` cell set

The local checkout has Liberty/LEF/SPICE/Verilog views under
`/grid/predictive/FreePDK45/FreePDK45/osu_soc`, but no GDS standard-cell
views or DRC/LVS path.  It therefore remains `RTL_SYNTHESIZABLE`; select it
with `--mode explore --allow-experimental`, not as a physical macro/signoff
target.  `PLL_CELL_NAND2BX1`/`NOR2BX1` use an inverter plus a base gate, and
`NAND3X8`/`INVX5`/`INVX9` are functional planning mappings, not drive-strength
equivalents.  No FreePDK45 GDS/DRC/LVS result is claimed.
