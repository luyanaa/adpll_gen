# Std-cell switched-cap finger — measurement report

Scope: measurement only. The committed DLL8 design (`src/dll8_line.v`) and the
custom-layout lane (`flow/macro/dll8_cells/`) were not modified. All work is
in `flow/characterization/stdcell_finger/`; scratch decks are under
`/tmp/opencode/stdcell_finger/`.

Harness: `stdcell_finger.py` (reuses the corner/OSDI/measure helpers of
`flow/characterization/dll8_pex2.py`). Device-level ngspice-44, real
`sg13g2_stdcell.spice` + `sg13_lv_*` OSDI PSP103-NQS, same corners:

| corner | VDD | T |
|---|---|---|
| ss | 1.08 V | 125 °C |
| tt | 1.20 V |  25 °C |
| ff | 1.32 V | -40 °C |

Element under test is the DLL8 element: `sg13g2_inv_4` → `mid` →
`sg13g2_inv_4`, with the reference 0.96 fF/node wire cap. Delay is the 50 %
IN→OUT crossing of a slow pulse; contrast = delay(EN) − delay(tri-stated).

## Headline

**Verdict: (C) not viable as a pure-std-cell replacement — for the exact
topology requested.**

`sg13g2_ebufn_*` is not a series switch. The Liberty function is `Z = A`
and the SPICE transistor view is an input inverter followed by a second,
tri-stated inverter. `Z` (the node that carries the load-inverter gate cap)
is an **actively driven buffered copy of `MID`**, not a conductive connection
to `MID`. The load capacitance therefore sits on the buffer output and never
loads `MID`; enabling/disabling it changes `MID` loading by essentially
nothing. Measured contrast of the requested finger over SS/TT/FF and over
`inv_4`/`inv_8`/`inv_16` caps: **0.002–0.016 ps** (i.e. 0 fF), with all cap
sizes and all four output terminations. The other mux-like cell,
`sg13g2_mux2_1`, was checked the same way (A0=MID, A1=VSS, cap on X):
**0.43 ps at TT** — it too actively drives X rather than passing A0, so it
does not help (evidence: `contrast_mux_tt.json`, `ac_mux_tt.json`).

A corrected finger using a real CMOS transmission gate *does* work
(21.6 ps at SS with `inv_16`, 5.6× the moscap finger), but a transmission
gate is not a standard cell: it requires one small custom/analog cell. The
rest of this report quantifies both the as-requested cell and that TG path.

## Evidence that `ebufn` tri-states but is a buffer

`ebufn_tristate_check.py` / `.json`: DC sweep A = 0…VDD, Z loaded with 1 GΩ.

| A (V) | Z enabled (TE_B=0) | Z disabled (TE_B=VDD) |
|---|---|---|
| 0.0 | 0.000 | 0.085 |
| 0.4 | 0.000 | 0.085 |
| 0.8 | 1.200 | 0.145 |
| 1.2 | 1.200 | 0.146 |

Disabled `Z` floats (does not track A): the cell *is* tri-state. But
enabled `Z` is a driven copy of A — that is the problem, not the enable.

## 1. Finger contrast (the decisive number)

`contrast.json`, `ac.json`, `cal.json`. Effective fF is the delay swing
divided by the local 10→20 fF calibration secant (SS 1.33, TT 0.767,
FF 0.481 ps/fF).

| corner | finger | switch | contrast | inferred swing | OFF residual vs no-finger | ON power @500 MHz |
|---|---|---|---|---|---|---|
| ss | inv_16 + **ebufn_4** | buffer (as asked) | **0.006 ps** | **0 fF** | 17.8 fF (AC @mid) / ~4 fF (delay) | 52.9 µW |
| tt | inv_16 + **ebufn_4** | buffer (as asked) | **0.003 ps** | **0 fF** | 19.7 fF / ~4 fF | 69.5 µW |
| ff | inv_16 + **ebufn_4** | buffer (as asked) | **0.002 ps** | **0 fF** | 20.6 fF / ~4 fF | 95.0 µW |
| ss | inv_16 + **TG** | PDK NMOS/PMOS pass | **21.63 ps** | 16.2 fF | 8.1 fF (delay) / 6.2 fF (AC) | 52.9 µW |
| tt | inv_16 + **TG** | PDK NMOS/PMOS pass | **12.57 ps** | 16.4 fF | 7.8 fF / 5.9 fF | 69.5 µW |
| ff | inv_16 + **TG** | PDK NMOS/PMOS pass | **8.65 ps** | 18.0 fF | 7.5 fF / 5.7 fF | 95.0 µW |

Moscap reference (`dll8_pex2/finger_test.py`, 127 × 1.0×1.0 µm): 3.83 / 3.19 /
3.18 ps per finger at SS/TT/FF for a ~12.8 fF moscap, passive. So the as-asked
std-cell finger is **0×** the moscap; the corrected TG finger is **5.6×** it.
The 5.6× is not because the TG cap is bigger (its delay-effective swing is
only ~16 fF, roughly one moscap finger): it is because the TG's 2.96/4.48 µm
CMOS pass device is a far stronger switch than the moscap finger's
0.50/0.45 µm NMOS, so it transfers the charge that the moscap switch leaves
behind near the rails.

