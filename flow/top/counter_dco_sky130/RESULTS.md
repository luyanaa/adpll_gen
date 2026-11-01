# sky130 Core C top PnR results

Status: physical integration experiment, not production signoff.

## Flow

- Top: `PLL_COUNTER_TOP` (real digital RTL) + hardened `PLL_COUNTER_DCO_PHYS`
- PDK: `sky130_fd_sc_hd` (TT `nom_tt_025C_1v80` only)
- Primary die: `300 x 300`; macro at `[20,20]` (`top_pnr4`)
- Retry: `300 x 300` macro `[20,0]` (`top_pnr5`); `350 x 350` macro `[20,0]` (`top_pnr6`)
- CTS and OpenROAD RCX SPEF extraction enabled

## Best completed run: `top_pnr4`

- Final views: `runs/top_pnr4/final/{gds,def,lef,nl,spice,odb,metrics.json}`
- Pre-fill: 1965 cells / 38849.60 um^2
- Final instance count including fill: 11034; stdcell 3507; macro 1
- Final instance area: 123178 um^2 (stdcell 23356, macro 19098, fill 80723)
- Setup WNS/TNS: `0 / 0`
- Hold WNS/TNS: `0 / 0` after resizer
- Magic DRC: Passed
- KLayout DRC: skipped (`KLAYOUT_DRC_RUNSET` unset for this PDK)
- LVS: Failed; 3 errors, 1 unmatched net
  - `Net: dco/VPWR (no matching net)`
  - `Net: dco/VGND (no matching net)`
  - Root cause: macro met4 power pins did not overlap the top PDN straps
- Power-grid checker: 998 violations (499 VPWR + 499 VGND), deferred
- Antenna: Failed; 5 pin / 5 net violations
- PEX: `runs/top_pnr4/54-openroad-rcx/nom/PLL_COUNTER_TOP.nom.spef`
- Manufacturability summary: `runs/top_pnr4/73-misc-reportmanufacturability`

## PDN/LVS retries

`top_pnr5` moved the macro to `[20,0]` so its met4 power rails overlap
the top PDN stubs. OpenROAD reported `dco matched with dco`; the remaining
power-grid count dropped from 998 to 996, and the two macro power nets were
no longer the reported unmatched-net cause. Detailed routing at 300x300 did
not converge cleanly (66 violations at the last iteration before the shell
timeout); no final views were produced.

`top_pnr6` repeated the `[20,0]` placement on a `350 x 350` die. It completed
all 80 steps and saved final views, but the larger/edge placement was worse
overall: 996 power-grid violations, 58 routing DRC errors, 36 Magic DRC
errors, 15 Magic illegal-overlap errors, and 5 LVS errors. Its final views are
at `runs/top_pnr6/final`, but `top_pnr4` remains the best completed result.

`top_pnr9` added a custom `PDN_CFG`/`pdn_patch.tcl` (no macro grid; wrap
`pdngen` to bind the macro met4 power rails to global straps). It completed
all 80 steps with Magic DRC passed, but the top met5 straps were removed as
floating by `PDN-0110`/`PDN-0200` before the patch ran, so the patch reported
no met5 strap for every macro rail. Result: 998 PSM violations, 3 LVS errors,
5/5 antenna, DRC pass. This did not close LVS.

`top_pnr10` switched to a single-layer met4 PDN and a met4 fallback in the
patch. DRC passed, but LVS was worse: 4 errors, 2 unmatched pins, 1 unmatched
net, and antenna 8/8. This confirmed that a horizontal met4 jog can short or
mis-bind the macro rails; the approach is not used.

`top_pnr11` tried wider met4/met5 PDN straps (`PDN_V/HWIDTH=1.6`) with
`PDN_V/HSPACING=0.5`. It failed immediately with `PDN-0108`: met5 minimum
spacing is 1.6 µm. No final views.

`top_pnr12` repeated with `PDN_V/HSPACING=1.6`. PDN generation reduced the
`PDN-0110` no-via count from 592 to 88, but `dco/VPWR` and `dco/VGND` were
still unconnected and the flow failed in detailed routing with `DRT-0085`
(no valid access pattern for `load_slew60/61`, `sky130_fd_sc_hd__probe_p_8`).
No final views.

