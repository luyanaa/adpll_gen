# Tuned short-ring DCO — campaign status (2026-11-26)

Driver: `flow/characterization/dco_tuned_pex.py` (decks /tmp/opencode/dcopex/decks,
results JSON on /grid). Bug fixed 2026-11-26 per orchestrator: parse key type
(`waves["v{key}"]`), settle/stop were compared in ns against seconds (that is why
all sweep JSON metrics were empty while the tran.out waveforms were valid), real
exception strings recorded.

## Design as implemented (RTL + SPICE in lockstep)
- `src/pll_multiphase_dco.v`: NSTAGE=25 (PH_W=3, STEP=3), AND2X1 closure, taps
  at k*STEP via dont_touch BUFFX0 — geometry untouched.
- Stage inverter = **PLL_CELL_INVX4** (sg13g2_inv_4) on all 25 stages, uniform.
- Ports `COARSE[4:0]`, `FINE signed [5:0]`; global decode once: fine_idx=FINE+32.
- `dco_stage` per stage output: inv_4 + 5-bit coarse bank + 6-bit fine bank
  (both switched sg13_moscap banks, GATE-side switches) + 11 dont_touch buf_1
  + sg13g2_decap_4.
- Coarse switch map (SW_M per bit): **1,1,2,4,8** (bit4 raised 4->8 on
  2026-11-26 to kill the last up-jump). Fine group switch map: **1,1,1,2,4,8**.
- One-shot startup kick (brief risk 7): EN delayed 3x dont_touch inv_1;
  kick = AND(EN, ~EN_d3), ORed into the closure; ~3 gate delays at release only.
- Known PDK note: cornerMOSCAP.lib has only moscap_tt (no cap_wcs/bcs).
- Documented deviations from the brief: NAND3 fine bank -> switched moscap
  (nand3_1 B pin ~0.4 fF, ~0.05 fF contrast at ring edge rates); plate-side
  switching -> gate-side switching (1.3 fF/finger dead load measured).

## FINAL SS rate table (2026-11-26, with-wire deck: SPEF wire caps + m8 bit4
## + w0.15u switches + kick; driver metrics fixed)
| code | f (MHz) |  | code | f (MHz) |
|---|---|---|---|---|
| 0 | 279.4 |  | 16 | 202.0 |
| 1 | 270.6 |  | 17 | 193.5 |
| 2 | 270.0 |  | 18 | 192.5 |
| 3 | 261.1 |  | 19 | 184.3 |
| 4 | 260.5 |  | 20 | 183.2 |
| 5 | 251.6 |  | 21 | 175.2 |
| 6 | 250.9 |  | 22 | 174.2 |
| 7 | 242.0 |  | 23 | 166.4 |
| 8 | 241.2 |  | 24 | 165.2 |
| 9 | 232.2 |  | 25 | 157.8 |
| 10 | 231.5 |  | 26 | 156.7 |
| 11 | 222.6 |  | 27 | 149.5 |
| 12 | 221.8 |  | 28 | 148.4 |
| 13 | 212.9 |  | 29 | 141.6 |
| 14 | 212.1 |  | 30 | 140.5 |
| 15 | 203.5 |  | 31 | 134.1 |

- **MONOTONE: 0 up-jumps over all 31 adjacent pairs.** (c23's sweep "DEAD" was
  an 18 ns window artifact; re-run at 40 ns = 166.4 MHz.)
- **GAP-FREE: max adjacent step 8.9 MHz << fine half-span 86 MHz (measured).**
- 250 MHz bracketed by c6 (250.9) / c7 (242.0); fast end 279.4 (+29 over 250);
  slow end 134.1. Fine LSB ~2.8 MHz; >=2 fine LSB headroom at 250 both sides.
- With-wire fast end at f=-31: 336.9 MHz (L_wire_c0_f-31 deck).
- c31 dead state: fixed by the one-shot kick (init 0 and X identical).


## OPEN / REMAINING (in order)
1. TT COARSE sweep (running at report time). FF table (final config, f=0,
   with-wire): **658.6 (c0) -> 289.3 (c31) MHz, STRICTLY MONOTONE (0 up-jumps,
   max step 23.8 MHz < fine half-span 86)**; 500 MHz bracketed by c12 (505.9) /
   c13 (483.2), inside the range with +158 / -211 margins. ss_sweep5_wire.json
   and ff_sweep_wire.json hold both tables.
2. Six acceptance measurements on the loaded tops (tb_rx_loaded / tb_tx_loaded
   decks generated and wired): startup x2 releases x2 inits x c0/c31; duty
   45-55% at the flop clock pin at the 250-locked code (~c6/c7) AND c31
   (pre-resize c31 SS duty 55.2% at ph0 was at the 55% edge — brief risk 5
   split-NMOS/PMOS remedy if confirmed); RX 8-tap phase <=30 ps at c0 AND c31
   (TX quadrature separate); PI-switch min pulse >=40% T/8; fine symmetry.
3. M4: regenerate MANUAL_GLOBAL_PLACEMENTS keyed on STEP (fat ~50-cell
   dco_stage, abutted, taps Metal3 downward), LibreLane macro build, post-route
   loaded tap uniformity + DRC/LVS, and the >=250 MHz ROUTED @ SS confirmation.
   The wire caps are now inside the SPICE decks, so the M4 delta is layout
   variation only — the old 1.16 penalty guess is retired.


## Runtime facts
- ngspice + psp103.osdi: ~30-60 s/ns; decks MUST live in /tmp/opencode
  (10x slower on /grid); 8-way parallel; ulimit -v 4000000 (KB).
- All PWL sources need finite ramps; instantaneous PWL steps stall ngspice.
