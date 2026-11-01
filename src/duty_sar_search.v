`timescale 1ns/1ps
// Duty/phase SAR acquisition — coarse search that walks DLY_CODE to the
// neighbourhood of the target before the bang-bang loop takes over.
//
// Why: a bang-bang PD only returns a sign, and once the error is large it
// either saturates the sign or loses it entirely (the ADCC drove its code
// to the rail for exactly this reason).  The SAR does a binary search on
// the delay code using the PD sign as the comparison result, converging in
// log2(range) steps, then hands a near-lock seed to the fine loop.
//
// Sample the PD sign once per CODE at TICK; when the sign flips vs the
// previous step the boundary is bracketed.  On DONE, CTRL_CODE holds the
// seed and the top level enables the continuous bang-bang loop.
module duty_sar_search #(
    parameter integer CODE_BITS = 8,
    parameter integer SETTLE = 4      // TICKs to wait after each code step
) (
    input  TICK, RST_N, START,
    input  PD_SIGN,                   // 1 = "increase delay" (late), 0 = decrease
    output reg [CODE_BITS-1:0] CTRL_CODE,
    output reg BUSY, DONE
);
    reg [CODE_BITS-1:0] lo, hi, mid;
    reg [3:0] settle;
    reg prev_sign, have_prev;

    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            lo <= 0; hi <= {CODE_BITS{1'b1}}; mid <= {1'b0,{(CODE_BITS-1){1'b1}}};
            settle <= 0; prev_sign <= 0; have_prev <= 0;
            CTRL_CODE <= 0; BUSY <= 0; DONE <= 0;
        end else if (START && !BUSY && !DONE) begin
            lo <= 0; hi <= {CODE_BITS{1'b1}};
            mid <= ({CODE_BITS{1'b1}}) >> 1;
            CTRL_CODE <= ({CODE_BITS{1'b1}}) >> 1;
            settle <= 0; have_prev <= 0;
            BUSY <= 1; DONE <= 0;
        end else if (BUSY) begin
            if (settle < SETTLE[3:0]) begin
                settle <= settle + 1;
            end else begin
                // sample PD_SIGN at this code
                if (PD_SIGN) lo <= mid + 1; else hi <= mid - 1;
                prev_sign <= PD_SIGN; have_prev <= 1;
                if (lo >= hi || mid == 0) begin
                    // converged: seed the loop at the bracket midpoint
                    CTRL_CODE <= (lo + hi) >> 1;
                    BUSY <= 0; DONE <= 1;
                end else begin
                    mid <= (lo + hi) >> 1;
                    CTRL_CODE <= (lo + hi) >> 1;
                    settle <= 0;
                end
            end
        end
    end
endmodule
