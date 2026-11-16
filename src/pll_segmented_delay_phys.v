// Segmented, truly bypassable delay line for the full-period DLL.
//
// The existing MID/FINE cells use the MUX only as a dummy NAND load; every
// stage is always in series.  This structure separates a coarse bypass bank
// from a fine tap bank:
//
//   IN -> 8 coarse segments (28 fine cells each), each bypassable
//      -> 28-tap fine segment -> OUT
//
// COARSE is the number of coarse segments used (0..8); FINE selects the fine
// tap (0..27).  COARSE=0/FINE=0 is a short path through the bypass muxes, not
// the whole chain.  This is the structural candidate for a 5 ns full-period
// DLL; cell sizing/segment count still need PPA and PVT optimization.
module PLL_SEGMENTED_DELAY_PHYS #(
    parameter integer NSEG = 8,
    parameter integer SEG_TAPS = 28,
    parameter integer SEG_EXTRA_CELLS = 0,
    parameter integer FINE_TAPS = 28,
    parameter integer COARSE_BITS = 4,
    parameter integer FINE_BITS = 5
) (
    input  wire                     CLK_IN,
    input  wire [COARSE_BITS-1:0]   COARSE,
    input  wire [FINE_BITS-1:0]     FINE,
    output wire                     CLK_OUT
);
    wire [NSEG:0] seg_node;
    assign seg_node[0] = CLK_IN;

    genvar g, i;
    generate
        for (g = 0; g < NSEG; g = g + 1) begin : seg
            wire [SEG_TAPS+SEG_EXTRA_CELLS:0] chain;
            assign chain[0] = seg_node[g];
            for (i = 0; i < SEG_TAPS; i = i + 1) begin : cell
                FINE_DELAY_CELL u_cell (
                    .MUX(1'b1),
                    .IN(chain[i]),
                    .OUT(chain[i+1])
                );
            end
            // Per-segment buffer: makes the segment path slower than the
            // bypass path plus the previous fine tap, so the code->delay map
            // stays monotonic across every coarse x 56 boundary.
            for (i = SEG_TAPS; i < SEG_TAPS + SEG_EXTRA_CELLS; i = i + 1)
                begin : extra
                FINE_DELAY_CELL u_extra (
                    .MUX(1'b1),
                    .IN(chain[i]),
                    .OUT(chain[i+1])
                );
            end
            // 1 = bypass this segment, 0 = use all its cells + buffer.
            wire bypass = (g >= COARSE);
            assign seg_node[g+1] = bypass ? chain[0] :
                chain[SEG_TAPS+SEG_EXTRA_CELLS];
        end
    endgenerate

    wire [FINE_TAPS:0] fine_chain;
    assign fine_chain[0] = seg_node[NSEG];
    generate
        for (i = 0; i < FINE_TAPS; i = i + 1) begin : fine_cell
            FINE_DELAY_CELL u_cell (
                .MUX(1'b1),
                .IN(fine_chain[i]),
                .OUT(fine_chain[i+1])
            );
        end
    endgenerate

    wire [FINE_BITS-1:0] fine_sel =
        (FINE >= FINE_TAPS) ? (FINE_TAPS - 1) : FINE;
    assign CLK_OUT = fine_chain[fine_sel];
endmodule
