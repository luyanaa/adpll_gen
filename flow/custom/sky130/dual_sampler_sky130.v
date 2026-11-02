// DUAL_SAMPLER — matched data/edge sampler pair, sky130_fd_sc_hd.
//
// The CDR's Alexander bang-bang PD needs two samples of the same DATA:
//   data phase -> posedge CK   (eye centre)
//   edge phase -> negedge CK   (transition boundary, ~0.5 UI later)
// A matched posedge/negedge FF pair gives the two samples on standard
// cells; both FFs are the same cell family / drive strength so their
// aperture skew is the residual to characterise.
//
//   D --> [dfrtp posedge] --> Q_POS   (data sample)
//   D --> [dfrtn negedge] --> Q_NEG   (edge sample)
module DUAL_SAMPLER (
`ifdef WITH_POWER
    inout VPWR, VGND,
`endif
    input  D,        // serial data to sample
    input  CK,       // recovered clock
    input  RST_B,    // async reset, active low
    output Q_POS,    // data-phase sample (posedge CK)
    output Q_NEG     // edge-phase sample (negedge CK)
);
    sky130_fd_sc_hd__dfrtp_1 u_pos (.D(D), .CLK(CK),   .RESET_B(RST_B), .Q(Q_POS)
        `ifdef WITH_POWER ,.VPWR(VPWR),.VGND(VGND),.VPB(VPWR),.VNB(VGND)`endif);
    sky130_fd_sc_hd__dfrtn_1 u_neg (.D(D), .CLK_N(CK), .RESET_B(RST_B), .Q(Q_NEG)
        `ifdef WITH_POWER ,.VPWR(VPWR),.VGND(VGND),.VPB(VPWR),.VNB(VGND)`endif);
endmodule
