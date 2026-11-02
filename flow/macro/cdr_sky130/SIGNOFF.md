# CDR_TOP sky130 status

- Functional model verified (`cdr_top_tb`): Alexander bang-bang PD +
  DCDL phase shifter + DLF converges on a PRBS-7 stream (LOCKED).

## PnR signoff — `cdr_pnr04` (clean)

| metric | value |
|---|---|
| unmapped cells | 0 |
| LVS errors | 0 |
| Magic DRC | 0 |
| route DRC | 0 |
| antenna pins | 0 |
| max slew / cap | 0 / 0 |
| setup WNS / TNS | 0 / 0 |
| hold WNS / TNS | 0 / 0 |

Config: `DIE_AREA [0,0,180,160]`, `FP_CORE_UTIL 20`, `RUN_CTS false`,
single `TICK` clock domain (`macro.sdc.tcl`).

### Run history

- `cdr_pnr01/02` — yosys PROC_DFF "multiple edge sensitive events":
  (a) behavioural samplers used `posedge`/`negedge rec_clk` on the same
  net (wrapped in `ifdef SIMULATION`); (b) `!RST_N || !EN` put EN in
  the async-reset term of the lock regs — split into a synchronous
  `else if(!EN)` gate.
- `cdr_pnr03` — DRC/LVS/ant/slew/hold all 0; one setup violator
  `TICK -> REC_CLK` (-2.66 ns).  `REC_CLK` is a recovered *clock*
  (TICK through the DCDL), not a synchronous data output ->
  `set_false_path -to REC_CLK`.
- `cdr_pnr04` — passes.

### Caveats (not claimed)

- TT corner only; no SS/FF/MCSTA, no SPEF, KLayout DRC skipped.
- Physical sampler path is a stub (`d_*`/`e_cur` tied off) — the real
  CDR needs two matched sampler FFs on two DCDL taps at 0.5 UI offset.
  Loop convergence signoff still requires a mixed-signal sim.
- Alexander early/late sign vs code direction validated only to
  "loop converges" level (see CDR_SPEC).
