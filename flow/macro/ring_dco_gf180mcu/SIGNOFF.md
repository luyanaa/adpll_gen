# Ring DCO gf180mcu signoff record

- DRC: KLayout 0.30.7 GF180 `gf180mcuD`, `variant=D`, `decks=all`,
  **SUCCESS (0 violations)** after density fill.
- LVS: KLayout GF180 LVS, `run_mode=flat`, `check_ports=false`,
  `combine=true`, fill-marker exclusion, **"Congratulations! Netlists match."**
- Timing: nominal STA only in `sta.rpt`; no PVT/jitter signoff.
- Evidence: `PLL_RING_DCO_PHYS_drc.lyrdb`, `PLL_RING_DCO_PHYS_drc.log`,
  `PLL_RING_DCO_PHYS_lvs.log`, `sta.rpt`.
