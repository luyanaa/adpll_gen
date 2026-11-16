// ics55 differential DDR CK pad wrapper.
//
// Two P65_1233_PBMUX single-ended pads form CK_T/CK_C.  Both are always
// driven (OE=1), maximum drive strength, no pull-up/down, no open drain.
// The supplies are explicit so the wrapper can be bound to the selected
// VDDIO/VSSIO in the PHY integration.
//
// This is the real ics55 IO cell wrapper.  The IO Verilog model has zero
// specify delay; OpenSTA with the real IO Liberty and a 2 pF pad load gives
// TT/SS/FF CK_T rise/fall 2.57/2.44, 4.22/4.22, 1.77/1.67 ns and
// single-ended duties 47.4/52.6, 50.0/50.0, 48.0/52.0%.  The differential
// crossing needs SI/IBIS and is not claimed by this wrapper.
// The functional DDR_CK_PAD_MODEL remains a portable approximation for
// environments without the ics55 IO library.
// The IO Liberty cell exposes only signal pins.  The ics55 Verilog model has
// VDD/VDDIO/VSS/VSSIO inouts, but the PDK supplies are global in the
// synthesis/STA view, so they are intentionally left unconnected here.
`timescale 1ns/1ps

module ICS55_DDR_CK_PAD (
    input  wire CK_PHY,
    input  wire CK_PHY_N,
    inout  wire VDD,
    inout  wire VDDIO,
    inout  wire VSS,
    inout  wire VSSIO,
    inout  wire CK_T,
    inout  wire CK_C
);
    P65_1233_PBMUX u_t (
        .C(), .A(), .PAD(CK_T),
        .IE(1'b0), .CS(1'b0), .I(CK_PHY),
        .OE(1'b1), .OD(1'b0), .PU(1'b0), .PD(1'b0),
        .DS0(1'b1), .DS1(1'b1)
    );

    P65_1233_PBMUX u_c (
        .C(), .A(), .PAD(CK_C),
        .IE(1'b0), .CS(1'b0), .I(CK_PHY_N),
        .OE(1'b1), .OD(1'b0), .PU(1'b0), .PD(1'b0),
        .DS0(1'b1), .DS1(1'b1)
    );
endmodule
