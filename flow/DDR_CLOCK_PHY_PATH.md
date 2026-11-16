# DDR clock PHY path

First fixed-configuration version implemented in `src/ddr_clock_phy.v`:

```text
ADPLL CK / divider
  -> ADCC_TOP (duty-cycle corrector)
  -> phase selector (static tap)
  -> CK_PHY / CK_PHY_N
```

`DLL_FULL_PERIOD_TOP` is the optional Route B full-period deskew block
(`USE_DLL=1`); it replaces the old `ADDLL_TOP` path in the PHY.  The default
fixed RTL bring-up still uses the selector path (`USE_DLL=0`).

## 1. Interface

`DDR_CLOCK_PHY` takes `CK_IN` and `PLL_LOCKED` from the ADPLL, plus the
1 GHz loop `TICK`, the fast DLL TDC clock `DLL_TICK`, `SAMP`, DCC/DLL
enables, gains, static trims and the selector request.  It exposes `CK_DCC`, `CK_DLL`, `CK_PATH`, `CK_SEL`, `CK_PHY`,
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

ADPLL -> divider -> DCC -> selector (`src/ddr_clock_phy_integration_tb.v`,
`USE_DLL=0`):

```text
LOCKED after 202 REF, FREQ_LOCKED=1
OUT_DIV 212 edges / 100 REF = 2.12 per REF
DCC_LOCKED after 19 TICK, DUTY_CODE=1
CK_PHY high=2.435 low=2.435 period=4.870 duty=50.0%
tap 4 phase=240.0 ps
PASS
```

The raw `OUT_DIV` is a fractional-divider clock: its edge spacing is not
uniform.  A one-period DLL has no valid code for it, and the Route B DLL
correctly refuses to lock.  The integration test therefore uses the
selector path; the DLL PHY path is verified separately with a uniform
reference (section 7).

The old `ADDLL_TOP` false lock is gone: it reported `LOCKED=1` with a
0.843 ns edge offset and 41.4% output duty.  `ADDLL_TOP` remains in the
source tree for its legacy regressions but is no longer instantiated by
`DDR_CLOCK_PHY`.

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

## 7. Route B full-period DLL

The old `ADDLL_TOP` `LOCKED` was an accumulator-stability window, not a
phase check.  Route B replaces it with `src/dll_full_period_top.v`:

- **DCDL**: 4 coarse segments (56 `FINE_DELAY_CELL` each) plus a 56-tap fine
  mux.  `COARSE=0/FINE=0` bypasses the segments.  Real ics55 OpenSTA:

  | Corner | 4-seg DCDL min-max | 4.5-5.5 ns |
  |---|---:|---|
  | TT | 2.93-11.55 ns | covered |
  | SS | 3.32-18.13 ns | covered |
  | FF | 2.78-8.64 ns | covered |

  An 8-segment version had SS `t_min` = 5.12 ns, so the 4-segment bypass is
  what brings SS below 4.5 ns.  This is a Liberty-corner structural check,
  not placed/PEX/PVT.
- **Startup range**: the line is driven by REF/16 while a free-running TDC
  measures the absolute delay, and a binary search finds the tap at one
  measured REF period.  The period is measured at startup, so a 4 ns input
  locks at 40 ticks and a 5 ns input at 50 ticks (10 GHz TDC).
- **Tracking**: REF-to-OUT delay in TICK counts modulo the period; the code
  window is the cycle/range detector, and `PHASE_OK` counts consecutive
  REF windows with a valid OUT edge and |delay - period| <= 1 tick.
- **LOCKED = RANGE_OK & PHASE_OK & !CODE_RAILED & ALIVE.**  The TDC samples
  the output edge; ALIVE requires one output edge per REF window.
- The behavioral line is a tapped transport-delay array.  The code is
  committed only in the low phase of the measurement clock, so a code change
  selects a different tap instead of re-timing an event.

`src/dll_full_period_tb.v` (behavioral 4-seg surrogate, T0/STEP from the
STA endpoints, 10 GHz TICK):

```text
TT 5 ns : LOCKED=1 CODE=58 phase=-40 ps
SS 5 ns : LOCKED=1 CODE=26 phase=-94 ps
FF 5 ns : LOCKED=1 CODE=90 phase=-60 ps
4 ns    : LOCKED=1 CODE=30 period=40 ticks phase=-20 ps
2T start: LOCKED=1 CODE=65 acq_delay=49 ticks phase=-60 ps  (1T, not 2T)
0T      : ACQ_FAIL=1 CODE=279 (railed) delay=3 ticks  (0.3 ns)
0.5T    : ACQ_FAIL=1 CODE=279 (railed) delay=25 ticks (2.5 ns)
2T      : ACQ_FAIL=1 CODE=0   (railed) delay=85 ticks (8.5 ns)
```

The 0T/0.5T/2T DUTs assert no `LOCKED`, `PHASE_OK` or `RANGE_OK` at any
time.  The 2T-start DUT starts at 10.6 ns absolute delay and must converge
to the 1T tap; it does, with `acq_delay` ~49 ticks.

PHY integration (`src/ddr_clock_phy_dll_tb.v`, uniform 200 MHz, 30% input
duty, `USE_DLL=1`):

```text
DCC_LOCKED=1 DLL_LOCKED=1 DLY_CODE=58 DLL_ERR=0
DLL delay=4.960 ns period=5.000 ns mod=4.960 ns
CK_PHY high=2.500 low=2.500 period=5.000 duty=50.0%
PASS (fail-closed on PLL_LOCKED drop)
```

The production blockers are now the real-cell (gate-level/SDF), placed/PEX
and PVT/jitter verification of this DLL.  The TT/SS/FF numbers above use a
linearized T0/STEP map, not the full nonlinear code-to-delay surface, and
the DLL reference must be a uniform clock.  `USE_DLL=0` remains the verified
fallback.

## 8. Not done

- The IO wrapper is a cell-level structural/timing view; there is no
  package model, extracted board load, SI/IBIS differential-crossing
  analysis or PVT/jitter signoff.  The OpenSTA table is single-ended.
- Frequency switching, per-lane deskew and DQS/DQ training are out of
  scope for this fixed first version.
- The real-cell check is a Liberty-corner structural/timing measurement,
  not a placed/parasitic timing signoff.
- The Route B DLL is verified behaviorally at TT/SS/FF.  There is no
  gate-level/SDF or placed/PEX run of the new DLL, and no PVT/jitter
  signoff.  The code-to-delay map is a linear surrogate of the 4-seg STA
  endpoints.
- The raw ADPLL `OUT_DIV` is a fractional-divider clock with non-uniform
  edge spacing; a full-period DLL cannot lock it.  The PHY DLL path requires
  a uniform integer-divided reference.

## 9. SoC PLL scope

Clock monitor, DFS, safe switching, APB/CSR, scan bypass and power
management remain separate deliverables; they do not all belong inside
the PHY clock bundle.
