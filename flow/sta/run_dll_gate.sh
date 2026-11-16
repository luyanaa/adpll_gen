#!/bin/sh
# Gate-level/SDF closure for the full Route B DLL at TT/SS/FF.
set -eu
ROOT=${ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}
PDK=${ICS55_REAL_ROOT:-/grid/icsprout55-pdk}
OUT=${SIM_OUT:-$ROOT/sim/outputs/ihp-sg13g2}
YOSYS=${YOSYS:-yosys}
STA=${STA:-sta}
IVERILOG=${IVERILOG:-iverilog}
VVP=${VVP:-vvp}
STD=$PDK/libs.ref/ics55_LLSC_H7CR
LIB_TT=$STD/liberty/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib
LIB_SS=$STD/liberty/ics55_LLSC_H7CR_ss_rcworst_1p08_125_nldm.lib
LIB_FF=$STD/liberty/ics55_LLSC_H7CR_ff_rcbest_1p32_m40_nldm.lib
CELLS_V=$STD/verilog/ics55_LLSC_H7CR.v
mkdir -p "$OUT"

# One netlist, mapped with the TT liberty.  Each corner's delays come from
# its own OpenSTA SDF.
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ics55.v $ROOT/src/fine_delay.v $ROOT/src/dll_dcdl.v $ROOT/src/pll_segmented_delay_phys.v $ROOT/src/dll_tdc.v $ROOT/src/dll_tdc_phys.v $ROOT/src/dll_full_period_top.v $ROOT/src/dll_acq_period.v; setattr -mod -unset keep_hierarchy; setattr -mod -unset keep; chparam -set TDC_IMPL 1 -set TDC_LINE_IMPL 1 -set DLL_IMPL 1 -set CODE_MIN 20 -set CODE_MAX 230 -set PHASE_TOL_DIV 4 -set ACQ_TOL_DIV 3 -set MON_TOL_NUM 3 -set MON_TOL_DEN 8 -set PHASE_MISS_MAX 8 -set ACQ_EARLY 1 DLL_FULL_PERIOD_TOP; synth -top DLL_FULL_PERIOD_TOP -flatten; dfflibmap -liberty $LIB_TT; abc -liberty $LIB_TT; write_verilog -noattr $OUT/dll_gate_net.v; stat" \
  > "$OUT/dll_gate.yosys.log"

for corner in TT SS FF; do
  case $corner in
    TT) LIB=$LIB_TT; L=tt ;;
    SS) LIB=$LIB_SS; L=ss ;;
    FF) LIB=$LIB_FF; L=ff ;;
  esac

  STD_LIB=$LIB NETLIST=$OUT/dll_gate_net.v SDF_OUT=$OUT/dll_gate_$L.sdf \
    $STA -no_init -exit "$ROOT/flow/sta/dll_gate.sta.tcl" \
    > "$OUT/dll_gate_$L.sta.log"
  python3 "$ROOT/flow/sta/fill_sdf_typ.py" \
    "$OUT/dll_gate_$L.sdf" "$OUT/dll_gate_${L}_typ.sdf" >/dev/null
  python3 "$ROOT/flow/sta/strip_sdf_cond.py" \
    "$OUT/dll_gate_${L}_typ.sdf" "$OUT/dll_gate_${L}_gl.sdf" >/dev/null
  # Yosys keeps flattened cell names as escaped identifiers containing dots;
  # Icarus reads those SDF INSTANCE names as hierarchy, so flatten both files.
  python3 "$ROOT/flow/sta/flatten_names.py" \
    "$OUT/dll_gate_net.v" "$OUT/dll_gate_${L}_gl.sdf" \
    "$OUT/dll_gate_${L}_flat" >/dev/null

  $IVERILOG -g2012 -gspecify -o "$OUT/dll_gate_$L.vvp" \
    -DSDF_FILE="\"$OUT/dll_gate_${L}_flat_sdf.sdf\"" \
    "$ROOT/src/dll_gate_tb.v" "$ROOT/src/dll_acq_period.v" \
    "$OUT/dll_gate_${L}_flat_net.v" "$CELLS_V" \
    > "$OUT/dll_gate_$L.iverilog.log" 2>&1
  $VVP "$OUT/dll_gate_$L.vvp" > "$OUT/dll_gate_$L.log" 2>&1
  echo "== $corner full DLL gate-level/SDF =="
  grep -E "GL DLL|dll_gate_tb: PASS|FAIL" "$OUT/dll_gate_$L.log"
done
