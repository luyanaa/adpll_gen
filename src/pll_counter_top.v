// Closed-loop Core C top: digital control + physical counter/NCO DCO.
// TICK is an external high-speed reference.  Its frequency is a required
// specification input; the macro does not assume 1 GHz.
`timescale 1ns/1ps

module PLL_COUNTER_TOP #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer FILTER_BITS = 16,
    parameter integer IS_DSM = 1,
    parameter integer DSM_DIV = 2,
    parameter integer LOCKED_WAIT = 64,
    parameter integer FILTER_ILL = 16,
    parameter integer LOCK_TOL = 1,
    parameter integer LOCK_COUNT = 16,
    parameter integer LOSS_COUNT = 4,
    parameter integer DIV_BITS = 8,
    parameter integer DIV_INIT = 2,
    parameter integer FCW_BITS = 8,
    parameter integer CNT_EXTRA_BITS = 8,
    parameter integer MEAS_PERIODS = 1,
    parameter integer ACC_BITS = 16,
    parameter integer BASE_INC = 3493,
    parameter integer COARSE_STEP = 120,
    parameter integer MID_STEP = 60,
    parameter integer FINE_STEP = 15
) (
    input REF, RST_N, TICK, INJ_EN,
    input [FILTER_BITS-1:0] KP, KI,
    input [FCW_BITS-1:0] FCW,
    input DSM_EN_DT, DSM_EN_SHDT,
    input [1:0] DSM_ORDER,
    input [DIV_BITS-1:0] SET_DIV,
    input LOAD_DIV,
    output OUT_DIV, LOCKED, ERR, OUT
);
    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0] MID_MUX;
    wire [FINE_NDELS-1:0] FINE_MUX;
    wire [1:0] SS_BBPD;
    wire MID_OUT, INJ_EDGE, DCO_EN;

    pll_logic #(
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
        .DIV_BITS(DIV_BITS),
        .DIV_INIT(DIV_INIT),
        .FCW_BITS(FCW_BITS),
        .CNT_EXTRA_BITS(CNT_EXTRA_BITS),
        .MEAS_PERIODS(MEAS_PERIODS)
    ) u_logic (
        .REF(REF), .OUT(OUT), .MID_OUT(MID_OUT), .INJ_EDGE(INJ_EDGE),
        .RST_N(RST_N), .SS_BBPD(SS_BBPD),
        .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT), .DSM_EN_SHDT(DSM_EN_SHDT),
        .DSM_ORDER(DSM_ORDER),
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV), .OUT_DIV(OUT_DIV),
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .DCO_EN(DCO_EN), .LOCKED(LOCKED), .ERR(ERR)
    );

    PLL_COUNTER_DCO_PHYS #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .ACC_BITS(ACC_BITS),
        .BASE_INC(BASE_INC),
        .COARSE_STEP(COARSE_STEP),
        .MID_STEP(MID_STEP),
        .FINE_STEP(FINE_STEP)
    ) dco (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .TICK(TICK), .DCO_EN(DCO_EN), .REF(REF), .INJ_EN(INJ_EN),
        .SS_BBPD(SS_BBPD), .OUT(OUT), .MID_OUT(MID_OUT),
        .INJ_EDGE(INJ_EDGE)
    );
endmodule
