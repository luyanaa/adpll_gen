#!/usr/bin/env python3
"""Turn regenerated-chain SPICE results into the TRIM_MASTER_PS table.

Model (docs/DDR1_DLL_ELEMENT_SIZING.md, docs/DDR1_CLOCKING.md):

  With REGEN=1 the TDC measures the REGENERATED master, so the loop servos
  the latch set-path delay D_set down to a residual systematic at CK90:

      CK90 offset = (3/4) * D_set + D_and + D_load   [ps]

  where D_and is the EN gate on the CK90 output only (the master path has
  no gate) and D_load is the residual latch-output load mismatch after the
  matched buf_4 (taken as 0 until STA says otherwise).

  TRIM_MASTER_PS is in MASTER-scale ps (4x CK90), so the nulling value is

      TRIM_MASTER_PS = 4 * CK90 offset = 3*D_set + 4*D_and

  Positive TRIM advances CK90 (shortens the locked segment), which is the
  direction that cancels a LATE CK90.

Usage:
  python3 flow/characterization/ddr1_regen_trim.py \
      --json sim/outputs/ddr1/dll_chain/regen_3corner.json --d-and 50
"""

import argparse
import json


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", required=True)
    ap.add_argument("--d-and", type=float, default=50.0,
                    help="EN-gate delay, CK90 path only (ps; STA value)")
    ap.add_argument("--d-load", type=float, default=0.0,
                    help="residual latch-output load mismatch after buf_4 (ps)")
    ap.add_argument("--spec", type=float, default=200.0,
                    help="CK90 phase spec limit (ps)")
    args = ap.parse_args()

    rows = json.load(open(args.json))
    print(f"{'corner':6s} {'code':>4s} {'duty':>5s} {'D_set':>7s} "
          f"{'CK90 off':>9s} {'TRIM':>7s} {'qc_high':>8s} {'err vs T/2':>10s}")
    trims = []
    for r in rows:
        if "error" in r:
            print(f"{r['corner']:6s} c{r['code']:<3d}  ERROR {r['error'][:60]}")
            continue
        d_set = r.get("d_set_ps")
        qc_high = r.get("qc_high_ps")
        if d_set is None:
            print(f"{r['corner']:6s} c{r['code']:<3d}  (no D_set — measurement failed)")
            continue
        off = 0.75 * d_set + args.d_and + args.d_load
        trim = 3.0 * d_set + 4.0 * (args.d_and + args.d_load)
        trims.append(trim)
        # regenerated duty: expect T/2 = 5000 ps; report the deviation in ps
        duty_err = (qc_high - 5000.0) if qc_high is not None else float("nan")
        print(f"{r['corner']:6s} {r['code']:4d} {r['duty']:5.2f} "
              f"{d_set:7.1f} {off:9.1f} {trim:7.0f} "
              f"{(qc_high if qc_high is not None else float('nan')):8.1f} "
              f"{duty_err:10.1f}")
        if abs(off) > args.spec:
            print(f"       NOTE: raw systematic {off:+.0f} ps is OUTSIDE the "
                  f"+-{args.spec:.0f} ps CK90 spec — TRIM is mandatory at this corner")
    if trims:
        print(f"\nTRIM_MASTER_PS range across corners: "
              f"{min(trims):.0f} .. {max(trims):.0f} ps (spread {max(trims)-min(trims):.0f})")
        print(f"A single fixed TRIM at the midpoint leaves +-{(max(trims)-min(trims))/2:.0f} ps "
              f"master = +-{(max(trims)-min(trims))/8:.0f} ps CK90 of corner residual.")
        print("duty column: OPEN-LOOP regenerated high time at the measured code.\n"
              "At LOCK the loop forces the regenerated master to T, so\n"
              "  qc_high(lock) = T/2 + D_reset - 1.5*D_set\n"
              "which is what the CK90 duty becomes (spec does not constrain CK90\n"
              "duty; see docs/DDR1_DLL_ELEMENT_SIZING.md for the measured effect\n"
              "of INPUT duty on the deep master taps -- the slave barely moves).")


if __name__ == "__main__":
    main()
