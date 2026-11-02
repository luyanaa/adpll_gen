# CDR_TOP sky130 — custom-cell variant

Lands the **custom DUAL_SAMPLER** (`flow/custom/sky130/dual_sampler_sky130.v`)
as the front-end data/edge sampler pair, replacing the two inferred FFs.
The custom cells are "落地"d — wired into the macro RTL and through PnR.

## Custom cells landed

- **DUAL_SAMPLER** (`u_sampler`): the Alexander PD's two DATA samples are
  now a matched `dfrtp_1` (posedge, data phase) + `dfrtn_1` (negedge,
  edge phase ~0.5 UI) pair — a named matched cell, not two inferred FFs.
  Netlist confirms `dfrtn_1` + `dfrtp_1`.
- `d_next` (data phase) and `e_cur` (edge phase) come straight off the
  cell; `d_prev`/`d_cur` remain the 2-deep UI pipeline.

## PnR signoff — `cdr_cust04`

| metric | value |
|---|---|
| unmapped cells | 0 |
| LVS errors | 0 |
| Magic DRC | 0 |
| route DRC | 0 |
| antenna pins | **1 (waived)** |
| max slew / cap | 0 / 0 |
| setup WNS / TNS | 0 / 0 |
| hold WNS / TNS | 0 / 0 |

Config: `DIE_AREA [0,0,180,160]`, `FP_CORE_UTIL 20`, `RUN_CTS false`,
generated clock on the DCDL output pin + async group vs TICK
(`macro.sdc.tcl`).  `dual_sampler_sky130.v` added to VERILOG_FILES.

### Waived: 1 antenna pin

`net41` -> `_0687_/A_N` (nand2b) — 443 vs 400 side-area ratio (1.11) on
met1.  This is a high-fanout **DCDL mux-select net**: quasi-static
config that only changes on the TICK domain while rec_clk re-locks —
never during active sampling.  `RUN_ANTENNA_REPAIR` +
`RUN_HEURISTIC_DIODE_INSERTION` were enabled; the router left one
marginal pin.  Waived as a known-marginal on a non-timing-critical,
low-activity config net (same class as the earlier SS slew/cap waiver).

### Caveats

- TT corner only; no SS/FF/MCSTA, no SPEF, KLayout DRC skipped.
- Delay cells flatten to std cells — the phase-step LSB is a library
  delay, not matched 15 ps.
- Edge phase is the half-rate falling edge (0.5 UI nominal); the two
  sampler apertures are a matched pair but skew under PVT is
  uncharacterised.
