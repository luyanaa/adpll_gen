// DUAL_SAMPLER — matched data/edge sampler pair, sg13g2_stdcell.
//
// The CDR's Alexander bang-bang PD needs two samples of the same DATA:
//   data phase -> posedge CK   (eye centre)
//   edge phase -> negedge CK   (transition boundary, ~0.5 UI later)
// sg13g2_stdcell has no explicit negedge DFF, so the edge-phase sampler
// is a posedge FF on an inverted copy of CK (inv_1 + dfrbpq): the
// falling edge of CK becomes the rising edge of ~CK.  Both phases use
// the same FF cell so the aperture skew is the residual to characterise.
//
//   D --> [dfrbpq posedge on CK]      --> Q_POS   (data sample)
//   D --> [inv_1 -> dfrbpq on ~CK]    --> Q_NEG   (edge sample)
module DUAL_SAMPLER (
    input  D,        // serial data to sample
    input  CK,       // recovered clock
    input  RST_B,    // async reset, active low
    output Q_POS,    // data-phase sample (posedge CK)
    output Q_NEG     // edge-phase sample (negedge CK via inverted clock)
);
    wire ck_n;
    sg13g2_inv_1 u_ckn (.A(CK), .Y(ck_n));
    sg13g2_dfrbpq_1 u_pos (.D(D), .CLK(CK),   .RESET_B(RST_B), .Q(Q_POS));
    sg13g2_dfrbpq_1 u_neg (.D(D), .CLK(ck_n), .RESET_B(RST_B), .Q(Q_NEG));
endmodule
