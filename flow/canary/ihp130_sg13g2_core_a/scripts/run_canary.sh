#!/usr/bin/env bash
# Canary driver for the IHP SG13G2 + Core A digital control.
#
#   synth-digital     Yosys synthesis of pll_logic with sg13g2_stdcell (TT)
#   pdk-root          assemble build/pdk_root/ihp-sg13g2 from the ORFS
#                     platform + the local minimal libs.tech/librelane config
#   librelane-digital LibreLane digital-only run (requires a usable PDK root,
#                     LibreLane and OpenROAD)
#   librelane-macro   LibreLane full-top run (requires the built PLL_ANALOG
#                     hard-macro views)
#   clean             remove build/
#
# Overrides: ORFS_PLATFORM, SRC_DIR, SG13G2_LIB, YOSYS, LIBRELANE,
# PDK_ROOT, PDK, SCL.
#
# This canary does not ship, pull or assume a LibreLane container image.
set -euo pipefail

CANARY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_DIR="$(cd "$CANARY_DIR/../../.." && pwd)"

ORFS_PLATFORM="${ORFS_PLATFORM:-/opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2}"
SRC_DIR="${SRC_DIR:-$ROOT_DIR/src}"
SG13G2_LIB="${SG13G2_LIB:-$ORFS_PLATFORM/lib/sg13g2_stdcell_typ_1p20V_25C.lib}"
YOSYS="${YOSYS:-yosys}"

PDK="${PDK:-ihp-sg13g2}"
SCL="${SCL:-sg13g2_stdcell}"
PDK_ROOT="${PDK_ROOT:-$CANARY_DIR/build/pdk_root}"
PDK_CONFIG="$PDK_ROOT/$PDK/libs.tech/librelane/config.tcl"

# LibreLane v3.0.16 is present in this environment but not in PATH.
if [[ -z "${LIBRELANE:-}" ]]; then
    if [[ -x /nix/store/ilpnqwsl6gvk6kvavkaljbnzaz3086fd-python3.13-librelane-3.0.16/bin/librelane ]]; then
        LIBRELANE=/nix/store/ilpnqwsl6gvk6kvavkaljbnzaz3086fd-python3.13-librelane-3.0.16/bin/librelane
    else
        LIBRELANE=librelane
    fi
fi

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

Set LIBRELANE=/path/to/librelane (or a wrapper) and re-run.  This canary does
not ship or download a LibreLane container image.

What *has* been proven without LibreLane: pll_logic synthesizes to
sg13g2_stdcell 1.2 V cells (make synth-digital).  Place/route/STA/DRC/LVS
have NOT been run.
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

assemble_pdk_root() {
    local script="$CANARY_DIR/scripts/assemble_pdk_root.sh"
    [[ -x "$script" ]] || die "missing $script"
    ORFS_PLATFORM="$ORFS_PLATFORM" PDK_ROOT="$PDK_ROOT" PDK="$PDK" "$script"
}

