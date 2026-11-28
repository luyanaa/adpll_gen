#!/bin/sh
# Real-cell (IHP SG13G2) DDR1 DQS delay-line tap characterization across TT/SS/FF.
# Structural Liberty-corner check; not a placed/parasitic signoff.
set -eu

ROOT=${ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}
PDK=${IHP_PDK_ROOT:-$ROOT/build/pdk_root/ihp-sg13g2}
OUT=${SIM_OUT:-$ROOT/sim/outputs/ddr1/ihp130}
YOSYS=${YOSYS:-yosys}
STA=${STA:-sta}

STD=$PDK/libs.ref/sg13g2_stdcell
LIB_TT=$STD/lib/sg13g2_stdcell_typ_1p20V_25C.lib
LIB_SS=$STD/lib/sg13g2_stdcell_slow_1p08V_125C.lib
LIB_FF=$STD/lib/sg13g2_stdcell_fast_1p32V_m40C.lib

for f in "$LIB_TT" "$LIB_SS" "$LIB_FF"; do test -f "$f"; done
mkdir -p "$OUT"

echo "== yosys: DDR1 DQS line (IMPL=1, 256 FINE_DELAY_CELL) -> sg13g2 =="
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ihp-sg13g2.v $ROOT/src/fine_delay.v $ROOT/src/ddr1_dqs_delay_line_phys.v $ROOT/flow/sta/ddr1_dqs_taps_meas.v; synth -top DDR1_DQS_TAPS_MEAS -flatten; abc -liberty $LIB_TT; write_verilog $OUT/ddr1_dqs_taps_net.v; stat" \
  > "$OUT/ddr1_dqs_taps.yosys.log" 2>&1
echo "netlist written"

fail=0
for corner in TT SS FF; do
  case $corner in
    TT) lib=$LIB_TT ;; SS) lib=$LIB_SS ;; FF) lib=$LIB_FF ;;
  esac
  echo "== $corner tap delays =="
  DDR1_LIB=$lib NETLIST=$OUT/ddr1_dqs_taps_net.v \
    $STA -no_init -exit "$ROOT/flow/sta/ddr1_dqs_taps.sta.tcl" \
    > "$OUT/ddr1_dqs_taps_$corner.log" 2>&1
  if ! python3 "$ROOT/flow/sta/ddr1_dqs_taps_check.py" \
      "$OUT/ddr1_dqs_taps_$corner.log" "$corner" \
      --csv "$OUT/ddr1_dqs_taps_$corner.csv"; then
    fail=1
  fi
done
exit $fail
