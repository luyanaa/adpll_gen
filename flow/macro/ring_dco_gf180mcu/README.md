# Core B ring DCO on gf180mcu

This is the DRC/LVS-clean second-PDK physical variant of `PLL_RING_DCO_PHYS`.

- Top: `PLL_RING_DCO_PHYS`
- PDK/library: `gf180mcu_as_sc_mcu7t3v3` (3.3 V)
- Flow: LibreLane P&R + local `def2stream` + GF180 density fill
- Views: `LEF/LIB/GDS/CDL/DEF/Verilog/SPICE` in this directory
- DRC: **0 violations** (KLayout 0.30.7, `gf180mcuD`, `variant=D`, after density fill)
- LVS: **PASS** (KLayout GF180 LVS with flow-local fill-marker exclusion)
- STA: nominal `sta.rpt` plus 3-corner characterization; no random-jitter/phase-noise signoff

Build/flow notes:
```sh
# P&R (KLayout streamout inside LibreLane is skipped; use def2stream below)
librelane --manual-pdk \
  --pdk-root /opt/adpll_gen/flow/canary/gf180mcu_as_sc_core_a/pdk_overlay \
  --pdk gf180mcu --scl gf180mcu_as_sc_mcu7t3v3 config.yaml
# then stream the final DEF with signoff/tcl/def2stream.py and add GF180 fill
```

The fill-marker LVS exclusion is the same documented flow-local shim used for
`flow/macro/gf180mcu/PLL_ANALOG_MACRO`; it is not a change to the foundry deck.
The ring has gate-level STA and cell-level transient PVT characterization, but the current layout does
not satisfy the symmetry contract in `SYMMETRY.md`.

- Characterization: gate-level STA TT/SS/FF PASS; ring transient PVT
  TT/SS/FF 21.07/15.74/26.60 MHz; deterministic period RMS <=0.26 ps.
  No random-jitter or phase-noise claim. See
  `flow/characterization/macro_char/CHARACTERIZATION.md`.
