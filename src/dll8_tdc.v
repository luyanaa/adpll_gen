`timescale 1ps/1fs
// Coherent phase TDC for the 8-phase DLL.
//
// The free-running counter and BOTH edge captures live in the TICK domain, and
// the phase is computed there (bin - ref_cnt) at the tap edge.  That is what
// avoids the +-1 period association error a split REF-domain handshake has:
// ref_cnt always holds the REF edge that launched (or most recently preceded)
// the tap edge.
//
// phase is in TICK units:
//   8d = T + delta  (late)  -> phase ~= delta
//   8d = T - delta  (early) -> phase ~= period - delta
// so the caller compares against period/2 and signed-corrects.
module DLL8_TDC #(
    parameter integer BITS = 16
) (
    input  wire             TICK,
    input  wire             REF,
    input  wire             TAP,
    input  wire             MON,
    input  wire             RST_N,
    output reg  [BITS-1:0]  tap_phase,
    output reg  [BITS-1:0]  mon_phase,
    output reg  [BITS-1:0]  period
);
    reg [BITS-1:0] bin;
    reg [BITS-1:0] ref_cnt;

    reg rs1, rs2, rs3;
    reg ts1, ts2, ts3;
    reg ms1, ms2, ms3;

    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            bin <= {BITS{1'b0}};
            ref_cnt <= {BITS{1'b0}};
            rs1 <= 1'b0; rs2 <= 1'b0; rs3 <= 1'b0;
            ts1 <= 1'b0; ts2 <= 1'b0; ts3 <= 1'b0;
            ms1 <= 1'b0; ms2 <= 1'b0; ms3 <= 1'b0;
            tap_phase <= {BITS{1'b0}};
            mon_phase <= {BITS{1'b0}};
            period    <= {BITS{1'b0}};
        end else begin
            bin <= bin + 1'b1;

            // REF edge: latch the count and the previous period.
            rs1 <= REF; rs2 <= rs1; rs3 <= rs2;
            if (rs2 && !rs3) begin
                period  <= bin - ref_cnt;   // one REF period in TICK units
                ref_cnt <= bin;
            end

            // TAP edge: phase relative to the most recent REF.
            ts1 <= TAP; ts2 <= ts1; ts3 <= ts2;
            if (ts2 && !ts3) tap_phase <= bin - ref_cnt;

            // Monitor edge (selected tap for per-element measurement).
            ms1 <= MON; ms2 <= ms1; ms3 <= ms2;
            if (ms2 && !ms3) mon_phase <= bin - ref_cnt;
        end
    end
endmodule
