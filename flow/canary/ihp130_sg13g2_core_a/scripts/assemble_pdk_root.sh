#!/usr/bin/env bash
# Assemble a *local, minimal* LibreLane PDK root for the ihp130 canary.
#
# This does NOT ship an IHP PDK.  It lays out the directory shape LibreLane
# expects and points the reference views at the OpenROAD-flow-scripts copy:
#
#   build/pdk_root/ihp-sg13g2/
#     libs.ref/sg13g2_stdcell/{lib,lef,gds,cdl,verilog}  -> ORFS platform dirs
#     libs.tech/librelane                               -> ../pdk/ihp-sg13g2/...
#     libs.tech/klayout/tech                            -> ORFS .lyt/.lyp/.map
#
# The `libs.tech/librelane` config is authored in this repository
# (pdk/ihp-sg13g2/libs.tech/librelane/) because the full IHP PDK root with
# its official `libs.tech/librelane` is NOT installed in this environment.
# It is a minimal bring-up config, not the official IHP PDK integration.
#
# Idempotent: re-running only refreshes the symlinks.
set -euo pipefail

CANARY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ORFS_PLATFORM="${ORFS_PLATFORM:-/opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2}"
PDK_ROOT="${PDK_ROOT:-$CANARY_DIR/build/pdk_root}"
PDK="${PDK:-ihp-sg13g2}"
SCL="${SCL:-sg13g2_stdcell}"

PDK_DIR="$PDK_ROOT/$PDK"
REF_DIR="$PDK_DIR/libs.ref/$SCL"
TECH_DIR="$PDK_DIR/libs.tech"
LOCAL_TECH="$CANARY_DIR/pdk/$PDK/libs.tech/librelane"

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

[[ -d "$ORFS_PLATFORM" ]] || die "ORFS ihp-sg13g2 platform not found: $ORFS_PLATFORM"
[[ -d "$LOCAL_TECH" ]]    || die "local libs.tech/librelane not found: $LOCAL_TECH"

for d in lib lef gds cdl verilog; do
    [[ -d "$ORFS_PLATFORM/$d" ]] || die "missing ORFS view dir: $ORFS_PLATFORM/$d"
done

mkdir -p "$REF_DIR" "$TECH_DIR/klayout/tech"

for d in lib lef gds cdl verilog; do
    ln -sfn "$ORFS_PLATFORM/$d" "$REF_DIR/$d"
done

# OpenRCX pattern file (one file covers all ORFS corners).
[[ -s "$ORFS_PLATFORM/rcx_patterns.rules" ]] || die "missing $ORFS_PLATFORM/rcx_patterns.rules"
mkdir -p "$REF_DIR/rcx"
ln -sfn "$ORFS_PLATFORM/rcx_patterns.rules" "$REF_DIR/rcx/IHP_rcx_patterns.rules"

ln -sfn "$LOCAL_TECH" "$TECH_DIR/librelane"

# The ORFS platform also carries the latch/clkgate mapping files and the
# OpenRCX rules; expose it read-only as $PDK_DIR/platform.
ln -sfn "$ORFS_PLATFORM" "$PDK_DIR/platform"

# KLayout needs a technology directory, but the official IHP KLayout decks are
# not installed.  Link the ORFS technology files so a `-n sg13g2` invocation
# can at least resolve layers.  DRC/LVS runsets are intentionally NOT provided,
# so those LibreLane steps have to be skipped rather than trusted.
ln -sfn "$ORFS_PLATFORM/sg13g2.lyt" "$TECH_DIR/klayout/tech/sg13g2.lyt"
ln -sfn "$ORFS_PLATFORM/sg13g2.lyp" "$TECH_DIR/klayout/tech/sg13g2.lyp"
ln -sfn "$ORFS_PLATFORM/sg13g2.map" "$TECH_DIR/klayout/tech/sg13g2.map"

printf 'PDK root assembled: %s\n' "$PDK_ROOT"
printf '  libs.ref/%s/lib       -> %s\n' "$SCL" "$ORFS_PLATFORM/lib"
printf '  libs.ref/%s/lef       -> %s\n' "$SCL" "$ORFS_PLATFORM/lef"
printf '  libs.ref/%s/gds       -> %s\n' "$SCL" "$ORFS_PLATFORM/gds"
printf '  libs.ref/%s/cdl       -> %s\n' "$SCL" "$ORFS_PLATFORM/cdl"
printf '  libs.ref/%s/verilog   -> %s\n' "$SCL" "$ORFS_PLATFORM/verilog"
printf '  libs.ref/%s/rcx       -> %s\n' "$SCL" "$ORFS_PLATFORM/rcx_patterns.rules"
printf '  libs.tech/librelane   -> %s\n' "$LOCAL_TECH"
printf '  NOT provided: official IHP libs.tech/librelane, KLayout DRC/LVS runsets,\n'
printf '                netgen setup, magic tech.  Signoff steps must be skipped.\n'
