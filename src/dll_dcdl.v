`timescale 1ps/1ps
// Unified DLL delay-line interface.
//
// CODE 0..279 maps to the physical segmentation explicitly:
//   COARSE = CODE / 56   (0..4 segments used)
//   FINE   = CODE % 56   (tap inside the final fine segment)
//
// IMPL=0: behavioral segmented backend with the same topology as the
//         physical line (4 segments x 56 cells, per-segment bypass, 56-tap
//         fine mux).  Each coarse boundary adds CELL_PS + EXTRA_PS, so the
//         model exposes the boundary steps instead of hiding them in a
//         linear T0 + code*STEP fit.
// IMPL=1: PLL_SEGMENTED_DELAY_PHYS, the real-cell structure used by the
//         ics55 OpenSTA range/boundary measurements.  This backend has no
//         timing model of its own; use SDF/STA for delay.
/* verilator lint_off ASSIGNDLY */
// Timing model cell: the transport delay is the point of this module.
module DLL_DELAY_CELL #(
    parameter integer DLY_PS = 0
) (
    input  wire I,
    output wire O
);
    reg d;
    always @(I) d <= #(DLY_PS) I;
    assign O = d;
endmodule
/* verilator lint_on ASSIGNDLY */

// One segment of the DLL delay line.
//
// Segment boundary uniformity
// ---------------------------
// The line is a chain of segments, and `fine` taps a dedicated 56-cell chain
// AFTER the segments.  The code->delay map is therefore
//
//   period(code) = T0
//                + (code / SEG_TAPS) * (SEG_TAPS*CELL_PS + EXTRA_PS)
//                + (code % SEG_TAPS) * CELL_PS
//
// so the step from code (k*SEG_TAPS-1) to (k*SEG_TAPS) is
// CELL_PS + EXTRA_PS, while an in-segment step is CELL_PS.
//
// With the old EXTRA_PS=62 ps that boundary step was 92 ps = 3.07 LSB, i.e.
// a 62 ps GAP in the transfer curve: no code lands on the periods inside it,
// and the loop cannot settle there.  That is a direct cause of "no legal code
// over one period" for references that need a period in that gap.
//
// Fix: the bypass must add NOTHING.  code = k*SEG_TAPS lands on seg_node[k],
// which already contains k full segments of SEG_TAPS cells, so the boundary
// step is one cell if the bypass is zero and 1+D extra if it is not.  Any
// nonzero EXTRA_PS is pure DNL:
//
//   EXTRA_PS =  62 ps -> boundary step 92 ps = 3.07 LSB   (62 ps gap)
//   EXTRA_PS =  30 ps -> boundary step 60 ps = 2.00 LSB   (30 ps gap)
//   EXTRA_PS =   0 ps -> boundary step 30 ps = 1.00 LSB   (monotone, DN L 0)
//
// EXTRA_PS is therefore 0 by default.  It stays a parameter so a per-PDK
// characterisation can re-introduce a real trim if the physical segment adds
// unavoidable delay, but the model now defaults to a uniform grid.
module DLL_DCDL_SEGMENT #(
    parameter integer SEG_TAPS = 56,
    parameter integer CELL_PS = 30,
    // Bypass trim.  Must be 0 for a uniform code->delay grid: see the note
    // above.  Nonzero values introduce exactly this much DNL at every
    // segment boundary.
    parameter integer EXTRA_PS = 0
) (
    input  wire CLK_IN,
    input  wire USED,
    output wire CLK_OUT
);
    wire [SEG_TAPS:0] chain;
    assign chain[0] = CLK_IN;
    genvar i;
    generate
        for (i = 0; i < SEG_TAPS; i = i + 1) begin : stage
            DLL_DELAY_CELL #(.DLY_PS(CELL_PS)) u_cell (
                .I(chain[i]), .O(chain[i+1])
            );
        end
    endgenerate
    wire raw = USED ? chain[SEG_TAPS] : chain[0];
    wire extra;
    DLL_DELAY_CELL #(.DLY_PS(EXTRA_PS)) u_extra (
        .I(raw), .O(extra)
    );
    assign CLK_OUT = USED ? extra : raw;
endmodule

module DLL_DCDL_SIM #(
    parameter integer CODE_BITS = 9,
    parameter integer SEGS = 4,
    parameter integer SEG_TAPS = 56,
    parameter integer FINE_TAPS = 56,
    parameter integer T0_PS = 2930,
    parameter integer CELL_PS = 30,
    // 0 keeps the code->delay map uniform (see DLL_DCDL_SEGMENT).
    parameter integer EXTRA_PS = 0
) (
    input  wire                  CLK_IN,
    input  wire [CODE_BITS-1:0]  CODE,
    output wire                  CLK_OUT
);
    wire [2:0] coarse = CODE / 56;
    wire [5:0] fine   = CODE % 56;
    genvar g, i;

    wire line_in;
    DLL_DELAY_CELL #(.DLY_PS(T0_PS)) u_t0 (
        .I(CLK_IN), .O(line_in)
    );

    wire [SEGS:0] seg_node;
    assign seg_node[0] = line_in;
    generate
        for (g = 0; g < SEGS; g = g + 1) begin : seg
            DLL_DCDL_SEGMENT #(
                .SEG_TAPS(SEG_TAPS), .CELL_PS(CELL_PS),
                .EXTRA_PS(EXTRA_PS)
            ) u_seg (
                .CLK_IN(seg_node[g]), .USED(g < coarse),
                .CLK_OUT(seg_node[g+1])
            );
        end
    endgenerate

    wire [FINE_TAPS:0] fine_chain;
    assign fine_chain[0] = seg_node[SEGS];
    generate
        for (i = 0; i < FINE_TAPS; i = i + 1) begin : fine_cell
            DLL_DELAY_CELL #(.DLY_PS(CELL_PS)) u_cell (
                .I(fine_chain[i]), .O(fine_chain[i+1])
            );
        end
    endgenerate
    wire [5:0] fine_sel = (fine >= FINE_TAPS) ? (FINE_TAPS - 1) : fine;
    assign CLK_OUT = fine_chain[fine_sel];
endmodule

module DLL_DCDL_PHYS #(
    parameter integer CODE_BITS = 9,
    parameter integer SEGS = 4,
    parameter integer SEG_TAPS = 56,
    parameter integer SEG_EXTRA_CELLS = 10,
    parameter integer FINE_TAPS = 56
) (
    input  wire                  CLK_IN,
    input  wire [CODE_BITS-1:0]  CODE,
    output wire                  CLK_OUT
);
    wire [2:0] coarse = CODE / 56;
    wire [5:0] fine   = CODE % 56;
    PLL_SEGMENTED_DELAY_PHYS #(
        .NSEG(SEGS), .SEG_TAPS(SEG_TAPS),
        .SEG_EXTRA_CELLS(SEG_EXTRA_CELLS), .FINE_TAPS(FINE_TAPS),
        .COARSE_BITS(3), .FINE_BITS(6)
    ) u_line (
        .CLK_IN(CLK_IN), .COARSE(coarse), .FINE(fine),
        .CLK_OUT(CLK_OUT)
    );
endmodule

module DLL_DCDL #(
    parameter integer IMPL = 0,
    parameter integer CODE_BITS = 9,
    parameter integer SEGS = 4,
    parameter integer SEG_TAPS = 56,
    parameter integer SEG_EXTRA_CELLS = 10,
    parameter integer FINE_TAPS = 56,
    parameter integer T0_PS = 2930,
    parameter integer CELL_PS = 30,
    // 0 keeps the code->delay map uniform; see DLL_DCDL_SEGMENT.
    parameter integer EXTRA_PS = 0
) (
    input  wire                  CLK_IN,
    input  wire [CODE_BITS-1:0]  CODE,
    output wire                  CLK_OUT
);
    generate
        if (IMPL == 0) begin : sim
            DLL_DCDL_SIM #(
                .CODE_BITS(CODE_BITS), .SEGS(SEGS),
                .SEG_TAPS(SEG_TAPS), .FINE_TAPS(FINE_TAPS),
                .T0_PS(T0_PS), .CELL_PS(CELL_PS), .EXTRA_PS(EXTRA_PS)
            ) u_line (
                .CLK_IN(CLK_IN), .CODE(CODE), .CLK_OUT(CLK_OUT)
            );
        end else begin : phys
            DLL_DCDL_PHYS #(
                .CODE_BITS(CODE_BITS), .SEGS(SEGS),
                .SEG_TAPS(SEG_TAPS),
                .SEG_EXTRA_CELLS(SEG_EXTRA_CELLS), .FINE_TAPS(FINE_TAPS)
            ) u_line (
                .CLK_IN(CLK_IN), .CODE(CODE), .CLK_OUT(CLK_OUT)
            );
        end
    endgenerate
endmodule

// Matched commit-delay strobe.  IMPL=0 is the behavioral delay; IMPL=1 uses
// the same FINE_DELAY_CELL chain as the physical DCDL/TDC so the code commit
// window is a real timed path in gate-level/SDF.
module DLL_COMMIT_DELAY #(
    parameter integer DLY_PS = 1800,
    parameter integer CELL_PS = 30,
    parameter integer IMPL = 0
) (
    input  wire I,
    output wire O
);
    localparam integer NCELL = (DLY_PS + CELL_PS - 1) / CELL_PS;
    generate
        if (IMPL == 0) begin : sim
            DLL_DELAY_CELL #(.DLY_PS(DLY_PS)) u_dly (.I(I), .O(O));
        end else begin : phys
            wire [NCELL:0] chain;
            assign chain[0] = I;
            genvar i;
            for (i = 0; i < NCELL; i = i + 1) begin : stage
                FINE_DELAY_CELL u_cell (
                    .MUX(1'b1), .IN(chain[i]), .OUT(chain[i+1])
                );
            end
            assign O = chain[NCELL];
        end
    endgenerate
endmodule
