# IHP official-deck signoff record — counter/NCO

- PDK: official IHP SG13G2 checkout.
- LVS: official `run_lvs.py`, **PASS** on the fill-stripped LVS view,
  using `--ignore_top_ports_mismatch` (same top-port naming waiver as ring).
- DRC maximum-rule + fill rules: **PASS, 0 violations** with density disabled
  (`PLL_COUNTER_DCO_PHYS_official_drc_nodensity.log`).
- Density-only official run: **FAIL** on `M2.j`/`M3.j` (about 32–33% versus
  35% minimum on this larger macro).  Full official DRC is therefore **not
  closed** and is not claimed.
- Evidence: `PLL_COUNTER_DCO_PHYS_official_lvs.log`,
  `PLL_COUNTER_DCO_PHYS_official_lvs.lvsdb`,
  `PLL_COUNTER_DCO_PHYS_official_drc_nodensity.log`,
  `PLL_COUNTER_DCO_PHYS_official_density.log`.
