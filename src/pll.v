// The top module of this PLL
`timescale 1fs/1fs

module pll #(
    parameter integer COARSE_NDELS = 15,    // 4-bit coarse
    parameter integer MID_NDELS = 15,       // 4-bit mid
    parameter integer FINE_NDELS = 31,      // 5-bit fine
    // Fixed in-loop ring delay stages (pll_analog.v / il_dco.v): shifts the
    // ring's centre frequency down — a tuning-range band knob only, NOT a
    // fine-bank monotonicity fix.  0 = no base chain (legacy behaviour).
    parameter integer BASE_NDELS = 0,
    parameter integer FILTER_BITS = 16,     // Filter bits
    parameter integer IS_DSM = 1,           // Enable the Delta-Sigma Modulator
    // DSM clock is MID_OUT/DSM_DIV.  Post-route STA (dsmdiv2_macro run,
    // 2026-11-24): /2 fails setup on all three corners -- WNS
    // -0.65/-1.14/-0.36 ns TT/SS/FF, 8 paths from one DSM adder flop
    // into dff_err*/FILTER_DEC_RAW.  /4 is the only value that closes
    // (SS +0.029).  The noise-shaping sample rate is MID_OUT/4, and the
    // resulting NTF and fractional spurs have not been measured at the
    // loop level (the standalone DSM spectrum is in
    // flow/characterization).  /4 is a timing closure, not a signed-off
    // noise-shaping rate.
    parameter integer DSM_DIV = 4,
    parameter integer LOCKED_WAIT = 64,     // Number of clock cycles of REF from the freq lock until we trigger LOCKED
    // Gear shifting passthrough (see pll_logic).  The tracking gains are
    // the dlf_design.py f_ref/80 point at 100 MHz REF.
    parameter integer GEAR_SHIFT = 1,
    parameter integer KP_TRACK = 1148,
    parameter integer KI_TRACK = 23,
    parameter integer FILTER_ILL = 16,      // While locking, if illegal (positive/negative) in the filter, will force increase/decrease freq lock
    parameter integer LOCK_TOL = 1,         // Frequency-counter tolerance in FCW counts
    parameter integer LOCK_COUNT = 16,      // Phase-lock detector count
    parameter integer LOSS_COUNT = 4,       // Phase-loss detector count
    parameter integer CNT_EXTRA_BITS = 8,   // Frequency-counter headroom bits
    parameter integer MEAS_PERIODS = 1,     // REF periods per measurement window
    parameter integer LOCK_WINDOW = 256,    // REF periods per lock-window sample
`ifndef PLL_WITHOUT_DIVIDER
    parameter integer DIV_BITS = 8,
`endif
    parameter integer FCW_BITS = 8
) (
`ifdef WITH_POWER
    inout VDD, VSS,
`endif
    input REF, RST_N, INJ_EN,
    input [FILTER_BITS-1:0] KP, KI,
    input [FCW_BITS-1:0] FCW,
    input DSM_EN_DT,
    input DSM_EN_SHDT,
    input [1:0] DSM_ORDER,
`ifndef PLL_WITHOUT_DIVIDER
    input [DIV_BITS-1:0] SET_DIV,
    input LOAD_DIV,
    output OUT_DIV,
    output CK,
`endif
    output LOCKED, ERR, OUT
);
    wire MID_OUT, INJ_EDGE;
    wire [1:0] SS_BBPD;
    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0] MID_MUX;
    wire [FINE_NDELS-1:0] FINE_MUX;
    wire DCO_EN;

    pll_logic
`ifndef POSTSYN
    #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .FILTER_BITS(FILTER_BITS),
        .IS_DSM(IS_DSM),
        .DSM_DIV(DSM_DIV),
        .LOCKED_WAIT(LOCKED_WAIT),
        .FILTER_ILL(FILTER_ILL),
        .LOCK_TOL(LOCK_TOL),
        .LOCK_COUNT(LOCK_COUNT),
        .LOSS_COUNT(LOSS_COUNT),
        .GEAR_SHIFT(GEAR_SHIFT),
        .KP_TRACK(KP_TRACK),
        .KI_TRACK(KI_TRACK),
        .CNT_EXTRA_BITS(CNT_EXTRA_BITS),
        .MEAS_PERIODS(MEAS_PERIODS),
        .LOCK_WINDOW(LOCK_WINDOW),
`ifndef PLL_WITHOUT_DIVIDER
        .DIV_BITS(DIV_BITS),
`endif
        .FCW_BITS(FCW_BITS)
    )
`endif
    pll_dig (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .REF(REF), .OUT(OUT), .MID_OUT(MID_OUT), .INJ_EDGE(INJ_EDGE), .RST_N(RST_N),
        .SS_BBPD(SS_BBPD),
        .KP(KP), .KI(KI),
        .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT),
        .DSM_EN_SHDT(DSM_EN_SHDT),
        .DSM_ORDER(DSM_ORDER),
`ifndef PLL_WITHOUT_DIVIDER
        .SET_DIV(SET_DIV),
        .LOAD_DIV(LOAD_DIV),
        .OUT_DIV(OUT_DIV),
        .CK(CK),
`endif
        .COARSE_MUX(COARSE_MUX),
        .MID_MUX(MID_MUX),
        .FINE_MUX(FINE_MUX),
        .DCO_EN(DCO_EN), .LOCKED(LOCKED), .ERR(ERR)
    );

    PLL_ANALOG #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .BASE_NDELS(BASE_NDELS)
    ) pll_ana (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .COARSE_MUX(COARSE_MUX),
        .MID_MUX(MID_MUX),
        .FINE_MUX(FINE_MUX),
        .DCO_EN(DCO_EN), .REF(REF), .INJ_EN(INJ_EN),
        .SS_BBPD(SS_BBPD),
        .OUT(OUT), .MID_OUT(MID_OUT), .INJ_EDGE(INJ_EDGE)
    );

endmodule
