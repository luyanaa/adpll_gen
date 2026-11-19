#!/bin/bash
# Mirror the env var order librelane's scripts/magic/lef.tcl uses:
#   read_tech_lef -> read_pdk_lef -> read_pdk_gds -> read_def -> lef write
# The GDS read only supplies the standard-cell geometry; layer *definitions*
# come from the tech LEF and the tech file.
# Usage: magic_tech_test.sh [pdk_root]
set -u
HERE=$(cd "$(dirname "$0")/.." && pwd)
PDK=${1:-$HERE/build/pdk_root}
RC=$PDK/ihp-sg13g2/libs.tech/magic/ihp-sg13g2-signoff.magicrc
TECHLEF=$PDK/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef
CELLLEF=$PDK/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef
CELLGDS=$PDK/ihp-sg13g2/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds
DEF=$HERE/runs/RUN_2026-11-19_23-01-46/final/def/pll_macro_top.def
OUT=/tmp/opencode/drc_out

mkdir -p "$OUT"
cat > "$OUT/techtest.tcl" <<EOF
puts "START"
lef read $TECHLEF
puts "TECHLEF_OK"
lef read $CELLLEF
puts "CELLLEF_OK"
if {[file exists $CELLGDS]} { gds read $CELLGDS; puts "PDKGDS_OK" }
load pll_macro_top
puts "DEF_LOAD"
read_def $DEF
puts "DEF_OK"
getcell pll_macro_top
puts "SELECTED"
lef write $OUT/out3.lef
puts "WRITE_OK"
quit
EOF

echo "=== rcfile: $RC"
timeout 300s docker run --rm --entrypoint /bin/bash \
  -v /grid:/grid -v /tmp/opencode:/tmp/opencode \
  -e PATH=/foss/tools/bin:/usr/bin:/bin -e PDK_ROOT="$PDK" \
  hpretl/iic-osic-tools:latest -lc \
  "magic -dnull -noconsole -rcfile '$RC' $OUT/techtest.tcl" 2>&1 \
  | grep -E "START|TECHLEF_OK|CELLLEF_OK|PDKGDS_OK|DEF_LOAD|DEF_OK|SELECTED|WRITE_OK|Unknown layer|parse layer|Too many|Error" \
  | head -14

echo "--- produced LEF ---"
ls -l "$OUT/out3.lef" 2>/dev/null | awk '{print $5, "bytes"}'
grep -m3 -E "^MACRO|^  PIN" "$OUT/out3.lef" 2>/dev/null
