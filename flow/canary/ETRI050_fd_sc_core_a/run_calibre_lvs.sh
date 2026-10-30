#!/usr/bin/env bash
# Run the vendor Calibre LVS deck on the filled ETRI050 GDS.
#
# The repository's local KLayout LVS deck loses top-level signal nets during
# hierarchical extraction.  The original NSPL PDK ships a Calibre LVS deck;
# use this script when Calibre is available.
#
# Usage:
#   CALIBRE=/path/to/calibre ./run_calibre_lvs.sh [pll_logic.gds] [pll_logic.cdl] [outdir]
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
gds=${1:-$here/final/etri_filled/pll_logic.gds}
cdl=${2:-$here/final/pll_logic.cdl}
out=${3:-$here/final/etri_calibre_lvs}
calibre=${CALIBRE:-calibre}
pdk=${NSPL_PDK:-/grid/NSPL_05CMOS_PDK_260820}
command -v "$calibre" >/dev/null || {
    echo "Calibre not found. Set CALIBRE=/path/to/calibre." >&2
    exit 127
}
[[ -f "$gds" && -f "$cdl" ]] || {
    echo "Missing GDS/CDL: $gds $cdl" >&2
    exit 2
}
mkdir -p "$out"
cp "$pdk/Calibre/LVS/NSPL_0p5um_Analog_CMOS_2P3M_5V_V1.1_LVS.cal" "$out/"
# Calibre header uses TOPCELL placeholders and includes the deck by relative path.
sed "s/TOPCELL/pll_logic/g" "$pdk/Calibre/LVS/lvs_header.cal" > "$out/lvs_header.local.cal"
ln -sf "$(cd "$(dirname "$gds")" && pwd)/$(basename "$gds")" "$out/pll_logic.gds"
ln -sf "$(cd "$(dirname "$cdl")" && pwd)/$(basename "$cdl")" "$out/pll_logic.cdl"
(
    cd "$out"
    "$calibre" -lvs -hier -spice pll_logic.spi lvs_header.local.cal | tee lvs.log
)
