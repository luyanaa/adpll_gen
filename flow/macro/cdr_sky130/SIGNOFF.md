# CDR_TOP sky130 status

- Functional model verified (`cdr_top_tb`): Alexander bang-bang PD +
  DLF re-encode + DCDL phase shifter; locks (PHASE_CODE=0), clean output.

## Stdcell substitutions (this revision)

- **Dual data/edge samplers**: the behavioural `ifdef SIMULATION` sampler
  stubs are gone — the two Alexander samples are now real FFs.
  - data phase -> `posedge rec_clk`  (sky130 `dfrtp`)
  - edge phase -> `negedge rec_clk`  (sky130 `dfrtn`, the falling-edge DFF)
  Both phases are standard cells; the 0.5-UI edge offset is the half-rate
  falling edge — the stdcell-only approximation of a matched 0.5-UI
  delay.  Netlist confirms `dfrtn_1` + 66 `dfrtp_1` mapped.
- A finer/matched edge phase (second DCDL tap at a fixed 0.5-UI offset)
  remains analog/custom work; not done.

## Clock-domain handling

`rec_clk` now drives real sampler FFs, so it is a genuine internal clock
(a DCDL phase-shift of TICK), not a dead stub.  `macro.sdc.tcl`:

- `create_generated_clock REC_CLK` anchored on the DCDL output pin
  (`dcdl.u_fine.stage[30].impl.inv_1.impl/Y`) so the sampler FFs and the
  delay-stage selects land in the rec_clk domain.
- `set_clock_groups -asynchronous -group {TICK} -group {REC_CLK}` —
  serial DATA is async; the loop hands off through quasi-static
  PHASE_CODE, so the domains are checked independently.
- `set_false_path -from DATA` (async serial input).
- `set_disable_timing` on each delay-stage select nand input
  (`mid.impl`/`A_N`, `upp.impl`/`A`): the tap selects are quasi-static
  config on the rec_clk clock network, not a timed path — waives the
  clock-gating hold check.

## PnR signoff — `cdr_pnr08` (clean)

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

Config: `DIE_AREA [0,0,180,160]`, `FP_CORE_UTIL 20`, `RUN_CTS false`.

### Caveats (not claimed)

- TT corner only; no SS/FF/MCSTA, no SPEF, KLayout DRC skipped.
- Delay cells flatten to std cells — the phase-step LSB is a
  library-cell delay, not a matched 15 ps.
- Edge phase is the half-rate falling edge (0.5 UI nominal), not a
  matched/interpolated 0.5-UI tap; jitter/asymmetry not characterised.
- The single `dfrtn` edge sampler gives one edge-phase sample per UI; a
  production CDR would want matched data/edge sampler pairs.
