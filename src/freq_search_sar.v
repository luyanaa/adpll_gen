// Optional SAR / binary-search frequency acquisition.
//
// This block is intentionally gated by a measured tuning-map proof.  A
// monotonic 16x16 map takes 8 comparison decisions, but that is not a
// guarantee of 8 REF cycles to lock: DCO settling, observation windows,
// retries and final phase acquisition still cost time.
`default_nettype none
`timescale 1ns/1ps

module freq_search_sar #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer CODE_BITS = 4,
    parameter integer OBS_BITS = 16,
    parameter integer TIMEOUT = 64
) (
    input REF,
    input RST_N,
    input START,
    input MONOTONIC_MAP_VALID,
    input OBS_VALID,
    input [OBS_BITS-1:0] OBS_COUNT,
    input [OBS_BITS-1:0] FCW,
    output reg [COARSE_NDELS-1:0] COARSE_MUX,
    output reg [MID_NDELS-1:0] MID_MUX,
    output reg BUSY,
    output reg DONE,
    output reg FALLBACK,
    output reg ERR
);
    localparam integer MAX_CODE = (1 << CODE_BITS) - 1;
    localparam [CODE_BITS-1:0] CODE_MAX = {CODE_BITS{1'b1}};
    localparam [CODE_BITS-1:0] CODE_MID = CODE_MAX >> 1;
    localparam integer PHASE_COARSE = 0;
    localparam integer PHASE_MID = 1;
    localparam integer PHASE_DONE = 2;
    localparam integer PHASE_FALLBACK = 3;
    localparam integer PHASE_ERR = 4;

    reg [1:0] phase;
    reg [CODE_BITS-1:0] coarse_lo, coarse_hi, coarse_code;
    reg [CODE_BITS-1:0] mid_lo, mid_hi, mid_code;
    reg [7:0] comparisons;
    reg [15:0] timeout_cnt;

    function automatic [COARSE_NDELS-1:0] thermo_c;
        input [CODE_BITS-1:0] code;
        integer i;
        begin
            thermo_c = 'd0;
            for (i = 0; i < COARSE_NDELS; i = i + 1)
                if (i < code) thermo_c[i] = 1'b1;
        end
    endfunction

    function automatic [MID_NDELS-1:0] thermo_m;
        input [CODE_BITS-1:0] code;
        integer i;
        begin
            thermo_m = 'd0;
            for (i = 0; i < MID_NDELS; i = i + 1)
                if (i < code) thermo_m[i] = 1'b1;
        end
    endfunction

    function automatic [CODE_BITS-1:0] midpoint;
        input [CODE_BITS-1:0] lo, hi;
        integer sum;
        begin
            sum = lo + hi;
            midpoint = sum >> 1;
        end
    endfunction

    task begin_mid;
        begin
            mid_lo = 'd0;
            mid_hi = CODE_MAX;
            mid_code = CODE_MID;
            phase = PHASE_MID;
        end
    endtask

    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            phase <= PHASE_COARSE;
            coarse_lo <= 'd0;
            coarse_hi <= CODE_MAX;
            coarse_code <= CODE_MID;
            mid_lo <= 'd0;
            mid_hi <= CODE_MAX;
            mid_code <= 'd0;
            comparisons <= 'd0;
            timeout_cnt <= 'd0;
            COARSE_MUX <= 'd0;
            MID_MUX <= 'd0;
            BUSY <= 1'b0;
            DONE <= 1'b0;
            FALLBACK <= 1'b0;
            ERR <= 1'b0;
        end else if (!START && !BUSY && !DONE && !FALLBACK && !ERR) begin
            // Idle: hold outputs, release any previous search result.
            COARSE_MUX <= 'd0;
            MID_MUX <= 'd0;
        end else if (START && !BUSY && !DONE && !FALLBACK && !ERR) begin
            if (!MONOTONIC_MAP_VALID) begin
                FALLBACK <= 1'b1;
                BUSY <= 1'b0;
            end else begin
                BUSY <= 1'b1;
                phase <= PHASE_COARSE;
                coarse_lo <= 'd0;
                coarse_hi <= CODE_MAX;
                coarse_code <= CODE_MID;
                mid_lo <= 'd0;
                mid_hi <= CODE_MAX;
                mid_code <= 'd0;
                comparisons <= 'd0;
                timeout_cnt <= 'd0;
                COARSE_MUX <= thermo_c(CODE_MID);
                MID_MUX <= 'd0;
            end
        end else if (BUSY) begin
            timeout_cnt <= timeout_cnt + 1'b1;
            if (timeout_cnt >= TIMEOUT) begin
                BUSY <= 1'b0;
                ERR <= 1'b1;
            end else if (OBS_VALID) begin
                timeout_cnt <= 'd0;
                comparisons <= comparisons + 1'b1;
                case (phase)
                    PHASE_COARSE: begin
                        if (OBS_COUNT == FCW) begin
                            begin_mid();
                        end else if (OBS_COUNT > FCW) begin
                            // Too fast: add delay, search higher codes.
                            if (coarse_code >= coarse_hi) begin
                                begin_mid();
                            end else begin
                                coarse_lo <= coarse_code + 1'b1;
                                coarse_code <= midpoint(coarse_code + 1'b1, coarse_hi);
                                COARSE_MUX <= thermo_c(midpoint(coarse_code + 1'b1, coarse_hi));
                            end
                        end else begin
                            // Too slow: reduce delay, search lower codes.
                            if (coarse_code == 0) begin
                                begin_mid();
                            end else begin
                                coarse_hi <= coarse_code - 1'b1;
                                coarse_code <= midpoint(coarse_lo, coarse_code - 1'b1);
                                COARSE_MUX <= thermo_c(midpoint(coarse_lo, coarse_code - 1'b1));
                            end
                        end
                    end
                    PHASE_MID: begin
                        if (OBS_COUNT == FCW) begin
                            phase <= PHASE_DONE;
                            BUSY <= 1'b0;
                            DONE <= 1'b1;
                        end else if (OBS_COUNT > FCW) begin
                            if (mid_code >= mid_hi) begin
                                phase <= PHASE_DONE;
                                BUSY <= 1'b0;
                                DONE <= 1'b1;
                            end else begin
                                mid_lo <= mid_code + 1'b1;
                                mid_code <= midpoint(mid_code + 1'b1, mid_hi);
                                MID_MUX <= thermo_m(midpoint(mid_code + 1'b1, mid_hi));
                            end
                        end else begin
                            if (mid_code == 0) begin
                                phase <= PHASE_DONE;
                                BUSY <= 1'b0;
                                DONE <= 1'b1;
                            end else begin
                                mid_hi <= mid_code - 1'b1;
                                mid_code <= midpoint(mid_lo, mid_code - 1'b1);
                                MID_MUX <= thermo_m(midpoint(mid_lo, mid_code - 1'b1));
                            end
                        end
                    end
                    default: begin
                        BUSY <= 1'b0;
                        DONE <= 1'b1;
                    end
                endcase
            end
        end
    end
endmodule
`default_nettype wire
