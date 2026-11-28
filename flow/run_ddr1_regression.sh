#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# DDR1 clocking regression runner (reproducibility target for the ddr-phy
# handoff; see docs/DDR1_HANDOFF.md and docs/DDR1_CLOCKING.md).
#
# Runs every DDR1 testbench with an explicit file list, checks the
# self-checking summary, and reports a single PASS/FAIL.  Each TB exits
# nonzero on failure and prints "SUMMARY: N checks, 0 errors".
#
# Usage:
#   flow/run_ddr1_regression.sh            # all TBs
#   flow/run_ddr1_regression.sh clock dll  # subset by name
#
# Exit: 0 = all selected TBs pass, 1 = any failure, 2 = build error.
set -u
cd "$(dirname "$0")/.."
OUT=/tmp/opencode/ddr1_reg
mkdir -p "$OUT" sim/outputs/ddr1

# Common RTL (behavioral path).  The structural pieces are always compiled
# too so any elaboration breakage shows up in the same run.
RTL_COMMON="src/ddr1_dll_tdc.v src/ddr1_dll_phys.v src/ddr1_phys_elab_stub.v \
            src/fine_delay.v src/sim_mux.v src/pll_cells_elab_stub.v \
            flow/macro/dll8_line4_macro/dll8_line4.v"

FILES_CLOCK="src/ddr1_clock_top_tb.v src/ddr1_clock_top.v src/ddr1_clk_de3.v src/ddr1_ck90_dll.v"
FILES_DLL="src/ddr1_ck90_dll_tdc_tb.v src/ddr1_ck90_dll.v"
FILES_TDC="src/ddr1_dll_tdc_tb.v"   # ddr1_dll_tdc.v comes from RTL_COMMON
FILES_JIT="src/ddr1_jitter_tb.v src/ddr1_clock_top.v src/ddr1_clk_de3.v src/ddr1_ck90_dll.v"
FILES_DUTY="src/ddr1_duty_tb.v src/ddr1_clock_top.v src/ddr1_clk_de3.v src/ddr1_ck90_dll.v"
FILES_CMP="src/ddr1_ck90_compare_tb.v src/ddr1_ck90_de2.v src/ddr1_ck90_dll.v"
FILES_DQS="src/ddr1_dqs_delay_tb.v src/ddr1_dqs_delay_line_phys.v src/ddr1_dqs_delay.v"
FILES_DE3="src/ddr1_clk_de3_tb.v src/ddr1_clk_de3.v"

fail=0
run_tb() {  # name expected_checks files...
    local name=$1 exp=$2; shift 2
    local files="$*"
    if [ -n "${SELECT:-}" ] && ! echo "$name" | grep -qE "$SELECT"; then
        return 0
    fi
    printf '=== %-10s ' "$name"
    if ! iverilog -g2012 -DSIMULATION -o "$OUT/$name.vvp" $files $RTL_COMMON > "$OUT/$name.build.log" 2>&1; then
        echo "BUILD FAIL ($OUT/$name.build.log)"; fail=1; return 0
    fi
    if ! vvp "$OUT/$name.vvp" > "$OUT/$name.log" 2>&1; then
        echo "RUN FAIL ($OUT/$name.log)"; fail=1; return 0
    fi
    # Accept either summary dialect used in this repo:
    #   "SUMMARY: N checks, 0 errors"   or   "TB done[, N checks], errors=0"
    if grep -qaE 'SUMMARY: [0-9]+ checks, 0 errors|errors=0 *===|done, errors=0' "$OUT/$name.log"; then
        n=$(grep -oaE 'SUMMARY: [0-9]+ checks|done, [0-9]+ checks' "$OUT/$name.log" \
            | grep -oaE '[0-9]+' | head -1)
        # TBs that only print "TB done, errors=0": count the PASS lines instead
        [ -z "${n:-}" ] && n=$(grep -caE '^PASS' "$OUT/$name.log")
        echo "PASS ${n:-?} checks"
        if [ -n "$exp" ] && [ -n "${n:-}" ] && [ "$n" != "$exp" ]; then
            echo "  NOTE: check count changed (expected $exp) — update this script if intentional"
        fi
    else
        echo "CHECK FAIL ($OUT/$name.log)"; fail=1
    fi
}

SELECT="${1:-}"
[ -n "$SELECT" ] && shift || true

run_tb clock 87  $FILES_CLOCK
run_tb dll   27  $FILES_DLL
run_tb tdc   11  $FILES_TDC
run_tb jitter 8  $FILES_JIT
run_tb duty   18 $FILES_DUTY
run_tb compare 84 $FILES_CMP
[ -f src/ddr1_dqs_delay_tb.v ]              && run_tb dqs  "" $FILES_DQS
[ -f src/ddr1_clk_de3_tb.v ]          && run_tb de3  "" $FILES_DE3

echo "----------------------------------------"
if [ "$fail" -eq 0 ]; then echo "DDR1 REGRESSION: PASS"; exit 0; else echo "DDR1 REGRESSION: FAIL"; exit 1; fi
