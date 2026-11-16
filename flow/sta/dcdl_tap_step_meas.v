// Structural harness for the real-cell tap-step measurement.
// Used only by flow/sta; not part of the synthesizable design.
module DCDL_TAP_STEP_MEAS (
    input  wire             CLK_IN,
    output wire [15:0]      TAP
);
    PLL_DCDL_TAP_BUS_PHYS #(
        .NTAPS(16)
    ) u_tap (
        .CLK_IN(CLK_IN),
        .TAP(TAP)
    );
endmodule
