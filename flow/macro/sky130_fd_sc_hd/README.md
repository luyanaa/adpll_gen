# PLL_ANALOG_MACRO — sky130_fd_sc_hd experiment

This is a second sky130 lane, using the standard `~/.ciel` OpenPDK
`sky130_fd_sc_hd` library instead of `sky130_as_sc_hs`.

## Why

`sky130_as_sc_hs` ships no CDL; its LVS reference had to be Magic-extracted
from 17 `.mag` cells. `sky130_fd_sc_hd` ships a full CDL/SPICE set, so it is
the better candidate for a clean LVS signoff path.

## Status

| Item | Result |
|---|---|
| Mapping | 15 `PLL_CELL_*` wrappers; `dfxtn` mapped to `dfxtp_2` + clock inverter |
| LibreLane P&R | reaches detailed route/fill; stops later at missing antenna LEF |
| Die | 79.665 × 90.385 µm = 0.00720 mm² |
| KLayout DRC | **0 violations** |
| LVS | **still fails at cell-subcircuit comparison**; no PDN/must-connect blocker after using `tapvpwrvgnd_1` |
| Density fill | not implemented |

## Important library mapping differences

- `sky130_fd_sc_hd` has `buf_2` (not `buff_2`), with output `X`.
- `and2_2` output is `X`.
- `nand2b_2` input is `A_N`; `nor2b_2` input is `B_N`.
- No `dfxtn_2`; `PLL_CELL_DFFNQX1` uses `dfxtp_2` with an added inverter.
- Tap master is `tapvpwrvgnd_1`; using `tap_1` leaves body pins unconnected.
- `SYNTH_TIEHI/LOW` use `conb_1/HI`, `conb_1/LO`.
- PDN/power mapping must be `SCL_POWER_PINS=[VPWR,VPB]`,
  `SCL_GROUND_PINS=[VGND,VNB]`; the initial overlay had the old swapped list.

## LVS detail

The canonical GDS/DRC is clean:

```text
final/PLL_ANALOG_MACRO.gds
final/PLL_ANALOG_MACRO_drc.lyrdb   # 0 items
```

The CDL is regenerated from the P&R ODB with `write_cdl -masters` against the
PDK CDL.  KLayout LVS still reports per-cell pin/device mismatches; the top
level no longer has the `PSM-0069` PDN failure.

Files:

```text
final/PLL_ANALOG_MACRO.def
final/PLL_ANALOG_MACRO.gds
final/PLL_ANALOG_MACRO.cdl
final/PLL_ANALOG_MACRO.reordered2.spice
final/PLL_ANALOG_MACRO_lvs*.lvsdb
```

This lane is experimental; it is not claimed as signoff-complete.

## Netgen follow-up (2026-10-29)

A direct netgen comparison was run with:

```text
layout:  final/PLL_ANALOG_MACRO_extracted8.cir
ref:     final/PLL_ANALOG_MACRO.vnb.spice / PLL_ANALOG_MACRO.spice
setup:   ~/.ciel/.../sky130A/libs.tech/netgen/sky130A_setup.tcl
```

The canonical `sky130_fd_sc_hd.spice` cell definitions have the correct
`w=...u l=...u` units.  Netgen reports every cell device class as equivalent,
but the top-level pin list remains ambiguous (many symmetric FINE/MID/COARSE
pins) and the `dfxtp_2` reference contains 8 `special_nfet_01v8` tap devices
that the extracted layout does not classify; final result is still
`Netlists do not match`.  This is a reference-cell-view / top-pin-matching
issue, not a macro routing/PDN issue.  DRC remains 0.

A clean blackbox top-level LVS or a reference cell CDL with the special tap
devices normalized is still required before claiming LVS PASS.