The TG swing does not scale with the cap-cell size the way a linear cap would
(SS: inv_4 10.7 fF, inv_8 12.8 fF, inv_16 16.2 fF). The TG's own switched
charge dominates the small finger; the inv_16 gate adds only ~5 fF more than
inv_4 at the switching edge, although its mid-bias small-signal capacitance is
large (inv_4 73, inv_8 125, inv_16 230 fF at SS; Miller at the metastable
point, an upper bound, not the large-signal effective value).

## 2. Off-state residual / floating-node X

`resid_tg.json`, `power_tg.json`, `crowbar_inv*.json`.

- **Normal disable** (finger enabled first, then TE_B raised while `MID`
  keeps switching): X remains at a rail, not mid-rail. `x_midrail_frac = 0`
  at every disable phase (5.00/5.25/5.50/5.75 ns) at SS/TT/FF; X ended at
  0.02 V or ~VDD, and the load-inverter output settled at the opposite rail.
  So a finger that was previously enabled does **not** sit at mid-rail.
- **Never-enabled / power-up** (X floating from the all-zero initial state):
  X charges to ~0.57·VDD through the off-TG/Miller coupling and stays there.
  Measured at FF: X = 0.758 V, Y = 0.06 V, and the `inv_16` draws a
  continuous **350 µA** crowbar current. This is the failure mode to guard.
- DC crowbar of `inv_16` vs input bias (bias = 0.5·VDD):
  SS 98.5 µA, TT 215 µA, FF 514 µA (inv_8: 49/108/257 µA; inv_4:
  25/54/129 µA). A 24-finger bank with X stuck mid-rail at FF would burn
  ≈12 mA / 16 mW in one element. A keeper (weak hold device or a real
  complementary TG to a rail when disabled) is **mandatory** for the TG path.
- Off-state capacitance on `MID` is large: ~7.5–8.1 fF per TG finger, nearly
  independent of cap-cell size, because it is the TG off-capacitance coupling
  the floating X. This is why a 32-finger bank has BASE ≈ 270 ps at SS.

## 3. Load-inverter output termination

`contrast.json`, `power_tg.json` (TG, inv_16).

| termination | contrast SS/TT/FF | ON power vs none (SS/TT) | remark |
|---|---|---|---|
| (a) small fixed load (`inv_1`) | 21.6 / 12.6 / 8.7 ps | +52.9 / +69.5 µW | works; extra dynamic power |
| (b) 1 GΩ to VDD | 21.6 / 12.6 / 8.7 ps | +52.9 / +69.5 µW | **does not suppress switching**; identical to open. It only defines the disabled DC, and adds nothing useful |
| (open, dangling) | 21.6 / 12.6 / 8.7 ps | +50.2 / +65.9 µW | lowest power, but a dangling output is an ERC/PnR violation |
| (c) input-drain short (diode) | **−4.4 / −3.5 / −2.9 ps** | +? (dominates: 125–309 µW total) | unusable: negative contrast (the "cap" bootstraps and the diode conducts) |

Pick: **(a) small fixed load** if the flow needs every output terminated;
otherwise open is electrically least-bad. The 1 GΩ pull (b) is not a power
fix — the inverter still swings, so the resistor only supplies ~VDD/R DC when
X is mid-rail and reduces nothing. The diode-connected variant (c) is not a
capacitor at all and burns crowbar current; reject.

## 4. Element-level bank (thermometer, TG path)

`bank_tg*.json`. Standard two-`inv_4` element, Cmid = 0.96 fF, loaded as in
the reference; `n_on` fingers enabled, `N` total fingers all present.

| bank | corner | BASE (n=0) | MAX (n=N) | range | LSB (0→1) |
|---|---|---|---|---|---|
| 16 × inv_16 | ss | 165.4 | 726.4 | 561.1 | 27.2 |
| 16 × inv_16 | tt |  98.1 | 457.5 | 359.4 | 16.4 |
| 16 × inv_16 | ff |  65.4 | 332.7 | 267.3 | 11.5 |
| 32 × inv_16 | ss | 270.1 | 1480.1 | 1210.1 | 29.7 |
| 32 × inv_8  | ss | 270.1 | 1039.3 | 769.3 | **20.6** |
| 24 × inv_8  | ss | 218.5 | 783.2 | **564.7** | **20.0** |
| 32 × inv_8  | tt | 156.7 | 645.2 | 488.5 | 12.7 |
| 32 × inv_8  | ff | 102.1 | 456.5 | 354.4 | 9.1 |

Monotone in every case (all increments positive).

Requirement: SS range ≥ 508 ps, LSB ≤ 22.7 ps, BASE < d.

