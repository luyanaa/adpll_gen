#!/usr/bin/env bash
# Canary driver for the ics55 H7CR + Core A digital control.
#
#   synth-digital     Yosys synthesis of pll_logic with ics55_LLSC_H7CR (TT)
#   librelane-digital LibreLane digital-only run (requires librelane + OpenROAD)
#   librelane-macro   LibreLane full-top run (requires librelane AND the built
#                     PLL_ANALOG hard-macro views)
#   clean             remove build/
#
# Overrides: PDK_ROOT, PDK_REF_ROOT, PDK, SCL, SRC_DIR, H7CR_LIB, YOSYS,
# LIBRELANE.
# No container image is assumed: if librelane is not in PATH (or LIBRELANE is
# not set), the LibreLane targets stop with an explicit blocker.

set -euo pipefail

CANARY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_DIR="$(cd "$CANARY_DIR/../../.." && pwd)"

PDK_ROOT="${PDK_ROOT:-/grid/icsprout55-pdk}"
PDK="${PDK:-ics55}"
SCL="${SCL:-ics55_LLSC_H7CR}"
# This checkout has no .../ics55/ level: the PDK tree is directly under
# /grid/icsprout55-pdk.  Prefer $PDK_ROOT/libs.ref, fall back to the
# LibreLane-style $PDK_ROOT/$PDK/libs.ref.
PDK_REF_ROOT="${PDK_REF_ROOT:-}"
if [[ -z "$PDK_REF_ROOT" ]]; then
    if [[ -d "$PDK_ROOT/libs.ref" ]]; then
        PDK_REF_ROOT="$PDK_ROOT/libs.ref"
    else
        PDK_REF_ROOT="$PDK_ROOT/$PDK/libs.ref"
    fi
fi
SRC_DIR="${SRC_DIR:-$ROOT_DIR/src}"
H7CR_LIB="${H7CR_LIB:-$PDK_REF_ROOT/$SCL/liberty/${SCL}_typ_tt_1p2_25_nldm.lib}"
YOSYS="${YOSYS:-yosys}"
LIBRELANE="${LIBRELANE:-librelane}"
LIBRELANE_PDK_ROOT="${LIBRELANE_PDK_ROOT:-/grid}"
# ics55 ships no Magic tech; KLayout is the primary streamout/DRC/LVS tool.
LIBRELANE_SKIP="${LIBRELANE_SKIP:-Magic.StreamOut Magic.WriteLEF Magic.DRC Magic.SpiceExtraction Netgen.LVS Checker.LVS Odb.CheckDesignAntennaProperties KLayout.XOR Checker.XOR}"

BUILD_ROOT="$CANARY_DIR/build"
BUILD_YOSYS="$BUILD_ROOT/yosys"
MACRO_DIR="$CANARY_DIR/hardmacro"

say()  { printf '%s\n' "$*"; }
die()  { printf 'BLOCKER: %s\n' "$*" >&2; exit 1; }

