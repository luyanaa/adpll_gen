# DLL8 v2 element resize — SPICE result (last M4 gate)

Device-level ngspice (cornerMOSlv, OSDI PSP103-NQS, 0.96 fF/node wire caps).
Element kept as `INVX4-ish -> mid -> INVX4`; the `sg13g2_nand3_1` finger bank
was replaced by switched capacitors, and the first-stage driver was re-sized.

## 1. Driver: INVX4's PMOS is under-sized when the mid node is loaded

`sg13g2_inv_4` is Wp=4.48u / Wn=2.96u (Wp/Wn=1.51). Under a capacitive load the
PMOS is too weak, so `mid` rises slower than it falls and tpHL-tpLH is large.
Sweeping a custom first-stage inverter against a *linear* load (0.96 fF wire +
C on mid):

| Wp/Wn (load 200-400 fF) | tpHL-tpLH (SS) | (FF) |
|---|---|---|
| 4.48u / 2.96u (INVX4) | +45 ... +64 ps | +16 ... +28 ps |
| **5.30u / 2.96u (chosen)** | **+0.6 ... +3.7 ps** | **+1.9 ... +5.0 ps** |
| 5.60u / 2.96u | -13 ... -20 ps | -3 ... -5 ps |

So the first stage uses `DLL8_INV4B` Wp=5.30u / Wn=2.96u. The second stage stays
`sg13g2_inv_4` (its load is small, its own asymmetry ~1-4 ps).

## 2. BASE (bank off), wire+load included

| corner | BASE ps |
|---|---|
| ss | 62.1 |
| tt | 42.2 |
| ff | 30.9 |

All well under the <200 ps (SS) / <250 ps (TT/FF) requirement.

## 3. Bank topology and duty

Measured tpHL-tpLH of a thermometer bank on mid (strong switches):

| scheme | n8 | n16 | n32 | n64 |
|---|---|---|---|---|
| sg13_moscap, NMOS-switched to VSS (ring style) | 18 (ss) | 22 | 46 | 161 |
| sg13_moscap, half NMOS->VSS / half PMOS->VDD | 18 | 51 | 137 | 321 |
| **half NMOS->VSS / half PMOS->VDD + linear cap** | **-3.9** | **-5.8** | **-1.9** | **+4.9** |
| same, FF | -1.0 | +0.3 | +5.4 | +9.0 |

The user's symmetric N/P scheme works, but only with a **linear** capacitor:
the moscap's voltage-dependent capacitance is itself a large asymmetric load
(17-320 ps), and no switch/driver sizing removes it.

## 4. Range with the symmetric N/P bank + linear cap (per-finger ~10 fF ideal)

Delay (ps) vs fingers, thermometer:

| corner | base | n16 | n32 | n64 | n96 | n127 | per-finger |
|---|---|---|---|---|---|---|---|
| ss | 62 | 151 | 257 | 487 | 739 | 1002 | ~7.4 ps |
| tt | 42 | - | - | - | 465 | 635 | ~4.7 ps |
| ff | 31 | 69 | 116 | 222 | 346 | 477 | ~3.5 ps |

Sizing to span 250-500 ps at every corner with >=15% headroom (575 ps max),
FS FF needs ~575 ps: with 127 fingers (7-bit) the cap must be ~12-13 fF/finger
(FF per-finger 4.2-4.5 ps -> 31+127*4.4 ~= 590 ps; SS max ~1200 ps).
Resulting element: BASE 62/42/31 ps, LSB ~9-10 ps (ss) / ~4-5 ps (ff),
range covers 250-500 ps at all corners, LSB <= 20 ps.

## 5. Blocker: no small linear switched capacitor in this environment

- `sg13_moscap_n/p`: available, but nonlinear -> duty fails (section 3).
- `cap_cmomi` / `cap_cmomf` (MOM, the small linear devices that would make the
  nplin bank physical): the `.lib` wrappers exist but **the OSDI binaries are
  not installed** (`libs.tech/ngspice/osdi/` has only psp103, psp103_nqs,
  r3_cmc, mosvar). Could not be simulated.
- `cap_cmim` (MIM): plain subckt, linear, but the model's valid size is
  7x7 um minimum (~70 fF/finger) -> LSB ~90 ps at SS, far above the 20 ps spec.

So the resize meets BASE and the range, and the topology meets the duty
(<=9 ps/element with a linear cap -> forecast 51-53% tap duty), but a *physical*
small linear cap is unavailable here.

## Proposed remedy (not implemented — device/model decision)

1. Install the MOM OSDI (`cap_cmomf.osdi` / `cap_cmomi.osdi`) and use a
   ~12 fF `cap_cmomf` finger (>=2.5x2.5 um) in the N/P symmetric bank; the
   nplin data predicts it meets both gates, or
2. keep the moscap bank and add a duty-cycle corrector (DCC) at each tap, or
3. accept a larger LSB with MIM fingers and add a fine moscap/trim layer.

## Files

- `flow/characterization/dll8_pex2.py` — v2 harness (custom driver, switched
  bank schemes `tg`, `np`, `nplin`, thermometer `diag`).
- `dll8_pex2/*.json` — raw measurements (`v2_diag*`, `v2_lin*`, `v2_nplin*`,
  `v2_npstrong`, `v2_size`).
