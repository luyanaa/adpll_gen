`timescale 1ns/1ps
// Alexander (bang-bang / 2x-oversampling) phase detector for CDR.
//
// Samples the incoming NRZ data at two phases a quarter/half UI apart:
//   D  = data-phase sample  (ideally at the eye centre)
//   E  = edge-phase sample  (ideally on the transition boundary)
// The XOR of E against the two neighbouring data samples gives the
// early/late sign that steers the sampling phase:
//   transition present and E == prev data  -> sampling too late  (UP)
//   transition present and E == next data  -> sampling too early (DN)
//   no transition                          -> no info (hold)
//
// SAMP_D / SAMP_E are the raw sampler outputs (in SIMULATION they are
// ideal sampled taps of the data waveform produced by cdr_top's delay
// taps; in silicon they are real FF samples at the two phases).  This
// module only does the digital early/late decode, which is identical
// in both views.
module ALEXANDER_PD (
    input  D_PREV,    // data sample of the previous UI
    input  D,         // data sample of the current UI (eye centre)
    input  D_NEXT,    // data sample of the next UI
    input  E,         // edge sample between D_PREV..D or D..D_NEXT
    output reg [1:0]  BBPD       // 10 = early (shift earlier), 01 = late (shift later), 00/11 = hold
);
    // A transition exists between D_PREV and D if they differ; the edge
    // sample E between them tells which side of the boundary we are on.
    wire tr_prev = D_PREV ^ D;
    wire tr_next = D      ^ D_NEXT;

    always @(*) begin
        if (tr_next) begin
            // E is the edge sample between D and D_NEXT.  If E still
            // holds D (the previous bit) the sampling phase is LATE (the
            // boundary has not yet been reached) -> ask for -delay (01).
            // If E already reads D_NEXT the phase is EARLY -> +delay (10).
            BBPD = (E == D_NEXT) ? 2'b10 : 2'b01;
        end else if (tr_prev) begin
            BBPD = (E == D) ? 2'b01 : 2'b10;
        end else begin
            BBPD = 2'b00;   // no transition -> hold
        end
    end
endmodule
