# DDR clock PHY path

First fixed-configuration version implemented in `src/ddr_clock_phy.v`:

```text
ADPLL CK / divider
  -> ADCC_TOP (duty-cycle corrector)
  -> phase selector (static tap)
  -> CK_PHY / CK_PHY_N
```

`ADDLL_TOP` is instantiated as an optional full-period deskew block
(`USE_DLL=1`).  The default first version uses the selector path
(`USE_DLL=0`).

## 1. Interface

`DDR_CLOCK_PHY` takes `CK_IN` and `PLL_LOCKED` from the ADPLL, plus
`TICK`, `SAMP`, DCC/DLL enables, gains, static trims and the selector
request.  It exposes `CK_DCC`, `CK_DLL`, `CK_PATH`, `CK_SEL`, `CK_PHY`,
`CK_PHY_N`, the DCC/DLL lock flags and the control words.

`PHY_LOCKED = PLL_LOCKED & DCC_LOCKED & (USE_DLL ? DLL_LOCKED : 1) & ~BUSY`.
`CK_PHY` and `CK_PHY_N` are both forced low when `PHY_LOCKED` is low.

## 2. Measured results

Standalone `src/ddr_clock_phy_tb.v`, 200 MHz, 30% input duty, with the
matched pad/load model (`TPAD=80 ps`, `50 ohm * 0.5 pF`, edge 30 ps):

```text
CK_DCC  : high=2.500 ns low=2.500 ns period=5.000 ns duty=50.0%
CK_PHY  : high=2.500 ns low=2.500 ns period=5.000 ns duty=50.0%
PAD_CK_T: high=2.500 ns low=2.500 ns period=5.000 ns duty=50.0%
tap 4   : phase=240.0 ps (4 x 60 ps)
PAD_CK_T: phase=375.0 ps (240 ps tap + 135 ps pad/load)
```

The test also checks the complementary pair and fail-closed shutdown:
dropping `PLL_LOCKED` mid-high forces both PHY and pad outputs low, no
further edges, and the output resumes after relock.  The pad model is a
matched functional load, not SI/IBIS/PVT.

ADPLL integration with full `LOCKED` and `USE_DLL=1`
(`src/ddr_clock_phy_integration_tb.v`):

```text
LOCKED after 202 REF, FREQ_LOCKED=1
OUT_DIV 212 edges / 100 REF = 2.12 per REF
DCC_LOCKED after 19 TICK, DUTY_CODE=1
DLL_LOCKED=1, DLY_CODE=34
DLL delay=0.843 ns, period=4.870 ns, mod=0.843 ns
CK_PHY period=4.157 ns duty=41.4%
FAIL: DLL_LOCKED but CK_DLL is not at a full-period phase
FAIL: CK_PHY duty outside 45-55%
```

The ADPLL full lock required the phase-filter integrator preload
(mid-scale), the phase-loop P/N swap for the delay-increasing DCO, and
stopping the FLL only when `PHASE_LOCK & FREQ_OK`.  The DLL `LOCKED` flag
is not a phase check: it asserts code stability while the delayed edge is
0.843 ns away from the full-period position.  This is a false DLL lock and
the current level-sampling PD is not sufficient for a full-period DLL.

## 3. Block limitations found

- `pll_logic`'s divider and CK gate are clocked by `OUT`, which starts
  after `RST_N` is already high.  Their async reset never saw a clock edge
  and `OUT_DIV` stayed X in integration.  A 16-`OUT`-edge local reset
  (`div_rst_n`) now initializes both blocks.
- The old `ADDLL_TOP` sampled the SS-BBPD level on `TICK` and used
  unbalanced PD inputs, so it could lock to the half-period.  The fixed
  path uses balanced `~CLK_IN/~CLK_OUT`, raw P/N decode (no bit swap), a
  captured PD code, and the DLF clocked on `!CLK_IN`.  At 4.88 ns it now
  gives `DLL_LOCKED=1`, `DLY_CODE=34`, phase 0 mod period.
- The ADCC duty loop has a few-percent frequency-dependent bias: 50.0% at
  5 ns, about 55% at 4 ns.  The first version is inside the DDR window but
  needs a pad-level calibration/PVT pass.

## 4. Two output contracts

| Contract | Requirement | Current status |
|---|---|---|
| Normal clock | period, duty inside the DDR window, skew, jitter; full pulses | 200 MHz RTL duty 50.0%; no pad/DCC/PVT signoff |
| Fault clock | fail-closed, last pulse may be truncated; controller stops data | both outputs forced low; tested mid-high |

A DDR controller must consume the fault indication and stop normal data
transfer; it must not treat a truncated last CK pulse as a valid clock.

## 5. Physical tap bus and real-cell check

`PHASE_SELECTOR_TOP`'s non-SIMULATION branch is no longer an undriven
placeholder.  `PLL_DCDL_TAP_BUS_PHYS` instantiates one `FINE_DELAY_CELL`
per tap (the same cell as the DCDL fine bank, `MUX=1`) and exposes
`TAP[0..NTAPS-1]`; the selector binds `TAP` directly.

