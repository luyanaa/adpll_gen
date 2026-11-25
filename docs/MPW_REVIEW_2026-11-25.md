# IHP 130 nm MPW — critical review of the two planning reports

Status: review deliverable, 2026-11-25. Reviews the pasted `MPW_PINS_AREA.md`
(pin/area/DDR-IO estimate) and the "MPW candidates — status and remaining
work" report against the **actual repo HEADs**. These are planning estimates,
not signoff — both source docs say so themselves. This report lists what is
stale, what is overstated, and what is still missing.

## 0. Doc HEADs are stale (verified against the repos)

| repo | doc HEAD | actual HEAD | what landed since |
|---|---|---|---|
| adpll_gen | `865ef20` | `7b0ac30` | coarse/fine DCO tuning + divider/freq-lock/counter + generator spec |
| OpenSERDES | `4154433` | `fdad859` | real-clock continuous PRBS31 BER=0 closure + BBPD/gearbox/pipeline fixes |
| ddr-phy | `6e818b9` | `1380ae8` | submodule bump, tb_dimm_smoke SMOKE_PASS |

Consequence: the "completion %" and "remaining work" lists are partly stale
(some things are further along than stated) — but also wrong in the *other*
direction on the one number that matters most (§1).

## 1. Dominant risk — the SS ring rate is unverified and likely ~2x worse

Both reports lean on **"cdr_ihp130 ≈ 335 MHz @ SS"** (status §1; MPW_PINS_AREA
OpenSERDES §3). Trace: that 335 is commit `9b4452d`'s **STA linearization**
(`loop_close arrival 1.49 ns ~ half-line` → period 2.98 ns). It is a
`set_disable_timing` single-traversal path estimate, **not a measured
oscillation**.

**Reconciliation complete (2026-11-25, device-level, controlled).** Both
numbers are correct — 335 is *not* an artifact:
- The signed-off **335 MHz @ SS** = ONE routed traversal 1.49 ns × 2,
  **bankless** ring. Valid.
- The new **tuned** ring at fastest code (c0/f−31) = **185 MHz @ SS**
  (pre-layout). The earlier "inv-only 154 MHz" was a mislabeled deck (retracted;
  real inv-only = 390 MHz). The drop is the banks' **5.7 fF/stage fixed load**
  (~30 ps/stage at SS), not a measurement bug. c31 startup dead-state confirmed
  real.
- **Decision**: stage drive `inv_1 → inv_4` (+ one-shot startup kick) — `inv_2`
  fails 250 @ SS after the ~16% routing penalty (~215 MHz); `inv_4` gives
  ~267 MHz routed @ SS ≥ 250 with margin and clears 500 @ FF. Detail in
  `docs/dco_tuning_design.md`.

What this breaks in the reports:
- MPW_PINS_AREA §3 and status §3 say *"safe demo is 1 Gb/s (250 MHz
  quarter-rate); 2 Gb/s needs TT/FF only."* If SS is really ~185 MHz, **even
  250 MHz @ SS is unreachable** — there is no corner-guaranteed rate at SS
  with the current fixed ring. The "safe 1 Gb/s" claim is not safe.
- This is exactly why a coarse/fine-tuned ring rebuild is in flight
  (`docs/dco_tuning_design.md`). Neither report mentions it — the single
  biggest PMA workstream is absent from both.

## 2. Signoff gaps common to both (none are "done")

- **Full-chip IHP top does not exist.** Both reports flag pad ring / seal ring
  / full-chip DRC / LVS / IR-EM as *"the largest unowned work item."* It is
  the schedule-critical path to Jan-10.
- **No power / pJ-per-bit anywhere.** The only power numbers in the repos are
  per-block µW (e.g. bang-bang 1.2 µW on sky130). The earlier program plan
  required pJ/bit by payload, SAIF/VCD for digital, and separately extracted
  oscillator / PI / IO power — all missing.
- **No jitter / phase-noise signoff.** adpll_gen B7: *"no phase noise or jitter
  at any corner."* For a PLL/SerDes MPW that is a headline spec.
