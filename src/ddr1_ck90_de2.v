// DDR1_CK90_DE2 — DDR1 100 MHz CK90 generation, candidate A: dual-edge
// divide-by-2 (Phase B on-chip clock generation, pass 1 behavioral/RTL).
//
// Structure
//   CK   : toggle flop clocked on POSEDGE MCK  (100 MHz, = MCK/2)
//   CK90 : toggle flop clocked on NEGEDGE MCK  (100 MHz, lags CK by one
//          MCK half-period = 2.5 ns when MCK duty = 50%)
// Both flops share the SAME asynchronous reset, and the reset RELEASE is
// re-timed inside the module: a release-strobe flop `rel` is set by the
// first MCK FALLING edge after RST deasserts, and the dividers only leave
// reset once rel=1 (i.e. during the MCK low phase).  This removes the
// start-up phase hazard of a raw dual-edge divider: if reset were
// released during MCK high, the negedge divider would toggle first and
// CK90 would come up 90 degrees EARLY (lag = T_MCK/2 + T_MCK/2 low) --
// the forbidden ambiguity.  With the rel strobe, the first edge each
// divider sees after release is, by construction, a rising edge (CK) and
// then a falling edge (CK90) exactly one MCK half-period later, so CK90
// always lags CK by the MCK high time with no run-to-run ambiguity.
//
// Reset release synchronizer (BLOCKER FIX): the release path is a proper
// two-flop synchronizer clocked on the MCK FALLING edge (async assert,
// synchronous deassert).  The synchronizer output therefore changes only
// on a falling edge, which keeps the original phase guarantee: the first
// edge each divider sees after release is a rising edge (CK), then a
// falling edge (CK90) one MCK half-period later.  A single-flop release
// (old code) could go metastable and resolve in the wrong phase.
//
// Remaining metastability assumption: RST deassertion is asynchronous to
// MCK.  The first synchronizer flop can still go metastable; the second
// flop supplies one full MCK period of settling and the release is
// qualified by the negedge (the clocked edge is never used to launch the
// first divider edge, so a resolved-late first flop merely delays release
// by one MCK cycle and cannot invert the CK/CK90 order).  Actual MTBF
// must be signed off with the real library flop in pass 2.
//
// Phase error budget (documented per requirements 2):
//   err(CK90 vs CK) = (MCK high time - T_MCK/2)
//                   = MCK duty error at the flop clock pin
//                   + negedge-distribution path skew (0 in behavioral sim)
//   The +/-0.2 ns CK90 spec at T_CK = 10 ns tolerates 4% MCK duty error;
//   the +/-0.1 ns target tolerates 2%.  Duty correction is UPSTREAM
//   responsibility (ADCC on the 200 MHz MCK, see DDR1_CLOCK_TOP).
//
// EN is the quiet/fail-closed gate: EN=0 forces CK and CK90 low.  The
// internal flops keep running while EN=0 so phase continuity is kept for
// re-enable.  The final fail-closed AND with PHY_LOCKED is done once, in
// DDR1_CLOCK_TOP, to avoid stacking two live-signal AND gates.
//
// Reset: RST is asynchronous, active high.  Both divider flops are reset
// by the same event; deassertion is also the same event, which is what
// makes the phase offset deterministic.
//
// Pass 1 caveats (behavioral):
//   * flops are zero-delay behavioral; real clk->q and hold behavior must
//     be re-verified with IHP130 real cells (STA/SDF) in pass 2.
`timescale 1ns/1ps

module DDR1_CK90_DE2 (
    input  wire MCK,     // 200 MHz master clock (duty-corrected upstream)
    input  wire RST,     // async reset, active high; aligns both dividers
    input  wire EN,      // quiet gate: 0 -> CK and CK90 forced low
    output wire CK,      // 100 MHz from posedge divider
    output wire CK90     // 100 MHz from negedge divider, lags CK by T_MCK/2
);
    reg ck_q;
    reg ck90_q;
    reg [1:0] rel_sync;

    // Explicit inverted clock for the negedge logic: sg13g2 has posedge
    // flops only and synthesis rejects mixed-edge clocking on one net
    // (bisected on DDR1_CLK_DE3, 2026-11-28).  In synthesis this inversion
    // must be a clock-tree inverter cell whose delay is part of the clock
    // network latency budget -- pass-2 STA item.
    wire mck_n;
    assign mck_n = ~MCK;

    // Two-flop async-assert / sync-deassert reset synchronizer.  Both
    // stages are clocked on the MCK falling edge so the release strobe
    // (rel_sync[1]) only ever changes during the MCK low phase, exactly
    // one MCK edge after the previous stage.
    always @(posedge mck_n or posedge RST) begin
        if (RST) rel_sync <= 2'b00;
        else     rel_sync <= {rel_sync[0], 1'b1};
    end
    wire rel = rel_sync[1];

    // Reset discipline as async-reset + synchronous-enable: the mixed
    // `if (RST || !rel)` form is NOT synthesizable (yosys proc rejects it
    // as multiple edge-sensitive events).  rel is stable across each MCK
    // edge by the synchronizer construction, so gating the update is
    // timing-equivalent to holding the flop in reset until release.
    // Posedge divider -> CK.  Reset value 0.
    always @(posedge MCK or posedge RST) begin
        if (RST)         ck_q <= 1'b0;
        else if (rel)    ck_q <= ~ck_q;
    end

    // Negedge divider -> CK90.  Same async reset event as ck_q.
    always @(posedge mck_n or posedge RST) begin
        if (RST)         ck90_q <= 1'b0;
        else if (rel)    ck90_q <= ~ck90_q;
    end

    assign CK   = EN & ck_q;
    assign CK90 = EN & ck90_q;
endmodule
