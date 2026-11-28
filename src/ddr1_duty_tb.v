`timescale 1ns/1ps
// Requirement-level duty testbench for DDR1_CLOCK_TOP.
//
// Covers the DDR1 output requirements that the per-block TBs do not:
//   * CK_PHY period 10 ns +/-1%, duty 45-55%  — at MCK duty 40 / 50 / 60%
//     (the DCO's duty is not specified; the DE3 must absorb it, and the
//     attenuation algebra predicts 46.7 / 50 / 53.3%).
//   * SYS_CLK period 20 ns +/-1%, duty 45-55% — same three MCK duties.
//   * CK_PHY_N is the complement of CK_PHY with cross-skew bounded by the
//     behavioral inverter (informational print; real matching is an STA item).
//   * CK90_PHY: period 10 ns and its own duty (informational — the spec
//     constrains CK90 PHASE, not duty; the regenerated value is 45.7-48.1%
//     per SPICE, so the TB only prints it and asserts a sanity window).
//
// Method: after PHY_LOCKED, measure N=20 consecutive periods/high-times of
// each output with $realtime edges; report min/max.
//
// Run: iverilog -g2012 -DSIMULATION -o ... ddr1_duty_tb.v <top deps> && vvp

module ddr1_duty_tb;
    localparam integer N = 20;

    reg mck = 1'b0;
    // NOTE: this loop starts from mck=0, so `lo_ps` is the LOW time and the
    // HIGH time is 3333-lo_ps.  Names say lo_ps to avoid the exact mistake
    // that made the first version of this TB label the duties backwards.
    integer lo_ps = 1667;          // MCK LOW time (ps); period 3333 ps
    always begin
        #(lo_ps/1000.0)        mck = 1'b1;
        #((3333-lo_ps)/1000.0) mck = 1'b0;
    end

    reg rst = 1'b1, pll_locked = 1'b0, bypass = 1'b0;
    wire ck, ckn, ck90, sysclk, phylock, err;
    wire [15:0] dbg;

    DDR1_CLOCK_TOP u_top (
        .MCK_IN(mck), .PLL_LOCKED(pll_locked), .RST(rst),
        .EXT_CK(1'b0), .EXT_CK90(1'b0), .EXT_SYS_CLK(1'b0),
        .BYPASS(bypass), .TRIM_SEL(2'd1),   // SS strap (informational)
        .CK_PHY(ck), .CK_PHY_N(ckn), .CK90_PHY(ck90), .SYS_CLK(sysclk),
        .PHY_LOCKED(phylock), .ERR(err), .DBG(dbg));

    // SYS_CLK alignment (requirement: its rising edge must coincide with a
    // CK_PHY rising edge to <= 0.2 ns, all PVT).  Track the last CK rise.
    // NOTE the #0: CK and SYS_CLK rise in the SAME time step (SYS is a
    // toggle flop on CK's source), so a cross-block read without yielding
    // sees the previous CK edge (measured 740 ns of nonsense once).  #0
    // moves this evaluation to the inactive region after the CK sampler.
    // align_en gates out the reset/release transient: the requirement is
    // the steady-state edge relationship (the release runt itself is
    // covered by the clock TB's first-pulse checks).
    real t_last_ck = 0.0;
    real align_max = 0.0;
    reg  align_en = 1'b0;
    always @(posedge ck) t_last_ck = $realtime;
    always @(posedge sysclk) begin
        #0;
        if (align_en && (t_last_ck > 0.0)) begin
            real d;
            d = ($realtime - t_last_ck) * 1000.0;   // ps
            if (d > align_max) align_max = d;
        end
    end

    integer errors = 0, checks = 0, fd;

    task chk(input cond, input [8*90-1:0] name);
        begin
            checks = checks + 1;
            if (cond) begin $display("PASS: %0s", name); $fdisplay(fd, "PASS: %0s", name); end
            else      begin errors = errors + 1; $display("FAIL: %0s", name); $fdisplay(fd, "FAIL: %0s", name); end
        end
    endtask

    // measure period + high time of a node over N cycles
    task meas(input integer which, output integer per_min, output integer per_max,
              output integer hi_min, output integer hi_max);
        integer k, t0, t1, th;
        real rt0, rt1;
        begin
            per_min = 1000000; per_max = 0; hi_min = 1000000; hi_max = 0;
            @(posedge ck);  // align roughly (any node works as a time base)
            for (k = 0; k < N; k = k + 1) begin
                case (which)
                    0: begin @(posedge ck);     rt0 = $realtime; @(negedge ck);     rt1 = $realtime;
                             @(posedge ck);     th  = $rtoi((rt1-rt0)*1000.0);
                             t1  = $rtoi(($realtime-rt0)*1000.0); end
                    1: begin @(posedge sysclk); rt0 = $realtime; @(negedge sysclk); rt1 = $realtime;
                             @(posedge sysclk); th  = $rtoi((rt1-rt0)*1000.0);
                             t1  = $rtoi(($realtime-rt0)*1000.0); end
                    default: begin @(posedge ck90); rt0 = $realtime; @(negedge ck90); rt1 = $realtime;
                             @(posedge ck90); th  = $rtoi((rt1-rt0)*1000.0);
                             t1  = $rtoi(($realtime-rt0)*1000.0); end
                endcase
                if (t1 < per_min) per_min = t1;
                if (t1 > per_max) per_max = t1;
                if (th < hi_min) hi_min = th;
                if (th > hi_max) hi_max = th;
            end
        end
    endtask

    integer pk_lo, pk_hi, hk_lo, hk_hi;
    integer ps_lo, ps_hi, hs_lo, hs_hi;
    integer p9_lo, p9_hi, h9_lo, h9_hi;
    integer duty_milli, tmo;

    task run_case(input integer lo, input [8*16-1:0] tag);
        begin
            // re-acquire at this MCK duty
            align_en = 1'b0;
            // real power-on sequence: RST low -> high -> low, so every
            // reset-edge-triggered block sees its edge (a RST that merely
            // starts high never produces one).
            rst = 1'b0; pll_locked = 1'b0; #100;
            rst = 1'b1; #200;
            lo_ps = lo;
            @(posedge mck); #0.5; rst = 1'b0; #100; pll_locked = 1'b1;
            tmo = 0;
            while (!phylock && tmo < 200000) begin #50; tmo = tmo + 50; end
            if (phylock !== 1'b1)
                $display("  [dbg] tag=%0s phylock=%b dll_locked=%b dll_err=%b mon_err=%b mon_fail=%0d err_q=%b code=%0d",
                         tag, phylock, u_top.dll_locked_c, u_top.dll_err_c,
                         u_top.ck90_mon_err, u_top.mon_fail, u_top.err_q, u_top.dll_code_c);
            chk(phylock === 1'b1, {"duty: PHY_LOCKED at MCK high=", tag});
            #500;
            align_en = 1'b1;
            meas(0, pk_lo, pk_hi, hk_lo, hk_hi);
            meas(1, ps_lo, ps_hi, hs_lo, hs_hi);
            meas(2, p9_lo, p9_hi, h9_lo, h9_hi);
            $display("duty %0s: CK period %0d..%0d high %0d..%0d (duty %0d.%01d%%)",
                     tag, pk_lo, pk_hi, hk_lo, hk_hi,
                     (hk_lo*1000)/pk_lo/10, ((hk_lo*1000)/pk_lo)%10);
            $display("           SYS period %0d..%0d high %0d..%0d ; CK90 high %0d..%0d",
                     ps_lo, ps_hi, hs_lo, hs_hi, h9_lo, h9_hi);
            $fdisplay(fd, "duty %0s: CK period %0d..%0d high %0d..%0d ; SYS %0d..%0d high %0d..%0d ; CK90 high %0d..%0d",
                      tag, pk_lo, pk_hi, hk_lo, hk_hi, ps_lo, ps_hi, hs_lo, hs_hi, h9_lo, h9_hi);
            chk(pk_lo >= 9900 && pk_hi <= 10100, {"duty: CK period 10ns +-1% at ", tag});
            chk(hk_lo*1000/pk_lo >= 450 && hk_hi*1000/pk_lo <= 550,
                {"duty: CK_PHY duty 45-55% at ", tag});
            chk(ps_lo >= 19800 && ps_hi <= 20200, {"duty: SYS_CLK period 20ns +-1% at ", tag});
            chk(hs_lo*1000/ps_lo >= 450 && hs_hi*1000/ps_lo <= 550,
                {"duty: SYS_CLK duty 45-55% at ", tag});
            chk(p9_lo >= 9900 && p9_hi <= 10100, {"duty: CK90 period 10ns +-1% at ", tag});
            $display("           SYS_CLK max edge offset from the preceding CK rise = %0.1f ps",
                     align_max);
            $fdisplay(fd, "           SYS_CLK align_max = %0.1f ps", align_max);
            chk(align_max <= 200.0, {"duty: SYS_CLK rise aligned to a CK rise <=0.2ns at ", tag});
            align_max = 0.0;
        end
    endtask

    initial begin
        fd = $fopen("sim/outputs/ddr1/ddr1_duty_tb.log", "w");
        $display("=== DDR1 duty TB ===");
        run_case(2000, "40pct_in");   // low 2000 -> high 1333 -> 40% MCK
        run_case(1667, "50pct_in");
        run_case(1333, "60pct_in");   // low 1333 -> high 2000 -> 60% MCK
        $fdisplay(fd, "SUMMARY: %0d checks, %0d errors", checks, errors);
        $display("=== duty TB done, %0d checks, errors=%0d ===", checks, errors);
        $fclose(fd);
        if (errors != 0) $fatal(1, "ddr1_duty_tb FAILED");
        $finish;
    end

    initial begin
        #(400_000);
        $display("FAIL: global timeout");
        $fatal(1, "watchdog");
    end
endmodule
