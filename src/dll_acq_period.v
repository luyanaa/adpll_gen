// ACQ period capture, blackboxed for Yosys/ABC so the sampler pipeline is
// never constant-folded.  Icarus uses this RTL body in gate-level/SDF runs.
module DLL_ACQ_PERIOD (
    input  wire         REF,
    input  wire         RST_N,
    input  wire [319:0] ACQ_THERM,
    input  wire [4:0]   ACQ_DLY,
    output wire [15:0]  PERIOD,
    output wire [4:0]   DBG_DLY,
    output wire [8:0]   DBG_FIRST,
    output wire [15:0]  DBG_PERIOD
);
    reg [319:0] th0, first;
    reg [15:0]  period_r;

    function [8:0] count_ones;
        input [319:0] t;
        integer i;
        begin
            count_ones = 0;
            for (i = 0; i < 320; i = i + 1)
                count_ones = count_ones + t[i];
        end
    endfunction

    always @(posedge REF) begin
        if (!RST_N) begin
            th0      <= {320{1'b0}};
            first    <= {320{1'b0}};
            period_r <= 16'd0;
        end else begin
            // Two-stage pipeline: the TDC sampler Q is valid at ACQ_DLY[1],
            // th0 at [2], first at [3].  Latching on [3] captures the first
            // REF sample after the ACQ edge (~1T, 148 taps at TT).
            th0   <= ACQ_THERM;
            first <= th0;
            if (ACQ_DLY[3])
                period_r <= {7'b0, count_ones(first)};
        end
    end
    assign PERIOD = period_r;
    assign DBG_DLY = ACQ_DLY;
    assign DBG_FIRST = count_ones(first);
    assign DBG_PERIOD = period_r;
endmodule
