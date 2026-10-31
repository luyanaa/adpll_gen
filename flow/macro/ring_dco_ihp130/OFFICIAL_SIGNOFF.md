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
- Characterization (2026-11-01): gate-level STA TT/SS/FF PASS; ring transient PVT 33.21/20.95/47.58 MHz; deterministic period RMS <=1.44 ps. No random-jitter/phase-noise signoff.
- Not claimed: random-jitter/phase-noise, SPEF-annotated STA (SPEF names do not match this netlist), or strict LVS without the waiver.
