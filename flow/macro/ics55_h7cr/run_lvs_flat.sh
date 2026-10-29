#!/usr/bin/env bash
# Flat-reference KLayout LVS for PLL_ANALOG_MACRO.
#
# The ics55 cell CDL is parameterized (W=nw/L=nl with nw/nl/pw/pl on the
# instance), which KLayout's SPICE reader cannot resolve.  flatten_cdl.py
# expands it and assigns unique internal nets; the layout extraction and
# reference are then compared in flat mode.  combine_devices=true is required
# because the deck merges parallel PMOS fingers in the layout.
set -euo pipefail

ROOT=${ROOT:-/opt/adpll_gen}
PDK_ROOT=${PDK_ROOT:-/grid}
TOP=${TOP:-PLL_ANALOG_MACRO}
SCL=${SCL:-ics55_LLSC_H7CR}
OUT=${OUT:-$ROOT/signoff/outputs/ics55}
REP=${REP:-$ROOT/signoff/reports/ics55}

mkdir -p "$OUT" "$REP"
FLAT="$OUT/${TOP}_flat.spice"

python3 "$ROOT/flow/macro/ics55_h7cr/flatten_cdl.py" \
  --cells "$PDK_ROOT/ics55/libs.ref/$SCL/cdl/$SCL.cdl" \
  --macro "$ROOT/pnr/outputs/ics55/$TOP.cdl" \
  --top "$TOP" \
  --out "$FLAT"

PDK_ROOT="$PDK_ROOT" PDK=ics55 klayout -b \
  -r "$PDK_ROOT/icsprout55-pdk/libs.tech/lvs/ics55.lvs" \
  -rd input="$OUT/$TOP.gds" \
  -rd schematic="$FLAT" \
  -rd topcell="$TOP" \
  -rd report="$REP/$TOP.lvsdb" \
  -rd target_netlist="$REP/${TOP}_extracted.cir" \
  -rd run_mode=flat -rd combine_devices=true -rd threads=10 \
  2>&1 | tee "$REP/${TOP}_lvs_flat.log"

grep -q 'ICS55_LVS_COMPARE=PASS' "$REP/${TOP}_lvs_flat.log"
echo "LVS PASS: $REP/$TOP.lvsdb"
