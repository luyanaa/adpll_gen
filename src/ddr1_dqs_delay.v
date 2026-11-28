`timescale 1ps/1ps
// SPDX-License-Identifier: Apache-2.0
// DDR1 DQS receive delay line wrapper (adpll_gen side).
//
// This mirrors the interface and handshake semantics of the consumer-side
// wrapper /grid/ddr-phy/rtl/ddr_dqs_delay_adpll.sv (LANES/TAP_BITS/
// FIRST_STAGE/STEP_CELLS/SETTLE_CYCLES, sys_clk/rst/update_idle,
// dqs_in/dqs_capture, tap_valid/tap_value/tap_ready) but binds the scaled
// DDR1_DQS_DELAY_LINE_PHYS primitive instead of the 16-tap
// PLL_DCDL_TAP_BUS_PHYS, adds the output settle gate required by the DDR1
// requirements (section 3.2: no glitch or half pulse on DQS_CAPTURE during a
// code update) and the recommended TAP_ERROR output.
//
// Handshake FSM is a direct copy of ddr_dqs_delay_adpll semantics:
//   * request is applied on the first idle SYS edge;
//   * tap_ready cannot assert until SETTLE_CYCLES full SYS periods after the
//     application edge;
//   * if update_idle drops, acknowledgement waits for the next idle window
//     without reprogramming (the applied code is kept);
//   * reset is synchronous and selects code 0 (minimum delay);
//   * tap_ready requires !rst, update_idle=1, pending and settle_left==0.
//
// Output settle gate (why it is safe):
//   dqs_capture = settled_q ? mux_out : 1'b0.  settled_q deasserts on the
//   edge that applies a new code and reasserts on the edge where tap_ready
//   asserts.  During the whole settle window the capture output is forced
//   low, so no select transition can propagate a stale/half tap value out.
//   This is safe because code updates are only legal when UPDATE_IDLE=1,
//   which by contract means there is no read burst and no in-flight DQS
//   edge; at that point DQS_IN is a defined static low from the pad
//   receiver, so forcing capture low cannot cut a real pulse and the plain
//   combinational tap mux cannot produce a visible glitch.  The gate is a
//   belt-and-braces guarantee against pad-receiver bounce and mux decode
//   skew.  It also matches the ddr-phy scheduler note that capture must be
//   quiescent from tap application through acknowledgement.
//
// Static-low behavior: TAP[g] of a uniform chain of non-inverting elements
// follows a static-low input to static low at every tap, and the mux selects
// one tap without inversion, so DQS_IN static low -> DQS_CAPTURE static low.
//
// TAP_ERROR choice: TAP_VALUE is exactly TAP_BITS wide, so it cannot exceed
// CODES and a code-range error cannot occur at the interface.  Instead
// TAP_ERROR[lane] (sticky) asserts when a tap_valid request is sampled while
// update_idle=0 and no update is pending -- i.e. the requester violated the
// UPDATE_IDLE contract.  It is cleared by reset or by a successful
// application of a later request.
//
// FIRST_STAGE >= 0; LANES, TAP_BITS, STEP_CELLS, SETTLE_CYCLES > 0;
// FIRST_STAGE + (CODES-1)*STEP_CELLS must stay below the primitive NTAPS.
// Default sizing / real-cell corners (requirements doc section 4.4):
//   TAP_BITS 7 (128 codes), CELLS_PER_TAP 2, LINE_NTAPS 128, CELL_PS 35 (TT
//   behavioral).  See ddr1_dqs_delay_line_phys.v for the TT/SS/FF table:
//   FF 48 ps/tap (code 105 covers 5 ns), TT 70 ps/tap, SS 122 ps/tap, all
//   <= the 200 ps step limit.

`default_nettype none
module DDR1_DQS_DELAY #(
    parameter integer LANES        = 1,
    parameter integer TAP_BITS     = 7,
    parameter integer FIRST_STAGE  = 0,
    parameter integer STEP_CELLS   = 1,
    parameter integer SETTLE_CYCLES = 2,
    // Primitive sizing (see ddr1_dqs_delay_line_phys.v).
    parameter integer LINE_NTAPS   = 128,
    parameter integer CELLS_PER_TAP = 2,
    parameter integer CELL_PS      = 35,
    parameter integer LINE_IMPL    = 0
) (
    input  wire                       sys_clk, rst, update_idle,
    input  wire [LANES-1:0]           dqs_in,
    output wire [LANES-1:0]           dqs_capture,
    input  wire [LANES-1:0]           tap_valid,
    input  wire [LANES*TAP_BITS-1:0]  tap_value,
    output wire [LANES-1:0]           tap_ready,
    output wire [LANES-1:0]           tap_error
);
    localparam integer CODES = 1 << TAP_BITS;
    localparam integer STAGES = FIRST_STAGE + (CODES-1)*STEP_CELLS + 1;
    localparam integer COUNT_BITS = $clog2(SETTLE_CYCLES+1);

    initial begin
        if (LANES < 1 || TAP_BITS < 5 || STEP_CELLS < 1 ||
            SETTLE_CYCLES < 1 || FIRST_STAGE < 0)
            $error("DDR1_DQS_DELAY parameter out of legal range");
        if (STAGES > LINE_NTAPS)
            $error("DDR1_DQS_DELAY: STAGES=%0d exceeds LINE_NTAPS=%0d",
                   STAGES, LINE_NTAPS);
    end

    for (genvar lane = 0; lane < LANES; lane = lane + 1) begin : g_lane
        wire [LINE_NTAPS-1:0] chain_taps;
        wire [CODES-1:0]      code_taps;
        // BLOCKER 4: declaration initialisers = the synchronous-reset
        // values.  Without them select_tap/settled_q are X until the first
        // sys_clk edge (t = one sys period), so dqs_capture reads X from
        // t=0 even though DQS_IN is statically low -- violating the
        // "static low in -> static low out at ALL times" check that must
        // run BEFORE any sweep.  (Companion to the `reg d = 1'b0` init in
        // DDR1_DQS_DELAY_CELL_BEH.)
        reg  [TAP_BITS-1:0]   select_tap = '0;
        reg  [COUNT_BITS-1:0] settle_left = '0;
        reg                   pending = 1'b0;
        reg                   settled_q = 1'b1;  // code-0 path, capture live
        reg                   error_q = 1'b0;

        (* keep_hierarchy = "yes", dont_touch = "true" *)
        DDR1_DQS_DELAY_LINE_PHYS #(
            .NTAPS(LINE_NTAPS), .CELLS_PER_TAP(CELLS_PER_TAP),
            .CELL_PS(CELL_PS), .IMPL(LINE_IMPL)
        ) delay_line (
            .CLK_IN(dqs_in[lane]), .TAP(chain_taps)
        );

        for (genvar code = 0; code < CODES; code = code + 1) begin : g_code
            assign code_taps[code] = chain_taps[FIRST_STAGE + code*STEP_CELLS];
        end

        wire mux_out = code_taps[select_tap];
        assign dqs_capture[lane] = settled_q ? mux_out : 1'b0;

        assign tap_ready[lane] = !rst && update_idle && pending &&
                                 (settle_left == 0);

        always @(posedge sys_clk) begin
            if (rst) begin
                select_tap <= '0;
                settle_left <= '0;
                pending <= 1'b0;
                settled_q <= 1'b1;  // code 0, minimum delay path
                error_q  <= 1'b0;
            end else if (pending) begin
                if (settle_left != 0) begin
                    settle_left <= settle_left - 1'b1;
                    // Reassert the gate in the same cycle settle completes,
                    // i.e. the cycle tap_ready first asserts.
                    if (settle_left == 1)
                        settled_q <= 1'b1;
                end else begin
                    // tap_ready is high in this window; only complete the
                    // handshake when the consumer actually sees the ack
                    // (tap_valid && tap_ready).  If update_idle drops during
                    // the ack window tap_ready is low, so the request stays
                    // pending and is acknowledged on the next idle window
                    // WITHOUT reprogramming (BLOCKER FIX).
                    settled_q <= 1'b1;
                    if (tap_valid[lane] && tap_ready[lane])
                        pending <= 1'b0;
                end
            end else if (update_idle && tap_valid[lane]) begin
                select_tap <= tap_value[lane*TAP_BITS +: TAP_BITS];
                settle_left <= COUNT_BITS'(SETTLE_CYCLES);
                pending <= 1'b1;
                settled_q <= 1'b0;   // force capture low during settle
                error_q  <= 1'b0;    // a successful application clears it
            end else if (tap_valid[lane]) begin
                // Contract violation: request while the bus is busy.
                error_q <= 1'b1;
            end
        end

        assign tap_error[lane] = error_q;
    end
endmodule
`default_nettype wire
