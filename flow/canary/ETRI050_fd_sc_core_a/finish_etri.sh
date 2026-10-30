#!/usr/bin/env bash
# Finish an already-routed ETRI050 ODB: insert vendor fill cells, stream out
# with the pin/label layer remap, and run the vendor KLayout DRC.
#
# Usage:
#   OPENROAD=/path/to/openroad ./finish_etri.sh [input.odb] [outdir]
#
# The original route left every empty site unfilled.  Because the 12T GDS
# extends 1.3/1.4 um outside the LEF, those gaps produced 636 NWL/NSD/PSD
# markers.  Filling with the vendor FILLX cells removes 635/636 markers.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
odb=${1:-$here/final/pll_logic.odb}
out=${2:-$here/final/etri_filled}
openroad=${OPENROAD:-openroad}
mkdir -p "$out"
"$openroad" -no_init -exit <<TCL
read_db $odb
filler_placement {FILLX1 FILLX2 FILLX3 FILLX4}
write_def $out/pll_logic_filled.def
exit
TCL
PDK_ROOT=${PDK_ROOT:-/grid} PDK=${PDK:-ETRI050} \
  bash "$here/klayout_check_local.sh" "$out/pll_logic_filled.def" pll_logic "$out" \
  "$here/final/pll_logic.cdl"
echo "filled DEF/GDS/DRC/LVS written to $out"
