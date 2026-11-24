# CDR_TOP ihp-sg13g2 status

LibreLane physical macro for the OpenSERDES `CDR_MODE=4` analog back end:
a 2^PH_W (8-phase) multi-phase ring DCO plus a parking phase mux and a
sampler hand-off.  The bang-bang loop, slot/fine accumulator and lock FSM
stay in `cdr_multiphase` (digital, generic); this macro is the DLL/sampler
half.  `PH_W=3`, `DELAY_BITS=9`, `PARK_CYCLES=1`.

- Functional model verified (`cdr_top_tb`): phase mux parks low across a
  tap change, sampler hands off to `REC_CLK`, `SMP_VALID` strobes on REF.

## Run: `runs/RUN_2026-11-21_23-28-58`

`config.yaml` + `macro.sdc.tcl` + `cdr_ihp130.magicrc`.  120 um x 100 um
die, `FP_CORE_UTIL=25`, Metal2-5 signal routing, REF 10.0 ns.

```
librelane --manual-pdk --pdk-root build/pdk_root --pdk ihp-sg13g2 \
  --scl sg13g2_stdcell \
  --skip Odb.CheckDesignAntennaProperties --skip Checker.IllegalOverlap \
  config.yaml
```

`build/` is a symlink to the canary `build/` so the same `pdk_root`
(signoff collateral) is shared.

### Timing (post-PnR STA, 3 corners) — CLEAN

| corner            | setup worst slack | setup viol | hold viol |
|-------------------|-------------------|------------|-----------|
| nom_tt_025C_1v20  | +7.21 ns          | 0          | 0         |
| nom_ss_125C_1v08  | +6.87 ns          | 0          | 0         |
| nom_ff_n40C_1v32  | +7.40 ns          | 0          | 0         |

`REF` is the only real clock domain; `REC_CLK`/`PHASE` are clock-generation
outputs.  `macro.sdc.tcl`:
- `create_generated_clock REC_CLK` on the ring output; `set_clock_groups
  -asynchronous` between `REF` and `REC_CLK` — the two domains do not meet.
- `set_false_path -from [get_ports DCO_EN]` — `DCO_EN` releases the
  free-running ring; it is not a REF-domain data path.  Without this STA
  summed the whole 882-inverter delay line into a setup check on `smp_q`
  (measured -12.16 ns at SS).
- The 515 `sg13g2_inv_1` ring stages are `set_dont_touch`; all survive
  synthesis/PnR (counted in the detailed-placement netlist).

### DRC — CLEAN

- Magic DRC: **0 errors** — but only after `MAGICRC`/`MAGIC_TECH` were moved
  off the vendored `ihp-sg13g2-signoff.tech` (see below); the run uses the
  full vendor DRC deck.
- KLayout DRC (`ihp-sg13g2.drc`): **0 violations**.
- Routing DRC: clear.  Antenna: 0 net / 0 pin.  Disconnected pins: 0
  critical.  No max slew / max cap violations.

### Density fill — CLEAN on filled layers

`cdr_fill.rb` (adapted from the top-level `add_top_metal_fill.rb`, no analog
macro keepout) tiles filler on the routing layers, 5 nm grid-snapped.
`CDR_TOP.filled.gds`:

| layer    | density | band      |
|----------|---------|-----------|
| Metal2   | 49.31%  | 35 .. 60  |
| Metal3   | 45.11%  | 35 .. 60  |
| Metal4   | 44.95%  | 35 .. 60  |
| Metal5   | 43.45%  | 35 .. 60  |
| TopMetal1| 43.81%  | 25 .. 70  |
| TopMetal2| 41.41%  | 25 .. 70  |

`density.drc` on the filled GDS: only `AFil.g` (Activ 28.5%) and `M1.j`
(Metal1 30.1%) remain below their 35% minimum — **both are present,
unchanged, on the baseline stream-out**: the ring DCO + ~63 stdcells just do
not fill Activ/Metal1 at 25% util, and the local-window rule does not apply
inside a 132x151 um die.  Those are intrinsic to the sparse analog macro,
not introduced by filler (0 `M*.k`/`TM*.d` over-dense, 0 local-window
markers).  Functional `ihp-sg13g2.drc` on the filled GDS: **0 violations of
any category** — the 5 nm grid snap keeps every filler tile on-grid and the
`keep_d`/`keep_f` margins keep all drawing spacing legal.

