// CUSTOM_CELLS_TOP — landing harness for the three custom/analog cells
// (OR1 / OpenRule1um, or1_fd_sc).  Power pins under WITH_POWER.
module CUSTOM_CELLS_TOP (
`ifdef WITH_POWER
    inout VDD, VSS,
`endif
    input  IN_A, input SEL, input REF, input SIG, input CK, input RST_B,
    output DLY_OUT, output ARB_OUT, output SAMP_POS, output SAMP_NEG
);
    DLY_STAGE    u_dly (.IN(IN_A), .B_IN(IN_A), .SEL(SEL), .X(DLY_OUT)
        `ifdef WITH_POWER , .VDD(VDD), .VSS(VSS)`endif);
    ARB_CELL     u_arb (.D(SIG), .CK(REF), .RST_B(RST_B), .Q(ARB_OUT)
        `ifdef WITH_POWER , .VDD(VDD), .VSS(VSS)`endif);
    DUAL_SAMPLER u_ds  (.D(SIG), .CK(CK), .RST_B(RST_B),
        .Q_POS(SAMP_POS), .Q_NEG(SAMP_NEG)
        `ifdef WITH_POWER , .VDD(VDD), .VSS(VSS)`endif);
endmodule
