// Fixed-width blackbox for the hardened sky130 Core C counter/NCO macro.
// The physical macro has no Verilog parameters: its LEF/Liberty/CDL/GDS views
// are fixed at COARSE_NDELS=15, MID_NDELS=15, FINE_NDELS=31.
`timescale 1ns/1ps

(* blackbox *)
module PLL_COUNTER_DCO_PHYS (
    input [14:0] COARSE_MUX,
    input [14:0] MID_MUX,
    input [30:0] FINE_MUX,
    input TICK,
    input DCO_EN, REF, INJ_EN,
    output [1:0] SS_BBPD,
    output OUT, MID_OUT, INJ_EDGE
);
endmodule
