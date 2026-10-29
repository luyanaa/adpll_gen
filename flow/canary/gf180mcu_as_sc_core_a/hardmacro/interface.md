# PLL_ANALOG hard-macro interface (gf180mcu 3.3 V)

Status: **not built / not characterized**.  This document is the contract that
the hard-macro build and the LibreLane top must both satisfy.  The only
executable artifact today is `PLL_ANALOG_blackbox.v` (synthesis/elaboration
stub) plus `manifest.yaml` (machine-readable form of this file).

Source of truth for the interface: `src/pll_analog.v`, `src/pll.v`.

This is the gf180mcu/180 nm, 3.3 V port of the same Core A IL-DCO interface
used by the ics55 canary.  The digital port list and parameter defaults are
unchanged; the supply, cell library and physical rules are different.

## Module and parameters

```verilog
module PLL_ANALOG #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS    = 15,
    parameter integer FINE_NDELS   = 31,
    parameter integer IL_NDELS     = 4
) (
    // inout VDD, VSS,                        // only with `WITH_POWER`
    input  [COARSE_NDELS-1:0] COARSE_MUX,
    input  [MID_NDELS-1:0]    MID_MUX,
    input  [FINE_NDELS-1:0]   FINE_MUX,
    input  DCO_EN, REF, INJ_EN,
    output [1:0] SS_BBPD,
    output OUT, MID_OUT, INJ_EDGE
);
```

`src/pll.v` overrides `COARSE_NDELS`, `MID_NDELS`, `FINE_NDELS`; it does not
override `IL_NDELS`, so the macro must keep the default (`4`) or `pll.v` must
be updated in the same change.  The instance name in the top is `pll_ana`.

## Ports

| Port | Dir | Width | Domain | Meaning |
|---|---|---|---|---|
| `COARSE_MUX` | in | `COARSE_NDELS` (15) | quasi-static, REF | Unary/thermometer coarse delay code. Bit `i` enables one coarse delay element. |
| `MID_MUX` | in | `MID_NDELS` (15) | quasi-static, REF | Unary/thermometer mid delay code. |
| `FINE_MUX` | in | `FINE_NDELS` (31) | quasi-static, DSM_CK (= MID_OUT/DSM_DIV) | Unary/thermometer fine delay code; MSB..LSB decoded by `pll_term_decoder_with_zero`. |
| `DCO_EN` | in | 1 | INJ_EDGE (negedge) | DCO enable. 0 holds the DCO off; 1 free-runs. Driven by the startup FSM. |
| `REF` | in | 1 | REF clock, 50 MHz nominal (20 ns) in this canary | Reference clock. Feeds the injection delay chain and the SS-BBPD sampler. |
| `INJ_EN` | in | 1 | quasi-static | Injection enable. Gates the injection pulse; not a reset. |
| `SS_BBPD` | out | 2 | sampled by REF/OUT; consumed at `negedge INJ_EDGE` | Sub-sampling bang-bang phase detector result. `SS_BBPD[0]` = REF sample, `SS_BBPD[1]` = OUT sample (see `digital_loop_filter.v`). |
| `OUT` | out | 1 | DCO clock | DCO output. Also feeds the output divider (`pll_mod_divider`); the freq-lock counter uses `MID_OUT`, not `OUT`. |
| `MID_OUT` | out | 1 | DCO clock | Mid-delay tap, same nominal frequency as `OUT`. Used as the freq-lock / DSM clock and sampled by the digital. |
| `INJ_EDGE` | out | 1 | REF-rate, phase-shifted | Delayed copy of `REF` from the injection chain. Used as a clock by the digital (`negedge INJ_EDGE` in the FSM, inverted in the loop filter). |
| `VDD`, `VSS` | inout | 1 each | supply | Only present when `WITH_POWER` is defined. Default top relies on the PDN; the LEF must expose `VDD`/`VSS` pins regardless. |

There is **no reset pin** on `PLL_ANALOG`.  `RST_N` is a digital-only input.
After power-up the macro is controlled solely by `DCO_EN`, `INJ_EN` and the
three delay codes.

## PD / DCO control buses

