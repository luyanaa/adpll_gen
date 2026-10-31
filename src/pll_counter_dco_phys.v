// Physical Core C counter DCO / NCO.
//
// This is a synthesizable phase accumulator, not a behavioral delay model.
// The DCO needs an externally supplied high-speed TICK.  There is no fixed
// 1 GHz assumption: the generator must bind tick_frequency_mhz.  The output
// clock toggles once per accumulator carry, so one output period is two
// carries and f_OUT = f_TICK * increment / 2^(ACC_BITS+1).  The control codes
// are unary thermometer codes from pll_logic.
`timescale 1ns/1ps

module PLL_COUNTER_DCO_PHYS #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer ACC_BITS = 16,
    parameter integer BASE_INC = 3493,
    parameter integer COARSE_STEP = 120,
    parameter integer MID_STEP = 60,
    parameter integer FINE_STEP = 15
) (
    input [COARSE_NDELS-1:0] COARSE_MUX,
    input [MID_NDELS-1:0] MID_MUX,
    input [FINE_NDELS-1:0] FINE_MUX,
    input TICK,
    input DCO_EN, REF, INJ_EN,
    output [1:0] SS_BBPD,
    output reg OUT,
    output MID_OUT,
    output INJ_EDGE
);
    reg [ACC_BITS-1:0] phase;
    reg [ACC_BITS:0] phase_sum;
    reg [ACC_BITS:0] increment;
    integer i;

    // Event semantics: one accumulator carry is one output toggle, not one
    // output period.  phase_overflow and output_edge are the same event here;
    // two carries are required for a complete OUT period.
    wire phase_overflow = phase_sum[ACC_BITS];
    wire output_edge = phase_overflow;

    assign MID_OUT = OUT;
    assign INJ_EDGE = REF;

    always @* begin
        // More unary delay bits means more delay and therefore a lower
        // output frequency, matching pll_logic's coarse/mid tuning direction.
        increment = BASE_INC;
        for (i = 0; i < COARSE_NDELS; i = i + 1)
            if (COARSE_MUX[i]) increment = increment - COARSE_STEP;
        for (i = 0; i < MID_NDELS; i = i + 1)
            if (MID_MUX[i]) increment = increment - MID_STEP;
        for (i = 0; i < FINE_NDELS; i = i + 1)
            if (FINE_MUX[i]) increment = increment - FINE_STEP;
        if (increment < 1)
            increment = 1;
        if (increment > (1 << ACC_BITS) / 2)
            increment = (1 << ACC_BITS) / 2;
        phase_sum = phase + increment;
    end

    always @(posedge TICK or negedge DCO_EN) begin
        if (!DCO_EN) begin
            phase <= 'd0;
            OUT <= 1'b0;
        end else begin
            phase <= phase_sum[ACC_BITS-1:0];
            if (output_edge)
                OUT <= ~OUT;
        end
    end

`ifdef SIMULATION
    sim_SSBBPD bbpd(.CLK_VCO(OUT), .CLK_REF(REF), .SS_BBPD(SS_BBPD));
`else
    PLL_SSBBPD bbpd(
        .INJ_EDGE_BALANCED(REF), .OSC_BALANCED(OUT), .SS_BBPD(SS_BBPD));
`endif
endmodule
