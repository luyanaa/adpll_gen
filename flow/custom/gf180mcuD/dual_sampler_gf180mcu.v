// DUAL_SAMPLER — matched data/edge sampler pair,
// gf180mcu_fd_sc_mcu9t5v0 (gf180mcuD only).
//
// The CDR's Alexander bang-bang PD needs two samples of the same DATA:
//   data phase -> posedge CK   (eye centre)
//   edge phase -> negedge CK   (transition boundary, ~0.5 UI later)
// A matched posedge/negedge FF pair gives the two samples on standard
// cells; both FFs are the same drive strength so the aperture skew is
// the residual to characterise.
//
//   D --> [dffq  posedge on CLK]   --> Q_POS   (data sample)
//   D --> [dffnq negedge on CLKN]  --> Q_NEG   (edge sample)
module DUAL_SAMPLER (
`ifdef WITH_POWER
    inout VDD, VSS, VPW, VNW,
`endif
    input  D,        // serial data to sample
    input  CK,       // recovered clock
    input  RST_B,    // async reset, active low (unused by these FFs)
    output Q_POS,    // data-phase sample (posedge CK)
    output Q_NEG     // edge-phase sample (negedge CK)
);
    gf180mcu_fd_sc_mcu9t5v0__dffq_1  u_pos (.D(D), .CLK(CK),  .Q(Q_POS)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS),.VPW(VPW),.VNW(VNW)`endif);
    gf180mcu_fd_sc_mcu9t5v0__dffnq_1 u_neg (.D(D), .CLKN(CK), .Q(Q_NEG)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS),.VPW(VPW),.VNW(VNW)`endif);
endmodule
