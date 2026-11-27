#!/usr/bin/env python3
"""Summarise the dll8 SPICE runs into REPORT.md."""
import json
import os
from pathlib import Path

D = Path("/grid/adpll_gen/flow/characterization/dll8_pex")


def load(name):
    p = D / name
    return json.load(open(p)) if p.exists() else []


E = load("dll8_elem_sweep.json")
C2 = load("dll8_chain2.json")
C8 = load("dll8_chain8.json") + load("dll8_chain8_c64.json")
DUTY1 = load("dll8_duty.json")
DUTY8 = load("dll8_duty8.json") + load("dll8_duty8_tt.json")

# per-corner natural operating point (element delay d = T/8)
REQ = {"ss": dict(T=4000.0, d=500.0), "tt": dict(T=3000.0, d=375.0),
       "ff": dict(T=2000.0, d=250.0)}
MODEL = {"ss": (120.0, 4.0), "tt": (85.0, 3.0), "ff": (60.0, 2.0)}


def by(rows, ne=None):
    out = {}
    for r in rows:
        if "error" in r:
            continue
        if ne is not None and r.get("nelem") != ne:
            continue
        out.setdefault(r["corner"], {})[r["code"]] = r
    return out


def stat(d):
    codes = sorted(d)
    return (d[codes[0]]["delay_ps"], d[codes[-1]]["delay_ps"],
            (d[codes[-1]]["delay_ps"] - d[codes[0]]["delay_ps"]) / (codes[-1] - codes[0]),
            codes)


e = by(E, 1)
c2 = by(C2)
c8 = by(C8)
d1 = by(DUTY1)
d8 = by(DUTY8)

L = []
L.append("# DLL8 element / line SPICE confirmation (real sg13g2, with wire caps)")
L.append("")
L.append("Device-level ngspice-44, cornerMOSlv + OSDI PSP103-NQS, and the")
L.append("DCO_PEX_WIRE routed-cap method (0.96 fF mean/node from the STEP=3 SPEF).")
L.append("Element: `INVX4 -> mid -> INVX4` with a binary 1:2:4:8:16:32:64 bank of")
L.append("`sg13g2_nand3_1` switched-cap fingers on `mid` (A=~code, B=mid, C=code),")
L.append("one `buf_1` + one `inv_1` per code bit. Each element output is loaded by")
L.append("the next element's INVX4 input + one tap `buf_1` + its wire cap.")
L.append("")
L.append("Corners: ss 1.08 V / 125 C, tt 1.20 V / 25 C, ff 1.32 V / -40 C.")
L.append("")

L.append("## 1. Element transfer curve (1 element)")
L.append("")
L.append("| corner | BASE(c0) ps | delay(c127) ps | LSB ps | max step ps | monotone | tr 10-90 ps | tf 10-90 ps | tf-tr ps |")
L.append("|---|---|---|---|---|---|---|---|---|")
for c in ("ss", "tt", "ff"):
    if c not in e:
        continue
    base, top, lsb, codes = stat(e[c])
    steps = [e[c][b]["delay_ps"] - e[c][a]["delay_ps"]
             for a, b in zip(codes, codes[1:])]
    r0 = e[c][codes[0]]
    L.append(f"| {c} | {base:.1f} | {top:.1f} | {lsb:.3f} | {max(steps):.3f} | "
             f"{'yes' if min(steps) >= 0 else 'NO'} | "
             f"{r0.get('rise_10_90_ps') or 0:.1f} | {r0.get('fall_10_90_ps') or 0:.1f} | "
             f"{r0.get('duty_distortion_ps') or 0:.1f} |")
