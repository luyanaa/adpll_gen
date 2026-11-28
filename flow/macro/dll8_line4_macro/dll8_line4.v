// -----------------------------------------------------------------------------
// dll8_line4 -- blackbox (LEF/GDS hard macro) for the DLL8 4-element delay
// line strip.  Signoff: flow/macro/dll8_cells/REPORT_signoff.md
// (KLayout DRC 0, LVS MATCH, commit 212e4d8).
//
// Pin contract (all coordinates in the derived LEF/GDS view, origin (0,0)):
//   IN        input   M1, left edge   -- serial chain input (E0.IN)
//   OUT       output  M1, right edge  -- serial chain output (E3.OUT)
//   TAP0..3   output  M2, bottom edge -- per-element output taps, length
//                                       matched by construction
//   ENk[j]    input   M3/4/5, right edge -- finger control straps,
//             k = element 0..3, j = finger 0..126 (thermometer ascending).
//             POLARITY CONTRACT: N fingers (even j) are ON when the strap is
//             HIGH, P fingers (odd j) ON when LOW -- the decoder must drive
//             strap[j] = th[j] XOR (j odd).  Control is quasi-static DC;
//             there are NO buffers inside the macro (one gate per bit).
//   VDD/VSS   power   M1
//
// Integration note (recorded 2026-11-28): per-element trim is NOT exported
// (measured element matching 1.5-1.7 ps -- no trim needed, see
// docs/dco_8phase_decision.md).  All elements in the DLL8 share one
// thermometer code: drive the same decoded bit to EN0[j]..EN3[j] of both
// strips (fanout-8 broadcast, quasi-static).
// -----------------------------------------------------------------------------
`default_nettype none
module dll8_line4 (
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
`ifdef USE_POWER_PINS
    , inout wire        VDD
    , inout wire        VSS
`endif
);
    // blackbox -- no functional model; simulation uses the DLL8_ELEM
    // transport-delay model (src/dll8_line.v DLL8_IMPL=0).
endmodule
`default_nettype wire
