`timescale 1ns/1ps
// CDR_TOP — all-digital clock-data recovery (functional model).
//
// Structure: a local reference TICK drives a tapped delay line whose
// output is the recovered data-sampling clock; an Alexander bang-bang PD
// compares the data sample against an edge sample taken one UI phase
// later and steers the DCDL code until the data sample sits at the eye
// centre and the edge sample on the transition boundary.
//
// Reuses: PLL_COUNTER_DCDL (phase shifter for the sampling clock),
// pll_digital_loop_filter (up/down counter, KP=0), term decoders,
// duty_sar_search-style acquisition could be added; kept minimal here.
//
// This is a FUNCTIONAL model — the samplers are behavioural delay taps
// of the DATA waveform, not real FFs.  The physical CDR needs two
// matched sampler FFs driven by the DCDL phases plus a retimer; that is
// called out in CDR_SPEC.md.
module CDR_TOP #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS    = 15,
    parameter integer FINE_NDELS   = 31,
    parameter integer FILTER_BITS  = 16,
    parameter integer LOCK_COUNT   = 16,
    parameter integer MID_W = 4,
    parameter integer COARSE_W = 8,
    parameter integer UI_PS = 1000      // unit-interval, for the phase span
) (
    input  DATA,                    // incoming NRZ serial data
    input  RST_N,
    input  TICK,                    // loop update clock (~ baud-rate ref)
    input  EN,
    input  [FILTER_BITS-1:0] KI,
    input  [7:0] PHASE_OFFS,
    input  [7:0] PHASE_INIT,
    output DATA_OUT,                // recovered (centre-sampled) data
    output REC_CLK,                 // recovered data-phase clock
    output LOCKED, ERR,
    output [7:0] PHASE_CODE
);
    localparam integer TOTAL_STEPS =
        FINE_NDELS + MID_W*MID_NDELS + COARSE_W*COARSE_NDELS;

    // ---- phase-shifter code (DLF + offset, 2-stage pipeline) ----
    // ALEXANDER_PD emits 10 = sample too early (need +delay),
    //                   01 = sample too late  (need -delay).
    // The shared DLF reads {OUT,REF}: 10 = +1, 11 = -1 (others = hold),
    // so re-encode late (01) onto 11 before feeding it.
    wire [1:0] bbpd_raw;
    wire [1:0] BBPD = (bbpd_raw == 2'b01) ? 2'b11 : bbpd_raw;
    wire [FILTER_BITS-1:0] DLF_OUT;
    wire ILL_P, ILL_N;
    pll_digital_loop_filter #(.BITS(FILTER_BITS)) dlf (
        .CLK(TICK), .RST_N(RST_N), .ENABLE(EN),
        .SS_BBPD(BBPD),
        .KP({FILTER_BITS{1'b0}}), .KI(KI),
        .OUT(DLF_OUT), .ILL_P(ILL_P), .ILL_N(ILL_N)
    );

    wire [FILTER_BITS-1:0] sum = DLF_OUT + {{(FILTER_BITS-8){1'b0}}, PHASE_OFFS};
    wire [FILTER_BITS-1:0] sat = (sum > TOTAL_STEPS) ? TOTAL_STEPS[FILTER_BITS-1:0] : sum;
    reg [7:0] code_q;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) code_q <= 8'd0;
        else        code_q <= EN ? sat[7:0] : PHASE_INIT;
    end
    assign PHASE_CODE = code_q;

    wire [7:0] fine_w   = (code_q > FINE_NDELS) ? FINE_NDELS : code_q;
    wire [7:0] rem1     = code_q - fine_w;
    wire [7:0] mid_w    = (rem1[7:2] > MID_NDELS) ? MID_NDELS : rem1[7:2];
    wire [7:0] rem2     = rem1 - (mid_w << 2);
    wire [7:0] coarse_w = (rem2[7:3] > COARSE_NDELS) ? COARSE_NDELS : rem2[7:3];
    reg [7:0] fine_n, mid_n, coarse_n;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) {fine_n, mid_n, coarse_n} <= 0;
        else        {fine_n, mid_n, coarse_n} <= {fine_w, mid_w, coarse_w};
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

    // ---- recovered data-phase clock = TICK pushed through the DCDL ----
    // The DCDL slides the sampling point across the UI; REC_CLK's rising
    // edge is the data sample point.
    wire rec_clk;
`ifdef SIMULATION
    PLL_COUNTER_DCDL #(
        .COARSE_NDELS(COARSE_NDELS), .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS), .T0_PS(0)
    ) dcdl (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_IN(TICK), .CLK_OUT(rec_clk)
    );
