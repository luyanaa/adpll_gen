// Behavioral Core C counter-DCO model.
//
// A 1 GHz simulation tick drives a phase accumulator; the control code sets
// the accumulator increment.  This is a model for the counter/NCO architecture
// and a closed-loop RTL smoke.  It is not a transistor-level oscillator and
// must not be used as a DCO/PVT signoff model.
`timescale 1ns/1ps

module PLL_COUNTER_DCO #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer TICK_PS = 1000,       // 1 GHz simulation tick
    parameter integer PHASE_MOD = 1000
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
    integer increment;
    integer phase;
    integer tick_ns;

    initial begin
        OUT = 1'b0;
        phase = 0;
        increment = 5;
        tick_ns = 1;
    end
    assign MID_OUT = OUT;
    assign INJ_EDGE = REF;

    always @* begin
        increment = 5 + 2 * $countones(COARSE_MUX)
                      + $countones(MID_MUX)
                      + ($countones(FINE_MUX) / 8);
        if (increment < 1) increment = 1;
        if (increment > PHASE_MOD / 2) increment = PHASE_MOD / 2;
        tick_ns = TICK_PS / 1000;
        if (tick_ns < 1) tick_ns = 1;
    end

    // Integer phase accumulator; OUT is the carry bit.
    initial begin
        #0.001;
        forever begin
            #(TICK_PS / 1000.0);
            if (DCO_EN) begin
                phase = phase + increment;
                if (phase >= PHASE_MOD) begin
                    phase = phase - PHASE_MOD;
                    OUT = ~OUT;
                end
            end
        end
    end

    sim_SSBBPD bbpd(.CLK_VCO(OUT), .CLK_REF(REF), .SS_BBPD(SS_BBPD));
endmodule
