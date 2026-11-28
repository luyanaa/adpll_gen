#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# DDR1 structural DLL synthesis smoke (IHP sg13g2).
#
# This is the "real-cell elaboration" evidence for the CK90 engine: the DLL
# is instantiated in its FULL structural configuration —
#   SEG_IMPL=1    five quarter segments = 10 x dll8_line4 hard macros
#   REGEN=1       matched SR regeneration (structural cells)
#   TDC_IMPL=1    structural signed flash TDC (FINE_DELAY_CELL chain)
# — with the `ifdef SYNTHESIS path that removes the behavioral FIFO/real
# timestamp logic entirely (silicon has no $realtime).
#
# It is a SYNTHESIS-CHECK, not a timing signoff: the dll8_line4 macros stay
# blackboxes (their LEF/GDS/LIB are in flow/macro/dll8_line4_macro/), and no
# liberty mapping is run here.  Gate-level timing uses the macro .lib files
# in flow/macro/dll8_line4_macro/dll8_line4__{tt,ss,ff}.lib.
#
# Expected: no ERROR lines; flattened cell count ~1286 with exactly 10
# dll8_line4 instances.
set -u
cd "$(dirname "$0")/../.."
OUT=${1:-sim/outputs/ddr1/ihp130}
mkdir -p "$OUT"

YOSYS=${YOSYS:-yosys}
LIBDIR=build/pdk_root/ihp-sg13g2/libs.ref/sg13g2_stdcell
FILES="src/pll_cells_ihp-sg13g2.v src/ddr1_cells_bb.v src/fine_delay.v \
       src/sim_mux.v src/ddr1_dll_tdc.v src/ddr1_dll_phys.v src/ddr1_ck90_dll.v \
       flow/macro/dll8_line4_macro/dll8_line4.v"

cat > "$OUT/ddr1_dll_struct_synth_top.v" <<'EOF'
module dll_struct_synth_top(
    input  wire CKIN, RST, EN,
    input  wire [1:0] TRIM_SEL,
    output wire CK90, DLL_LOCKED, DLL_ERR,
    output wire [6:0] DBG_CODE);
    wire signed [15:0] trim = (TRIM_SEL == 2'd1) ? 16'sd1472 :
                              (TRIM_SEL == 2'd2) ? 16'sd791  : 16'sd1018;
    DDR1_CK90_DLL #(
        .CODE_BITS(7), .CODE_INIT(48),
        .SEG_IMPL(1), .REGEN(1), .REGEN_IMPL(1), .TDC_IMPL(1),
        .STEP_MASTER_PS(32), .HOLD_PS(65), .TRIM_EXT_EN(1)
    ) u_dll (
        .CKIN(CKIN), .RST(RST), .EN(EN), .TRIM_EXT(trim),
        .CK90(CK90), .DLL_LOCKED(DLL_LOCKED), .DLL_ERR(DLL_ERR),
        .DBG_CODE(DBG_CODE));
endmodule
EOF

$YOSYS -DYOSYS -p "read_verilog $FILES $OUT/ddr1_dll_struct_synth_top.v; \
  hierarchy -top dll_struct_synth_top; synth -top dll_struct_synth_top -flatten; stat" \
  > "$OUT/ddr1_dll_struct_synth.log" 2>&1
rc=$?

echo "--- errors ---"
grep -E '^ERROR|error:' "$OUT/ddr1_dll_struct_synth.log" | head -5 || true
echo "--- result ---"
grep -E 'Number of cells|dll8_line4' "$OUT/ddr1_dll_struct_synth.log" | sort -u | head -4

if [ $rc -ne 0 ] || grep -qE '^ERROR|error:' "$OUT/ddr1_dll_struct_synth.log"; then
    echo "DDR1 DLL STRUCTURAL SYNTH: FAIL ($OUT/ddr1_dll_struct_synth.log)"
    exit 1
fi
# count from the FLATTENED stat only (per-module stats also mention the
# macro in the hierarchy listing with different counts)
nmacro=$(awk '/Number of cells/{f=1} f&&/^     dll8_line4 /{print $2; exit}' \
          "$OUT/ddr1_dll_struct_synth.log")
if [ "${nmacro:-0}" != "10" ]; then
    echo "DDR1 DLL STRUCTURAL SYNTH: FAIL — expected 10 dll8_line4 macros, got ${nmacro:-0}"
    exit 1
fi
echo "DDR1 DLL STRUCTURAL SYNTH: PASS (10 macros, $(grep -oE 'Number of cells: +[0-9]+' "$OUT/ddr1_dll_struct_synth.log" | head -1 | grep -oE '[0-9]+') cells)"
