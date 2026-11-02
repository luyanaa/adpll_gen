// Fine-stage lock detector for the SS-BBPD-based ADPLL.
//
// The SS-BBPD is a bang-bang detector, not a linear phase-error source.  The
// loop filter treats 2'b01 as "no phase-error symbol" in the default
// polarity; 2'b10 is the positive symbol and 2'b11 is the negative symbol.
// (The alternate WITH_REF_TRIG_OUT polarity changes this mapping.)  This
// detector therefore requires a run of no-symbol samples before declaring
// phase lock, and deasserts lock after a run of non-no-symbol samples or
// filter saturation.
//
// This is a lock indication, not a jitter/phase-noise measurement.  A real
// phase-noise characterization still needs the DCO/loop model.
`timescale 1fs/1fs

module pll_lock_detector #(
    parameter integer LOCK_COUNT = 16,
    parameter integer LOSS_COUNT = 4,
    parameter [1:0] NO_SYMBOL_CODE = 2'b01
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
    localparam integer LOCK_W = (LOCK_COUNT < 2) ? 1 : $clog2(LOCK_COUNT);
    localparam integer LOSS_W = (LOSS_COUNT < 2) ? 1 : $clog2(LOSS_COUNT);

    reg [LOCK_W-1:0] good_count;
    reg [LOSS_W-1:0] bad_count;
    wire no_symbol = (SS_BBPD == NO_SYMBOL_CODE) && !ILL_P && !ILL_N;

    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            good_count <= 'd0;
            bad_count  <= 'd0;
            PHASE_LOCK <= 1'b0;
            LOCK_LOST  <= 1'b0;
        end else if (!ENABLE) begin
            good_count <= 'd0;
            bad_count  <= 'd0;
            PHASE_LOCK <= 1'b0;
            LOCK_LOST  <= 1'b0;
        end else if (no_symbol) begin
            bad_count <= 'd0;
            if (good_count < LOCK_COUNT)
                good_count <= good_count + 1'b1;
            if (good_count + 1'b1 >= LOCK_COUNT) begin
                PHASE_LOCK <= 1'b1;
                LOCK_LOST  <= 1'b0;
            end
        end else begin
            good_count <= 'd0;
            if (PHASE_LOCK) begin
                if (bad_count + 1'b1 >= LOSS_COUNT) begin
                    PHASE_LOCK <= 1'b0;
                    LOCK_LOST  <= 1'b1;
                    bad_count  <= 'd0;
                end else begin
                    bad_count <= bad_count + 1'b1;
                end
            end else begin
                bad_count <= 'd0;
            end
        end
    end
endmodule
