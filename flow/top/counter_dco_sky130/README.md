# sky130 Core C top physical integration

See `RESULTS.md` for the completed-run evidence, constraints audit, and limits.

This flow places and routes the real `PLL_COUNTER_TOP` digital controller with
the hardened `PLL_COUNTER_DCO_PHYS` counter/NCO macro.  It is the first
top-level physical integration experiment; it is not a production signoff.

## Prerequisites

```sh
flow/macro/sky130_fd_sc_hd/make_pdk_root.sh build/pdk_root
```

The flow uses:

- PDK root: `build/pdk_root`
- PDK: `sky130_fd_sc_hd`
- standard cells: `sky130_fd_sc_hd`
- macro views: `flow/macro/counter_dco_sky130/PLL_COUNTER_DCO_PHYS.{gds,lef,lib,spice}`
- top RTL: `src/pll_logic.v` and its digital blocks, plus the
  `pll_counter_top_phys.v` physical-build copy of `src/pll_counter_top.v`
- macro blackbox: `PLL_COUNTER_DCO_PHYS_bb.v`

`pll_counter_top_phys.v` removes the simulation-only macro parameters
(`ACC_BITS`, `BASE_INC`, step sizes) because the hardened macro has fixed
widths and parameters.  The digital RTL inside `PLL_COUNTER_TOP` is unchanged.

## Run

```sh
librelane --manual-pdk --pdk-root build/pdk_root \
  --pdk sky130_fd_sc_hd --scl sky130_fd_sc_hd \
  --run-tag top_pnr flow/top/counter_dco_sky130/config.yaml
```

## Constraints

`constraints/top.sdc` defines:

- `REF` at 2.66 MHz (375 ns), `TICK` at 100 MHz (10 ns)
- `DCO_OUT` at the macro `dco/OUT` pin
- `MID_OUT` generated from `DCO_OUT`
- `OUT_DIV` generated from `MID_OUT` with `/2`
- input/output delays for the control ports
- the Gray-bus `set_max_delay -datapath_only` between
  `*counter_frontend*gray_q*` and `*cnt_gray_s1*`

`RUN_CTS`, `RUN_SPEF_EXTRACTION`, and the OpenRCX nom ruleset are enabled in
`config.yaml`.  The macro is fixed at the TT (`nom_tt_025C_1v80`) view only.

## Evidence to collect after the run

- `runs/top_pnr/final/gds/PLL_COUNTER_TOP.gds`
- `runs/top_pnr/final/def/PLL_COUNTER_TOP.def`
- `runs/top_pnr/final/nl/PLL_COUNTER_TOP.nl.v`
- `runs/top_pnr/final/spef/*.spef` (if SPEF extraction succeeds)
- OpenROAD/OpenSTA timing reports under `runs/top_pnr/`
- Magic/KLayout DRC and Netgen LVS reports under `runs/top_pnr/`

## Known limits

- The DCO macro has only a TT Liberty view; no SS/FF top STA is claimed.
- The macro is a hard macro and its internal timing/DRC/LVS evidence is the
  separate `flow/macro/counter_dco_sky130` result.
- No Pnoise/PSS, random-jitter, or phase-noise signoff is performed here.
