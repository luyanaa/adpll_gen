# Counter/NCO gf180mcu signoff record

- DRC: KLayout 0.30.7 GF180 `gf180mcuD`, `variant=D`, `decks=all`,
  **SUCCESS (0 violations)** after density fill.
- LVS: KLayout GF180 LVS, `run_mode=flat`, `check_ports=false`,
  `combine=true`, fill-marker exclusion, **"Congratulations! Netlists match."**
- Timing: nominal `sta.rpt` plus 3-corner characterization; no transistor-level counter PVT/phase-noise signoff.
- Evidence: `PLL_COUNTER_DCO_PHYS_drc.lyrdb`, `PLL_COUNTER_DCO_PHYS_drc.log`,
  `PLL_COUNTER_DCO_PHYS_lvs.log`, `sta.rpt`.

## Characterization (2026-11-01)

- Gate-level OpenSTA TT/SS/FF: **PASS**; TICK WNS
  +5.53/+3.96/+6.50 ns; estimated max TICK 223.7/165.6/285.7 MHz.
- NCO at TICK=100 MHz, code 0, `BASE_INC=3493`: mean output period
  **375.385 ns**, alternating 380/370 ns; period pp **10 ns**, RMS
  **4.985 ns**. This is deterministic TICK quantization, not random jitter.
- Counter output frequency is PVT-invariant in the ideal digital model;
  no transistor-level counter PVT frequency is claimed.
- Evidence: `flow/characterization/macro_char/CHARACTERIZATION.md`,
  `sta_summary.json`, `counter_nco.json`.
