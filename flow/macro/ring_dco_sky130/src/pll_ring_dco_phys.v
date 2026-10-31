// Physical Core B ring DCO.
//
// This is the synthesizable/transistor-level ring path: a fixed inverter bank
// plus the existing coarse/mid/fine delay elements and the symmetric output
// stage.  Injection is disabled; REF is used only by the SS-BBPD.  The ring is
// a hard-macro candidate and must be characterized for its actual PVT range.
`timescale 1ns/1ps

module PLL_RING_DCO_PHYS #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer BASE_NDELS = 256
) (
`ifdef WITH_POWER
    inout VDD, VSS,
`endif
    input [COARSE_NDELS-1:0] COARSE_MUX,
    input [MID_NDELS-1:0] MID_MUX,
    input [FINE_NDELS-1:0] FINE_MUX,
    input DCO_EN, REF, INJ_EN,
    output [1:0] SS_BBPD,
    output OUT,
    output MID_OUT,
    output INJ_EDGE
);
    // No injection path in the ring variant.  REF remains the phase-detector
    // reference; the output clock is free-running and controlled by the codes.
    PLL_ILDCO #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .BASE_NDELS(BASE_NDELS)
    ) ring (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .COARSE_MUX(COARSE_MUX),
        .MID_MUX(MID_MUX),
        .FINE_MUX(FINE_MUX),
        .INJ_EDGE(REF), .INJ_WIN(1'b0), .DCO_EN(DCO_EN),
        .SS_BBPD(SS_BBPD),
        .OUT(OUT), .MID_OUT(MID_OUT)
    );
    assign INJ_EDGE = REF;
endmodule
