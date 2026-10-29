// PLL_ANALOG blackbox for the ihp130 / SG13G2 LibreLane full-top canary.
//
// This file is a SYNTHESIS/ELABORATION view only.  It matches the ports and
// parameters that src/pll.v instantiates; it contains no behavior.  For
// simulation use the real analog model (src/pll_analog.v + DCO/injection
// chain) or a characterized behavioral model, not this file.
//
// The hard macro must provide the same interface in its LEF/Liberty views:
//   hardmacro/interface.md
//   hardmacro/manifest.yaml
//
// VDD/VSS are present only when WITH_POWER is defined, exactly like
// src/pll_analog.v.  The default LibreLane top does not define WITH_POWER;
// power is connected through the PDN instead.
//
// PDK: ihp-sg13g2, 1.2 V core.  Do not substitute the 3.3 V
// `sg13g2_stdcell_hv` cells into this macro's digital wrapper.
`timescale 1fs/1fs

(* blackbox *)
module PLL_ANALOG #(
    parameter integer COARSE_NDELS = 15, // 4-bit coarse
    parameter integer MID_NDELS    = 15, // 4-bit mid
    parameter integer FINE_NDELS   = 31, // 5-bit fine
    parameter integer IL_NDELS     = 4   // injection delay stages
) (
`ifdef WITH_POWER
    inout VDD, VSS,
`endif
    input  [COARSE_NDELS-1:0] COARSE_MUX,
    input  [MID_NDELS-1:0]    MID_MUX,
    input  [FINE_NDELS-1:0]   FINE_MUX,
    input  DCO_EN,
    input  REF,
    input  INJ_EN,
    output [1:0] SS_BBPD,
    output OUT,
    output MID_OUT,
    output INJ_EDGE
);

    // Intentionally empty: hard macro.

endmodule
