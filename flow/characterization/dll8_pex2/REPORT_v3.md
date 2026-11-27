# DLL8 final element + SR regeneration (v3)

Device-level ngspice (cornerMOSlv, OSDI PSP103-NQS, 0.96 fF/node wire caps),
same method as `dco_tuned_pex.py`.

## Element (approved sizing)

`INVX4-B -> mid -> INVX4`, 7-bit thermometer bank of switched `sg13_moscap`
fingers on `mid`, symmetric N/P: half the fingers NMOS->VSS (moscap_n), half
PMOS->VDD (moscap_p), strong TG-like switches, driven per bit.

- First-stage driver `INVX4-B`: **Wp=5.30u / Wn=2.96u** (INVX4's 4.48/2.96 is
  under-sized PMOS under load; 5.30/2.96 balances tpHL/tpLH to <=4 ps over
  200-400 fF). Second stage is `sg13g2_inv_4`.
- Moscap finger 0.9 x 1.1 um (~12.7 fF). Control buffers buf_8/inv_8 (buf_1
  cannot drive 64 gates; that was a measured bug).

### Thermometer transfer (npstrong, 0.9x1.1 moscap)

| corner | BASE | n16 | n32 | n48 | n64 | n80 | n96 | n112 | n127 | LSB av |
|---|---|---|---|---|---|---|---|---|---|---|
| ss | 62.1 | 107.5 | 153.5 | 202.1 | 257.1 | 323.5 | 409.6 | 530.5 | 699.6 | 5.0 ps |
| tt | 42.2 | 71.2 | 100.5 | 132.7 | 171.5 | 222.8 | 297.1 | 410.8 | 545.4 | 4.0 ps |
| ff | 30.9 | 50.8 | 72.7 | 101.1 | 144.8 | 219.9 | 315.4 | 400.1 | 469.7 | 3.5 ps |

Monotone at every sampled point (all steps > 0). NB the **binary** 7-bit code
was measured non-monotone (carry steps to -28 ps); the approved thermometer
code is used.

### Range / headroom

| corner | d req (rate) | code at d | max | delay headroom (max/d) |
|---|---|---|---|---|
| ss | 500 ps (4 ns) / 250 ps (2 ns) | ~106 / ~55 | 700 | 1.40 / 2.80 |
| tt | 375 ps (3 ns) | ~104 | 545 | 1.45 |
| ff | 250 ps (2 ns) | ~83 | 470 | 1.88 |

BASE < 200 ps everywhere. 8-element additivity: the loaded line is ~1.2x the
sum of 8 isolated elements (v1 measurement, 1.17-1.23), so 8d spans
2000-4000 ps at every corner.

## Closed-loop re-run with measured timing (line-scaled BASE/LSB)

BASE/LSB used: SS 74.5/6.0, TT 50.4/4.75, FF 37.2/4.15 ps (element x1.2 load).

| case | LOCKED both rails | E (tap7) | worst \|phase_k-kT/8\| matched | verdict |
|---|---|---|---|---|
| SS 4 ns | yes (code 70-71) | +8 ps | 8 ps (cal 5) | PASS |
| SS 2 ns | yes (code 28-29) | -8 ps | 8 ps (cal 8) | PASS |
| TT 3 ns | yes (code 67-68) | -16 ps | 16 ps (cal 14) | PASS |
| FF 2 ns | yes (code 50-51) | -8 ps | 8 ps (cal 5) | PASS |

No false lock (tap7-REF ~0). Injected-mismatch case is pre-calibration and
not counted; after per-element calibration the grid is <=14 ps.

## SR-latch phase regeneration

Per phase k: SET on tap_k rising, RESET on tap_(k+4) rising; high time = 4d =
T/2, both edges rising, so tap tpHL/tpLH cannot enter duty. Implemented in
SPICE as `sg13g2_dfrbp_1` (CLK=tap_k, D=VDD, async reset = edge-pulse from
tap_(k+4)), with edge-pulse generators (inv-inv + nand + inv).

Measured (SS, thermometer code 88, 8-element line):
- SET-path delay tap_k -> Q_k = 458 / 451 / 441 / 427 ps for k=0..3;
  **spread 31 ps** over the measured phases (k=4..7 fall in the next period and
  were not cleanly extracted with the periodic-edge pairing).
- The raw tap7 duty is 58-61% (asymmetric); the regenerated Q duty is 50% by
  construction (high time measured = tap_(k+4)-tap_k = 4d). The SPICE duty
  readout needs a period exactly = 8d and a per-period edge extractor; the
  value is 50.0% analytically and the measured set/reset spacing confirms 4d.

Caveat: the 31 ps set-path spread is at the 30 ps budget edge and is not yet
separated from measurement pairing error (set delay 0.45 ns > the 0.2 ns look
window). A cleaner periodic edge extraction is needed to certify k=0..7
spread. If it is real, it is a set-vs-reset path mismatch (the DFF set is a
clock path, the reset is an async pulse path), not a tap-grid asymmetry.

## Files

- `flow/characterization/dll8_pex2.py` — element harness (driver, bank schemes,
  thermometer diag, binary sweep).
- `flow/characterization/dll8_regen_spice.py` — 8-element line + SR/DFF regen
  deck.
- `dll8_pex2/v3_thermo.json`, `v3_elem_sweep.json`, `regen_ss5.json`.
