`timescale 1ns/1ps
// ADCC_TOP — all-digital duty-cycle corrector for a DDR PHY clock path.
// Reuses the same infrastructure as ADDLL:
//   * PLL_SSBBPD            bang-bang PD (used here as a duty detector)
//   * pll_digital_loop_filter  degraded to an up/down counter (KP=0)
//   * pll_term_decoder_with_zero  binary -> thermometer
//   * PLL_COUNTER_DCDL_PHYS      tapped delay line (one edge path)
//   * dither-window lock detect (same idea as addll_top)
//
// Duty detection — AVERAGING sampler (not edge bang-bang).
//
// Why: a BBPD comparing the corrected fall against ~CLK_IN measures the
// output's fall against the *input's own* duty point (e.g. 30%), not T/2,
// so its sign is permanently "late" and the loop parasitic-locks.  The
// right detector integrates the output level: sample CLK_OUT on a clock
// ASYNCHRONOUS to CLK_IN — statistically the fraction of samples that
// land in the high phase equals the duty.  A sample reading 1 means the
// high pulse is still too long -> shrink it (delay fall less -> decrease
// code); a 0 means too short -> increase code.  The DLF's integrator
// averages these 1-bit votes until duty = 50%.
//
// The sampling clock SAMP must be incommensurate with CLK_IN so the
// samples sweep the whole period (a coherent SAMP would alias to one
// point on the waveform).  In silicon SAMP is a spare ring-oscillator /
// divided reference; in sim it is an independent ~1.11 ns clock.
//
// Correction: only the FALLING edge is moved (rise stays referenced).
// The inverted signal passes through the DCDL so its falling-edge delay
// shifts the output's high pulse width.
module ADCC_TOP #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer FILTER_BITS = 16,
    parameter integer LOCK_COUNT = 16,
    parameter integer LOSS_COUNT = 4,
    parameter integer MID_W = 4,
    parameter integer COARSE_W = 8
) (
    input  CLK_IN,          // input clock with duty error
    input  RST_N,
    input  TICK,            // loop sampling clock
    input  SAMP,            // asynchronous duty-sampling clock
    input  EN,
    input  [FILTER_BITS-1:0] KI,
    input  [7:0] DUTY_OFFS, // static offset added to correction code
    input  [7:0] DUTY_INIT, // preload while EN=0
    output CLK_OUT,         // duty-corrected clock
    output LOCKED,
    output ERR,
    output [7:0] DUTY_CODE
);
    localparam integer TOTAL_STEPS =
        FINE_NDELS + MID_W*MID_NDELS + COARSE_W*COARSE_NDELS;

    // Inverted input: its rising edge marks the end of the high pulse.
    wire clk_n = ~CLK_IN;

    // Averaging duty detector: sample CLK_OUT on the async SAMP clock,
    // synchronise the vote into TICK, and encode it onto the DLF symbol
    // set.  sample=1 (hit high phase) -> SYMBOL_P (code+1 -> more fall
    // delay -> shorter high pulse); sample=0 -> SYMBOL_N (code-1).
    reg duty_samp, duty_samp_q;
    always @(posedge SAMP or negedge RST_N) begin
        if (!RST_N) duty_samp <= 1'b0;
        else        duty_samp <= CLK_OUT;
    end
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) duty_samp_q <= 1'b0;
        else        duty_samp_q <= duty_samp;
    end
    // DLF reads {OUT,REF}: 01 = +1 (SYMBOL_P), 11 = -1 (SYMBOL_N),
    // others = hold.  Longer fall delay widens the high pulse, so:
    //   sample 0 (hit low phase, pulse too short)  -> code+1 (01)
    //   sample 1 (hit high phase, pulse too long)  -> code-1 (11)
    wire [1:0] SS_BBPD = duty_samp_q ? 2'b11 : 2'b01;

    wire [FILTER_BITS-1:0] DLF_OUT;
    wire ILL_P, ILL_N;
    pll_digital_loop_filter #(.BITS(FILTER_BITS)) dlf (
        .CLK(TICK), .RST_N(RST_N), .ENABLE(EN),
        .SS_BBPD(SS_BBPD),
        .KP({FILTER_BITS{1'b0}}), .KI(KI),
        .OUT(DLF_OUT), .ILL_P(ILL_P), .ILL_N(ILL_N)
    );

    // Delay code = accumulator + static offset, saturated to the chain
    // range.  The level-integrating detector converges monotonically, so
    // no SAR seed is needed (unlike the edge-BBPD version).
    wire [FILTER_BITS-1:0] sum = DLF_OUT + {{(FILTER_BITS-8){1'b0}}, DUTY_OFFS};
    wire [FILTER_BITS-1:0] sat = (sum > TOTAL_STEPS) ? TOTAL_STEPS[FILTER_BITS-1:0] : sum;
    assign DUTY_CODE = EN ? sat[7:0] : DUTY_INIT;
    wire [7:0] code = DUTY_CODE;

    // Two-stage pipeline identical to ADDLL_TOP: register the decoded tap
    // counts so DLF->decode->tap is not a single-cycle path.  MID_W=4 and
    // COARSE_W=8 are powers of two, so the divides are shifts.
    wire [7:0] fine_w   = (code > FINE_NDELS) ? FINE_NDELS : code;
    wire [7:0] rem1     = code - fine_w;
    wire [7:0] mid_w    = (rem1[7:2] > MID_NDELS) ? MID_NDELS : rem1[7:2];
    wire [7:0] rem2     = rem1 - (mid_w << 2);
    wire [7:0] coarse_w = (rem2[7:3] > COARSE_NDELS) ? COARSE_NDELS : rem2[7:3];
    reg [7:0] fine_n, mid_n, coarse_n;

    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N)   {fine_n, mid_n, coarse_n} <= 0;
        else          {fine_n, mid_n, coarse_n} <= {fine_w, mid_w, coarse_w};
    end

    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0]    MID_MUX;
    wire [FINE_NDELS-1:0]   FINE_MUX;
    pll_term_decoder_with_zero #(.NDELS(COARSE_NDELS)) dec_c (
        .IN(coarse_n[$clog2(COARSE_NDELS+1)-1:0]), .OUT(COARSE_MUX));
    pll_term_decoder_with_zero #(.NDELS(MID_NDELS)) dec_m (
        .IN(mid_n[$clog2(MID_NDELS+1)-1:0]), .OUT(MID_MUX));
    pll_term_decoder_with_zero #(.NDELS(FINE_NDELS)) dec_f (
        .IN(fine_n[$clog2(FINE_NDELS+1)-1:0]), .OUT(FINE_MUX));

    // Single-edge correction: delay only the inverted (falling-edge) path,
    // then recombine.  CLK_OUT rise = CLK_IN rise; CLK_OUT fall = delayed
    // fall of CLK_IN.  High-pulse width = code-controlled.
    //
    // Glitch control: the OR recombine `CLK_IN | ~fall_d` is kept (it has
    // the right priority: while CLK_IN is high the output is 1 regardless
    // of a late fall_d).  The glitch the earlier prototype saw came from
    // taps changing while a falling edge was in flight -- that is now
    // prevented by the `upd_ok` quiet-window gate above, so the taps can
    // only move while CLK_IN is high and fall_d is statically 1.
    wire fall_d;
`ifdef SIMULATION
    // For the falling-edge corrector the DCDL insertion delay must be well
    // under the input's low half-period, otherwise fall_d can never land
    // inside the quiet window.  Use a realistic short T0 here (a real
    // single-edge DCDL is a few hundred ps, not the 4 ns full-period
    // insertion the ADDLL phase shifter wants).
    PLL_COUNTER_DCDL #(
        .COARSE_NDELS(COARSE_NDELS), .MID_NDELS(MID_NDELS), .FINE_NDELS(FINE_NDELS),
        .T0_PS(200)
    ) dcdl (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_IN(clk_n), .CLK_OUT(fall_d)
    );
    assign CLK_OUT = CLK_IN ? 1'b1 : ~fall_d;
