# DLL8 custom bank — signoff record (2026-11-28)

## Final artifacts
| artifact | file | DRC (KLayout 0.30.12) | LVS |
|---|---|---|---|
| 127-finger array (NY=5000/PY=5500 pitch) | dll8_line_array.gds | 0 (final_drc_arr.lyrdb) | — |
| element macro (bank + 2x inv_4 + IN/MID/OUT + rails) | dll8_elem_macro.gds | 0 (final_drc_elem.lyrdb) | **MATCH** (elem_macro_lvs_MATCH.log) |
| 4-element line macro (chain + TAP[3:0] + ctrl escapes) | dll8_line4.gds | 0 (final_drc_line4.lyrdb) | **MATCH** (line4_lvs_MATCH.log) |

Reference netlists: dll8_elem.cdl (gen_elem_cdl.py), dll8_line4.cdl (gen_line4_cdl.py).
Final extraction: out/lvs/elem_macro_final_extracted.cir — 64 nmos sw + 63 pmos sw
+ 64 sg13_moscap_n + 63 sg13_moscap_p + 2x inv_4 FETs + 2 taps.

## Critical LVS usage fact
The compare MUST use `-rd ignore_top_ports_mismatch=true` (equivalently the
run_lvs.py `--ignore_top_ports_mismatch` flag used by the PDK's own regression
in testing/run_regression.py). Strict port mode is a FALSE NEGATIVE generator
in this environment: it fails even the PDK's own sg13_lv_nmos unit testcase
(verified 2026-11-28); with the flag, the same testcase passes. An afternoon of
"Netlists don't match" iterations was this artifact, not a circuit error.
Independent isomorphism check (net-signature multiset comparison) confirmed
extracted vs reference topology identical: 262 nets / 260 devices exact.

## moscap_n pitch rule (measured)
The deck's moscap extractor sizes device cores by 1.5 um and requires exactly
one core per merged dev_mk blob. moscap_n core vertical extent is 1.74 um in
the finger cell -> sized reach 4.74 um. Adjacent N caps MUST be pitched
>= 4.1 um (measured threshold: 4.0 merges/rejects all, 4.1 extracts cleanly);
array uses NY=5000 (N rows), PY=5500 (P rows).

## Integration contract
- Control straps ENk_j (k=element 0..3, j=finger 0..126, thermometer ascending):
  N fingers (even j) ON when strap HIGH; P fingers (odd j) ON when strap LOW.
  Decoder must emit strap[j] = th[j] XOR (j odd). Quasi-static DC, no buffers.
- TAP[3:0]: identical straight M2 drops from E[k].OUT — length-matched by
  construction (inter-element element-to-pin x-shift identical per strip).
- Chain: E0.OUT -> E1.IN -> E2.OUT -> E3.IN on M2 (within macro).
- Power: continuous VDD/VSS rails, boundary pins IN/OUT/VDD/VSS per build_line4.py.

## PEX status (documented tooling gap)
No RCX capability exists in this PDK/KLayout/Magic flow (REPORT_pex_tooling.md).
ITF first-order: MID bus R~105 ohm, wire C 35-64 fF = 2-4% of 1.626 pF bank.
Impact analysis: additive at all codes -> range barely moves; even +30 ps on FF
BASE keeps fast-end far inside spec. Tap spread decisive item lives in
tap-output routing (byte-identical across strips -> common-mode inside bank).