- **Hard macro has TT-only Liberty.** `hardmacro/PLL_ANALOG.lib` is *"TT 1.20 V
  / 25 C only"* (canary config line 72). Full-chip SS/FF STA cannot include the
  macro without SS/FF liberty — a signoff blocker. (The ADPLL *digital* itself
  is not SS-closed either: setup **−0.3168 ns**, 8 violators.)
- **LVS/DRC carried with waivers:** bang-bang top LVS residual, `cdr_ihp130`
  "93 LVS errors" placeholder-collapse artifact, adpll port-naming waiver.
  Signoff cannot ship with open waivers.
- **No DFT/scan, no calibration hooks** (listed as remaining).

## 3. DDR-specific risks — the biggest block in the pin budget is the least-built

- **~30 of ~65 pads are DDR1** — for a block that is **~5%, RTL absent**
  (`rtl/ddr1_phy.sv` confirmed missing in ddr-phy @ `1380ae8`). The pin table
  is sized for an unwritten design.
- **2.5 V IO is uncharacterized.** The 2.5/1.8 V rows are *"first-order
  scaling, not data"*; ngspice on the pad *"would not converge"*; *"simulating
  the pad at 2.5 V is an open item, ~a day."* So "DDR1 on stock IO at 2.5 V" is
  not de-risked.
- **No ring-break cell** → the 2.5 V IOVDD segment needs a custom rail gap plus
  its own ESD/power clamps — custom analog layout, unbuilt.
- **6-week schedule vs reality.** DDR1 from ~5% needs 1:2 DFI, a behavioral
  DDR model, an init sequence, `ck90`, LiteDRAM integration, **and** the
  uncharacterized pads. The source doc itself concedes custom-pad DDR1 is
  "not realistic in ~6 weeks"; even the stock-pad path is tight.

## 4. Stale / incorrect claims to correct in the source docs

- **`B1: "config.macro.yaml still points at an empty hardmacro/"` is stale.**
  `flow/canary/ihp130_sg13g2_core_a/hardmacro/` now contains `PLL_ANALOG.gds`
  (20 MB), `.lef` (71 pins, 160×105), `.lib`, `corners/`, and the blackbox.
  Top assembly is further along than stated — the real gap is the TT-only
  liberty (above), not an empty directory.
- **OpenSERDES "BER 0 at 1 and 2 Gb/s" understates its own weakness.** It is
  RTL-level on the DCO ring with a **behavioral `#delay` PI** (no physical PI
  netlist), at a ~TT-like 40 ps stand-in (not SS); and the TX 2 Gb/s 20k-bit
  zero-error was **ideal-clock** (structural proved oscillation only).
- **HEADs / completion %** — refresh to §0.

## 5. Cross-repo single-point-of-failure

Clocking leans on the ADPLL output, but the ADPLL is (a) not SS-closed and
(b) has a **known DLL false-lock**. The reports note a bypass exists, but the
default integration plan still routes DDR `sys`/CK and SerDes PCS off an
unclosed PLL. Invert that dependency — external/bypass by default — until the
ADPLL is SS-closed and jitter-measured.

## 6. Priority actions (to de-risk Jan-10)

1. **Nail the SS ring rate** — finish the SPICE-vs-STA reconciliation; decide
   `inv_2` vs `inv_4` vs load-reduction. This decides whether *any* rate is
   corner-guaranteed. Everything downstream depends on it.
2. **Own the full-chip top early** (pad ring / seal / DRC / LVS / IR) — the
   largest unowned item and the real critical path.
3. **SS/FF Liberty for the hard macros** (unblocks full-chip STA).
4. **Power + jitter signoff** (currently zero coverage).
5. **Decide DDR1 scope now** — commit to stock-2.5V-IO with a real RTL start
   this week, or descope DDR1 from this shuttle (~30 pads).
6. **Correct the stale claims** in both source docs (HEADs, "empty hardmacro",
   the 335 / 1-Gb/s-safe statements).
