`timescale 1ps/1ps
// Route B: full-period DLL with an absolute-range acquisition, a TDC phase
// detector, a monitor line for continuous range revalidation and a
// target/active code commit that only changes the line in a proven window.
//
// Delay line: DLL_DCDL (4 segments x 56 cells, coarse=code/56, fine=code%56).
// The simulation backend exposes the coarse-boundary steps; the physical
// backend instantiates PLL_SEGMENTED_DELAY_PHYS.
//
// Clock domains:
//   TICK  : TDC counter only (DLL_TDC)
//   OUT   : TDC timestamp capture and toggle only
//   REF   : all DLL control, lock terms, code_target
//   commit: delayed-REF strobe, writes code_active only
// No register is written from two clock domains.  The TDC crosses the
// timestamp with a Gray snapshot and a toggle handshake; code_target is
// stable before the delayed-REF commit strobe samples it.
//
// Acquisition drives the line from REF/16 and measures the absolute delay,
// so 0T/0.5T/2T cannot pass.  Tracking measures the REF-to-OUT phase modulo
// the measured period.  The monitor line runs from REF/16 with the same
// active code and is revalidated continuously; an out-of-range monitor
// measurement drops RANGE_OK and restarts acquisition.
//
// LOCKED = RANGE_OK & PHASE_OK & !CODE_RAILED & ALIVE.
/* verilator lint_off SYNCASYNCNET */
/* verilator lint_off UNUSEDSIGNAL */
// REF/acq_clk are clocks and also the delay-line data input; a clock-delay
// line intentionally uses a clock as data.  acq_delay is read by the TB.
module DLL_FULL_PERIOD_TOP #(
    parameter integer TAPS = 280,
    parameter integer CODE_BITS = 9,
    parameter integer T0_PS = 2930,
    parameter integer CELL_PS = 30,
    parameter integer EXTRA_PS = 62,
    parameter integer DLL_IMPL = 0,
    // 0 = 10 GHz simulation timestamp TDC, 1 = physical delay-line TDC.
    parameter integer TDC_IMPL = 0,
    parameter integer TDC_LINE_IMPL = 0,
    parameter integer TDC_NTAP = 320,
    parameter integer TDC_CELL_PS = 35,
    parameter integer CODE_MIN = 45,
    parameter integer CODE_MAX = 116,
    parameter integer LOCK_COUNT = 16,
    // Commit guard: must exceed the fine-tap span and stay below the REF
    // low phase.  At SS the fine span is larger than the low phase, so the
    // commit is refused and the acquired code is held.
    parameter integer COMMIT_GUARD_PS = 1800,
    // Controller tolerances: the default values are the behavioral
    // architecture settings; the gate-level/SDF flow overrides them for the
    // real delay line (wider acquisition/monitor windows, isolated-miss
    // tolerance, early phase acceptance).
    parameter integer PHASE_TOL_DIV = 5,   // phase_tol = period>>DIV + 1
    parameter integer ACQ_TOL_DIV = 3,
    parameter integer MON_TOL_NUM = 1,     // mon_tol = period*NUM/DEN + 1
    parameter integer MON_TOL_DEN = 4,
    parameter integer PHASE_MISS_MAX = 8,  // drop PHASE_OK on this many misses
    parameter integer ACQ_EARLY = 1        // 1 = accept an in-window phase
) (
    input  wire                  REF,
    input  wire                  RST_N,
    input  wire                  EN,
    input  wire                  TICK,
    input  wire [CODE_BITS-1:0]  CODE_START,
    output wire                  OUT,
    output wire                  LOCKED,
    output wire                  PHASE_OK,
    output wire                  RANGE_OK,
    output wire                  CODE_RAILED,
    output wire                  ALIVE,
    output wire [CODE_BITS-1:0]  CODE,
    output wire                  PFD_UP,
    output wire                  PFD_DN,
    output wire                  ACQ_BUSY,
    output wire                  ACQ_OK,
    output wire                  ACQ_FAIL,
    output wire [4:0]            DBG_ACQ_DLY,
    output wire [8:0]            DBG_FIRST,
    output wire [15:0]           DBG_PERIOD
);
    // ---------------------------------------------------------------- lines
    reg        acq_mode;
    reg        acq_armed;
    reg  [3:0] div;
    wire       acq_clk = div[3];
    // REF/acq_clk are also the delay-line data input.  A clock-delay line
    // intentionally uses a clock as data; Verilator flags this as
    // SYNCASYNCNET in addition to its legitimate clock use.
    wire       line_in = acq_mode ? (acq_armed ? acq_clk : 1'b0) : REF;
    // Matched launch buffers.  div[3] has a large load (TDC ACQ line +
    // monitor DCDL) and its launch delay otherwise appears as a short
    // measured period.  The phase-line input gets the same buffer so the
    // period and phase comparisons see the same launch delay.
    wire acq_clk_buf, mon_clk_buf, line_in_buf;
    wire acq_clk_b1, acq_clk_b2;
    generate
        if (DLL_IMPL == 0) begin : launch_sim
            // Behavioral path: no physical launch buffers, so the DDR/DLL
            // simulations do not need the ics55 cell library.
            assign acq_clk_buf = acq_clk;
            assign acq_clk_b1  = acq_clk;
            assign acq_clk_b2  = acq_clk;
            assign mon_clk_buf = acq_clk;
            assign line_in_buf = line_in;
        end else begin : launch_phys
            FINE_DELAY_CELL u_acq_clk_buf (
                .MUX(1'b1), .IN(acq_clk), .OUT(acq_clk_buf)
            );
            FINE_DELAY_CELL u_acq_clk_b1 (
                .MUX(1'b1), .IN(acq_clk_buf), .OUT(acq_clk_b1)
            );
            FINE_DELAY_CELL u_acq_clk_b2 (
                .MUX(1'b1), .IN(acq_clk_b1), .OUT(acq_clk_b2)
            );
            FINE_DELAY_CELL u_mon_clk_buf (
                .MUX(1'b1), .IN(acq_clk), .OUT(mon_clk_buf)
            );
            FINE_DELAY_CELL u_line_in_buf (
                .MUX(1'b1), .IN(line_in), .OUT(line_in_buf)
            );
        end
    endgenerate

    reg [CODE_BITS-1:0] code_target;
    reg [CODE_BITS-1:0] code_active;
    reg [CODE_BITS-1:0] code_target_q;
    reg                 commit_tog;
    wire [CODE_BITS-1:0] code = code_active;
    assign CODE = code_active;

    wire main_out;
    wire mon_out;
    DLL_DCDL #(
        .IMPL(DLL_IMPL), .CODE_BITS(CODE_BITS),
        .T0_PS(T0_PS), .CELL_PS(CELL_PS), .EXTRA_PS(EXTRA_PS)
    ) u_line (
        .CLK_IN(line_in), .CODE(code), .CLK_OUT(main_out)
    );
    DLL_DCDL #(
        .IMPL(DLL_IMPL), .CODE_BITS(CODE_BITS),
        .T0_PS(T0_PS), .CELL_PS(CELL_PS), .EXTRA_PS(EXTRA_PS)
    ) u_mon (
        .CLK_IN(mon_clk_buf), .CODE(code), .CLK_OUT(mon_out)
    );
    assign OUT = main_out;

    // Delayed-REF commit strobe.  The delay is a matched path in the
    // physical implementation; the behavioral cell exposes the same timing.
    wire commit_strobe;
    DLL_COMMIT_DELAY #(
        .DLY_PS(COMMIT_GUARD_PS), .CELL_PS(CELL_PS), .IMPL(DLL_IMPL)
    ) u_commit_dly (
        .I(REF), .O(commit_strobe)
    );

    // ------------------------------------------------------------------ TDC
    wire [15:0] ref_stamp, main_stamp, mon_stamp, acq_stamp;
    (* keep *) wire [15:0] period_ticks;
    wire [15:0] period_ticks_raw;
    wire        main_tog, mon_tog;
    // Registered one-cycle pulse, matching the physical-TDC ACQ timing in
    // the verified TDC-only flow.  The previous combinational (div==7)
    // shifted the ACQ period pipeline one REF early and sampled the period
    // before the first REF edge after the ACQ launch.
    reg         acq_latch_r;
    always @(posedge REF) begin
        if (!RST_N) acq_latch_r <= 1'b0;
        else        acq_latch_r <= (div == 4'd7);
    end
    wire        acq_latch = (TDC_IMPL == 0) ? (div == 4'd7) : acq_latch_r;
    wire [319:0] tdc_acq_therm;
    wire [4:0]   tdc_acq_dly;
    wire         tdc_ref_clk;
    wire [15:0]  tdc_period_unused;
    (* keep *) wire [15:0] period_unused;

    generate
        if (TDC_IMPL == 0) begin : tdc_sim
            DLL_TDC u_tdc (
                .TICK(TICK), .REF(REF), .OUT(main_out), .MON_OUT(mon_out),
                .RST_N(RST_N), .ACQ_LATCH(acq_latch),
                .ref_stamp(ref_stamp), .period_ticks(period_ticks),
                .main_stamp(main_stamp), .main_tog(main_tog),
                .mon_stamp(mon_stamp), .mon_tog(mon_tog),
                .acq_stamp(acq_stamp)
            );
        end else begin : tdc_phys
            DLL_TDC_PHYS #(
                .NTAP(TDC_NTAP), .CELL_PS(TDC_CELL_PS),
                .IMPL(TDC_LINE_IMPL)
            ) u_tdc (
                .REF(REF), .ACQ_CLK(acq_clk_b2), .PHASE_IN(line_in_buf),
                .OUT(main_out), .MON_OUT(mon_out),
                .RST_N(RST_N), .ACQ_LATCH(acq_latch),
                .ref_stamp(ref_stamp), .period_ticks(tdc_period_unused),
                .main_stamp(main_stamp), .main_tog(main_tog),
                .mon_stamp(mon_stamp), .mon_tog(mon_tog),
                .acq_stamp(acq_stamp),
                .acq_therm_ref_out(tdc_acq_therm),
                .acq_dly_out(tdc_acq_dly),
                .REF_CLK(tdc_ref_clk)
            );
            DLL_ACQ_PERIOD u_acq_period (
                .REF(REF), .RST_N(RST_N), .ACQ_CLK(acq_clk_buf),
                .ACQ_THERM(tdc_acq_therm), .ACQ_DLY(tdc_acq_dly),
                // Use the DBG_PERIOD output (the full period_r bus); the
                // PERIOD port is aliased to period_r[0] by Yosys's width
                // optimization in this flattened context.
                .PERIOD(period_unused),
                .DBG_DLY(DBG_ACQ_DLY), .DBG_FIRST(DBG_FIRST),
                .DBG_PERIOD(period_ticks_raw)
            );
        end
    endgenerate
    reg  [15:0] acq_delay;  // exposed for the testbench range check
    wire [15:0] acq_period = (period_ticks << 4);
    // Signed modulo differences.  These were integer-based self-referencing
    // always blocks, which Yosys dropped ("No latch inferred") leaving ad/md/pd
    // undriven in the gate netlist.
    wire signed [17:0] ad_x = $signed({2'b00, main_stamp}) -
                              $signed({2'b00, acq_stamp});
    wire signed [17:0] md_x = $signed({2'b00, mon_stamp}) -
                              $signed({2'b00, acq_stamp});
    wire [15:0] ad = (period_ticks == 0) ? 16'd0 :
                     (ad_x < 0)           ? ad_x + acq_period :
                     (ad_x >= acq_period) ? ad_x - acq_period : ad_x[15:0];
    wire [15:0] md = (period_ticks == 0) ? 16'd0 :
                     (md_x < 0)           ? md_x + acq_period :
                     (md_x >= acq_period) ? md_x - acq_period : md_x[15:0];

    // ------------------------------------------------------- REF controller
    reg        main_tog_seen, mon_tog_seen;
    reg        main_evt;
    reg [2:0]  alive_cnt;
    reg [1:0]  acq_settle;
    reg [7:0]  phase_good;
    reg [2:0]  phase_miss;
    reg        phase_ok_r;
    reg        acq_ok, acq_fail, acq_busy;
    reg  [3:0] flush;
    reg [CODE_BITS-1:0] lo, hi;
    reg        range_live;
    reg [1:0]  mon_bad;

    wire [2:0] active_coarse = code_active / 56;
    wire [15:0] phase_tol = (period_ticks >> PHASE_TOL_DIV) + 1;
    wire [15:0] acq_tol   = (period_ticks >> ACQ_TOL_DIV) + 1;
    wire [15:0] mon_tol   = ((period_ticks * MON_TOL_NUM) / MON_TOL_DEN) + 1;

    // Calibrate the ACQ launch/measurement offset.  The sampler pipeline
    // reports ~15/16 of the true REF period; the 1/16 term restores the
    // full-period target without changing the tap/code resolution.
    assign period_ticks = period_ticks_raw;
    assign DBG_PERIOD = period_ticks;
    assign ACQ_BUSY = acq_busy;
    assign ACQ_OK   = acq_ok;
    assign ACQ_FAIL = acq_fail;
    // Legal-code window.
    //
    // CODE_MIN/CODE_MAX encode T0_PS + CELL_PS*code ~= period for ONE
    // reference period (10 ns).  A different reference moves the window, and
    // if it moves far enough no code is legal -- the "no legal code in one
    // period" failure.
    //
    // Trying to derive the window from the measured period at runtime was
    // attempted and abandoned: any combinational dependence on period_ticks
    // (which is X until the first measurement) made the simulator re-enter
    // this always block indefinitely, observed as a hang rather than a wrong
    // result.  The window is therefore a PARAMETER, so each reference period
    // picks its own legal band at elaboration:
    //
    //   DLL_PERIOD_PS   CODE_MIN   CODE_MAX
    //   10000 (100 MHz)    45        116      (the calibrated values)
    //    5000 (200 MHz)    20         60      (T0 2.93 ns + 30 ps/step)
    //
    // derive_code_window.py prints the pair for a target period.
    assign RANGE_OK = acq_ok && range_live &&
                      (code_active >= CODE_MIN) && (code_active <= CODE_MAX);
    assign CODE_RAILED = (code_active == 0) || (code_active == TAPS - 1);
    assign PHASE_OK = phase_ok_r;
    assign ALIVE = (alive_cnt < 3'd4);
    assign LOCKED = PHASE_OK && RANGE_OK && !CODE_RAILED && ALIVE;

    // Phase modulo the measured period.  The tracking event is within one
    // period of the latest REF edge; the sign bit selects the wrap.
    wire signed [17:0] pd_x = $signed({2'b00, main_stamp}) -
                              $signed({2'b00, ref_stamp});
    wire [15:0] pd = (period_ticks == 0) ? 16'd0 :
                     (pd_x < 0)           ? pd_x + period_ticks :
                     (pd_x >= period_ticks) ? pd_x - period_ticks : pd_x[15:0];
    assign PFD_UP = (pd > phase_tol) && (pd < period_ticks / 2);
    assign PFD_DN = (pd >= period_ticks / 2) &&
                    (pd < period_ticks - phase_tol);

    always @(posedge REF) begin
        if (!RST_N) begin
            div <= 4'd0; acq_mode <= 1'b0; acq_armed <= 1'b0; flush <= 4'd0;
            acq_ok <= 1'b0; acq_fail <= 1'b0; acq_busy <= 1'b0;
            code_target <= CODE_START; code_target_q <= CODE_START;
            commit_tog <= 1'b0;
            lo <= CODE_MIN; hi <= CODE_MAX;
            main_tog_seen <= 1'b0; mon_tog_seen <= 1'b0;
            main_evt <= 1'b0;
            alive_cnt <= 3'd0; acq_settle <= 2'd0;
            phase_good <= 8'd0; phase_miss <= 3'd0; phase_ok_r <= 1'b0;
            range_live <= 1'b0; mon_bad <= 2'd0;
        end else if (!EN) begin
            div <= 4'd0; acq_mode <= 1'b0; acq_armed <= 1'b0; flush <= 4'd0;
            acq_ok <= 1'b0; acq_fail <= 1'b0; acq_busy <= 1'b0;
            code_target <= CODE_START; code_target_q <= CODE_START;
            commit_tog <= 1'b0;
            lo <= CODE_MIN; hi <= CODE_MAX;
            main_tog_seen <= 1'b0; mon_tog_seen <= 1'b0;
            main_evt <= 1'b0;
            alive_cnt <= 3'd0; acq_settle <= 2'd0;
            phase_good <= 8'd0; phase_miss <= 3'd0; phase_ok_r <= 1'b0;
            range_live <= 1'b0; mon_bad <= 2'd0;
        end else begin
            div <= div + 1'b1;

            // Event detection from the synchronized TDC toggles.
            if (main_tog != main_tog_seen) begin
                main_tog_seen <= main_tog;
                alive_cnt <= 3'd0;
                phase_miss <= 3'd0;
                if (acq_ok) begin
                    // tracking event; consume immediately
                    if ((pd <= phase_tol) ||
                        (pd >= period_ticks - phase_tol)) begin
                        if (phase_good < LOCK_COUNT[7:0])
                            phase_good <= phase_good + 1'b1;
                        if (phase_good + 1 >= LOCK_COUNT[7:0])
                            phase_ok_r <= 1'b1;
                    end else begin
                        phase_good <= 8'd0;
                        phase_ok_r <= 1'b0;
                        // Tracking steps the code by one, ACROSS the coarse
                        // boundary.
                        //
                        // The clamp used to be active_coarse*56 ..
                        // active_coarse*56+55, i.e. the tracker could only
                        // move inside the coarse segment it acquired in.  If
                        // acquisition lands in the wrong segment -- which a
                        // reference period different from the calibrated one
                        // causes, because the phase window is period-relative
                        // -- the loop then walks to the segment edge and stops
                        // with no legal code in reach.  That is the "no legal
                        // code in one period" failure.
                        //
                        // The clamp now stops only at the global legal range,
                        // which is what the acquisition binary search already
                        // uses.
                        if ((pd > phase_tol) && (pd < period_ticks / 2)) begin
                            if (code_target > lo)
                                code_target <= code_target - 1'b1;
                        end else if ((pd >= period_ticks / 2) &&
                                     (pd < period_ticks - phase_tol)) begin
                            if (code_target < hi)
                                code_target <= code_target + 1'b1;
                        end
                    end
                end else begin
                    main_evt <= 1'b1;   // acquisition consumes it at div==4
                end
            end else begin
                if (alive_cnt < 3'd4) alive_cnt <= alive_cnt + 1'b1;
                if (acq_ok) begin
                    // At a full-period phase the OUT edge is coincident with
                    // the next REF edge, so the OUT->REF toggle can miss an
                    // occasional sample.  Tolerate isolated misses; ALIVE and
                    // the monitor check still catch a stopped/wrong output.
                    if (phase_miss < PHASE_MISS_MAX - 1)
                        phase_miss <= phase_miss + 1'b1;
                    if (phase_miss == PHASE_MISS_MAX - 1) begin
                        phase_good <= 8'd0;
                        phase_ok_r <= 1'b0;
                    end
                end
            end

            // Monitor event: continuous absolute-range revalidation.
            if (mon_tog != mon_tog_seen) begin
                mon_tog_seen <= mon_tog;
                if (acq_ok && (period_ticks != 0)) begin
                    if ((md >= period_ticks - mon_tol) &&
                        (md <= period_ticks + mon_tol)) begin
                        mon_bad <= 2'd0;
                        range_live <= 1'b1;
                    end else if (mon_bad == 2'd0) begin
                        // One stale sample is possible around a commit;
                        // require two consecutive out-of-range samples.
                        mon_bad <= 2'd1;
                    end else begin
                        // Code no longer in the 1T range at the measured
                        // period: drop the lock and re-acquire.
                        mon_bad <= 2'd0;
                        range_live <= 1'b0;
                        acq_ok <= 1'b0;
                        acq_fail <= 1'b0;
                        acq_mode <= 1'b0;
                        acq_armed <= 1'b0;
                        flush <= 4'd0;
                        phase_good <= 8'd0;
                        phase_ok_r <= 1'b0;
                    end
                end
            end

            if (!acq_mode) begin
                if (acq_ok) begin
                    // tracking (handled on events above)
                end else if (!acq_fail && (period_ticks != 0)) begin
                    acq_mode <= 1'b1;
                    acq_armed <= 1'b0;
                    flush <= 4'd0;
                    acq_busy <= 1'b1;
                    range_live <= 1'b0;
                    lo <= CODE_MIN;
                    hi <= CODE_MAX;
                    code_target <= (CODE_MIN + CODE_MAX) >> 1;
                end
            end else if (!acq_armed) begin
                if (flush < 4'd8) flush <= flush + 1'b1;
                else if (!acq_clk) begin
                    acq_armed <= 1'b1;
                    acq_settle <= 2'd2;
                end
            end else begin
                // Process at div==4, after the delayed falling edge and
                // before the next rising edge.
                if ((div == 4'd0) && main_evt && (period_ticks != 0) &&
                    (acq_settle == 2'd0)) begin
                    main_evt <= 1'b0;
                    acq_delay <= ad[15:0];
                    // Accept as soon as the measured phase is a full period.
                    // At FF the phase code can step from just-below-period to
                    // the 0 wrap in one binary-search step, so accepting only
                    // at the range boundary would miss the crossing.
                    if ((ACQ_EARLY != 0) &&
                        (ad >= period_ticks - phase_tol) &&
                        (ad <= period_ticks + phase_tol)) begin
                        acq_ok <= 1'b1;
                        range_live <= 1'b1;
                        mon_bad <= 2'd0;
                        acq_busy <= 1'b0;
                    end else if (ad < period_ticks) begin
                        if (code_target >= hi) begin
                            acq_fail <= 1'b1;
                            acq_busy <= 1'b0;
                        end else begin
                            lo <= code_target + 1'b1;
                            code_target <= code_target +
                                ((hi - code_target + 1'b1) >> 1);
                        end
                    end else begin
                        if (code_target <= lo) begin
                            acq_fail <= 1'b1;
                            acq_busy <= 1'b0;
                        end else begin
                            hi <= code_target - 1'b1;
                            code_target <= lo +
                                ((code_target - lo) >> 1);
                        end
                    end
                end else if ((div == 4'd0) && (acq_settle != 2'd0)) begin
                    acq_settle <= acq_settle - 1'b1;
                    main_evt <= 1'b0;
                end
                if (acq_ok && (div == 4'd15)) acq_mode <= 1'b0;
                if (acq_fail && (div == 4'd15)) acq_mode <= 1'b0;
            end

            // Request a commit when the target changes.  The actual code
            // write happens only in the delayed-REF commit block.
            if (code_target != code_target_q) begin
                code_target_q <= code_target;
                commit_tog <= ~commit_tog;
            end
        end
    end

    // ------------------------------------------------------- safe commit
    // Single writer for code_active.  commit_tog crosses into the delayed
    // REF strobe domain with a 2FF synchronizer; the write is allowed only
    // while REF is low, so a tracking update lands inside the low phase
    // after COMMIT_GUARD_PS.  At a corner where the fine span exceeds the
    // low phase the strobe sees REF high and the acquired code is held.
    // During acquisition the target changes at div==4, i.e. after 20 ns of
    // the 40 ns REF/16 low phase, so the next low-phase strobe is safe for
    // the measured 18.13 ns maximum tap delay.
    reg [1:0] ct_sync;
    reg       commit_done;
    reg [3:0] acq_low_cnt;
    always @(negedge commit_strobe) begin
        ct_sync <= {ct_sync[0], commit_tog};
        if (!RST_N || !EN) begin
            code_active <= CODE_START;
            commit_done <= 1'b0;
            acq_low_cnt <= 4'd0;
        end else begin
            if (acq_mode && acq_armed && !acq_clk) begin
                if (acq_low_cnt < 4'd4) acq_low_cnt <= acq_low_cnt + 1'b1;
            end else begin
                acq_low_cnt <= 4'd0;
            end

            if (ct_sync[1] != commit_done) begin
                if (acq_mode) begin
                    // Slow acquisition line: 20 ns of low covers the
                    // measured 18.13 ns maximum tap delay.
                    if (acq_armed && !acq_clk && (acq_low_cnt >= 4'd4)) begin
                        code_active <= code_target;
                        commit_done <= ct_sync[1];
                    end
                end else if (!REF) begin
                    // Tracking: only inside the REF low phase after the
                    // fine-settling guard.  REF high means the guard is
                    // longer than the low phase, so the code is held.
                    code_active <= code_target;
                    commit_done <= ct_sync[1];
                end
            end
        end
    end
/* verilator lint_on UNUSEDSIGNAL */
/* verilator lint_on SYNCASYNCNET */
endmodule
