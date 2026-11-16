// Route B DLL with the physical delay-line TDC (behavioral cell delays).
//
// TDC_IMPL=1 selects DLL_TDC_PHYS; TDC_LINE_IMPL=0 uses the behavioral
// DLL_DELAY_CELL chain so the architecture and controller can be verified
// before the real-cell/SDF run.  The timestamp unit is one tap (CELL_PS),
// not the 10 GHz simulation tick, so the checks are relative to the measured
// period code.
`timescale 1ns/1ps

module dll_phys_tdc_tb;
    reg REF = 1'b0;
    always #2.5 REF = ~REF;
    reg TICK = 1'b0;
    always #0.05 TICK = ~TICK;  // unused by the phys TDC

    reg rst = 1'b1;

    wire out_tt, out_ss, out_ff, out_2s;
    wire locked_tt, locked_ss, locked_ff, locked_2s;
    wire ph_tt, ph_ss, ph_ff, ph_2s;
    wire rng_tt, rng_ss, rng_ff, rng_2s;
    wire rail_tt, rail_ss, rail_ff, rail_2s;
    wire alive_tt, alive_ss, alive_ff, alive_2s;
    wire [8:0] code_tt, code_ss, code_ff, code_2s;
    wire acq_ok_tt, acq_fail_tt;
    wire acq_ok_2s, acq_fail_2s;

    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(2930), .CELL_PS(30), .EXTRA_PS(62),
        .TDC_IMPL(1), .TDC_LINE_IMPL(0), .TDC_NTAP(320), .TDC_CELL_PS(30),
        .CODE_MIN(45), .CODE_MAX(116),
        .LOCK_COUNT(16), .COMMIT_GUARD_PS(1800)
    ) u_tt (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd88),
        .OUT(out_tt), .LOCKED(locked_tt), .PHASE_OK(ph_tt),
        .RANGE_OK(rng_tt), .CODE_RAILED(rail_tt), .ALIVE(alive_tt),
        .CODE(code_tt), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(acq_ok_tt), .ACQ_FAIL(acq_fail_tt)
    );

    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(3320), .CELL_PS(52), .EXTRA_PS(75),
        .TDC_IMPL(1), .TDC_LINE_IMPL(0), .TDC_NTAP(320), .TDC_CELL_PS(52),
        .CODE_MIN(20), .CODE_MAX(61),
        .LOCK_COUNT(16), .COMMIT_GUARD_PS(3000)
    ) u_ss (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd44),
        .OUT(out_ss), .LOCKED(locked_ss), .PHASE_OK(ph_ss),
        .RANGE_OK(rng_ss), .CODE_RAILED(rail_ss), .ALIVE(alive_ss),
        .CODE(code_ss), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(), .ACQ_FAIL()
    );

    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(2780), .CELL_PS(20), .EXTRA_PS(70),
        .TDC_IMPL(1), .TDC_LINE_IMPL(0), .TDC_NTAP(320), .TDC_CELL_PS(20),
        .CODE_MIN(72), .CODE_MAX(176),
        .LOCK_COUNT(16), .COMMIT_GUARD_PS(1200)
    ) u_ff (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd134),
        .OUT(out_ff), .LOCKED(locked_ff), .PHASE_OK(ph_ff),
        .RANGE_OK(rng_ff), .CODE_RAILED(rail_ff), .ALIVE(alive_ff),
        .CODE(code_ff), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(), .ACQ_FAIL()
    );

    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(0), .CELL_PS(75), .EXTRA_PS(0),
        .TDC_IMPL(1), .TDC_LINE_IMPL(0), .TDC_NTAP(320), .TDC_CELL_PS(75),
        .CODE_MIN(0), .CODE_MAX(279),
        .LOCK_COUNT(16), .COMMIT_GUARD_PS(3000)
    ) u_2s (
        .REF(REF), .RST_N(rst), .EN(1'b1), .TICK(TICK),
        .CODE_START(9'd139),
        .OUT(out_2s), .LOCKED(locked_2s), .PHASE_OK(ph_2s),
        .RANGE_OK(rng_2s), .CODE_RAILED(rail_2s), .ALIVE(alive_2s),
        .CODE(code_2s), .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(acq_ok_2s), .ACQ_FAIL(acq_fail_2s)
    );

    real ref_t_tt, ph_tt_ns, ref_t_ss, ph_ss_ns;
    real ref_t_ff, ph_ff_ns, ref_t_2s, ph_2s_ns;
    always @(posedge REF) begin
        ref_t_tt = $realtime; ref_t_ss = $realtime;
        ref_t_ff = $realtime; ref_t_2s = $realtime;
    end
    always @(posedge out_tt) begin
        ph_tt_ns = $realtime - ref_t_tt;
        if (ph_tt_ns < 0.0) ph_tt_ns = ph_tt_ns + 5.0;
    end
    always @(posedge out_ss) begin
        ph_ss_ns = $realtime - ref_t_ss;
        if (ph_ss_ns < 0.0) ph_ss_ns = ph_ss_ns + 5.0;
    end
    always @(posedge out_ff) begin
        ph_ff_ns = $realtime - ref_t_ff;
        if (ph_ff_ns < 0.0) ph_ff_ns = ph_ff_ns + 5.0;
    end
    always @(posedge out_2s) begin
        ph_2s_ns = $realtime - ref_t_2s;
        if (ph_2s_ns < 0.0) ph_2s_ns = ph_2s_ns + 5.0;
    end

    integer errors = 0;
    integer k;

    task check_phase;
        input real ph;
        input real period;
        input [8*16-1:0] name;
        real e1, e2;
        begin
            e1 = ph - period;
            if (e1 < 0.0) e1 = -e1;
            e2 = period - e1;
            if (e2 < 0.0) e2 = -e2;
            if (e1 > 0.5 && e2 > 0.5) begin
                $display("FAIL: %0s phase=%0.3f expected~%0.3f", name, ph, period);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s phase=%0.3f ns", name, ph);
            end
        end
    endtask

    task wait_locked;
        input integer which;
        input [8*12-1:0] name;
        reg locked;
        begin
            for (k = 0; k < 4000; k = k + 1) begin
                @(posedge REF);
                case (which)
                    0: locked = locked_tt;
                    1: locked = locked_ss;
                    2: locked = locked_ff;
                    default: locked = locked_2s;
                endcase
                if (locked) disable wait_locked;
            end
            $display("FAIL: %0s did not lock", name);
            errors = errors + 1;
        end
    endtask

    initial begin
        #1 rst = 1'b0;
        #20 rst = 1'b1;

        wait_locked(0, "TT phys");
        wait_locked(1, "SS phys");
        wait_locked(2, "FF phys");
        wait_locked(3, "2T-start phys");
        #1;
        $display("TT: LOCKED=%b PHASE=%b RANGE=%b ALIVE=%b CODE=%0d phase=%0.3f period_code=%0d phase_code=%0d",
                 locked_tt, ph_tt, rng_tt, alive_tt, code_tt, ph_tt_ns,
                 u_tt.period_ticks, u_tt.main_stamp);
        $display("SS: LOCKED=%b PHASE=%b RANGE=%b ALIVE=%b CODE=%0d phase=%0.3f period_code=%0d phase_code=%0d",
                 locked_ss, ph_ss, rng_ss, alive_ss, code_ss, ph_ss_ns,
                 u_ss.period_ticks, u_ss.main_stamp);
        $display("FF: LOCKED=%b PHASE=%b RANGE=%b ALIVE=%b CODE=%0d phase=%0.3f period_code=%0d phase_code=%0d",
                 locked_ff, ph_ff, rng_ff, alive_ff, code_ff, ph_ff_ns,
                 u_ff.period_ticks, u_ff.main_stamp);
        $display("2T-start: LOCKED=%b CODE=%0d phase=%0.3f period_code=%0d acq=%0d",
                 locked_2s, code_2s, ph_2s_ns, u_2s.period_ticks,
                 u_2s.acq_delay);

        check_phase(ph_tt_ns, 5.0, "TT phys lock");
        check_phase(ph_ss_ns, 5.0, "SS phys lock");
        check_phase(ph_ff_ns, 5.0, "FF phys lock");
        check_phase(ph_2s_ns, 5.0, "2T-start phys lock");

        if (!(locked_tt && locked_ss && locked_ff && locked_2s)) begin
            $display("FAIL: a phys-TDC corner did not lock");
            errors = errors + 1;
        end
        if (!(acq_ok_tt && acq_ok_2s)) begin
            $display("FAIL: a phys-TDC DUT did not acquire");
            errors = errors + 1;
        end
        // The 2T-start acquisition must settle near one period code, not 2T.
        if (u_2s.acq_delay > (u_2s.period_ticks + (u_2s.period_ticks >> 2))) begin
            $display("FAIL: 2T-start phys acquisition is not 1T, acq=%0d period=%0d",
                     u_2s.acq_delay, u_2s.period_ticks);
            errors = errors + 1;
        end
        if (code_2s > 80) begin
            $display("FAIL: 2T-start settled at code %0d", code_2s);
            errors = errors + 1;
        end
        if (u_tt.period_ticks < 140 || u_tt.period_ticks > 190) begin
            $display("FAIL: TT period code %0d is not ~5 ns / 30 ps",
                     u_tt.period_ticks);
            errors = errors + 1;
        end
        if (errors != 0) $fatal(1, "dll_phys_tdc_tb failed");
        $display("dll_phys_tdc_tb: PASS");
        $finish;
    end
endmodule
