// CUSTOM_CELLS_TOP — landing harness for the three custom/analog cells
// (ihp-sg13g2 / sg13g2_stdcell).  No power pins (IHP lib convention).
module CUSTOM_CELLS_TOP (
    input  IN_A, input SEL, input REF, input SIG, input CK, input RST_B,
    output DLY_OUT, output ARB_OUT, output SAMP_POS, output SAMP_NEG
);
    DLY_STAGE    u_dly (.IN(IN_A), .B_IN(IN_A), .SEL(SEL), .X(DLY_OUT));
    ARB_CELL     u_arb (.D(SIG), .CK(REF), .RST_B(RST_B), .Q(ARB_OUT));
    DUAL_SAMPLER u_ds  (.D(SIG), .CK(CK), .RST_B(RST_B),
                        .Q_POS(SAMP_POS), .Q_NEG(SAMP_NEG));
endmodule
