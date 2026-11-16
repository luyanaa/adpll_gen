#!/bin/sh
# Physical TDC: real-cell line span + gate-level/SDF smoke at TT/SS/FF.
set -eu
ROOT=${ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}
PDK=${ICS55_REAL_ROOT:-/grid/icsprout55-pdk}
OUT=${SIM_OUT:-$ROOT/sim/outputs/ihp-sg13g2}
YOSYS=${YOSYS:-yosys}
STA=${STA:-sta}
IVERILOG=${IVERILOG:-iverilog}
VVP=${VVP:-vvp}
STD=$PDK/libs.ref/ics55_LLSC_H7CR
STD_TT=$STD/liberty/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib
STD_SS=$STD/liberty/ics55_LLSC_H7CR_ss_rcworst_1p08_125_nldm.lib
STD_FF=$STD/liberty/ics55_LLSC_H7CR_ff_rcbest_1p32_m40_nldm.lib
CELLS_V=$STD/verilog/ics55_LLSC_H7CR.v
mkdir -p "$OUT"

echo "== Yosys physical TDC =="
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ics55.v $ROOT/src/fine_delay.v $ROOT/src/dll_dcdl.v $ROOT/src/pll_segmented_delay_phys.v $ROOT/src/dll_tdc_phys.v $ROOT/flow/sta/dll_tdc_phys_meas.v; setattr -mod -unset keep_hierarchy; setattr -mod -unset keep; synth -top DLL_TDC_PHYS_MEAS -flatten; dfflibmap -liberty $STD_TT; abc -liberty $STD_TT; write_verilog -noattr $OUT/tdc_phys_net.v; stat" \
  > "$OUT/tdc_phys.yosys.log"

echo "== Yosys TDC line =="
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ics55.v $ROOT/src/fine_delay.v $ROOT/src/dll_dcdl.v $ROOT/src/pll_segmented_delay_phys.v $ROOT/src/dll_tdc_phys.v $ROOT/flow/sta/dll_tdc_line_meas.v; synth -top DLL_TDC_LINE_MEAS -flatten; abc -liberty $STD_TT; write_verilog $OUT/tdc_line_net.v; stat" \
  > "$OUT/tdc_line.yosys.log"

for corner in TT SS FF; do
  case $corner in
    TT) lib=$STD_TT ;;
    SS) lib=$STD_SS ;;
    FF) lib=$STD_FF ;;
  esac
  echo "== $corner TDC line =="
  STD_LIB=$lib NETLIST=$OUT/tdc_line_net.v \
    $STA -no_init -exit "$ROOT/flow/sta/dll_tdc_line.sta.tcl" \
    > "$OUT/tdc_line_$corner.log"
  python3 "$ROOT/flow/sta/tdc_line_check.py" "$OUT/tdc_line_$corner.log" "$corner"
done

for corner in TT SS FF; do
  case $corner in
    TT) lib=$STD_TT ;;
    SS) lib=$STD_SS ;;
    FF) lib=$STD_FF ;;
  esac
  echo "== $corner TDC gate-level/SDF =="
  STD_LIB=$lib NETLIST=$OUT/tdc_phys_net.v SDF_OUT=$OUT/tdc_phys_$corner.sdf \
    $STA -no_init -exit "$ROOT/flow/sta/dll_tdc_phys.sta.tcl" \
    > "$OUT/tdc_phys_$corner.sta.log"
  python3 "$ROOT/flow/sta/fill_sdf_typ.py" \
    "$OUT/tdc_phys_$corner.sdf" "$OUT/tdc_phys_${corner}_typ.sdf" >/dev/null
  python3 "$ROOT/flow/sta/strip_sdf_cond.py" \
    "$OUT/tdc_phys_${corner}_typ.sdf" "$OUT/tdc_phys_${corner}_gl.sdf" >/dev/null
  $IVERILOG -g2012 -gspecify -o "$OUT/tdc_phys_gl_$corner.vvp" \
    -DSDF_FILE="\"$OUT/tdc_phys_${corner}_gl.sdf\"" \
    "$ROOT/src/dll_tdc_phys_gl_tb.v" "$OUT/tdc_phys_net.v" "$CELLS_V" \
    > "$OUT/tdc_phys_gl_$corner.iverilog.log" 2>&1
  $VVP "$OUT/tdc_phys_gl_$corner.vvp" > "$OUT/tdc_phys_gl_$corner.log" 2>&1
  grep -E "GL TDC|dll_tdc_phys_gl_tb: PASS|FAIL" "$OUT/tdc_phys_gl_$corner.log"
done
echo "PASS: physical TDC line + gate-level/SDF smoke at TT/SS/FF"
