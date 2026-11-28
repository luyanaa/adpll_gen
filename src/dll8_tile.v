`timescale 1ps/1ps
// -----------------------------------------------------------------------------
// dll8_tile -- production 8-phase all-digital DLL tile.
//
//   REF -> [2x dll8_line4 hard macros, 8 elements chained] -> TAP[7:0]
//   Control: FINE per-element codes, DFF phase detector, first-order DLF.
//
// ---------------------------------------------------------------------------
// WHY FINE PER-ELEMENT CODES (measured evidence, 2026-11-28)
// ---------------------------------------------------------------------------
// The element bank's tuning step is BASE 148 / STEP 5.0 ps at SS.  With ONE
// code broadcast to all 8 elements, one code step moves tap7 by 8*STEP = 40 ps
// -- larger than the 30 ps phase budget.  A sign-only (bang-bang) loop then
// necessarily limit-cycles over one code step (40 ps at tap7, SS): the first
// tile build measured worst |phase_k-kT/8| = 61 ps for exactly this reason.
//
// The line exposes EN0..EN3 per element (4 separate 127-bit straps per strip),
// so each element can carry its own code.  Let the loop own a fine
// accumulator S = sum(code_i) in units of one element STEP:
//     S = 8*c + m,  c = S>>3 (coarse), m = S&7 (fine phase 0..7)
//     code_i = c + d_i,  d_i = round((i+1)*m/8) - round(i*m/8)   (Bresenham)
// Then for tap_k (after k+1 elements, k=0..7):
//     tap_k   = (k+1)*BASE + STEP*((k+1)*c + round((k+1)*m/8))
//     target  = (k+1)*(BASE + STEP*(c + m/8))
//     |tap_k - target| <= 0.5*STEP   for EVERY k   (error does not accumulate)
// and tap7 = 8*BASE + STEP*S: the tap7 tuning step is STEP (5 ps SS), not
// 8*STEP.  The Bresenham split converts the 8-element line into a 1016-step
// DCDL with no analog delay, no TDC and no new IP.
//
// ---------------------------------------------------------------------------
// PHASE DETECTOR (why not PLL_SSBBPD)
// ---------------------------------------------------------------------------
// PLL_SSBBPD is a NAND cross-coupled latch meant for *sub-sampling pulse*
// operation.  Driven with continuous complementary clock levels -- the way
// DLL8_TOP drove it -- both inputs go low after the second edge and the latch
// returns to its (11) state, erasing the decision before any fixed sample
// point.  Probe evidence (/tmp/opencode/dll8tile): pd_sync read 11 at every
// offset; the loop had no sign information.  The "PD_MODE=0 settles at
// anti-phase" note in docs/dco_8phase_decision.md is an artifact of that model.
//
// This tile uses a DFF detector: D=REF, CLK=TAP7.  At the TAP7 rising edge,
// REF is high iff d > T (too long) -- a true sign detector around d = T,
// correct for d in (T/2, 3T/2).  Acquisition lands the line in (T, T+T/2) by
// construction, so the detector never operates out of range.  The DFF's
// metastability window is the residual dither source (~10-20 ps), sampled half
// a period later by the loop clock.
//
// ---------------------------------------------------------------------------
// ACQUISITION (T/2 resolution, harmonic-safe)
// ---------------------------------------------------------------------------
// The line is clocked by REF/4 during acquisition; TAP7's rising edge captures
//     meas = {refdiv[0], ~REF} = floor(d/(T/2)) mod 4:
//     0: d<T/2   1: (T/2,T)   2: (T,T+T/2)   3: (T+T/2,2T)
// Target is EXACTLY meas=2 -- the half period in which the DFF detector is
// guaranteed correct.  meas=3 must step down, meas<2 steps up.  Each
// acquisition cycle moves S by 8 (one coarse code = 40 ps at tap7 SS), so the
// handoff lands at 8d = T + 0..40 ps.
//
// ---------------------------------------------------------------------------
// REGENERATION (SPICE-verified cell structure)
// ---------------------------------------------------------------------------
// flow/characterization/dll8_regen_spice.py: edge pulse on TAP[k+4] via
// inv -> inv -> nand2 -> inv, active-low async reset of a DFF clocked by
// TAP[k] with D=1.  High time = T/2 exactly when 8d = T; both edges are
// rising, so the bank's tpHL/tpLH asymmetry cannot enter duty.
// -----------------------------------------------------------------------------
`default_nettype none

