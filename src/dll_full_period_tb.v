// Route B full-period DLL regression.
//
// The lock DUTs use the 4-segment DCDL delays measured by OpenSTA, as a
// linear surrogate of the real code->delay map:
//   TT: T0=2930 ps, CELL=30 ps, EXTRA=62 ps, 5 ns code ~67
//   SS: T0=3320 ps, CELL=52 ps, EXTRA=75 ps, 5 ns code ~31
//   FF: T0=2780 ps, CELL=20 ps, EXTRA=70 ps, 5 ns code ~108
// The line is the segmented DLL_DCDL, so coarse=code/56 and fine=code%56;
// the boundary step is CELL+EXTRA rather than a hidden linear fit.
// These are behavioral numbers from the STA range, not silicon.
//
// Rejection DUTs:
//   0T   : line cannot reach 5 ns at all (max 0.28 ns)
//   0.5T : line cannot reach 5 ns at all (max 2.51 ns)
//   2T   : line cannot go below 8.5 ns (min 8.5 ns)
//   2TS  : line starts at 2T (10.6 ns) but can reach 5 ns; acquisition must
//          find 1T, and the absolute delay must come out ~5 ns, not ~10 ns.
//
// The DLL must lock at 5 ns in TT/SS/FF, and no 0T/0.5T/2T DUT may ever
// assert LOCKED, PHASE_OK or RANGE_OK.
`timescale 1ns/1ps

module dll_full_period_tb;
    reg REF = 1'b0;
    always #2.5 REF = ~REF;
    reg REF4 = 1'b0;
    always #2.0 REF4 = ~REF4;    // 4 ns input, must also lock at one period
    reg TICK = 1'b0;
    always #0.05 TICK = ~TICK;   // 10 GHz TDC

    reg rst = 1'b1;

    wire out_tt, out_ss, out_ff, out_2s;
    wire locked_tt, locked_ss, locked_ff, locked_2s;
    wire phase_tt, phase_ss, phase_ff, phase_2s;
    wire range_tt, range_ss, range_ff, range_2s;
    wire railed_tt, railed_ss, railed_ff, railed_2s;
    wire alive_tt, alive_ss, alive_ff, alive_2s;
    wire [8:0] code_tt, code_ss, code_ff, code_2s;
    wire up_tt, dn_tt;
    wire acq_busy_tt, acq_ok_tt, acq_fail_tt;
    wire acq_ok_2s, acq_fail_2s;

    wire out_4n, locked_4n, phase_4n, range_4n, railed_4n, alive_4n;
    wire [8:0] code_4n;
    wire acq_ok_4n, acq_fail_4n;

    wire out_0t, out_half, out_2t;
    wire locked_0t, locked_half, locked_2t;
    wire phase_0t, phase_half, phase_2t;
    wire range_0t, range_half, range_2t;
    wire railed_0t, railed_half, railed_2t;
    wire alive_0t, alive_half, alive_2t;
    wire [8:0] code_0t, code_half, code_2t;
    wire acq_ok_0t, acq_fail_0t;
    wire acq_ok_half, acq_fail_half;
    wire acq_ok_2t, acq_fail_2t;

    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(2930), .CELL_PS(30), .EXTRA_PS(62),
        .CODE_MIN(45), .CODE_MAX(116),         .LOCK_COUNT(16), .COMMIT_GUARD_PS(1800)
    ) u_tt (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd88),
        .OUT(out_tt), .LOCKED(locked_tt), .PHASE_OK(phase_tt),
        .RANGE_OK(range_tt), .CODE_RAILED(railed_tt), .ALIVE(alive_tt),
        .CODE(code_tt), .PFD_UP(up_tt), .PFD_DN(dn_tt),
        .ACQ_BUSY(acq_busy_tt), .ACQ_OK(acq_ok_tt), .ACQ_FAIL(acq_fail_tt)
    );

    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(3320), .CELL_PS(52), .EXTRA_PS(75),
        .CODE_MIN(20), .CODE_MAX(61),         .LOCK_COUNT(16), .COMMIT_GUARD_PS(3000)
    ) u_ss (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd44),
        .OUT(out_ss), .LOCKED(locked_ss), .PHASE_OK(phase_ss),
        .RANGE_OK(range_ss), .CODE_RAILED(railed_ss), .ALIVE(alive_ss),
        .CODE(code_ss), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(), .ACQ_FAIL()
    );

    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(2780), .CELL_PS(20), .EXTRA_PS(70),
        .CODE_MIN(72), .CODE_MAX(176),         .LOCK_COUNT(16), .COMMIT_GUARD_PS(1200)
    ) u_ff (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd134),
        .OUT(out_ff), .LOCKED(locked_ff), .PHASE_OK(phase_ff),
        .RANGE_OK(range_ff), .CODE_RAILED(railed_ff), .ALIVE(alive_ff),
        .CODE(code_ff), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(), .ACQ_FAIL()
    );

    // Starts at 2T (10.6 ns), can reach 1T.
    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(0), .CELL_PS(75), .EXTRA_PS(0),
        .CODE_MIN(0), .CODE_MAX(279),         .LOCK_COUNT(16), .COMMIT_GUARD_PS(3000)
    ) u_2s (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd139),
        .OUT(out_2s), .LOCKED(locked_2s), .PHASE_OK(phase_2s),
        .RANGE_OK(range_2s), .CODE_RAILED(railed_2s), .ALIVE(alive_2s),
        .CODE(code_2s), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(acq_ok_2s), .ACQ_FAIL(acq_fail_2s)
    );

    // 4 ns input: TT line covers it; the target is the measured REF period.
    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(2930), .CELL_PS(30), .EXTRA_PS(62),
        .CODE_MIN(0), .CODE_MAX(116),         .LOCK_COUNT(16), .COMMIT_GUARD_PS(1800)
    ) u_4n (
        .REF(REF4), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd31),
        .OUT(out_4n), .LOCKED(locked_4n), .PHASE_OK(phase_4n),
        .RANGE_OK(range_4n), .CODE_RAILED(railed_4n), .ALIVE(alive_4n),
        .CODE(code_4n), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(acq_ok_4n), .ACQ_FAIL(acq_fail_4n)
    );

    // 0T: max delay 0.28 ns.
    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(0), .CELL_PS(1), .EXTRA_PS(0),
        .CODE_MIN(0), .CODE_MAX(279),         .LOCK_COUNT(16), .COMMIT_GUARD_PS(1200)
    ) u_0t (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd10),
        .OUT(out_0t), .LOCKED(locked_0t), .PHASE_OK(phase_0t),
        .RANGE_OK(range_0t), .CODE_RAILED(railed_0t), .ALIVE(alive_0t),
        .CODE(code_0t), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(acq_ok_0t), .ACQ_FAIL(acq_fail_0t)
    );

    // 0.5T: max delay 2.51 ns.
    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(0), .CELL_PS(9), .EXTRA_PS(0),
        .CODE_MIN(0), .CODE_MAX(279),         .LOCK_COUNT(16), .COMMIT_GUARD_PS(1200)
    ) u_half (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd139),
        .OUT(out_half), .LOCKED(locked_half), .PHASE_OK(phase_half),
        .RANGE_OK(range_half), .CODE_RAILED(railed_half), .ALIVE(alive_half),
        .CODE(code_half), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(acq_ok_half), .ACQ_FAIL(acq_fail_half)
    );

    // 2T: min delay 8.5 ns, never reaches 1T.
    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(8500), .CELL_PS(30), .EXTRA_PS(0),
        .CODE_MIN(0), .CODE_MAX(279),         .LOCK_COUNT(16), .COMMIT_GUARD_PS(1800)
    ) u_2t (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd139),
        .OUT(out_2t), .LOCKED(locked_2t), .PHASE_OK(phase_2t),
        .RANGE_OK(range_2t), .CODE_RAILED(railed_2t), .ALIVE(alive_2t),
        .CODE(code_2t), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(acq_ok_2t), .ACQ_FAIL(acq_fail_2t)
    );

    // Phase monitor: time of the last OUT edge minus the last REF edge.
    real ref_t_tt, ph_tt;
    real ref_t_ss, ph_ss;
    real ref_t_ff, ph_ff;
    real ref_t_2s, ph_2s;
    real ref_t_4n, ph_4n;
    always @(posedge REF) begin
        ref_t_tt = $realtime;
        ref_t_ss = $realtime;
        ref_t_ff = $realtime;
        ref_t_2s = $realtime;
    end
    always @(posedge REF4) ref_t_4n = $realtime;
    always @(posedge out_4n) begin
        ph_4n = $realtime - ref_t_4n;
        if (ph_4n < 0.0) ph_4n = ph_4n + 4.0;
    end
    always @(posedge out_tt) begin
        ph_tt = $realtime - ref_t_tt;
        if (ph_tt < 0.0) ph_tt = ph_tt + 5.0;
    end
    always @(posedge out_ss) begin
        ph_ss = $realtime - ref_t_ss;
        if (ph_ss < 0.0) ph_ss = ph_ss + 5.0;
    end
    always @(posedge out_ff) begin
        ph_ff = $realtime - ref_t_ff;
        if (ph_ff < 0.0) ph_ff = ph_ff + 5.0;
    end
    always @(posedge out_2s) begin
        ph_2s = $realtime - ref_t_2s;
        if (ph_2s < 0.0) ph_2s = ph_2s + 5.0;
    end

    // Any false lock on a reject DUT is a hard failure.
    reg false_lock_seen = 1'b0;
    reg reject_phase_seen = 1'b0;
    always @(posedge REF) begin
        if (locked_0t || locked_half || locked_2t)
            false_lock_seen = 1'b1;
        if (phase_0t || phase_half || phase_2t)
            reject_phase_seen = 1'b1;
    end

    integer errors = 0;
    integer k;

    task check_phase;
        input real ph;
        input real expected;
        input real period;
        input [8*16-1:0] name;
        real e1, e2;
        begin
            e1 = ph - expected;
            if (e1 < 0.0) e1 = -e1;
            e2 = period - e1;
            if (e2 < 0.0) e2 = -e2;
            if (e1 > 0.5 && e2 > 0.5) begin
                $display("FAIL: %0s phase=%0.3f ns expected~%0.3f",
                         name, ph, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s phase=%0.3f ns", name, ph);
            end
        end
    endtask

    task wait_locked;
        input integer which;
        input [8*16-1:0] name;
        reg locked;
        begin
            for (k = 0; k < 3000; k = k + 1) begin
                @(posedge REF);
                case (which)
                    0: locked = locked_tt;
                    1: locked = locked_ss;
                    2: locked = locked_ff;
                    3: locked = locked_2s;
                    default: locked = locked_4n;
                endcase
                if (locked) disable wait_locked;
            end
            $display("FAIL: %0s did not lock", name);
            errors = errors + 1;
        end
    endtask

    task wait_reject;
        begin
            for (k = 0; k < 4000; k = k + 1) begin
                @(posedge REF);
                if (acq_fail_0t && acq_fail_half && acq_fail_2t)
                    disable wait_reject;
            end
            $display("FAIL: rejection DUTs did not finish acquisition");
            errors = errors + 1;
        end
    endtask

    initial begin
        #1 rst = 1'b0;
        #20 rst = 1'b1;

        wait_locked(0, "TT");
        wait_locked(1, "SS");
        wait_locked(2, "FF");
        wait_locked(3, "2T-start");
        wait_locked(4, "4ns");
        wait_reject;
        // Let the reject DUTs run far beyond LOCK_COUNT.
        repeat (200) @(posedge REF);

        $display("TT: LOCKED=%b PHASE_OK=%b RANGE_OK=%b RAILED=%b ALIVE=%b CODE=%0d phase=%0.3f",
                 locked_tt, phase_tt, range_tt, railed_tt, alive_tt,
                 code_tt, ph_tt);
        $display("SS: LOCKED=%b PHASE_OK=%b RANGE_OK=%b RAILED=%b ALIVE=%b CODE=%0d phase=%0.3f",
                 locked_ss, phase_ss, range_ss, railed_ss, alive_ss,
                 code_ss, ph_ss);
        $display("FF: LOCKED=%b PHASE_OK=%b RANGE_OK=%b RAILED=%b ALIVE=%b CODE=%0d phase=%0.3f",
                 locked_ff, phase_ff, range_ff, railed_ff, alive_ff,
                 code_ff, ph_ff);
        $display("2T-start: LOCKED=%b PHASE_OK=%b RANGE_OK=%b RAILED=%b ALIVE=%b CODE=%0d phase=%0.3f acq_delay=%0d ticks",
                 locked_2s, phase_2s, range_2s, railed_2s, alive_2s,
                 code_2s, ph_2s, u_2s.acq_delay);
        $display("4ns:  LOCKED=%b PHASE_OK=%b RANGE_OK=%b RAILED=%b ALIVE=%b CODE=%0d phase=%0.3f period=%0d ticks",
                 locked_4n, phase_4n, range_4n, railed_4n, alive_4n,
                 code_4n, ph_4n, u_4n.period_ticks);

        $display("0T:   LOCKED=%b PHASE_OK=%b RANGE_OK=%b RAILED=%b ACQ_OK=%b ACQ_FAIL=%b CODE=%0d delay=%0d ticks",
                 locked_0t, phase_0t, range_0t, railed_0t,
                 acq_ok_0t, acq_fail_0t, code_0t, u_0t.acq_delay);
        $display("0.5T: LOCKED=%b PHASE_OK=%b RANGE_OK=%b RAILED=%b ACQ_OK=%b ACQ_FAIL=%b CODE=%0d delay=%0d ticks",
                 locked_half, phase_half, range_half, railed_half,
                 acq_ok_half, acq_fail_half, code_half, u_half.acq_delay);
        $display("2T:   LOCKED=%b PHASE_OK=%b RANGE_OK=%b RAILED=%b ACQ_OK=%b ACQ_FAIL=%b CODE=%0d delay=%0d ticks",
                 locked_2t, phase_2t, range_2t, railed_2t,
                 acq_ok_2t, acq_fail_2t, code_2t, u_2t.acq_delay);

        check_phase(ph_tt, 5.0, 5.0, "TT lock");
        check_phase(ph_ss, 5.0, 5.0, "SS lock");
        check_phase(ph_ff, 5.0, 5.0, "FF lock");
        check_phase(ph_2s, 5.0, 5.0, "2T-start lock");
        check_phase(ph_4n, 4.0, 4.0, "4ns lock");

        if (!(locked_tt && locked_ss && locked_ff && locked_2s && locked_4n)) begin
            $display("FAIL: a lock corner did not assert LOCKED");
            errors = errors + 1;
        end
        if (!(acq_ok_tt && acq_ok_2s && acq_ok_4n)) begin
            $display("FAIL: a lock corner did not complete acquisition");
            errors = errors + 1;
        end
        if (false_lock_seen) begin
            $display("FAIL: a 0T/0.5T/2T DUT asserted LOCKED");
            errors = errors + 1;
        end
        if (reject_phase_seen) begin
            $display("FAIL: a 0T/0.5T/2T DUT asserted PHASE_OK");
            errors = errors + 1;
        end
        if (locked_0t || locked_half || locked_2t ||
            range_0t || range_half || range_2t ||
            phase_0t || phase_half || phase_2t) begin
            $display("FAIL: reject DUT lock terms not clear at the end");
            errors = errors + 1;
        end
        if (!(acq_fail_0t && acq_fail_half && acq_fail_2t)) begin
            $display("FAIL: a 0T/0.5T/2T DUT did not report ACQ_FAIL");
            errors = errors + 1;
        end
        if (!(railed_0t && railed_half && railed_2t)) begin
            $display("FAIL: a reject DUT did not rail its code");
            errors = errors + 1;
        end
        // The absolute acquisition must have picked ~1T, never ~2T.
        if (u_2s.acq_delay > 60) begin
            $display("FAIL: 2T-start acquisition locked the 2T tap (acq_delay=%0d)",
                     u_2s.acq_delay);
            errors = errors + 1;
        end
        if (code_2s > 80) begin
            $display("FAIL: 2T-start settled at code %0d (not 1T)", code_2s);
            errors = errors + 1;
        end

        if (errors != 0) $fatal(1, "dll_full_period_tb failed");
        $display("dll_full_period_tb: PASS");
        $finish;
    end
endmodule
