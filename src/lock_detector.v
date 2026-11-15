// Fine-stage lock detector for the SS-BBPD-based ADPLL.
//
// The SS-BBPD is a bang-bang detector, not a linear phase-error source.
// SS_BBPD is {OUT, REF}.  Default polarity (pll_digital_loop_filter, the
// branch that is not WITH_REF_TRIG_OUT):
//   2'b00  no correction     REF=0, OUT=0
//   2'b01  positive symbol   REF=1, OUT=0
//   2'b11  negative symbol   REF=1, OUT=1
//   2'b10  is not a correction in that filter.  It is the positive symbol
//   under WITH_REF_TRIG_OUT, so a build that defines that macro has to
//   override SYMBOL_P_CODE / SYMBOL_N_CODE / NO_SYMBOL_CODE together.
//
// A stuck detector can sit on the quiet code forever, so a run of quiet
// samples is not enough.  Phase lock also requires both correction symbols
// to have been seen inside the qualifying window: the loop must have been
// steered from both sides before the quiet run counts.
//
// This is a lock indication, not a jitter/phase-noise measurement.  A real
// phase-noise characterization still needs the DCO/loop model.
`timescale 1fs/1fs

module pll_lock_detector #(
    parameter integer LOCK_COUNT = 16,
    parameter integer LOSS_COUNT = 4,
    parameter [1:0] NO_SYMBOL_CODE = 2'b00,
    parameter [1:0] SYMBOL_P_CODE = 2'b01,
    parameter [1:0] SYMBOL_N_CODE = 2'b11
) (
    input  wire       CLK,        // INJ_EDGE domain
    input  wire       RST_N,
    input  wire       ENABLE,
    input  wire [1:0] SS_BBPD,
    input  wire       ILL_P,
    input  wire       ILL_N,
    output reg        PHASE_LOCK,
    output reg        LOCK_LOST
);
    // The counter has to be able to hold the limit.  $clog2(N) is one
    // bit short when N is a power of two, and the increment then wraps
    // before the compare can succeed.
    localparam integer LOCK_W = (LOCK_COUNT < 2) ? 1 : $clog2(LOCK_COUNT + 1);
    localparam integer LOSS_W = (LOSS_COUNT < 2) ? 1 : $clog2(LOSS_COUNT + 1);

    reg [LOCK_W-1:0] good_count;
    reg [LOSS_W-1:0] bad_count;
    reg seen_p;
    reg seen_n;
    wire no_symbol = (SS_BBPD == NO_SYMBOL_CODE) && !ILL_P && !ILL_N;
    wire symbol_p = (SS_BBPD == SYMBOL_P_CODE) && !ILL_P && !ILL_N;
    wire symbol_n = (SS_BBPD == SYMBOL_N_CODE) && !ILL_P && !ILL_N;
    // Explicit extra bit so a full count does not wrap inside the compare.
    wire [LOCK_W:0] good_inc = {1'b0, good_count} + 1'b1;
    wire [LOSS_W:0] bad_inc = {1'b0, bad_count} + 1'b1;

    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            good_count <= 'd0;
            bad_count  <= 'd0;
            seen_p <= 1'b0;
            seen_n <= 1'b0;
            PHASE_LOCK <= 1'b0;
            LOCK_LOST  <= 1'b0;
        end else if (!ENABLE) begin
            good_count <= 'd0;
            bad_count  <= 'd0;
            seen_p <= 1'b0;
            seen_n <= 1'b0;
            PHASE_LOCK <= 1'b0;
            LOCK_LOST  <= 1'b0;
        end else if (no_symbol) begin
            bad_count <= 'd0;
            if (good_inc < LOCK_COUNT)
                good_count <= good_inc[LOCK_W-1:0];
            // Both sides of the detector must have spoken before a quiet
            // run can declare lock.  A stuck no-symbol code never sets
            // seen_p/seen_n, so it cannot lock.
            if ((good_inc >= LOCK_COUNT) && seen_p && seen_n) begin
                PHASE_LOCK <= 1'b1;
                LOCK_LOST  <= 1'b0;
            end
        end else begin
            // A symbol that is also the one that drops lock must not
            // be kept as proof for the next quiet run.  The clear below
            // wins over the set in the same cycle.
            if (symbol_p) seen_p <= 1'b1;
            if (symbol_n) seen_n <= 1'b1;
            good_count <= 'd0;
            if (PHASE_LOCK) begin
                if (bad_inc >= LOSS_COUNT) begin
                    PHASE_LOCK <= 1'b0;
                    LOCK_LOST  <= 1'b1;
                    bad_count  <= 'd0;
                    // A real unlock has to re-prove both sides.
                    seen_p <= 1'b0;
                    seen_n <= 1'b0;
                end else begin
                    bad_count <= bad_count + 1'b1;
                end
            end else begin
                bad_count <= 'd0;
            end
        end
    end
endmodule
