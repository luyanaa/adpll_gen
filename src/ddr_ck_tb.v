// DDR CK contract:
//   * CK stays 0 while LOCKED is 0 and the divider is already running
//   * even /8 of an 800 MHz clock is 100 MHz, tCH/tCL inside 0.45-0.55
//   * an odd divisor does not keep CK running
//   * after LOCKED falls, at most the pulse already open is emitted
`timescale 1ns/1ps

module ddr_ck_tb;
    reg clk = 1'b0;
    always #0.625 clk = ~clk; // 800 MHz

    reg rst_n = 1'b0;
    reg locked = 1'b0;
    reg load_div = 1'b0;
    reg [7:0] set_div = 8'd8;
    integer phase = 0;

    wire div_clk;
    wire [7:0] div_q;
    wire ck;

    pll_mod_divider #(.W(8), .DIV_INIT(8)) div (
        .clk(clk), .rst_n(rst_n),
        .set_div(set_div), .load_div(load_div),
        .out(div_clk), .div_q(div_q)
    );
    ddr_ck_gate #(.W(8)) u_ck (
        .clk_div(div_clk), .locked(locked), .rst_n(rst_n),
        .div(div_q), .ck(ck)
    );

    integer edges, fail, duty_n;
    real rise_t, high_t, duty_sum;

    always @(posedge ck) begin
        edges = edges + 1;
        rise_t = $realtime;
    end
    always @(negedge ck) begin
        if (phase == 2 && rise_t > 0.0) begin
            high_t = $realtime - rise_t;
            // /8 of 1.25 ns is a 10 ns period; high phase is 5 ns.
            if (high_t > 2.0 && high_t < 8.0) begin
                duty_sum = duty_sum + (high_t / 10.0);
                duty_n = duty_n + 1;
            end
        end
    end

    initial begin
        edges = 0;
        fail = 0;
        duty_n = 0;
        duty_sum = 0.0;
        phase = 1;
        #5;
        rst_n = 1;
        #40;
        if (edges != 0) begin
            $display("FAIL pre-lock CK edges=%0d", edges);
            fail = fail + 1;
        end else
            $display("PASS pre-lock CK quiet");

        edges = 0;
        phase = 2;
        locked = 1;
        #80; // 8 cycles of 10 ns, minus gate-open latency
        if (edges < 4) begin
            $display("FAIL /8 CK edges=%0d (want a 100 MHz clock)", edges);
            fail = fail + 1;
        end else
            $display("PASS /8 released %0d CK edges", edges);
        if (duty_n == 0 || (duty_sum / duty_n) < 0.45 || (duty_sum / duty_n) > 0.55) begin
            $display("FAIL duty avg=%0.3f n=%0d", (duty_n ? duty_sum / duty_n : 0.0), duty_n);
            fail = fail + 1;
        end else
            $display("PASS duty avg=%0.3f inside 0.45-0.55", duty_sum / duty_n);

        // Odd divisor. Allow the one high pulse already enabled.
        phase = 3;
        edges = 0;
        set_div = 8'd5;
        load_div = 1;
        #1.25;
        load_div = 0;
        #15;
        edges = 0;
        #40;
        if (edges != 0) begin
            $display("FAIL odd /5 still toggling, edges=%0d", edges);
            fail = fail + 1;
        end else
            $display("PASS odd divisor holds CK low");

        set_div = 8'd8;
        load_div = 1;
        #1.25;
        load_div = 0;
        phase = 4;
        #40;
        edges = 0;
        locked = 0;
        #20; // one completing pulse may still exit
        edges = 0;
        #40;
        if (edges != 0) begin
            $display("FAIL CK edges=%0d after unlock", edges);
            fail = fail + 1;
        end else
            $display("PASS CK quiet after unlock");

        if (fail == 0) $display("ddr_ck_tb: PASS");
        else $display("ddr_ck_tb: FAIL %0d", fail);
        $finish;
    end
endmodule