cmd="${1:-help}"
case "$cmd" in
    synth-digital)
        have_tool "$YOSYS" || die "Yosys not found ('$YOSYS'). Set YOSYS=/path/to/yosys."
        [[ -s "$SG13G2_LIB" ]] || die "sg13g2 Liberty not found: $SG13G2_LIB"
        [[ -d "$SRC_DIR" ]]     || die "RTL source dir not found: $SRC_DIR"
        mkdir -p "$BUILD_YOSYS"

        # The checked-in .ys has this checkout's absolute paths.  Rewrite them
        # in a build copy when the caller overrides SRC_DIR / SG13G2_LIB.
        ys_in="$CANARY_DIR/scripts/synth_digital.ys"
        ys_run="$BUILD_YOSYS/synth_digital.generated.ys"
        sed -e "s|/opt/adpll_gen/src/|$SRC_DIR/|g" \
            -e "s|/opt/OpenROAD-flow-scripts/flow/platforms/ihp-sg13g2/lib/sg13g2_stdcell_typ_1p20V_25C.lib|$SG13G2_LIB|g" \
            "$ys_in" > "$ys_run"

        say "Yosys:    $(command -v "$YOSYS") ($("$YOSYS" -V 2>/dev/null | head -1))"
        say "RTL:      $SRC_DIR"
        say "Liberty:  $SG13G2_LIB"
        say "Netlist:  $BUILD_YOSYS/pll_logic_net.v"
        say "Log:      $BUILD_YOSYS/yosys.log"
        say

        # set -e + pipefail: a Yosys failure aborts before the success summary.
        ( cd "$CANARY_DIR" && "$YOSYS" -s "$ys_run" 2>&1 | tee "$BUILD_YOSYS/yosys.log" )

        say
        say "Synthesis PASS. Cell usage (tail of build/yosys/stat.rpt):"
        tail -n 8 "$BUILD_YOSYS/stat.rpt" | sed 's/^/  /'
        ;;

    pdk-root)
        assemble_pdk_root
        ;;

    librelane-digital)
        have_tool "$LIBRELANE" || { print_librelane_blocker; exit 2; }
        [[ -s "$PDK_CONFIG" ]] || assemble_pdk_root
        [[ -s "$PDK_CONFIG" ]] || die "PDK LibreLane config still missing: $PDK_CONFIG"
        say "LibreLane: $LIBRELANE"
        say "PDK root:  $PDK_ROOT"
        say "Config:    config.digital.yaml (top = pll_logic)"
        say "Log:       $BUILD_ROOT/librelane_digital.log"
        mkdir -p "$BUILD_ROOT"
        # No official IHP magic/KLayout signoff collateral is installed.
        # These steps need the missing decks (or the design LEF that Magic
        # would have written), so skip them explicitly.  The GDS comes from
        # KLayout.StreamOut (RUN_KLAYOUT_STREAMOUT: true).
        ( cd "$CANARY_DIR" && "$LIBRELANE" --manual-pdk --pdk-root "$PDK_ROOT" --pdk "$PDK" --scl "$SCL" \
            --skip Odb.CheckDesignAntennaProperties \
            --skip Magic.SpiceExtraction \
            --skip Checker.IllegalOverlap \
            config.digital.yaml 2>&1 | tee "$BUILD_ROOT/librelane_digital.log" )
        ;;

    librelane-macro)
        check_macro_views || exit 2
        have_tool "$LIBRELANE" || { print_librelane_blocker; exit 2; }
        [[ -s "$PDK_CONFIG" ]] || assemble_pdk_root
        [[ -s "$PDK_CONFIG" ]] || die "PDK LibreLane config still missing: $PDK_CONFIG"
        say "LibreLane: $LIBRELANE"
        say "PDK root:  $PDK_ROOT"
        say "Config:    config.macro.yaml (top = pll, PLL_ANALOG hard macro)"
        say "Log:       $BUILD_ROOT/librelane_macro.log"
        mkdir -p "$BUILD_ROOT"
        ( cd "$CANARY_DIR" && "$LIBRELANE" --manual-pdk --pdk-root "$PDK_ROOT" --pdk "$PDK" --scl "$SCL" config.macro.yaml 2>&1 | tee "$BUILD_ROOT/librelane_macro.log" )
        ;;

    clean)
        rm -rf "$BUILD_ROOT"
        say "Removed $BUILD_ROOT"
        ;;

    help|-h|--help|"")
        cat <<EOF
Canary for the IHP SG13G2 + Core A digital control.

  synth-digital     Yosys synthesis of pll_logic with sg13g2_stdcell (TT)
  pdk-root          assemble build/pdk_root/ihp-sg13g2 (ORFS views + local
                    minimal libs.tech/librelane config)
  librelane-digital LibreLane digital-only run (requires librelane + OpenROAD)
  librelane-macro   LibreLane full-top run (requires librelane AND the built
                    PLL_ANALOG hard-macro views)
  clean             remove build/

Overrides: ORFS_PLATFORM, SRC_DIR, SG13G2_LIB, YOSYS, LIBRELANE, PDK_ROOT,
PDK, SCL.  No container image is assumed.
EOF
        ;;

    *)
        die "unknown target '$cmd' (use: synth-digital | pdk-root | librelane-digital | librelane-macro | clean)"
        ;;
esac
