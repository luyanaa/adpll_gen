`timescale 1ps/1ps
// 8-phase all-digital DLL: 8 elements lock to a FULL period (8d = T).
//
// Two selectable phase detectors (PD_MODE):
//   1 = TDC (default).  The TDC *measures* the REF->TAP[7] phase in TICK_FAST
//       units (one LSB = T/256) instead of resolving a sign, so there is no
//       latch neutral band swallowing the error.  Resolution 15.6 ps at 250 MHz
//       and 7.8 ps at 500 MHz, which is what lets the loop hold the lock point
//       inside the <= 34 ps budget needed for tap7 <= 30 ps.
//   0 = legacy bang-bang latch (kept so the comparison is reproducible).
//
// Loop topology is unchanged in both modes:
//   * EIGHT elements, 8d = T (full period), duty-cycle immune.
//   * Per-element signed trim: code_i = clamp(loop_code + trim_i).
//   * Absolute-range acquisition (harmonic-lock fix): during acquisition the
//     line is clocked by REF/8 and the REF->TAP[7] delay is counted in TICK
//     (=16 x REF) units, so 8d = T reads NOM_COUNTS = 16 unambiguously.  The
//     code walks until the count is in range, then the line switches to REF
//     and the tracking loop takes over.
//   * Measured-delay lock validator: LOCKED requires the TDC phase error to
//     sit inside a small band for LOCK_COUNT cycles.
//
// TDC usage: the lock loop always closes on TAP[7] (so monitoring does not
// disturb it), while MON_OUT drives TAP[TAP_SEL].  The monitor stamp is how
// per-element delays are measured and the per-element trims are derived.
`default_nettype none

