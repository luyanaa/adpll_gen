#!/usr/bin/env bash
# Assemble a LibreLane-consumable sky130 PDK root for the DCO macro builds.
#
# The in-repo pdk_overlay/.../libs.tech/librelane/config.tcl deliberately
# points KLayout/Magic/Netgen at placeholder files.  LibreLane still needs
# real tech files to stream out GDS/LEF and to run the magic/netgen checks.
# This script creates build/pdk_root/sky130_fd_sc_hd with:
#   - libs.ref and the real KLayout/Magic/Netgen tech trees symlinked
#   - the repo's librelane config copied with real tech paths
#   - build/pdk_root/sky130A -> sky130_fd_sc_hd for the tech scripts that
#     hard-code $PDK_ROOT/sky130A
#
# Usage:
#   flow/macro/sky130_fd_sc_hd/make_pdk_root.sh [DEST]
#   librelane --manual-pdk --pdk-root DEST --pdk sky130_fd_sc_hd \
#             --scl sky130_fd_sc_hd flow/macro/ring_dco_sky130/config.yaml
#
# DEST defaults to <repo>/build/pdk_root (ignored by git).
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
DEST=${1:-"$ROOT/build/pdk_root"}

find_pdk() {
    if [[ -n "${SKY130A:-}" ]]; then
        printf '%s\n' "$SKY130A"
        return
    fi
    local candidate
    while IFS= read -r candidate; do
        if [[ -f "$candidate/libs.tech/klayout/lvs/sky130.lvs" ]]; then
            printf '%s\n' "$candidate"
            return
        fi
    done < <(find "$HOME/.ciel/ciel/sky130/versions" -maxdepth 2 -type d -name sky130A 2>/dev/null | sort -r)
    echo "No sky130A PDK found; set SKY130A=/path/to/sky130A" >&2
    exit 1
}

PDK=$(find_pdk)
PDK_DIR="$DEST/sky130_fd_sc_hd"
OVERLAY="$ROOT/flow/macro/sky130_fd_sc_hd/pdk_overlay/sky130_fd_sc_hd/libs.tech/librelane"

rm -rf "$DEST"
mkdir -p "$PDK_DIR/libs.tech"
ln -s "$PDK/libs.ref" "$PDK_DIR/libs.ref"
ln -s "$PDK/libs.tech/klayout" "$PDK_DIR/libs.tech/klayout"
ln -s "$PDK/libs.tech/magic" "$PDK_DIR/libs.tech/magic"
ln -s "$PDK/libs.tech/netgen" "$PDK_DIR/libs.tech/netgen"
cp -a "$OVERLAY" "$PDK_DIR/libs.tech/librelane"

python3 - "$PDK_DIR/libs.tech/librelane/config.tcl" <<'PY'
import sys
from pathlib import Path
p = Path(sys.argv[1])
s = p.read_text()
repl = {
    'set ::env(MAGIC_TECH) "$placeholder"': 'set ::env(MAGIC_TECH) "$pdk_dir/libs.tech/magic/sky130A.tech"',
    'set ::env(MAGIC_PDK_SETUP) "$placeholder"': 'set ::env(MAGIC_PDK_SETUP) "$pdk_dir/libs.tech/magic/sky130A.tcl"',
    'set ::env(KLAYOUT_TECH) "$placeholder"': 'set ::env(KLAYOUT_TECH) "$pdk_dir/libs.tech/klayout/tech/sky130A.lyt"',
    'set ::env(KLAYOUT_PROPERTIES) "$placeholder"': 'set ::env(KLAYOUT_PROPERTIES) "$pdk_dir/libs.tech/klayout/tech/sky130A.lyp"',
    'set ::env(KLAYOUT_DEF_LAYER_MAP) "$placeholder"': 'set ::env(KLAYOUT_DEF_LAYER_MAP) "$pdk_dir/libs.tech/klayout/tech/sky130A.map"',
    'set ::env(NETGEN_SETUP) "$placeholder"': 'set ::env(NETGEN_SETUP) "$pdk_dir/libs.tech/netgen/sky130A_setup.tcl"',
    'set ::env(MAGICRC) "$placeholder"': 'set ::env(MAGICRC) "$pdk_dir/libs.tech/magic/sky130A.magicrc"',
}
for old, new in repl.items():
    if old not in s:
        raise SystemExit(f"overlay config missing expected line: {old}")
    s = s.replace(old, new)
p.write_text(s)
PY

mkdir -p "$DEST/placeholders"
: > "$DEST/placeholders/not_a_deck"
ln -s "$PDK_DIR" "$DEST/sky130A"

printf 'PDK root: %s\n' "$DEST"
printf 'Build:    librelane --manual-pdk --pdk-root %s --pdk sky130_fd_sc_hd --scl sky130_fd_sc_hd <config.yaml>\n' "$DEST"
