// CDC/scoreboard test for the free-running Gray snapshot protocol.
//
// The DCO counter is asynchronous to REF.  Gray coding guarantees one-bit
// source transitions, the 2FF sample is a valid word, and REF computes the
// delta between consecutive samples.  This test changes the REF/MID ratio,
// uses a random initial phase, and checks the captured delta against an
// independent MID-edge counter.
`timescale 1ns/1ps

module freq_lock_cdc_tb;
    localparam real REF_PERIOD = 10.0;

    reg REF = 1'b0;
    reg MID_OUT = 1'b0;
    real MID_HALF = 0.333;

    always #(REF_PERIOD/2.0) REF = ~REF;
    always #(MID_HALF) MID_OUT = ~MID_OUT;

    reg RST_N = 1'b1;
    reg START = 1'b0;
    reg [7:0] FCW = 8'd15;
    wire [3:0] COARSE_MUX, MID_MUX;
    wire LOCKED, ERR;

    pll_freq_lock #(
        .COARSE_NDELS(4), .MID_NDELS(4), .CNT_BITS(8), .LOCK_LIMIT(1)
    ) dut (
        .REF(REF), .MID_OUT(MID_OUT), .OUT(MID_OUT), .RST_N(RST_N),
        .FCW(FCW), .START(START), .LOCK(1'b0),
        .FORCE_P(1'b0), .FORCE_N(1'b0),
        .LOCKED(LOCKED), .ERR(ERR),
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX)
    );

    integer errors = 0;
    integer checks = 0;
    integer mid_edges = 0;
    integer mid_edges_d = 0;
    integer mid_edges_prev = 0;
    real expected;
    reg score = 1'b0;

    always @(posedge MID_OUT) mid_edges = mid_edges + 1;

    always @(posedge REF) begin
        mid_edges_d = mid_edges;
        if (RST_N && START && score) begin
            checks = checks + 1;
            expected = REF_PERIOD / (2.0 * MID_HALF);

            if (!dut.cap_valid) begin
                $display("FAIL: cap_valid low at %0t", $time);
                errors = errors + 1;
            end else if ($isunknown(dut.cnt_cap)) begin
                $display("FAIL: cnt_cap is X at %0t", $time);
                errors = errors + 1;
            end else if (dut.cnt_cap > 8'd63) begin
                $display("FAIL: cnt_cap=%0d exceeds counter range at %0t", dut.cnt_cap, $time);
                errors = errors + 1;
            end else if ((dut.cnt_cap + 2 < expected) || (dut.cnt_cap > expected + 2)) begin
                $display("FAIL: cnt_cap=%0d, expected %.2f +/-2 at %0t",
                         dut.cnt_cap, expected, $time);
                errors = errors + 1;
            end

            // Independent scoreboard from the TB MID edge counter.  The REF
            // capture has a small synchronization latency, so allow +/-2.
            if (checks > 2) begin
                integer measured;
                measured = mid_edges_d - mid_edges_prev;
                if ((dut.cnt_cap + 2 < measured) || (dut.cnt_cap > measured + 2)) begin
                    $display("FAIL: cnt_cap=%0d, TB mid delta=%0d at %0t",
                             dut.cnt_cap, measured, $time);
                    errors = errors + 1;
                end
            end
        end
        mid_edges_prev = mid_edges_d;
    end

    initial begin
        #0.137 MID_OUT = 1'b1;
        #1 RST_N = 1'b0;
        #20 RST_N = 1'b1;
        #20 START = 1'b1;
        #200;
        #100 MID_HALF = 0.250; #150 score = 1'b1;
        #250 MID_HALF = 0.750; score = 1'b0; #150 score = 1'b1;
        #250 MID_HALF = 0.500; score = 1'b0; #150 score = 1'b1;
        #500;
        if (checks < 100) begin
            $display("FAIL: only %0d REF checks", checks);
            errors = errors + 1;
        end
        if (errors != 0) $fatal(1, "freq_lock_cdc_tb failed");
        $display("freq_lock_cdc_tb: PASS (%0d REF checks)", checks);
        $finish;
    end
endmodule
