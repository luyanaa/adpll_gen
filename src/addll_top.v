`timescale 1ns/1ps
// ADDLL_TOP — all-digital delay-locked loop for a DDR PHY write/read
// clock-deskew path.  Reuses the ADPLL infrastructure:
//   * PLL_SSBBPD            bang-bang PD (CLK_IN vs delayed CLK_OUT)
//   * pll_digital_loop_filter  degraded to a first-order up/down counter
//                            (tie KP = 0; INT is the accumulator)
//   * pll_term_decoder_with_zero  binary code -> thermometer tap select
//   * PLL_COUNTER_DCDL_PHYS      COARSE->MID->FINE tapped delay chain
//                            (functional model: PLL_COUNTER_DCDL)
//   * pll_lock_detector     lock / loss-of-lock counters
//
// Loop: the PD compares the reference (undelayed) edge with the delayed
// edge.  A late CLK_OUT edge is pushed further, toward alignment with the
// NEXT CLK_IN edge, so the loop converges to a whole-period delay
// (t_d ~= T_CLK_IN) — the standard bang-bang DLL lock point.
//
// The raw SS_BBPD bit order is swapped before the filter/lock logic:
// in the ADPLL the sign convention served a frequency loop; here "VCO
// (delayed output) late" must step the delay UP, not down.
//
// PHASE_OFFS adds a fixed offset (fine LSBs) to the loop code so a static
// phase shift can be applied without a second PD.  DLY_INIT preloads the
// code while EN=0 — seed inside the capture range (0 < t_d < T_CLK_IN).
module ADDLL_TOP #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer FILTER_BITS = 16,
    parameter integer LOCK_COUNT = 16,
    parameter integer LOSS_COUNT = 4,
    // fine-LSB weight of one MID tap and one COARSE tap
    parameter integer MID_W = 4,      // 60 ps / 15 ps
    parameter integer COARSE_W = 8    // 120 ps / 15 ps
) (
    input  CLK_IN,          // reference clock to be delayed (e.g. CK/WCK)
    input  RST_N,           // async reset, active low
    input  TICK,            // loop/PD sampling clock
    input  EN,              // loop enable; 0 freezes the control word
    input  [FILTER_BITS-1:0] KI,        // integral step (1 = minimum)
    input  [7:0] PHASE_OFFS,            // static phase offset, fine LSBs
    input  [7:0] DLY_INIT,              // preload code while EN=0
    output CLK_OUT,         // delayed clock out to the PHY
    output LOCKED,          // PHASE_LOCK
    output ERR,             // LOCK_LOST / saturation
    output [7:0] DLY_CODE   // current binary delay code (observability)
);
    // Largest useful code: fill fine to its top, then mid, then coarse.
    localparam integer TOTAL_STEPS =
        FINE_NDELS + MID_W*MID_NDELS + COARSE_W*COARSE_NDELS;

    wire [1:0] pd_raw;
    // Swap only for the filter: "delayed clock late" must mean increment
    // for the DLL.  The lock detector keeps the ADPLL convention where
    // 2'b01 is the balanced / no-correction state.
    wire [1:0] SS_BBPD = {pd_raw[0], pd_raw[1]};
    wire [FILTER_BITS-1:0] DLF_OUT;
    wire ILL_P, ILL_N;

`ifdef SIMULATION
    sim_SSBBPD bbpd (
        .CLK_VCO(CLK_OUT), .CLK_REF(CLK_IN), .SS_BBPD(pd_raw)
    );
