// Fine-stage SS-BBPD lock detector regression.
`timescale 1ns/1ps

module lock_detector_tb;
    reg CLK = 1'b0;
    always #5 CLK = ~CLK;
    reg RST_N = 1'b0;
    reg ENABLE = 1'b0;
    reg [1:0] SS_BBPD = 2'b00;
    reg ILL_P = 1'b0, ILL_N = 1'b0;
    wire PHASE_LOCK, LOCK_LOST;

    pll_lock_detector #(
        .LOCK_COUNT(4),
        .LOSS_COUNT(2)
    ) dut (
        .CLK(CLK), .RST_N(RST_N), .ENABLE(ENABLE),
        .SS_BBPD(SS_BBPD), .ILL_P(ILL_P), .ILL_N(ILL_N),
        .PHASE_LOCK(PHASE_LOCK), .LOCK_LOST(LOCK_LOST)
    );

    integer errors = 0;
    integer k;

    task check_lock;
        input p;
        input l;
        input [8*24-1:0] name;
        begin
            if (PHASE_LOCK !== p || LOCK_LOST !== l) begin
                $display("FAIL: %0s PHASE_LOCK=%b LOCK_LOST=%b expected=%b/%b",
                         name, PHASE_LOCK, LOCK_LOST, p, l);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s PHASE_LOCK=%b LOCK_LOST=%b", name, PHASE_LOCK, LOCK_LOST);
            end
        end
    endtask

    // Change the code away from the sampling edge, then let the detector
    // see exactly n rising edges of it.
    task drive_code;
        input [1:0] code;
        input integer n;
        begin
            @(negedge CLK);
            SS_BBPD = code;
            for (k = 0; k < n; k = k + 1)
                @(posedge CLK);
            @(negedge CLK);
        end
    endtask

    initial begin
        @(negedge CLK);
        RST_N = 1'b1;
        @(negedge CLK);
        ENABLE = 1'b1;

        // A stuck quiet code never presents either correction symbol.
        drive_code(2'b00, 8);
        check_lock(1'b0, 1'b0, "stuck quiet code");

        // Default polarity: 2'b01 positive, 2'b11 negative, 2'b00 quiet.
        // Both symbols, then a quiet run of LOCK_COUNT.
        drive_code(2'b01, 1);
        drive_code(2'b11, 1);
        drive_code(2'b00, 4);
        check_lock(1'b1, 1'b0, "lock after both sides");

        drive_code(2'b01, 2);
        check_lock(1'b0, 1'b1, "loss after 2 symbols");

        // The unlock cleared both sides.  One symbol is not enough.
        drive_code(2'b01, 1);
        drive_code(2'b00, 6);
        // LOCK_LOST stays set until a qualified relock.  The one symbol
        // must not clear it or raise PHASE_LOCK.
        check_lock(1'b0, 1'b1, "one side does not relock");

        drive_code(2'b11, 1);
        drive_code(2'b00, 4);
        check_lock(1'b1, 1'b0, "relock");

        // 2'b10 is the alternate-polarity positive code, not a quiet code.
        drive_code(2'b10, 2);
        check_lock(1'b0, 1'b1, "10 is not quiet");

        if (errors != 0) $fatal(1, "lock_detector_tb failed");
        $display("lock_detector_tb: PASS");
        $finish;
    end
endmodule
