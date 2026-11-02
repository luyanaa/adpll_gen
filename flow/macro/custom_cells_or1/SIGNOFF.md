# CUSTOM_CELLS_TOP — OR1 / OpenRule1um landing (synthesis-verified)

Lands the three custom/analog cells on `or1_fd_sc` (1um, 3-metal, 5.0V).
Per the requirement this PDK is **synthesis-only** — no timing target.
Result: the cells map to real `or1_fd_sc` leaf cells and are wired into
the harness top; placement is blocked by an OR1 LEF defect (below).

## Cells landed (flow/custom/or1)

`or1_fd_sc` is a minimal SCL — `INVX1`, `BUFX2`, `CLKBUFX2`, `NAND2X1`,
`NOR2X1`, `DFFPOSX1`, `DFFRX1/2`, `TIEHI`, `TIELO` — **no** delay cell,
mux2, latch, or negedge FF.  Each cell is rebuilt from primitives:

- **DLY_STAGE** — fast `INVX1`×2 vs slow `INVX1`×4 legs (LSB = one extra
  matched inverter pair) + a three-NAND 2:1 mux.
- **ARB_CELL** — NAND-gated SR-latch resolver (no latch cell exists) +
  `DFFRX1` decision FF (`RST_B` inverted once for the active-HIGH reset).
- **DUAL_SAMPLER** — `DFFRX1` posedge (data) + `DFFRX1` on an
  `INVX1`-inverted clock (edge, ~negedge — same trick as ihp).

## Synthesis evidence — `cust_or1_08` netlist

`19-openroad-tapendcapinsertion/CUSTOM_CELLS_TOP.nl.v` keeps the
custom-cell hierarchy and maps to leaf cells:

| instance | cells |
|---|---|
| `u_dly` | `u_f0/u_f1` (fast), `u_s0/u_s1` (slow), `u_sb/u_ns/u_nb/u_mx` (mux) — `INVX1` + `NAND2X1` |
| `u_arb` | `u_db/u_set/u_rst/u_q/u_qb` (SR latch) + `u_dec` = `DFFRX1` |
| `u_ds`  | `u_pos`/`u_neg` = `DFFRX1`×2, `u_cinv`/`u_rinv` = `INVX1` |

- `design__instance_unmapped__count = 0`
- Lint clean (Verilator + lint checkers).
- Floorplan, PDN generation, IO placement, global placement all ran.

## Placement blocker (OR1 LEF defect, not our cells)

Detailed placement fails on exactly the three `DFFRX1` instances
(`u_arb.u_dec`, `u_ds.u_pos`, `u_ds.u_neg`) — `[DPL-0036]`.  Cause: every
`or1_fd_sc` cell declares `SYMMETRY Y` only and the `unit` SITE declares
no symmetry, so DPL cannot legalize the wide (84-site) FF onto a row in
any orientation.  `DFFPOSX1`/`DFFRX2` share the same LEF pattern — a PDK
geometry/symmetry defect.  For a synthesis-only landing this is out of
scope; the netlist/mapped evidence above is the deliverable.

## PDK shim

`build/pdk_root/or1/` — `libs.ref` symlink to
`/grid/OpenRule1um/OR1PDK/OR1/libs.ref`, `libs.tech/{magic,klayout,
netgen,...}` symlinks, plus a hand-written `libs.tech/librelane/
config.tcl` supplying the LibreLane-3 variables the PDK's OpenLane-1.x
config predates.  `libs.ref_local/or1_fd_sc/verilog/or1_fd_sc_bb.v` is
the PDK's own empty-body blackbox, used because the shipped `or1_fd_sc.v`
mis-blackboxes (its bare `if(RESET)q<=0;else` line is stripped by
LibreLane's naive model preprocessor, leaving a dangling `else`).

## Caveats

- Single corner (TT 5.0V 25C is the only characterized lib); no MCSTA.
- KLayout/Magic/LVS skipped (placeholder decks); synthesis+placement
  intent only.  No production/PVT/jitter signoff.
- `.lib` FFs have no `QB` pin (verilog model declares one — a model/lib
  mismatch; the cells connect `.Q()` only).
- The tap LSB is a 2×`INVX1` insertion delay, not a delay-tuned cell —
  a weaker "matched" claim than sky130/ihp/gf180mcuD.
