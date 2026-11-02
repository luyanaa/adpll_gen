// ARB_CELL — sub-LSB metastability arbiter, sg13g2_stdcell.
//
// A bare DFF resolving "did D beat CK" has a razor-edge aperture and
// poor resolution bandwidth.  The arbiter adds a resolving front stage
// (a transparent latch) so the metastable interval regenerates in the
// latch before the decision FF quantises it — better MTBF and a narrower
// indeterminate band than a single DFF.
//
//   D --> [dlhrq transparent latch, GATE = CK] --> [dfrbpq FF] --> Q
//
// dlhrq_1: transparent-high D latch with reset (.D,.GATE,.RESET_B,.Q).
// dfrbpq_1: posedge DFF with reset    (.D,.CLK,.RESET_B,.Q).
module ARB_CELL (
    input  D,       // signal edge to compare
    input  CK,      // reference edge (clock)
    input  RST_B,   // async reset, active low
    output Q        // 1 if D arrived before CK
);
    wire resolved;
    sg13g2_dlhrq_1  u_res (.D(D),       .GATE(CK), .RESET_B(RST_B), .Q(resolved));
    sg13g2_dfrbpq_1 u_dec (.D(resolved), .CLK(CK),  .RESET_B(RST_B), .Q(Q));
endmodule