- `COARSE_MUX`, `MID_MUX` and `FINE_MUX` are **unary/thermometer** codes, not
  binary: bit `i` enables delay element `i`.  The decoder for the fine bus is
  `pll_term_decoder_with_zero` (`OUT = (1 << IN) - 1`).
- Widths are set by `COARSE_NDELS`/`MID_NDELS`/`FINE_NDELS`; the top defaults
  are 15/15/31.  The macro must sample the buses synchronously enough that a
  code change does not create a glitch that permanently stops the DCO.  The
  coarse/mid loop changes one bit per update; the fine DSM path can change
  several bits at once.
- Update domains: coarse/mid are updated from the REF/MID_OUT sampling loop;
  fine is updated on `DSM_CK` (`MID_OUT / DSM_DIV`).  The buses are
  quasi-static relative to the DCO period, but they are not a binary encoded
  word and must not be re-encoded inside the macro.
- `DCO_EN` is the only DCO power/enable control.  It is not a reset: the delay
  chains and injection front-end are expected to settle from their own bias
  when `DCO_EN` goes high.

## Clock / reset assumptions

- `REF` is the only reference clock: 20 ns period (50 MHz) in this canary.
- `OUT` and `MID_OUT` are DCO-rate clocks.  Their period is set by the delay
  codes, not by `REF`; the RTL's default FCW width is 8 bits and the
  frequency-lock loop targets the integer ratio `FCW`.  FCW = 8 therefore
  implies `OUT ≈ 8 × REF = 400 MHz` (2.5 ns).  At 180 nm / 3.3 V a 400 MHz
  IL-DCO is **not claimed**; the canary SDC uses a conservative 5.0 ns
  (200 MHz) planning period.  The real DCO range is a characterization result.
- `INJ_EDGE` has the `REF` period and a delay set by `IL_NDELS` buffer stages.
  It is not a free-running clock and must be characterized as a delayed
  `REF` (or a generated clock) in the macro Liberty/top SDC.
- The macro has no synchronous reset.  The digital reset (`RST_N`, active low,
  asynchronous) does not reset the analog macro; the startup FSM waits with
  `DCO_EN=0` and then enables it.

## Power

- Nominal **3.3 V**, single `VDD`/`VSS` domain in the current RTL and in the
  `gf180mcu_as_sc_mcu7t3v3` digital library.  No level shifters are needed if
  the macro is built in the same 3.3 V domain.
- The standard cells additionally expose `VNW`/`VPW` well pins in the LEF
  (and `pg_pin` entries in Liberty).  They are not part of the `PLL_ANALOG`
  RTL interface; they are well-tie/tap concerns.  The macro LEF must define
  `VDD`/`VSS` pins and the PDN must connect them.
- `PDN_MACRO_CONNECTIONS` (key name/format depends on the LibreLane release)
  is left commented in `config.macro.yaml`.
- If the analog build needs a separate/quiet supply or bias pins, this
  interface must be extended (new pins, blackbox update, LEF/Liberty update,
  UPF/level-shifter decision).  The current interface does not carry them.

## Required views

| View | Path (expected) | Required contents |
|---|---|---|
| GDSII | `hardmacro/PLL_ANALOG.gds` | Final macro layout, top cell `PLL_ANALOG`, origin at (0,0), VDD/VSS rails, no unresolved DRC. |
| LEF | `hardmacro/PLL_ANALOG.lef` | `MACRO PLL_ANALOG`, `SIZE`, `PIN` for every port above with `DIRECTION`/`USE`, `PORT` geometry on the gf180 routing grid (`Metal1` rails, `Metal2` pin access; the tech LEF layer names are `Metal1`..`Metal5`), `OBS`, `PIN VDD/VSS`. |
| Liberty | `hardmacro/PLL_ANALOG.lib` | `cell (PLL_ANALOG)`, input pins with capacitance, `SS_BBPD`/`OUT`/`MID_OUT`/`INJ_EDGE` output timing, internal power, `pg_pin` VDD/VSS, operating conditions matching `STA_CORNERS` (3.3 V). |
| CDL | `hardmacro/PLL_ANALOG.cdl` | Subcircuit for LVS, pin order matching the LEF/Verilog. |
| SPICE | `hardmacro/PLL_ANALOG.spice` | Extracted/transistor netlist for macro-level simulation; used by the analog signoff, not by LibreLane. |
| Verilog | `hardmacro/PLL_ANALOG_blackbox.v` | Present.  Synthesis/elaboration stub only. |

