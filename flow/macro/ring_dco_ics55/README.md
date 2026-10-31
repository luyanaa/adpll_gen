# Core B ring DCO (ics55 H7CR)

This directory contains the physical Core B ring-DCO macro, not the old
behavioral `PLL_RING_DCO` model.

- Top: `PLL_RING_DCO_PHYS`
- Topology: fixed `BASE_NDELS=256` inverter bank + coarse/mid/fine delay cells
  and the symmetric output stage
- Injection: disabled; `REF` is only the SS-BBPD reference
- Views: `PLL_RING_DCO_PHYS.lef`, `.lib`, `.cdl`, `.def`, `.gds`, `.v`
- Size: 120 x 120 um
- Build: `make -C flow/macro/ring_dco_ics55 pnr` (then `gds`) with the local
  ics55 PDK and `USE_DOCKER=0`

The macro was placed and routed with the ckdur OpenROAD flow using
`SKIP_PLL_POS=1`, `SKIP_CLK_ISOLATE=1` and `SKIP_CTS=1`.  The GDS exists but
this is **not** a DRC/LVS/timing/PVT signoff: the ring is a free-running
analog-like loop and its frequency, tuning range, jitter and PVT behavior have
not been characterized.  Do not use a Core A DCO manifest for this macro.

A clean checkout must rebuild the ignored generated views before claiming
`BUILT` in `macro_inventory.json`.
