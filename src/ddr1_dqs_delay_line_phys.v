`timescale 1ps/1ps
// SPDX-License-Identifier: Apache-2.0
// DDR1 DQS receive delay line, physical tap-bus primitive.
//
// Requirement source: /grid/ddr-phy/docs/ADPLL_DDR1_REQUIREMENTS.md section 3.
// The existing PLL_DCDL_TAP_BUS_PHYS is only NTAPS FINE_DELAY_CELLs in series
// (16 taps ~= 1 ns at ics55 TT) -- far short of the 0-5 ns DDR1 range.  This
// primitive keeps the same uniform exposed-tap interface (CLK_IN / TAP[g] =
// g element delays, no mux, no select) but every "element" is a short chain
// of CELLS_PER_TAP fine cells, so the tap step and the total range are scaled
// up while the chain stays structurally uniform.
//
// Sizing (BLOCKER FIX): resized for real IHP130/ics55 cells, not just the
// behavioral 55 ps model.  The characterized FINE_DELAY_CELL is about
// 35 ps TT / 61 ps SS / 24 ps FF.  With CELLS_PER_TAP=2:
//
//   corner | cell | step/tap | code 127 range | 5 ns reached at
//   -------+------+----------+----------------+------------------
//   TT     | 35ps |  70 ps   | 8890 ps        | code  72 (<=200 ps ok)
//   SS     | 61ps | 122 ps   | 15494 ps       | code  41 (<=200 ps ok)
//   FF     | 24ps |  48 ps   | 6096 ps        | code 105 (<=200 ps ok)
//
// Every corner has step <= 200 ps and, with >=128 taps (TAP_BITS=7 gives
// 128 codes, indices 0..127), FF reaches 5 ns at code 105 (< 127).  The
// old 48 taps x 3 cells x 32 codes only reached 5.115 ns in the 55 ps
// behavioral model and FAILED on real cells (TT 3.26 ns, FF 2.23 ns).
//
// Defaults: NTAPS=128, CELLS_PER_TAP=2, CELL_PS=35 (TT behavioral model).
// The parameters stay overridable; the consumer must keep
// FIRST_STAGE + (CODES-1)*STEP_CELLS < NTAPS.
//
// NTAPS=128 leaves no head-room for FIRST_STAGE>0 or STEP_CELLS>1 at the
// default; a caller that needs those must raise NTAPS (and the wrapper
// LINE_NTAPS) accordingly.  Pass 2 must re-verify monotonicity on the
// routed real-cell netlist.
//
// Monotonicity by construction: there is no bypass, no coarse mux and no
// segmented select.  Every exposed tap is a node on one series chain of
// identical elements, so in any timing model where each cell has a positive
// delay, TAP[g+1] is strictly later than TAP[g]; the code->delay map is
// monotone with every step exactly one element (boundary step ratio 1.0).
// This deliberately keeps the PLL_SEGMENTED_DELAY_PHYS boundary lesson: the
// coarse bypass mux was the source of non-monotone boundary steps, and this
// line has nothing that can bypass a chain segment.  Pass 2 must re-verify
// this on the routed real-cell netlist (fanout/load differences per tap and
// the tap mux loading in the consumer can still bend individual steps).
//
// IMPL=0 (behavioral simulation): each sub-cell is a transport delay of
// CELL_PS.  The chain structure is identical to IMPL=1; only the cell timing
// model differs, exactly like the DLL_DCDL SIM/PHYS split in dll_dcdl.v.
// IMPL=1 (structural): FINE_DELAY_CELL (MUX=1) instances, no timing model of
// their own; use STA/SDF for delay.
//
// Port convention matches PLL_DCDL_TAP_BUS_PHYS so the ddr-phy consumer
// (rtl/ddr_dqs_delay_adpll.sv) can bind either primitive: TAP[g] is the input
// delayed by g elements; the final element's output node is not exposed
// (same as the existing tap bus).

`default_nettype none

// Behavioral-only timed cell for IMPL=0.  Transport (not inertial) delay:
// the point of this module is the timing model.
/* verilator lint_off ASSIGNDLY */
module DDR1_DQS_DELAY_CELL_BEH #(
    parameter integer DLY_PS = 55
) (
    input  wire I,
    output wire O
);
    // BLOCKER 4: initialise the output register to the static-low value.
    // DQS_IN is held low from t=0, so the first `always @(I)` never fires
    // and `d` would stay X forever -> dqs_capture X at power-up, violating
    // the requirement "static low in -> static low out" (section 3.1).
    // Real silicon with IMPL=1 has no such register (FINE_DELAY_CELL is
    // combinational, no init needed); this is behavioral-model hygiene.
    reg d = 1'b0;
    always @(I) d <= #(DLY_PS) I;
    assign O = d;
endmodule
/* verilator lint_on ASSIGNDLY */

module DDR1_DQS_DELAY_LINE_PHYS #(
    parameter integer NTAPS        = 128,  // exposed taps (code 0..NTAPS-1)
    parameter integer CELLS_PER_TAP = 2,   // fine cells per element/tap step
    parameter integer CELL_PS      = 35,   // behavioral sub-cell delay (TT model)
    parameter integer IMPL         = 0     // 0 = behavioral, 1 = structural cells
) (
    input  wire             CLK_IN,
    output wire [NTAPS-1:0] TAP
);
    initial begin
        if (NTAPS < 2)        $error("NTAPS must be >= 2");
        if (CELLS_PER_TAP < 1) $error("CELLS_PER_TAP must be >= 1");
    end

    genvar g, c;
    generate
        if (IMPL == 0) begin : g_beh
            // NTAPS elements; element g spans node[g] .. node[g+1] and is a
            // real chain of CELLS_PER_TAP sub-cells, not a single #delay.
            wire [NTAPS*CELLS_PER_TAP:0] node;
            assign node[0] = CLK_IN;
            for (g = 0; g < NTAPS; g = g + 1) begin : g_elem
                for (c = 0; c < CELLS_PER_TAP; c = c + 1) begin : g_cell
                    DDR1_DQS_DELAY_CELL_BEH #(.DLY_PS(CELL_PS)) u_cell (
                        .I(node[g*CELLS_PER_TAP + c]),
                        .O(node[g*CELLS_PER_TAP + c + 1])
                    );
                end
            end
            for (g = 0; g < NTAPS; g = g + 1) begin : g_tap
                assign TAP[g] = node[g*CELLS_PER_TAP];
            end
        end else begin : g_phys
            // Structural view: FINE_DELAY_CELL chain, tap at every element
            // boundary.  Same convention as PLL_DCDL_TAP_BUS_PHYS.
            wire [(NTAPS*CELLS_PER_TAP):0] node;
            assign node[0] = CLK_IN;
            for (g = 0; g < NTAPS*CELLS_PER_TAP; g = g + 1) begin : g_cell
                FINE_DELAY_CELL u_cell (
                    .MUX(1'b1),
                    .IN(node[g]),
                    .OUT(node[g+1])
                );
            end
            for (g = 0; g < NTAPS; g = g + 1) begin : g_tap
                assign TAP[g] = node[g*CELLS_PER_TAP];
            end
        end
    endgenerate
endmodule
`default_nettype wire
