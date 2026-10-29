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

    initial begin
        #25 RST_N = 1'b1;
        #20 ENABLE = 1'b1;
        #60;
        check_lock(1'b1, 1'b0, "lock after 4 no-symbol");

        SS_BBPD = 2'b10;
        #30;
        check_lock(1'b0, 1'b1, "loss after 2 symbols");

        SS_BBPD = 2'b00;
        #60;
        check_lock(1'b1, 1'b0, "relock");

        ILL_P = 1'b1;
        #30;
        check_lock(1'b0, 1'b1, "saturation loss");

        if (errors != 0) $fatal(1, "lock_detector_tb failed");
        $display("lock_detector_tb: PASS");
        $finish;
    end
endmodule
