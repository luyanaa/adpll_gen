#!/bin/sh
# Real ics55 4-seg DCDL coverage gate (TT/SS/FF).
#
# Builds the SEGMENTED_DELAY4_MEAS netlist with Yosys and measures the
# coarse=0/fine=0 and coarse=4/fine=55 endpoints with OpenSTA.  Exits 2 if any
# corner does not cover 4.5-5.5 ns.  This is a Liberty-corner structural check,
# not placed/PEX/PVT silicon signoff.
set -eu

ROOT=${ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}
PDK=${ICS55_REAL_ROOT:-/grid/icsprout55-pdk}
OUT=${SIM_OUT:-$ROOT/sim/outputs/ihp-sg13g2}
YOSYS=${YOSYS:-yosys}
STA=${STA:-sta}

STD=$PDK/libs.ref/ics55_LLSC_H7CR
STD_TT=$STD/liberty/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib
STD_SS=$STD/liberty/ics55_LLSC_H7CR_ss_rcworst_1p08_125_nldm.lib
STD_FF=$STD/liberty/ics55_LLSC_H7CR_ff_rcbest_1p32_m40_nldm.lib

test -f "$STD_TT"
mkdir -p "$OUT"

echo "== Yosys DLL_DCDL physical backend =="
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ics55.v $ROOT/src/fine_delay.v $ROOT/src/pll_segmented_delay_phys.v $ROOT/src/dll_dcdl.v $ROOT/flow/sta/dll_dcdl_phys_meas.v; synth -top DLL_DCDL_PHYS_MEAS -flatten; stat" \
  > "$OUT/dll_dcdl_phys.yosys.log"

echo "== Yosys 4-seg DCDL =="")"
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ics55.v $ROOT/src/fine_delay.v $ROOT/src/pll_segmented_delay_phys.v $ROOT/flow/sta/segmented_delay4_meas.v; synth -top SEGMENTED_DELAY4_MEAS -flatten; abc -liberty $STD_TT; write_verilog $OUT/segmented_delay4_net.v; stat" \
  > "$OUT/segmented_delay4.yosys.log"

fail=0
for corner in TT SS FF; do
  case $corner in
    TT) lib=$STD_TT ;;
    SS) lib=$STD_SS ;;
    FF) lib=$STD_FF ;;
  esac
  echo "== $corner 4-seg DCDL =="
  STD_LIB=$lib NETLIST=$OUT/segmented_delay4_net.v \
    $STA -no_init -exit "$ROOT/flow/sta/segmented_delay4.sta.tcl" \
    > "$OUT/segmented_delay4_$corner.log"
  if ! python3 "$ROOT/flow/sta/segmented_delay_check.py" \
      "$OUT/segmented_delay4_$corner.log" "$corner" --min=4.5 --max=5.5; then
    fail=1
  fi

  echo "== $corner 4-seg boundary continuity =="
  STD_LIB=$lib NETLIST=$OUT/segmented_delay4_net.v \
    $STA -no_init -exit "$ROOT/flow/sta/segmented_boundary.sta.tcl" \
    > "$OUT/segmented_boundary_$corner.log"
  if ! python3 "$ROOT/flow/sta/segmented_boundary_check.py" \
      "$OUT/segmented_boundary_$corner.log" "$corner" --max-step=300; then
    fail=1
  fi
done

if [ "$fail" != 0 ]; then
  echo "BLOCKED: 4-seg DCDL does not cover 4.5-5.5 ns at TT/SS/FF"
  exit 2
fi
echo "PASS: 4-seg DCDL covers 4.5-5.5 ns at TT/SS/FF"
