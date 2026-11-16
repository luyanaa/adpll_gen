// Muxed/bypassable delay-line prototype for the DCDL.
//
// The existing MID_DELAY_CELL/FINE_DELAY_CELL use the MUX only as a dummy
// NAND load; the main path is always INV->LOAD->INV and every stage is in
// series.  That makes the minimum insertion delay the whole chain (SS >
// 5 ns) and the code only a small load trim.
//
// This prototype keeps the same FINE_DELAY_CELL stage (MUX=1) but exposes
// every tap and selects one with a real mux.  SEL=0 bypasses the chain;
// SEL=NTAPS-1 uses all stages.  It is a range/feasibility model, not the
// final area-optimized DCDL: a 224:1 mux is large, and a segmented
// coarse/fine mux is the likely production structure.
module PLL_MUXED_DELAY_PHYS #(
    parameter integer NTAPS = 224,
    parameter integer SEL_BITS = 8
) (
    input  wire                 CLK_IN,
    input  wire [SEL_BITS-1:0]  SEL,
    output wire                 CLK_OUT
);
    wire [NTAPS-1:0] tap;
    wire [NTAPS:0] chain;
    assign chain[0] = CLK_IN;

    genvar i;
    generate
        for (i = 0; i < NTAPS; i = i + 1) begin : stage
            FINE_DELAY_CELL u_cell (
                .MUX(1'b1),
                .IN(chain[i]),
                .OUT(chain[i+1])
            );
            assign tap[i] = chain[i];
        end
    endgenerate

    // Keep the select in range; the production version should decode a
    // thermometer code in segments rather than build a 224:1 mux.
    wire [SEL_BITS-1:0] sel = (SEL >= NTAPS) ? (NTAPS - 1) : SEL;
    assign CLK_OUT = tap[sel];
endmodule
