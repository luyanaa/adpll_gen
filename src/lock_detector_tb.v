// Fine-stage SS-BBPD lock detector regression.
//
// Contract at the sampled edge: 01 = P, 11 = N, 00/10 = invalid.  The
// detector qualifies a window of LOCK_COUNT valid samples only when both
// signs occur, and drops an existing lock on a one-sided window or on
// LOSS_COUNT consecutive invalid samples.
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
        input [8*32-1:0] name;
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

    // Drive a code for exactly n sampling edges.  The task is entered at a
    // falling edge and returns at the next falling edge, so chained calls
    // do not insert an extra sample between sequences.
    task drive_code;
        input [1:0] code;
        input integer n;
        begin
            SS_BBPD = code;
            for (k = 0; k < n; k = k + 1)
                @(posedge CLK);
            @(negedge CLK);
        end
    endtask

    task drive_window;   // P, N, P, N for LOCK_COUNT=4
        begin
            drive_code(2'b01, 1);
            drive_code(2'b11, 1);
            drive_code(2'b01, 1);
            drive_code(2'b11, 1);
        end
    endtask

    initial begin
        @(negedge CLK);
        RST_N = 1'b1;
        @(negedge CLK);
        ENABLE = 1'b1;

        // 00 is not a stable latch state and 10 is not a quiet code.
        drive_code(2'b00, 8);
        check_lock(1'b0, 1'b0, "stuck 00 never locks");
        drive_code(2'b10, 8);
        check_lock(1'b0, 1'b0, "stuck 10 never locks");

        // One sign only, however long, is not phase lock.
        drive_code(2'b01, 8);
        check_lock(1'b0, 1'b0, "stuck P never locks");
        drive_code(2'b11, 8);
        check_lock(1'b0, 1'b0, "stuck N never locks");

        // Both signs in one window.
        drive_window;
        check_lock(1'b1, 1'b0, "lock after both sides");

        // A full one-sided window drops an existing lock.
        drive_code(2'b01, 4);
        check_lock(1'b0, 1'b1, "one-sided window drops lock");

        // One-sided windows while unlocked do not clear LOCK_LOST.
        drive_code(2'b11, 6);
        check_lock(1'b0, 1'b1, "one side does not relock");

        drive_window;
        check_lock(1'b1, 1'b0, "relock");

        // Invalid samples drop a lock after LOSS_COUNT.
        drive_code(2'b10, 2);
        check_lock(1'b0, 1'b1, "10 drops lock");

        drive_window;
        check_lock(1'b1, 1'b0, "relock after 10");

        drive_code(2'b00, 2);
        check_lock(1'b0, 1'b1, "00 drops lock");

        drive_window;
        check_lock(1'b1, 1'b0, "relock after 00");

        // Filter saturation makes every sample invalid.
        ILL_P = 1'b1;
        drive_code(2'b01, 2);
        check_lock(1'b0, 1'b1, "ILL_P drops lock");
        ILL_P = 1'b0;
        drive_window;
        check_lock(1'b1, 1'b0, "relock after ILL_P");

        if (errors != 0) $fatal(1, "lock_detector_tb failed");
        $display("lock_detector_tb: PASS");
        $finish;
    end
endmodule
