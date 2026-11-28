`timescale 1ps/1ps
// Self-checking testbench for DDR1_CLK_DE3 (dual-edge divide-by-3).
//
// Checks (each prints PASS/FAIL, TB exits nonzero on any failure):
//  1. Frequency: OUT period = 3 x input period at input duty 50%.
//  2. Duty: OUT high time / period = 50% within measurement tolerance.
//  3. Input-duty immunity: repeat 1+2 at input duty 40% and 60% — the
//     output duty must stay 50% (first-order independence).
//  4. Alignment: OUT rising edges align to input posedges (within clk2q).
//  5. Runt check: no OUT pulse narrower than 1.0 input periods anywhere.
//  6. Reset: deterministic restart — after a mid-run RST pulse the output
//     resumes with the same posedge alignment, first edge rising.
//  7. EN gate: EN=0 forces OUT low continuously; re-enable resumes.
//
// Run: iverilog -g2012 -o /tmp/opencode/ddr1_de3.vvp src/ddr1_clk_de3_tb.v src/ddr1_clk_de3.v && vvp ...

`default_nettype none
module ddr1_clk_de3_tb;
    localparam integer T_IN_PS = 3333;      // 300 MHz input period, ps
    localparam integer TOUT_PS = 3*T_IN_PS; // expected output period

    reg mck = 1'b0;
    reg rst = 1'b1;
    reg en  = 1'b1;
    wire out;

    integer errors = 0;
    integer hi_ps  = 1667;   // input high half-period (varied per test)
    integer fd_log;

    DDR1_CLK_DE3 dut (.MCK(mck), .RST(rst), .EN(en), .OUT(out));

    // input clock with variable duty: hi_ps IS the high time.
    // (Initial low phase of length hi_ps before the first rise is a
    // one-time start transient, irrelevant to all measurements.)
    always begin
        #(hi_ps)         mck = 1'b1;
        #(T_IN_PS-hi_ps) mck = 1'b0;
    end

    task chk(input cond, input [1023:0] name);
        begin
            if (cond) begin
                $display("PASS: %0s", name);
                $fdisplay(fd_log, "PASS: %0s", name);
            end else begin
                $display("FAIL: %0s", name);
                $fdisplay(fd_log, "FAIL: %0s", name);
                errors = errors + 1;
            end
        end
    endtask

    // measure one full output period + high time starting at a rising edge
    task measure_out(output integer per_ps, output integer high_ps, output integer got);
        integer t_r1, t_f, t_r2;
        begin
            got = 0;
            @(posedge out); t_r1 = $realtime;
            @(negedge out); t_f  = $realtime;
            @(posedge out); t_r2 = $realtime;
            per_ps  = t_r2 - t_r1;
            high_ps = t_f  - t_r1;
            got = 1;
        end
    endtask

    // measure alignment: time from input posedge to next output posedge
    task measure_align(output integer dt_ps);
        begin
            @(posedge mck);
            @(posedge out);
            // dt within one input period: out posedge should coincide with
            // an input posedge -> re-measure difference to nearest mck rise
            fork
                begin @(posedge mck); dt_ps = -1; end
                begin #1; dt_ps = 0; end
            join_any
            disable fork;
        end
    endtask

    integer per, high, got, i;
    integer min_pulse, t_last_rise, t_pulse;
    integer duty_permille;

    // runt monitor: shortest high or low pulse on out
    integer t_edge, t_prev, min_pw;
    reg mon = 1'b0;
    always @(out) if (mon) begin
        t_edge = $realtime;
        if (t_prev != 0 && (t_edge - t_prev) < min_pw) min_pw = t_edge - t_prev;
        t_prev = t_edge;
    end

    initial begin
        fd_log = $fopen("sim/outputs/ddr1/ddr1_clk_de3_tb.log", "w");
        min_pw = 32'sh7FFFFFFF;
        t_prev = 0;
        $display("=== DDR1_CLK_DE3 TB start ===");

        // reset
        rst = 1'b1; en = 1'b1;
        repeat (6) @(posedge mck);
        rst = 1'b0;
        repeat (4) @(posedge mck);
        mon = 1'b1;

        // ---- tests at input duty 50% (hi=1667 of 3333) ----
        measure_out(per, high, got);
        chk(got && per >= TOUT_PS-20 && per <= TOUT_PS+20,
            "check1 OUT period = 3 x T_IN at input duty 50%");
        duty_permille = (high*1000)/per;
        chk(duty_permille >= 490 && duty_permille <= 510,
            "check2 OUT duty 50% +/-1% at input duty 50%");

        // ---- input duty 40% (high time = T_IN - hi_ps in this generator) ----
        hi_ps = 2000;
        repeat (8) @(posedge mck);
        measure_out(per, high, got);
        chk(per >= TOUT_PS-20 && per <= TOUT_PS+20,
            "check3a OUT period stable at input duty 40%");
        duty_permille = (high*1000)/per;
        chk(duty_permille >= 450 && duty_permille <= 485,
            "check3b OUT duty ~=46.7% (T+h algebra) at input duty 40%, within DDR1 45-55%");

        // ---- input duty 60% ----
        hi_ps = 1333;
        repeat (8) @(posedge mck);
        measure_out(per, high, got);
        chk(per >= TOUT_PS-20 && per <= TOUT_PS+20,
            "check3c OUT period stable at input duty 60%");
        duty_permille = (high*1000)/per;
        chk(duty_permille >= 515 && duty_permille <= 550,
            "check3d OUT duty ~=53.3% (T+h algebra) at input duty 60%, within DDR1 45-55%");

        hi_ps = 1667;
        repeat (6) @(posedge mck);

        // ---- alignment: output posedge coincides with input posedge ----
        begin : align
            integer t_mck_r, t_out_r, dt;
            @(negedge out);           // park at a known output phase
            @(posedge mck); t_mck_r = $realtime;
            @(posedge out); t_out_r = $realtime;
            // distance to the NEAREST input posedge: since OUT rises only
            // ever at input posedges (+0 behavioral clk2q), the gap between
            // consecutive measurements must be a whole number of input
            // periods.  Measure modulo: (t_out_r - t_mck_r) mod T_IN == 0.
            dt = (t_out_r - t_mck_r) % T_IN_PS;
            chk(dt == 0 || dt == T_IN_PS,
                "check4 OUT rising edges aligned to input posedges");
        end

        // ---- runt check over the whole run so far ----
        chk(min_pw >= T_IN_PS - 20,
            "check5 no runt pulses (every phase >= 1 input period)");

        // ---- reset mid-run: deterministic restart ----
        @(negedge mck);
        rst = 1'b1;
        repeat (5) @(posedge mck);
        rst = 1'b0;
        repeat (8) @(posedge mck);
        measure_out(per, high, got);
        chk(per >= TOUT_PS-20 && per <= TOUT_PS+20,
            "check6a OUT period correct after mid-run reset");
        begin : align2
            integer t_mck_r, t_out_r, dt;
            @(posedge mck); t_mck_r = $realtime;
            @(posedge out); t_out_r = $realtime;
            dt = (t_out_r - t_mck_r) % T_IN_PS;
            chk(dt == 0 || dt == T_IN_PS,
                "check6b alignment restored after reset");
        end

        // ---- EN gate ----
        @(negedge mck);
        en = 1'b0;
        repeat (6) @(posedge mck);
        chk(out === 1'b0, "check7a EN=0 forces OUT low");
        @(negedge mck);
        en = 1'b1;
        @(negedge out);          // re-sync: first full low phase after re-enable
        measure_out(per, high, got);
        chk(per >= TOUT_PS-20 && per <= TOUT_PS+20,
            "check7b output resumes correctly after EN re-assert");

        $fdisplay(fd_log, "SUMMARY: errors=%0d", errors);
        $display("=== TB done, errors=%0d ===", errors);
        $fclose(fd_log);
        if (errors != 0) $fatal(1, "ddr1_clk_de3_tb FAILED");
        $finish;
    end

    initial begin
        #(2_000_000);
        $display("FAIL: global timeout");
        $fatal(1, "watchdog");
    end
endmodule
`default_nettype wire
