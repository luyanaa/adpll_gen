// Fine-stage lock detector for the SS-BBPD-based ADPLL.
//
// Code contract at the sampling edge
// ---------------------------------
// The detector uses the same edge as pll_digital_loop_filter:
// posedge(!INJ_EDGE), i.e. negedge INJ_EDGE.  At that edge the NAND latch
// in ssbbpd.v is still in its transparent state, so its two buffered
// outputs encode the oscillator level:
//
//   {SS_BBPD[1],SS_BBPD[0]} = {OUT,REF}
//     2'b01  P: REF=1, OUT=0 (oscillator low at the sample)
//     2'b11  N: REF=1, OUT=1 (oscillator high at the sample)
//     2'b00  invalid: both NAND outputs low is not a stable state
//     2'b10  invalid at this edge: latch resolution outside the sampled phase
//
// 00 is never produced, and the only quiet-looking code, 10, is not a
// no-correction result.  A quiet-run lock criterion therefore waits for a
// state the detector cannot reach.  This block instead treats lock as a
// property of the P/N stream: a window of LOCK_COUNT valid samples must
// contain both signs.  A stuck-invalid, stuck P or stuck N source never
// qualifies.  A stream that completes a whole window with one sign only
// drops an existing lock.
//
// A build that defines WITH_REF_TRIG_OUT uses the alternate filter decode
// and must override SYMBOL_P_CODE / SYMBOL_N_CODE together (P=10, N=01).
//
// This is an activity/balance check, not a phase-noise or jitter
// measurement, and it cannot detect a detector that toggles P/N
// artificially.  A real phase-detector health check needs a dither or an
// independent monitor.
`timescale 1fs/1fs

module pll_lock_detector #(
    parameter integer LOCK_COUNT = 16,   // valid samples per qualification window
    parameter integer LOSS_COUNT = 4,    // consecutive invalid samples that drop lock
    parameter [1:0] SYMBOL_P_CODE = 2'b01,
    parameter [1:0] SYMBOL_N_CODE = 2'b11
) (
    input  wire       CLK,        // negedge INJ_EDGE
    input  wire       RST_N,
    input  wire       ENABLE,
    input  wire [1:0] SS_BBPD,
    input  wire       ILL_P,
    input  wire       ILL_N,
    output reg        PHASE_LOCK,
    output reg        LOCK_LOST
);
    // The counters have to hold the limit.  $clog2(N) is one bit short
    // when N is a power of two.
    localparam integer CNT_W = (LOCK_COUNT < 2) ? 1 : $clog2(LOCK_COUNT + 1);
    localparam integer BAD_W = (LOSS_COUNT < 2) ? 1 : $clog2(LOSS_COUNT + 1);

    reg [CNT_W-1:0] win_cnt;
    reg [BAD_W-1:0] bad_cnt;
    reg seen_p;
    reg seen_n;

    // Saturation is a filter-level failure, not a phase decision.
    wire symbol_p = (SS_BBPD == SYMBOL_P_CODE) && !ILL_P && !ILL_N;
    wire symbol_n = (SS_BBPD == SYMBOL_N_CODE) && !ILL_P && !ILL_N;
    wire valid = symbol_p || symbol_n;
    wire seen_p_n = seen_p | symbol_p;
    wire seen_n_n = seen_n | symbol_n;
    wire [CNT_W:0] win_inc = {1'b0, win_cnt} + 1'b1;
    wire [BAD_W:0] bad_inc = {1'b0, bad_cnt} + 1'b1;

    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            win_cnt <= 'd0;
            bad_cnt <= 'd0;
            seen_p <= 1'b0;
            seen_n <= 1'b0;
            PHASE_LOCK <= 1'b0;
            LOCK_LOST  <= 1'b0;
        end else if (!ENABLE) begin
            win_cnt <= 'd0;
            bad_cnt <= 'd0;
            seen_p <= 1'b0;
            seen_n <= 1'b0;
            PHASE_LOCK <= 1'b0;
            LOCK_LOST  <= 1'b0;
        end else if (!valid) begin
            // 00 or 10.  Restart the window; drop an existing lock only
            // after LOSS_COUNT consecutive invalid samples.
            win_cnt <= 'd0;
            seen_p <= 1'b0;
            seen_n <= 1'b0;
            if (bad_inc >= LOSS_COUNT) begin
                if (PHASE_LOCK)
                    LOCK_LOST <= 1'b1;
                PHASE_LOCK <= 1'b0;
                bad_cnt <= 'd0;
            end else begin
                bad_cnt <= bad_inc[BAD_W-1:0];
            end
        end else begin
            bad_cnt <= 'd0;
            if (win_inc >= LOCK_COUNT) begin
                // The current sample is the last one in the window.
                if (seen_p_n && seen_n_n) begin
                    PHASE_LOCK <= 1'b1;
                    LOCK_LOST  <= 1'b0;
                end else begin
                    if (PHASE_LOCK)
                        LOCK_LOST <= 1'b1;
                    PHASE_LOCK <= 1'b0;
                end
                win_cnt <= 'd0;
                seen_p <= 1'b0;
                seen_n <= 1'b0;
            end else begin
                win_cnt <= win_inc[CNT_W-1:0];
                seen_p <= seen_p_n;
                seen_n <= seen_n_n;
            end
        end
    end
endmodule
