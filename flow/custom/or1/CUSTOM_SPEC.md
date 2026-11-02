# or1_fd_sc custom/analog cells (OR1 / OpenRule1um, 5.0V)

Three matched cells for the ADPLL timing macros (DCDL delay line, TDC
arbiter, CDR dual sampler).  Each is a thin wrapper that instantiates
**named or1_fd_sc stdcells only** — verified to elaborate against
`or1_fd_sc.v`.

**SCL constraint:** `or1_fd_sc` is a minimal standard-cell library —
only `INVX1`, `BUFX2`, `CLKBUFX2`, `NAND2X1`, `NOR2X1`, `DFFPOSX1`,
`DFFRX1/2`, `TIEHI`, `TIELO`.  **No** dedicated delay cell, no mux2, no
transparent latch, no negedge FF.  Each cell is therefore rebuilt from
the available primitives rather than wrapped around a purpose-built
cell, so the "matched" claims are weaker than on sky130/ihp/gf180mcuD —
matching comes from identical cell + fanout, not delay-tuned devices.

## DLY_STAGE (`dly_stage_or1.v`)

One tap of a custom delay line.  `IN` drives a **fast leg**
(`INVX1`×2) and a **slow leg** (`INVX1`×4, fast leg + one extra matched
inverter pair = the designed LSB).  A three-NAND 2:1 mux picks `B_IN`
(chain input, `SEL`=0) or the slow leg (`SEL`=1):
`X = NAND(~(SEL&slow), ~(~SEL&B_IN)) = (SEL&slow)|(~SEL&B_IN)`.

*Matching strategy:* both legs non-inverting, single drive strength, same
fanout — the LSB is one matched `INVX1` pair's insertion delay.  No
delay-tuned cell exists, so the step is whatever 2×INVX1 gives at TT;
true matching needs a sized bank + layout.

## ARB_CELL (`arbiter_or1.v`)

Sub-LSB metastability arbiter.  `or1_fd_sc` has no transparent latch, so
the sky130 `dlxtp` resolver is rebuilt as a **NAND-gated SR latch**:
`NAND(CK,D)`/`NAND(CK,~D)` drive a cross-coupled NAND pair — transparent
while `CK` is high, holds while low, regenerates on a D/CK race.  The
decision FF is `DFFRX1` (posedge, active-HIGH reset); `RST_B` is
inverted once to drive it.

*Why:* the cross-coupled pair is the closest stdcell analogue of a
latch's regeneration — it snaps the metastable midpoint to a rail before
the FF quantises.  Sub-aperture resolution still wants a sized
comparator (true analog).

## DUAL_SAMPLER (`dual_sampler_or1.v`)

Matched `DFFRX1` pair for the Alexander PD: posedge `CK` (data phase) +
`DFFRX1` on a local `INVX1`-inverted clock (edge phase, ~negedge — same
trick as ihp, which also lacks a negedge cell).  `RST_B` is inverted
once and shared.  Residual: inverter + aperture skew under PVT.

## Interface

Cells expose `VDD`/`VSS` only under `WITH_POWER`, matching the physical
harness; the OR1 verilog models carry no power ports (the flow injects
them), so the ifdef keeps the cells usable in functional synthesis.
