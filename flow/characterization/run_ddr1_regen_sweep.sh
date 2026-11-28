#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# DDR1 CK90: regenerated-chain characterization sweep + TRIM table.
#
# Runs the decks that produced docs/DDR1_DLL_ELEMENT_SIZING.md's
# "Regenerated-chain SPICE" section:
#   * SS/TT/FF at the measured lock codes (50% input duty)
#   * TT at 45% / 55% / 60% input duty (sensitivity of the deep taps)
# then converts the D_set numbers into TRIM_MASTER_PS.
#
# Cost: each deck is a 32-element master + 8-element slave at the real
# device level, ~8-12 min single-threaded.  --jobs controls parallelism.
#
# Usage: flow/characterization/run_ddr1_regen_sweep.sh [jobs]
set -u
cd "$(dirname "$0")/../.."
JOBS=${1:-4}
OUT=sim/outputs/ddr1/dll_chain
mkdir -p "$OUT/logs"

python3 - "$JOBS" <<'PY'
import json, sys
sys.path.insert(0, 'flow/characterization')
import ddr1_dll_regen as R
from concurrent.futures import ThreadPoolExecutor

jobs = int(sys.argv[1])
cfgs = [
    dict(corner='ss', code=33, duty=0.50, nelem=8, tstep='10p', ncyc=3, wire=True),
    dict(corner='tt', code=72, duty=0.50, nelem=8, tstep='10p', ncyc=3, wire=True),
    dict(corner='ff', code=94, duty=0.50, nelem=8, tstep='10p', ncyc=3, wire=True),
    dict(corner='tt', code=72, duty=0.45, nelem=8, tstep='10p', ncyc=3, wire=True),
    dict(corner='tt', code=72, duty=0.55, nelem=8, tstep='10p', ncyc=3, wire=True),
    dict(corner='tt', code=72, duty=0.60, nelem=8, tstep='10p', ncyc=3, wire=True),
]

def go(c):
    try:
        return R.run_one(c)
    except Exception as ex:
        return {**c, 'error': repr(ex)[:200]}

with ThreadPoolExecutor(jobs) as ex:
    res = list(ex.map(go, cfgs))

json.dump(res, open('sim/outputs/ddr1/dll_chain/regen_sweep.json', 'w'), indent=1)
for r in res:
    if 'error' in r:
        print("ERR", r['corner'], r['duty'], r['error'][:120])
        continue
    print(f"{r['corner']:2s} c{r['code']:<3d} duty {r['duty']:.2f}: "
          f"D_set {r.get('d_set_master_ps') and round(r['d_set_master_ps'],1)} ps, "
          f"mismatch {r.get('regen_phase_shift_ps') and round(r['regen_phase_shift_ps'],1)} ps, "
          f"qc_high {r.get('qc_high_ps') and round(r['qc_high_ps'])} ps")
PY

echo
echo "=== TRIM_MASTER_PS (D_EN taken as 50 ps; replace with the STA value) ==="
python3 flow/characterization/ddr1_regen_trim.py \
    --json "$OUT/regen_sweep.json" --d-and 50
