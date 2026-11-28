// Structural harness for the DDR1 DQS real-cell tap measurement (IHP130).
// Used only by flow/sta; not part of the synthesizable design.
module DDR1_DQS_TAPS_MEAS (
    input  wire             CLK_IN,
    output wire [127:0]     TAP
);
    DDR1_DQS_DELAY_LINE_PHYS #(
        .NTAPS(128),
        .CELLS_PER_TAP(1),
        .IMPL(1)
    ) u_line (
        .CLK_IN(CLK_IN),
        .TAP(TAP)
    );
endmodule
