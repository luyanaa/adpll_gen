// Real-cell TDC delay-line span measurement.
module DLL_TDC_LINE_MEAS (
    input  wire         CLK_IN,
    output wire [320:0] TAP
);
    DLL_TDC_LINE #(.NTAP(320), .IMPL(1)) u_line (
        .IN(CLK_IN), .TAP(TAP)
    );
endmodule
