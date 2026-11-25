// Divider boundary regression: DIV=2/3/4, runtime load, and the /1 bypass
// in the configurable divider.
`timescale 1ns/1ps

module divider_tb;
    reg clk = 1'b0;
    always #5 clk = ~clk;

    reg rst_n = 1'b0;
    reg [7:0] set_div = 8'd2;
    reg load_div = 1'b0;

    wire out2, out3, out4, outm;
    wire [7:0] divq;

    pll_fix_divider #(.DIV(2)) d2 (.clk(clk), .rst_n(rst_n), .out(out2));
    pll_fix_divider #(.DIV(3)) d3 (.clk(clk), .rst_n(rst_n), .out(out3));
    pll_fix_divider #(.DIV(4)) d4 (.clk(clk), .rst_n(rst_n), .out(out4));
    pll_mod_divider #(.W(8)) dm (
        .clk(clk), .rst_n(rst_n), .rst_n2(rst_n),
        .set_div(set_div), .load_div(load_div), .out(outm),
        .div_q(divq)
    );

    integer last2 = -1, last3 = -1, last4 = -1, lastm = -1;
    integer p2 = 0, p3 = 0, p4 = 0, pm = 0;

    always @(posedge out2) begin
        if (last2 >= 0) p2 = $time - last2;
        last2 = $time;
    end
    always @(posedge out3) begin
        if (last3 >= 0) p3 = $time - last3;
        last3 = $time;
    end
    always @(posedge out4) begin
        if (last4 >= 0) p4 = $time - last4;
        last4 = $time;
    end
    always @(posedge outm) begin
        if (lastm >= 0) pm = $time - lastm;
        lastm = $time;
    end

    integer errors = 0;

    task check_period;
        input integer got;
        input integer expected;
        input [8*32-1:0] name;
        begin
            if (got != expected) begin
                $display("FAIL: %0s period=%0d expected=%0d", name, got, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s period=%0d", name, got);
            end
        end
    endtask

    // Load a new ratio and measure the first high that belongs to it.
    // A high already open when the request is made is the old ratio's and
    // is skipped.  The new ratio is applied at the rising edge that starts
    // its high phase, so div_q already holds the new value there.
    task switch_and_check;
        input [7:0] nd;
        input integer expected_high;     // ns
        input [8*40-1:0] name;
        integer t0, w, low_w;
        begin
            @(negedge clk); set_div = nd; load_div = 1'b1;
            @(negedge clk); load_div = 1'b0;
            if (outm) @(negedge outm);
            @(posedge outm);
            while (divq !== nd) @(posedge outm);
            t0 = $time;
            @(negedge outm);
            w = $time - t0;
            t0 = $time;
            @(posedge outm);
            low_w = $time - t0;
            if (w != expected_high || low_w != expected_high) begin
                $display("FAIL: %0s first high=%0d low=%0d expected=%0d both",
                         name, w, low_w, expected_high);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s first high=%0d low=%0d", name, w, low_w);
            end
        end
    endtask

    initial begin
        #25 rst_n = 1'b1;
        #120;
        check_period(p2, 20, "DIV=2");
        check_period(p3, 30, "DIV=3");
        check_period(p4, 40, "DIV=4");
        check_period(pm, 20, "mod reset DIV=2");

        // Runtime load: 3 then a /1 bypass request.
        @(negedge clk); set_div = 8'd3; load_div = 1'b1;
        @(negedge clk); load_div = 1'b0;
        #100;
        check_period(pm, 30, "mod load DIV=3");

        @(negedge clk); set_div = 8'd1; load_div = 1'b1;
        @(negedge clk); load_div = 1'b0;
        #100;
        check_period(pm, 10, "mod DIV=1 bypass");

        // A load that lands in the middle of a phase must not finish that
        // phase short.  /4 high is 2 clocks; loading /2 one clock into the
        // high phase still has to complete those 2 clocks before /2 starts.
        @(negedge clk); set_div = 8'd4; load_div = 1'b1;
        @(negedge clk); load_div = 1'b0;
        #80;
        begin : switch_check
            integer rose_at, high_w, low_w;
            // /4 high is two input clocks.  Record it from the rising edge,
            // and request /2 one clock into that high phase.  Both halves of
            // the period already open have to keep the /4 width.
            @(posedge outm);
            rose_at = $time;
            @(negedge clk);
            set_div = 8'd2;
            load_div = 1'b1;
            @(posedge clk);
            @(negedge clk);
            load_div = 1'b0;
            @(negedge outm);
            high_w = $time - rose_at;
            rose_at = $time;
            @(posedge outm);
            low_w = $time - rose_at;
            if (high_w < 20 || low_w < 20) begin
                $display("FAIL: runt pulse high=%0d low=%0d", high_w, low_w);
                errors = errors + 1;
            end else begin
                $display("PASS: no runt pulse high=%0d low=%0d", high_w, low_w);
            end
            // The next rising edge starts the new /2 period: 20 time units.
            @(posedge outm);
            check_period(pm, 20, "settled DIV=2 after switch");
        end

        // The first high after a ratio change must be the new high width.
        // /4->/2 only needs one input clock for its high, so it cannot see
        // the pre-load bug.  These ratios can.
        switch_and_check(8'd8, 40, "/2 to /8");
        check_period(pm, 80, "settled DIV=8");

        switch_and_check(8'd4, 20, "/8 to /4");
        switch_and_check(8'd8, 40, "/4 to /8");
        check_period(pm, 80, "settled DIV=8 again");

        // Through the /1 bypass and back.  In bypass out follows clk, so
        // its high is half an input period (5 ns); leaving it starts the
        // new counted high at a full width.
        switch_and_check(8'd1, 5, "/8 to /1");
        switch_and_check(8'd8, 40, "/1 to /8");
        check_period(pm, 80, "settled DIV=8 after bypass");

        if (errors != 0) $fatal(1, "divider_tb failed");
        $display("divider_tb: PASS");
        $finish;
    end
endmodule
