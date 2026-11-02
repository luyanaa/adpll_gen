// ARB_CELL — sub-LSB metastability arbiter, or1_fd_sc (OpenRule1um).
//
// or1_fd_sc has no transparent-latch cell, so the sky130 `dlxtp` front
// resolver is rebuilt as a NAND-gated SR latch — the stdcell closest to
// a latch's "hold the race result while the gate is open" behaviour.
//
//   D,NCK -> set_n = NAND(CK, D)   --+
//                                  |  cross-coupled NAND pair:
//   ~D,CK -> rst_n = NAND(CK,~D)  --+  resolved = NAND(set_n, qb)
//                                     qb       = NAND(rst_n, resolved)
//   resolved --> [DFFRX1 decision FF, posedge CK, async reset] --> Q
//
// While CK is high the two input NANDs drive the latch toward D (or ~D);
// when D and CK race, the cross-coupled pair sits at the metastable
// midpoint and regenerates to a rail — the same regeneration a
// transparent latch provides.  While CK is low both set_n/rst_n
// deassert and the latch holds — transparent-latch semantics from four
// NANDs.  The decision FF is DFFRX1 (posedge-CLK, active-HIGH async
// reset), so RST_B is inverted once to drive it.
module ARB_CELL (
`ifdef WITH_POWER
    inout VDD, VSS,
`endif
    input  D,       // signal edge to compare
    input  CK,      // reference edge (clock)
    input  RST_B,   // async reset, active low
    output Q        // 1 if D arrived before CK (D was high when CK rose)
);
    wire db, set_n, rst_n, resolved, qb, rst;
    INVX1   u_db  (.A(D),      .Y(db)    `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    // gated set/reset — transparent while CK is high.
    NAND2X1 u_set (.A(CK),     .B(D),    .Y(set_n) `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    NAND2X1 u_rst (.A(CK),     .B(db),   .Y(rst_n) `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    // cross-coupled regenerative pair (the resolver latch).
    NAND2X1 u_q   (.A(set_n),  .B(qb),   .Y(resolved) `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    NAND2X1 u_qb  (.A(resolved),.B(rst_n),.Y(qb)       `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    // decision FF: quantises the resolved level on the clock edge.
    // DFFRX1 clears on RESET high -> invert the active-low RST_B once.
    INVX1   u_ri  (.A(RST_B),  .Y(rst)   `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    DFFRX1  u_dec (.D(resolved), .CLK(CK), .RESET(rst), .Q(Q)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
endmodule
