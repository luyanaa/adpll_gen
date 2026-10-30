// Behavioral Core B ring-DCO model.
//
// This is a simulation/architecture model, not a hardened analog macro.  It
// exposes the same control/observability interface as PLL_ANALOG so the
// generator can select Core B and run a closed-loop RTL smoke before a real
// ring macro exists.  The delay model is intentionally parameterized; replace
// it with measured ring delay/PVT data for signoff.
`timescale 1ns/1ps

module PLL_RING_DCO #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter real BASE_PERIOD_NS = 50.0,   // 20 MHz at code 0
    parameter real COARSE_STEP_NS = 2.50,
    parameter real MID_STEP_NS = 0.20,
    parameter real FINE_STEP_NS = 0.010
) (
    input [COARSE_NDELS-1:0] COARSE_MUX,
    input [MID_NDELS-1:0] MID_MUX,
    input [FINE_NDELS-1:0] FINE_MUX,
    input DCO_EN, REF, INJ_EN,
    output [1:0] SS_BBPD,
    output reg OUT,
    output MID_OUT,
    output INJ_EDGE
);
    integer code;
    real period_ns;

    initial begin
        OUT = 1'b0;
        period_ns = BASE_PERIOD_NS;
        code = 0;
    end
    assign MID_OUT = OUT;
    assign INJ_EDGE = REF;

    always @* begin
        code = $countones(COARSE_MUX) + $countones(MID_MUX) + $countones(FINE_MUX);
        period_ns = BASE_PERIOD_NS
                  - COARSE_STEP_NS * $countones(COARSE_MUX)
                  - MID_STEP_NS * $countones(MID_MUX)
                  - FINE_STEP_NS * $countones(FINE_MUX);
        if (period_ns < 3.0) period_ns = 3.0;
    end

    initial begin
        #0.001;
        forever begin
            #(period_ns / 2.0);
            if (DCO_EN)
                OUT = ~OUT;
        end
    end

    sim_SSBBPD bbpd(.CLK_VCO(OUT), .CLK_REF(REF), .SS_BBPD(SS_BBPD));
endmodule
