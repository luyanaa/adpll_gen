// DUAL_SAMPLER — matched data/edge sampler pair, or1_fd_sc (OpenRule1um).
//
// The CDR's Alexander bang-bang PD needs two samples of the same DATA:
//   data phase -> posedge CK   (eye centre)
//   edge phase -> negedge CK   (transition boundary, ~0.5 UI later)
//
// or1_fd_sc has no negedge FF, so the edge-phase sampler is a DFFRX1
// clocked by a local INVX1 inverter — the same trick used on ihp-sg13g2
// (which also lacks a negedge cell).  Both FFs are the same cell so the
// aperture mismatch is the inverter delay + aperture skew — the
// residual to characterise.
//
//   D --> [DFFRX1, posedge CK]          --> Q_POS   (data sample)
//   D --> [INVX1 -> DFFRX1 posedge ckn] --> Q_NEG   (edge sample ~negedge)
//
// DFFRX1 clears on RESET high; RST_B (active low) is inverted once and
// shared by both FFs, matching the dfrtp/dfrtn semantics of the sky130
// version.
module DUAL_SAMPLER (
`ifdef WITH_POWER
    inout VDD, VSS,
`endif
    input  D,        // serial data to sample
    input  CK,       // recovered clock
    input  RST_B,    // async reset, active low
    output Q_POS,    // data-phase sample (posedge CK)
    output Q_NEG     // edge-phase sample (negedge CK, via inverted clock)
);
    wire ckn, rst;
    INVX1 u_cinv (.A(CK),    .Y(ckn) `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    INVX1 u_rinv (.A(RST_B), .Y(rst) `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    // data phase: posedge CK.
    DFFRX1 u_pos (.D(D), .CLK(CK),  .RESET(rst), .Q(Q_POS)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    // edge phase: posedge of the inverted clock = negedge CK.
    DFFRX1 u_neg (.D(D), .CLK(ckn), .RESET(rst), .Q(Q_NEG)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
endmodule
