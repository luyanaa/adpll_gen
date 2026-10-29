# LibreLane integration notes

LibreLane is the default **top-level** flow for the ADPLL family.  It is not a
transistor-level analog flow, so the DCO/PD/injection/symmetric mux are
pre-hardened macros; the digital control is synthesized and integrated.

## Flow split

```text
per-PDK / per-library hard macro        digital control (soft)
────────────────────────────────        ──────────────────────
IL-DCO / ring DCO / counter DCO         capture/lock FSM
injection + symmetric mux               PI / gear-shift
SS-BBPD / BBPD / SR TDC                 DSM / divider
ngspice / ISF characterization           registers / DFT / test modes
        │                                        │
        └──────────────┬─────────────────────────┘
                       ▼
                 LibreLane top level
        macro placement → PDN → CTS → route
        STA / DRC / LVS / antenna / IR / EM
```

The ckdur custom OpenROAD Tcl flow (`pnr/tcl/pll_pos.tcl`,
`pnr/tcl/clk_isolate.tcl`, etc.) is used **inside the hard macro**, not as the
default top-level flow.  If a custom top-level step is needed, add it as a
LibreLane step rather than forking the whole flow.

## Configuration skeleton

`config.example.yaml` is a skeleton.  LibreLane changes its schema between
releases; adapt the keys to the installed version and to the PDK's
`libs.tech/librelane` config.  The important parts are:

- `PDK` and `STD_CELL_LIBRARY`: the selected digital library.
- `VERILOG_FILES`: digital control RTL + macro behavioral models.
- `MACROS`: hard-macro GDS/LEF/Liberty.
- `EXTRA_LIBS`: selected DCO/PD macro Liberty/LEF, if not already in `MACROS`.
- `CLOCK_PORT` / `CLOCK_PERIOD`: reference clock.
- `STA_CORNERS`: all corners supported by the selected library for Tier 2
  flow; TT only for Tier 1.
- `RUN_DRC` / `RUN_LVS` / `RUN_ANTENNA`: signoff steps.
- IR/EM/DFT: use LibreLane steps where available; otherwise call the PDK's
  OpenROAD/Calibre/Assura flow from the generator.

## Per-block mixing

LibreLane can read multiple Liberty/LEF views.  For a mixed-library selection:

1. all libraries must be in the same PDK;
2. all libraries must be the same voltage, unless level shifters/UPF are
   explicitly selected;
3. the hard macro's Liberty/LEF must be generated with the same corner names
   as the digital library, or mapped explicitly;
4. the top-level STA must include all selected libraries;
5. do not mix a TT-only library into a `2-flow` claim.

Start with same-voltage mixing (for example ics55 H7CH DCO + H7CL digital),
then add level shifters only after the same-voltage flow is proven.

## What is not in LibreLane

- ngspice/ISF phase-noise and injection-range characterization;
- transistor-level PLL co-simulation;
- DCO tuning-curve extraction;
- the hard-macro GDS/LEF/Liberty build.

Those stay in `flow/analog/` and the ckdur hard-macro flow.  The generator
orchestrates: characterize → build macro → LibreLane integrate → signoff.
