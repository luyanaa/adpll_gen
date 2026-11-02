// CUSTOM_CELLS_TOP — landing harness for the three custom/analog cells.
// Instantiates DLY_STAGE, ARB_CELL and DUAL_SAMPLER with real I/O so the
// PnR flow proves they place, route and map to named stdcells.
// This is the "落地" vehicle for the custom cell library.
module CUSTOM_CELLS_TOP (
    input  IN_A,      // delay-line signal in
    input  SEL,       // delay tap select
    input  REF,       // arbiter reference clock
    input  SIG,       // arbiter/sampler data
    input  CK,        // sampler clock
    input  RST_B,     // async reset
    output DLY_OUT,   // delay-stage output
    output ARB_OUT,   // arbiter verdict
    output SAMP_POS,  // data-phase sample
    output SAMP_NEG   // edge-phase sample
);
`ifdef WITH_POWER
    wire VPWR, VGND;
`endif
    // 1: matched delay-line tap
    DLY_STAGE u_dly (.IN(IN_A), .B_IN(IN_A), .SEL(SEL), .X(DLY_OUT)
        `ifdef WITH_POWER , .VPWR(VPWR), .VGND(VGND)`endif);
    // 2: sub-LSB arbiter
    ARB_CELL u_arb (.D(SIG), .CK(REF), .RST_B(RST_B), .Q(ARB_OUT)
        `ifdef WITH_POWER , .VPWR(VPWR), .VGND(VGND)`endif);
    // 3: matched dual sampler
    DUAL_SAMPLER u_ds (.D(SIG), .CK(CK), .RST_B(RST_B),
        .Q_POS(SAMP_POS), .Q_NEG(SAMP_NEG)
        `ifdef WITH_POWER , .VPWR(VPWR), .VGND(VGND)`endif);
endmodule
