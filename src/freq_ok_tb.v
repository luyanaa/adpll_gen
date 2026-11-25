// Live frequency window.  Sticky LOCKED stays set after acquisition;
// FREQ_OK must fall once the filtered count leaves FCW +/- LOCK_TOL, and
// rise again when the count comes back.  One out-of-window sample is not
// enough: FREQ_LOSS of them are required.
`timescale 1ns/1ps

module freq_ok_tb;
    localparam real REF_HALF = 5.0;
    // 8 rising MID_OUT edges per 10 ns REF period, then 20.
    real mid_half = 0.625;

    reg REF = 1'b0;
    reg MID_OUT = 1'b0;
    reg RST_N = 1'b0;
    reg START = 1'b0;
    reg [7:0] FCW = 8'd8;

    wire LOCKED, ERR, FREQ_OK;
    wire [3:0] COARSE_MUX, MID_MUX;

    always #(REF_HALF) REF = ~REF;
    always #(mid_half) MID_OUT = ~MID_OUT;

    pll_freq_lock #(
        .COARSE_NDELS(4), .MID_NDELS(4), .CNT_BITS(8),
        .LOCK_TOL(1), .FREQ_LOSS(4), .LOCK_LIMIT(8), .LOCK_WINDOW(1)
    ) dut (
        .REF(REF), .MID_OUT(MID_OUT), .OUT(MID_OUT), .RST_N(RST_N),
        .FCW(FCW), .START(START), .LOCK(1'b0),
        .FORCE_P(1'b0), .FORCE_N(1'b0),
        .LOCKED(LOCKED), .ERR(ERR), .FREQ_OK(FREQ_OK),
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX)
    );

    integer errors = 0;
    integer i;
    integer saw_ok;

    initial begin
        #20 RST_N = 1'b1;
        #20 START = 1'b1;
        #10 START = 1'b0;

        // FREQ_OK follows the raw per-REF delta.  The filtered count
        // is not used: it settles on different codes for the same ratio
        // depending on which side it approached from.
        saw_ok = 0;
        for (i = 0; i < 40; i = i + 1) begin
            @(posedge REF);
            if (FREQ_OK === 1'b1)
                saw_ok = saw_ok + 1;
        end
        if (saw_ok < 8) begin
            $display("FAIL: FREQ_OK rose on %0d of 40 in-window REFs, cnt_cap=%0d",
                     saw_ok, dut.cnt_cap);
            errors = errors + 1;
        end else begin
            $display("PASS: FREQ_OK high for %0d in-window REFs, cnt_cap=%0d",
                     saw_ok, dut.cnt_cap);
        end

        // Leave the window.  FREQ_OK must survive the first few samples
        // and then fall.  Sticky LOCKED is not this flag.
        mid_half = 0.250;
        saw_ok = 0;
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge REF);
            if (FREQ_OK !== 1'b1)
                saw_ok = saw_ok + 1;
        end
        if (saw_ok != 0) begin
            $display("FAIL: FREQ_OK dropped inside the first %0d out-of-window REFs",
                     saw_ok);
            errors = errors + 1;
        end else begin
            $display("PASS: FREQ_OK held through the first out-of-window samples");
        end
        saw_ok = 0;
        for (i = 0; i < 30; i = i + 1) begin
            @(posedge REF);
            if (FREQ_OK === 1'b0)
                saw_ok = saw_ok + 1;
        end
        if (FREQ_OK !== 1'b0 || saw_ok < 8) begin
            $display("FAIL: FREQ_OK=%b after leaving the window, cnt_cap=%0d",
                     FREQ_OK, dut.cnt_cap);
            errors = errors + 1;
        end else begin
            $display("PASS: FREQ_OK low once cnt_cap=%0d left FCW=8", dut.cnt_cap);
        end

        // Back inside the window.  FREQ_OK has to rise again without START.
        mid_half = 0.625;
        saw_ok = 0;
        for (i = 0; i < 40; i = i + 1) begin
            @(posedge REF);
            if (FREQ_OK === 1'b1)
                saw_ok = saw_ok + 1;
        end
        if (FREQ_OK !== 1'b1) begin
            $display("FAIL: FREQ_OK did not return, cnt_cap=%0d", dut.cnt_cap);
            errors = errors + 1;
        end else begin
            $display("PASS: FREQ_OK returned, cnt_cap=%0d", dut.cnt_cap);
        end

        if (errors != 0) $fatal(1, "freq_ok_tb failed");
        $display("freq_ok_tb: PASS");
        $finish;
    end
endmodule
