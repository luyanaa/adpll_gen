`timescale 1ns/1ps
module frequency_counter_frontend_tb;
    reg CLK = 0;
    reg RST_N = 0;
    wire [7:0] sync_count, sync_gray, rip_count, rip_gray, john_count, john_gray;
    wire [7:0] ps2_count, ps2_gray;
    wire sync_safe, rip_safe, john_safe, ps2_safe;

    frequency_counter_frontend #(.CNT_W(8), .MODE(0)) u_sync(
        .CLK(CLK), .RST_N(RST_N), .COUNT(sync_count),
        .GRAY_COUNT(sync_gray), .CDC_SAFE(sync_safe));
    frequency_counter_frontend #(.CNT_W(8), .MODE(0), .PRESCALE(2)) u_ps2(
        .CLK(CLK), .RST_N(RST_N), .COUNT(ps2_count),
        .GRAY_COUNT(ps2_gray), .CDC_SAFE(ps2_safe));
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
        // Johnson terminal must increment exactly once per 8-state cycle;
        // after 20 input edges COUNT must equal 20, not 20*4/8-ish.
        if (john_count != 8'd20)
            $fatal(1, "Johnson count %0d expected 20", john_count);
        // Prescale changes the internal divide rate but COUNT is normalized
        // back to input edges so freq_lock's FCW comparison is unchanged.
        if (ps2_count != 8'd20)
            $fatal(1, "prescale=2 count %0d expected 20", ps2_count);
        if (ps2_gray != ((ps2_count >> 1) ^ ps2_count))
            $fatal(1, "prescale=2 gray mismatch");
        if (!ps2_safe) $fatal(1, "prescale sync frontend not CDC-safe");
        $display("frequency_counter_frontend_tb: PASS sync=%0d ps2=%0d ripple=%0d johnson=%0d",
                 sync_count, ps2_count, rip_count, john_count);
        $finish;
    end
endmodule
