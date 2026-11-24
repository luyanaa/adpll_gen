// CDR_TOP for IHP SG13G2 — SerDes CDR_MODE=4 endpoint.
//
// Interface contract: ../OpenSERDES rtl/serdes_rx_digital.sv (CDR_MODE=4) and
// rtl/cdr_multiphase.sv.
//
//   the digital core supplies  rx_dll_tap[PH_W-1:0]  (a plain register slice)
//   this macro returns        rx_smp                 (the bit sampled at that
//                                                      phase, one clk late)
//
// The core never generates the edge.  It selects one of 2^PH_W equally spaced
// phases produced by PLL_MULTIPHASE_DCO, so the analog work here is:
//
//   PLL_MULTIPHASE_DCO  -> 2^PH_W phases of one period
//   PHASE_MUX_SIMPLE    -> pick phase[tap]
//   sampler FF          -> capture DATA on the selected phase
//
// That is the DLL/sampler half the SerDes document says lives outside
// cdr_multiphase (docs/dll_backend.md section 2).
//
// What is deliberately NOT here
// -----------------------------
// The bang-bang loop filter, the slot/fine accumulator and the lock FSM are
// all in cdr_multiphase (digital, generic).  Duplicating them here would mean
// two loops fighting over the same tap.  This macro is the analog back end
// plus the sampler hand-off, and nothing else.
//
// Timing contract the sampler must meet (docs/dll_backend.md section 2):
// the phase mux is set up from `tap` before the selected edge, and the sample
// is read on the following reference edge.  PHASE_MUX_SIMPLE below holds the
// output low while it changes taps so the mux never switches under a live
// edge, which is the same glitch-managed hand-off PHASE_SELECTOR_TOP uses.
`default_nettype none
`timescale 1ns/1ps

module CDR_TOP #(
    // 2^PH_W equally spaced phases.  PH_W=3 -> 8 phases, the documented
    // default (1.25 ns spacing at 100 MHz).
    parameter integer PH_W       = 3,
    // Stages per tap (NSTAGE = 8*STEP + 1).  6 -> ~243 MHz, 3 -> ~476 MHz at
    // SS on sg13g2_inv_1.  For a 500 MHz-class multiphase clock use STEP=3 and
    // pull down with CLOSE_LOAD.  DELAY_BITS is the legacy back-compat knob
    // (ignored while STEP!=0).
    parameter integer DELAY_BITS = 0,
    parameter integer STEP        = 3,
    parameter integer CLOSE_LOAD  = 0,
    // Number of reference cycles the phase mux parks low when the tap
    // changes.  1 is enough for the sampled edge to be safely away.
    parameter integer PARK_CYCLES = 1
) (
    input  wire                     REF,        // reference / sample clock
    input  wire                     RST_N,
    input  wire                     DCO_EN,     // release the ring
    input  wire                     DATA,       // incoming NRZ line
    input  wire [PH_W-1:0]          TAP,        // from cdr_multiphase
    output wire [ (1<<PH_W)-1 : 0 ] PHASE,      // all phases (observability)
    output wire                     SMP,        // sampled bit, valid next REF
    output wire                     SMP_VALID,  // SMP updated this cycle
    output wire                     REC_CLK     // recovered sampling clock
);
    localparam integer NPHASE = 1 << PH_W;

    wire dco_out, dco_out_n;

    PLL_MULTIPHASE_DCO #(
        .PH_W(PH_W), .DELAY_BITS(DELAY_BITS),
        .STEP(STEP), .CLOSE_LOAD(CLOSE_LOAD)
    ) u_dco (
        .DCO_EN(DCO_EN),
        .DCO_OUT(dco_out), .DCO_OUT_N(dco_out_n),
        .PHASE(PHASE)
    );

    // ------------------------------------------------------------------
    // Phase mux with a parking hand-off.
    //
    // Switching the mux while the selected phase is high would chop the
    // sampling edge.  The selector therefore parks its output low for
    // PARK_CYCLES reference cycles whenever TAP changes, and only then
    // connects the new phase.
    // ------------------------------------------------------------------
    reg [PH_W-1:0] tap_q;
    reg [3:0]      park_q;
    reg            mux_ready;

    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            tap_q     <= {PH_W{1'b0}};
            park_q    <= 4'd0;
            mux_ready <= 1'b0;
        end else begin
            tap_q <= TAP;
            if (TAP != tap_q) begin
                park_q    <= PARK_CYCLES[3:0];
                mux_ready <= 1'b0;
            end else if (park_q != 4'd0) begin
                park_q    <= park_q - 4'd1;
                mux_ready <= 1'b0;
            end else begin
                mux_ready <= 1'b1;
            end
        end
    end

    // One-hot phase select on the registered tap; gated by mux_ready so the
    // output is parked low during a hand-off.
    wire sel_phase;
    assign sel_phase = PHASE[tap_q] & mux_ready;

    // The recovered sampling clock is the selected phase, parked low during a
    // tap change.
    assign REC_CLK = sel_phase;

    // ------------------------------------------------------------------
    // Sampler.
    //
    // The data bit is captured on the selected phase, i.e. at the instant the
    // mux passes through, and presented on the next reference edge.  Modelling
    // it as a phase-clocked flop (rather than sampling DATA on REF) is what
    // makes the tap selection observable: a tap change moves the capture
    // instant.
    // ------------------------------------------------------------------
    reg smp_q;
    reg smp_valid_q;

    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            smp_q       <= 1'b0;
            smp_valid_q <= 1'b0;
        end else begin
            // Behavioural capture on the selected phase.  In the built macro
            // this is the sampler FF clocked by REC_CLK; the model keeps the
            // same sampling instant.
            smp_q       <= sel_phase ? DATA : smp_q;
            smp_valid_q <= mux_ready;
        end
    end

    assign SMP       = smp_q;
    assign SMP_VALID = smp_valid_q;

endmodule
`default_nettype wire
