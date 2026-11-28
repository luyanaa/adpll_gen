// -----------------------------------------------------------------------------
// dll8_line8_test -- minimal integration test top: two dll8_line4 strips
// chained into the full 8-element DLL8 line with broadcast control.
//
//   IN -> line_a.IN ; line_a.OUT -> line_b.IN ; line_b.OUT -> OUT
//   TAPA[3:0] = elements 0..3 taps, TAPB[3:0] = elements 4..7 taps
//   EN[j] broadcast: the same thermometer bit drives EN0[j]..EN3[j] of BOTH
//   strips (fanout 8).  Per-element trim is intentionally not exported
//   (measured element matching 1.5-1.7 ps -- docs/dco_8phase_decision.md).
//   The decoder contract (strap[j] = th[j] XOR (j odd)) is applied upstream.
// -----------------------------------------------------------------------------
`default_nettype none
module dll8_line8_test (
    input  wire         IN,
    output wire         OUT,
    output wire [3:0]   TAPA,
    output wire [3:0]   TAPB,
    input  wire [126:0] EN
);
    wire mid;

    dll8_line4 line_a (
        .IN(IN), .OUT(mid), .TAP0(TAPA[0]), .TAP1(TAPA[1]), .TAP2(TAPA[2]), .TAP3(TAPA[3]),
        .EN0(EN), .EN1(EN), .EN2(EN), .EN3(EN)
    );
    dll8_line4 line_b (
        .IN(mid), .OUT(OUT), .TAP0(TAPB[0]), .TAP1(TAPB[1]), .TAP2(TAPB[2]), .TAP3(TAPB[3]),
        .EN0(EN), .EN1(EN), .EN2(EN), .EN3(EN)
    );
endmodule
`default_nettype wire
