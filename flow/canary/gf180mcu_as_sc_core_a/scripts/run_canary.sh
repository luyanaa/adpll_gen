#!/usr/bin/env bash
# Canary driver for the gf180mcu 3.3 V + Core A digital control.
#
#   synth-digital     Yosys synthesis of pll_logic with
#                     gf180mcu_as_sc_mcu7t3v3 (TT / 3.3 V / 25 C)
#   librelane-digital LibreLane digital-only run (requires librelane + OpenROAD)
#   librelane-macro   LibreLane full-top run (requires librelane AND the built
#                     PLL_ANALOG hard-macro views)
#   clean             remove build/
#
# Overrides: GF180_PDK, PDK_REF_ROOT, PDK, SCL, SRC_DIR, GF180_LIB, YOSYS,
# LIBRELANE, LIBRELANE_PDK_ROOT, LIBRELANE_SKIP.
#
# PDK layout note
# ---------------
# The PDK is at
#   /grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk
# but LibreLane's config loader requires
#   $PDK_ROOT/$PDK/libs.tech/librelane/config.tcl
# and this PDK has only the SCL-level
#   .../libs.tech/librelane/gf180mcu_as_sc_mcu7t3v3/config.tcl.
# This script therefore uses the canary-local overlay
#   pdk_overlay/gf180mcu/
#     libs.ref -> <PDK>/libs.ref
#     libs.tech/librelane/gf180mcu_as_sc_mcu7t3v3 -> <PDK>/.../gf180mcu_as_sc_mcu7t3v3
#     libs.tech/librelane/config.tcl  (checked in; fills missing PDK variables)
# The PDK itself is not modified.  See pdk_overlay/.../config.tcl for the
# exact values and the signoff caveats.

set -euo pipefail

CANARY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_DIR="$(cd "$CANARY_DIR/../../.." && pwd)"

GF180_PDK="${GF180_PDK:-/grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk}"
PDK_REF_ROOT="${PDK_REF_ROOT:-$GF180_PDK/libs.ref}"
PDK="${PDK:-gf180mcu}"
SCL="${SCL:-gf180mcu_as_sc_mcu7t3v3}"
SRC_DIR="${SRC_DIR:-$ROOT_DIR/src}"
GF180_LIB="${GF180_LIB:-$PDK_REF_ROOT/$SCL/lib/${SCL}__tt_025C_3v30.lib}"
YOSYS="${YOSYS:-yosys}"
LIBRELANE="${LIBRELANE:-/nix/store/ilpnqwsl6gvk6kvavkaljbnzaz3086fd-python3.13-librelane-3.0.16/bin/librelane}"
LIBRELANE_PDK_ROOT="${LIBRELANE_PDK_ROOT:-$CANARY_DIR/pdk_overlay}"
# Steps that need Magic/KLayout/Netgen/OpenRCX collateral this PDK does not
# ship.  They are skipped, not faked.  Override with a space-separated list.
LIBRELANE_SKIP="${LIBRELANE_SKIP:-Magic.StreamOut KLayout.StreamOut KLayout.Render Magic.WriteLEF Odb.CheckDesignAntennaProperties KLayout.XOR Checker.XOR Magic.DRC KLayout.DRC Checker.MagicDRC Checker.KLayoutDRC Magic.SpiceExtraction Netgen.LVS Checker.LVS OpenROAD.RCX OpenROAD.STAPostPNR OpenROAD.IRDropReport Checker.SetupViolations Checker.HoldViolations Checker.MaxSlewViolations Checker.MaxCapViolations}"

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

Point LIBRELANE at a LibreLane 3.x executable, e.g. the Nix store path
recorded in README.md:

  export LIBRELANE=/path/to/librelane
  make librelane-digital

What has been proven without LibreLane: the digital control synthesizes to
gf180mcu_as_sc_mcu7t3v3 cells (make synth-digital).  Place/route/STA/DRC/LVS
have NOT been run.
EOF
}

