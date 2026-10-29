#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/adpll_gen}
PDK_ROOT=${PDK_ROOT:-/grid}
OUT=${OUT:-$ROOT/sim/post_pnr/out}
mkdir -p "$OUT"
cp "$ROOT/pnr/outputs/ics55/PLL_ANALOG_MACRO.sdf" "$OUT/PLL_ANALOG_MACRO.sdf"
cp "$ROOT/pnr/outputs/ics55/PLL_ANALOG_MACRO.v" "$OUT/PLL_ANALOG_MACRO.v"
cp "$ROOT/sim/post_pnr/filler_stubs.v" "$OUT/filler_stubs.v"
cd "$OUT"
CELLS="$PDK_ROOT/ics55/libs.ref/ics55_LLSC_H7CR/verilog/ics55_LLSC_H7CR.v"
iverilog -gspecify -T max -o pnr_sdf.vvp \
  "$ROOT/sim/post_pnr/test_pll_analog_macro.v" PLL_ANALOG_MACRO.v filler_stubs.v "$CELLS"
vvp pnr_sdf.vvp > pnr_sdf.log
iverilog -gspecify -T max -D NOSDF -o pnr_nosdf.vvp \
  "$ROOT/sim/post_pnr/test_pll_analog_macro.v" PLL_ANALOG_MACRO.v filler_stubs.v "$CELLS"
vvp pnr_nosdf.vvp > pnr_nosdf.log
printf '%s\n' '--- post-PnR SDF ---'; grep POST_PNR pnr_sdf.log
printf '%s\n' '--- no SDF (gate netlist, zero-delay cells) ---'; grep POST_PNR pnr_nosdf.log
