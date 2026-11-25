# Jitter / phase-noise status

The DCO now has:

- sparse/dense L3 transistor frequency tables;
- routed macro PEX extraction;
- one-code PEX-capacitance and TT/SS/FF frequency checks.

The macro transients below are **not** a jitter signoff.  A
`kdco_jitter.py` report extracts local KDCO and deterministic transient
period spread from the existing IHP table/PEX raw; see
`KDCO_JITTER_REPORT.md`.  It still does not provide random/phase noise.
The one signed-off jitter number is the estimated thermal residual in
[Estimated signoff](#estimated-signoff-2026-11-24), and it does not cover
these transients.

## Physical macro update (2026-11-01)

`flow/characterization/macro_char.py` now runs the built ring/counter macros
for gf180mcu, sky130 and IHP:

- gf180mcu ring: TT/SS/FF transient complete; deterministic period RMS
  0.11/0.26/0.24 ps (TT/SS/FF).
- IHP ring: TT/SS/FF transient complete; deterministic period RMS
  1.44/0.13/0.42 ps (TT/SS/FF).
- sky130 ring: the `PLL_CELL_NOR2BX1` RTL mapping was corrected so
  `DCO_EN=1` enables the oscillator path.  Post-fix minimum-code transient:
  **43.08/27.64/13.48 MHz** for FF/TT/SS (SS is a two-edge one-period
  estimate).  Deterministic period RMS is 4.4 ps (FF) and 36.4 ps (TT); the
  old `NO_OSCILLATION` rows are pre-fix and must not be reused.
- Counter/NCO: exact TICK quantization (380/370 ns at 100 MHz TICK,
  pp 10 ns, RMS 4.985 ns) plus gate-level STA PVT.

These are still **not** random jitter or phase noise.  The transients are
noiseless and the views have no routed RC.  The sky130 counter now passes
setup at 100 MHz TICK in all three corners after the carry-select
accumulator change (SS WNS +1.47 ns); this is a timing result, not a jitter
result.  See `macro_char/CHARACTERIZATION.md`.

## Why

`ngspice-44.2` exposes a `.pss` analysis, but it has no matching `.pnoise`
command in this build.  A PSS attempt on the IHP DCO exited the stabilization
phase and then failed to converge within 700 s.  A DC operating-point `.noise`
analysis of a ring oscillator is not a phase-noise result.

The alternative engines do not yet run the models cleanly:

- Xyce 7.10 rejects the ics55 BSIM4 4.5 deck (`older than 4.6.1`).
- Xyce does not load the IHP PSP103 OSDI model used by the working L3 path.
- ngspice transient noise requires explicit `trnoise` sources; using an
  arbitrary amplitude would not be calibrated to the device noise.

## What would count as completion

1. A PSS/Pnoise run on the PEX-annotated DCO with the vendor transistor models.
2. Phase noise at a defined offset grid (e.g. 100 kHz, 1 MHz, 10 MHz).
3. Integrated RMS jitter over a defined bandwidth.
4. At least TT and one slow/fast corner, with the same PEX netlist.

That list is still unmet, so the generator keeps production/PVT/PEX
requests at `FAIL_UNCHARACTERIZED`, and the PEX results stay labelled
`L3_PEX_CAP`, not `L3_PEX_PVT`.  A pnoise run would replace the estimate
below; until then the estimate is the number this project quotes.

## Estimated signoff (2026-11-24)

`ngspice-44.2` has `.pss` and no `.pnoise`.  The one `.pss` attempt on this
DCO did not converge, and Xyce 7.10 will not load `psp103.osdi`, so a
closed-loop noise simulation cannot be run here.  The locked residual is
signed off from the free-running ISF instead.

**Signed off: 4.0 ps rms, thermal only.**  Tag `ESTIMATED_THERMAL_HP_100kHz`.

| item | value |
|---|---|
| netlist | IHP lock point c4/m9/f25, free-running, f0 = 359.30 MHz |
| spectrum | `sim/outputs/ihp-sg13g2/lock/test_dco_noise.csv`, thermal column |
| floor | L_thermal(1 MHz) = −112.91 dBc/Hz, `A = L·f² = 5.112 Hz` |
| transfer | `H_err = (f/fc)² / (1+(f/fc)²)`, fc = **100 kHz, assumed** |
| integral | `2·L·|H_err|²` from 100 Hz to 1 GHz, 71-point trapezoid: 3.987 ps |
| check | closed form `σ_φ² = π A / (2 fc)` over 0–∞: 3.969 ps |

The 4.0 ps figure is the grid integral, rounded.  Derivation and the
rejected columns are in `sim/outputs/ihp-sg13g2/lock/ISF_LOCK_NOTES.md` §6–§7.

The 100 kHz bandwidth was not measured.  `src/dlf_design.py`'s 1 MHz target
does not include `KDCO·Kpd`, and the fine `KDCO` table changes sign, so it
cannot be used to pick `fc`.  If a bandwidth is measured later, rescale the
thermal number only: `σ_t = 4.0 ps · sqrt(100 kHz / fc)`.  Do not quote the
1 MHz row (1.3 ps) as this loop.

Same grid with the high-pass removed integrates to 144 ps rms of thermal
jitter.  A loop slower than 100 kHz lands between 4.0 ps and that 144 ps.
4.0 ps is therefore conditional on the assumed bandwidth, not an
unconditional upper bound.

Not part of this signoff:

- the synthesized flicker, and the total column that it dominates (53 ps at
  the same 100 kHz; the 27.7 MHz corner is an upper bound, §3 of the ISF note);
- SS/FF, or the same integral on a PEX-annotated netlist;
- the physical ring and counter macros in `flow/macro/SIGNOFF_STATUS.md`.
