// CUSTOM_CELLS_TOP — landing harness for the three custom/analog cells
// (gf180mcuD / gf180mcu_fd_sc_mcu9t5v0).  Power pins under WITH_POWER.
module CUSTOM_CELLS_TOP (
`ifdef WITH_POWER
    inout VDD, VSS, VPW, VNW,
`endif
    input  IN_A, input SEL, input REF, input SIG, input CK, input RST_B,
    output DLY_OUT, output ARB_OUT, output SAMP_POS, output SAMP_NEG
);
    DLY_STAGE    u_dly (.IN(IN_A), .B_IN(IN_A), .SEL(SEL), .X(DLY_OUT)
        `ifdef WITH_POWER , .VDD(VDD), .VSS(VSS), .VPW(VPW), .VNW(VNW)`endif);
    ARB_CELL     u_arb (.D(SIG), .CK(REF), .RST_B(RST_B), .Q(ARB_OUT)
        `ifdef WITH_POWER , .VDD(VDD), .VSS(VSS), .VPW(VPW), .VNW(VNW)`endif);
    DUAL_SAMPLER u_ds  (.D(SIG), .CK(CK), .RST_B(RST_B),
        .Q_POS(SAMP_POS), .Q_NEG(SAMP_NEG)
        `ifdef WITH_POWER , .VDD(VDD), .VSS(VSS), .VPW(VPW), .VNW(VNW)`endif);
endmodule
