`timescale 1ps/1ps
// SPDX-License-Identifier: Apache-2.0
// Self-checking testbench for DDR1_DQS_DELAY (DQS receive delay line).
//
// Checks (each prints PASS/FAIL, TB exits nonzero on any failure):
//  0. BLOCKER 4: power-up static low — DQS_IN low from t=0, before any
//     clock/reset/sweep, dqs_capture must be 0 (never X).
//  1. Range/step sweep: all 128 codes on lane 0, single-edge delay
//     measurement. Range >= 5.0 ns, average step <= 200 ps, no negative
//     step, max/nominal step ratio <= 1.5.
//  2. Strict monotonicity across all codes.
//  3. Handshake: request with update_idle=0 is NOT applied; applied on the
//     first idle edge; tap_ready exactly SETTLE_CYCLES after application;
//     ack clears ready; back-to-back requests.
//  3b. BLOCKER ack test: update_idle drops during the ack window.  The
//     request must NOT be consumed; the ack must complete in the next idle
//     window WITHOUT reprogramming (consumer contract: tap_valid &&
//     tap_ready).
//  4. Glitch: DQS_IN static low, full-range code sweep -> zero edges on
//     DQS_CAPTURE (output settle gate).
//  5. Static low -> static low over 20 sys cycles; 8-edge burst passes
//     through with the code delay and no extra/missing edges.
//  6. Mid-burst tap_valid with update_idle=0: code unchanged, capture edge
//     count unaffected, tap_error asserts.
//  7. Multi-lane independence (LANES=2, different codes per lane).
//  8. Reset returns code 0 (zero delay).
//
// Outputs: sim/outputs/ddr1/ddr1_dqs_delay_tb.log (log) and
//          sim/outputs/ddr1/dqs_delay_codes.csv (code,delay_ps,step_ps).
//
// Behavior of the line under test is the TT behavioral model with the
// resized line: CELLS_PER_TAP=2, CELL_PS=35 -> delay(code) = code * 70 ps.
// (The old 3 x 55 ps / 32-code model could not meet the 5 ns range on
// real cells; see ddr1_dqs_delay_line_phys.v for the TT/SS/FF table.)
//
// All DUT control inputs (tap_valid/tap_value/update_idle/rst) are driven on
// negedge sys_clk so the DUT posedge sampling is race-free.

`default_nettype none
module ddr1_dqs_delay_tb;
    localparam integer LANES        = 2;
    localparam integer TAP_BITS     = 7;
    localparam integer CODES        = 1 << TAP_BITS;   // 128
    localparam integer SETTLE_CYCLES = 2;
    localparam integer STEP_PS      = 70;             // expected TT model step
    localparam integer CLK_HALF     = 10000;          // 50 MHz sys_clk, ps
    localparam integer TIMEOUT_PS   = 200000;
    localparam integer MAX_DELAY_PS = (CODES-1)*STEP_PS; // 8890

    reg                    sys_clk = 1'b0;
    reg                    rst = 1'b1;
    reg                    update_idle = 1'b0;
    reg  [LANES-1:0]       dqs_in = 2'b00;
    wire [LANES-1:0]       dqs_capture;
    reg  [LANES-1:0]       tap_valid = 2'b00;
    reg  [LANES*TAP_BITS-1:0] tap_value = '0;
    wire [LANES-1:0]       tap_ready;
    wire [LANES-1:0]       tap_error;

    integer errors = 0;
    integer fd_log, fd_csv;

    // ---- edge monitors --------------------------------------------------
    integer glitch_cnt   [0:LANES-1];
    integer cap_rise_cnt [0:LANES-1];
    integer cap_fall_cnt [0:LANES-1];
    integer in_rise_cnt  [0:LANES-1];
    integer in_fall_cnt  [0:LANES-1];
    reg mon_glitch = 1'b0;
    reg mon_edges  = 1'b0;

    genvar gv;
    for (gv = 0; gv < LANES; gv = gv + 1) begin : g_mon
        always @(dqs_capture[gv]) if (mon_glitch) begin
            glitch_cnt[gv] = glitch_cnt[gv] + 1;
        end
        always @(posedge dqs_capture[gv]) if (mon_edges)
            cap_rise_cnt[gv] = cap_rise_cnt[gv] + 1;
        always @(negedge dqs_capture[gv]) if (mon_edges)
            cap_fall_cnt[gv] = cap_fall_cnt[gv] + 1;
        always @(posedge dqs_in[gv]) if (mon_edges)
            in_rise_cnt[gv] = in_rise_cnt[gv] + 1;
        always @(negedge dqs_in[gv]) if (mon_edges)
            in_fall_cnt[gv] = in_fall_cnt[gv] + 1;
    end

    DDR1_DQS_DELAY #(
        .LANES(LANES), .TAP_BITS(TAP_BITS),
        .FIRST_STAGE(0), .STEP_CELLS(1), .SETTLE_CYCLES(SETTLE_CYCLES)
    ) dut (
        .sys_clk(sys_clk), .rst(rst), .update_idle(update_idle),
        .dqs_in(dqs_in), .dqs_capture(dqs_capture),
        .tap_valid(tap_valid), .tap_value(tap_value),
        .tap_ready(tap_ready), .tap_error(tap_error)
    );

    always #(CLK_HALF) sys_clk = ~sys_clk;

    // ---- helpers --------------------------------------------------------
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

    // wait for tap_ready[lane]; got=1 on success, 0 on timeout
    task wait_ready(input integer lane, output integer got);
        begin
            got = 0;
            fork
                begin : w
                    wait (tap_ready[lane] === 1'b1);
                    got = 1;
                end
                begin : t
                    #(TIMEOUT_PS);
                end
            join_any
            disable fork;
        end
    endtask

    // wait until dqs_capture[lane] === val; got=1 on success
    task wait_cap(input integer lane, input val, output integer got);
        begin
            got = 0;
            fork
                begin : w
                    wait (dqs_capture[lane] === val);
                    got = 1;
                end
                begin : t
                    #(TIMEOUT_PS);
                end
            join_any
            disable fork;
        end
    endtask

    // apply one code via the handshake (race-free: request driven on
    // negedge, held through the apply edge, ready edge and one more posedge
    // so the DUT deterministically clears pending; then dropped on negedge).
    task apply_code(input integer lane, input integer code, output integer ok);
        integer got;
        begin
            ok = 0;
            tap_value[lane*TAP_BITS +: TAP_BITS] = code[TAP_BITS-1:0];
            @(negedge sys_clk);
            update_idle   = 1'b1;
            tap_valid[lane] = 1'b1;
            @(posedge sys_clk);          // apply edge
            wait_ready(lane, got);
            if (!got) begin
                $display("FAIL: tap_ready timeout lane %0d code %0d", lane, code);
                errors = errors + 1;
            end else begin
                ok = 1;
            end
            @(posedge sys_clk);          // pending cleared with valid high
            @(negedge sys_clk);
            tap_valid[lane] = 1'b0;
            @(negedge sys_clk);
            update_idle = 1'b0;
        end
    endtask

    // measure rising-edge delay of lane (code already applied, input low)
    task measure_delay(input integer lane, output integer delay_ps);
        integer got, t0;
        begin
            delay_ps = -1;
            dqs_in[lane] = 1'b0;
            #(500);
            t0 = $realtime;
            dqs_in[lane] = 1'b1;
            wait_cap(lane, 1'b1, got);
            if (got) begin
                delay_ps = $realtime - t0;
            end else begin
                $display("FAIL: capture rise timeout lane %0d", lane);
                errors = errors + 1;
            end
            #(8000);
            dqs_in[lane] = 1'b0;
            wait_cap(lane, 1'b0, got);
            if (!got) begin
                $display("FAIL: capture fall timeout lane %0d", lane);
                errors = errors + 1;
            end
            #(500);
        end
    endtask

    // measured code table for the CSV and later checks
    integer delay_tab [0:CODES-1];
    integer i, c, d, d0, got, ok;
    integer min_step, max_step, sum_step, nom_step, neg_cnt;
    integer t_burst_start;

    initial begin
        for (i = 0; i < LANES; i = i + 1) begin
            glitch_cnt[i] = 0; cap_rise_cnt[i] = 0; cap_fall_cnt[i] = 0;
            in_rise_cnt[i] = 0; in_fall_cnt[i] = 0;
        end
        fd_log = $fopen("sim/outputs/ddr1/ddr1_dqs_delay_tb.log", "w");
        if (fd_log == 0) begin
            $display("ERROR: cannot open log file");
            $finish;
        end
        $fdisplay(fd_log, "DDR1 DQS delay line TB (TT behavioral model, %0d ps nominal step)", STEP_PS);
        $display("=== DDR1 DQS delay TB start ===");

        // ---------------- check 0: BLOCKER 4 — power-up static-low --------
        // DQS_IN has been held low since t=0 and NO clock edge, reset, code
        // or sweep has occurred yet.  Requirement section 3.1: static low in
        // -> static low out AT ALL TIMES, so dqs_capture must read 0 (not X)
        // from the very first instant.  (The delay cell's output register
        // and the wrapper FSM regs carry declaration initialisers exactly so
        // this holds before the first sys_clk edge.)
        chk((dqs_capture[0] === 1'b0) && (dqs_capture[1] === 1'b0),
            "check0 t=0 DQS_IN static low -> dqs_capture 0 (not X) before sweep");
        $display("t=%0t capture=%b%b (before any reset/clock/sweep)",
                 $realtime, dqs_capture[1], dqs_capture[0]);
        $fdisplay(fd_log, "t=%0t capture=%b%b (before any reset/clock/sweep)",
                  $realtime, dqs_capture[1], dqs_capture[0]);

        // reset (synchronous, selects code 0)
        rst = 1'b1;
        update_idle = 1'b0;
        repeat (4) @(posedge sys_clk);
        @(negedge sys_clk);
        rst = 1'b0;
        repeat (2) @(posedge sys_clk);

        // ---------------- check 1+2: range/step sweep + monotonicity ------
        nom_step = STEP_PS;
        min_step = 32'sh7FFFFFFF;
        max_step = 0;
        sum_step = 0;
        neg_cnt  = 0;
        for (c = 0; c < CODES; c = c + 1) begin
            apply_code(0, c, ok);
            measure_delay(0, d);
            delay_tab[c] = d;
        end
        for (c = 1; c < CODES; c = c + 1) begin
            d0 = delay_tab[c] - delay_tab[c-1];
            sum_step = sum_step + d0;
            if (d0 < min_step) min_step = d0;
            if (d0 > max_step) max_step = d0;
            if (d0 <= 0) neg_cnt = neg_cnt + 1;
        end

        // CSV: code,delay_ps,step_ps
        fd_csv = $fopen("sim/outputs/ddr1/dqs_delay_codes.csv", "w");
        $fdisplay(fd_csv, "code,delay_ps,step_ps");
        $fdisplay(fd_csv, "0,%0d,0", delay_tab[0]);
        for (c = 1; c < CODES; c = c + 1)
            $fdisplay(fd_csv, "%0d,%0d,%0d", c, delay_tab[c],
                      delay_tab[c]-delay_tab[c-1]);
        $fclose(fd_csv);

        chk(delay_tab[CODES-1] >= 5000,
            "check1 range >= 5.0 ns");
        chk(neg_cnt == 0, "check1 no negative step");
        chk((sum_step / (CODES-1)) <= 200,
            "check1 average step <= 200 ps");
        chk(max_step <= (nom_step*3)/2,
            "check1 max/nominal step <= 1.5");
        chk(delay_tab[0] <= 20, "check2 code 0 delay ~= 0");
        begin : mono
            ok = 1;
            for (c = 1; c < CODES; c = c + 1)
                if (delay_tab[c] <= delay_tab[c-1]) ok = 0;
            chk(ok == 1, "check2 strictly monotonic across all codes");
        end
        $display("RANGE/STEP: range=%0d ps min_step=%0d ps max_step=%0d ps avg_step=%0d ps nom=%0d ps neg=%0d",
                 delay_tab[CODES-1], min_step, max_step,
                 sum_step/(CODES-1), nom_step, neg_cnt);
        $fdisplay(fd_log, "RANGE/STEP: range=%0d ps min_step=%0d ps max_step=%0d ps avg_step=%0d ps nom=%0d ps neg=%0d",
                  delay_tab[CODES-1], min_step, max_step,
                  sum_step/(CODES-1), nom_step, neg_cnt);

        // ---------------- check 3: handshake -------------------------------
        apply_code(0, 0, ok);        // known baseline code 0
        // request while update_idle=0 must NOT be applied
        tap_value[0*TAP_BITS +: TAP_BITS] = TAP_BITS'(20);
        @(negedge sys_clk);
        tap_valid[0] = 1'b1;         // update_idle still 0
        repeat (5) @(posedge sys_clk);
        @(negedge sys_clk);
        tap_valid[0] = 1'b0;
        measure_delay(0, d);
        chk(d == delay_tab[0],
            "check3 request with update_idle=0 not applied");
        chk(tap_error[0] === 1'b1,
            "check3 tap_error asserts on idle-contract violation");

        // applied on the first idle edge; ready timing
        tap_value[0*TAP_BITS +: TAP_BITS] = TAP_BITS'(10);
        @(negedge sys_clk);
        update_idle = 1'b1;
        tap_valid[0] = 1'b1;
        @(posedge sys_clk);          // apply edge
        for (i = 0; i < SETTLE_CYCLES; i = i + 1) begin
            #(1);
            chk(tap_ready[0] === 1'b0,
                "check3 ready low during settle (cycle)");
            @(posedge sys_clk);
        end
        #(1);
        chk(tap_ready[0] === 1'b1,
            "check3 ready asserts after SETTLE_CYCLES");
        @(posedge sys_clk);          // pending cleared with valid high
        @(negedge sys_clk);
        tap_valid[0] = 1'b0;
        @(posedge sys_clk);
        #(1);
        chk(tap_ready[0] === 1'b0, "check3 ready deasserts after ack");
        @(negedge sys_clk);
        update_idle = 1'b0;
        measure_delay(0, d);
        chk(d == delay_tab[10], "check3 code applied = requested code");

        // back-to-back: request 21, then request 22
        apply_code(0, 21, ok);
        chk(ok == 1, "check3 back-to-back request 21 acked");
        apply_code(0, 22, ok);
        chk(ok == 1, "check3 back-to-back request 22 acked");
        measure_delay(0, d);
        chk(d == delay_tab[22], "check3 back-to-back final code applied");

        // ---------------- check 3b: update_idle drops in ack window ------
        // Exact consumer-contract scenario: request applied, settle done,
        // update_idle drops before the handshake edge.  The request must
        // stay pending and the ack must complete in the next idle window
        // WITHOUT reprogramming (tap_valid && tap_ready is the ack).
        tap_value[0*TAP_BITS +: TAP_BITS] = TAP_BITS'(30);
        @(negedge sys_clk);
        update_idle   = 1'b1;
        tap_valid[0]  = 1'b1;
        @(posedge sys_clk);          // E1: apply code 30
        @(posedge sys_clk);          // E2: settle 2 -> 1
        @(posedge sys_clk);          // E3: settle 1 -> 0, ready opens
        #(1);
        chk(tap_ready[0] === 1'b1,
            "check3b ready window opened before idle drop");
        @(negedge sys_clk);
        update_idle = 1'b0;          // drop idle inside the ack window
        @(posedge sys_clk);          // E4: must NOT consume the request
        #(1);
        chk(tap_ready[0] === 1'b0,
            "check3b ready low after idle drop in ack window");
        repeat (3) @(posedge sys_clk);
        #(1);
        chk(tap_ready[0] === 1'b0,
            "check3b request still pending (not consumed)");
        @(negedge sys_clk);
        update_idle   = 1'b1;        // next idle window, no reprogramming
        #(1);
        chk(tap_ready[0] === 1'b1,
            "check3b ack completes in next idle window");
        @(posedge sys_clk);          // ack edge (tap_valid && tap_ready)
        @(negedge sys_clk);
        tap_valid[0] = 1'b0;
        @(posedge sys_clk);
        #(1);
        chk(tap_ready[0] === 1'b0,
            "check3b ready deasserts after delayed ack");
        @(negedge sys_clk);
        update_idle = 1'b0;
        measure_delay(0, d);
        chk(d == delay_tab[30],
            "check3b code applied once, not reprogrammed");

        // ---------------- check 4: glitch-free updates, input low ----------
        mon_glitch = 1'b1;
        glitch_cnt[0] = 0;
        dqs_in[0] = 1'b0;
        for (c = 0; c < CODES; c = c + 1) begin
            apply_code(0, c, ok);
        end
        #(1000);
        mon_glitch = 1'b0;
        chk(glitch_cnt[0] == 0,
            "check4 zero DQS_CAPTURE edges during full-range update sweep");

        // ---------------- check 5: static low + burst ----------------------
        apply_code(0, 15, ok);       // known code for the burst checks
        dqs_in[0] = 1'b0;
        update_idle = 1'b1;
        tap_valid[0] = 1'b0;
        repeat (20) @(posedge sys_clk);
        chk(dqs_capture[0] === 1'b0 && dqs_capture[1] === 1'b0,
            "check5 DQS_IN static low 20 cycles -> capture static low");

        // burst of 8 edges (4 rise + 4 fall), 8 ns half-period
        cap_rise_cnt[0] = 0; cap_fall_cnt[0] = 0;
        in_rise_cnt[0] = 0;  in_fall_cnt[0] = 0;
        mon_edges = 1'b1;
        dqs_in[0] = 1'b1;  #(8000);
        dqs_in[0] = 1'b0;  #(8000);
        dqs_in[0] = 1'b1;  #(8000);
        dqs_in[0] = 1'b0;  #(8000);
        dqs_in[0] = 1'b1;  #(8000);
        dqs_in[0] = 1'b0;  #(8000);
        dqs_in[0] = 1'b1;  #(8000);
        dqs_in[0] = 1'b0;
        t_burst_start = 0;
        #(MAX_DELAY_PS + 1000);      // let the delayed last edge land
        mon_edges = 1'b0;
        chk(in_rise_cnt[0] == 4 && in_fall_cnt[0] == 4,
            "check5 burst driven (8 edges)");
        chk(cap_rise_cnt[0] == 4 && cap_fall_cnt[0] == 4,
            "check5 burst edges preserved on capture (no extra/missing)");
        measure_delay(0, d);
        chk(d == delay_tab[15],
            "check5 post-burst delay still = applied code delay");

        // ---------------- check 6: mid-burst update attempt ----------------
        @(negedge sys_clk);
        update_idle = 1'b0;              // burst active
        cap_rise_cnt[0] = 0; cap_fall_cnt[0] = 0;
        in_rise_cnt[0] = 0;  in_fall_cnt[0] = 0;
        mon_edges = 1'b1;
        tap_value[0*TAP_BITS +: TAP_BITS] = TAP_BITS'(3);  // attempted change
        @(negedge sys_clk);
        tap_valid[0] = 1'b1;
        dqs_in[0] = 1'b1;  #(8000);
        @(negedge sys_clk);
        tap_valid[0] = 1'b0;
        dqs_in[0] = 1'b0;  #(8000);
        dqs_in[0] = 1'b1;  #(8000);
        dqs_in[0] = 1'b0;
        #(MAX_DELAY_PS + 1000);
        mon_edges = 1'b0;
        chk(in_rise_cnt[0] == 2 && in_fall_cnt[0] == 2,
            "check6 mid-burst burst driven");
        chk(cap_rise_cnt[0] == 2 && cap_fall_cnt[0] == 2,
            "check6 capture unaffected by mid-burst tap_valid");
        chk(tap_error[0] === 1'b1,
            "check6 tap_error asserts on mid-burst request");
        measure_delay(0, d);
        chk(d == delay_tab[15],
            "check6 code unchanged after mid-burst tap_valid attempt");

        // ---------------- check 7: multi-lane independence -----------------
        apply_code(0, 7, ok);
        apply_code(1, 23, ok);
        measure_delay(0, d);
        chk(d == delay_tab[7], "check7 lane0 delay = its own code");
        measure_delay(1, d);
        chk(d == delay_tab[23], "check7 lane1 delay = its own code");
        chk(d == 23*STEP_PS, "check7 lane1 delay matches model");
        apply_code(1, 25, ok);
        measure_delay(0, d);
        chk(d == delay_tab[7],
            "check7 lane0 unaffected by lane1 re-program");

        // ---------------- check 8: reset returns code 0 --------------------
        @(negedge sys_clk);
        rst = 1'b1;
        update_idle = 1'b0;
        repeat (3) @(posedge sys_clk);
        @(negedge sys_clk);
        rst = 1'b0;
        update_idle = 1'b1;
        repeat (2) @(posedge sys_clk);
        measure_delay(0, d);
        chk(d <= 10, "check8 reset selects code 0 (minimum delay)");

        // ---------------- summary ------------------------------------------
        $fdisplay(fd_log, "SUMMARY: errors=%0d", errors);
        $display("=== TB done, errors=%0d ===", errors);
        $fclose(fd_log);
        if (errors != 0) begin
            $fatal(1, "ddr1_dqs_delay_tb FAILED");
        end
        $finish;
    end

    // global watchdog
    initial begin
        #(60_000_000);
        $display("FAIL: global timeout");
        $fatal(1, "global watchdog timeout");
    end
endmodule
`default_nettype wire
