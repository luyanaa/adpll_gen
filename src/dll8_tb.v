`timescale 1ps/1fs
// 8-phase DLL verification (one corner / one rate per elaboration; set the
// parameters with iverilog -P dll8_tb.<name>=<value>):
//   CORNER   : 0=SS 1=TT 2=FF (label only)
//   BASE_PS  : element base delay of the model
//   STEP_PS  : element LSB (one finger)
//   T_PS     : REF period (4000 ps = 250 MHz, 2000 ps = 500 MHz)
//   PD_MODE  : 1 = TDC (default), 0 = legacy bang-bang latch
//
// Checks: lock from both code rails, no false lock (tap7 one full period
// behind REF), k*T/8 conformance, duty, TDC resolution report, per-element
// matching, and measurement-based per-element trim calibration.
module dll8_tb;
    parameter integer CORNER  = 0;
    parameter real BASE_PS = 120.0;
    parameter real STEP_PS = 4.0;
    parameter integer T_PS    = 4000;
    parameter integer PD_MODE = 1;

    // Half a code step in TDC LSBs: one code step moves 8d by 8*STEP_PS, and
    // the TDC LSB is ~T/1024, so the dead band must scale with STEP_PS/T.
    localparam integer EB = $rtoi(4.0 * STEP_PS * 1024.0 / T_PS + 0.5);

    reg  REF = 1'b0, RST_N = 1'b0, EN = 1'b0;
    reg  TICK = 1'b0, TICK_FAST = 1'b0;
    reg  TRIM_LD = 1'b0, HOLD = 1'b0;
    reg  [15:0] KI;
    reg  signed [39:0] TRIM_IN;
    reg  [6:0] CODE_INIT;
    reg  signed [4:0] PD_OFFSET;
    reg  [6:0] PD_TRIM_V, PD_TRIM_R;
    reg  [2:0] TAP_SEL;
    wire [7:0] TAP;
    wire [7:0] PHASE;
    reg phase_early;
    wire LOCKED;
    wire [6:0] LOOP_CODE;
    wire [55:0] ELEM_CODES;
    wire [7:0] MEAS_COUNTS;
    wire ACQ_DONE;
    wire [15:0] TAP_STAMP, MON_STAMP, REF_STAMP, PERIOD_TICKS;

    DLL8_TOP #(
        .CODE_BITS(7), .MAXC(127), .FILTER_BITS(16), .LOCK_COUNT(24),
        .PD_MODE(PD_MODE), .BASE_PS(BASE_PS), .STEP_PS(STEP_PS),
        .ERR_BAND(EB), .LOCK_TOL(EB + 1),
        .DLL8_IMPL(0)
    ) dut (
        .REF(REF), .RST_N(RST_N), .EN(EN), .TICK(TICK),
        .TICK_FAST(TICK_FAST), .TAP_SEL(TAP_SEL),
        .KI(KI), .PD_OFFSET(PD_OFFSET),
        .PD_TRIM_V(PD_TRIM_V), .PD_TRIM_R(PD_TRIM_R),
        .CODE_INIT(CODE_INIT), .HOLD(HOLD),
        .TRIM_LD(TRIM_LD), .TRIM_IN(TRIM_IN),
        .TAP(TAP), .LOCKED(LOCKED), .LOOP_CODE(LOOP_CODE),
        .ELEM_CODES(ELEM_CODES),
        .MEAS_COUNTS(MEAS_COUNTS), .ACQ_DONE(ACQ_DONE),
        .TAP_STAMP(TAP_STAMP), .MON_STAMP(MON_STAMP),
        .REF_STAMP(REF_STAMP), .PERIOD_TICKS(PERIOD_TICKS),
        .PHASE(PHASE)
    );

    always #(T_PS / 2)          REF = ~REF;
    always #(T_PS / 32.0)       TICK = ~TICK;      // 16 x REF  (range counter)
    always #(T_PS / 2048.0)     TICK_FAST = ~TICK_FAST; // 1024 x REF (TDC)

    // regenerated outputs must be flat while the loop is not locked
    always @(PHASE) if (!LOCKED && PHASE != 8'd0) phase_early <= 1'b1;

    real t_ref;
    real d_elem [0:7];
    real d_ph [0:7];
    real dmeas  [0:7];
    integer errors;
    reg [8*48-1:0] check_name;
    real last_err7;
    real tick_ps;
    integer trim_cur [0:7];
    real worst_elem, min_elem, max_elem;
    real tdc_phase;
    integer kk;
    integer err_save;

    // ------------------------------------------------------------ utilities
    task automatic measure_taps;
        integer t;
        begin
            @(posedge REF); t_ref = $realtime;
            for (t = 0; t < 8; t = t + 1) begin
                @(posedge TAP[t]); d_elem[t] = $realtime - t_ref;
            end
        end
    endtask

    task automatic check;
        integer t;
        real target_d, resid, worst_c;
        begin
            measure_taps;
            target_d = T_PS / 8.0;
            worst_c = 0.0;
            $display("-- %0s: T=%0d ps, d=T/8=%0.1f ps",
                     check_name, T_PS, target_d);
            for (t = 0; t < 8; t = t + 1) begin
                resid = d_elem[t] - (t + 1) * target_d;
                if ((resid < 0 ? -resid : resid) > worst_c)
                    worst_c = (resid < 0 ? -resid : resid);
                $display("   tap%0d = %0.1f ps  k*T/8 err=%+0.1f ps",
                         t, d_elem[t], resid);
            end
            last_err7 = d_elem[7] - 8.0 * target_d;
            $display("   worst |phase_k-k*T/8| = %0.1f ps (budget 30)%s",
                     worst_c, (worst_c <= 30.0) ? "  PASS" : "  FAIL");
            if (worst_c > 30.0) errors = errors + 1;
            $display("   -> E (tap7 lock-point error) = %+0.1f ps", last_err7);
        end
    endtask

    task automatic check_duty;
        real t0, t1, t2, duty;
        integer t;
        begin
            for (t = 0; t < 8; t = t + 1) begin
                @(posedge TAP[t]); t0 = $realtime;
                @(negedge TAP[t]); t1 = $realtime;
                @(posedge TAP[t]); t2 = $realtime;
                duty = 100.0 * (t1 - t0) / (t2 - t0);
                if (t == 7 || duty <= 45.0 || duty >= 55.0)
                    $display("   duty tap%0d = %0.1f %% %s", t, duty,
                             (duty > 45.0 && duty < 55.0) ? "PASS" : "FAIL");
                if (duty <= 45.0 || duty >= 55.0) errors = errors + 1;
            end
        end
    endtask

    // ------------------------------------------------------- trim plumbing
    task automatic load_trims;
        integer t;
        reg signed [39:0] p;
        begin
            p = 40'd0;
            for (t = 0; t < 8; t = t + 1) p[t*5 +: 5] = trim_cur[t];
            TRIM_IN = p; TRIM_LD = 1'b1;
            @(posedge TICK); @(negedge TICK);
            TRIM_LD = 1'b0;
        end
    endtask

    task automatic run_lock;
        input rail_high;
        integer n;
        begin
            HOLD = 1'b0;
            CODE_INIT = rail_high ? 7'd127 : 7'd0;
            EN = 1'b0;
            RST_N = 1'b1; #(T_PS);
            RST_N = 1'b0; #(4 * T_PS);
            RST_N = 1'b1; EN = 1'b1;
            KI = 16'd1;
            load_trims;               // re-apply the current trims
            for (n = 0; n < 60000 && !LOCKED; n = n + 1) @(posedge TICK);
            $display("-- lock %s: LOCKED=%0b after %0d TICK CODE=%0d meas=%0d",
                     rail_high ? "HIGH rail" : "LOW rail", LOCKED, n,
                     LOOP_CODE, MEAS_COUNTS);
            if (!LOCKED) errors = errors + 1;
        end
    endtask

    task automatic check_no_false_lock;
        input [8*12-1:0] label;
        real dt, perr;
        begin
            // tap7 must lead/trail REF by ~0 modulo T: that is exactly 8d=T.
            // A 7d or 9d lock would show T/8 (500 ps) or -T/8.
            @(posedge REF); t_ref = $realtime;
            @(posedge TAP[7]); dt = $realtime - t_ref;
            while (dt > T_PS) dt = dt - T_PS;
            perr = dt;
            if (perr > T_PS / 2.0) perr = perr - T_PS;
            $display("   %0s: tap7-REF = %+0.1f ps mod T (0 => 8d=T)%s",
                     label, perr, (perr > -30.0 && perr < 30.0) ?
                     "  PASS" : "  FALSE LOCK/FAIL");
            if (perr < -30.0 || perr > 30.0) errors = errors + 1;
        end
    endtask

    // --------------------------------------------------- TDC measurement
    // Phase of TAP[TAP_SEL] relative to REF in ps (mod T), read from the TDC
    // monitor stamp.  The tick length is derived from the MEASURED period so
    // the report does not depend on the ideal clock ratio.
    task automatic tdc_measure;
        input integer kk;
        reg [15:0] dph;
        begin
            TAP_SEL = kk[2:0];
            repeat (8) @(posedge REF);
            if (PERIOD_TICKS > 8) tick_ps = T_PS / (PERIOD_TICKS * 1.0);
            else                  tick_ps = T_PS / 1024.0;
            dph = MON_STAMP;
            tdc_phase = dph * tick_ps;
            tdc_phase = tdc_phase - T_PS * $floor(tdc_phase / T_PS);
            @(posedge REF);
        end
    endtask

    task automatic measure_elements;
        integer kk;
        real prev;
        begin
            prev = 0.0;
            for (kk = 0; kk < 8; kk = kk + 1) begin
                tdc_measure(kk);
                dmeas[kk] = tdc_phase - prev;
                if (dmeas[kk] < 0.0) dmeas[kk] = dmeas[kk] + T_PS;
                prev = tdc_phase;
            end
            TAP_SEL = 3'd7;
        end
    endtask

    task automatic report_matching;
        input [8*16-1:0] label;
        integer kk;
        real dstar;
        begin
            measure_elements;
            dstar = T_PS / 8.0;
            min_elem = 1.0e9; max_elem = -1.0e9; worst_elem = 0.0;
            $display("-- per-element delays from TDC (%0s), d*=T/8=%0.1f ps:",
                     label, dstar);
            for (kk = 0; kk < 8; kk = kk + 1) begin
                $display("   elem%0d d=%0.1f ps  (d-d*)=%+0.1f ps",
                         kk, dmeas[kk], dmeas[kk] - dstar);
                if (dmeas[kk] < min_elem) min_elem = dmeas[kk];
                if (dmeas[kk] > max_elem) max_elem = dmeas[kk];
            end
            worst_elem = max_elem - min_elem;
            $display("   per-element matching (max-min) = %0.1f ps", worst_elem);
            $display("   TDC LSB (measured) = %0.3f ps (%0d ticks/REF)",
                     tick_ps, PERIOD_TICKS);
        end
    endtask


    // Measurement-based per-element calibration: measure every element delay
    // with the TDC and move each trim by (T/8 - d)/LSB.  Because the loop
    // guarantees sum(d)=T, this equalises the elements (matching -> 0).
    task automatic tdc_calibrate;
        integer kk;
        real corr;
        begin
            measure_elements;
            for (kk = 0; kk < 8; kk = kk + 1) begin
                corr = (T_PS / 8.0 - dmeas[kk]) / STEP_PS;
                trim_cur[kk] = trim_cur[kk] +
                               $rtoi(corr + (corr >= 0.0 ? 0.5 : -0.5));
                if (trim_cur[kk] > 15)  trim_cur[kk] = 15;
                if (trim_cur[kk] < -16) trim_cur[kk] = -16;
                $display("   TDC meas elem%0d d=%0.1f ps -> trim %0d",
                         kk, dmeas[kk], trim_cur[kk]);
            end
            load_trims;
        end
    endtask

    // ---------------------------------------------- regenerated phases
    task automatic check_phase;
        integer t;
        real target, resid, off, worst_raw, worst_off;
        begin
            @(posedge REF); t_ref = $realtime;
            for (t = 0; t < 8; t = t + 1) begin
                @(posedge PHASE[t]); d_ph[t] = $realtime - t_ref;
            end
            target = T_PS / 8.0;
            off = 0.0;
            for (t = 0; t < 8; t = t + 1)
                off = off + (d_ph[t] - (t + 1) * target);
            off = off / 8.0;
            worst_raw = 0.0; worst_off = 0.0;
            for (t = 0; t < 8; t = t + 1) begin
                resid = d_ph[t] - (t + 1) * target;
                if ((resid < 0 ? -resid : resid) > worst_raw)
                    worst_raw = (resid < 0 ? -resid : resid);
                resid = resid - off;
                if ((resid < 0 ? -resid : resid) > worst_off)
                    worst_off = (resid < 0 ? -resid : resid);
            end
            $display("   REGEN: common offset %+0.1f ps, raw worst %0.1f ps, de-offset worst %0.1f ps %s",
                     off, worst_raw, worst_off, (worst_off <= 30.0) ? "PASS" : "FAIL");
            if (worst_off > 30.0) errors = errors + 1;
        end
    endtask

    task automatic check_phase_duty;
        integer t;
        real t0, t1, t2, duty, wduty;
        begin
            wduty = 0.0;
            for (t = 0; t < 8; t = t + 1) begin
                @(posedge PHASE[t]); t0 = $realtime;
                @(negedge PHASE[t]); t1 = $realtime;
                @(posedge PHASE[t]); t2 = $realtime;
                duty = 100.0 * (t1 - t0) / (t2 - t0);
                if (duty < 45.0 || duty > 55.0) begin
                    $display("   REGEN duty ph%0d = %0.2f %% FAIL", t, duty);
                    errors = errors + 1;
                end
                if (t == 0) wduty = duty;
            end
            $display("   REGEN duty ph0 = %0.2f %% (all 8 45-55 check done)", wduty);
        end
    endtask

    // ------------------------------------------------------------- stimulus
    initial begin
        errors = 0;
        PD_OFFSET = 5'sd0;
        PD_TRIM_V = 7'd0; PD_TRIM_R = 7'd0;
        TAP_SEL   = 3'd7;
        phase_early = 1'b0;
        HOLD      = 1'b0;
        for (kk = 0; kk < 8; kk = kk + 1) trim_cur[kk] = 0;

        $display("=======================================================");
        $display("corner %0d: T=%0d ps BASE=%0.1f LSB=%0.3f PD_MODE=%0d dead-band=%0d LSB",
                 CORNER, T_PS, BASE_PS, STEP_PS, PD_MODE, EB);
        $display("TDC nominal LSB = T/1024 = %0.3f ps", T_PS / 1024.0);
        // Element transfer (timing model): delay(c) = BASE + c*LSB, strictly
        // monotone (one NAND3 finger per LSB).  SPICE is the authority.
        $display("element transfer: base=%0.1f ps  LSB=%0.3f ps  delay(c)=base+c*LSB",
                 BASE_PS, STEP_PS);
        $display("   c=0:%0.1f  c=1:%0.1f  c=2:%0.1f  c=32:%0.1f  c=95:%0.1f  c=127:%0.1f ps",
                 BASE_PS, BASE_PS+STEP_PS, BASE_PS+2*STEP_PS,
                 BASE_PS+32*STEP_PS, BASE_PS+95*STEP_PS, BASE_PS+127*STEP_PS);

        // ---- 1: ideal (matched) elements, low rail
        run_lock(1'b0);
        HOLD = 1'b1;
        check_name = "matched elements, untrimmed"; check;
        check_phase;
        check_phase_duty;
        if (phase_early) begin
            $display("   ERROR: regenerated edge before LOCKED");
            errors = errors + 1;
        end
        check_no_false_lock("low-rail");
        check_duty;
        report_matching("matched");
        HOLD = 1'b0;

        // ---- 2: high rail (false-lock stress)
        run_lock(1'b1);
        HOLD = 1'b1;
        check_no_false_lock("high-rail");
        HOLD = 1'b0;

        // ---- 3: inject a deliberate per-element mismatch through the trims,
        // which is exactly a per-element delay offset of ms[k]*LSB.
        trim_cur[0] =  6; trim_cur[1] =  4; trim_cur[2] = -5; trim_cur[3] =  3;
        trim_cur[4] = -4; trim_cur[5] =  5; trim_cur[6] = -3; trim_cur[7] =  2;
        $display("-- injected per-element mismatch (trim codes): %0d %0d %0d %0d %0d %0d %0d %0d",
                 trim_cur[0], trim_cur[1], trim_cur[2], trim_cur[3],
                 trim_cur[4], trim_cur[5], trim_cur[6], trim_cur[7]);
        run_lock(1'b0);
        HOLD = 1'b1;
        err_save = errors;
        check_name = "injected element mismatch"; check;
        if (errors > err_save) begin
            $display("   (expected: mismatch injected, pre-calibration - not a gate)");
            errors = err_save;
        end
        report_matching("mismatched");
        HOLD = 1'b0;

        // ---- 4: measurement-based calibration from the TDC, then re-lock
        run_lock(1'b0);
        HOLD = 1'b1;
        tdc_calibrate;
        HOLD = 1'b0;
        run_lock(1'b0);
        HOLD = 1'b1;
        check_name = "after TDC measurement calibration"; check;
        report_matching("calibrated");
        check_duty;
        HOLD = 1'b0;

        $display("=======================================================");
        if (errors == 0) $display("dll8_tb: PASS");
        else             $display("dll8_tb: FAIL (%0d checks)", errors);
        $finish;
    end
endmodule
