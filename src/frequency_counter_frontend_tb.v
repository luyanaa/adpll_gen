`timescale 1ns/1ps
module frequency_counter_frontend_tb;
    reg CLK = 0;
    reg RST_N = 0;
    wire [7:0] sync_count, sync_gray, rip_count, rip_gray, john_count, john_gray;
    wire sync_safe, rip_safe, john_safe;

    frequency_counter_frontend #(.CNT_W(8), .MODE(0)) u_sync(
        .CLK(CLK), .RST_N(RST_N), .COUNT(sync_count),
        .GRAY_COUNT(sync_gray), .CDC_SAFE(sync_safe));
    frequency_counter_frontend #(.CNT_W(8), .MODE(1)) u_ripple(
        .CLK(CLK), .RST_N(RST_N), .COUNT(rip_count),
        .GRAY_COUNT(rip_gray), .CDC_SAFE(rip_safe));
    frequency_counter_frontend #(.CNT_W(8), .MODE(2)) u_johnson(
        .CLK(CLK), .RST_N(RST_N), .COUNT(john_count),
        .GRAY_COUNT(john_gray), .CDC_SAFE(john_safe));

    always #5 CLK = ~CLK;

    initial begin
        #1 RST_N = 1;
        #1 RST_N = 0;
        #10 RST_N = 1;
        repeat (20) @(posedge CLK);
        #1;
        if (sync_count != 8'd20) $fatal(1, "sync count %0d", sync_count);
        if (sync_gray != ((sync_count >> 1) ^ sync_count))
            $fatal(1, "sync gray mismatch");
        if (!sync_safe) $fatal(1, "sync frontend not marked CDC-safe");
        if (rip_safe || john_safe)
            $fatal(1, "alternate frontend incorrectly marked CDC-safe");
        if (john_count == 0) $fatal(1, "Johnson counter did not advance");
        $display("frequency_counter_frontend_tb: PASS sync=%0d ripple=%0d johnson=%0d",
                 sync_count, rip_count, john_count);
        $finish;
    end
endmodule
