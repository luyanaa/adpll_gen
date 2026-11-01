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
- Top LVS is not closed; the macro-power/PDN root cause is identified, but the
  `[20,0]` retry did not produce a clean final DRC.
