# Ring DCO IHP SG13G2 evidence

- DRC: `sg13g2_minimal.lydrc`, filled GDS, **0 violations**
- LVS: `sg13g2.lvs`, fill-stripped GDS, **"Congratulations! Netlists match."**
- STA: nominal `sta.rpt` plus 3-corner characterization; setup/hold `MET`
- Evidence: `PLL_RING_DCO_PHYS_drc.lyrdb`, `PLL_RING_DCO_PHYS_drc.log`,
  `PLL_RING_DCO_PHYS_lvs.log`, `sta.rpt`
- Not claimed: random-jitter/phase-noise, SPEF-annotated STA, or strict LVS without the top-port waiver

## Characterization (2026-11-01)

- Gate-level OpenSTA TT/SS/FF: **PASS**, WNS +9.44/+9.24/+9.55 ns.
- Ring PVT transient (minimum delay code): TT/SS/FF =
  **33.21/20.95/47.58 MHz** (30.111/47.729/21.018 ns).
- Settled deterministic period spread at TT: pp 3.26 ps, RMS 1.44 ps.
  This is a noiseless transient spread, **not** random jitter or phase
  noise. No Pnoise result exists.
- The IHP SPEF exists but its instance naming does not match the gate
  netlist; it is not claimed as back-annotated STA here.
- Evidence: `flow/characterization/macro_char/CHARACTERIZATION.md`,
  `sta_summary.json`, `ring_pvt.json`, `ring_tuning.json`.
