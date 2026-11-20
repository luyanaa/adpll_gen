#!/bin/bash
# OpenROAD-extracted CDL  vs  post-synthesis gate-level netlist, compared with
# netgen.  This avoids the Magic tech entirely (gap doc B18).
#
# The gate-level netlist has no macro internals, so PLL_ANALOG_MACRO is
# blackboxed on both sides; the comparison is on the standard-cell logic the
# flow actually places and routes.
#
# Usage: lvs_openroad.sh [run_dir]
set -u
HERE=$(cd "$(dirname "$0")/.." && pwd)
# Accept a relative run path and make it absolute: the netlist arguments are
# passed into the container, where a relative path resolves against /grid.
RUN=$(cd "${1:-$HERE/runs/RUN_2026-11-19_23-01-46}" && pwd)
OUT=$HERE/lvs_openroad
PDK=$HERE/build/pdk_root/ihp-sg13g2
SETUP=$PDK/libs.tech/netgen/ihp-sg13g2_setup.tcl
mkdir -p "$OUT"

ODB=$RUN/final/odb/pll_macro_top.odb
SDC=$RUN/final/sdc/pll_macro_top.sdc
GATE=$RUN/final/nl/pll_macro_top.nl.v
MASTERS=$PDK/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl

for f in "$ODB" "$GATE" "$MASTERS" "$SETUP"; do
  [ -f "$f" ] || { echo "missing: $f" >&2; exit 1; }
done
echo "odb     : $(stat -c %s "$ODB") bytes"
echo "gate    : $(stat -c %s "$GATE") bytes"
echo "masters : $(stat -c %s "$MASTERS") bytes"
echo "setup   : $(stat -c %s "$SETUP") bytes"

cat > "$OUT/extract.tcl" <<EOF
read_db $ODB
if {[file exists $SDC]} { read_sdc $SDC }
write_cdl -masters {$MASTERS} $OUT/pll_macro_top.cdl.raw
puts "CDL_WRITTEN"
exit
EOF

echo
echo "=== 1. extract CDL from the routed ODB (OpenROAD) ==="
timeout 600s docker run --rm --entrypoint /bin/bash -v /grid:/grid \
  -e PATH=/foss/tools/bin:/usr/bin:/bin -e PDK_ROOT="$HERE/build/pdk_root" \
  hpretl/iic-osic-tools:latest -lc \
  "openroad -exit -no_splash $OUT/extract.tcl" 2>&1 \
  | grep -E "CDL_WRITTEN|Error|error" | head -3
# OpenROAD's write_cdl omits the .ENDS terminator and puts the first instance
# on the line straight after the .SUBCKT header; netgen then cannot delimit the
# port list, which reads as "every pin has no matching pin".  Normalise both.
python3 - "$OUT/pll_macro_top.cdl.raw" "$OUT/pll_macro_top.cdl" <<'PYFIX'
import sys
src, dst = sys.argv[1], sys.argv[2]
lines = open(src).read().split("\n")
out, in_hdr = [], False
for line in lines:
    if line.startswith(".SUBCKT"):
        in_hdr = True
        out.append(line)
        continue
    if in_hdr:
        if line.startswith("+"):
            out.append(line)
            continue
        in_hdr = False
        out.append("")
    out.append(line)
txt = "\n".join(out).rstrip()
if ".ENDS" not in txt:
    txt += "\n\n.ENDS"
open(dst, "w").write(txt + "\n")
print("   normalised CDL: header separated, .ENDS appended")
PYFIX
ls -l "$OUT/pll_macro_top.cdl" 2>/dev/null | awk '{print "   cdl:", $5, "bytes"}'

echo
echo "=== 2. netgen LVS: extracted CDL vs gate-level netlist ==="
timeout 900s docker run --rm --entrypoint /bin/bash -v /grid:/grid \
  -e PATH=/foss/tools/bin:/usr/bin:/bin -e PDK_ROOT="$HERE/build/pdk_root" \
  hpretl/iic-osic-tools:latest -lc \
  "netgen -batch lvs '$OUT/pll_macro_top.cdl pll_macro_top' \
      '$GATE pll_macro_top' '$SETUP' '$OUT/lvs.log'" 2>&1 \
  | tail -25
echo
echo "--- lvs.log summary ---"
grep -iE "subcircuit|mismatch|match|failed|Netlists" "$OUT/lvs.log" 2>/dev/null | tail -12
