// Structural harness for the ics55 IO pad delay/duty measurement.
// Used only by flow/sta; not part of the synthesizable PHY.
module ICS55_CK_PAD_MEAS (
    input  wire CK_PHY,
    input  wire CK_PHY_N,
    inout  wire CK_T,
    inout  wire CK_C
);
    wire VDD, VDDIO, VSS, VSSIO;
    assign VDD = 1'b1;
    assign VDDIO = 1'b1;
    assign VSS = 1'b0;
    assign VSSIO = 1'b0;

    ICS55_DDR_CK_PAD u_pad (
        .CK_PHY(CK_PHY), .CK_PHY_N(CK_PHY_N),
        .VDD(VDD), .VDDIO(VDDIO), .VSS(VSS), .VSSIO(VSSIO),
        .CK_T(CK_T), .CK_C(CK_C)
    );
endmodule