// Per-element code = clamp(loop_code + trim + pd_offset, 0, MAXC).  A
// submodule keeps the part-select assignment out of a generate scope
// (iverilog 12 limit).
module DLL8_CODE_CALC #(
    parameter integer CODE_BITS = 7,
    parameter integer MAXC = 127
) (
    input  wire [CODE_BITS-1:0] BASE,
    input  wire signed [4:0]    TRIM,
    input  wire signed [4:0]    PD_OFF,   // common-mode code offset
    output wire [CODE_BITS-1:0] CODE
);
    wire signed [CODE_BITS+5:0] sum =
        $signed({1'b0, BASE}) + $signed(TRIM) + $signed(PD_OFF);
    assign CODE = (sum < 0) ? {CODE_BITS{1'b0}} :
                  (sum > MAXC) ? MAXC[CODE_BITS-1:0] : sum[CODE_BITS-1:0];
endmodule

module DLL8_TOP #(
    parameter integer CODE_BITS   = 7,
    parameter integer MAXC        = 127,
    parameter integer FILTER_BITS = 16,
    parameter integer LOCK_COUNT  = 24,
    // Absolute-range acquisition: TICK = 16 x REF, so 8d = T reads NOM.
    parameter integer NOM_COUNTS  = 16,
    // PD_MODE: 0 = bang-bang latch (legacy), 1 = TDC (default).
    parameter integer PD_MODE     = 1,
    parameter integer TDC_BITS    = 16,
    // TDC tracking dead band.  One code step moves 8d by 8*STEP_PS, which is
    // about 8 TDC LSBs, so the band must cover half a step or the loop
    // limit-cycles by +-1 code: 4 LSB = 15.6 ps at 250 MHz.
    parameter integer ERR_BAND    = 4,
    // Lock band in TDC LSBs.
    parameter integer LOCK_TOL    = 5,
    // Update the TDC integrator once every UPDATE_DIV REF cycles.  The phase
    // reading is one period old (code -> line -> tap edge -> capture); at one
    // step per period a code step of ~8 LSB overshoots and the loop
    // limit-cycles.  Spacing the updates lets the effect of each step be
    // measured before the next one.
    parameter integer UPDATE_DIV  = 3,
    // Timing model (DLL8_IMPL=0).  Set per corner by the testbench.
    parameter integer BASE_PS     = 110,
    parameter integer STEP_PS     = 3,
    parameter integer DLL8_IMPL   = 0
) (
    input  wire                    REF,
    input  wire                    RST_N,
    input  wire                    EN,
    input  wire                    TICK,      // 16 x REF (range counter)
    input  wire                    TICK_FAST, // 256 x REF (TDC)
    input  wire [2:0]              TAP_SEL,   // monitor tap for the TDC
    input  wire [FILTER_BITS-1:0]  KI,
    input  wire signed [4:0]       PD_OFFSET, // static code offset
    // Bang-bang detector input delays (PD_MODE=0 only).
    input  wire [CODE_BITS-1:0]    PD_TRIM_V,
    input  wire [CODE_BITS-1:0]    PD_TRIM_R,
    input  wire [CODE_BITS-1:0]    CODE_INIT, // reset code (rail test hook)
    input  wire                    HOLD,     // freeze the code (measurement)
    input  wire                    TRIM_LD,
    input  wire signed [8*5-1:0]   TRIM_IN,
    output wire [7:0]              TAP,
    output wire                    LOCKED,
    output wire [CODE_BITS-1:0]    LOOP_CODE,
    output wire [8*CODE_BITS-1:0]  ELEM_CODES,
    output wire [7:0]              MEAS_COUNTS,
    output wire                    ACQ_DONE,
    output wire [TDC_BITS-1:0]     TAP_STAMP,   // TAP[7] timestamp
    output wire [TDC_BITS-1:0]     MON_STAMP,   // TAP[TAP_SEL] timestamp
    output wire [TDC_BITS-1:0]     REF_STAMP,
    output wire [TDC_BITS-1:0]     PERIOD_TICKS
);
    // ---------------------------------------------------------------- trim
    reg signed [4:0] trim [0:7];
    integer ti;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            for (ti = 0; ti < 8; ti = ti + 1) trim[ti] <= 5'sd0;
        end else if (TRIM_LD) begin
            for (ti = 0; ti < 8; ti = ti + 1) trim[ti] <= TRIM_IN[ti*5 +: 5];
        end
    end

    // ------------------------------------- absolute-range acquisition
    // A phase detector cannot tell a small delay from a delay one period
    // larger, so the range is measured ABSOLUTELY: during acquisition the
    // line is clocked by REF/8, and TICK (16 x REF) edges are counted from
    // acq_clk's rising edge to TAP[7]'s rising edge.  8d = T reads NOM.
    reg [4:0] refdiv;
    reg       acq_clk;
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            refdiv  <= 5'd0;
            acq_clk <= 1'b0;
        end else begin
            refdiv <= refdiv + 5'd1;
            if (refdiv == 5'd3) begin
                refdiv  <= 5'd0;
                acq_clk <= ~acq_clk;
            end
        end
    end

    wire line_in  = acq_done ? REF : acq_clk;

    reg [7:0] cnt;
    reg [7:0] meas;
    reg       acq_done;
    reg       acq_q;
    // Single clock domain: acq_clk's rising edge is detected in the TICK
    // domain, so only one process drives cnt.
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            cnt   <= 8'd0;
            acq_q <= 1'b0;
        end else begin
            acq_q <= acq_clk;
            if (acq_clk && !acq_q) cnt <= 8'd0;
            else                   cnt <= cnt + 8'd1;
        end
    end
    always @(posedge TAP[7] or negedge RST_N) begin
        if (!RST_N)         meas <= 8'd0;
        else if (!acq_done) meas <= cnt;
    end
    assign MEAS_COUNTS = meas;
    assign ACQ_DONE    = acq_done;

    // ------------------------------------------------------------------ TDC
    // Coherent phase TDC: TAP[7] drives the lock measurement, MON the monitor
    // sweep, so changing TAP_SEL cannot disturb the loop.  Phase is in
    // TICK_FAST units (one LSB ~= T/1024).
    wire [TDC_BITS-1:0] tdc_tap, tdc_mon, tdc_period;
    DLL8_TDC #(.BITS(TDC_BITS)) u_tdc (
        .TICK(TICK_FAST), .REF(REF),
        .TAP(TAP[7]), .MON(TAP[TAP_SEL]),
        .RST_N(RST_N),
        .tap_phase(tdc_tap), .mon_phase(tdc_mon), .period(tdc_period)
    );
    assign TAP_STAMP    = tdc_tap;
    assign MON_STAMP    = tdc_mon;
    assign REF_STAMP    = tdc_period;
    assign PERIOD_TICKS = tdc_period;

    // Signed phase error, wrapped to +-period/2; 0 => 8d = T.
    //   err_raw small positive : tap7 late  (8d > T) -> reduce delay
    //   err_raw near period    : tap7 early (8d < T) -> increase delay
    wire [TDC_BITS-1:0] err_raw  = tdc_tap;
    wire [TDC_BITS-1:0] half_per = {1'b0, tdc_period[TDC_BITS-1:1]};
    wire                err_late = (err_raw > half_per);
    wire [TDC_BITS-1:0] err_mag  = err_late ? (tdc_period - err_raw) : err_raw;
    // Dead band: half a code step.  Inside it the loop holds.
    wire                err_act  = (err_mag > ERR_BAND);

    // ----------------------------------------------------- bang-bang PD
    // Detector-input trim delays (PD_MODE=0 only; the TDC taps TAP directly).
    wire ref_pd, vco_pd;
    DLL8_ELEM #(
        .BASE_PS(0), .STEP_PS(STEP_PS), .CODE_BITS(CODE_BITS),
        .DLL8_IMPL(DLL8_IMPL)
    ) u_pdtrim_r (.IN(REF), .CODE(PD_TRIM_R), .OUT(ref_pd), .LOAD());
    DLL8_ELEM #(
        .BASE_PS(0), .STEP_PS(STEP_PS), .CODE_BITS(CODE_BITS),
        .DLL8_IMPL(DLL8_IMPL)
    ) u_pdtrim_v (.IN(TAP[7]), .CODE(PD_TRIM_V), .OUT(vco_pd), .LOAD());

    wire [1:0] pd_raw;
`ifdef SIMULATION
    sim_SSBBPD bbpd (.CLK_VCO(~vco_pd), .CLK_REF(~ref_pd), .SS_BBPD(pd_raw));
`else
    PLL_SSBBPD bbpd (
        .INJ_EDGE_BALANCED(~ref_pd), .OSC_BALANCED(~vco_pd), .SS_BBPD(pd_raw)
    );
`endif
    reg [1:0] pd_sync;
    always @(negedge ref_pd or negedge RST_N) begin
        if (!RST_N) pd_sync <= 2'b00;
        else        pd_sync <= pd_raw;
    end

    reg [CODE_BITS-1:0] loop_code;

    // ------------------------------------------------ acquisition direction
    wire acq_up   = !acq_done && (meas + 8'd1 < NOM_COUNTS[7:0]);
    wire acq_down = !acq_done && (meas > NOM_COUNTS[7:0] + 8'd1);

    // -------------------------------------------------- first-order filter
    // In TDC mode the filter is parked (SS_BBPD = 00) and the TDC integrator
    // drives the code; in BB mode it runs as before, including during
    // acquisition (forced direction) so the handover is jump-free.
    wire [1:0] pd_used = (PD_MODE != 0) ? 2'b00 :
                         (acq_up   ? 2'b11 :
                          acq_down ? 2'b10 : pd_sync);

    wire [FILTER_BITS-1:0] dlf_out;
    wire                   ill_p, ill_n;
    // The loop updates once per REF edge after acquisition (one PD decision =
    // one code step) and once per acquisition window while ranging.
    wire loop_clk = !acq_done ? acq_clk : REF;
    pll_digital_loop_filter #(.BITS(FILTER_BITS), .INVERT_PN(1)) dlf (
        .CLK(loop_clk), .RST_N(RST_N), .ENABLE(EN),
        .SS_BBPD(pd_used),
        .KP({FILTER_BITS{1'b0}}), .KI(KI),
        .OUT(dlf_out), .ILL_P(ill_p), .ILL_N(ill_n)
    );

    wire [FILTER_BITS-1:0] code_sat =
        (dlf_out > MAXC) ? MAXC[FILTER_BITS-1:0] : dlf_out;

    // ------------------------------------------------------ code update
    wire [CODE_BITS-1:0] acq_up_next =
        (loop_code == MAXC[CODE_BITS-1:0]) ? loop_code : loop_code + 1'b1;
    wire [CODE_BITS-1:0] acq_dn_next =
        (loop_code == {CODE_BITS{1'b0}}) ? loop_code : loop_code - 1'b1;
    wire [CODE_BITS-1:0] tdc_up_next =
        (loop_code == MAXC[CODE_BITS-1:0]) ? loop_code : loop_code + 1'b1;
    wire [CODE_BITS-1:0] tdc_dn_next =
        (loop_code == {CODE_BITS{1'b0}}) ? loop_code : loop_code - 1'b1;

    // TDC tracking: at most one code step per UPDATE_DIV REF cycles, only
    // while the measured error is outside the dead band.
    // err_late => tap7 early => more delay.
    reg [7:0] upd_div;
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) upd_div <= 8'd0;
        else if (upd_div == UPDATE_DIV[7:0] - 8'd1) upd_div <= 8'd0;
        else upd_div <= upd_div + 8'd1;
    end
    wire upd_en = (upd_div == UPDATE_DIV[7:0] - 8'd1);
    wire [CODE_BITS-1:0] tdc_next =
        (!err_act || !upd_en) ? loop_code :
        (err_late ? tdc_up_next : tdc_dn_next);

    wire [CODE_BITS-1:0] acq_next =
        acq_up   ? acq_up_next :
        acq_down ? acq_dn_next : loop_code;

    wire [CODE_BITS-1:0] code_next =
        (PD_MODE != 0) ? (!acq_done ? acq_next : tdc_next)
                       : code_sat[CODE_BITS-1:0];

    always @(posedge loop_clk or negedge RST_N) begin
        if (!RST_N)        loop_code <= CODE_INIT;
        else if (!EN)      loop_code <= CODE_INIT;
        else if (HOLD)     loop_code <= loop_code;
        else               loop_code <= code_next;
    end
    assign LOOP_CODE = loop_code;

    // Acquisition completes when the measured range is within one count of a
    // full period.
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) acq_done <= 1'b0;
        else if (!EN) acq_done <= 1'b0;
        else if (!acq_done &&
                 (meas + 8'd1 >= NOM_COUNTS[7:0]) &&
                 (meas <= NOM_COUNTS[7:0] + 8'd1)) acq_done <= 1'b1;
    end

    // -------------------------------------------------- per-element codes
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : elem_code
            DLL8_CODE_CALC #(.CODE_BITS(CODE_BITS), .MAXC(MAXC)) u_calc (
                .BASE(loop_code), .TRIM(trim[i]), .PD_OFF(PD_OFFSET),
                .CODE(ELEM_CODES[i*CODE_BITS +: CODE_BITS])
            );
        end
    endgenerate

    // ------------------------------------------------------------ the line
    DLL8_LINE #(
        .BASE_PS(BASE_PS), .STEP_PS(STEP_PS),
        .CODE_BITS(CODE_BITS), .DLL8_IMPL(DLL8_IMPL)
    ) u_line (
        .IN(line_in), .CODES(ELEM_CODES), .TAP(TAP)
    );

    // --------------------------------------------------------------- lock
    // LOCKED requires acquisition done, no rail/illegal state, no code jump,
    // and the measured TDC phase inside LOCK_TOL LSBs, held for LOCK_COUNT
    // code-update cycles.
    wire ill = (PD_MODE != 0) ? 1'b0 : (ill_p | ill_n);
    reg [7:0] stable;
    reg [CODE_BITS-1:0] code_d;
    // Any code change clears the lock counter: LOCKED means genuinely
    // settled, so a dithering/limit-cycling loop must not report lock.
    wire code_jump = (loop_code != code_d);
    always @(posedge loop_clk or negedge RST_N) begin
        if (!RST_N) begin
            stable <= 8'd0;
            code_d <= CODE_INIT;
        end else begin
            code_d <= loop_code;
            if (!EN || !acq_done || ill || code_jump ||
                (err_mag > LOCK_TOL))
                stable <= 8'd0;
            else if (stable != LOCK_COUNT[7:0])
                stable <= stable + 8'd1;
        end
    end
    assign LOCKED = acq_done && (stable == LOCK_COUNT[7:0]);

`ifdef SIMULATION
    // Simulation-only power-on values: every one of these flops also has an
    // async reset; the initial values just remove start-up X from the
    // combinational range comparisons.
    initial begin
        cnt = 8'd0; meas = 8'd0; acq_q = 1'b0; acq_done = 1'b0;
        refdiv = 5'd0; acq_clk = 1'b0; stable = 8'd0;
        code_d = {CODE_BITS{1'b0}}; loop_code = {CODE_BITS{1'b0}};
    end
`endif
endmodule
`default_nettype wire