`top_pnr13` implemented both remaining directions: (1) top-flow macro
LEF/GDS copies with all 12 met4 power rails extended to the macro boundary
and (2) a hand-written local met4 bridge around the DCO rails. Detailed
routing completed, but the result was worse: Magic DRC failed with 111
errors, LVS failed with 4 errors / 2 unmatched pins / 1 unmatched net
( VG ND pin↔VPWR node swap = a short), and antenna failed 4/4.
Setup/hold remained 0/0.  Post-run review found the failure was two
implementation bugs, not a wrong direction:

* `_bind_rail` and `_patch_dco_local` read `dbMPin::getGeometry` in the
  macro MASTER frame and used it as chip coords, so every bridge and rail
  bind landed 20 µm down-left of the macro (inst at [20,20]).  The
  hardcoded VGND jog ran through the real VPWR vertical strap →
  VGND↔VPWR short (the LVS pin swap).  Coordinates now go through the
  instance origin in `_bind_all`/`_bind_rail_abs`.
* Extending the macro's met4 rails to y=0 was unnecessary (a vertical
  rail gains nothing by overlapping a same-layer vertical strap; only a
  horizontal jog to a same-net strap connects) and made Magic stream-out
  slice the existing fill-cell met2 band into <28 nm notch slivers — all
  111 `met2.2` errors sit on those rail edges at y≈30.55–30.8.  Reverted
  to the original `flow/macro` LEF/GDS.
* True top straps: VPWR met4 at x = 0/23.62/43.62/…; VGND = VPWR+1.44.
  Each macro rail (abs x = rel+20) has a clear horizontal met4 channel
  to its nearest same-net strap (e.g. VGND rail 51.48 → strap 45.06,
  no VPWR strap in between), so `_bind_rail_abs`'s jog is sufficient;
  the extra `_patch_dco_local` bridge was removed.

`top_pnr16b` **closes both LVS and DRC** — the first clean top-level run.
Two changes did it:

1. `PDN_VOFFSET: 4.52` aligns the met4 VPWR/VGND strap grid with the
   macro's power rails.  Measured in top_pnr15b's DEF, internal VPWR
   strap centre = `PDN_VOFFSET + 6.0` (mod PDN_VPITCH=20); macro rail
   centres sit at abs x = 30.52/50.52/../130.52 == 10.52 (mod 20), so
   VOFFSET=4.52 and the paired VGND strap (+1.44) lands on each VGND
   rail (x1.96 mod 20).  The straps run the full die height, so they
   overlap the macro rails directly - no horizontal jog needed.
2. `pdn_patch.tcl::_bind_vertical` bridges the residual ~0.6 um gap:
   the aligned strap is trimmed just above each rail top (strap bottom
   y=151.4, rail top y=150.8).  It draws a same-x vertical met4 stub
   from each rail top to the overlapping same-net strap - vertical, so
   it cannot cross an opposite-net strap (unlike the earlier horiz jog
   that shorted VGND<->VPWR).  Rail binding uses the instance origin to
   convert master->chip coords.

Result (`runs/top_pnr16b/final`):
  LVS ......... `Circuits match uniquely` (lvs_error=0, unmatched=0)
  PSM ......... power_grid_violation=0 (was 998)
  Magic DRC ... magic__drc_error__count=0
  Route DRC ... route__drc_errors=0
  Timing ...... setup/hold WNS=TNS=0
  Antenna ..... antenna__violating__nets=2 (residual, was 5)

`top_pnr17` clears the residual antennas.  The 2 violations were
side-area-ratio on `clkdlybuf4s50_1` gates (INJ_EN/input13/A met3,
net59/output59/A met1).  Root cause: `DIODE_CELL` was unset, so
`repair_antennas` ran but skipped post-DRT repair
("Skipping post-DRT antenna repair: 'DIODE_CELL' not set").  Setting
`DIODE_CELL: "sky130_fd_sc_hd__diode_2/DIODE"` let repair run; the
violations cleared via reroute/jumper (antenna_diodes_count=0).
Result (`runs/top_pnr17/final`): all signoff counters zero -
  LVS=0 unmatched, Magic DRC=0, Route DRC=0, PSM=0, antenna=0,
  setup/hold WNS=TNS=0, flow__errors__count=0.  This is the clean
  top-level result.

