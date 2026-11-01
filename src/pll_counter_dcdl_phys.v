`timescale 1ns/1ps
// Physical DCDL: a real tapped delay chain built by cascading the existing
// COARSE / MID / FINE delay modules.  This is the DLL analogue of
// PLL_COUNTER_DCO_PHYS with the ring broken open: CLK_IN enters the chain
// and CLK_OUT exits at the far end; the thermometer control words select how
// many stages the signal traverses.
//
//   CLK_IN -> COARSE_DELAY -> MID_DELAY_BUFFERED -> FINE_DELAY_BUFFERED -> CLK_OUT
//
// Each stage's cells are non-inverting (COARSE: NAND-dominant FCHAIN/RCHAIN
// pair; MID/FINE buffered: two INV per cell), so the chain preserves the
// input phase and the delay grows monotonically with the thermometer count.
//
// Control words are thermometer-coded, exactly as in the DCO: more '1's =
// more delay.  The mapping to a binary delay code lives in addll_top
// (pll_term_decoder_with_zero).
module PLL_COUNTER_DCDL_PHYS #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31
) (
`ifdef WITH_POWER
    inout VDD, VSS,
`endif
    input  [COARSE_NDELS-1:0] COARSE_MUX,
    input  [MID_NDELS-1:0]    MID_MUX,
    input  [FINE_NDELS-1:0]   FINE_MUX,
    input  CLK_IN,
    output CLK_OUT
);
    wire c_out, m_out;

    (* keep_hierarchy = "yes" *)
    COARSE_DELAY #(
        .NDELS(COARSE_NDELS)
    ) u_coarse (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .MUX(COARSE_MUX), .IN(CLK_IN), .OUT(c_out)
    );

    (* keep_hierarchy = "yes" *)
    MID_DELAY_BUFFERED #(
        .NDELS(MID_NDELS)
    ) u_mid (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .MUX(MID_MUX), .IN(c_out), .OUT(m_out)
    );

    (* keep_hierarchy = "yes" *)
    FINE_DELAY_BUFFERED #(
        .NDELS(FINE_NDELS)
    ) u_fine (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .MUX(FINE_MUX), .IN(m_out), .OUT(CLK_OUT)
    );
endmodule
