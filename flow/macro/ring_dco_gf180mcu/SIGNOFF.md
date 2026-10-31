# Ring DCO gf180mcu signoff record

- DRC: KLayout 0.30.7 GF180 `gf180mcuD`, `variant=D`, `decks=all`,
  **SUCCESS (0 violations)** after density fill.
- LVS: KLayout GF180 LVS, `run_mode=flat`, `check_ports=false`,
  `combine=true`, fill-marker exclusion, **"Congratulations! Netlists match."**
- Timing: nominal `sta.rpt` plus 3-corner characterization; no random-jitter/phase-noise signoff.
- Evidence: `PLL_RING_DCO_PHYS_drc.lyrdb`, `PLL_RING_DCO_PHYS_drc.log`,
  `PLL_RING_DCO_PHYS_lvs.log`, `sta.rpt`.

## Characterization (2026-11-01)

- Gate-level OpenSTA TT/SS/FF: **PASS**, WNS +8.02/+7.78/+8.17 ns.
- Ring PVT transient (minimum delay code): TT/SS/FF =
  **21.07/15.74/26.60 MHz** (47.469/63.522/37.589 ns).
- Settled deterministic period spread at TT: pp 0.24 ps, RMS 0.11 ps.
  This is a noiseless transient spread, **not** random jitter or phase
  noise. No Pnoise result exists.
- The transient uses the cell-level macro view, not routed RC.
- Evidence: `flow/characterization/macro_char/CHARACTERIZATION.md`,
  `sta_summary.json`, `ring_pvt.json`, `ring_tuning.json`.