`top_pnr18b` adds signoff coverage on top of the top_pnr17 recipe
(PDN_VOFFSET=4.52 strap alignment + `_bind_vertical` rail bridge +
DIODE_CELL).  New: MCSTA at nom_tt/min_ff/max_ss, KLayout DRC via
`sky130A.lydrc`, and an IR-drop report.  Results:
  KLayout DRC ......... klayout__drc_error__count=0  (runset now set)
  IR drop ............. worst 1.58e-05 V on VGND, 0.00 % (PSM clean)
  MCSTA (flow) ........ setup/hold WNS=TNS=0 at all 3 corners
  Independent OpenSTA + post-route SPEF worst slack:
      TT 1.80V 25C   setup +1.01  hold +0.055 ns
      FF 1.95V -40C  setup +0.83  hold +0.154 ns
      SS 1.60V -40C  setup +1.50  hold -0.558 ns (RST_N removal check)
  Residual flags:
    * LVS reports 2 errors -> 1 net mismatch on `net92` (RST_N fanout
      re-buffered by antenna-diode insertion; device pin lists are
      equivalent on both sides, so it is a netgen net-name grouping
      artefact, not an open/short).  top_pnr17 (no diodes) had clean
      netlists.
    * max_ss_n40C_1v60: 60 max-slew + 4 max-cap violations (slow corner
      not re-buffered - reported, not fixed).
    * SS corner RST_N removal -0.558 ns (async-reset release timing;
      needs a hold-path delay or set_false_path -hold decision).

Intermediate steps: top_pnr14 fixed getLocation list unpack;
top_pnr14b still jogged horizontally -> short (reverted); top_pnr15/15b
probed the strap-phase formula; top_pnr16 aligned straps but left the
0.6 um gap; top_pnr16b bridges it and is the keeper.

## Constraints audit

`constraints/top.sdc` defines:

- `REF` 375.000 ns
- `TICK` 10.000 ns
- `DCO_OUT` 375.000 ns at `dco/OUT`
- `MID_OUT` 375.000 ns at `dco/MID_OUT` (independent clock; blackbox internal
  source path is invisible)
- `INJ_EDGE` 375.000 ns at `dco/INJ_EDGE` (independent clock)
- `OUT_DIV` 750.000 ns generated from `MID_OUT` /2
- `DSM_CK` 750.000 ns generated from `MID_OUT` /2
- `CKR` 750.000 ns generated from `MID_OUT` /2

The script resolves `DSM_CK`/`CKR` driver pins from exact post-synthesis net
aliases (`u_logic.dsm_impl.DSM_CK`, `u_logic.CKR`) and constrains the Gray bus
from the exact `u_logic.flock.cnt_gray[0..15]` nets. This reduced unclocked
register/latch pins from 118 to 0.

`set_max_delay -datapath_only` is not supported by OpenSTA 2.0.17 or the
OpenROAD version used by this flow; the final constraint is
`set_max_delay 0.500` without that flag. OpenROAD still warns that the
selected Gray source Q pins are not valid start points in some early steps,
so the Gray exception should be re-audited in a signoff STA.

`check_setup` still reports 18 unconstrained endpoints: `OUT`, `OUT_DIV`, and
16 Gray synchronizer D pins. The 16 D pins are the destination of the
max-delay; `OUT`/`OUT_DIV` are clock outputs without output delay.

`OUT_DIV` produces `STA-1062` ("source pin OUT_DIV missing paths from master
clock MID_OUT") because the divider is separated from the macro pin by the
digital hierarchy; the clock is still defined at the top port.

## Limits

- Only TT top STA; no SS/FF, no top-level MCMM signoff.
- Macro Liberty is TT; no macro SPEF was provided to top STA.
- No Pnoise/PSS, random-jitter, or phase-noise signoff.
- KLayout DRC was not run; only Magic DRC is top-level DRC evidence.
- The 996/998 deferred PSM violations remain; IR-drop/power integrity is not closed.
- Antenna is not closed (5/5).
- Top LVS is not closed; the macro-power/PDN root cause is identified, but
  `[20,0]`, `350x350`, custom `PDN_CFG`, and single-layer met4 retries did not
  produce a clean LVS/DRC combination.
