# Jitter / phase-noise status

The DCO now has:

- sparse/dense L3 transistor frequency tables;
- routed macro PEX extraction;
- one-code PEX-capacitance and TT/SS/FF frequency checks.

Jitter and phase noise are **not** signoff results yet.  A new
`kdco_jitter.py` report now extracts local KDCO and deterministic transient
period spread from the existing IHP table/PEX raw; see
`KDCO_JITTER_REPORT.md`.  It still does not provide random/phase noise.

## Physical macro update (2026-11-01)

`flow/characterization/macro_char.py` now runs the built ring/counter macros
for gf180mcu, sky130 and IHP:

- gf180mcu ring: TT/SS/FF transient complete; deterministic period RMS
  0.11/0.26/0.24 ps (TT/SS/FF).
- IHP ring: TT/SS/FF transient complete; deterministic period RMS
  1.44/0.13/0.42 ps (TT/SS/FF).
- sky130 ring: functional probe reports `NO_OSCILLATION` at all three
  corners; no sky130 ring frequency or jitter claim is made.
- Counter/NCO: exact TICK quantization (380/370 ns at 100 MHz TICK,
  pp 10 ns, RMS 4.985 ns) plus gate-level STA PVT.

These are still **not** random jitter or phase noise.  The transients are
noiseless and the views have no routed RC.  The sky130 counter SS corner
fails setup at 100 MHz TICK (WNS -0.640 ns); this is a timing issue, not a
jitter result.  See `macro_char/CHARACTERIZATION.md`.

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

Until then, the generator keeps production/PVT/PEX requests at
`FAIL_UNCHARACTERIZED`, and the PEX results are explicitly labelled
`L3_PEX_CAP`, not `L3_PEX_PVT`.
