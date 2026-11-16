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
module DLL_FULL_PERIOD_TOP #(
    parameter integer TAPS = 280,
    parameter integer CODE_BITS = 9,
    parameter integer T0_PS = 2930,
    parameter integer CELL_PS = 30,
    parameter integer EXTRA_PS = 62,
    parameter integer DLL_IMPL = 0,
    parameter integer CODE_MIN = 45,
    parameter integer CODE_MAX = 116,
    parameter integer PERIOD_TICKS = 50,
    parameter integer LOCK_COUNT = 16,
    // Commit guard: must exceed the fine-tap span and stay below the REF
    // low phase.  At SS the fine span is larger than the low phase, so the
    // commit is refused and the acquired code is held.
    parameter integer COMMIT_GUARD_PS = 1800
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
    output wire                  ACQ_FAIL
);
    // ---------------------------------------------------------------- lines
    reg        acq_mode;
    reg        acq_armed;
    reg  [3:0] div;
    wire       acq_clk = div[3];
    wire       line_in = acq_mode ? (acq_armed ? acq_clk : 1'b0) : REF;

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
        .CLK_IN(acq_clk), .CODE(code), .CLK_OUT(mon_out)
    );
    assign OUT = main_out;

    // Delayed-REF commit strobe.  The delay is a matched path in the
    // physical implementation; the behavioral cell exposes the same timing.
    wire commit_strobe;
    DLL_DELAY_CELL #(.DLY_PS(COMMIT_GUARD_PS)) u_commit_dly (
        .I(REF), .O(commit_strobe)
    );

    // ------------------------------------------------------------------ TDC
    wire [15:0] ref_stamp, period_ticks, main_stamp, mon_stamp, acq_stamp;
    wire        main_tog, mon_tog;
    wire        acq_latch = (div == 4'd7);
    DLL_TDC u_tdc (
        .TICK(TICK), .REF(REF), .OUT(main_out), .MON_OUT(mon_out),
        .RST_N(RST_N), .ACQ_LATCH(acq_latch),
        .ref_stamp(ref_stamp), .period_ticks(period_ticks),
        .main_stamp(main_stamp), .main_tog(main_tog),
        .mon_stamp(mon_stamp), .mon_tog(mon_tog),
        .acq_stamp(acq_stamp)
    );
    reg  [15:0] acq_delay;
    wire [15:0] acq_period = (period_ticks << 4);
    integer ad, md;
    always @* begin
        ad = main_stamp - acq_stamp;
        if (period_ticks != 0) begin
            if (ad < 0) ad = ad + acq_period;
            else if (ad >= acq_period) ad = ad - acq_period;
        end
        md = mon_stamp - acq_stamp;
        if (period_ticks != 0) begin
            if (md < 0) md = md + acq_period;
            else if (md >= acq_period) md = md - acq_period;
        end
    end

    // ------------------------------------------------------- REF controller
    reg        main_tog_seen, mon_tog_seen;
    reg        main_evt, mon_evt;
    reg [2:0]  alive_cnt;
    reg [1:0]  acq_settle;
    reg [7:0]  phase_good;
    reg        phase_ok_r;
    reg        acq_ok, acq_fail, acq_busy;
    reg  [3:0] flush;
    reg [CODE_BITS-1:0] lo, hi;
    reg [15:0] phase_delta;
    reg [15:0] mon_delta_r;
    reg        range_live;
    reg [1:0]  mon_bad;
    integer    dd;
    integer    pd;

    wire [2:0] active_coarse = code_active / 56;
    wire [15:0] phase_tol = (period_ticks >> 5) + 1;   // ~3% + 1 tick
    wire [15:0] acq_tol   = (period_ticks >> 4) + 1;   // ~6% + 1 tick
    wire [15:0] mon_tol   = (period_ticks >> 3) + 1;   // ~12.5% + 1 tick

    assign ACQ_BUSY = acq_busy;
    assign ACQ_OK   = acq_ok;
    assign ACQ_FAIL = acq_fail;
    assign RANGE_OK = acq_ok && range_live &&
                      (code_active >= CODE_MIN) && (code_active <= CODE_MAX);
    assign CODE_RAILED = (code_active == 0) || (code_active == TAPS - 1);
    assign PHASE_OK = phase_ok_r;
    assign ALIVE = (alive_cnt < 3'd4);
    assign LOCKED = PHASE_OK && RANGE_OK && !CODE_RAILED && ALIVE;

    // Phase modulo the measured period.  The tracking event is within one
    // period of the latest REF edge; the sign bit selects the wrap.
    always @* begin
        pd = main_stamp - ref_stamp;
        if (pd < 0) pd = pd + period_ticks;
        else if (pd >= period_ticks) pd = pd - period_ticks;
    end
    assign PFD_UP = (pd > phase_tol) && (pd < period_ticks / 2);
    assign PFD_DN = (pd >= period_ticks / 2) &&
                    (pd < period_ticks - phase_tol);

    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            div <= 4'd0; acq_mode <= 1'b0; acq_armed <= 1'b0; flush <= 4'd0;
            acq_ok <= 1'b0; acq_fail <= 1'b0; acq_busy <= 1'b0;
            code_target <= CODE_START; code_target_q <= CODE_START;
            commit_tog <= 1'b0;
            lo <= CODE_MIN; hi <= CODE_MAX;
            main_tog_seen <= 1'b0; mon_tog_seen <= 1'b0;
            main_evt <= 1'b0; mon_evt <= 1'b0;
            alive_cnt <= 3'd0; acq_settle <= 2'd0;
            phase_good <= 8'd0; phase_ok_r <= 1'b0;
            phase_delta <= 16'd0; mon_delta_r <= 16'd0;
            range_live <= 1'b0; mon_bad <= 2'd0;
        end else if (!EN) begin
            div <= 4'd0; acq_mode <= 1'b0; acq_armed <= 1'b0; flush <= 4'd0;
            acq_ok <= 1'b0; acq_fail <= 1'b0; acq_busy <= 1'b0;
            code_target <= CODE_START; code_target_q <= CODE_START;
            commit_tog <= 1'b0;
            lo <= CODE_MIN; hi <= CODE_MAX;
            main_tog_seen <= 1'b0; mon_tog_seen <= 1'b0;
            main_evt <= 1'b0; mon_evt <= 1'b0;
            alive_cnt <= 3'd0; acq_settle <= 2'd0;
            phase_good <= 8'd0; phase_ok_r <= 1'b0;
            phase_delta <= 16'd0; mon_delta_r <= 16'd0;
            range_live <= 1'b0; mon_bad <= 2'd0;
        end else begin
            div <= div + 1'b1;

            // Event detection from the synchronized TDC toggles.
            if (main_tog != main_tog_seen) begin
                main_tog_seen <= main_tog;
                alive_cnt <= 3'd0;
                if (acq_ok) begin
                    // tracking event; consume immediately
                    phase_delta <= pd[15:0];
                    if ((pd <= phase_tol) ||
                        (pd >= period_ticks - phase_tol)) begin
                        if (phase_good < LOCK_COUNT[7:0])
                            phase_good <= phase_good + 1'b1;
                        if (phase_good + 1 >= LOCK_COUNT[7:0])
                            phase_ok_r <= 1'b1;
                    end else begin
                        phase_good <= 8'd0;
                        phase_ok_r <= 1'b0;
                        // Fine-only tracking: hold the acquired coarse.
                        if ((pd > phase_tol) && (pd < period_ticks / 2)) begin
                            if (code_target > active_coarse * 56)
                                code_target <= code_target - 1'b1;
                        end else if ((pd >= period_ticks / 2) &&
                                     (pd < period_ticks - phase_tol)) begin
                            if (code_target < active_coarse * 56 + 55)
                                code_target <= code_target + 1'b1;
                        end
                    end
                end else begin
                    main_evt <= 1'b1;   // acquisition consumes it at div==4
                end
            end else begin
                if (alive_cnt < 3'd4) alive_cnt <= alive_cnt + 1'b1;
                if (acq_ok) begin
                    // no valid output edge in this REF window
                    phase_good <= 8'd0;
                    phase_ok_r <= 1'b0;
                end
            end

            // Monitor event: continuous absolute-range revalidation.
            if (mon_tog != mon_tog_seen) begin
                mon_tog_seen <= mon_tog;
                mon_delta_r <= md[15:0];
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
                    dd = ad;
                    acq_delay <= ad[15:0];
                    if (dd < period_ticks) begin
                        if (code_target >= hi) begin
                            if (dd >= period_ticks - acq_tol) begin
                                acq_ok <= 1'b1;
                                range_live <= 1'b1;
                                mon_bad <= 2'd0;
                            end else begin
                                acq_fail <= 1'b1;
                            end
                            acq_busy <= 1'b0;
                        end else begin
                            lo <= code_target + 1'b1;
                            code_target <= code_target +
                                ((hi - code_target + 1'b1) >> 1);
                        end
                    end else begin
                        if (code_target <= lo) begin
                            if (dd <= period_ticks + acq_tol) begin
                                acq_ok <= 1'b1;
                                range_live <= 1'b1;
                                mon_bad <= 2'd0;
                            end else begin
                                acq_fail <= 1'b1;
                            end
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
    always @(negedge commit_strobe or negedge RST_N) begin
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
endmodule