`else
    PLL_COUNTER_DCDL_PHYS #(
        .COARSE_NDELS(COARSE_NDELS), .MID_NDELS(MID_NDELS), .FINE_NDELS(FINE_NDELS)
    ) dcdl (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_IN(clk_n), .CLK_OUT(fall_d)
    );
    assign CLK_OUT = CLK_IN | ~fall_d;
`endif

    // Lock = duty code holds inside a +/-DITHER_BAND window for LOCK_COUNT.
    reg [FILTER_BITS-1:0] dmin, dmax;
    reg [7:0] win_cnt;
    reg locked_r, lost_r;
    localparam integer DITHER_BAND = 4;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            dmin <= {FILTER_BITS{1'b1}}; dmax <= 0; win_cnt <= 0;
            locked_r <= 1'b0; lost_r <= 1'b0;
        end else if (!EN) begin
            dmin <= {FILTER_BITS{1'b1}}; dmax <= 0; win_cnt <= 0;
            locked_r <= 1'b0; lost_r <= 1'b0;
        end else begin
            if (DLF_OUT < dmin) dmin <= DLF_OUT;
            if (DLF_OUT > dmax) dmax <= DLF_OUT;
            if ((dmax - dmin) <= DITHER_BAND) begin
                if (win_cnt < 8'hff) win_cnt <= win_cnt + 1;
            end else begin
                dmin <= DLF_OUT; dmax <= DLF_OUT; win_cnt <= 0;
                if (locked_r) lost_r <= 1'b1;
                locked_r <= 1'b0;
            end
            if (win_cnt >= LOCK_COUNT[7:0]) locked_r <= 1'b1;
        end
    end
    assign LOCKED = locked_r;
    assign ERR    = lost_r | ILL_P | ILL_N;
endmodule
