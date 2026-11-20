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
# Drop the supply pins from the .SUBCKT header.  write_cdl lists them
# (VDD, VSS) but the gate-level netlist declares no power ports, and netgen
# then misaligns the whole pin list: it reported
#   OUT_DIV |(no matching pin)
#   RST_N   |(no matching pin)
#   SET_DIV[0] .. [7] |(no matching pin)
# i.e. ten pins after the supply names, instead of only VDD/VSS themselves.
# They carry no connectivity to compare, so remove them rather than teaching
# netgen to ignore them.
hdr_end = None
for n, line in enumerate(out):
    if line.startswith(".SUBCKT"):
        hdr_start = n
        m = n + 1
        while m < len(out) and out[m].startswith("+"):
            m += 1
        hdr_end = m
        break
if hdr_end is not None:
    body = " ".join([out[hdr_start].split(None, 2)[2]] +
                    [l[1:].strip() for l in out[hdr_start + 1:hdr_end]])
    keep = [p for p in body.split() if p not in ("VDD", "VSS")]
    wrapped, cur = [], ""
    for pin in keep:
        cand = (cur + " " + pin).strip()
        if len(cand) > 70 and cur:
            wrapped.append(cur); cur = pin
        else:
            cur = cand
    wrapped.append(cur)
    new_hdr = [".SUBCKT pll_macro_top " + wrapped[0]] + ["+ " + w for w in wrapped[1:]]
    out[hdr_start:hdr_end] = new_hdr
    print(f"   dropped supply pins; subckt header now {len(keep)} pins")

txt = "\n".join(out).rstrip()
if ".ENDS" not in txt:
    txt += "\n\n.ENDS"
open(dst, "w").write(txt + "\n")
print("   normalised CDL: header separated, .ENDS appended")
PYFIX
ls -l "$OUT/pll_macro_top.cdl" 2>/dev/null | awk '{print "   cdl:", $5, "bytes"}'


echo
echo "=== 1b. strip physical-only cells from the netlist ==="
mkdir -p "$OUT/nolvs"
python3 - "$GATE" "$OUT/nolvs/pll_macro_top.v" <<'PYF'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
lines = open(src).read().split("\n")
out, removed, i = [], {}, 0
# Two separate patterns: a cell-family strip, and the clkload instances which
# are named, not typed.  A single alternation matched the *wrong* group for
# clkload and reported 59 sg13g2_inv_1 as removed.
family = re.compile(r"^\s*sg13g2_(decap|fill|antennanp|diode)\w*\s+\S+\s*\(")
clkload = re.compile(r"^\s*sg13g2_\w+\s+clkload\d+\s*\(")
while i < len(lines):
    m = family.match(lines[i]) or clkload.match(lines[i])
    if m:
        key = "clkload" if clkload.match(lines[i]) else m.group(0).split()[0]
        removed[key] = removed.get(key, 0) + 1
        while i < len(lines) and not lines[i].rstrip().endswith(");"):
            i += 1
        i += 1
        continue
    out.append(lines[i]); i += 1
open(dst, "w").write("\n".join(out))
print("   removed:", dict(sorted(removed.items())))
PYF


echo
echo "=== 1c. flatten bus ports in the netlist header ==="
# netgen matches top-level pins by name, and the CDL spells buses out
# (FCW[0] .. FCW[7]) while the Verilog declares them as vectors.  B19 did this
# flattening inline; it was lost when this script was rewritten.  Without it
# every vector port reports "(no matching pin)" and the per-class comparison
# never runs.
python3 - "$OUT/nolvs/pll_macro_top.v" <<'PYFLAT'
import re, sys
path = sys.argv[1]
src = open(path).read()
buses = {"DSM_ORDER": 2, "FCW": 8, "KI": 16, "KP": 16, "SET_DIV": 8}
m = re.search(r"^module pll_macro_top \((.*?)\);", src, re.S)
if not m:
    print("   WARNING: no module header found"); raise SystemExit(0)
ports = [p.strip() for p in m.group(1).replace("\n", " ").split(",") if p.strip()]
new = []
for p in ports:
    new += [f"{p}[{i}]" for i in range(buses[p])] if p in buses else [p]
hdr = "module pll_macro_top (" + ",\n    ".join(new) + ");"
src = src[:m.start()] + hdr + src[m.end():]
for name, w in buses.items():
    src = re.sub(
        rf"^(\s*)(input|output)(\s+)\[{w-1}:0\]\s+{name};",
        lambda mm, name=name, w=w: mm.group(0) + "\n" + "\n".join(
            f"{mm.group(1)}{mm.group(2)} {name}[{i}];" for i in range(w)),
        src, count=1, flags=re.M)
open(path, "w").write(src)
print(f"   flattened {len([p for p in ports if p in buses])} bus ports -> {len(new)} pins")
PYFLAT

echo
echo "=== 1d. append the cell definitions ==="
# netgen needs the standard-cell subckts to have anything to compare.  Without
# them every cell is a black box on both sides:
#   Circuit 1 cell sg13g2_inv_1 and Circuit 2 cell sg13g2_inv_1 are black boxes
# and the per-class table is empty even though the top-level topology is read.
# write_cdl -masters only uses the PDK CDL to *resolve* masters during
# extraction; it does not copy their definitions into the output.
cat "$OUT/pll_macro_top.cdl" "$MASTERS" > "$OUT/pll_macro_top_full.cdl"
echo "   cell definitions appended: $(grep -cE '^\.SUBCKT' "$OUT/pll_macro_top_full.cdl") subckts"

echo
echo "=== 2. netgen LVS: extracted CDL vs gate-level netlist ==="
timeout 900s docker run --rm --entrypoint /bin/bash -v /grid:/grid \
  -e PATH=/foss/tools/bin:/usr/bin:/bin -e PDK_ROOT="$HERE/build/pdk_root" \
  hpretl/iic-osic-tools:latest -lc \
  "netgen -batch lvs '$OUT/pll_macro_top_full.cdl pll_macro_top' \
      '$OUT/nolvs/pll_macro_top.v pll_macro_top' '$SETUP' '$OUT/lvs.log'" 2>&1 \
  | tail -25
echo
echo "--- lvs.log summary ---"
grep -iE "subcircuit|mismatch|match|failed|Netlists" "$OUT/lvs.log" 2>/dev/null | tail -12
