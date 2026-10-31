# Counter/NCO IHP SG13G2 evidence

- DRC: `sg13g2_minimal.lydrc`, filled GDS, **0 violations**
- LVS: `sg13g2.lvs`, fill-stripped GDS, **"Congratulations! Netlists match."**
- STA: nominal `sta.rpt` plus 3-corner characterization; setup/hold `MET`
- Evidence: `PLL_COUNTER_DCO_PHYS_drc.lyrdb`, `PLL_COUNTER_DCO_PHYS_drc.log`,
  `PLL_COUNTER_DCO_PHYS_lvs.log`, `sta.rpt`
- Not claimed: random-jitter/phase-noise, SPEF-annotated STA, or strict LVS without the top-port waiver

## Characterization (2026-11-01)

- Gate-level OpenSTA TT/SS/FF: **PASS**; TICK WNS
  +6.87/+5.10/+7.90 ns; estimated max TICK 319.5/204.1/476.2 MHz.
- NCO at TICK=100 MHz, code 0, `BASE_INC=3493`: mean output period
  **375.385 ns**, alternating 380/370 ns; period pp **10 ns**, RMS
  **4.985 ns**. This is deterministic TICK quantization, not random jitter.
- Counter output frequency is PVT-invariant in the ideal digital model;
  no transistor-level counter PVT frequency is claimed.
- Evidence: `flow/characterization/macro_char/CHARACTERIZATION.md`,
  `sta_summary.json`, `counter_nco.json`.
