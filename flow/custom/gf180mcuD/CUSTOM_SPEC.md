# gf180mcu_fd_sc_mcu9t5v0 (gf180mcuD) custom/analog cells

Three matched cells for the ADPLL timing macros (DCDL delay line, TDC
arbiter, CDR dual sampler).  Each instantiates **named gf180mcu cells
only** — verified to elaborate against `gf180mcu_fd_sc_mcu9t5v0.v` with
power pins connected (`-DWITH_POWER`).  gf180mcuD variant only.

## DLY_STAGE (`dly_stage_gf180mcu.v`)

One delay-line tap.  `buf_1` fast leg vs `dlya_4` slow leg; `mux2_1`
(`I0`/`I1`/`S`/`Z`) picks `B_IN` (chain) vs slow on `SEL`; `buf_1` output
buffer equalises load.  Tap step = `dlya_4`−`buf_1` — a designed LSB.

*Matching:* same stage count + output buffer both legs; only the delay
element differs.  `dly*` is the library's matched delay family.
Common-centroid layout + calibration still needed for a fine LSB.

## ARB_CELL (`arbiter_gf180mcu.v`)

`latrnq_1` transparent latch (resolves D/CK while `E` high, `RN` reset)
→ `dffrnq_1` decision FF (`RN` reset).  Latch+FF arbiter rationale as
sky130 — regeneration settles before quantisation, narrower band.

## DUAL_SAMPLER (`dual_sampler_gf180mcu.v`)

Matched `dffq_1` (posedge, `CLK`, data phase) + `dffnq_1` (negedge,
`CLKN`, edge phase ~0.5 UI) pair for the Alexander PD.  `dffnq` is a
native negedge FF — no clock inverter needed (unlike ihp).  Residual:
aperture skew between the two FF edges under PVT.  These FFs have no
reset pin, so `RST_B` is documented-unused.

## Interface

All cells expose `VDD`/`VSS`/`VPW`/`VNW` when compiled `-DWITH_POWER`
(gf180mcu uses VPW/VNW well taps in addition to VDD/VSS).
