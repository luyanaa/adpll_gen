// Structural harness for the muxed delay-line range measurement.
module MUXED_DELAY_MEAS (
    input  wire             CLK_IN,
    input  wire [7:0]       SEL,
    output wire             CLK_OUT
);
    PLL_MUXED_DELAY_PHYS #(
        .NTAPS(224), .SEL_BITS(8)
    ) u_delay (
        .CLK_IN(CLK_IN), .SEL(SEL), .CLK_OUT(CLK_OUT)
    );
endmodule
