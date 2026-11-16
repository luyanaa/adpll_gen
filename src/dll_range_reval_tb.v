// Route B DLL range-revalidation and missing-edge regression.
//
// 1. Lock at 5 ns.
// 2. Step REF to 6 ns.  The monitor line still runs at the old code, so its
//    absolute delay is outside the new period window; the DLL must drop
//    RANGE_OK/LOCKED and re-acquire at 6 ns.
// 3. Force the main line output low; ALIVE and LOCKED must drop.  Release
//    and the DLL must re-lock.
`timescale 1ns/1ps

module dll_range_reval_tb;
    real half_ns = 2.5;              // 5 ns, later 6 ns
    reg REF = 1'b0;
    always begin
        #(half_ns) REF = 1'b0;
        #(half_ns) REF = 1'b1;
    end
    reg TICK = 1'b0;
    always #0.05 TICK = ~TICK;       // 10 GHz TDC

    reg rst = 1'b1;
    wire out, locked, ph_ok, rng, rail, alive, busy, acq_ok, acq_fail;
    wire [8:0] code;

    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(2930), .CELL_PS(30), .EXTRA_PS(62),
        .CODE_MIN(20), .CODE_MAX(170),         .LOCK_COUNT(16), .COMMIT_GUARD_PS(1800)
    ) u (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd88),
        .OUT(out), .LOCKED(locked), .PHASE_OK(ph_ok), .RANGE_OK(rng),
        .CODE_RAILED(rail), .ALIVE(alive), .CODE(code),
        .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(busy), .ACQ_OK(acq_ok), .ACQ_FAIL(acq_fail)
    );

    real ref_t, ph;
    always @(posedge REF) ref_t = $realtime;
    always @(posedge out) begin
        ph = $realtime - ref_t;
        if (ph < 0.0) ph = ph + 6.0;
    end

    integer errors = 0;
    integer k;

    task wait_locked;
        input integer want;
        input integer limit;
        input [8*8-1:0] name;
        begin
            for (k = 0; k < limit; k = k + 1) begin
                @(posedge REF);
                if (locked === want[0]) disable wait_locked;
            end
            $display("FAIL: %0s did not reach LOCKED=%0d", name, want);
            errors = errors + 1;
        end
    endtask

    initial begin
        #1 rst = 1'b0;
        #20 rst = 1'b1;

        wait_locked(1, 4000, "initial 5 ns lock");
        $display("5ns: LOCKED=%b PERIOD=%0d CODE=%0d phase=%0.3f",
                 locked, u.period_ticks, code, ph);
        if (u.period_ticks < 45 || u.period_ticks > 55) begin
            $display("FAIL: 5 ns period measurement %0d", u.period_ticks);
            errors = errors + 1;
        end

        // Step the reference period.  The old code is ~5 ns, which is
        // outside the 6 ns window; the monitor must invalidate it.
        half_ns = 3.0;
        wait_locked(0, 3000, "range drop after 6 ns step");
        wait_locked(1, 6000, "re-lock at 6 ns");
        #1;
        $display("6ns: LOCKED=%b PERIOD=%0d CODE=%0d phase=%0.3f RANGE=%b",
                 locked, u.period_ticks, code, ph, rng);
        if (u.period_ticks < 55 || u.period_ticks > 65) begin
            $display("FAIL: 6 ns period measurement %0d", u.period_ticks);
            errors = errors + 1;
        end
        if (ph > 0.5 && ph < 5.5) begin
            $display("FAIL: 6 ns phase not at full period, ph=%0.3f", ph);
            errors = errors + 1;
        end

        // Wrong-phase extra edge: force a high pulse at half a period.
        @(posedge REF);
        #(half_ns + 1.0);   // clear of the previous high + 2-FF sync window
        force u.main_out = 1'b1;
        #0.2;
        force u.main_out = 1'b0;
        #0.2;
        release u.main_out;
        repeat (8) @(posedge REF);
        if (ph_ok !== 1'b0 || locked !== 1'b0) begin
            $display("FAIL: wrong-phase extra edge did not drop PHASE_OK/LOCKED, %b/%b",
                     ph_ok, locked);
            errors = errors + 1;
        end else begin
            $display("PASS: wrong-phase extra edge rejected");
        end
        wait_locked(1, 4000, "re-lock after wrong edge");

        // Missing main output edge: force the line output low.
        force u.main_out = 1'b0;
        repeat (8) @(posedge REF);
        if (alive !== 1'b0 || locked !== 1'b0 || ph_ok !== 1'b0) begin
            $display("FAIL: missing-edge did not drop ALIVE/PHASE_OK/LOCKED, %b/%b/%b",
                     alive, ph_ok, locked);
            errors = errors + 1;
        end else begin
            $display("PASS: missing output edge dropped ALIVE/PHASE_OK/LOCKED");
        end
        release u.main_out;
        wait_locked(1, 4000, "re-lock after edge restore");
        $display("restore: LOCKED=%b PERIOD=%0d CODE=%0d phase=%0.3f",
                 locked, u.period_ticks, code, ph);

        if (errors != 0) $fatal(1, "dll_range_reval_tb failed");
        $display("dll_range_reval_tb: PASS");
        $finish;
    end
endmodule