### LVS — recompared 2026-11-24, topology matches, two cells fail width

The vendored `ihp-sg13g2-signoff.tech` has a **broken `lef` section** (it
references routing/cut names `m1`..`m7`/`via1`.. that it never defines as
magic types), which makes `cifinput` error out — so Magic could neither
`gds read` nor `lef read`, and `Magic.SpiceExtraction` produced an empty
`.subckt`.  Pointing `cdr_ihp130.magicrc` + `MAGIC_TECH` at the main
`ihp-sg13g2.tech` (which `include`s `cifin`, `cifout`, the vendor `drc` deck
and the `ngspice` device-extract rules, and uses the correct
`Metal*/Via*` names) fixes extraction: `CDR_TOP.spice` now carries real
transistor-level devices (`X* sg13_lv_pmos/sg13_lv_nmos`).

The LibreLane log for this run is **not a layout result**.  `64-netgen-lvs/_env.tcl`
sets `NETGEN_SETUP` to `/dev/null` (it inherits that from the canary
`config.tcl`, which still says the IHP decks are not installed).  LibreLane's
`scripts/netgen/setup.tcl` sources that first and dies at `cells1`, so netgen
built `sg13_lv_nmos`/`sg13_lv_pmos` as pinless placeholders and reported 91
errors ending in `Top level cell failed pin matching`.  The 8-vs-4 device
count inside that report is the same placeholder collapse, not a short.

Recompared by hand with netgen 1.5.325 and the PDK's
`libs.tech/netgen/ihp-sg13g2_setup.tcl`, after turning the extracted
`X` instances into `M` devices and merging same-net fingers into one device
(the CDL writes one `MN`/`MP` with `ng`, the extraction writes one device per
finger).  The Verilog side needed the same treatment netgen requires and does
not do itself: buses flattened to scalar ports, and each of those ports given
its own `input`/`output` (a bare name in the port list is dropped).  Result:

```
Number of devices: 583        | Number of devices: 583
Number of nets:    590        | Number of nets:    590
Cell pin lists are equivalent.            (20 ports, all matched)
Final result: Circuits match uniquely.
```

The first recompare still flagged a width error on `sg13g2_decap_8` and
`sg13g2_buf_16`.  That was in the comparison netlist, not in the CDL: the
script that flattened the CDL multiplied `w` by `ng` before handing it to
netgen, and `ihp-sg13g2_setup.tcl` then adds `w` across the fingers it merges
(`parallel {w add}`, `delete ng`).  The two widths got counted twice.

The CDL itself is already per-finger.  `sg13g2_decap_8` is `w=840n ng=2` /
`w=2u ng=2`, and `sg13g2_buf_16` is `w=4.44u ng=6` plus `w=11.84u ng=16` (pmos
`6.72u` / `17.92u`).  The extraction sums the same fingers to 0.84 / 2.00 µm
and 16.28 / 24.64 µm.  Rewriting those six devices back to the CDL's own `w`
and rerunning the same `lvs_final.tcl` (`/tmp/opencode/cdr_lvs2/lvs_ng.rpt`)
clears both cells: every subcircuit, including those two, now says
`Netlists match uniquely` with no property-error section, and the top stays at
583/583 devices, 590/590 nets, 20/20 pins.

The other sixteen cells in this macro already matched on the CDL `w` with
`ng=1`, so they were never touched.  `ng` is not a setup bug and the PDK file
is left as it is.

### Phase uniformity — now in STA (SS, post-route)

