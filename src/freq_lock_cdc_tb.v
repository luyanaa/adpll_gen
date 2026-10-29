// CDC smoke for the Gray snapshot/handshake in pll_freq_lock.
// REF and MID_OUT are independent clocks with a non-integer phase relationship.
`timescale 1ns/1ps

module freq_lock_cdc_tb;
    reg REF = 1'b0;
    reg MID_OUT = 1'b0;
    always #5 REF = ~REF;          // 100 MHz
    always #0.333 MID_OUT = ~MID_OUT; // ~1.5 GHz

    reg RST_N = 1'b1;
    reg START = 1'b0;
    reg [7:0] FCW = 8'd15;
    wire [3:0] COARSE_MUX, MID_MUX;
    wire LOCKED, ERR;

    pll_freq_lock #(
        .COARSE_NDELS(4),
        .MID_NDELS(4),
        .CNT_BITS(8),
        .LOCK_LIMIT(1)
    ) dut (
        .REF(REF), .MID_OUT(MID_OUT), .OUT(MID_OUT), .RST_N(RST_N),
        .FCW(FCW), .START(START), .LOCK(1'b0),
        .FORCE_P(1'b0), .FORCE_N(1'b0),
        .LOCKED(LOCKED), .ERR(ERR),
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX)
    );

    integer errors = 0;
    integer checks = 0;
    reg [7:0] last_cap = 0;
    reg armed = 1'b0;

    always @(posedge REF) begin
        if (RST_N && START && armed) begin
            checks = checks + 1;
            if ($isunknown(dut.cnt_cap)) begin
                $display("FAIL: cnt_cap is X at %0t", $time);
                errors = errors + 1;
            end else if (dut.cnt_cap > 8'h3f) begin
                $display("FAIL: cnt_cap=%0d exceeds counter range at %0t", dut.cnt_cap, $time);
                errors = errors + 1;
            end
            last_cap = dut.cnt_cap;
        end
    end

    initial begin
        #1 RST_N = 1'b0;
        #20 RST_N = 1'b1;
        #20 START = 1'b1;
        #200 armed = 1'b1;
        #1000;
        if (checks < 50) begin
            $display("FAIL: only %0d REF checks", checks);
            errors = errors + 1;
        end
        if (errors != 0) $fatal(1, "freq_lock_cdc_tb failed");
        $display("freq_lock_cdc_tb: PASS (%0d checks, last cnt_cap=%0d)", checks, last_cap);
        $finish;
    end
endmodule