- 16 × inv_16 at SS: range 561 ps (pass) but LSB 27.2 ps (fails by 1.2×).
- **24 × inv_8 at SS: range 564.7 ps and LSB 20.0 ps — meets both.**
- 32 × inv_8 at SS: range 769 ps, LSB 20.6 ps — more margin, more area/power.

**N-finger answer (TG path): ~24 fingers of inv_8** (or 16 × inv_16 plus one
fine inv_4 finger for LSB). BASE is 219–270 ps at SS vs the moscap 173.6 ps.
This is *only* for the corrected TG cell; the as-asked ebufn bank has zero
range.

## 5. Power / noise

`power_tg.json`, `power_tg_inv8.json`, `power_ebufn.json`, 500 MHz (2 ns).

| finger | corner | ON added power | proper OFF added power |
|---|---|---|---|
| inv_8 + TG | ss / tt / ff | 32.6 / 41.9 / 54.6 µW | ~3.8 / 4.6 / (mid-rail artifact) |
| inv_16 + TG | ss / tt / ff | 52.9 / 69.5 / 95.0 µW | ~3.8 / 6.5 / (mid-rail artifact) |
| inv_16 + ebufn | ss / tt / ff | 58.6 / 77.1 / 103.5 µW | 7.6 / 15.0 / (mid-rail artifact) |

The `ff` OFF figures of 160–435 µW are the never-enabled floating-X
crowbar case (§2), not a normal disabled finger.

For 24 enabled inv_8 fingers: **0.8–1.3 mW per element at 500 MHz**
(SS→FF), ×8 elements in the line = **6.4–10.5 mW** for the whole DLL, and
that is with every finger enabled. A moscap bank is passive (leakage only).
The switching load inverters also inject rail current and Miller charge into
`mid` every edge; the moscap bank does not. This is a new simultaneous-
switching-noise source on the delay supply, on top of the DLL's own jitter
budget.

## Final table (per corner)

| | moscap finger (ref) | stdcell finger as asked (`ebufn_4` + `inv_16`) | TG path (`inv_16`, corrected) |
|---|---|---|---|
| contrast SS / TT / FF | 3.83 / 3.19 / 3.18 ps | **0.006 / 0.003 / 0.002 ps** | 21.6 / 12.6 / 8.7 ps |
| effective swing | ~12.8 fF physical (~2.7 fF delay-effective) | **0 fF** | ~16–18 fF |
| OFF residual | ~0.7 fF (127-finger BASE, inferred) | ~4 fF (delay) / 18–21 fF (AC @mid) | 7.5–8.1 fF |
| power (per finger, 500 MHz) | passive (~0) | 53–104 µW while "enabled", 8–15 µW "disabled" | 33–95 µW enabled |
| extra cell needed | moscap + switch (custom) | none (but does nothing) | **one custom TG** |
| N for 508 ps @SS / LSB ≤22.7 | 127 / 3.83 ps | **impossible** | **24 × inv_8** (565 ps, 20 ps) |

## Verdict

**(C) Not viable as the proposed pure-std-cell finger.** `sg13g2_ebufn_*` is a
tri-state *buffer*, so the load capacitance on its output is never conductively
connected to `MID`; measured switched contrast is 0.00–0.02 ps at every corner
and cap size. Building the bank from it would add area and 8–15 µW/finger of
power for zero tuning range. There is no other standard cell that exposes a
pass transistor, so a pure-synthesis/PnR switched-cap finger is not realisable
in this library.

If a **single small transmission-gate cell** may be added (far cheaper than
the moscap layout — one TG + the existing `inv_8` is all that is custom, and
the TG is a standard-cell-style cell that P&R can place), the path is
**(B) viable but worse in residual/power**:

- contrast 5.6× the moscap finger at SS (21.6 vs 3.83 ps) with `inv_16`,
- ~24 `inv_8`-cap TG fingers meet SS range 565 ps and LSB 20 ps,
- but each finger leaves ~8 fF off-residual (raises BASE to ~219–270 ps),
- burns 0.8–1.3 mW/element at 500 MHz, and
- needs a keeper/hold device, or a boot sequence, to stop a floating X from
  settling at ~0.57·VDD and drawing 0.1–0.5 mA of cap-inverter crowbar per
  finger (up to ~16 mW/element at FF).

## Files

- `contrast_mux_tt.json`, `ac_mux_tt.json` — `sg13g2_mux2_1` check
- `stdcell_finger.py` — harness (`cal`, `contrast`, `power`, `bank`,
  `resid`, `crowbar`, `ac`)
- `ebufn_tristate_check.py` / `.json` — tri-state / buffer evidence
- `cal.json`, `contrast.json`, `ac.json`, `power_tg.json`,
  `power_tg_inv8.json`, `power_ebufn.json`, `resid_tg.json`,
  `crowbar_inv4.json`, `crowbar_inv8.json`, `crowbar_inv16.json`,
  `bank_tg.json`, `bank_tg_n16.json`, `bank_tg_inv8_ss.json`,
  `bank_tg_inv8_ttff.json`, `bank_tg_inv8_n24_ss.json`
