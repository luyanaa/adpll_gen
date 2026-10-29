// Closed-loop integration wrapper: digital control + hardened analog macro.
//
// This is deliberately a separate top from `pll.v`: `pll.v` uses the
// behavioral/transistor PLL_ANALOG for simulation, while this wrapper binds
// the same pll_logic to the P&R macro `PLL_ANALOG_MACRO`.
`timescale 1fs/1fs

module pll_macro_top #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer FILTER_BITS = 16,
    parameter integer IS_DSM = 1,
    parameter integer DSM_DIV = 2,
    parameter integer LOCKED_WAIT = 64,
    parameter integer FILTER_ILL = 16,
`ifndef PLL_WITHOUT_DIVIDER
    parameter integer DIV_BITS = 8,
`endif
    parameter integer FCW_BITS = 8,
    parameter integer IL_NDELS = 4
) (
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
`endif
    output LOCKED, ERR, OUT
);
    wire MID_OUT, INJ_EDGE;
    wire [1:0] SS_BBPD;
    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0] MID_MUX;
    wire [FINE_NDELS-1:0] FINE_MUX;
    wire DCO_EN;

    pll_logic #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .FILTER_BITS(FILTER_BITS),
        .IS_DSM(IS_DSM),
        .DSM_DIV(DSM_DIV),
        .LOCKED_WAIT(LOCKED_WAIT),
        .FILTER_ILL(FILTER_ILL),
`ifndef PLL_WITHOUT_DIVIDER
        .DIV_BITS(DIV_BITS),
`endif
        .FCW_BITS(FCW_BITS)
    ) pll_dig (
        .REF(REF), .OUT(OUT), .MID_OUT(MID_OUT), .INJ_EDGE(INJ_EDGE), .RST_N(RST_N),
        .SS_BBPD(SS_BBPD),
        .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT), .DSM_EN_SHDT(DSM_EN_SHDT), .DSM_ORDER(DSM_ORDER),
`ifndef PLL_WITHOUT_DIVIDER
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV), .OUT_DIV(OUT_DIV),
`endif
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .DCO_EN(DCO_EN), .LOCKED(LOCKED), .ERR(ERR)
    );

    PLL_ANALOG_MACRO #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .IL_NDELS(IL_NDELS)
    ) pll_ana (
        .COARSE_MUX(COARSE_MUX),
        .MID_MUX(MID_MUX),
        .FINE_MUX(FINE_MUX),
        .DCO_EN(DCO_EN), .REF(REF), .INJ_EN(INJ_EN),
        .SS_BBPD(SS_BBPD),
        .OUT(OUT), .MID_OUT(MID_OUT), .INJ_EDGE(INJ_EDGE)
    );
endmodule
