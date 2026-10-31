# IHP official-deck signoff record — ring DCO

- PDK: official IHP SG13G2 checkout
  `/home/yanlu/.ciel/ciel/ihp-sg13/versions/89d42ee6d2fd9b50b86a1aada6fee6673c3e6008/ihp-sg13g2`
- DRC: official `run_drc.py` (maximal + density), **PASS, 0 violations**
  on the flow-generated legal fill (`PLL_RING_DCO_PHYS.gds`).
- LVS: official `run_lvs.py`, **PASS** on the fill-stripped LVS view.
  The pass uses `--ignore_top_ports_mismatch`; the layout pin labels are
  `A|...`-style while the schematic uses the RTL port names.  This is a
  top-port naming waiver, not a device-level waiver.
- Evidence: `PLL_RING_DCO_PHYS_official_drc.log`,
  `PLL_RING_DCO_PHYS_official_drc.lyrdb`,
  `PLL_RING_DCO_PHYS_official_lvs.log`,
  `PLL_RING_DCO_PHYS_official_lvs.lvsdb`.
- Not claimed: PVT/jitter/KDCO, or top-port strict LVS without the waiver.