`else
    PLL_COUNTER_DCDL_PHYS #(
        .COARSE_NDELS(COARSE_NDELS), .MID_NDELS(MID_NDELS), .FINE_NDELS(FINE_NDELS)
    ) dcdl (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_IN(TICK), .CLK_OUT(rec_clk)
    );
`endif
    assign REC_CLK = rec_clk;

    // ---- samplers --------------------------------------------------
    // Two matched sampler FFs on the two recovered-clock phases:
    //   data phase -> posedge rec_clk  (eye centre)
    //   edge phase -> negedge rec_clk  (transition boundary, 0.5 UI)
    // The negedge FF synthesises to a sky130 falling-edge DFF
    // (sky130_fd_sc_hd__dfrtn / __dfxtn), so both phases are standard
    // cells and no behavioural stub is needed.  A finer / more accurate
    // edge phase would use a second DCDL tap at a fixed 0.5-UI offset;
    // the half-rate falling edge is the stdcell-only approximation and
    // is what makes this block synthesisable today.
    // Front-end sampler = the custom DUAL_SAMPLER cell: a matched
    // posedge/negedge FF pair (dfrtp + dfrtn) gives the data sample
    // (posedge rec_clk) and the edge sample (negedge rec_clk, ~0.5 UI).
    wire d_next, e_cur;
    DUAL_SAMPLER u_sampler (.D(DATA), .CK(rec_clk), .RST_B(RST_N),
        .Q_POS(d_next), .Q_NEG(e_cur)
        `ifdef WITH_POWER , .VPWR(VPWR), .VGND(VGND)`endif);
    reg d_prev, d_cur;
    // 2-deep UI history on the data phase (d_next is the raw sample)
    always @(posedge rec_clk or negedge RST_N) begin
        if (!RST_N) begin
            d_prev <= 0; d_cur <= 0;
        end else begin
            d_prev <= d_cur;
            d_cur  <= d_next;
        end
    end
    assign DATA_OUT = d_cur;

    ALEXANDER_PD pd (
        .D_PREV(d_prev), .D(d_cur), .D_NEXT(d_next), .E(e_cur),
        .BBPD(bbpd_raw)
    );

    // ---- lock detector: code holds in a +/-4 window ----
    reg [FILTER_BITS-1:0] dmin, dmax;
    reg [7:0] win_cnt;
    reg locked_r, lost_r;
    localparam integer DITHER_BAND = 4;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            dmin <= {FILTER_BITS{1'b1}}; dmax <= 0; win_cnt <= 0;
            locked_r <= 0; lost_r <= 0;
        end else if (!EN) begin
            // EN is a synchronous gate, not part of the async reset —
            // keeping it out of the reset term avoids a second
            // edge-sensitive source on these registers.
            dmin <= {FILTER_BITS{1'b1}}; dmax <= 0; win_cnt <= 0;
            locked_r <= 0; lost_r <= 0;
        end else begin
            if (DLF_OUT < dmin) dmin <= DLF_OUT;
            if (DLF_OUT > dmax) dmax <= DLF_OUT;
            if ((dmax - dmin) <= DITHER_BAND) begin
                if (win_cnt < 8'hff) win_cnt <= win_cnt + 1;
            end else begin
                dmin <= DLF_OUT; dmax <= DLF_OUT; win_cnt <= 0;
                if (locked_r) lost_r <= 1;
                locked_r <= 0;
            end
            if (win_cnt >= LOCK_COUNT[7:0]) locked_r <= 1;
        end
    end
    assign LOCKED = locked_r;
    assign ERR    = lost_r | ILL_P | ILL_N;
endmodule
