# L3 DCO/PEX characterization attempt

This directory records the first attempt to move from the L1 behavioral DCO
scan to a transistor-level L3 model.  **No L3 result is claimed yet.**

## ics55 CDL fallback

The `/grid/ics55` install has `cdl/` but no `libs.ref/<scl>/spice/` directory.
The fallback added in `lib/ics55_settings.tcl` and `settings.mk` uses the CDL
as the master netlist and points ngspice at the foundry model library:

```text
/grid/ics55/libs.tech/spice/foundry/ngspice/ICsprout_55LLULP1225_V1p1_hsp.lib
```

`make -C sim test_dco PDK=ics55 PDK_ROOT=/grid` now generates
`syn/outputs/ics55/PLL_ILDCO.sp`, but ngspice stops on the vendor CDL cell
wrapper syntax:

```text
Too many parameters for subcircuit type "inv"
(instance: .../xxi0)
```

The CDL uses wrapper calls such as:

```text
XXI0 A VDD VSS Y / INV pl=... pw=... nl=... nw=...
```

That `/ INV` form and its parameter overrides are not accepted by this
ngspice.  A clean L3 run therefore needs a flattened/standard-SPICE cell view
(or a proper CDL reader), not another flow knob.

## IHP attempt

The IHP PDK has the standard-cell SPICE view and PSP model library, but the
local PDK install has no PSP OSDI shared objects:

```text
psp103.osdi: No such file or directory
psp103_nqs.osdi: No such file or directory
```

ngspice therefore reports `Unknown model type psp103va` and cannot run the
DCO.  Installing/building the OSDI modules is required before an IHP L3 run.

## Status

```text
L1 behavioral DCO scan:       complete (flow/characterization/ics55_sim)
L3 ics55 transistor netlist:  generated, ngspice blocked by CDL syntax
L3 IHP transistor netlist:    generated, ngspice blocked by missing OSDI
PEX extraction:               not started
```

## Next options

1. Flatten the ics55 CDL cells to plain SPICE with explicit transistor sizes,
   then rerun `test_dco`.
2. Install/build the IHP PSP OSDI modules, then rerun `test_dco` on IHP.
3. Only after a working transistor-level DCO, add PEX (RCX) and run
   tuning/PVT/injection characterization.

Do not treat the L1 numbers as PEX or jitter signoff.

## Xyce attempt (IHP)

The local IHP tree includes `libs.tech/xyce/models`, and a working Xyce 7.10
binary was found in the system Spack installation.  Using the Xyce model path

```text
.../ihp-sg13g2/libs.tech/xyce/models/cornerMOSlv.lib
```

and the IHP standard-cell SPICE view still fails before transient analysis:

```text
Unrecognized parameter D for device YPSP103_VA!M1
Unrecognized fields for device YPSP103_VA!M1
1430/2790 netlist errors
```

So the Xyce/PSP path is also blocked by the local model/library combination,
not by the DCO testbench.

## ics55 flat-CDL check

`flow/macro/ics55_h7cr/flatten_cdl.py` successfully flattens the generated
`PLL_ILDCO.sp` to 776 devices and 70 top pins.  ngspice then still fails to
resolve the foundry `nm1p2_svt_lp`/`pm1p2_svt_lp` model cards because the
vendor model library uses relative nested `.LIB` files and additional model
data; this is a model-deck assembly issue, not a DCO netlist issue.

Thus both L3 routes are currently blocked.  No L3/PEX baseline is claimed.
