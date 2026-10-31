# IHP official-deck signoff record — counter/NCO

- PDK: official IHP SG13G2 checkout.
- DRC: official `run_drc.py` maximal + density, **PASS, 0 violations**
  on the legal filled GDS (`PLL_COUNTER_DCO_PHYS.gds`).
  - Activ 38.37%, GatPoly 34.20%
  - Metal1 40.63%, Metal2 40.61%, Metal3 40.99%
  - Metal4 41.76%, Metal5 41.92%
  - TopMetal1 31.52%, TopMetal2 33.69%
- LVS: official `run_lvs.py`, **PASS** on the fill-stripped LVS view,
  using `--ignore_top_ports_mismatch` because the layout pin labels are
  KLayout `A|...`-style while the schematic uses RTL port names.
- Evidence: `PLL_COUNTER_DCO_PHYS_official_drc.log`,
  `PLL_COUNTER_DCO_PHYS_official_drc.lyrdb`,
  `PLL_COUNTER_DCO_PHYS_official_lvs.log`,
  `PLL_COUNTER_DCO_PHYS_official_density.log`.
- Not claimed: PVT/jitter/KDCO, or top-port strict LVS without the waiver.
