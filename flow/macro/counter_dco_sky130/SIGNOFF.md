# Counter/NCO sky130 result

- DRC: sky130A KLayout DRC, **0 violations**.
- Layout extraction: official `sky130_fd_sc_hd` KLayout LVS deck in `deep`
  mode, using the `~/.ciel` sky130A PDK and native-cell CDL/SPICE views.
- LVS: **PASS (topology)**. netgen 1.5.325, official
  `sky130A_setup.tcl`, reports `Circuits match uniquely`.
- Evidence:
  - `PLL_COUNTER_DCO_PHYS_lvs_netgen.rpt` — final `Circuits match uniquely`
  - `PLL_COUNTER_DCO_PHYS_lvs_netgen.log` — command and netgen log
  - `PLL_COUNTER_DCO_PHYS_extracted.cir` — KLayout deep-mode extracted netlist
  - `PLL_COUNTER_DCO_PHYS_lvs_klayout.log` — official-deck run (see caveat)
  - `PLL_COUNTER_DCO_PHYS_drc.lyrdb`, `PLL_COUNTER_DCO_PHYS_drc.log`
- Reproduce:
  `python3 flow/macro/sky130_fd_sc_hd/lvs/run_sky130_lvs.py PLL_COUNTER_DCO_PHYS`

## Caveat

The official KLayout deck's own numeric compare still reports a top-pin /
net-name mismatch on this macro.  The extracted functional netlist and the
normalized native-cell reference match under netgen with the official sky130
setup: unique topology match after the library-view normalization (native
`VNB` vs extracted `sky130_gnd`, CDL `m=N` multiplicity, removed `conb_1`
ideal-resistor/tie view, and the unused `INJ_EN` port).  This is **not** a
full production signoff; the separate `macro_char` campaign covers STA and
functional/PVT characterization.  No random-jitter or phase-noise signoff is
claimed.

## Characterization (2026-11-01)

- Gate-level OpenSTA: TT/FF **PASS** (TICK WNS +5.04/+7.15 ns);
  **SS FAIL at the 100 MHz TICK planning point** (WNS -0.640 ns,
  TNS -1.85 ns). Estimated SS max TICK is 94.0 MHz.
- NCO at TICK=100 MHz, code 0, `BASE_INC=3493`: mean output period
  **375.385 ns**, alternating 380/370 ns; period pp **10 ns**, RMS
  **4.985 ns**. This is deterministic TICK quantization, not random jitter.
- Counter output frequency is PVT-invariant in the ideal digital model;
  no transistor-level counter PVT frequency is claimed.
- Evidence: `flow/characterization/macro_char/CHARACTERIZATION.md`,
  `sta_summary.json`, `counter_nco.json`.