L.append("")
L.append("Model vs SPICE (delta):")
L.append("")
L.append("| corner | model BASE/LSB | SPICE BASE/LSB | BASE delta | LSB delta | model max | SPICE max |")
L.append("|---|---|---|---|---|---|---|")
for c in ("ss", "tt", "ff"):
    if c not in e:
        continue
    base, top, lsb, _ = stat(e[c])
    mb, ml = MODEL[c]
    L.append(f"| {c} | {mb:.0f}/{ml:.0f} | {base:.0f}/{lsb:.2f} | "
             f"{base-mb:+.0f} | {lsb-ml:+.2f} | {mb+127*ml:.0f} | {top:.0f} |")
L.append("")
L.append("The real BASE is 3.1x (ss) / 2.8x (tt) / 2.7x (ff) the model. The bank LSB is")
L.append("0.35-0.69 ps (finer than the 4 ps model), so the *range* is only 44-88 ps,")
L.append("not 250-500 ps. The always-on NAND3 B-pin gate cap (~0.4 fF x 127 = 51 fF)")
L.append("raises BASE; the switched contrast (~0.05 fF/finger) is tiny.")
L.append("")

L.append("## 2. Reach the required d? (single element)")
L.append("")
L.append("| corner | d_req ps | SPICE max ps | shortfall ps | low end OK (BASE<d)? |")
L.append("|---|---|---|---|---|")
for c in ("ss", "tt", "ff"):
    if c not in e:
        continue
    base, top, lsb, _ = stat(e[c])
    dreq = REQ[c]["d"]
    L.append(f"| {c} | {dreq:.0f} | {top:.1f} | {max(0.0, dreq-top):.1f} | "
             f"{'yes' if base < dreq else 'NO'} |")
L.append("")

L.append("## 3. Chain additivity (loaded 1 / 2 / 8 elements)")
L.append("")
L.append("| corner | code | 1 el ps | 2 el ps | 8 el ps | 8 x 1el ps | 8el/(8x1el) |")
L.append("|---|---|---|---|---|---|---|")
for c in ("ss", "tt", "ff"):
    for code in (0, 64, 127):
        a = e.get(c, {}).get(code, {}).get("delay_ps")
        b = c2.get(c, {}).get(code, {}).get("delay_ps")
        x = c8.get(c, {}).get(code, {}).get("delay_ps")
        if None in (a, b, x):
            continue
        L.append(f"| {c} | {code} | {a:.1f} | {b:.1f} | {x:.1f} | {8*a:.1f} | {x/(8*a):.3f} |")
L.append("")
L.append("The 8-element line is ~1.17-1.23x the sum of 8 isolated elements: the")
L.append("interconnect + next-element input + tap buffer add ~17-23%. Additive within")
L.append("that loading, no accumulation surprise.")
L.append("")

L.append("## 4. Does the 8-element LINE reach the operating period?")
L.append("")
L.append("| corner | T_req ps | line min ps | line max ps | reachable | code at T | headroom codes | tap7 shortfall ps |")
L.append("|---|---|---|---|---|---|---|---|")
for c in ("ss", "tt", "ff"):
    if c not in c8:
        continue
    codes = sorted(c8[c])
    lo = c8[c][codes[0]]["delay_ps"]
    hi = c8[c][codes[-1]]["delay_ps"]
    T = REQ[c]["T"]
    # interpolate code at T if reachable
    if lo <= T <= hi:
        cc = None
        for a, b in zip(codes, codes[1:]):
            da, db = c8[c][a]["delay_ps"], c8[c][b]["delay_ps"]
            if da <= T <= db:
                cc = a + (T-da)/(db-da)*(b-a)
        reach = "yes"
        codeT = f"{cc:.0f}" if cc is not None else "?"
        head = f"{127-cc:.0f}" if cc is not None else "?"
        short = "0"
    else:
        reach = "NO"
        codeT = ">127" if hi < T else "<0"
        head = "0"
        short = f"{hi-T:+.0f}"
    L.append(f"| {c} | {T:.0f} | {lo:.1f} | {hi:.1f} | {reach} | {codeT} | {head} | {short} |")
