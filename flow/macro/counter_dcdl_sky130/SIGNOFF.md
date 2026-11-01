# ADDLL_TOP sky130 status

- RTL functional model verified (iverilog): loop locks to minimum-delay
  full-period alignment, `DLY_CODE` dithers +/-1 LSB.
- Physical cascade `PLL_COUNTER_DCDL_PHYS` written (COARSE->MID->FINE
  buffered chain).

## PnR signoff — `dcdl_pnr08` (clean)

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

Config: `DIE_AREA [0,0,180,160]`, `FP_CORE_UTIL 20`,
`PL_TARGET_DENSITY_PCT 40`, `RUN_CTS false`, clocks `TICK`/`CLK_IN`
async-grouped, `macro.sdc.tcl` multicycle 4/3 on `PHASE_OFFS`/`DLY_INIT`/`KI`.

### Run history

- `dcdl_pnr01` — Verilator lint: `mid_delay.v` `MID_DELAY_CELL` instance
  connected `.VDD/.VSS` unconditionally while the cell declares them only
  under `ifdef WITH_POWER`; wrapped the instance power pins in `ifdef`
  (both `src/` and flow copy).
- `dcdl_pnr02/03` — 3 unmapped cells: `*_DELAY_CELL` and then the
  parametrised `COARSE_DELAY`/`MID_DELAY_BUFFERED`/`FINE_DELAY_BUFFERED`
  instances were held as `keep_hierarchy` blackboxes, so Yosys never
  expanded them to std cells. Removed `keep_hierarchy` in the flow
  copies (RTL originals keep it for hierarchy docs).
- `dcdl_pnr04` — unmapped 0, LVS 0, DRC 0, antenna 0, slew/cap 0,
  hold 0; setup WNS -5.03 / TNS -77 on `PHASE_OFFS -> tap regs`
  (constant-divisor decode chain in one cycle). Multicycle 4/3 on the
  quasi-static config ports moved the worst path to `DLF_OUT -> tap`.
- `dcdl_pnr05` — same path reg-reg -4.07: `DLF_OUT -> add/offset ->
  saturate -> decode -> tap` is a real per-TICK path.
- `dcdl_pnr06` — added `code_q` pipeline reg after saturation +
  shift-based decode (MID_W=4, COARSE_W=8 are powers of two, so `/`,`%`
  become shifts/slices). WNS -0.91 / TNS -12.8 on `code_q -> tap`.
- `dcdl_pnr07` — added second pipeline stage registering
  `fine_n/mid_n/coarse_n`; setup WNS/TNS = 0. 9 Magic `met4.2` spacing
  DRC remained at x~69.7-70.2um, y~128-130um (net46 hugging the
  x=70.52um VPWR strap near the top die edge).
- `dcdl_pnr08` — die 180x140 -> 180x160, util 25 -> 20, density
  45 -> 40: router got strap-channel margin, all 9 DRC cleared.
  **Flow passes.**

### Caveats (not claimed)

- TT corner only (`nom_tt_025C_1v80`); no SS/FF/MCSTA, no SPEF, no IR
  drop, KLayout DRC runset unset (skipped) — Magic DRC used.
- The delay cells are flattened to std cells (hierarchy removed for
  synthesis), so tap delays are library-cell delays, not the matched
  custom-cell delays of the behavioural model. No jitter / linearity /
  PVT signoff.
- Two pipeline stages add 2 TICKs of loop latency (validated in sim).
