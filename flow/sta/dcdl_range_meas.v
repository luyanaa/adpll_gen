// Structural harness for the ics55 physical DCDL range measurement.
// Used only by flow/sta; not part of the synthesizable PHY.
module DCDL_RANGE_MEAS (
    input  wire             CLK_IN,
    input  wire [14:0]      COARSE_MUX,
    input  wire [14:0]      MID_MUX,
    input  wire [30:0]      FINE_MUX,
    output wire             CLK_OUT
);
    PLL_COUNTER_DCDL_PHYS #(
        .COARSE_NDELS(15), .MID_NDELS(15), .FINE_NDELS(31)
    ) u_dcdl (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_IN(CLK_IN), .CLK_OUT(CLK_OUT)
    );
endmodule
