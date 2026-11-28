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
//   VDD/VSS   power   Metal5 end pads, local x[53.76,69.26]
//             VSS y[9.18,10.36], VDD y[10.98,12.36]  (power respin 2026-11-28)
//
// Integration note (updated 2026-11-28 evening): the four elements have
// INDEPENDENT EN buses and the production tile drives them with per-element
// codes (Bresenham fractional-code split, src/dll8_tile.v).  A uniform
// broadcast code cannot meet the 30 ps budget: one code step moves tap7 by
// 8*STEP = 40 ps at SS, so a sign-only loop limit-cycles over 40 ps.  The
// per-element split gives a STEP-granular tap7 (5 ps SS) and <=0.5*STEP
// per-tap uniformity error (measured: worst 7.0 ps SS, 8.0 ps FF).
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
