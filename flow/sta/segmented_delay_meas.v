module SEGMENTED_DELAY_MEAS (
    input  wire       CLK_IN,
    input  wire [3:0] COARSE,
    input  wire [4:0] FINE,
    output wire       CLK_OUT
);
    PLL_SEGMENTED_DELAY_PHYS #(
        .NSEG(8), .SEG_TAPS(28), .FINE_TAPS(28),
        .COARSE_BITS(4), .FINE_BITS(5)
    ) u_delay (
        .CLK_IN(CLK_IN), .COARSE(COARSE), .FINE(FINE), .CLK_OUT(CLK_OUT)
    );
endmodule
