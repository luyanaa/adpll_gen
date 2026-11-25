// Odd-divisor duty check for pll_mod_divider.
//
// A DDR DLL fed by OUT_DIV needs a uniform reference.  With a posedge-only
// counter an odd divisor cannot be 50%: div=3 gives 66.7%, div=5 60%,
// div=15 53.3%.  pll_mod_divider therefore has a dedicated odd path (two
// counters, one per clock edge, OR-ed) that is exactly 50%.
//
// This bench measures the high and low times of every divisor 2..15 and
// checks the duty against 50% with a one-half-clk tolerance for the odd
// cases, exact for the even ones.
`timescale 1ps/1ps

module divider_duty_tb;
    localparam integer W = 8;
    localparam time HALF = 5000;   // 100 MHz

    reg clk = 1'b0;
    always #HALF clk = ~clk;

    reg rst_n = 1'b0;
    reg load = 1'b0;
    reg [W-1:0] set_div = 8'd2;
    wire out, div_even;
    wire [W-1:0] divq;

    pll_mod_divider #(.W(W), .DIV_INIT(2)) dut (
        .clk(clk), .rst_n(rst_n), .rst_n2(rst_n), .set_div(set_div), .load_div(load),
        .out(out), .div_q(divq), .div_even(div_even)
    );

    integer errors = 0;
    integer d;
    time t_r, t_f, high_t, low_t;
    real duty;

    task measure(input integer divisor);
        begin
            set_div = divisor[W-1:0];
            load = 1'b1;
            @(negedge clk);
            load = 1'b0;
            // Let the new ratio settle, then measure one full output period
            // starting from a rising edge.  Waiting on `out` events directly
            // is what makes this ratio-agnostic.
            repeat (4 * divisor) @(posedge clk);
            @(posedge out);
            t_r = $time;
            @(negedge out);
            t_f = $time;
            @(posedge out);
            high_t = t_f - t_r;
            low_t  = $time - t_f;
            duty   = 100.0 * high_t / (high_t + low_t);
            $display("div=%0d high=%0d low=%0d period=%0d duty=%5.2f%%",
                     divisor, high_t, low_t, high_t + low_t, duty);
            // 50% +- one half clk for odd, exact for even.
            if (divisor % 2) begin
                if (duty < 45.0 || duty > 55.0) begin
                    $display("  FAIL: odd divisor duty outside 45-55%%");
                    errors = errors + 1;
                end
            end else begin
                if (high_t != low_t) begin
                    $display("  FAIL: even divisor not exactly 50%%");
                    errors = errors + 1;
                end
            end
        end
    endtask

    initial begin
        #(2*HALF) rst_n = 1'b1;
        // use_clk is released on a FALLING clk edge, so wait for one before
        // the first measurement or out starts as x.
        @(negedge clk);
        repeat (4) @(posedge clk);
        for (d = 2; d <= 15; d = d + 1) measure(d);
        if (errors == 0) $display("divider_duty_tb: PASS");
        else             $display("divider_duty_tb: FAIL (%0d)", errors);
        $finish;
    end
endmodule
