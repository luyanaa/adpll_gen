`timescale 1ps/1ps
// -----------------------------------------------------------------------------
// dll8_line4 behavioral stand-in for digital verification of dll8_tile.
//
// Implements the SAME port interface as the hard-macro blackbox
// (flow/macro/dll8_line4_macro/dll8_line4.v) with 4 transport-delay elements
// whose timing is the SPICE-locked model (BASE + code*STEP).  The
// thermometer-to-code relationship is inverted through the SAME polarity
// contract the real macro implements:
//
//   strap[j] = th[j] XOR (j odd)  =>  active fingers f =
//     |{even j < ?}| ... -- simpler: we recover th[j] = strap[j] XOR (j odd)
//     and count the leading run of 1s as the active finger count.
//
// Delay of an element = BASE + f*STEP where f is the active finger count
// (0..127).  Because even fingers are N (th=1) and odd fingers P (th=0),
// the exact per-finger parity bookkeeping is irrelevant for the delay: f is
// just the count of active fingers, monotone in the binary code.
// -----------------------------------------------------------------------------
`default_nettype none

module dll8_line4 #(
    parameter real    BASE_PS   = 110.0,
    parameter real    STEP_PS   = 3.0
) (
    input  wire         IN,
    output wire         OUT,
    output wire         TAP0,
    output wire         TAP1,
    output wire         TAP2,
    output wire         TAP3,
    input  wire [126:0] EN0,
    input  wire [126:0] EN1,
    input  wire [126:0] EN2,
    input  wire [126:0] EN3
);
    // Recover the binary code from the polarity-decoded thermometer straps:
    // th[j] = strap[j] XOR (j odd); count leading ones.
    function [6:0] strap2code;
        input [126:0] s;
        integer jj;
        reg [6:0] c;
        begin
            c = 7'd0;
            for (jj = 0; jj < 127; jj = jj + 1)
                if ((s[jj] ^ jj[0]) && jj[6:0] == c) c = c + 7'd1;
                // strict leading-run count: bit j counts only if all
                // previous bits were active, i.e. index == running count
            strap2code = c;
        end
    endfunction

    wire [6:0] c0 = strap2code(EN0);
    wire [6:0] c1 = strap2code(EN1);
    wire [6:0] c2 = strap2code(EN2);
    wire [6:0] c3 = strap2code(EN3);

    wire n0, n1, n2, n3, n4;
    assign n0 = IN;
    assign TAP0 = n1;
    assign TAP1 = n2;
    assign TAP2 = n3;
    assign TAP3 = n4;
    assign OUT  = n4;

    DLL8_ELEM #(.BASE_PS(BASE_PS), .STEP_PS(STEP_PS)) e0 (.IN(n0), .CODE(c0), .OUT(n1), .LOAD());
    DLL8_ELEM #(.BASE_PS(BASE_PS), .STEP_PS(STEP_PS)) e1 (.IN(n1), .CODE(c1), .OUT(n2), .LOAD());
    DLL8_ELEM #(.BASE_PS(BASE_PS), .STEP_PS(STEP_PS)) e2 (.IN(n2), .CODE(c2), .OUT(n3), .LOAD());
    DLL8_ELEM #(.BASE_PS(BASE_PS), .STEP_PS(STEP_PS)) e3 (.IN(n3), .CODE(c3), .OUT(n4), .LOAD());
endmodule
`default_nettype wire