have_tool() {
    local t="$1"
    if [[ "$t" == */* ]]; then
        [[ -x "$t" ]]
    else
        command -v "$t" >/dev/null 2>&1
    fi
}

print_librelane_blocker() {
    cat >&2 <<EOF
BLOCKER: LibreLane is not available.

  Looked for: $LIBRELANE
  Result:     not found (command -v / executable check failed)

This canary does not ship, pull or assume a LibreLane container image.
Install LibreLane in the environment and/or point LIBRELANE at it:

  export LIBRELANE=/path/to/librelane        # or a wrapper script
  make librelane-digital

What *has* been proven without LibreLane: the digital control synthesizes to
ics55_LLSC_H7CR cells (make synth-digital).  Place/route/STA/DRC/LVS have NOT
been run.
EOF
}

check_macro_views() {
    local missing=()
    local f
    for f in PLL_ANALOG.gds PLL_ANALOG.lef PLL_ANALOG.lib; do
        [[ -s "$MACRO_DIR/$f" ]] || missing+=("hardmacro/$f")
    done
    if (( ${#missing[@]} )); then
        {
            echo "BLOCKER: the PLL_ANALOG hard-macro views do not exist yet:"
            printf '  - %s\n' "${missing[@]}"
            echo
            echo "config.macro.yaml is a skeleton for the eventual full 'pll' top."
            echo "It will not run until the macro is built and characterized and"
            echo "hardmacro/PLL_ANALOG.{gds,lef,lib} (plus CDL/SPICE for LVS) exist."
            echo "See hardmacro/interface.md and hardmacro/manifest.yaml."
        } >&2
        return 1
    fi
}

cmd="${1:-help}"
case "$cmd" in
    synth-digital)
        have_tool "$YOSYS" || die "Yosys not found ('$YOSYS'). Set YOSYS=/path/to/yosys."
        [[ -s "$H7CR_LIB" ]] || die "H7CR Liberty not found: $H7CR_LIB"
        [[ -d "$SRC_DIR" ]]  || die "RTL source dir not found: $SRC_DIR"
        mkdir -p "$BUILD_YOSYS"

        # The checked-in .ys has this checkout's absolute paths.  Rewrite them
        # in a build copy when the caller overrides SRC_DIR / H7CR_LIB.
        ys_in="$CANARY_DIR/scripts/synth_digital.ys"
        ys_run="$BUILD_YOSYS/synth_digital.generated.ys"
        sed -e "s|/opt/adpll_gen/src/|$SRC_DIR/|g" \
            -e "s|/grid/icsprout55-pdk/libs.ref/ics55_LLSC_H7CR/liberty/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib|$H7CR_LIB|g" \
            "$ys_in" > "$ys_run"

        say "Yosys:    $(command -v "$YOSYS") ($("$YOSYS" -V 2>/dev/null | head -1))"
        say "RTL:      $SRC_DIR"
        say "Liberty:  $H7CR_LIB"
        say "Netlist:  $BUILD_YOSYS/pll_logic_net.v"
        say "Log:      $BUILD_YOSYS/yosys.log"
        say

        # set -e + pipefail: a Yosys failure aborts before the success summary.
        ( cd "$CANARY_DIR" && "$YOSYS" -s "$ys_run" 2>&1 | tee "$BUILD_YOSYS/yosys.log" )

        say
        say "Synthesis PASS. Cell usage (top of build/yosys/stat.rpt):"
        tail -n 8 "$BUILD_YOSYS/stat.rpt" | sed 's/^/  /'
        ;;

    librelane-digital)
        have_tool "$LIBRELANE" || { print_librelane_blocker; exit 2; }
        say "LibreLane: $LIBRELANE"
        say "Config:    config.digital.yaml (top = pll_logic)"
        mkdir -p "$BUILD_ROOT"
        skip_args=()
        for s in $LIBRELANE_SKIP; do skip_args+=(--skip "$s"); done
        say "Skipped:   $LIBRELANE_SKIP"
        ( cd "$CANARY_DIR" && "$LIBRELANE" --manual-pdk --pdk-root "$LIBRELANE_PDK_ROOT" --pdk "$PDK" --scl "$SCL" "${skip_args[@]}" config.digital.yaml 2>&1 | tee "$BUILD_ROOT/librelane_digital.log" )
        ;;

    librelane-macro)
        check_macro_views || exit 2
        have_tool "$LIBRELANE" || { print_librelane_blocker; exit 2; }
        say "LibreLane: $LIBRELANE"
        say "Config:    config.macro.yaml (top = pll, PLL_ANALOG hard macro)"
        mkdir -p "$BUILD_ROOT"
        ( cd "$CANARY_DIR" && "$LIBRELANE" --manual-pdk --pdk-root "$LIBRELANE_PDK_ROOT" --pdk "$PDK" --scl "$SCL" config.macro.yaml 2>&1 | tee "$BUILD_ROOT/librelane_macro.log" )
        ;;

    clean)
        rm -rf "$BUILD_ROOT"
        say "Removed $BUILD_ROOT"
        ;;

    help|-h|--help|"")
        cat <<EOF
Canary for the ics55 H7CR + Core A digital control.

  synth-digital     Yosys synthesis of pll_logic with ics55_LLSC_H7CR (TT)
  librelane-digital LibreLane digital-only run (requires librelane + OpenROAD)
  librelane-macro   LibreLane full-top run (requires librelane AND the built
                    PLL_ANALOG hard-macro views)
  clean             remove build/

Overrides: PDK_ROOT, PDK_REF_ROOT, PDK, SCL, SRC_DIR, H7CR_LIB, YOSYS,
LIBRELANE.  No container image is assumed.
EOF
        ;;

    *)
        die "unknown target '$cmd' (use: synth-digital | librelane-digital | librelane-macro | clean)"
        ;;
esac
