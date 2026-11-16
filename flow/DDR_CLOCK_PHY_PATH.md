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

- **DCDL interface**: `src/dll_dcdl.v` has one interface and two backends.
  CODE 0..279 maps explicitly to `COARSE = CODE / 56` (0..4 segments used)
  and `FINE = CODE % 56` (tap in the final fine segment).  `IMPL=0` is the
  segmented behavioral backend with the same 4x56 + 56 topology; `IMPL=1`
  instantiates `PLL_SEGMENTED_DELAY_PHYS`.  The behavioral boundary steps
  are fitted to the measured physical steps instead of hiding the coarse
  handoff in a linear T0 + code*STEP fit.
- **Physical boundary finding**: the first 4-segment line was
  **non-monotonic at every coarse boundary**.  Code 55 -> 56 measured
  TT -260 ps, SS -470 ps, FF -170 ps: the used segment path was faster than
  the bypass path plus the previous fine tap.  Adding 10
  `FINE_DELAY_CELL` buffer cells per used segment (`SEG_EXTRA_CELLS`) made
  the map monotonic.  Real ics55 OpenSTA:

  | Corner | 4-seg min-max | boundary steps 56/112/168/224 | max adjacent step |
  |---|---:|---:|---:|
  | TT | 2.930-12.730 ns | 40/110/80/70 ps | 130 ps |
  | SS | 3.320-20.150 ns | 30/180/110/110 ps | 250 ps |
  | FF | 2.780-9.440 ns | 30/90/60/60 ps | 90 ps |

  All three corners cover 4.5-5.5 ns and pass the monotonic/step-bounded
  gate.  This is a Liberty-corner structural check, not placed/PEX/PVT.
- **Startup range**: the line is driven by REF/16 while the TDC measures
  the absolute delay; a binary search finds the tap at the measured REF
  period.  The measured period also makes the controller frequency-adaptive:
  4 ns -> 40 ticks, 5 ns -> 50 ticks, 6 ns -> 60 ticks at the 10 GHz
  simulation TDC.
- **TDC/controller split**: `src/dll_tdc.v` timestamps REF, OUT and MON_OUT
  in the TICK domain; the asynchronous edges are 2FF-synchronized into
  TICK, and the timestamps cross to REF with toggle handshakes.  The
  controller is REF-only and consumes timestamps plus the measured period;
  it does not assume a 10 GHz binary counter.  A physical TDC can replace
  the simulation front end with the same interface.
- **Safe commit**: `code_target` is REF-domain; `code_active` is written
  only by the delayed-REF commit block.  The commit strobe is REF delayed
  by `COMMIT_GUARD_PS`; tracking writes only in the REF low phase after the
  fine-settling guard and only inside the acquired coarse.  At SS the fine
  span exceeds the low phase, so the commit is refused and the acquired
  code is held; the lock still uses that code.
- **Continuous range revalidation**: a monitor line runs from REF/16 with
  the same active code.  Its absolute delay is checked every measurement
  period; two consecutive out-of-window samples drop RANGE_OK and restart
  acquisition.
- **LOCKED = RANGE_OK & PHASE_OK & !CODE_RAILED & ALIVE.**  PHASE_OK counts
  consecutive REF windows with a valid output timestamp and a phase inside
  the measured-period window; ALIVE requires a main output edge.

`src/dll_full_period_tb.v` (segmented behavioral line, 10 GHz TICK):

```text
TT 5 ns : LOCKED=1 CODE=66 phase=-28 ps
SS 5 ns : LOCKED=1 CODE=31 phase=-68 ps
FF 5 ns : LOCKED=1 CODE=104 phase=-70 ps
4 ns    : LOCKED=1 CODE=34 period=40 ticks phase=-50 ps
2T start: LOCKED=1 CODE=65 acq_delay=49 ticks phase=-125 ps  (1T, not 2T)
0T      : ACQ_FAIL=1 CODE=279 (railed) delay=3 ticks  (0.3 ns)
0.5T    : ACQ_FAIL=1 CODE=279 (railed) delay=25 ticks (2.5 ns)
2T      : ACQ_FAIL=1 CODE=0   (railed) delay=85 ticks (8.5 ns)
```

