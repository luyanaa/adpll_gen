# Canary status

These are **flow canaries**, not product defaults and not signoff.  Each
directory has its own README, configs, SDC and Yosys/LibreLane driver.

| PDK | Library | Core | Yosys | LibreLane | GDS | DRC/LVS | Hard macro |
|---|---|---|---|---|---|---|---|
| ics55 | `ics55_LLSC_H7CR` | A (IL-DCO) | PASS: 1571 cells, 4321.8 µm² | 80/80, exit 0; route DRC 0, setup/hold 0, antenna 0; KLayout DRC after GDS-map fix: 5734 = 4259 7T-cell + 1453 via-cell + 22 top (density) | written by KLayout | KLayout DRC 5734 (cell/via dominated); original 2312 invalid (wrong map); LVS skipped | not built |
| gf180mcu | `gf180mcu_as_sc_mcu7t3v3` | A (IL-DCO) | PASS: 1690 cells, 49,069 µm² | **80/80**, exit 0, 8:12, with documented skips | skipped (no decks) | not claimed | not built |
| ihp130 | `sg13g2_stdcell` (1.2 V) | A (IL-DCO) | PASS: 1587 cells, 26,243 µm² | layout + RCX + STA + IR + GDS; exits at setup checker | **GDS written** (`final/gds/pll_logic.gds`) | not claimed (no official IHP decks) | not built |

## Key results / findings

- **ics55 H7CR**: the seven Liberty corners are not cell-identical;
  `ss_cworst_1p08_m40` lacks `ICGNX3H7R`, which the TT netlist uses.  The
  canary runs the three PDK-wired corners.  The `nom_*` RCX fallback produced
  duplicate SPEF and broke IR-drop; the canary now overrides `RCX_RULESETS`
  with the three specific patterns.  Magic streamout/DRC are skipped because
  the PDK has no Magic tech; KLayout is the primary streamout/DRC.
  **GDS-map correction**: the original KLayout DRC used the PDK's GDS-import
  map as a LEF/DEF map, so DEF routing/SPNET landed on auto layers and the
  original **2312 is invalid**.  Re-streaming with
  `flow/maps/ics55_lefdef.map` gives **5734 = 4259 7T-cell-internal + 1453
  via-cell + 22 top-level**; the top-level items are density checks, the
  via-cell items are LEF via-pad geometry, and the 7T-cell items are library
  as-drawn.  See `ics55_h7cr_core_a/drc_remap.md`.
- **gf180mcu `as_sc`**: PnR flow completes 80/80, but KLayout/Magic DRC, LVS,
  RCX, post-PnR STA, IR and GDS are skipped because the PDK checkout has no
  decks/OpenRCX rules.  Mid-PnR STA has one r2r setup violation
  **-0.092 ns** at ff/n40C/3.6 V; hold is clean.  The library has no
  scan/enable flops; all async-reset flops map to `dfsrtp_2` with tie-high.
- **ihp130 `sg13g2_stdcell` 1.2 V**: layout, RCX, 3-corner STA, IR drop and
  KLayout GDS complete; routing DRC 0; hold +0.125 ns; setup TT +0.622 ns,
  FF +1.145 ns, **SS -0.316 ns / 10 paths / TNS -2.534 ns** under the
  nominal 2.5 ns OUT/MID_OUT assumption.  The flow exits non-zero at
  `Checker.SetupViolations`.  The official IHP PDK root/decks are absent; a
  local minimal PDK root is assembled from ORFS views.
- All three use the same generic `PLL_ANALOG` Core A hard-macro interface;
  none of the hard macros is built yet.

## Known RTL issues found by the canaries

1. `src/pll.v` passes parameters to `pll_logic` only under `SIMULATION`; a
   non-simulation synthesis of the full top silently uses default parameters.
2. `pll_mod_divider` (`conf_div.v`) divide-by-1 toggles every cycle, i.e. it
   actually divides by 2 for `div == 1`.  `pll_fix_divider` should be checked
   for the same semantics.
3. `CKR` and `DSM_CK` are internally generated clocks not declared in the
   canary SDC; timing claims are incomplete until they are added after
   synthesis/CTS.

## Next gates

1. Build the `PLL_ANALOG` hard macro for ics55 H7CR, gf180 3.3 V, and IHP
   1.2 V; the digital-only canaries are the current proof.
2. Close the IHP SS setup at the characterized DCO period, or relax the
   nominal `OUT`/`MID_OUT` assumption; do not skip the checker.
3. Add official PDK decks/OpenRCX rules for gf180/IHP, or keep DRC/LVS/GDS
   explicitly unclaimed.
4. Fix the RTL parameter propagation and divider-by-1 semantics, then rerun
   all three canaries.
