# Post-PnR simulation

## What is implemented

`test_pll_analog_macro.v` instantiates the **ics55 P&R gate netlist**
`pnr/outputs/ics55/PLL_ANALOG_MACRO.v`, drives the DCO controls, and optionally
annotates the P&R SDF:

```text
$sdf_annotate("PLL_ANALOG_MACRO.sdf", dut);
```

`filler_stubs.v` supplies empty models for the physical-only filler cells
(`FILLER*`, `FILLCAP*`, `FILLTAPH7R`) that are absent from the PDK Verilog
model.

Run:

```sh
ROOT=/opt/adpll_gen PDK_ROOT=/grid bash sim/post_pnr/run.sh
```

Icarus 12 does not support `-ginterconnect` (unlike the older sim targets in
`sim/tests.mk`), so the command uses `-gspecify` only.

## Current smoke result

Stimulus: `DCO_EN=1`, `INJ_EN=1`, all mux controls set, 200 ns simulated,
REF toggled every 5 ps for injection kick-start (not a 100 MHz system reference),
SDF maximum/default annotation by Icarus.

```text
SDF annotated:
  edges=38  last_period_ps=2284  avg_period_ps=4926

No SDF:
  edges=52  last_period_ps=5000  avg_period_ps=3568
```

The numbers are a **simulation smoke result**, not a calibrated DCO period:
the last/avg periods vary because the injection-locked waveform is not
strictly periodic in this short run.  The important observation is that SDF
annotation materially changes the gate-level behavior, so the P&R delay model
is being consumed.

## Limits (important)

- Icarus warns that `$sdf_annotate` currently uses only the file and instance
  arguments; corner selection (`min/typ/max`) and the log path are ignored.
  Do not quote this as a min/typ/max signoff simulation.
- The macro is a **gate-level logic netlist**.  This test does not model
  transistor-level DCO phase noise, injection locking physics, or analog
  supply effects.
- Full SPEF/interconnect-aware simulation needs OpenSTA (timing) or an
  extracted SPICE netlist + ngspice/Xyce (analog).  Icarus SDF annotation is
  not a substitute for either.
- The top-level `pll` with the hard macro has not been assembled yet; this test
  is macro-only.

## Next steps

1. Run OpenSTA on the P&R netlist + SPEF + all corners and compare with the
   reported post-PnR setup/hold margins.
2. Build an extracted SPICE macro from the P&R GDS/SPEF and run ngspice for
   DCO period/tuning, injection lock range, and SS-BBPD offset.
3. Add the macro to `config.macro.yaml` and simulate the full PLL, not just the
   macro.
