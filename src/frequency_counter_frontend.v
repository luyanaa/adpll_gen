// Replaceable DCO frequency-counter frontend.
//
// This block deliberately keeps the counter topology separate from the
// acquisition FSM.  The default is a synchronous binary counter clocked by the
// DCO output.  The alternate modes are explicit experiments, not claims that
// an asynchronous counter is unconditionally safe.
`default_nettype none
`timescale 1ns/1ps

module frequency_counter_frontend #(
    parameter integer CNT_W = 16,
    // 0 = synchronous binary, 1 = asynchronous ripple, 2 = Johnson prescaler
    parameter integer MODE = 0,
    parameter integer PRESCALE = 1,
    parameter integer JOHNSON_STAGES = 4
) (
    input CLK,
    input RST_N,
    output [CNT_W-1:0] COUNT,
    output [CNT_W-1:0] GRAY_COUNT,
    output CDC_SAFE
);
    localparam integer MODE_SYNC = 0;
    localparam integer MODE_RIPPLE = 1;
    localparam integer MODE_JOHNSON = 2;
    genvar i;

    generate
        if (MODE == MODE_SYNC) begin : sync_frontend
            localparam integer PS = (PRESCALE < 1) ? 1 : PRESCALE;
            reg [CNT_W-1:0] cnt;
            reg [CNT_W-1:0] ps;
            always @(posedge CLK or negedge RST_N) begin
                if (!RST_N) begin
                    cnt <= 'd0;
                    ps <= 'd0;
                end else if (ps == PS - 1) begin
                    ps <= 'd0;
                    cnt <= cnt + 1'b1;
                end else begin
                    ps <= ps + 1'b1;
                end
            end
            assign COUNT = cnt;
            assign GRAY_COUNT = (cnt >> 1) ^ cnt;
            assign CDC_SAFE = 1'b1;
        end else if (MODE == MODE_RIPPLE) begin : ripple_frontend
            // Asynchronous toggle chain.  The multi-bit COUNT/GRAY outputs are
            // not safe to sample directly across a clock domain; CDC_SAFE is
            // deliberately low so the caller must use a Gray/synchronizer or
            // a stable capture window.
            reg [CNT_W-1:0] cnt;
            integer i;
            always @(posedge CLK or negedge RST_N) begin
                if (!RST_N) cnt[0] <= 1'b0;
                else cnt[0] <= ~cnt[0];
            end
            for (i = 1; i < CNT_W; i = i + 1) begin : stages
                always @(posedge cnt[i-1] or negedge RST_N) begin
                    if (!RST_N) cnt[i] <= 1'b0;
                    else cnt[i] <= ~cnt[i];
                end
            end
            assign COUNT = cnt;
            assign GRAY_COUNT = (cnt >> 1) ^ cnt;
            assign CDC_SAFE = 1'b0;
        end else if (MODE == MODE_JOHNSON) begin : johnson_frontend
            // 4-stage Johnson prescaler (divide by 8) plus a synchronous
            // extension counter.  The phase decode is intentionally explicit:
            // do not assume the Johnson state is a binary code.
            localparam integer DIV = 2 * JOHNSON_STAGES;
            reg [JOHNSON_STAGES-1:0] john;
            reg [CNT_W-1:0] ext;
            reg [2:0] phase;
            wire terminal = john[JOHNSON_STAGES-1];
            always @(posedge CLK or negedge RST_N) begin
                if (!RST_N) begin
                    john <= {{(JOHNSON_STAGES-1){1'b0}}, 1'b1};
                    ext <= 'd0;
                end else begin
                    john <= {john[JOHNSON_STAGES-2:0], ~john[JOHNSON_STAGES-1]};
                    if (terminal) ext <= ext + 1'b1;
                end
            end
            always @* begin
                case (john)
                    4'b0001: phase = 3'd0;
                    4'b0011: phase = 3'd1;
                    4'b0111: phase = 3'd2;
                    4'b1111: phase = 3'd3;
                    4'b1110: phase = 3'd4;
                    4'b1100: phase = 3'd5;
                    4'b1000: phase = 3'd6;
                    4'b0000: phase = 3'd7;
                    default: phase = 3'd0;
                endcase
            end
            assign COUNT = ext * DIV + phase;
            assign GRAY_COUNT = (COUNT >> 1) ^ COUNT;
            // The Johnson decode is a multi-bit synchronous state, but the
            // extension counter and phase are sampled in the DCO domain.  It is
            // not a CDC-safe replacement without a stable capture protocol.
            assign CDC_SAFE = 1'b0;
        end else begin : unsupported_frontend
            assign COUNT = 'd0;
            assign GRAY_COUNT = 'd0;
            assign CDC_SAFE = 1'b0;
        end
    endgenerate
endmodule
`default_nettype wire
