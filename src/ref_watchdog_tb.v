// REF watchdog characteristics, including the sampled-liveness limitation.
//
// Normal operation: REF toggles while OUT runs, so alive stays high.
// REF stop: alive falls after TIMEOUT OUT edges.
// Exact 1:1 (FCW=1): every OUT edge samples the same REF phase, so the
// sampled toggle detector sees no edge and alive falls even though REF is
// running.  That is a documented limitation, not a pass.  A hard clock-fault
// contract needs an independent always-on monitor.
// A non-integer ratio lets the phase walk, so alive stays high.
`timescale 1ns/1ps

module ref_watchdog_tb;
    localparam integer TIMEOUT = 32;

    reg clk_count = 1'b0;
    reg clk_watch = 1'b0;
    reg ref_run = 1'b1;
    real out_half = 0.5;   // 1 GHz OUT
    real ref_half = 5.0;   // 100 MHz REF

    always #(out_half) clk_count = ~clk_count;
    initial begin
        #0.1;
        forever #(ref_half) if (ref_run) clk_watch = ~clk_watch;
    end

    reg rst_n = 1'b0;
    reg enable = 1'b1;
    wire alive;

    pll_ref_watchdog #(.TIMEOUT(TIMEOUT)) dut (
        .clk_count(clk_count), .clk_watch(clk_watch),
        .enable(enable), .rst_n(rst_n), .alive(alive)
    );

    integer errors = 0;
    integer i;

    task reset_dut;
        begin
            rst_n = 1'b0;
            #10;
            rst_n = 1'b1;
            #10;
        end
    endtask

    task expect_alive;
        input expected;
        input [8*40-1:0] name;
        begin
            if (alive !== expected) begin
                $display("FAIL: %0s alive=%b expected=%b", name, alive, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s alive=%b", name, alive);
            end
        end
    endtask

    initial begin
        // Normal 8:1 ratio.  TIMEOUT is 32 OUT edges; REF toggles every
        // 10 ns, so the sampled level changes well inside the window.
        reset_dut;
        #500;
        expect_alive(1'b1, "normal 8:1 keeps REF alive");

        // Stop REF.  The sampled level stops changing.
        ref_run = 1'b0;
        clk_watch = 1'b0;
        #600;
        expect_alive(1'b0, "REF stop drops alive");
        ref_run = 1'b1;

        // Exact 1:1.  OUT and REF are both 2 ns; the 0.1 ns offset makes
        // every sampling edge see the same high phase.  This is the FCW=1
        // alias: alive falls while REF is still running.
        out_half = 1.0;
        ref_half = 1.0;
        reset_dut;
        #500;
        if (alive !== 1'b0) begin
            $display("FAIL: exact 1:1 did not reproduce the alias, alive=%b", alive);
            errors = errors + 1;
        end else begin
            $display("LIMITATION: exact 1:1 (FCW=1) sampled REF aliases, alive=0");
        end

        // A 5% frequency offset walks the phase, so the same detector sees
        // REF again.  This is why the alias is an integer-ratio boundary,
        // not a general REF-loss failure.
        out_half = 1.0;
        ref_half = 1.05;
        reset_dut;
        #2000;
        expect_alive(1'b1, "1:1 with 5% offset keeps alive");

        // A faster REF than OUT is sampled randomly and stays alive when the
        // ratio is not an integer.  An exact integer ratio aliases here too,
        // so the phase must walk across samples.
        out_half = 2.0;
        ref_half = 0.23;
        reset_dut;
        #500;
        expect_alive(1'b1, "non-integer fast REF keeps alive");

        if (errors != 0) $fatal(1, "ref_watchdog_tb failed");
        $display("ref_watchdog_tb: PASS");
        $finish;
    end
endmodule
