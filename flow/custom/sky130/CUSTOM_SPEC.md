# sky130_fd_sc_hd custom/analog cells

Three matched cells for the ADPLL timing macros (DCDL delay line, TDC
arbiter, CDR dual sampler).  Each is a thin wrapper that instantiates
**named sky130 stdcells only** — verified to elaborate against
`sky130_fd_sc_hd.v` with all power pins connected (`-DWITH_POWER`).

## DLY_STAGE (`dly_stage_sky130.v`)

One tap of a custom delay line.  Two matched legs from `IN`:
`clkbuf_1` (fast) vs `clkdlybuf4s50_1` (slow); `mux2_1` picks between the
chain input `B_IN` and the slow leg on `SEL`; a `clkinv_1` output
inverter equalises load and restores phase.

*Matching strategy:* both legs traverse the same *number* of stages and
see the same output inverter; only the delay element differs.  The tap
step is the `clkdlybuf4s50`−`clkbuf_1` delay difference — a designed,
repeatable LSB rather than whatever the synthesiser infers.  A real
delay line chains `DLY_STAGE`s and thermometrically drives `SEL`.

*Still analog:* the LSB is a library-cell delay difference (~hundreds of
ps at TT), not a calibrated 15 ps; true matching needs common-centroid
layout + dummy fill and the offset drawn from a matched cell bank.

## ARB_CELL (`arbiter_sky130.v`)

Sub-LSB metastability arbiter: `dlxtp_1` transparent latch (resolves the
D/CK race while the gate is open) → `dfrtp_1` decision FF.

*Why:* a bare DFF has a razor-edge aperture; the latch holds the
pre-decision state so regeneration settles before the FF quantises —
narrower indeterminate band, better MTBF.  Stdcell realisation of a
latch+FF arbiter.  Sub-aperture resolution still wants a sized
comparator (true custom analog), but this is the best stdcells give.

## DUAL_SAMPLER (`dual_sampler_sky130.v`)

Matched `dfrtp_1` (posedge, data phase) + `dfrtn_1` (negedge, edge
phase ~0.5 UI) pair for the Alexander PD — the synthesised version of
the CDR's two samples, now as a named matched pair.  Residual: aperture
skew between the two FF edges under PVT.

## Interface

All cells expose `VPWR`/`VGND` when compiled `-DWITH_POWER` (the
physical macro); the ifdef keeps them usable in the functional flow.
