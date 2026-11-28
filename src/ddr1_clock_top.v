// DDR1_CLOCK_TOP — DDR1 100 MHz on-chip clock generation (Phase B),
// pass 1 behavioral/RTL sketch.  Requirements:
// /grid/ddr-phy/docs/ADPLL_DDR1_REQUIREMENTS.md sections 1-2.
//
// ARCHITECTURE DECISION (latest): candidate B (master/slave ratio DLL) is
// the Phase-B architecture.  USE_DLL90 defaults to 1.  Candidate A
// (dual-edge divide-by-2) is kept for comparison/experiments.
//
//   MCK_IN (200 MHz, ADPLL integer divider output -- the fractional
//           OUT_DIV output is FORBIDDEN for DDR use)
//     -> optional ADCC_TOP (duty correction, USE_DCC=1, candidate-A
//           experiments only) -> MCK_PATH
//     -> DDR1_CK90_DE2 (candidate A / always present as the CK source)
//          CK  = 100 MHz
//     -> DDR1_CK90_DLL (candidate B, default: USE_DLL90=1)
//          CK90 = CK + 2.5 ns by the 4:1 replica ratio, locked on CK
//     -> SYS_CLK = CK/2 toggle flop (edge-aligned with CK by construction)
//     -> fail-closed output gate (PHY_LOCKED)
//
// Why DCC is optional and OFF by default (USE_DCC=0):
//   Candidate B locks on CK, and CK is the toggle-divider output of MCK.
//   A divide-by-2 toggle is 50% duty by construction (both halves are one
//   MCK period), so CK/CK90 for candidate B do not need the ADCC.  The
//   ADCC remains instantiable (USE_DCC=1) for candidate-A experiments,
//   where CK90 is the negedge divider and therefore carries MCK duty
//   error.  With USE_DCC=0 the DCC outputs are tied off (dcc_locked=1,
//   dcc_err=0) and the DCC-loss ERR arming naturally does not apply.
//   TICK/SAMP are exposed as INPUT PORTS so a USE_DCC=1 build can be
//   driven by real/simulated sources (pass 2 real-cell evidence); with
//   USE_DCC=0 they are unused inputs.
//
// Interface contract (lane):
//   * CK_PHY/CK_PHY_N 100 MHz complementary pair, 45-55% duty, both low
//     when unlocked.
//   * CK90_PHY lags CK_PHY by 2.5 ns +/-0.2 ns (target +/-0.1 ns).
//   * SYS_CLK 50 MHz, rise edge-aligned with a CK_PHY rise.
//   * PHY_LOCKED high only when the full chain is valid; deasserts
//     immediately on loss.
//   * ERR sticky: set on (a) PLL_LOCKED drop after lock, (b) candidate-B
//     DLL rail / false lock / lost lock / acquisition timeout, (c) DCC_ERR
//     when USE_DCC=1 AND after the DCC path has locked once (the raw
//     ADCC_ERR ILL flags pulse while the DCC code integrates up from
//     reset, so it must not poison a fresh acquisition), (d) CK90
//     phase-monitor violation.  ERR clears only on RST and blocks
//     PHY_LOCKED.
//
// BLOCKER FIXES in this revision
// ------------------------------
// 4. DLL enable: DDR1_CK90_DLL is held in reset while PLL_LOCKED=0
//    (`.RST(RST | ~PLL_LOCKED)`) and disabled (`.EN(PLL_LOCKED)`), exactly
//    like src/ddr_clock_phy.v (`dll_en = DLL_EN & PLL_LOCKED`).  It can no
//    longer lock on the ADPLL acquisition-time frequency; a PLL lock loss
//    resets it and the next PLL lock re-acquires.
//
// 5. DCC lock loss is now visible after the latch.  err_q is armed (sticky)
//    on dcc_err, and a debounced DCC-lock-loss (DCC_LOSS_DBC_CY consecutive
//    MCK cycles with dcc_locked=0, default 4) clears latch_q.  The debounce
//    is needed because DCC_LOCKED is a dither-window level; 4 cycles is
//    long enough to reject the normal dither while dropping PHY_LOCKED
//    fail-closed on a real loss.  With USE_DCC=0 all of this is tied off.
//
// 6. CK90 phase monitor.  A CK-clocked structural monitor samples CK90 at
//    three points per CK period: the CK rising edge (must be low, rejects
//    0 degrees), the CK falling edge (must be high, rejects 270 degrees),
//    and CK-rise + 2.8 ns = T/4 + margin (must be high, rejects the
//    forbidden 180-degree inverse -- BLOCKER 3 of attempt 3: the first two
//    samples alone are satisfied by both 90-degree lag and 180-degree
//    inverse).  CK90_MON_N consecutive failures (default 3) set a sticky
//    ck90_mon_err that feeds ERR and clears PHY_LOCKED.  For candidate B
//    this checks the DLL quadrature; for candidate A it checks the
//    structural negedge relationship only (it does NOT measure duty
//    accuracy -- real-cell duty/phase accuracy is pass-2).  Real-cell
//    monitor accuracy (a sub-ns TDC/edge-order check) is also pass-2.
//
// 7. Lock-release runt.  latch_q is a debounced level in the MCK domain;
//    releasing the output gate directly on it could start CK90 mid-high
//    when the latch happened to set on a CK falling edge.  `go_q` registers
//    the RELEASE on a ck_a RISING edge (both candidates have CK90 low
//    there), while the DROP is asynchronous (negedge of phy_lock_core).
//    Thus the first CK and CK90 pulses are always full-width and CK leads
//    CK90.
//
// 8. Bypass holes:
//    (a) bypass outputs are gated by the bypass-lock latch (blatch/bgo_q);
//    (b) the bypass lock debouncer is clocked by EXT_SYS_CLK, not MCK.  If
//        EXT_SYS_CLK is not running the outputs stay low (correct Phase-A
//        behaviour: no board clock -> no output);
//    (c) BYPASS is 2-flop synchronized into the EXT_SYS_CLK domain and is
//        committed ONLY while RST is asserted; changes outside reset are
//        ignored (BYPASS must be changed during reset).  The mux therefore
//        never switches a live clock.  The bypass output gate is also
//        registered on an EXT_CK rising edge (bgo_q) so no runt is
//        launched;
//    (d) sys_r is cleared whenever the core is unlocked, so the first
//        SYS_CLK after every lock/relock is a full CK-aligned pulse.
//
// 9. ERR blind window: locked_seen is now armed from the SAME MCK edge
//    that sets latch_q (latch_next), instead of one edge later.
//
// DLL choice (per brief): DLL_FULL_PERIOD_TOP is NOT instantiated.  Its
// internal line (4x56 cells x ~30 ps + T0 2930 ps) is sized for ~5 ns
// periods and cannot cover a 10 ns lock; candidate B therefore implements
// its own quarter-replica ratio DLL (see ddr1_ck90_dll.v header).
//
// Reset semantics: RST async, active high.  All dividers/toggles are
// forced to 0, so the first CK edge after release is at the next MCK
// rising edge and CK90 lags it by one MCK half-period.
//
// DBG[15:0] layout (documented):
//   [15] PHY_LOCKED   [14] ERR (sticky)   [13] BYPASS(committed)
//   [12] USE_DLL90    [11] DLL_LOCKED     [10] DLL_ERR
//   [9] DCC_LOCKED    [8] DCC_ERR         [7:0] DLL code (B; 0 if A)
//
// Parameters:
//   MCK_DIV is documentation-only in pass 1 (MCK_IN is assumed to be
//   already the final 200 MHz integer-divided master clock).
`timescale 1ns/1ps

module DDR1_CLOCK_TOP #(
    parameter integer MCK_DIV     = 2,    // documentation-only, see header
    parameter integer USE_DLL90   = 1,    // 1 = candidate B (default), 0 = A
    parameter integer BYPASS_EN   = 1,    // Phase A bypass mux present
    parameter integer LOCK_DBC_CY = 8,    // debounce MCK cycles
    // ADCC (duty corrector) plumbing -- off by default for candidate B
    parameter integer USE_DCC     = 0,
    parameter [15:0]  DCC_KI      = 16'd1,
    // BLOCKER 5: DCC-lock-loss debounce (MCK cycles).
    // Attempt-3 tuning 4 -> 16: measured on the re-integration path, the
    // DCC presents dcc_locked LOW stretches of up to 9 MCK cycles after
    // every reset (harness: /tmp/opencode/t_dcc.v, worst=9 over 40 us).
    // With 4, every normal re-integration debounced "loss" dropped the
    // latch and (once arming follows dcc_loss_deb) armed sticky ERR ~10 us
    // after every reset, permanently poisoning a fresh acquisition.
    // 16 = 40 ns still catches a real loss in far under one check window
    // (check13 forces 200 ns = 80 MCK) while 2x margin over the 9-cycle
    // integration glitch.
    parameter integer DCC_LOSS_DBC_CY = 16, // DCC-lock-loss debounce (MCK cy)
    parameter integer CK90_MON_N  = 3     // CK90 phase-monitor failure count
) (
    input  wire MCK_IN,       // 200 MHz master clock (ADPLL integer divider)
    input  wire PLL_LOCKED,   // upstream PLL lock status
    input  wire RST,          // async reset, active high
    // Pass-1-only DCC sources (unused when USE_DCC=0)
    input  wire TICK,         // DCC loop clock
    input  wire SAMP,         // DCC incommensurate duty sampler
    // Phase A bypass: external (board-provided) clocks
    input  wire EXT_CK, EXT_CK90, EXT_SYS_CLK,
    input  wire BYPASS,       // 1 = pass external clocks through
    // outputs
    output wire CK_PHY, CK_PHY_N, CK90_PHY, SYS_CLK,
    output wire PHY_LOCKED,
    output wire ERR,
    output wire [15:0] DBG
);
    wire RST_N = ~RST;
    wire en    = ~RST;

    // ------------------------------------------------------------------
    // Optional duty correction on the 200 MHz MCK (candidate-A experiments).
    // ------------------------------------------------------------------
    wire        mck_dcc;
    wire        dcc_locked, dcc_err;
    wire [7:0]  dcc_code;

    generate
        if (USE_DCC) begin : g_dcc
            ADCC_TOP #(
                .COARSE_NDELS(15), .MID_NDELS(15), .FINE_NDELS(31),
                .FILTER_BITS(16), .LOCK_COUNT(16),
                .MID_W(4), .COARSE_W(8)
            ) u_dcc (
                .CLK_IN(MCK_IN), .RST_N(RST_N), .TICK(TICK), .SAMP(SAMP),
                .EN(en), .KI(DCC_KI),
                .DUTY_OFFS(8'd0), .DUTY_INIT(8'd0),
                .CLK_OUT(mck_dcc), .LOCKED(dcc_locked), .ERR(dcc_err),
                .DUTY_CODE(dcc_code)
            );
        end else begin : g_dcc_byp
            // Candidate B: CK is a /2 toggle, 50% duty by construction, so
            // the DCC is not needed.  Tied off; DCC-loss logic is inert.
            assign mck_dcc    = MCK_IN;
            assign dcc_locked = 1'b1;
            assign dcc_err    = 1'b0;
            assign dcc_code   = 8'd0;
        end
    endgenerate

    // ------------------------------------------------------------------
    // Candidate A: dual-edge dividers on the (optionally corrected) MCK.
    // ------------------------------------------------------------------
    wire ck_a, ck90_a;
    DDR1_CK90_DE2 u_de2 (
        .MCK(mck_dcc), .RST(RST), .EN(en),
        .CK(ck_a), .CK90(ck90_a)
    );

    // ------------------------------------------------------------------
    // Candidate B: master/slave ratio DLL locked on CK.  BLOCKER 4: park
    // it in reset/disabled until PLL_LOCKED, and re-acquire on lock loss.
    // ------------------------------------------------------------------
    wire        dll_locked_c, dll_err_c;
    wire [8:0]  dll_code_c;
    wire        ck90_b;

    generate
        if (USE_DLL90) begin : g_dll
            DDR1_CK90_DLL #(.NQ_SEG(64), .CODE_BITS(9)) u_dll (
                .CKIN(ck_a), .RST(RST | ~PLL_LOCKED), .EN(PLL_LOCKED),
                .CK90(ck90_b), .DLL_LOCKED(dll_locked_c),
                .DLL_ERR(dll_err_c), .DBG_CODE(dll_code_c)
            );
        end else begin : g_dll_off
            assign ck90_b       = 1'b0;
            assign dll_locked_c = 1'b0;
            assign dll_err_c    = 1'b0;
            assign dll_code_c   = 9'd0;
        end
    endgenerate

    // CK90 select (incl. BLOCKER 2 test inversion) is declared with the
    // phase monitor below; CK90_PHY uses ck90_sel.

    // BLOCKER 2 (attempt 3) TEST SCAFFOLDING (pass-2 removal): ck90_inv_tb
    // injects the forbidden 180-degree inverse CK90 (= ~CK, "force
    // ck90_sel = ~ck_a") so the monitor test can prove sample 3 catches
    // what samples 1+2 miss.  A procedural `force ck90_sel = ~ck_a` cannot
    // be used: iverilog evaluates the force RHS only ONCE (constant), which
    // would collapse the injection to a stuck level caught by sample 1.
    // This is a plain internal reg (not a port, constant 0 in synthesis)
    // driving a continuous mux, so the inversion tracks ck_a exactly;
    // pass 2 deletes it and relies on a real fault-injection path.
    reg  ck90_inv_tb = 1'b0;
    wire ck90_nonsel = USE_DLL90 ? ck90_b : ck90_a;
    wire ck90_sel = ck90_inv_tb ? ~ck_a : ck90_nonsel;

    // ------------------------------------------------------------------
    // BLOCKER 6 + BLOCKER 2 (attempt 3): CK90 phase monitor (structural,
    // CK-clocked).  Three samples per CK period; a failure after
    // CK90_MON_N consecutive CK cycles is sticky and feeds ERR.
    //   1. at CK rise        CK90 must be LOW   (rejects 0 degrees)
    //   2. at CK fall        CK90 must be HIGH  (rejects 270 degrees)
    //   3. at CK rise+2.8 ns CK90 must be HIGH  (rejects 180 degrees)
    // Sample 3 is the BLOCKER 2 fix: samples 1+2 alone are satisfied by
    // BOTH the correct 90-degree lag AND the forbidden 180-degree inverse
    // (they differ only in the middle quadrants), so the old monitor
    // accepted an inverted CK90.  A correct 90-degree CK90 rises at
    // CK-rise+2.5 ns (+/-0.2 ns spec), so at 2.8 ns it reads HIGH; the
    // 180-degree inverse (~CK, or CK delayed by T/2) is LOW across the
    // whole CK high phase, so sample 3 reads LOW and the monitor trips.
    // 2.8 ns = T/4 + 0.3 ns clears both the coincident 2.5 ns edge and the
    // +0.2 ns spec corner with margin.  Behavioural implementation: a
    // delayed replica of CK (assign #2.8) clocking the sample flop.
    // Real-cell equivalent: an edge-order comparator / TDC that timestamps
    // the CK90 edge against CK and checks lag within T/4 +/-0.2 ns.
    // For candidate B this checks the DLL quadrature; for candidate A the
    // structural negedge relationship (NOT duty accuracy -- real-cell
    // duty/phase accuracy is pass 2).
    // ------------------------------------------------------------------
    wire ck_a_qtr;
    assign #2.8 ck_a_qtr = ck_a;          // CK rise + T/4 + margin
    reg  ck90_at_qtr;
    always @(posedge ck_a_qtr or posedge RST) begin
        if (RST) ck90_at_qtr <= 1'b0;
        else     ck90_at_qtr <= ck90_sel; // sampled at CK-rise + 2.8 ns
    end

    reg ck90_at_fall;
    always @(negedge ck_a or posedge RST) begin
        if (RST) ck90_at_fall <= 1'b1;
        else     ck90_at_fall <= ck90_sel;
    end

    reg [3:0] mon_fail;
    reg       ck90_mon_err;
    always @(posedge ck_a or posedge RST) begin
        if (RST) begin
            mon_fail     <= 4'd0;
            ck90_mon_err <= 1'b0;
        end else if (phy_lock_core) begin
            if ((ck90_sel !== 1'b0) || (ck90_at_fall !== 1'b1) ||
                (ck90_at_qtr !== 1'b1)) begin
                if (mon_fail >= CK90_MON_N-1) ck90_mon_err <= 1'b1;
                else                          mon_fail     <= mon_fail + 1'b1;
            end else begin
                mon_fail <= 4'd0;
            end
        end else begin
            mon_fail <= 4'd0;
        end
    end

    wire ck90_ok = (USE_DLL90 ? dll_locked_c : 1'b1) & ~ck90_mon_err;

    // ------------------------------------------------------------------
    // BLOCKER 5: debounced DCC-lock loss (inert when USE_DCC=0).
    // ------------------------------------------------------------------
    reg [7:0] dcc_loss_cnt;
    always @(posedge MCK_IN or posedge RST) begin
        if (RST || !USE_DCC)      dcc_loss_cnt <= 8'd0;
        else if (dcc_locked)      dcc_loss_cnt <= 8'd0;
        else if (dcc_loss_cnt < DCC_LOSS_DBC_CY[7:0])
            dcc_loss_cnt <= dcc_loss_cnt + 1'b1;
    end
    wire dcc_loss_deb = (USE_DCC != 0) &&
                        (dcc_loss_cnt >= DCC_LOSS_DBC_CY[7:0]);

    // ------------------------------------------------------------------
    // BLOCKER 8(c): BYPASS is synchronized/committed only while RST is
    // asserted.  Changes outside reset are ignored, so the output mux is
    // only ever switched while both sides are quiet.
    // ------------------------------------------------------------------
    reg bp_meta, bp_sync, bypass_q;
    always @(posedge EXT_SYS_CLK or posedge RST) begin
        if (RST) begin
            bp_meta  <= BYPASS;
            bp_sync  <= BYPASS;
            bypass_q <= BYPASS;     // commit reset value
        end else begin
            bp_meta <= BYPASS;
            bp_sync <= bp_meta;
            // bypass_q holds: BYPASS changes after reset are ignored
        end
    end

    // BLOCKER 8(b): bypass lock debounce clocked by EXT_SYS_CLK.
    reg [15:0] bdbc;
    reg        blatch;
    always @(posedge EXT_SYS_CLK or posedge RST) begin
        if (RST || !bypass_q) begin
            bdbc   <= 16'd0;
            blatch <= 1'b0;
        end else begin
            if (bdbc < LOCK_DBC_CY) bdbc <= bdbc + 1'b1;
            if (bdbc >= LOCK_DBC_CY-1) blatch <= 1'b1;
        end
    end

    // Bypass output gate: register release on an EXT_CK rising edge so the
    // external clocks are never ungated mid-pulse.  Async drop on loss.
    reg bgo_q;
    always @(posedge EXT_CK or posedge RST or negedge blatch) begin
        if (RST || !blatch) bgo_q <= 1'b0;
        else                bgo_q <= 1'b1;
    end

    // ------------------------------------------------------------------
    // Core lock qualification (BLOCKERS 5, 9).
    //   chain_ok      : everything that must be valid to SET the latch
    //   phy_lock_core : the latched, qualified lock (DCC loss is debounced)
    // ------------------------------------------------------------------
    reg  err_q;
    reg  locked_seen;    // a valid chain lock was observed since reset
    reg  [15:0] dbc;
    reg         latch_q;

    wire dcc_ok        = USE_DCC ? dcc_locked : 1'b1;
    wire chain_ok      = PLL_LOCKED & ck90_ok & dcc_ok & ~err_q;
    wire latch_next    = chain_ok && (dbc >= LOCK_DBC_CY-1);
    wire phy_lock_core = latch_q & PLL_LOCKED & ck90_ok & ~err_q
                       & ~dcc_loss_deb;

    // Merged lock/ERR block: locked_seen is armed from the SAME edge that
    // sets latch_q (blocker 9).
    always @(posedge MCK_IN or posedge RST) begin
        if (RST) begin
            err_q       <= 1'b0;
            locked_seen <= 1'b0;
            dbc         <= 16'd0;
            latch_q     <= 1'b0;
        end else begin
            // ---- sticky ERR arming ----
            if (bypass_q) begin
                locked_seen <= 1'b0;   // on-chip lock state is stale
            end else if (latch_q || latch_next) begin
                locked_seen <= 1'b1;   // same edge as latch_q
            end

            if (!bypass_q && locked_seen && !PLL_LOCKED) err_q <= 1'b1;
            if (!bypass_q && USE_DLL90 && dll_err_c)     err_q <= 1'b1;
            // DCC_ERR (ADCC: lost_r | ILL_P | ILL_N) is NOT armable as a
            // raw level: lost_r latches high on the FIRST out-of-band code
            // excursion and never clears until RST, and ILL flags pulse
            // during normal acquisition -- both fire within ~20 us of any
            // reset while the DCC is still integrating.  Arming on that
            // level (gated or not by the top-level locked_seen) latches
            // err_q before the chain can hold lock, permanently killing
            // PHY_LOCKED after any mid-test reset (BLOCKER 5 follow-up:
            // observed uC never re-locking; whether check13 passed was a
            // race between the arm pulse and the lockC sample).
            // The arm condition is therefore the DEBOUNCED DCC lock LOSS --
            // the same condition that clears latch_q -- which is a real,
            // sustained loss (>= DCC_LOSS_DBC_CY MCK cycles) after the
            // chain has locked at least once (locked_seen).  check13's
            // 200 ns forced loss trips it within 40 ns; normal
            // re-integration lows (<= 9 MCK measured) never do.
            if (!bypass_q && USE_DCC && dcc_loss_deb && locked_seen) err_q <= 1'b1;
            if (!bypass_q && ck90_mon_err)               err_q <= 1'b1;

            // ---- latch set / clear ----
            if (bypass_q) begin
                dbc     <= 16'd0;
                latch_q <= 1'b0;   // leaving bypass requires full relock
            end else if (chain_ok) begin
                if (dbc < LOCK_DBC_CY) dbc <= dbc + 1'b1;
                if (dbc >= LOCK_DBC_CY-1) latch_q <= 1'b1;
            end else begin
                dbc <= 16'd0;
                // DCC dither loss (debounced) is now a latch-clear source.
                if (!PLL_LOCKED || !ck90_ok || dcc_loss_deb)
                    latch_q <= 1'b0;
            end
        end
    end

    // ------------------------------------------------------------------
    // SYS_CLK: /2 toggle in the CK domain.  BLOCKER 8(d): clear whenever
    // the core is unlocked so the first pulse after lock/relock is full.
    // ------------------------------------------------------------------
    reg sys_r;
    always @(posedge ck_a or posedge RST or negedge phy_lock_core) begin
        if (RST || !phy_lock_core) sys_r <= 1'b0;
        else                       sys_r <= ~sys_r;
    end

    // ------------------------------------------------------------------
    // BLOCKER 7: register the gate RELEASE on a ck_a rising edge; keep the
    // asynchronous DROP.  At a ck_a rise CK90 is low for both candidates,
    // so the first output pulses are full-width and correctly ordered.
    // ------------------------------------------------------------------
    reg go_q;
    always @(posedge ck_a or posedge RST or negedge phy_lock_core) begin
        if (RST || !phy_lock_core) go_q <= 1'b0;
        else                       go_q <= 1'b1;
    end

    assign ERR        = err_q;
    assign PHY_LOCKED = bypass_q ? blatch : go_q;

    // ------------------------------------------------------------------
    // Fail-closed output gate (single quiet gate, see header).
    // ------------------------------------------------------------------
    assign CK_PHY   = bypass_q ? (bgo_q &  EXT_CK)
                               : (go_q  &  ck_a);
    assign CK_PHY_N = bypass_q ? (bgo_q & ~EXT_CK)
                               : (go_q  & ~ck_a);
    assign CK90_PHY = bypass_q ? (bgo_q &  EXT_CK90)
                               : (go_q  &  ck90_sel);
    assign SYS_CLK  = bypass_q ? (blatch & EXT_SYS_CLK)
                               : (go_q  &  sys_r);

    // ------------------------------------------------------------------
    // Debug taps (see header for layout).
    // ------------------------------------------------------------------
    assign DBG = {PHY_LOCKED, ERR, bypass_q, (USE_DLL90 != 0),
                  dll_locked_c, dll_err_c, dcc_locked, dcc_err,
                  dll_code_c[7:0]};
endmodule
