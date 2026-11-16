#!/bin/sh
# Real ics55 DDR PHY structural/timing checks across TT/SS/FF.
#
# Requires the ics55 PDK at ICS55_REAL_ROOT (default /grid/icsprout55-pdk).
# This is a structural + Liberty-corner check, not a placed/parasitic or IO
# SI/PVT signoff.
set -eu

ROOT=${ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}
PDK=${ICS55_REAL_ROOT:-/grid/icsprout55-pdk}
OUT=${SIM_OUT:-$ROOT/sim/outputs/ihp-sg13g2}
IVERILOG=${IVERILOG:-iverilog}
YOSYS=${YOSYS:-yosys}
STA=${STA:-sta}

STD=$PDK/libs.ref/ics55_LLSC_H7CR
IO=$PDK/libs.ref/ICsprout_55LLULP1233_IO_251013
STD_TT=$STD/liberty/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib
STD_SS=$STD/liberty/ics55_LLSC_H7CR_ss_rcworst_1p08_125_nldm.lib
STD_FF=$STD/liberty/ics55_LLSC_H7CR_ff_rcbest_1p32_m40_nldm.lib
IO_TT=$IO/liberty/ICSIOA_N55_3P3_tt_1p2_3p3_25c.lib
IO_SS=$IO/liberty/ICSIOA_N55_3P3_ss_1p08_2p97_125c.lib
IO_FF=$IO/liberty/ICSIOA_N55_3P3_ff_1p32_3p63_m40c.lib
STD_V=$STD/verilog/ics55_LLSC_H7CR.v
IO_V=$IO/verilog/icsIOA_N55_3P3.v

test -f "$STD_V"
test -f "$IO_V"
test -f "$STD_TT"
test -f "$IO_TT"
mkdir -p "$OUT"

echo "== non-SIMULATION elaboration with real ics55 cells =="
$IVERILOG -g2012 -s PHASE_SELECTOR_TOP -o "$OUT/phase_selector_ics55.vvp" \
  "$ROOT/src/pll_cells_ics55.v" "$STD_V" \
  "$ROOT/src/fine_delay.v" "$ROOT/src/pll_dcdl_tap_bus_phys.v" \
  "$ROOT/src/phase_selector_top.v" \
  > "$OUT/phase_selector_ics55.elab.log" 2>&1
echo "Icarus real-cell elaboration: PASS"

echo "== Yosys selector + tap bus =="
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ics55.v $ROOT/src/fine_delay.v $ROOT/src/pll_dcdl_tap_bus_phys.v $ROOT/src/phase_selector_top.v; synth -top PHASE_SELECTOR_TOP -flatten; abc -liberty $STD_TT; stat" \
  > "$OUT/phase_selector_ics55.yosys.log"
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ics55.v $ROOT/src/fine_delay.v $ROOT/src/pll_dcdl_tap_bus_phys.v $ROOT/flow/sta/dcdl_tap_step_meas.v; synth -top DCDL_TAP_STEP_MEAS -flatten; abc -liberty $STD_TT; write_verilog $OUT/dcdl_tap_step_net.v; stat" \
  > "$OUT/dcdl_tap_step.yosys.log"

echo "== Yosys real IO pad =="
$YOSYS -p "read_liberty -lib $IO_TT; read_verilog $ROOT/src/ics55_ddr_ck_pad.v $ROOT/flow/sta/ics55_ck_pad_meas.v; synth -top ICS55_CK_PAD_MEAS -flatten; write_verilog $OUT/ics55_pad_net.v; stat" \
  > "$OUT/ics55_pad.yosys.log"

echo "== Yosys real DCDL range =="
$YOSYS -p "read_verilog $ROOT/src/pll_cells_ics55.v $ROOT/src/coarse_delay.v $ROOT/src/mid_delay.v $ROOT/src/fine_delay.v $ROOT/src/pll_counter_dcdl_phys.v $ROOT/flow/sta/dcdl_range_meas.v; setattr -mod -unset keep_hierarchy; setattr -mod -unset keep; synth -top DCDL_RANGE_MEAS -flatten; abc -liberty $STD_TT; write_verilog $OUT/dcdl_range_net.v; stat" \
  > "$OUT/dcdl_range.yosys.log"

fail=0
for corner in TT SS FF; do
  case $corner in
    TT) std_lib=$STD_TT; io_lib=$IO_TT ;;
    SS) std_lib=$STD_SS; io_lib=$IO_SS ;;
    FF) std_lib=$STD_FF; io_lib=$IO_FF ;;
  esac
  echo "== $corner tap step =="
  ICS55_LIB=$std_lib NETLIST=$OUT/dcdl_tap_step_net.v \
    $STA -no_init -exit "$ROOT/flow/sta/dcdl_tap_step.sta.tcl" \
    > "$OUT/dcdl_tap_step_$corner.log"
  python3 "$ROOT/flow/sta/tap_step_check.py" \
    "$OUT/dcdl_tap_step_$corner.log" "$corner"

  echo "== $corner IO pad =="
  IO_LIB=$io_lib NETLIST=$OUT/ics55_pad_net.v \
    $STA -no_init -exit "$ROOT/flow/sta/ics55_ck_pad.sta.tcl" \
    > "$OUT/ics55_pad_$corner.log"
  python3 "$ROOT/flow/sta/pad_check.py" "$OUT/ics55_pad_$corner.log" "$corner"

  echo "== $corner DCDL range =="
  STD_LIB=$std_lib NETLIST=$OUT/dcdl_range_net.v \
    $STA -no_init -exit "$ROOT/flow/sta/dcdl_range.sta.tcl" \
    > "$OUT/dcdl_range_$corner.log"
  if ! python3 "$ROOT/flow/sta/dcdl_range_check.py" \
      "$OUT/dcdl_range_$corner.log" "$corner" \
      --require-coverage --period=5.0 --guardband=0.5; then
    fail=1
  fi

  echo "== $corner DCDL bank sensitivity =="
  STD_LIB=$std_lib NETLIST=$OUT/dcdl_range_net.v \
    $STA -no_init -exit "$ROOT/flow/sta/dcdl_bank.sta.tcl" \
    > "$OUT/dcdl_bank_$corner.log"
  if ! python3 "$ROOT/flow/sta/dcdl_bank_check.py" \
      "$OUT/dcdl_bank_$corner.log" "$corner"; then
    fail=1
  fi
done

if [ "$fail" != 0 ]; then
  echo "BLOCKED: ics55 DCDL does not cover 5 ns +/- 0.5 ns and/or a bank has no real sensitivity"
  exit 2
fi
echo "PASS: ics55 real-cell tap/pad/DCDL TT/SS/FF checks"
