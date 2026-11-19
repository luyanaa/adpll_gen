#!/bin/bash
# Print the signoff summary of a run directory.
set -u
R=${1:-$(ls -dt /grid/adpll_gen/flow/canary/ihp130_sg13g2_core_a/runs/RUN_* | head -1)}
echo "run: $R"
if [ -f "$R/final/metrics.json" ]; then
  python3 - "$R/final/metrics.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
print(f"{'corner':22s} {'holdWS':>8s} {'holdv':>6s} {'setupWS':>9s} {'setupv':>7s}")
for c in ('nom_tt_025C_1v20', 'nom_ss_125C_1v08', 'nom_ff_n40C_1v32'):
    print(f"{c:22s} "
          f"{d.get('timing__hold__ws__corner:'+c, 0):8.4f} "
          f"{d.get('timing__hold_vio__count__corner:'+c, -1):6d} "
          f"{d.get('timing__setup__ws__corner:'+c, 0):9.4f} "
          f"{d.get('timing__setup_vio__count__corner:'+c, -1):7d}")
PY
else
  echo "  metrics pending"
fi
D="$R/55-openroad-stapostpnr/nom_ss_125C_1v08"
if [ -d "$D" ]; then
  echo "  NE_CLK clocks: $(grep -cE '^Clock: NE_CLK' "$D/clock.rpt" 2>/dev/null)"
  grep -oE 'There are [0-9]+ unclocked register/latch pins' "$D/checks.rpt" 2>/dev/null | head -1 | sed 's/^/  /'
fi
