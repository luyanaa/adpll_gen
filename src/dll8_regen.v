`timescale 1ps/1ps
// 8-phase duty regeneration for the DLL taps.
//
// For phase k: Q_k is SET by the rising edge of TAP[k] and RESET by the
// rising edge of TAP[(k+4)%8].  With the line locked at 8d = T, TAP[k+4] rises
// exactly T/2 after TAP[k], so the high time is exactly T/2 -> 50.000% duty,
// and because both edges are rising edges the raw taps' tpHL/tpLH asymmetry
// cannot enter the duty.
//
// Implementation per phase (same cells, same load for all k): a DFF clocked by
// TAP[k] with D=1, asynchronously reset by a one-cycle pulse generated on the
// TAP[k+4] rising edge.  The pulse is detected against TICK_FAST (the TDC
// clock, 1024x REF), so no analogue delay is used.  PHASE is forced low while
// EN (LOCKED) is deasserted so acquisition glitches cannot reach the outputs.
`default_nettype none

module DLL8_REGEN #(
    parameter integer PHASES = 8
) (
    input  wire                  TICK_FAST,
    input  wire                  RST_N,
    input  wire                  EN,     // LOCKED
    input  wire [PHASES-1:0]     TAP,
    output wire [PHASES-1:0]     PHASE
);
    reg [PHASES-1:0] tap_d;
    always @(posedge TICK_FAST or negedge RST_N) begin
        if (!RST_N) tap_d <= {PHASES{1'b0}};
        else        tap_d <= TAP;
    end

    genvar k;
    generate
        for (k = 0; k < PHASES; k = k + 1) begin : ph
            wire       tk  = TAP[k];
            wire       tk4 = TAP[(k + (PHASES/2)) % PHASES];
            wire       dk4 = tap_d[(k + (PHASES/2)) % PHASES];
            // one-TICK_FAST-wide active-low reset pulse on tk4 rising
            wire       rst_n = ~(tk4 & ~dk4);
            reg        q;

            always @(posedge tk or negedge rst_n or negedge RST_N) begin
                if (!RST_N || !rst_n) q <= 1'b0;
                else                  q <= 1'b1;
            end
            assign PHASE[k] = EN ? q : 1'b0;
        end
    endgenerate
endmodule
`default_nettype wire