module dll8_tile #(
    parameter integer CODE_BITS   = 7,
    // S = sum of the 8 element codes.  Max = 8*127.
    parameter integer S_MAX       = 1016,
    parameter integer FILTER_BITS = 16,
    // Lock qualification: S must stay inside a LOCK_TOL window for LOCK_WIN
    // consecutive loop cycles (a parked fine accumulator).
    parameter integer LOCK_WIN    = 128,
    parameter integer LOCK_TOL    = 8,
    // Behavioral line timing passthrough (sim only).
    parameter real    BASE_PS     = 110.0,
    parameter real    STEP_PS     = 3.0,
    parameter real    A2_PS       = 0.0,
    parameter real    A3_PS       = 0.0,
    // Phase-detector timing model (sim only).  The DFF's decision boundary
    // is NOT at the clock pin edge: SPICE (sg13g2_dfrbp_1, ideal 20 ps data
    // ramp) measures "data must lead the clock edge by" = 122 / 92 / 61 ps at
    // SS / TT / FF.  A clock-path buffer (buf_4 = 108 / 71 / 51 ps) moves the
    // sampling instant later and cancels most of it; the residual is closed
    // post-layout with a routing snake (documented in REPORT_tile_rtl).
    parameter real    PD_OFF_PS   = 0.0,   // flop data-lead offset
    parameter real    PD_CLK_PS   = 0.0    // clock-path buffer delay
) (
    input  wire                    REF,
    input  wire                    RST_N,
    input  wire                    EN,
    input  wire [FILTER_BITS-1:0]  KI,
    input  wire [CODE_BITS-1:0]    CODE_INIT,   // coarse starting code
    input  wire                    HOLD,       // freeze the accumulator
    output wire [7:0]              PHASE,      // duty-regenerated phases
    output wire                    LOCKED,
    output wire [CODE_BITS-1:0]    LOOP_CODE,  // coarse code (c)
    output wire [10:0]             LOOP_S,     // fine accumulator
    output wire                    ACQ_DONE,
    output wire [3:0]              MEAS_COUNTS
);

    wire [7:0] tap;

    // ---------------------------------------------------------- acquisition
    reg [1:0] refdiv;
    reg       acq_clk;
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            refdiv  <= 2'd0;
            acq_clk <= 1'b0;
        end else if (refdiv == 2'd1) begin
            refdiv  <= 2'd0;
            acq_clk <= ~acq_clk;
        end else begin
            refdiv <= refdiv + 2'd1;
        end
    end

    reg  acq_done;
    wire line_in = acq_done ? REF : acq_clk;

    // T/2-resolution range capture: refdiv resets at both acq_clk edges and
    // counts REF edges from the launch; REF's level supplies the half bit.
    reg [3:0] meas;
    always @(posedge tap[7] or negedge RST_N) begin
        if (!RST_N)         meas <= 4'd0;
        else if (!acq_done) meas <= {2'b00, refdiv[0], ~REF};
    end
    assign MEAS_COUNTS = meas;
    assign ACQ_DONE    = acq_done;

    wire acq_up   = !acq_done && (meas < 4'd2);
    wire acq_down = !acq_done && (meas > 4'd2);

    // One code update per acquisition period, placed at the REF falling edge
    // where acq_clk is low and refdiv has just wrapped (t = 2.5T after the
    // launch).  That is AFTER the TAP7 rise (d < 2T, so meas is captured) and
    // well BEFORE the next launch at 4T, so each measurement corresponds to a
    // settled code -- the update/launch race that latched a false meas=2 on
    // the high-rail start is gone.
    wire acq_upd = !acq_done && !acq_clk && (refdiv == 2'd0);

    reg acq_seen;
    always @(negedge REF or negedge RST_N) begin
        if (!RST_N)             acq_seen <= 1'b0;
        else if (!EN || acq_done) acq_seen <= 1'b0;
        else if (acq_upd)       acq_seen <= 1'b1;
    end

    always @(posedge REF or negedge RST_N) begin
        if (!RST_N)       acq_done <= 1'b0;
        else if (!EN)     acq_done <= 1'b0;
        else if (!acq_done && acq_seen && meas == 4'd2) acq_done <= 1'b1;
    end

    // ---------------------------------------------------------- accumulator
    wire [FILTER_BITS-1:0] dlf_out;
    reg  [10:0] loop_code_q;          // S
    wire [10:0] s_sat = (dlf_out > S_MAX) ? S_MAX[10:0] : dlf_out[10:0];

    // ------------------------------------------------------------- the line
    // 8 separate 127-bit straps: strap_i[j] = th(code_i)[j] XOR (j odd).
    // This is the ONLY place the polarity contract exists (N fingers even j
    // are ON when HIGH, P fingers odd j are ON when LOW).
    wire [8*127-1:0] strap;
    wire mid, unused_tap6b;

`ifdef DLL8_TILE_SIM
`define DLL8_LINE4_PARAMS #(.BASE_PS(BASE_PS), .STEP_PS(STEP_PS), .A2_PS(A2_PS), .A3_PS(A3_PS))
`else
`define DLL8_LINE4_PARAMS
`endif
    dll8_line4 `DLL8_LINE4_PARAMS line_a (
        .IN(line_in), .OUT(mid),
        .TAP0(tap[0]), .TAP1(tap[1]), .TAP2(tap[2]), .TAP3(tap[3]),
        .EN0(strap[0*127 +: 127]), .EN1(strap[1*127 +: 127]),
        .EN2(strap[2*127 +: 127]), .EN3(strap[3*127 +: 127])
    );
    dll8_line4 `DLL8_LINE4_PARAMS line_b (
        .IN(mid), .OUT(tap[7]),
        .TAP0(tap[4]), .TAP1(tap[5]), .TAP2(tap[6]), .TAP3(unused_tap6b),
        .EN0(strap[4*127 +: 127]), .EN1(strap[5*127 +: 127]),
        .EN2(strap[6*127 +: 127]), .EN3(strap[7*127 +: 127])
    );

    // ------------------------------------------------------------- decoder
    //   code_i = c + d_i,  d_i = round((i+1)*m/8) - round(i*m/8)
    // (x*m + 4) >> 3 is round(x*m/8) for non-negative x.
    function [6:0] elem_code;
        input [6:0] cc;
        input [2:0] mm;
        input integer idx;
        integer a, b;
        begin
            a = (idx * mm + 4) >> 3;
            b = ((idx + 1) * mm + 4) >> 3;
            elem_code = cc + (b - a);
        end
    endfunction

    // iverilog forbids nested generate regions: compute the 8 codes with
    // explicit assignments, then a single flat 1016-bit generate loop.
    wire [8*7-1:0] codes;
    assign codes[0*7 +: 7] = elem_code(loop_code_q[9:3], loop_code_q[2:0], 0);
    assign codes[1*7 +: 7] = elem_code(loop_code_q[9:3], loop_code_q[2:0], 1);
    assign codes[2*7 +: 7] = elem_code(loop_code_q[9:3], loop_code_q[2:0], 2);
    assign codes[3*7 +: 7] = elem_code(loop_code_q[9:3], loop_code_q[2:0], 3);
    assign codes[4*7 +: 7] = elem_code(loop_code_q[9:3], loop_code_q[2:0], 4);
    assign codes[5*7 +: 7] = elem_code(loop_code_q[9:3], loop_code_q[2:0], 5);
    assign codes[6*7 +: 7] = elem_code(loop_code_q[9:3], loop_code_q[2:0], 6);
    assign codes[7*7 +: 7] = elem_code(loop_code_q[9:3], loop_code_q[2:0], 7);

    genvar b;
    generate
        for (b = 0; b < 8*127; b = b + 1) begin : decbit
            wire [6:0] ec = codes[(b/127)*7 +: 7];
            assign strap[b] = (ec > (b % 127)) ^ ((b % 127) % 2);
        end
    endgenerate

    // ------------------------------------------------------- phase detector
    // D=REF, CLK=TAP7 (delayed): at the sampling instant REF high => d > T.
    // Both inputs get a 2x inv_16 (fast edge, ~50 ps, non-inverting) so the
    // flop sees the slews its offset was characterized at; the clock gets an
    // extra buf_4 whose delay subtracts from the flop's data-lead offset.
    wire pd_raw, pd_clk, ref_pd;
`ifdef DLL8_TILE_SIM
    assign #(PD_CLK_PS) pd_clk = tap[7];
    assign #(PD_OFF_PS) ref_pd = REF;
    reg pd_q;
    always @(posedge pd_clk) pd_q <= ref_pd;
    assign pd_raw = pd_q;
`else
    wire ref_a, ref_b, tk_a, tk_b;
    sg13g2_inv_16 u_ra (.A(REF),    .Y(ref_a));
    sg13g2_inv_16 u_rb (.A(ref_a),  .Y(ref_b));
    sg13g2_inv_16 u_ka (.A(tap[7]), .Y(tk_a));
    sg13g2_inv_16 u_kb (.A(tk_a),   .Y(tk_b));
    sg13g2_buf_4  u_kc (.A(tk_b),   .X(pd_clk));
    assign ref_pd = ref_b;
    sg13g2_dfrbp_1 u_pd (
        .Q(pd_raw), .Q_N(), .CLK(pd_clk), .D(ref_pd), .RESET_B(RST_N)
    );
`endif

    // One loop clock for both phases: the REF falling edge.  In tracking it
    // is half a period after the detector decision (TAP7 edge at ~T, sample
    // at T + T/2); in acquisition it is the settled-update instant above.
    wire loop_clk = ~REF;

    // ---------------------------------------------------------- loop filter
    // KI is boosted during acquisition: a forced decision must move one full
    // coarse code (8 S counts) per acquisition cycle.
    wire [FILTER_BITS+2:0] ki_wide = {1'b0, KI, 3'b000};
    wire [FILTER_BITS-1:0] ki_eff  = acq_done ? KI :
        (ki_wide > {3'b000, {FILTER_BITS{1'b1}}}) ? {FILTER_BITS{1'b1}}
                                                  : ki_wide[FILTER_BITS-1:0];
    wire                   ill_p, ill_n;
    wire [1:0] pd_used = !acq_done ? (acq_up ? 2'b01 : acq_down ? 2'b11 : 2'b00)
                                   : (pd_raw ? 2'b11 : 2'b01);
    wire dlf_en = EN && (acq_done || acq_upd);
    pll_digital_loop_filter #(.BITS(FILTER_BITS), .INVERT_PN(0)) dlf (
        .CLK(loop_clk), .RST_N(RST_N), .ENABLE(dlf_en),
        .SS_BBPD(pd_used), .KP({FILTER_BITS{1'b0}}), .KI(ki_eff),
        .OUT(dlf_out), .ILL_P(ill_p), .ILL_N(ill_n)
    );

    // Async reset is a CONSTANT 0 (a dynamic async reset value cannot map to
    // a library flop).  CODE_INIT is loaded synchronously while EN is low.
    always @(posedge loop_clk or negedge RST_N) begin
        if (!RST_N)     loop_code_q <= 11'd0;
        else if (!EN)   loop_code_q <= {CODE_INIT, 3'b000};
        else if (acq_done ? !HOLD : acq_upd) loop_code_q <= s_sat;
    end
    assign LOOP_S    = loop_code_q;
    assign LOOP_CODE = loop_code_q[9:3];

    // --------------------------------------------------------------- lock
    // Parked fine accumulator: windowed min/max over LOCK_WIN cycles.
    reg [10:0] s_min, s_max;
    reg [7:0]  win;
    reg        stable;
    always @(posedge loop_clk or negedge RST_N) begin
        if (!RST_N) begin
            win <= 8'd0; s_min <= 11'd0; s_max <= 11'd0; stable <= 1'b0;
        end else if (!EN || !acq_done || HOLD) begin
            win <= 8'd0; s_min <= loop_code_q; s_max <= loop_code_q;
            stable <= 1'b0;
        end else begin
            if (loop_code_q < s_min) s_min <= loop_code_q;
            if (loop_code_q > s_max) s_max <= loop_code_q;
            if (win == LOCK_WIN[7:0] - 8'd1) begin
                stable <= ((s_max - s_min) <= LOCK_TOL[10:0]) &&
                          (s_min != 11'd0) && (s_max != S_MAX[10:0]);
                win    <= 8'd0;
                s_min  <= loop_code_q;
                s_max  <= loop_code_q;
            end else begin
                win <= win + 8'd1;
            end
        end
    end
    assign LOCKED = acq_done && stable;

    // --------------------------------------------------------- regeneration
    genvar k;
    generate
        for (k = 0; k < 8; k = k + 1) begin : regen
            wire tk  = tap[k];
            wire tk4 = tap[(k + 4) % 8];
            wire rda, rpn;
            // Set path: two inverters matched to the reset former's inv+nand,
            // so t_set and t_rst cancel and the high time is T/2 (not
            // T/2 + reset-path delay).  Mismatch is one gate type (~10-20 ps).
            wire ts1, ts2;
`ifdef SIMULATION
            // Zero-delay stdcell models collapse the pulse; the real cells
            // measure ~20-40 ps/stage (dll8_regen_spice.py).  The set path is
            // given the same 2-stage delay so the sim models the matching.
            wire rda_c, rpn_c, ts1_c, ts2_c;
            assign #(30) rda = rda_c;
            assign #(30) rpn = rpn_c;
            assign #(30) ts1 = ts1_c;
            assign #(30) ts2 = ts2_c;
            (* keep *) (* dont_touch = "true" *)
            sg13g2_inv_1 u_rda (.A(tk4), .Y(rda_c));
            (* keep *) (* dont_touch = "true" *)
            sg13g2_nand2_1 u_rpn (.A(tk4), .B(rda), .Y(rpn_c));
            (* keep *) (* dont_touch = "true" *)
            sg13g2_inv_1 u_sda (.A(tk), .Y(ts1_c));
            (* keep *) (* dont_touch = "true" *)
            sg13g2_inv_1 u_sdb (.A(ts1), .Y(ts2_c));
`else
            (* keep *) (* dont_touch = "true" *)
            sg13g2_inv_1 u_rda (.A(tk4), .Y(rda));
            (* keep *) (* dont_touch = "true" *)
            sg13g2_nand2_1 u_rpn (.A(tk4), .B(rda), .Y(rpn));
            (* keep *) (* dont_touch = "true" *)
            sg13g2_inv_1 u_sda (.A(tk), .Y(ts1));
            (* keep *) (* dont_touch = "true" *)
            sg13g2_inv_1 u_sdb (.A(ts1), .Y(ts2));
`endif
            wire rst_comb = rpn & RST_N;
            reg q;
            always @(posedge ts2 or negedge rst_comb) begin
                if (!rst_comb) q <= 1'b0;
                else           q <= 1'b1;
            end
            assign PHASE[k] = LOCKED ? q : 1'b0;
        end
    endgenerate

`ifdef SIMULATION
    initial begin
        refdiv = 2'd0; acq_clk = 1'b0; meas = 4'd0;
        acq_done = 1'b0; loop_code_q = 11'd0;
        s_min = 11'd0; s_max = 11'd0; win = 8'd0; stable = 1'b0;
    end
`endif
endmodule
`default_nettype wire
