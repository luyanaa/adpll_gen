// ARB_CELL — sub-LSB metastability arbiter, sky130_fd_sc_hd.
//
// A bare DFF asked to resolve "did D beat CK" has a single razor-edge:
// near the setup/hold boundary its output is metastable and its
// resolution bandwidth is poor.  A real arbiter adds a *resolving*
// front stage — a transparent latch — so the metastable window is
// settled by the latch's regeneration before the decision FF reads it.
//
//   D --+--> [dlxtp  transparent latch, GATE = CK]  --+
//       |        resolve while GATE high            |
//       +-----------> [dfrtp decision FF, posedge] -+--> Q
//
// The latch holds the pre-decision analog state long enough for
// regeneration; the dfrtp quantises the (now-resolved) level.  This is
// the stdcell realisation of a latch+FF arbiter — better MTBF and a
// narrower indeterminate band than a single DFF.  Resolution < the
// latch aperture still wants a custom sized comparator, but this is the
// best that standard cells provide.
module ARB_CELL (
`ifdef WITH_POWER
    inout VPWR, VGND,
`endif
    input  D,       // signal edge to compare
    input  CK,      // reference edge (clock)
    input  RST_B,   // async reset, active low
    output Q        // 1 if D arrived before CK (D was high when CK rose)
);
    wire resolved;
    // front resolver: transparent latch holds the D/CK race result while
    // the gate is open — the metastable interval is decided by the latch
    // regeneration, not by a bare FF aperture.
    sky130_fd_sc_hd__dlxtp_1 u_res (.D(D), .GATE(CK), .Q(resolved)
        `ifdef WITH_POWER ,.VPWR(VPWR),.VGND(VGND),.VPB(VPWR),.VNB(VGND)`endif);
    // decision FF: quantises the resolved level on the clock edge.
    sky130_fd_sc_hd__dfrtp_1 u_dec (.D(resolved), .CLK(CK), .RESET_B(RST_B), .Q(Q)
        `ifdef WITH_POWER ,.VPWR(VPWR),.VGND(VGND),.VPB(VPWR),.VNB(VGND)`endif);
endmodule
