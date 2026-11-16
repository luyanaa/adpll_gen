#!/bin/sh
# Gate-level/SDF closure attempt for the full Route B DLL (TT corner).
set -eu
ROOT=${ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}
PDK=${ICS55_REAL_ROOT:-/grid/icsprout55-pdk}
OUT=${SIM_OUT:-$ROOT/sim/outputs/ihp-sg13g2}
YOSYS=${YOSYS:-yosys}
STA=${STA:-sta}
IVERILOG=${IVERILOG:-iverilog}
VVP=${VVP:-vvp}
STD=$PDK/libs.ref/ics55_LLSC_H7CR
LIB=$STD/liberty/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib
CELLS_V=$STD/verilog/ics55_LLSC_H7CR.v
mkdir -p "$OUT"
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ics55.v $ROOT/src/fine_delay.v $ROOT/src/dll_dcdl.v $ROOT/src/pll_segmented_delay_phys.v $ROOT/src/dll_tdc.v $ROOT/src/dll_tdc_phys.v $ROOT/src/dll_full_period_top.v; setattr -mod -unset keep_hierarchy; setattr -mod -unset keep; setattr -set keep 1 w:DLL_TDC_PHYS/th0 w:DLL_TDC_PHYS/th1 w:DLL_TDC_PHYS/first_therm w:DLL_TDC_PHYS/acq_dly w:DLL_TDC_PHYS/period_r w:DLL_FULL_PERIOD_TOP/t_th0 w:DLL_FULL_PERIOD_TOP/t_th1 w:DLL_FULL_PERIOD_TOP/t_first w:DLL_FULL_PERIOD_TOP/t_period; chparam -set TDC_IMPL 1 -set TDC_LINE_IMPL 1 -set DLL_IMPL 1 DLL_FULL_PERIOD_TOP; synth -top DLL_FULL_PERIOD_TOP -flatten; dfflibmap -liberty $LIB; abc -liberty $LIB; write_verilog -noattr $OUT/dll_gate_net.v; stat" \
  > "$OUT/dll_gate.yosys.log"
STD_LIB=$LIB NETLIST=$OUT/dll_gate_net.v SDF_OUT=$OUT/dll_gate_tt.sdf \
  $STA -no_init -exit "$ROOT/flow/sta/dll_gate.sta.tcl" > "$OUT/dll_gate_tt.sta.log"
python3 "$ROOT/flow/sta/fill_sdf_typ.py" "$OUT/dll_gate_tt.sdf" "$OUT/dll_gate_tt_typ.sdf" >/dev/null
python3 "$ROOT/flow/sta/strip_sdf_cond.py" "$OUT/dll_gate_tt_typ.sdf" "$OUT/dll_gate_tt_gl.sdf" >/dev/null
$IVERILOG -g2012 -gspecify -o "$OUT/dll_gate_tt.vvp" \
  -DSDF_FILE="\"$OUT/dll_gate_tt_gl.sdf\"" \
  "$ROOT/src/dll_gate_tb.v" "$OUT/dll_gate_net.v" "$CELLS_V" \
  > "$OUT/dll_gate_tt.iverilog.log" 2>&1
$VVP "$OUT/dll_gate_tt.vvp" > "$OUT/dll_gate_tt.log" 2>&1
grep -E "GL DLL|dll_gate_tb: PASS|FAIL" "$OUT/dll_gate_tt.log"
