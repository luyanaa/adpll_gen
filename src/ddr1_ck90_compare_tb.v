// ddr1_ck90_compare_tb — A/B comparison of the two DDR1 CK90 candidates
// under injected duty error and negedge skew (pass 1 behavioral).
//
//   Candidate A: DDR1_CK90_DE2 (dual-edge divide-by-2)
//   Candidate B: DDR1_CK90_DLL (master/slave ratio DLL, CKIN = CK of A)
//
// Injection is in the TB, not the RTL: MCK (200 MHz) is generated with a
// parameterizable high-time distortion.  In pass 1 both effects are
// lumped as a displacement of the MCK falling edge at the module input:
//   * DUTY_ERR_PS  : MCK duty error (high time = 2500 + DUTY_ERR_PS ps)
//   * NEGEDGE_SKEW_PS : extra delay of the negedge distribution path
// Both shift the falling edge the dividers see by the same amount, so the
// candidate-A CK90-CK lag becomes 2500 + DUTY_ERR_PS + NEGEDGE_SKEW_PS.
// A pass-2 flow must separate waveform duty from per-path distribution
// skew (per-net RC/SDF).  Candidate B is fed with CK_A (the posedge
// divider output), whose duty is MCK-duty-error immune by construction,
// so B should stay constant across the matrix.
//
// BLOCKER FIX: candidate B is no longer frozen after lock.  Its bang-bang
// loop keeps running and the code dithers by +/-1 LSB (+/-16 ps at CK90).
// run_case counts post-lock code changes and checks DLL_ERR stays clear, so
// B's phase error in the matrix now includes that small dither while still
// showing duty/skew immunity.
//
// Compile/run (from the repo root):
//   iverilog -g2012 -DSIMULATION -o /tmp/opencode/ddr1_ck90_compare.vvp \
//     src/ddr1_ck90_compare_tb.v src/ddr1_ck90_de2.v src/ddr1_ck90_dll.v
//   vvp /tmp/opencode/ddr1_ck90_compare.vvp
//
// Outputs:
//   sim/outputs/ddr1/ck90_compare_tb.log  (full log)
//   sim/outputs/ddr1/ck90_ab_matrix.csv   (duty,skew,errA_ps,errB_ps)
`timescale 1ns/1ps

module ddr1_ck90_compare_tb;
    integer fd, cf, errors, checks;

    // MCK generator with injected fall-edge distortion
    real th_ns, tl_ns;
    reg  mck = 1'b0;
    initial begin th_ns = 2.5; tl_ns = 2.5; end
    always begin
        mck = 1'b1; #(th_ns);
        mck = 1'b0; #(tl_ns);
    end

    reg rst = 1'b0;   // starts low; test sequence asserts a real 0->1 edge
    wire ck_a, ck90_a, ck90_b, dll_locked, dll_err;
    wire [8:0] dbg_code;

    DDR1_CK90_DE2 u_a (.MCK(mck), .RST(rst), .EN(1'b1),
                       .CK(ck_a), .CK90(ck90_a));
    DDR1_CK90_DLL #(.NQ_SEG(64), .CODE_BITS(9)) u_b (
        .CKIN(ck_a), .RST(rst), .EN(1'b1),
        .CK90(ck90_b), .DLL_LOCKED(dll_locked), .DLL_ERR(dll_err),
        .DBG_CODE(dbg_code));

    // matrix storage: 4 duty x 3 skew
    real errA [0:11];
    real errB [0:11];
    integer duty_list [0:3];
    integer skew_list [0:2];

    initial begin
        duty_list[0]=0; duty_list[1]=100; duty_list[2]=200; duty_list[3]=400;
        skew_list[0]=0; skew_list[1]=50;  skew_list[2]=100;
    end

    task chk(input cond, input [8*48-1:0] name);
        begin
            checks = checks + 1;
            if (cond) begin
                $display("PASS: %0s", name);
                $fdisplay(fd, "PASS: %0s", name);
            end else begin
                errors = errors + 1;
                $display("FAIL: %0s", name);
                $fdisplay(fd, "FAIL: %0s", name);
            end
        end
    endtask

    // One matrix cell: reconfigure MCK, reset both candidates, wait for
    // DLL lock, average 8 CK90-CK lag measurements per candidate.
    task run_case(input integer d, input integer s, input integer idx);
        real t1, t2, sa, sb, ea, eb;
        integer k, wt, dcnt;
        reg [8:0] prev_code;
        begin
            th_ns = 2.5 + (d + s)/1000.0;
            tl_ns = 5.0 - th_ns;
            rst = 1'b1;
            #30;
            rst = 1'b0;
            // wait for candidate B DLL lock
            wt = 0;
            while (!(dll_locked === 1'b1) && wt < 3000) begin #10; wt = wt + 10; end
            chk(dll_locked === 1'b1, "candidate B DLL locked");
            chk(dll_err === 1'b0,   "candidate B no DLL_ERR");
            #200; // settle
            // BLOCKER FIX check (contract 2026-11-28): the loop holds its
            // code in a dead zone when the residual quantizes to zero
            // (dither broke the CK90 jitter spec); tracking is proven by
            // perturbation instead of by dither.
            prev_code = dbg_code; dcnt = 0;
            for (k = 0; k < 24; k = k + 1) begin
                @(posedge ck_a);
                if (dbg_code !== prev_code) dcnt = dcnt + 1;
                prev_code = dbg_code;
            end
            chk(dcnt == 0, "candidate B code stable in dead zone post-lock");
            begin : track_c
                integer moved; reg [8:0] c_before;
                c_before = dbg_code;
                force u_b.dly_off_x4 = 32'd2;   // > HOLD_PS
                moved = 0;
                for (k = 0; k < 20; k = k + 1) begin
                    @(posedge ck_a); #0.01;
                    if (dbg_code !== c_before) moved = 1;
                end
                chk(moved == 1, "candidate B one-tap offset re-engages tracking");
                release u_b.dly_off_x4; u_b.dly_off_x4 = 32'd0;
            end
            chk(dll_err === 1'b0, "candidate B still no DLL_ERR after tracking");
            sa = 0.0; sb = 0.0;
            for (k = 0; k < 8; k = k + 1) begin
                @(posedge ck_a);   t1 = $realtime;
                @(posedge ck90_a); sa = sa + ($realtime - t1);
            end
            for (k = 0; k < 8; k = k + 1) begin
                @(posedge ck_a);   t1 = $realtime;
                @(posedge ck90_b); sb = sb + ($realtime - t1);
            end
            ea = sa/8.0*1000.0 - 2500.0;
            eb = sb/8.0*1000.0 - 2500.0;
            errA[idx] = ea; errB[idx] = eb;
            $display("MATRIX duty=%0dps skew=%0dps : errA=%0.1f ps  errB=%0.1f ps (code=%0d dither=%0d)",
                     d, s, ea, eb, dbg_code, dcnt);
            $fdisplay(fd, "MATRIX duty=%0dps skew=%0dps : errA=%0.1f ps  errB=%0.1f ps (code=%0d dither=%0d)",
                      d, s, ea, eb, dbg_code, dcnt);
            $fdisplay(cf, "%0d,%0d,%0.1f,%0.1f", d, s, ea, eb);
        end
    endtask

    integer d_i, s_i, idx;
    real ea, eb;
    initial begin
        errors = 0; checks = 0;
        fd = $fopen("sim/outputs/ddr1/ck90_compare_tb.log", "w");
        cf = $fopen("sim/outputs/ddr1/ck90_ab_matrix.csv", "w");
        $fdisplay(cf, "duty_err_ps,negedge_skew_ps,ck90_phase_err_A_ps,ck90_phase_err_B_ps");
        $display("ddr1_ck90_compare_tb: A/B CK90 phase-error matrix");
        $fdisplay(fd, "ddr1_ck90_compare_tb: A/B CK90 phase-error matrix");

        idx = 0;
        for (d_i = 0; d_i < 4; d_i = d_i + 1) begin
            for (s_i = 0; s_i < 3; s_i = s_i + 1) begin
                run_case(duty_list[d_i], skew_list[s_i], idx);
                idx = idx + 1;
            end
        end

        // summary table
        $display("A/B matrix (CK90 phase error vs 2.5 ns, ps):");
        $fdisplay(fd, "A/B matrix (CK90 phase error vs 2.5 ns, ps):");
        $display("duty\\skew |    0     50    100");
        $fdisplay(fd, "duty\\skew |    0     50    100");
        idx = 0;
        for (d_i = 0; d_i < 4; d_i = d_i + 1) begin
            ea = errA[idx]; eb = errB[idx];
            $display("A duty=%0d  | %+7.1f %+7.1f %+7.1f",
                     duty_list[d_i], errA[idx], errA[idx+1], errA[idx+2]);
            $fdisplay(fd, "A duty=%0d  | %+7.1f %+7.1f %+7.1f",
                      duty_list[d_i], errA[idx], errA[idx+1], errA[idx+2]);
            $display("B duty=%0d  | %+7.1f %+7.1f %+7.1f",
                     duty_list[d_i], errB[idx], errB[idx+1], errB[idx+2]);
            $fdisplay(fd, "B duty=%0d  | %+7.1f %+7.1f %+7.1f",
                      duty_list[d_i], errB[idx], errB[idx+1], errB[idx+2]);
            idx = idx + 3;
        end
        // Expected qualitative behavior: A tracks duty+skew linearly, B is
        // (nearly) immune.  Verify A's error follows the injection within
        // 40 ps (transport model is exact; measurement averaging only) and
        // B stays inside +/-100 ps for all cells.
        idx = 0;
        for (d_i = 0; d_i < 4; d_i = d_i + 1) begin
            for (s_i = 0; s_i < 3; s_i = s_i + 1) begin
                ea = errA[idx]; eb = errB[idx];
                chk((ea > (duty_list[d_i]+skew_list[s_i] - 40.0)) &&
                    (ea < (duty_list[d_i]+skew_list[s_i] + 40.0)),
                    "candidate A error tracks duty+skew injection");
                chk((eb > -100.0) && (eb < 100.0),
                    "candidate B error stays within +/-100 ps");
                idx = idx + 1;
            end
        end
        $display("SUMMARY: %0d checks, %0d errors", checks, errors);
        $fdisplay(fd, "SUMMARY: %0d checks, %0d errors", checks, errors);
        $fflush(fd); $fflush(cf);
        $fclose(fd); $fclose(cf);
        if (errors != 0) begin
            $display("RESULT: FAIL");
            $fatal(1, "ddr1_ck90_compare_tb FAILED");
        end else begin
            $display("RESULT: PASS");
            $finish;
        end
    end
endmodule
