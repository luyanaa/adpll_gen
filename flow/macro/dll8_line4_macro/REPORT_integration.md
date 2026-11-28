# dll8_line4 hard-macro integration report (2026-11-28)

## Verdict: signal integration VALIDATED end-to-end; power hookup blocked pending the macro power respin (spec in ../dll8_cells/REPORT_power.md)

## Deliverables
| file | what |
|---|---|
| dll8_line4.gds | derived GDS view: top renamed `dll8_line4`, origin shifted to (0,0) bbox — make_gds_view.py (signed-off stream untouched) |
| dll8_line4.lef | 516-pin abstract, gen_lef.py: IN/OUT (M1), TAP0-3 (M2), ENk[j] 508x (M3/4/5), VDD/VSS (M1); OBS cut at pin shapes |
| dll8_line4.v | blackbox, scalar TAP0-3 + 4x127-bit EN buses (matches LEF mterm names exactly) |
| dll8_line4__{tt,ss,ff}.lib | stub liberties, gen_lib.py — yosys/openroad parse clean; comb arcs IN->OUT/TAP are placeholders, analog timing is SPICE-signed-off elsewhere |
| pin_inventory.json | extract_pins.py — 516 unique labels, all checks pass |
| dll8_line8_test.v + flow_test/ | two-strip chained integration test top + LibreLane config |

## LibreLane validation evidence (flow_test/runs/smoke4)
`librelane --manual-pdk --pdk-root ../build/pdk_root --pdk ihp-sg13g2 --scl sg13g2_stdcell --skip OpenROAD.GeneratePDN --skip Odb.AddPDNObstructions --run-tag smoke4 config.yaml`

- Synthesis/netlist/lint: clean
- LEF reads: "created 1 library cells", macro places at both locations
- Global routing + **detailed routing COMPLETE, 0 DRC violations** (iter8 final),
  275 nets routed incl. the 254 EN broadcast nets (fanout-8 quasi-static control)
- TrDRC checker: clear; disconnected-pin check: ran clean
- Flow stops only at `PSM-0069 Check connectivity failed on VDD` — the power
  grid cannot land vias on the macro's 0.16 um-wide power shapes (physically
  impossible, via enclosure alone exceeds the pin width).  This is the
  power-integrity defect quantified in ../dll8_cells/REPORT_power.md.

## Issues found and fixed during integration (lane handoff notes)
1. Strict-port LVS false-negative (parent signoff issue): use
   `-rd ignore_top_ports_mismatch=true`, see dll8_cells/REPORT_signoff.md.
2. LEF coordinate frame: the signed-off GDS bbox starts at (-0.88,-13.67);
   pins outside the macro bbox break OpenROAD pin access — derived views are
   origin-shifted; never use the raw signed-off stream directly in PnR.
3. Corner naming: LibreLane PDK default corner is `nom_typ_1p20V_25C` —
   LIB keys MUST use the PDK-native names or the stdcell timing model is
   silently not loaded (surface error: IFP-0053 sg13g2_tielo/L_LO not found).
4. Yosys liberty reader crashes (assert) if bus-style pin names `TAP[i]`
   collide with scalar pins — TAP pins must be scalar TAP0..TAP3 in lib,
   LEF and Verilog alike.
5. FP_SIZING must be `absolute` or DIE_AREA is ignored (relative sizing
   produced a ~1000x1000 um die).

## Integration contract (unchanged)
- 8 elements share ONE thermometer code: broadcast decoded bits to
  EN0[j]..EN3[j] of both strips (fanout 8), polarity th[j] XOR (j odd)
  applied in the decoder (see dll8_line4.v header).
- The 254-net DEF count in smoke4 is the 127-bit bus x2 (per-strip branch
  nets created by synthesis); timing-irrelevant (quasi-static DC).

## Remaining for the DLL8 tile
1. Macro power respin (bounded, spec'd) -> regenerate views (scripted minutes)
   -> rerun this flow WITHOUT the PDN skips as the acceptance test.
2. DLL8 tile RTL: 2x dll8_line4 + thermometer decoder (polarity contract) +
   TDC + loop filter + SR regeneration (src/dll8_*.v exist as models).
3. Real liberty: the stub has placeholder arcs; decide whether STA needs
   extracted timing or whether SPICE-level signoff + blackbox STA exclusion
   is the correct treatment for this analog macro.
