`timescale 1ns/1ps
// PHASE_SELECTOR_TOP — glitch-managed phase selector / rotator.
//
// A phase selector picks one of N equally-spaced clock phases.  Here the
// "phases" are the taps of the shared DCDL: the input clock is pushed
// down the COARSE->MID->FINE cascade and the MUX selects which tap is
// driven out.  Unlike the DLL (which accumulates taps for a transport
// delay), a selector exposes the tap as the output phase directly.
//
// The hard part is GLITCHLESS switching: moving the select while an edge
// is in flight produces a runt pulse.  This block implements the
// standard two-phase "deselect -> reselect" handoff: on a change request
// the output is first parked low for a dead time, then the new tap is
// connected, so no partial edge propagates.  It is the same quiet-window
// idea used for the ADCC tap-update gating.
module PHASE_SELECTOR_TOP #(
    parameter integer NTAPS = 16,        // number of selectable taps
    parameter integer SEL_BITS = 4,
    parameter integer DEAD_TICKS = 2     // park cycles between deselect/reselect
) (
    input  CLK_IN,                       // source clock driving the taps
    input  RST_N,
    input  TICK,                         // control clock for the handoff
    input  [SEL_BITS-1:0] SEL_REQ,       // requested tap index
    input  SEL_UPD,                      // strobe: apply SEL_REQ
    output CLK_OUT,                      // selected (glitch-managed) phase
    output reg [SEL_BITS-1:0] SEL_CUR,   // currently-active tap
    output reg BUSY                      // handoff in progress (out parked)
);
`ifdef SIMULATION
    // Functional model: synthesise NTAPS equally delayed copies of CLK_IN
    // on a ~15 ps grid so the select exercises real timing, then MUX.
    localparam integer STEP_PS = 60;
    wire [NTAPS-1:0] tap;
    genvar g;
    generate
        for (g = 0; g < NTAPS; g = g + 1) begin : taps
            // each tap is CLK_IN delayed by g*STEP_PS (behavioural)
            wire #((g*STEP_PS)/1000.0) t = CLK_IN;
            assign tap[g] = t;
        end
    endgenerate
`else
    // Physical view: these taps come from a DCDL tap-out bus.
    wire [NTAPS-1:0] tap;   // driven by the delay-line tap bus
`endif

    // Glitch-managed select: deselect (park out low) for DEAD_TICKS, then
    // connect the new tap.  sel_act is only changed while BUSY, i.e. while
    // the output is held low, so the MUX never switches under a live edge.
    reg [SEL_BITS-1:0] sel_act;
    reg [SEL_BITS-1:0] dead;
    reg switching;

    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            sel_act <= 0; SEL_CUR <= 0; dead <= 0; switching <= 0; BUSY <= 0;
        end else if (!switching && SEL_UPD && (SEL_REQ != sel_act)) begin
            // begin handoff: park output, remember target
            switching <= 1; BUSY <= 1;
            SEL_CUR <= SEL_REQ;
            dead <= DEAD_TICKS[SEL_BITS-1:0];
        end else if (switching) begin
            if (dead != 0) begin
                dead <= dead - 1;
            end else begin
                sel_act <= SEL_CUR;      // reselect while output parked
                switching <= 0; BUSY <= 0;
            end
        end
    end

    // Output: parked low during handoff, otherwise the active tap.
    assign CLK_OUT = switching ? 1'b0 : tap[sel_act];
endmodule
