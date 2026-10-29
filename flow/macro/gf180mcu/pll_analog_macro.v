// Hard-macro wrapper for PLL_ANALOG.
//
// The instance name is `pll_ana` on purpose: after Yosys flattening the
// hierarchy is `pll_ana_dco/...` and `pll_ana_inj/...`, which is exactly what
// pnr/tcl/pll_pos.tcl expects.  Do not rename it without updating that script.

module PLL_ANALOG_MACRO #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS    = 15,
    parameter integer FINE_NDELS   = 31,
    parameter integer IL_NDELS     = 4
) (
    input  [COARSE_NDELS-1:0] COARSE_MUX,
    input  [MID_NDELS-1:0]    MID_MUX,
    input  [FINE_NDELS-1:0]   FINE_MUX,
    input  DCO_EN,
    input  REF,
    input  INJ_EN,
    output [1:0] SS_BBPD,
    output OUT,
    output MID_OUT,
    output INJ_EDGE
);

    PLL_ANALOG #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .IL_NDELS(IL_NDELS)
    ) pll_ana (
        .COARSE_MUX(COARSE_MUX),
        .MID_MUX(MID_MUX),
        .FINE_MUX(FINE_MUX),
        .DCO_EN(DCO_EN),
        .REF(REF),
        .INJ_EN(INJ_EN),
        .SS_BBPD(SS_BBPD),
        .OUT(OUT),
        .MID_OUT(MID_OUT),
        .INJ_EDGE(INJ_EDGE)
    );

endmodule