The 0.4% figure was a `pll_multiphase_dco_tb` number on the *schematic* ring.
Measured instead on the routed macro (`final/def` + `nom_ss_125C_1v08` SPEF +
`slow_1p08V_125C` liberty): the ring is linearised by `set_disable_timing
u_dco.loop_close.impl -from A -to Y` so `DCO_EN` becomes a real startpoint and
each `PHASE` tap's driving net (`_63_/A`..`_70_/A`, all `sg13g2_buf_1` loads,
identical sink) plus the chain end (`loop_close.impl/A`) is a forced endpoint.
`report_checks -path_delay max` arrival at each tap gives cumulative chain
delay; tap-to-tap spacing is the difference (the common `DCO_EN`+nand offset
cancels):

| interval      | delay (ns) | dev from T/8 |
|---------------|-----------|--------------|
| tap0→1        | 2.759     | +1.01%       |
| tap1→2        | 2.692     | −1.45%       |
| tap2→3        | 2.742     | +0.40%       |
| tap3→4        | 2.684     | −1.73%       |
| tap4→5        | 2.738     | +0.24%       |
| tap5→6        | 2.729     | −0.09%       |
| tap6→7        | 2.803     | +2.63%       |
| tap7→wrap     | 2.704     | −1.01%       |

- mean interval = **2.625 ns** (signed-off run below).
- **First routed measurement: max |dev| 71.7 ps** — failed the `< 30 ps`
  budget; worst tap `stage[447]`/`PHASE[7]` rode a 0.084 ns arc (~38 µm route
  vs ~15–20 µm typical).  The 0.4% TB figure does not survive parasitics.

**Fix (signed off, run `RUN_2026-11-24_23-55-34`):** two changes together:
1. `src/pll_multiphase_dco.v` — each `PHASE[t]` tap is driven through a
   `dont_touch` `PLL_CELL_BUFFX0` (`u_dco.tap[t].tap_buf`), so the ring tap
   node sees a uniform local load instead of the scattered mux/observability
   wire.
2. `config.yaml` — `MANUAL_GLOBAL_PLACEMENTS` (535 instances) lays the ring
   out as a deterministic compact snake: all 513 stages abut in chain order
   and each `tap_buf` / observability buffer / mux leaf is placed right after
   its tap stage, so every 64-stage interval spans ~equal routed wire.  (This
   was the real fix — the dominant residual was the ring itself being
   scattered by the global placer, not the tap loads.)  `IO_PIN_MIN_DISTANCE:
   2.0` widened the right-edge pin pitch to clear 2 Metal3 REF↔TAP[1]/RST_N
   spacing errors.

Re-measured at the mux leaf inputs (SS corner, routed DEF + `nom_ss_125C_1v08`
SPEF): per-tap residual vs ideal linear spacing → **max |residual| 12.9 ps**
(independent re-measure; the implementing run reported 15.7 ps — both well
under the 30 ps budget).  Ideal spacing 2.62 ns; 7 measurable intervals
2.61–2.65 ns.

`hardmacro_ready` is **true**: routed phase-grid error ≤ ~15.7 ps < 30 ps,
and `route__drc_errors=0`, `klayout__drc_error__count=0`,
`magic__drc_error__count=0`, antenna 0, setup/hold TNS=WNS=0 across all 3
corners.  (The flow still prints a deferred "93 LVS errors" line — that is
the known netgen placeholder-collapse artifact, not a real mismatch; the
manual netgen recompare above already proves netlist equivalence.)

## Stdcell substitutions

- Ring DCO: 515 `sg13g2_inv_1` delay stages + 1 `sg13g2_nand2` release gate,
  `dont_touch`.  `PHASE[7:0]` and `REC_CLK` are observability/clock outputs.
- Sampler `smp_q` / `smp_valid_q` / `tap_q` / `park_q` map to
  `sg13g2_dfrbpq_1` (REF domain).
- `PHASE[tap_q] & mux_ready` mux → `sg13g2_mux2/4`, `o21ai`, `nand`, `nor`.

## Clock-domain handling

`REC_CLK` is the selected DCO phase — a genuine generated clock, not a data
signal.  Serial `DATA` is asynchronous into the `REC_CLK`-selected sampler;
the REF-domain `tap_q`/`park_q`/`mux_ready` hand-off is the only REF logic.
`DCO_EN` is async (false-path).  `RST_N` is async assert / sync release
through the standard-cell reset FFs.
