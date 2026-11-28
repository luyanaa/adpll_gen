#!/usr/bin/env python3
"""Parse DDR1 DQS tap-measurement OpenSTA log -> per-tap delay table + checks.

Usage: ddr1_dqs_taps_check.py LOG CORNER --csv OUT.csv
Checks (requirements doc sec 3.2): range >= 5.0 ns at code 127 (or reports the
code reaching 5ns), steps <= 200 ps, strictly monotone, max/nominal <= 1.5.
Exit 1 on violation.
"""
import sys, re, csv

def parse(path):
    taps = {}
    cur = None
    for line in open(path):
        m = re.match(r"=== TAP(\d+) ===", line)
        if m:
            cur = int(m.group(1)); continue
        # full_clock_expanded: lines like "    1.234   data arrival time"
        m = re.match(r"\s*([\d.]+)\s+data arrival time", line)
        if m and cur is not None:
            taps[cur] = float(m.group(1)); cur = None
    return taps

def main():
    log, corner = sys.argv[1], sys.argv[2]
    csv_path = None
    if "--csv" in sys.argv:
        csv_path = sys.argv[sys.argv.index("--csv") + 1]
    taps = parse(log)
    if len(taps) < 100:
        print(f"FAIL {corner}: only {len(taps)} taps parsed"); sys.exit(1)
    rows = []
    prev = None
    for t in sorted(taps):
        d = taps[t]
        step = None if prev is None else (d - prev) * 1000.0  # ps
        rows.append((t, d, step))
        prev = d
    if csv_path:
        with open(csv_path, "w", newline="") as f:
            w = csv.writer(f); w.writerow(["tap", "delay_ns", "step_ps"])
            for r in rows: w.writerow(r)
    rng = rows[-1][1] - rows[0][1]
    steps = [r[2] for r in rows if r[2] is not None]
    neg = [s for s in steps if s <= 0]
    mx, mn, avg = max(steps), min(steps), sum(steps) / len(steps)
    nominal = rng * 1000 / (len(rows) - 1)
    code5ns = next((r[0] for r in rows if r[1] - rows[0][1] >= 5.0), None)
    print(f"{corner}: range={rng*1000:.0f}ps over {len(rows)-1} steps; "
          f"step min/avg/max = {mn:.1f}/{avg:.1f}/{mx:.1f} ps; "
          f"neg={len(neg)}; max/nominal={mx/nominal:.2f}; 5ns at tap {code5ns}")
    ok = True
    if neg: print(f"FAIL {corner}: {len(neg)} non-positive steps"); ok = False
    if mx > 200: print(f"FAIL {corner}: max step {mx:.1f} > 200 ps"); ok = False
    if mx / nominal > 1.5: print(f"FAIL {corner}: max/nominal {mx/nominal:.2f} > 1.5"); ok = False
    if rng * 1000 < 5000: print(f"FAIL {corner}: range {rng*1000:.0f} < 5000 ps"); ok = False
    if ok: print(f"PASS {corner}")
    sys.exit(0 if ok else 1)

main()
