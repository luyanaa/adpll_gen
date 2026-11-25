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
    // In the real cell (PLL_ILDCO / PLL_RING_DCO_PHYS) more set bits switch in
    // MORE delay: the coarse tap-select folds the forward chain back through
    // more stages, and the mid/fine dangling-NAND cells gate-load the shared
    // node harder.  Measured (ics55 full-code scan): "increasing coarse/mid
    // creates more delay and lowers the frequency; increasing fine also
    // lowers the frequency".  So period grows with countones — the sign below
    // is BASE + STEP*countones, NOT a minus.  A minus here would flip the DCO
    // actuator against the freq_lock loop, which assumes code-up = slower.
    parameter real MIN_PERIOD_NS = 0.5,     // fastest ring, all codes 0
    parameter real COARSE_STEP_NS = 0.20,
    parameter real MID_STEP_NS = 0.020,
    parameter real FINE_STEP_NS = 0.0010
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
        period_ns = MIN_PERIOD_NS;
        code = 0;
    end
    assign MID_OUT = OUT;
    assign INJ_EDGE = REF;

    always @* begin
        code = $countones(COARSE_MUX) + $countones(MID_MUX) + $countones(FINE_MUX);
        period_ns = MIN_PERIOD_NS
                  + COARSE_STEP_NS * $countones(COARSE_MUX)
                  + MID_STEP_NS * $countones(MID_MUX)
                  + FINE_STEP_NS * $countones(FINE_MUX);
        if (period_ns < 0.2) period_ns = 0.2;
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
