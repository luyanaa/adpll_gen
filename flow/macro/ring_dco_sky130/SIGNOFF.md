# Ring DCO sky130 result

- DRC: sky130A KLayout DRC, **0 violations**.
- Layout extraction: official `sky130_fd_sc_hd` KLayout LVS deck in `deep`
  mode, using the `~/.ciel` sky130A PDK and native-cell CDL/SPICE views.
- LVS: **PASS (topology)**. netgen 1.5.325, official
  `sky130A_setup.tcl`, reports `Circuits match uniquely`.
- Evidence:
  - `PLL_RING_DCO_PHYS_lvs_netgen.rpt` — final `Circuits match uniquely`
  - `PLL_RING_DCO_PHYS_lvs_netgen.log` — command and netgen log
  - `PLL_RING_DCO_PHYS_extracted.cir` — KLayout deep-mode extracted netlist
  - `PLL_RING_DCO_PHYS_lvs_klayout.log` — official-deck run (see caveat)
  - `PLL_RING_DCO_PHYS_drc.lyrdb`, `PLL_RING_DCO_PHYS_drc.log`
- Reproduce:
  `python3 flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py PLL_RING_DCO_PHYS`

## Caveat

The official KLayout deck's own numeric compare still reports a top-pin /
net-name mismatch on this macro.  The extracted functional netlist and the
normalized native-cell reference match under netgen with the official sky130
setup: unique topology match with all top-level functional cells and the
merged decap/tie devices (489 compared top-level devices, 549 nets).  The
normalization is limited to library-view differences (native `VNB` vs
extracted `sky130_gnd`, CDL `m=N` multiplicity, the `conb_1` poly-short tie
cell, and the unused `INJ_EN` port).  This is **not** a full production
signoff; the separate `macro_char` campaign covers STA and functional/PVT characterization.  No random-jitter or phase-noise signoff is claimed.

## Characterization (2026-11-01)

- Gate-level OpenSTA TT/SS/FF: **PASS**, WNS +9.51/+9.28/+9.59 ns.
- Functional fix: the old `PLL_CELL_NOR2BX1` wrapper drove
  `sky130_fd_sc_hd__nor2b_2` as `.A(A0), .B_N(B0)`, which is
  `!DCO_EN & INJ_WIN`.  `PLL_RING_DCO_PHYS` ties `INJ_WIN=0`, so
  `DCO_EN_INJ_WIN` was held at 0 and the sym-mux never passed the
  oscillator.  The wrapper now drives `.A(B0), .B_N(A0)`, giving the
  intended `A0 & !B0`; the rebuilt netlist has `.A(0), .B_N(DCO_EN)`.
- Post-fix transient: **FF 43.08 MHz**, **TT 27.64 MHz**, **SS 13.48 MHz**
  (minimum code; SS is a two-edge one-period estimate).  FF deterministic
  period RMS 4.4 ps, TT 36.4 ps; no random-jitter or phase-noise claim.
  See `flow/characterization/macro_char/ring_pvt.json` and
  `CHARACTERIZATION.md`.
- Evidence: `flow/characterization/macro_char/CHARACTERIZATION.md`,
  `ring_pvt.json`, `sta_summary.json`.