`else
    PLL_SSBBPD bbpd (
        .INJ_EDGE_BALANCED(CLK_IN),
        .OSC_BALANCED(CLK_OUT),
        .SS_BBPD(pd_raw)
    );
`endif

    // First-order loop: KP = 0 makes OUT = INT, the up/down accumulator.
    pll_digital_loop_filter #(
        .BITS(FILTER_BITS)
    ) dlf (
        .CLK(TICK), .RST_N(RST_N), .ENABLE(EN),
        .SS_BBPD(SS_BBPD),
        .KP({FILTER_BITS{1'b0}}), .KI(KI),
        .OUT(DLF_OUT), .ILL_P(ILL_P), .ILL_N(ILL_N)
    );

    // Binary delay code = accumulator + static phase offset, saturated to
    // the chain's range.  DLY_INIT drives the taps while EN is low so the
    // loop can be seeded near the expected operating point.
    wire [FILTER_BITS-1:0] dly_sum = DLF_OUT + {{(FILTER_BITS-8){1'b0}}, PHASE_OFFS};
    wire [FILTER_BITS-1:0] dly_sat =
        (dly_sum > TOTAL_STEPS) ? TOTAL_STEPS[FILTER_BITS-1:0] : dly_sum;
    assign DLY_CODE = EN ? dly_sat[7:0] : DLY_INIT;
    wire [7:0] code = DLY_CODE;

    // Saturating small-to-large decode (monotonic in fine-LSB units):
    //   fine_n   = min(code, FINE_NDELS)
    //   mid_n    = min((code - fine_n) / MID_W, MID_NDELS)
    //   coarse_n = min((code - fine_n - MID_W*mid_n) / COARSE_W, COARSE_NDELS)
    // Realised delay = T0 + 15*fine_n + 60*mid_n + 120*coarse_n (ps, model).
    wire [7:0] fine_n   = (code > FINE_NDELS) ? FINE_NDELS : code;
    wire [7:0] rem1     = code - fine_n;
    wire [7:0] mid_n    = (rem1/MID_W > MID_NDELS) ? MID_NDELS : rem1/MID_W;
    wire [7:0] rem2     = rem1 - mid_n*MID_W;
    wire [7:0] coarse_n = (rem2/COARSE_W > COARSE_NDELS) ? COARSE_NDELS : rem2/COARSE_W;

    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0]    MID_MUX;
    wire [FINE_NDELS-1:0]   FINE_MUX;

    pll_term_decoder_with_zero #(.NDELS(COARSE_NDELS)) dec_c (
        .IN(coarse_n[$clog2(COARSE_NDELS+1)-1:0]), .OUT(COARSE_MUX));
    pll_term_decoder_with_zero #(.NDELS(MID_NDELS)) dec_m (
        .IN(mid_n[$clog2(MID_NDELS+1)-1:0]), .OUT(MID_MUX));
    pll_term_decoder_with_zero #(.NDELS(FINE_NDELS)) dec_f (
        .IN(fine_n[$clog2(FINE_NDELS+1)-1:0]), .OUT(FINE_MUX));

`ifdef SIMULATION
    PLL_COUNTER_DCDL #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS)
    ) dcdl (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_IN(CLK_IN), .CLK_OUT(CLK_OUT)
    );
`else
    PLL_COUNTER_DCDL_PHYS #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS)
    ) dcdl (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_IN(CLK_IN), .CLK_OUT(CLK_OUT)
    );
`endif

    // Bang-bang lock detection.  The DLL lock point is the smallest delay
    // that aligns a delayed edge with a reference edge; once centred, the
    // accumulator dithers in a tight band (DLF_OUT bounces by +/-KI around
    // the lock code).  A run of "no change" (the PD reports no clear symbol,
    // or the correction balances) marks lock; sustained saturation or a
    // monotone run marks loss.  Track the running min/max of DLF_OUT over a
    // window: when the window stays inside a few KI steps for LOCK_COUNT
    // ticks, assert LOCKED.
    reg [FILTER_BITS-1:0] dmin, dmax;
    reg [7:0] win_cnt;
    reg locked_r, lost_r;
    localparam integer DITHER_BAND = 4;   // max +/- band of DLF_OUT at lock
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            dmin <= {FILTER_BITS{1'b1}}; dmax <= 0;
            win_cnt <= 0; locked_r <= 1'b0; lost_r <= 1'b0;
        end else if (!EN) begin
            dmin <= {FILTER_BITS{1'b1}}; dmax <= 0;
            win_cnt <= 0; locked_r <= 1'b0; lost_r <= 1'b0;
        end else begin
            if (DLF_OUT < dmin) dmin <= DLF_OUT;
            if (DLF_OUT > dmax) dmax <= DLF_OUT;
            if ((dmax - dmin) <= DITHER_BAND) begin
                if (win_cnt < 8'hff) win_cnt <= win_cnt + 1;
            end else begin
                // excursion out of band: reset window
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
