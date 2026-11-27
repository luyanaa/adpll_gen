# KLayout LVS extraction of the 127-finger element bank

Deck : PDK sg13g2.lvs (KLayout 0.30.12), net_only extraction
Input: dll8_elem_shared_well.gds (proven KLayout DRC 0, 127 fingers, shared
31/0+32/0 over the P group), topcell dll8_elem_shared_well_top.

## Extracted device counts (out/lvs/elem_extracted.cir)
| device                         | count |
|--------------------------------|-------|
| sg13_moscap_n w=1u l=1u        |  64   |
| sg13_moscap_p w=1u l=1u        |  63   |
| nmos switch (sg13_lv_nmos)     |  64   |
| pmos switch (sg13_lv_pmos)     |  63   |
| sg13g2_inv_4                   |   2   |

Total moscap = 127 (64 even N + 63 odd P) == DLL8_ELEM_PHYS, plus the two
inv_4 stages.  Switch counts match (64 nmos even / 63 pmos odd).

## DECISIVE: moscap_p inside the shared nBuLay
`moscap_p` inside the shared nBuLay **DOES extract as `sg13_moscap_p`**
(63 instances, w=1u l=1u).  It does NOT collapse to a plain device or vanish.
The shared-well construction (one 31/0 + 32/0 rectangle over the whole P
group) is LVS-compatible with per-finger moscap_p extraction.

## Notes
- These are net_only extraction counts (device recognition), not a full
  schematic compare; the bank is not yet routed, so the caps sit on isolated
  nets.  Device recognition / moscap_p-in-shared-well is confirmed.
- PEX (RC) is not available from this flow: see REPORT_pex_tooling.md.
