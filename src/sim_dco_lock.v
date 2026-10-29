// Small behavioral DCO used only by the frequency-lock RTL regression.
// The delay increases monotonically with the thermometer code, so the
// frequency controller has a well-defined direction.
`timescale 1fs/1fs

module sim_dco #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer BASE_PERIOD_FS = 500000, // 1.5 GHz at code 0
    parameter integer STEP_FS = 20000
) (
    output reg CLK_VCO,
    input [COARSE_NDELS-1:0] COARSE_MUX,
    input [MID_NDELS-1:0] MID_MUX,
    input [FINE_NDELS-1:0] FINE_MUX
);
    integer period;
    integer code;

    initial CLK_VCO = 1'b0;
    always begin
        code = $countones(COARSE_MUX) + $countones(MID_MUX);
        period = BASE_PERIOD_FS + STEP_FS * code;
        #(period/2) CLK_VCO = ~CLK_VCO;
    end
endmodule