The macro Liberty is the piece that makes the top STA meaningful.  A
GDS+LEF-only macro can be placed/routed but cannot be timing-closed.

## Timing assumptions / open items

1. `SS_BBPD` is the critical macro→digital path: the digital samples it on
   `negedge INJ_EDGE` (loop-filter `CLK = !INJ_EDGE`).  The macro must
   characterize `SS_BBPD` relative to `INJ_EDGE` (setup/hold at the sampling
   edge), or the top SDC must declare that path false and the loop must be
   validated in analog co-simulation.  Today it is unconstrained.
2. `INJ_EDGE` is a delayed `REF`.  Until the macro Liberty provides the
   insertion delay, the canary SDC treats it as an asynchronous clock.
3. `COARSE_MUX`/`MID_MUX`/`FINE_MUX` are quasi-static: they change at most
   once per REF cycle / DSM cycle, so they are not a high-speed synchronous
   interface.  Still, code transitions can inject glitches into the delay
   chain; the macro must either be glitch-tolerant or the digital must
   guarantee a single-bit change per update (the freq-lock loop does change
   one bit at a time; the fine DSM path can change several bits).
4. `DCO_EN` and `INJ_EN` are static during normal operation.  Their setup to
   the DCO/injection enable is a characterization item.
5. The macro Liberty is expected to be TT-only at first.  If so, do **not**
   run the multi-corner `STA_CORNERS` list as a signoff claim; restrict the
   macro run to `nom_tt_025C_3v30` until the macro is characterized at the
   other corners.
6. The 180 nm DCO delay range, tuning step and 3.3 V swing are not
   characterized.  The ics55 delay-code widths are carried over unchanged;
   they may be a poor match to gf180mcu device speeds and must be re-sized
   from the analog characterization.

## Hard-macro build boundary

Inside the macro (built/characterized outside LibreLane):

- injection delay chain (`PLL_INJECTION`, `IL_NDELS` stages, `INJ_EDGE`/`INJ_WIN`);
- IL-DCO (`PLL_ILDCO`): coarse/mid/fine delay chains and the symmetric mux;
- SS-BBPD sampler (`ssbbpd`/equivalent) and its sampling latches;
- output buffers/drivers for `OUT`, `MID_OUT`, `INJ_EDGE`, `SS_BBPD`;
- macro-local power grid, decap, well taps, and (if used) analog bias.

Outside the macro (LibreLane top + digital synthesis):

- `pll_logic` and its dependencies (`digital_loop_filter`, `freq_lock`,
  `delta_sigma`, `term_decoder`, `fix_div`, `conf_div`);
- the startup/lock FSM, mode registers, divider control;
- reference clock generation, test muxing, scan/DFT;
- top-level PDN, CTS, routing, STA, DRC/LVS/antenna, IR/EM.

The macro build is the ckdur hard-macro flow (`pnr/`, ngspice/ISF
characterization) or an equivalent.  LibreLane does not build this macro.

## gf180mcu portability notes

- `gf180mcu_as_sc_mcu7t3v3` has only 107 cells, one positive-edge DFF
  (`dfxtp_2`/`dfxtp_4`, plus `dyn_dfxtp_2` which the PDK synthesis-exclude
  file removes), one negative-edge DFF (`dfxtn_2`) and one async
  set/reset DFF (`dfsrtp_2`, with both `RN` and `SN`).  There are no scan
  flops and no enable flops in this library.
- Yosys maps all async-reset digital flops to `dfsrtp_2` and ties the unused
  `SN` high with `tieh_4` cells.  This is legal but is not a low-power or
  scan-ready netlist.  A product port needs a library with reset/enable/scan
  flops or a different reset strategy.
- The library is 3.3 V only.  Mixing it with the 1.2 V ics55 macro is not
  possible without level shifters and a supply change; this canary does not
  do that.
