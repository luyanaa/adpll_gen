// DDR1_CLK_DE3 — dual-edge divide-by-3: 300 MHz MCK -> 100 MHz, 50% duty.
//
// Why this exists: the DDR1 frequency plan (docs/DDR1_FREQ_PLAN.md, verdict
// 2026-11-28) is DCO = 300 MHz (FCW=3 x REF 100 MHz) divided by 3 for the
// DDR1 master clock.  Odd integer division cannot produce 50% duty from
// posedge-only logic (a posedge count of 3 gives 1/3 or 2/3 duty); the
// classical fix is the dual-edge construction below.
//
// Structure (glitch-free by construction):
//   q0,q1 : posedge-clocked state, sequence 00 -> 10 -> 11 -> 00 -> ...
//           (mod-3, exactly one full input period per phase, 3 phases)
//   qn    : negedge-clocked copy of q0 (half-cycle delayed)
//   OUT   = q0 | qn  ->  high for exactly 1.5 input periods per 3
//
// Timing algebra (T = input period):
//   q0 high during phase 10            : 1.0 T wide, starting at a posedge
//   qn = q1 delayed by T/2             : high during the second half of
//                                        phase 11 plus first half of
//                                        phase 00 = 1.0 T wide, starting
//                                        half a period after q0 falls
//   overlap of q0/qn                   : none (they abut)
//   OUT high time                      : q0 high 1.0T abutted by qn high
//                                        filling to T + h where h is the
//                                        input HIGH time
//   => OUT period exactly 3T (input-duty independent); high time T + h.
//      At 50% input duty h = T/2 -> output duty exactly 50%.  Input duty
//      error passes into the high time 1:1 but the period is fixed at 3T,
//      so output duty error = input duty error / 3 (attenuated, not
//      eliminated): input 40/60% -> output 46.7/53.3%, inside the DDR1
//      45-55% spec.  The output RISING edge is posedge-referenced and
//      input-duty independent; the DLL locks on period, which is exact.
//
// Glitch safety: q0/q1 change only on posedges, qn only on negedges.
// When q0 rises (posedge), qn is stable low (q1 was 0 in phase 00->10
// transition); when q0 falls (posedge into phase 11), qn rises half a
// period later — the OR inputs never transition simultaneously, so no
// runt pulse is possible at any input duty.  This is the standard
// reason the dual-edge odd divider is preferred over counter+logic.
//
// Reset: async active-high.  The first output edge after release is a
// RISING edge half a period after the first posedge that sees rel=1;
// release is re-timed by a two-flop negedge synchronizer (same discipline
// as DDR1_CK90_DE2) so qn never launches a leading edge before q0/q1
// have a defined phase — no start-up phase ambiguity, deterministic
// alignment of the output rising edges to input posedges.
//
// EN is the quiet/fail-closed gate: EN=0 forces OUT low while the divider
// keeps running (phase continuity).  The final AND with PHY_LOCKED is
// done once in DDR1_CLOCK_TOP.
//
// Pass-2 notes: clk->q mismatch between the posedge and negedge paths is
// the dominant residual duty/phase error; STA at TT/SS/FF must check the
// OR-gate for runt-pulse-free transitions (input duty sweep 40-60%).
`timescale 1ns/1ps

module DDR1_CLK_DE3 (
    input  wire MCK,     // 300 MHz master clock (DCO output / integer path)
    input  wire RST,     // async reset, active high
    input  wire EN,      // quiet gate: 0 -> OUT forced low
    output wire OUT      // 100 MHz, 50% duty by construction
);
    reg q0, q1, qn;
    reg [1:0] rel_sync;

    // Explicit inverted clock for the negedge logic.  sg13g2 (like most
    // stdcell libraries) has POSEDGE flops only, and synthesis tools
    // reject mixed-edge clocking on one net; the library-consistent form
    // is a dedicated clock-inverter cell plus posedge flops on the
    // inverted net.  In synthesis this inversion must be a clock-tree
    // cell (sg13g2_inv_1 or the clkinv variant, dont_touch) whose delay
    // is part of the clock network latency budget -- STA item pass 2.
    // The negedge copy qn and the release synchronizer are the ONLY
    // users; the divide state q0/q1 stays on the true clock.
    wire mck_n;
    assign mck_n = ~MCK;

    // Two-flop async-assert / sync-deassert release, clocked on the MCK
    // falling edge (posedge of mck_n) so `rel` only changes during the
    // MCK low phase: the first posedge after release starts the 00->10
    // phase deterministically.
    always @(posedge mck_n or posedge RST) begin
        if (RST) rel_sync <= 2'b00;
        else     rel_sync <= {rel_sync[0], 1'b1};
    end
    wire rel = rel_sync[1];

    // Posedge mod-3 state: 00 -> 10 -> 11 -> 00 -> ...
    //   phase encoding: state = {q1,q0}
    //   00: q0_next=1,q1_next=0  (entering 10)
    //   10: q0_next=0,q1_next=1  (entering 11)
    //   11: q0_next=0,q1_next=0  (entering 00)
    // Reset discipline as async-reset + synchronous-enable (the
    // `if (RST || !rel)` mixed form is NOT synthesizable -- yosys proc
    // rejects it as multiple edge-sensitive events; bisected 2026-11-28).
    // Timing-equivalent: rel is stable across each MCK edge by the
    // synchronizer construction, so gating the update is identical to
    // holding the flops in reset until release.
    always @(posedge MCK or posedge RST) begin
        if (RST) begin
            q0 <= 1'b0;
            q1 <= 1'b0;
        end else if (rel) begin
            // shift a single '1' through {q0,q1}: 00 -> 10 -> 01 -> 00
            q1 <= q0;
            q0 <= ~(q0 | q1);
        end
    end

    // Negedge copy of q0 (NOT q1): qn must already be high when q0 falls
    // at the 01->10 posedge, otherwise OUT notches low for half a cycle.
    // qn rises at the negedge inside state 01 (q0=1 there) and falls at
    // the negedge inside state 10 (q0=0 there) -- abutting q0's high
    // pulse with overlap on both sides, no simultaneous OR-input
    // transitions, no notch.
    always @(posedge mck_n or posedge RST) begin
        if (RST)         qn <= 1'b0;
        else if (rel)    qn <= q0;
    end

    assign OUT = EN & (q0 | qn);
endmodule
