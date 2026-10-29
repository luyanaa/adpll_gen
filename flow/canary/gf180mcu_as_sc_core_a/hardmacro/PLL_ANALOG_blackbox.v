// PLL_ANALOG blackbox for the gf180mcu 3.3 V full-top canary.
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
// gf180mcu note: the digital library gf180mcu_as_sc_mcu7t3v3 is a 3.3 V,
// 7-track library.  The macro is expected to be a 3.3 V macro in the same
// domain; there are no level shifters in this interface.  The LEF must still
// expose VDD/VSS power pins even though RTL power ports are omitted.
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