make_pdk_overlay() {
    local template="$CANARY_DIR/pdk_overlay"
    local overlay="$LIBRELANE_PDK_ROOT/$PDK"

    # If the caller relocates PDK_ROOT, copy the checked-in shim and
    # placeholder there.  The default layout is used in place.
    if [[ "$LIBRELANE_PDK_ROOT" != "$template" ]]; then
        mkdir -p "$LIBRELANE_PDK_ROOT/placeholders" \
                 "$overlay/libs.tech/librelane"
        cp "$template/$PDK/libs.tech/librelane/config.tcl" \
           "$overlay/libs.tech/librelane/config.tcl"
        cp "$template/placeholders/not_a_deck" \
           "$LIBRELANE_PDK_ROOT/placeholders/not_a_deck"
    fi

    mkdir -p "$overlay/libs.tech/librelane"
    ln -sfn "$GF180_PDK/libs.ref" "$overlay/libs.ref"
    ln -sfn "$GF180_PDK/libs.tech/librelane/$SCL" "$overlay/libs.tech/librelane/$SCL"

    # Sanity: the paths LibreLane's config loader and the shim use must resolve.
    [[ -d "$overlay/libs.ref/$SCL" ]] || die "PDK overlay libs.ref/$SCL missing"
    [[ -f "$overlay/libs.tech/librelane/$SCL/config.tcl" ]] || \
        die "PDK overlay SCL config.tcl missing"
    [[ -f "$overlay/libs.tech/librelane/config.tcl" ]] || \
        die "PDK overlay top-level config.tcl missing (see pdk_overlay/)"
    [[ -f "$LIBRELANE_PDK_ROOT/placeholders/not_a_deck" ]] || \
        die "PDK overlay placeholder missing (see pdk_overlay/placeholders/)"
    say "PDK overlay: $overlay"
    say "  libs.ref -> $GF180_PDK/libs.ref"
    say "  libs.tech/librelane/$SCL -> $GF180_PDK/libs.tech/librelane/$SCL"
    say "  config.tcl: $overlay/libs.tech/librelane/config.tcl"
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
        [[ -s "$GF180_LIB" ]] || die "gf180 Liberty not found: $GF180_LIB"
        [[ -d "$SRC_DIR" ]]  || die "RTL source dir not found: $SRC_DIR"
        mkdir -p "$BUILD_YOSYS"

        # The checked-in .ys has this checkout's absolute paths.  Rewrite them
        # in a build copy when the caller overrides SRC_DIR / GF180_LIB.
        ys_in="$CANARY_DIR/scripts/synth_digital.ys"
        ys_run="$BUILD_YOSYS/synth_digital.generated.ys"
        sed -e "s|/opt/adpll_gen/src/|$SRC_DIR/|g" \
            -e "s|/grid/gf180mcu/gf180mcu_as_sc_mcu7t3v3/pdk/libs.ref/gf180mcu_as_sc_mcu7t3v3/lib/gf180mcu_as_sc_mcu7t3v3__tt_025C_3v30.lib|$GF180_LIB|g" \
            "$ys_in" > "$ys_run"

        say "Yosys:    $(command -v "$YOSYS") ($("$YOSYS" -V 2>/dev/null | head -1))"
        say "RTL:      $SRC_DIR"
        say "Liberty:  $GF180_LIB"
        say "Netlist:  $BUILD_YOSYS/pll_logic_net.v"
        say "Log:      $BUILD_YOSYS/yosys.log"
        say

        # set -e + pipefail: a Yosys failure aborts before the success summary.
        ( cd "$CANARY_DIR" && "$YOSYS" -s "$ys_run" 2>&1 | tee "$BUILD_YOSYS/yosys.log" )

        # Post-map sanity: no internal $ cells survived.
        if grep -qE '\$_[A-Za-z0-9_]+' "$BUILD_YOSYS/pll_logic_net.v"; then
            die "unmapped internal cells (\$...) remain in $BUILD_YOSYS/pll_logic_net.v"
        fi

        say
        say "Synthesis PASS. Cell usage (top of build/yosys/stat.rpt):"
        tail -n 8 "$BUILD_YOSYS/stat.rpt" | sed 's/^/  /'
        ;;

    librelane-digital)
        have_tool "$LIBRELANE" || { print_librelane_blocker; exit 2; }
        make_pdk_overlay
        skip_args=()
        for s in $LIBRELANE_SKIP; do skip_args+=(--skip "$s"); done
        say "LibreLane: $LIBRELANE"
        say "Config:    config.digital.yaml (top = pll_logic)"
        say "Skipped:   $LIBRELANE_SKIP"
        mkdir -p "$BUILD_ROOT"
        set +e
        ( cd "$CANARY_DIR" && "$LIBRELANE" --manual-pdk \
            --pdk-root "$LIBRELANE_PDK_ROOT" --pdk "$PDK" --scl "$SCL" \
            "${skip_args[@]}" config.digital.yaml 2>&1 | \
            tee "$BUILD_ROOT/librelane_digital.log" )
        rc=${PIPESTATUS[0]}
        set -e
        say
        say "LibreLane exit code: $rc (log: build/librelane_digital.log)"
        exit "$rc"
        ;;

    librelane-macro)
        check_macro_views || exit 2
        have_tool "$LIBRELANE" || { print_librelane_blocker; exit 2; }
        make_pdk_overlay
        skip_args=()
        for s in $LIBRELANE_SKIP; do skip_args+=(--skip "$s"); done
        say "LibreLane: $LIBRELANE"
        say "Config:    config.macro.yaml (top = pll, PLL_ANALOG hard macro)"
        say "Skipped:   $LIBRELANE_SKIP"
        mkdir -p "$BUILD_ROOT"
        set +e
        ( cd "$CANARY_DIR" && "$LIBRELANE" --manual-pdk \
            --pdk-root "$LIBRELANE_PDK_ROOT" --pdk "$PDK" --scl "$SCL" \
            "${skip_args[@]}" config.macro.yaml 2>&1 | \
            tee "$BUILD_ROOT/librelane_macro.log" )
        rc=${PIPESTATUS[0]}
        set -e
        say
        say "LibreLane exit code: $rc (log: build/librelane_macro.log)"
        exit "$rc"
        ;;

    clean)
        rm -rf "$BUILD_ROOT"
        say "Removed $BUILD_ROOT"
        ;;

    help|-h|--help|"")
        cat <<EOF
Canary for the gf180mcu 3.3 V + Core A digital control.

  synth-digital     Yosys synthesis of pll_logic with
                    gf180mcu_as_sc_mcu7t3v3 (TT / 3.3 V / 25 C)
  librelane-digital LibreLane digital-only run (requires librelane + OpenROAD)
  librelane-macro   LibreLane full-top run (requires librelane AND the built
                    PLL_ANALOG hard-macro views)
  clean             remove build/

Overrides: GF180_PDK, PDK_REF_ROOT, PDK, SCL, SRC_DIR, GF180_LIB, YOSYS,
LIBRELANE, LIBRELANE_PDK_ROOT.

The LibreLane targets create a canary-local PDK overlay under
build/pdk_overlay/\$PDK because this PDK ships no top-level
libs.tech/librelane/config.tcl.  The PDK itself is not modified.
EOF
        ;;

    *)
        die "unknown target '$cmd' (use: synth-digital | librelane-digital | librelane-macro | clean)"
        ;;
esac
