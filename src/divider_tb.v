// Divider boundary regression: DIV=2/3/4 and runtime load, including the
// illegal DIV<2 clamp path in the configurable divider.
`timescale 1ns/1ps

module divider_tb;
    reg clk = 1'b0;
    always #5 clk = ~clk;

    reg rst_n = 1'b0;
    reg [7:0] set_div = 8'd2;
    reg load_div = 1'b0;

    wire out2, out3, out4, outm;

    pll_fix_divider #(.DIV(2)) d2 (.clk(clk), .rst_n(rst_n), .out(out2));
    pll_fix_divider #(.DIV(3)) d3 (.clk(clk), .rst_n(rst_n), .out(out3));
    pll_fix_divider #(.DIV(4)) d4 (.clk(clk), .rst_n(rst_n), .out(out4));
    pll_mod_divider #(.W(8)) dm (
        .clk(clk), .rst_n(rst_n),
        .set_div(set_div), .load_div(load_div), .out(outm)
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

    initial begin
        #25 rst_n = 1'b1;
        #120;
        check_period(p2, 20, "DIV=2");
        check_period(p3, 30, "DIV=3");
        check_period(p4, 40, "DIV=4");
        check_period(pm, 20, "mod reset DIV=2");

        // Runtime load: 3 then an illegal 1 (must clamp to 2).
        @(negedge clk); set_div = 8'd3; load_div = 1'b1;
        @(negedge clk); load_div = 1'b0;
        #100;
        check_period(pm, 30, "mod load DIV=3");

        @(negedge clk); set_div = 8'd1; load_div = 1'b1;
        @(negedge clk); load_div = 1'b0;
        #100;
        check_period(pm, 20, "mod illegal DIV=1 clamps to 2");

        if (errors != 0) $fatal(1, "divider_tb failed");
        $display("divider_tb: PASS");
        $finish;
    end
endmodule
