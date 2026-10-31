# Hard macros

| Macro | PDK / stdcell | Status |
|---|---|---|
| `PLL_ANALOG_MACRO` | ics55 H7CR | 160×100; top-level DRC 0; 305 cell-internal waived (remaining 0); **LVS PASS**; density fill |
| `PLL_ANALOG_MACRO` | IHP SG13G2 `sg13g2_stdcell` | 160×105; route DRC 0; **minimal-deck DRC 0 with density fill**; **LVS PASS** on fill-stripped LVS view |
| `PLL_ANALOG_MACRO` | gf180mcu `gf180mcu_as_sc_mcu7t3v3` | 85.6×103.6; 80/80 P&R; route DRC 0; **DRC 0**, **LVS PASS** (fill-marker shim); GDS/LEF/Liberty/CDL/DEF |
| `PLL_ANALOG_MACRO` | sky130 `sky130_as_sc_hs` | 80.2×90.9; 80/80 P&R; route DRC 0; **KLayout DRC 0**; **PDN fixed** (0 PSM unconnected); LVS still fails cell-subcircuit device/pin comparison |
| `PLL_ANALOG_MACRO` | sky130 `sky130_fd_sc_hd` | 79.7×90.4; route/fill; **KLayout DRC 0**; **PDN fixed**; LVS still cell-subcircuit comparison; full CDL available |
| `PLL_RING_DCO_PHYS` | ics55 H7CR | 120×120; physical ring macro; GDS/LEF/LIB/CDL/DEF; DRC/LVS not clean |
| `PLL_COUNTER_DCO_PHYS` | ics55 H7CR | 96.3×102.7; digital NCO/counter; GDS/LEF/LIB/DEF; DRC/LVS not clean |
| `PLL_RING_DCO_PHYS` | gf180mcu `gf180mcu_as_sc_mcu7t3v3` | **DRC 0, LVS PASS** after density fill; GDS/LEF/LIB/CDL/DEF/SPICE; nominal STA only |
| `PLL_COUNTER_DCO_PHYS` | gf180mcu `gf180mcu_as_sc_mcu7t3v3` | **DRC 0, LVS PASS** after density fill; GDS/LEF/LIB/CDL/DEF/SPICE; nominal STA only |
| `PLL_RING_DCO_PHYS` | IHP SG13G2 `sg13g2_stdcell` | **DRC 0 (ORFS minimal deck), LVS PASS** on fill-stripped GDS; nominal STA only |
| `PLL_COUNTER_DCO_PHYS` | IHP SG13G2 `sg13g2_stdcell` | **DRC 0 (ORFS minimal deck), LVS PASS** on fill-stripped GDS; nominal STA only |
| `PLL_RING_DCO_PHYS` | sky130 `sky130_fd_sc_hd` | **DRC 0**; LVS **FAIL** (cell/top netlist view); experiment only |
| `PLL_COUNTER_DCO_PHYS` | sky130 `sky130_fd_sc_hd` | **DRC 0**; LVS **FAIL** (cell/top netlist view); experiment only |

Each macro directory contains a wrapper, macro-only SDC and a Makefile or
LibreLane config.  The ics55/IHP builds use the ckdur OpenROAD flow; gf180 and
sky130 use LibreLane with local PDK shims because their PDKs do not ship a
complete LibreLane top-level config in this checkout.

The ics55 macro uses `flow/maps/ics55_lefdef.map` (a LEF/DEF map, not the PDK
GDS-import map), `add_density_fill.rb` and an explicit cell-internal DRC
waiver.  The IHP macro uses `flow/macro/ihp130_sg13g2/add_density_fill.rb` on
the IHP FILL layers with NODRC markers; its LVS is run on a fill-stripped
view.  GF180 and IHP have DRC/LVS evidence.  IHP uses the ORFS minimal deck and
flow-local fill-stripped LVS view, not the official IHP deck.  sky130 has DRC 0
but LVS still fails at the cell/top netlist view; it is recorded as an
experiment, not a passing signoff.

FreePDK45 is included as a planning-only predictive profile/library; see
`FREEPDK45.md`.  It has no physical GDS/DRC/LVS signoff path in this checkout.
