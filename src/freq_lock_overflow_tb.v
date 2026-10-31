// Frequency-measurement range/window regression.
//
// MID_OUT is 300x REF.  With the old 8-bit counter this wraps (300 -> 44).
// The widened source counter and the four-period measurement window must
// report about 300 counts per REF and about 1200 counts per window.
`timescale 1ns/1ps

module freq_lock_overflow_tb;
    localparam real REF_PERIOD = 300.0;
    localparam real MID_HALF = 0.5;

    reg REF = 1'b0;
    reg MID_OUT = 1'b0;
    always #(REF_PERIOD/2.0) REF = ~REF;
    always #(MID_HALF) MID_OUT = ~MID_OUT;

    reg RST_N = 1'b0;
    reg START = 1'b0;
    reg [7:0] FCW = 8'd15;
    wire [3:0] COARSE_MUX, MID_MUX;
    wire LOCKED, ERR;
    wire SAMPLE_VALID;
    wire [17:0] MEASURED_COUNT;

    pll_freq_lock #(
        .COARSE_NDELS(4), .MID_NDELS(4), .CNT_BITS(8),
        .CNT_EXTRA_BITS(8), .MEAS_PERIODS(4), .LOCK_LIMIT(1)
    ) dut (
        .REF(REF), .MID_OUT(MID_OUT), .OUT(MID_OUT), .RST_N(RST_N),
        .FCW(FCW), .START(START), .LOCK(1'b0),
        .FORCE_P(1'b0), .FORCE_N(1'b0),
        .LOCKED(LOCKED), .ERR(ERR),
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX),
        .SAMPLE_VALID(SAMPLE_VALID), .MEASURED_COUNT(MEASURED_COUNT)
    );

    integer errors = 0;
    integer windows = 0;
    integer checks = 0;
    integer ref_edges = 0;

    always @(posedge REF) ref_edges = ref_edges + 1;

    always @(posedge SAMPLE_VALID) begin
        windows = windows + 1;
        if (checks > 0) begin
            if ((dut.cnt_cap + 4 < 300) || (dut.cnt_cap > 304)) begin
                $display("FAIL: cnt_cap=%0d, expected 300 +/-4 at %0t",
                         dut.cnt_cap, $time);
                errors = errors + 1;
            end
            if ((MEASURED_COUNT + 8 < 1200) || (MEASURED_COUNT > 1208)) begin
                $display("FAIL: MEASURED_COUNT=%0d, expected 1200 +/-8 at %0t",
                         MEASURED_COUNT, $time);
                errors = errors + 1;
            end
        end
        checks = checks + 1;
    end

    initial begin
        #130 RST_N = 1'b1;
        #20 START = 1'b1;
        #(REF_PERIOD * 40);
        if (windows < 4) begin
            $display("FAIL: only %0d measurement windows", windows);
            errors = errors + 1;
        end
        if (checks < 4) begin
            $display("FAIL: only %0d checked windows", checks);
            errors = errors + 1;
        end
        if (errors != 0) $fatal(1, "freq_lock_overflow_tb failed");
        $display("freq_lock_overflow_tb: PASS (%0d windows, cnt_cap=%0d, measured=%0d)",
                 windows, dut.cnt_cap, MEASURED_COUNT);
        $finish;
    end
endmodule
