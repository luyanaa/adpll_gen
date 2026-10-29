#!/usr/bin/env bash
# Fetch the wafer-space gf180mcuD PDK used by the FD canary.
#
# Usage: ./fetch_gf180mcuD.sh [DEST]
# Default DEST: /tmp/gf180mcu-wafer
#
# The PDK is large and is not vendored in this repository.  The tested commit
# is pinned so the 5-metal FD technology LEF and the single-cut Via2 defaults
# match the reported result.
set -euo pipefail

DEST="${1:-/tmp/gf180mcu-wafer}"
REPO="https://github.com/wafer-space/gf180mcu.git"
COMMIT="ac7d8696de96a4d708e768b607ae37f02207a354"

if [[ ! -d "$DEST/.git" ]]; then
    git clone --filter=blob:none --sparse "$REPO" "$DEST"
fi

git -C "$DEST" fetch origin "$COMMIT"
git -C "$DEST" checkout --detach "$COMMIT"
git -C "$DEST" sparse-checkout set \
    gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0 \
    gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu9t5v0 \
    gf180mcuD/libs.ref/gf180mcu_fd_io \
    gf180mcuD/libs.tech

echo "gf180mcuD ready at: $DEST"
echo "Run with: --manual-pdk --pdk-root $DEST --pdk gf180mcuD"