Two structural checks are provided:

```sh
make -C sim test_ddr_phy_non_sim     # PDK-independent stub check
make -C sim test_ddr_phy_real_cells  # ics55 real cells + Yosys + OpenSTA
```

The real-cell target uses `/grid/icsprout55-pdk` by default
(`ICS55_REAL_ROOT` can override).  Evidence from the ics55 H7CR run:

```text
Icarus non-SIMULATION elaboration with ics55_LLSC_H7CR.v : PASS
Yosys PHASE_SELECTOR_TOP: 191 cells
  FINE_DELAY_CELL 16, INVX5H7R 32, NAND3X1H7R 16
OpenSTA TAP arrivals (50 ps input, 2 fF tap load):
  TT: average step 35.3 ps
  SS: average step 60.7 ps
  FF: average step 24.0 ps
```

The physical tap step is therefore corner-dependent (35/61/24 ps at
TT/SS/FF), not the 60 ps used by the SIMULATION model.  The selector's tap
index must be calibrated per PDK/corner before it is used as a phase number.

The PDK-independent stubs in `src/pll_cells_elab_stub.v` remain only for
environments without a PDK; the real-cell target is the authoritative
structural check.

## 6. Real ics55 IO pad

`src/ics55_ddr_ck_pad.v` wraps two `P65_1233_PBMUX` cells as CK_T/CK_C:
OE=1, I=CK_PHY/CK_PHY_N, maximum drive, no pull-up/down/open-drain.
The IO Liberty cell exposes only signal pins, so the PDK supplies are
global/unconnected in this structural view.

Simulation with the ics55 IO Verilog model (`test_ddr_phy_ics55_io`):

```text
IO_CK_T high=2.500 low=2.500 period=5.000 duty=50.0%
IO_CK_T phase=240.0 ps (expected 240.0 ps)
```

The Verilog model has zero specify delay; it checks connectivity/duty, not
IO timing.  OpenSTA with the real IO Liberty at a 2 pF pad load:

| Corner | CK_T rise/fall | CK_T duty | CK_C duty | common crossing |
|---|---:|---:|---:|---:|
| TT | 2.570 / 2.440 ns | 47.4% | 52.6% | 2.505 ns |
| SS | 4.220 / 4.220 ns | 50.0% | 50.0% | 4.220 ns |
| FF | 1.770 / 1.670 ns | 48.0% | 52.0% | 1.720 ns |

At 200 MHz the SS pad delay is 4.22 ns, i.e. 84% of the period, and the
TT/FF single-ended duty shifts by about 2.5%.  These are single-ended
figures; the differential crossing/duty needs an SI/IBIS model and is not
claimed.  The pad-stage phase budget is dominated by the IO cell, not the
35-61 ps tap.

## 7. DLL decision and real DCDL range

The behavioral DLL `LOCKED` flag is not a full-period phase lock: at
4.87 ns it asserts with a 0.843 ns edge offset and the output duty drops
to 41.4%.  The level-sampling PD/lock detector needs a real edge/PFD
phase detector before the DLL path can be verified.  The ADPLL full
`LOCKED` itself does work (202 REF, P/N balanced, no ILL).

The production blocker is the real ics55 DCDL range at a 5 ns target:

| Corner | DCDL min-max | 5 ns |
|---|---:|---|
| TT | 4.71-5.55 ns | covered |
| SS | 6.43-7.98 ns | **blocked** (minimum above 5 ns) |
| FF | 3.97-4.52 ns | **blocked** (maximum below 5 ns) |

A full-period DLL at 5 ns cannot be verified at SS/FF with this DCDL.  The
options are a wider/different DCDL, a different period/architecture, or
accepting the selector-only path with PVT calibration.  The DLL also needs
a phase detector that can distinguish the full period; the current level
PD cannot.  That is a design decision; `USE_DLL=0` stays the default for
the fixed RTL bring-up.

The real IO corner spread (1.77/2.57/4.22 ns at FF/TT/SS for a 5 ns
period) still means a static selector tap cannot hold pad phase across
PVT; the DLL/phase-tracking path is required, but its real DCDL range and
PD architecture are the blockers above.

## 8. Not done

- The IO wrapper is a cell-level structural/timing view; there is no
  package model, extracted board load, SI/IBIS differential-crossing
  analysis or PVT/jitter signoff.  The OpenSTA table is single-ended.
- Frequency switching, per-lane deskew and DQS/DQ training are out of
  scope for this fixed first version.
- The real-cell check is a Liberty-corner structural/timing measurement,
  not a placed/parasitic timing signoff.

## 9. SoC PLL scope

Clock monitor, DFS, safe switching, APB/CSR, scan bypass and power
management remain separate deliverables; they do not all belong inside
the PHY clock bundle.
