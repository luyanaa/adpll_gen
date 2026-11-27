# DLL8 element / line SPICE confirmation (real sg13g2, with wire caps)

Device-level ngspice-44, cornerMOSlv + OSDI PSP103-NQS, and the
DCO_PEX_WIRE routed-cap method (0.96 fF mean/node from the STEP=3 SPEF).
Element: `INVX4 -> mid -> INVX4` with a binary 1:2:4:8:16:32:64 bank of
`sg13g2_nand3_1` switched-cap fingers on `mid` (A=~code, B=mid, C=code),
one `buf_1` + one `inv_1` per code bit. Each element output is loaded by
the next element's INVX4 input + one tap `buf_1` + its wire cap.

Corners: ss 1.08 V / 125 C, tt 1.20 V / 25 C, ff 1.32 V / -40 C.

## 1. Element transfer curve (1 element)

| corner | BASE(c0) ps | delay(c127) ps | LSB ps | max step ps | monotone | tr 10-90 ps | tf 10-90 ps | tf-tr ps |
|---|---|---|---|---|---|---|---|---|
| ss | 374.4 | 462.5 | 0.694 | 1.035 | yes | 167.6 | 167.5 | 108.4 |
| tt | 233.9 | 293.9 | 0.472 | 0.710 | yes | 106.4 | 108.7 | 83.4 |
| ff | 160.8 | 204.8 | 0.346 | 0.534 | yes | 72.9 | 74.2 | 48.1 |

Model vs SPICE (delta):

| corner | model BASE/LSB | SPICE BASE/LSB | BASE delta | LSB delta | model max | SPICE max |
|---|---|---|---|---|---|---|
| ss | 120/4 | 374/0.69 | +254 | -3.31 | 628 | 463 |
| tt | 85/3 | 234/0.47 | +149 | -2.53 | 466 | 294 |
| ff | 60/2 | 161/0.35 | +101 | -1.65 | 314 | 205 |

The real BASE is 3.1x (ss) / 2.8x (tt) / 2.7x (ff) the model. The bank LSB is
0.35-0.69 ps (finer than the 4 ps model), so the *range* is only 44-88 ps,
not 250-500 ps. The always-on NAND3 B-pin gate cap (~0.4 fF x 127 = 51 fF)
raises BASE; the switched contrast (~0.05 fF/finger) is tiny.

## 2. Reach the required d? (single element)

| corner | d_req ps | SPICE max ps | shortfall ps | low end OK (BASE<d)? |
|---|---|---|---|---|
| ss | 500 | 462.5 | 37.5 | yes |
| tt | 375 | 293.9 | 81.1 | yes |
| ff | 250 | 204.8 | 45.2 | yes |

## 3. Chain additivity (loaded 1 / 2 / 8 elements)

| corner | code | 1 el ps | 2 el ps | 8 el ps | 8 x 1el ps | 8el/(8x1el) |
|---|---|---|---|---|---|---|
| ss | 0 | 374.4 | 844.6 | 3669.0 | 2995.2 | 1.225 |
| ss | 64 | 419.1 | 936.7 | 4045.2 | 3352.7 | 1.207 |
| ss | 127 | 462.5 | 1026.4 | 4412.2 | 3700.0 | 1.192 |
| tt | 0 | 233.9 | 526.4 | 2283.3 | 1871.2 | 1.220 |
| tt | 64 | 264.3 | 589.4 | 2541.5 | 2114.4 | 1.202 |
| tt | 127 | 293.9 | 650.7 | 2793.3 | 2351.2 | 1.188 |
| ff | 0 | 160.8 | 357.8 | 1541.2 | 1286.2 | 1.198 |
| ff | 64 | 183.1 | 404.3 | 1732.7 | 1464.7 | 1.183 |
| ff | 127 | 204.8 | 449.5 | 1918.9 | 1638.0 | 1.171 |

The 8-element line is ~1.17-1.23x the sum of 8 isolated elements: the
interconnect + next-element input + tap buffer add ~17-23%. Additive within
that loading, no accumulation surprise.

## 4. Does the 8-element LINE reach the operating period?

| corner | T_req ps | line min ps | line max ps | reachable | code at T | headroom codes | tap7 shortfall ps |
|---|---|---|---|---|---|---|---|
| ss | 4000 | 3669.0 | 4412.2 | yes | 56 | 71 | 0 |
| tt | 3000 | 2283.3 | 2793.3 | NO | >127 | 0 | -207 |
| ff | 2000 | 1541.2 | 1918.9 | NO | >127 | 0 | -81 |

SS reaches 4000 ps (code ~56, 71 codes of headroom). TT cannot reach
3000 ps (short 207 ps) and is too slow for 2000 ps (min 2283). FF cannot
reach 2000 ps (short 81 ps). SS is also too slow for 2000 ps (min 3669).

## 5. Tap duty cycle (square wave)

| corner | 1 element @2ns | 8 elements @corner period | spec 45-55% |
|---|---|---|---|
| ss | 55.7 | 70.2 | FAIL |
| tt | 54.2 | 71.0 | FAIL |
| ff | 52.4 | 68.2 | FAIL |

The element rise/fall is matched in absolute time (tr~tf, SS 168/167 ps) but
its rising and falling *propagation delays* differ by 108 (ss) / 83 (tt) / 48
(ff) ps. Chained 8x, the high time widens by ~0.8 ns (ss) / 0.36 ns (ff), so
the tap duty reaches 64-70% - outside 45-55%.

## 6. Closed-loop re-run with the SPICE line timing substituted

The digital TB (real BASE/LSB now) re-run with the line-derived per-element
BASE/LSB (line delay / 8 at c0 and c127):

| case | BASE ps | LSB ps | LOCKED | E/tap7 ps | worst |phase_k-kT/8| ps | verdict |
|---|---|---|---|---|---|---|
| SS 250 MHz (T=4000) | 458.6 | 0.731 | yes (code 55-57) | 0 | 5 | PASS |
| FF 500 MHz (T=2000) | 192.6 | 0.372 | no (rails 127) | -81 | 81 | FAIL |
| TT 3 ns (T=3000) | 285.4 | 0.502 | no (rails 127) | -207 | 207 | FAIL |
| SS 500 MHz (T=2000) | 458.6 | 0.731 | no (rails 0) | +1669 | 1669 | FAIL |

For the fail cases the per-element delay is short/long, so tap_k =
(k+1)*element and the residual is (k+1)*(element - T/8).

## Summary

- SS 250 MHz: real cells work; 8d=4000 ps reachable at code ~56 (71 codes of
  headroom); re-run conformance 5 ps, duty marginal (element 55.7% @2ns but
  the 8-tap duty is 64-70% -> duty gate FAIL).
- FF 500 MHz: 8d max 1919 ps vs 2000 required -> short 81 ps (4%).
- TT 3 ns: 8d max 2793 vs 3000 -> short 207 ps (7%); TT 2 ns unattainable
  (min 2283 ps).
- Root causes: (i) the NAND3 switched-cap contrast is ~0.05 fF/finger, so the
  bank gives only 44-88 ps of range instead of 250-500 ps, while its 51 fF
  always-on load raises BASE to 161-374 ps; (ii) the NMOS NAND3 stack makes
  tpHL-tpLH = 48-108 ps per element, which accumulates to 63-70% tap duty.
- Proposed fix (not implemented): replace the NAND3 finger bank with a
  symmetric switched `sg13_moscap_n` bank (ring-campaign method) sized for
  ~250 ps of switched range and balanced rise/fall, then re-tune BASE/LSB.
- Plus, if more range is needed: a coarse moscap bank + fine bank.