The 0T/0.5T/2T DUTs assert no `LOCKED`, `PHASE_OK` or `RANGE_OK` at any
time.  The 2T-start DUT starts at 10.6 ns and must converge to the 1T tap;
it does.  `src/dll_range_reval_tb.v` steps the reference from 5 ns to 6 ns
and forces a missing output edge:

```text
5ns: LOCKED=1 PERIOD=50 CODE=66 phase=4.972
6ns: LOCKED=1 PERIOD=60 CODE=99 phase=5.962 RANGE=1   (after drop/re-acquire)
PASS: missing output edge dropped ALIVE/PHASE_OK/LOCKED
restore: LOCKED=1 PERIOD=60 CODE=99 phase=5.962
```

PHY integration (`src/ddr_clock_phy_dll_tb.v`, uniform 200 MHz, 30% input
duty, `USE_DLL=1`):

```text
DCC_LOCKED=1 DLL_LOCKED=1 DLY_CODE=66 DLL_ERR=0
DLL delay=4.972 ns period=5.000 ns mod=4.972 ns
CK_PHY high=2.500 low=2.500 period=5.000 duty=50.0%
PASS (fail-closed on PLL_LOCKED drop)
```

### Physical TDC (delay-line, no GHz counter)

`src/dll_tdc_phys.v` replaces the 10 GHz timestamp counter with three tapped
`FINE_DELAY_CELL` lines.  The lines are driven by short start pulses (2 cell
delays) at the REF/ACQ edges; the sampler banks are clocked by the measured
edge, and a first-high priority encoder returns the delay in tap units.  The
ACQ line is sampled by REF at the first REF after the ACQ edge (period code)
and by MON_OUT (monitor code); the PHASE line is sampled by OUT.  There is no
GHz binary counter and no same-rate toggle requirement on the controller.

Real ics55 OpenSTA delay-line span (320 taps):

| Corner | line span | tap step |
|---|---:|---:|
| TT | 7.750-11.910 ns | 24.2-37.2 ps |
| SS | 13.310-18.620 ns | 41.6-58.2 ps |
| FF | 5.410-8.910 ns | 16.9-27.8 ps |

`src/dll_phys_tdc_tb.v` (physical TDC architecture, behavioral cell delays):

```text
TT: LOCKED=1 CODE=66 period_code=166 phase_code=165 phase=4.972 ns
SS: LOCKED=1 CODE=32 period_code=96  phase_code=95  phase=4.984 ns
FF: LOCKED=1 CODE=106 period_code=249 phase_code=248 phase=4.970 ns
2T-start: LOCKED=1 CODE=65 period_code=66 acq=65
```

### Gate-level/SDF status

The full DLL/controller/TDC Yosys netlist, OpenSTA SDF and Icarus gate-level
runs are generated by `flow/sta/run_dll_gate.sh` at TT/SS/FF.  SDF empty
typical/negative triplets are filled, `COND`/`TIMINGCHECK` blocks are
stripped, and the escaped hierarchical cell names that Yosys leaves in the
flattened netlist are rewritten consistently in the netlist and SDF so
Icarus can annotate the real cells.

Physical-TDC ACQ (gate-level/SDF, `dll_tdc_phys_gl_tb`):

```text
TT: period_ext=149 main=138 mon=135
SS: period_ext=90  main=77  mon=81
FF: period_ext=230 main=212 mon=207
PASS: physical TDC line + gate-level/SDF smoke at TT/SS/FF
```

Full DLL gate-level/SDF (`dll_gate_tb`, full-period phase, all corners):

```text
TT: LOCKED after 146 REF, CODE=111, delay=4.696 ns, per=142 main=142 mon=143
SS: LOCKED after 130 REF, CODE=46,  delay=4.729 ns, per=82  main=83  mon=88
FF: LOCKED after 115 REF, CODE=178, delay=4.777 ns, per=222 main=222 mon=212
dll_gate_tb: PASS (TT/SS/FF)
```

