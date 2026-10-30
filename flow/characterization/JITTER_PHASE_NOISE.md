# Jitter / phase-noise status

The DCO now has:

- sparse/dense L3 transistor frequency tables;
- routed macro PEX extraction;
- one-code PEX-capacitance and TT/SS/FF frequency checks.

Jitter and phase noise are **not** signoff results yet.

## Why

`ngspice-44.2` provides `.noise` (small-signal input-referred noise) but not a
PSS/Pnoise analysis for an autonomous oscillator.  A DC operating-point noise
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
