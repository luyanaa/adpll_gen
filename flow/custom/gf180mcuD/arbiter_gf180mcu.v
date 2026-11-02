// ARB_CELL — sub-LSB metastability arbiter,
// gf180mcu_fd_sc_mcu9t5v0 (gf180mcuD only).
//
// A bare DFF resolving "did D beat CK" has a razor-edge aperture and
// poor resolution bandwidth.  The arbiter adds a resolving front stage
// (a transparent latch) so the metastable interval regenerates in the
// latch before the decision FF quantises it — better MTBF and a narrower
// indeterminate band than a single DFF.
//
//   D --> [latrnq transparent latch, E = CK] --> [dffrnq FF] --> Q
//
// latrnq_1: D latch, enable E, active-low reset RN (.D,.E,.RN,.Q).
// dffrnq_1: posedge DFF, active-low reset RN      (.D,.CLK,.RN,.Q).
module ARB_CELL (
`ifdef WITH_POWER
    inout VDD, VSS, VPW, VNW,
`endif
    input  D,       // signal edge to compare
    input  CK,      // reference edge (clock)
    input  RST_B,   // async reset, active low
    output Q        // 1 if D arrived before CK
);
    wire resolved;
    gf180mcu_fd_sc_mcu9t5v0__latrnq_1 u_res (.D(D),       .E(CK),  .RN(RST_B), .Q(resolved)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS),.VPW(VPW),.VNW(VNW)`endif);
    gf180mcu_fd_sc_mcu9t5v0__dffrnq_1 u_dec (.D(resolved), .CLK(CK), .RN(RST_B), .Q(Q)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS),.VPW(VPW),.VNW(VNW)`endif);
endmodule
