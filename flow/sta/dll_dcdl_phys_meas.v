// Physical-backend elaboration check for the unified DLL_DCDL interface.
module DLL_DCDL_PHYS_MEAS (
    input  wire       CLK_IN,
    input  wire [8:0] CODE,
    output wire       CLK_OUT
);
    DLL_DCDL #(
        .IMPL(1), .CODE_BITS(9),
        .SEGS(4), .SEG_TAPS(56), .SEG_EXTRA_CELLS(10), .FINE_TAPS(56),
        .T0_PS(0), .CELL_PS(0), .EXTRA_PS(0)
    ) u_line (
        .CLK_IN(CLK_IN), .CODE(CODE), .CLK_OUT(CLK_OUT)
    );
endmodule