L.append("")
L.append("SS reaches 4000 ps (code ~56, 71 codes of headroom). TT cannot reach")
L.append("3000 ps (short 207 ps) and is too slow for 2000 ps (min 2283). FF cannot")
L.append("reach 2000 ps (short 81 ps). SS is also too slow for 2000 ps (min 3669).")
L.append("")

L.append("## 5. Tap duty cycle (square wave)")
L.append("")
L.append("| corner | 1 element @2ns | 8 elements @corner period | spec 45-55% |")
L.append("|---|---|---|---|")
for c in ("ss", "tt", "ff"):
    a = d1.get(c, {}).get(0, {}).get("duty_pct")
    x = d8.get(c, {}).get(0, {}).get("duty_pct")
    L.append(f"| {c} | {a if a is None else round(a,1)} | "
             f"{x if x is None else round(x,1)} | {'PASS' if (x is not None and 45<x<55) else 'FAIL'} |")
L.append("")
L.append("The element rise/fall is matched in absolute time (tr~tf, SS 168/167 ps) but")
L.append("its rising and falling *propagation delays* differ by 108 (ss) / 83 (tt) / 48")
L.append("(ff) ps. Chained 8x, the high time widens by ~0.8 ns (ss) / 0.36 ns (ff), so")
L.append("the tap duty reaches 64-70% - outside 45-55%.")
L.append("")

L.append("## 6. Closed-loop re-run with the SPICE line timing substituted")
L.append("")
L.append("The digital TB (real BASE/LSB now) re-run with the line-derived per-element")
L.append("BASE/LSB (line delay / 8 at c0 and c127):")
L.append("")
L.append("| case | BASE ps | LSB ps | LOCKED | E/tap7 ps | worst |phase_k-kT/8| ps | verdict |")
L.append("|---|---|---|---|---|---|---|")
L += ["| SS 250 MHz (T=4000) | 458.6 | 0.731 | yes (code 55-57) | 0 | 5 | PASS |",
      "| FF 500 MHz (T=2000) | 192.6 | 0.372 | no (rails 127) | -81 | 81 | FAIL |",
      "| TT 3 ns (T=3000) | 285.4 | 0.502 | no (rails 127) | -207 | 207 | FAIL |",
      "| SS 500 MHz (T=2000) | 458.6 | 0.731 | no (rails 0) | +1669 | 1669 | FAIL |"]
L.append("")
L.append("For the fail cases the per-element delay is short/long, so tap_k =")
L.append("(k+1)*element and the residual is (k+1)*(element - T/8).")
L.append("")

L.append("## Summary")
L.append("")
L.append("- SS 250 MHz: real cells work; 8d=4000 ps reachable at code ~56 (71 codes of")
L.append("  headroom); re-run conformance 5 ps, duty marginal (element 55.7% @2ns but")
L.append("  the 8-tap duty is 64-70% -> duty gate FAIL).")
L.append("- FF 500 MHz: 8d max 1919 ps vs 2000 required -> short 81 ps (4%).")
L.append("- TT 3 ns: 8d max 2793 vs 3000 -> short 207 ps (7%); TT 2 ns unattainable")
L.append("  (min 2283 ps).")
L.append("- Root causes: (i) the NAND3 switched-cap contrast is ~0.05 fF/finger, so the")
L.append("  bank gives only 44-88 ps of range instead of 250-500 ps, while its 51 fF")
L.append("  always-on load raises BASE to 161-374 ps; (ii) the NMOS NAND3 stack makes")
L.append("  tpHL-tpLH = 48-108 ps per element, which accumulates to 63-70% tap duty.")
L.append("- Proposed fix (not implemented): replace the NAND3 finger bank with a")
L.append("  symmetric switched `sg13_moscap_n` bank (ring-campaign method) sized for")
L.append("  ~250 ps of switched range and balanced rise/fall, then re-tune BASE/LSB.")
L.append("- Plus, if more range is needed: a coarse moscap bank + fine bank.")
L.append("")

(D / "REPORT.md").write_text("\n".join(L) + "\n")
print("\n".join(L))
