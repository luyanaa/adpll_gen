#!/bin/bash
# Verify the merged IHP Magic tech can (a) read the routed GDS, (b) read the
# routed DEF without LEF layer errors, and (c) write a non-empty LEF.
# Usage: magic_tech_test.sh [pdk_root]
set -u
HERE=$(cd "$(dirname "$0")/.." && pwd)
PDK=${1:-$HERE/build/pdk_root}
RC=$PDK/ihp-sg13g2/libs.tech/magic/ihp-sg13g2-signoff.magicrc
GDS=$HERE/runs/RUN_2026-11-19_23-01-46/final/gds/pll_macro_top.gds
DEF=$HERE/runs/RUN_2026-11-19_23-01-46/final/def/pll_macro_top.def
LEF=$HERE/build/pdk_root/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef
TECHLEF=$HERE/build/pdk_root/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef

mkdir -p /tmp/opencode/drc_out
cat > /tmp/opencode/drc_out/techtest.tcl <<EOF
puts "START"
gds read $GDS
puts "GDS_OK"
lef read $TECHLEF
lef read $LEF
puts "LEF_OK"
load pll_macro_top
puts "LOADED"
puts "PINS [llength [box values]]"
load $DEF
puts "DEF_OK"
getcell pll_macro_top
puts "SELECTED"
lef write /tmp/opencode/drc_out/out2.lef
puts "WRITE_OK"
quit
EOF

echo "=== rcfile: $RC"
timeout 300s docker run --rm --entrypoint /bin/bash \
  -v /grid:/grid -v /tmp/opencode:/tmp/opencode \
  -e PATH=/foss/tools/bin:/usr/bin:/bin -e PDK_ROOT="$PDK" \
  hpretl/iic-osic-tools:latest -lc \
  "magic -dnull -noconsole -rcfile '$RC' /tmp/opencode/drc_out/techtest.tcl" 2>&1 \
  | grep -E "START|GDS_OK|LEF_OK|LOADED|DEF_OK|SELECTED|WRITE_OK|Unknown layer|parse layer|Error|error" \
  | head -14

echo "--- produced LEF ---"
ls -l /tmp/opencode/drc_out/out2.lef 2>/dev/null | awk '{print $5, "bytes"}'
grep -m3 -E "^MACRO|^  PIN|^  OBS" /tmp/opencode/drc_out/out2.lef 2>/dev/null
