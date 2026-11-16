module SEGMENTED_DELAY4_MEAS (
    input  wire       CLK_IN,
    input  wire [2:0] COARSE,
    input  wire [5:0] FINE,
    output wire       CLK_OUT
);
    PLL_SEGMENTED_DELAY_PHYS #(
        .NSEG(4), .SEG_TAPS(56), .FINE_TAPS(56),
        .COARSE_BITS(3), .FINE_BITS(6)
    ) u_delay (
        .CLK_IN(CLK_IN), .COARSE(COARSE), .FINE(FINE), .CLK_OUT(CLK_OUT)
    );
endmodule
