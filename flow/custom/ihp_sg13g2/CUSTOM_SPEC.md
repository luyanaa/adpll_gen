# sg13g2_stdcell (ihp-sg13g2) custom/analog cells

Three matched cells for the ADPLL timing macros (DCDL delay line, TDC
arbiter, CDR dual sampler).  Each instantiates **named sg13g2 cells
only** — verified to elaborate against `sg13g2_stdcell.v`.

## DLY_STAGE (`dly_stage_sg13g2.v`)

One delay-line tap.  `buf_1` fast leg vs `dlygate4sd3_1` slow leg;
`mux2_1` picks `B_IN` (chain) vs slow on `SEL`; `buf_1` output buffer
equalises load.  Tap step = `dlygate4sd3`−`buf_1` — a designed LSB.

*Matching:* same stage count and output buffer on both legs; only the
delay element differs.  `dlygate4sd*` is the library's native matched
delay gate — the right primitive.  Still needs common-centroid layout +
calibration for a true sub-100-ps LSB.

## ARB_CELL (`arbiter_sg13g2.v`)

`dlhrq_1` transparent latch (resolves D/CK while `GATE` high) →
`dfrbpq_1` decision FF.  Same latch+FF arbiter rationale as sky130 —
regeneration settles before quantisation, narrower indeterminate band
than a bare DFF.

## DUAL_SAMPLER (`dual_sampler_sg13g2.v`)

`sg13g2` has **no explicit negedge DFF**, so the edge-phase sampler is a
`dfrbpq_1` on an inverted clock (`inv_1` → `dfrbpq_1`): CK's falling
edge becomes ~CK's rising edge.  Data phase is a plain `dfrbpq_1`.
Same FF cell on both phases → residual is the inv_1 clock skew + FF
aperture under PVT.  A matched 0.5-UI pair would draw both clock legs
from a balanced clock tree.

## Interface

sg13g2 lib cells expose no explicit power pins in the .lib, so these
wrappers carry no power ports (matches the IHP OpenLane convention).