The captured period and the tracking phase code are equal at every corner
(142/142, 82/83, 222/222); the external ns delay is ~94% of the nominal REF
period because the phase-sampler clock buffer shifts the measured edge by
~0.3 ns.  The DLL is locked to exactly one measured period, not to 0T or 2T.

Closure fixes that were required for the gate netlist:

- 16-slice buffered sampler clock trees for the 320-flop phase/ACQ/monitor
  banks; wiring OUT/REF/MON_OUT directly to 320 clock pins produced a ~6 ns
  clock-path delay in the ics55 netlist.
- `DLL_ACQ_PERIOD` is synthesized as real gates (flops plus a self-contained
  320-input priority encoder); there is no blackbox instance, and
  `assign period_ticks = {7'h00, period_r[8:0]}` keeps the full period bus.
  The OpenSTA SDF includes the period flops (CK->Q 0.129-0.141 ns at TT).
- `ad`/`md`/`pd` rewritten as signed combinational wires; the previous
  self-referencing `integer` always blocks were dropped by Yosys and left
  `pd=z` in the netlist.
- SDF `COND` blocks are unwrapped rather than deleted; OpenSTA writes flop
  CK->Q/RN->Q arcs under COND, and deleting them left the flop CELLs empty
  and dropped the period-capture timing.
- Buffered bypass in `PLL_SEGMENTED_DELAY_PHYS`; the bypass mux was driving
  the next 56-cell segment and the minimum code delay was ~6.18 ns (>1 REF
  period).
- Physical acquisition window/controller parameters selected with
  `chparam` (`CODE_MIN=20`, `CODE_MAX=230`, `ACQ_TOL_DIV=3`, monitor 3/8,
  miss tolerance 8, early in-window acceptance).

PEX/PVT is not yet run: LibreLane v3.0.14 and the ics55 PDK are present, but
the full DLL has not been placed/routed/extracted.  The gate-level/SDF flow
above is the prerequisite; the next step is LibreLane hardening plus
SPEF/SDF multi-corner closure.

The behavioral physical-TDC TB (`test_dll_phys_tdc`) and the period
range-revalidation TB still use their external-ns phase checks; they show the
TDC pulse-width calibration offset at SS (≈0.97 ns) even though the gate-level
full DLL locks at 5.005 ns.  These behavioral calibration checks remain to be
updated/calibrated; they do not affect the gate-level ACQ/full-DLL closure
above.

`make test_ddr_phy` treats the legacy COARSE-only DCDL as
`test_ddr_phy_legacy_blocked` (passes only while it is BLOCKED) and gates
the new design with `test_segmented_dcdl`.  The remaining production
blockers are gate-level/SDF and placed/PEX/PVT verification of the new
DLL, and a uniform integer-divided reference.  `USE_DLL=0` remains the
verified fallback.

## 8. Not done

- The IO wrapper is a cell-level structural/timing view; there is no
  package model, extracted board load, SI/IBIS differential-crossing
  analysis or PVT/jitter signoff.  The OpenSTA table is single-ended.
- Frequency switching, per-lane deskew and DQS/DQ training are out of
  scope for this fixed first version.
- The real-cell check is a Liberty-corner structural/timing measurement,
  not a placed/parasitic timing signoff.
- The Route B DLL is verified behaviorally and at gate-level/SDF at
  TT/SS/FF.  There is no placed/PEX run of the new DLL, and no PVT/jitter
  signoff.  The code-to-delay map is a linear surrogate of the 4-seg STA
  endpoints.
- The raw ADPLL `OUT_DIV` is a fractional-divider clock with non-uniform
  edge spacing; a full-period DLL cannot lock it.  The PHY DLL path requires
  a uniform integer-divided reference.

## 9. SoC PLL scope

Clock monitor, DFS, safe switching, APB/CSR, scan bypass and power
management remain separate deliverables; they do not all belong inside
the PHY clock bundle.
