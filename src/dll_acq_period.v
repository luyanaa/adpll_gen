// ACQ period capture, blackboxed for Yosys/ABC so the sampler pipeline is
// never constant-folded.  Icarus uses this RTL body in gate-level/SDF runs.
(* blackbox *)
module DLL_ACQ_PERIOD (
    input  wire         REF,
    input  wire         RST_N,
    input  wire [319:0] ACQ_THERM,
    input  wire [4:0]   ACQ_DLY,
    output wire [15:0]  PERIOD
);
    reg [319:0] th0, th1, first;
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
            th1      <= {320{1'b0}};
            first    <= {320{1'b0}};
            period_r <= 16'd0;
        end else begin
            th0   <= ACQ_THERM;
            th1   <= th0;
            first <= th1;
            if (ACQ_DLY[3])
                period_r <= {7'b0, count_ones(first)};
        end
    end
    assign PERIOD = period_r;
endmodule
