// DDR1_CLOCK_TOP — DDR1 100 MHz on-chip clock generation (Phase B),
// pass 1 behavioral/RTL sketch.  Requirements:
// /grid/ddr-phy/docs/ADPLL_DDR1_REQUIREMENTS.md sections 1-2.
//
// ARCHITECTURE (locked 2026-11-28, docs/DDR1_FREQ_PLAN.md):
//   MCK_IN (300 MHz, ADPLL DCO=300MHz FCW=3 path -- the fractional
//           OUT_DIV output is FORBIDDEN for DDR use)
//     -> DDR1_CLK_DE3 dual-edge divide-by-3
//          CK  = 100 MHz, duty = 1/3-attenuated input duty error
//                (input 40/60% -> output 46.7/53.3%, inside DDR1 45-55%)
//     -> DDR1_CK90_DLL master/slave ratio DLL
//          CK90 = CK + 2.5 ns by the 4:1 replica ratio, locked on CK
//     -> SYS_CLK = CK/2 toggle flop (edge-aligned with CK by construction)
//     -> fail-closed output gate (PHY_LOCKED)
//
// 2026-11-28 architecture cleanup: candidate A (dual-edge divide-by-2)
//   and the ADCC duty-corrector path are REMOVED.  They were 200 MHz
//   experiments; at the committed 300 MHz MCK the DE2 divider would
//   produce 150 MHz, and no 300 MHz candidate-A duty experiment exists.
//   The divide-by-3 output duty is input-duty-attenuated 3x (DE3 algebra,
//   src/ddr1_clk_de3.v) and needs no correction inside the DDR1 45-55%
//   spec.  TICK/SAMP ports are gone with the DCC.
//
// Interface contract (lane):
//   * CK_PHY/CK_PHY_N 100 MHz complementary pair, 45-55% duty, both low
//     when unlocked.
//   * CK90_PHY lags CK_PHY by 2.5 ns +/-0.2 ns (target +/-0.1 ns).
//   * SYS_CLK 50 MHz, rise edge-aligned with a CK_PHY rise.
//   * PHY_LOCKED high only when the full chain is valid; deasserts
//     immediately on loss.
//   * ERR sticky: set on (a) PLL_LOCKED drop after lock, (b) DLL rail /
//     false lock / lost lock / acquisition timeout, (c) CK90 phase-monitor
//     violation.  ERR clears only on RST and blocks PHY_LOCKED.
//
// BLOCKER FIXES in this revision
// ------------------------------
// 4. DLL enable: DDR1_CK90_DLL is held in reset while PLL_LOCKED=0
//    (`.RST(RST | ~PLL_LOCKED)`) and disabled (`.EN(PLL_LOCKED)`), exactly
//    like src/ddr_clock_phy.v (`dll_en = DLL_EN & PLL_LOCKED`).  It can no
//    longer lock on the ADPLL acquisition-time frequency; a PLL lock loss
//    resets it and the next PLL lock re-acquires.
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
// Reset semantics: RST async, active high.  The DE3 divider and all
// toggles are forced to 0, so the first CK edge after release is aligned
// to an MCK rising edge (DDR1_CLK_DE3 header) and CK90 lags it by the
// DLL-controlled T/4.
//
// DBG[15:0] layout (documented):
//   [15] PHY_LOCKED   [14] ERR (sticky)   [13] BYPASS(committed)
//   [12] 1'b1 (was USE_DLL90)             [11] DLL_LOCKED     [10] DLL_ERR
//   [9:8] 2'b00 (was DCC)                 [7:0] DLL code
//
// Parameters:
//   MCK_DIV is documentation-only (MCK_IN is assumed to be already the
//   final 300 MHz integer-path master clock; the divider is inside).
`timescale 1ns/1ps

module DDR1_CLOCK_TOP #(
    parameter integer MCK_DIV     = 3,    // documentation-only, see header
    parameter integer USE_DLL90   = 1,    // vestigial (candidate A removed
                                          // 2026-11-28); must stay 1
    parameter integer BYPASS_EN   = 1,    // Phase A bypass mux present
    parameter integer LOCK_DBC_CY = 8,    // debounce MCK cycles (300 MHz:
                                          // 8 cy = 26.7 ns)
    parameter integer CK90_MON_N  = 3,    // CK90 phase-monitor failure count
    // Corner-selected phase calibration (docs/DDR1_HANDOFF.md §7).
    // TRIM_STRAP_EN=0 keeps the compile-time value inside the DLL (0), i.e.
    // the historical behavior; =1 enables the runtime 2-bit strap.
    // Values are MASTER-scale ps measured in SPICE:
    //   SS 1472 / TT 1018 / FF 791   (SEL: 0=TT default, 1=SS, 2=FF)
    parameter integer TRIM_STRAP_EN = 0,
    parameter integer TRIM_TT_PS    = 1018,
    parameter integer TRIM_SS_PS    = 1472,
    parameter integer TRIM_FF_PS    = 791
) (
    input  wire MCK_IN,       // 300 MHz master clock (ADPLL integer path)
    input  wire PLL_LOCKED,   // upstream PLL lock status
    input  wire RST,          // async reset, active high
    // Phase A bypass: external (board-provided) clocks
    input  wire EXT_CK, EXT_CK90, EXT_SYS_CLK,
    input  wire BYPASS,       // 1 = pass external clocks through
    input  wire [1:0] TRIM_SEL, // corner strap: 0=TT, 1=SS, 2=FF (see params)
    // outputs
    output wire CK_PHY, CK_PHY_N, CK90_PHY, SYS_CLK,
    output wire PHY_LOCKED,
    output wire ERR,
    output wire [15:0] DBG
);
    wire RST_N = ~RST;
    wire en    = ~RST;

    // ------------------------------------------------------------------
    // 300 MHz -> 100 MHz dual-edge divide-by-3 (50% at 50% input duty,
    // duty error attenuated 3x; DDR1_CLK_DE3 header).  This is the only
    // CK source: candidate A (DE2 divide-by-2) was retired with the
    // 200 MHz frequency plan.
    // ------------------------------------------------------------------
    wire ck_a;
    DDR1_CLK_DE3 u_de3 (
        .MCK(MCK_IN), .RST(RST), .EN(en),
        .OUT(ck_a)
    );

    // ------------------------------------------------------------------
    // Master/slave ratio DLL locked on CK.  BLOCKER 4: park it in
    // reset/disabled until PLL_LOCKED, and re-acquire on lock loss.
    // ------------------------------------------------------------------
    wire        dll_locked_c, dll_err_c;
    wire [8:0]  dll_code_c;
    // corner strap -> runtime trim (ignored unless TRIM_STRAP_EN=1)
    wire signed [15:0] trim_sel =
        (TRIM_SEL == 2'd1) ? TRIM_SS_PS[15:0] :
        (TRIM_SEL == 2'd2) ? TRIM_FF_PS[15:0] :
                             TRIM_TT_PS[15:0];
    wire        ck90_b;

    generate
        if (USE_DLL90) begin : g_dll
            DDR1_CK90_DLL #(.NQ_SEG(64), .CODE_BITS(9),
                            .TRIM_EXT_EN(TRIM_STRAP_EN)) u_dll (
                .CKIN(ck_a), .RST(RST | ~PLL_LOCKED), .EN(PLL_LOCKED),
                .TRIM_EXT(trim_sel),
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

    // BLOCKER 2 (attempt 3) TEST SCAFFOLDING — simulation-only since
    // 2026-11-28 (pass-2 removal done): the inversion mux must not exist in
    // silicon (it is a mux on a clock).  `ifdef SIMULATION keeps it for the
    // fault-injection tests (iverilog evaluates a procedural force RHS only
    // once, so a literal `force ck90_sel = ~ck_a` collapses to a stuck
    // level; the reg-driven mux tracks ck_a exactly).  Synthesis sees only
    // the direct connection.
`ifdef SIMULATION
    reg  ck90_inv_tb = 1'b0;
    wire ck90_sel = ck90_inv_tb ? ~ck_a : ck90_b;
`else
    wire ck90_sel = ck90_b;
`endif

    // ------------------------------------------------------------------
    // BLOCKER 6 + BLOCKER 2: CK90 edge-order monitor, MCK-grid structural
    // implementation (2026-11-28, replaces the behavioral `assign #2.8`
    // third sample and the negedge-CK second sample — neither is
    // synthesizable on the posedge-only sg13g2 library).
    //
    // Structure: MCK (300 MHz) is exactly 3x CK and CK rises are aligned
    // to MCK rising edges (DDR1_CLK_DE3 construction), so the CK period
    // spans exactly 3 MCK edges at +0, +3.33, +6.67 ns.  A 2-deep sample
    // shift of ck_a in the MCK domain detects the CK falling edge with
    // one-edge latency:
    //   cka_h == 2'b10 at an MCK edge  <=>  ck_a was HIGH at the previous
    //   edge and LOW at this one.  Since CK falls at +5.0 ns (between MCK
    //   edges), the first LOW sample is at +6.67 and the detection fires
    //   at the FOLLOWING edge = +10.0 ns = exactly the next CK rising
    //   edge ("det").  det therefore recurs once per CK period, perfectly
    //   aligned, with no counter and no knowledge of the DE3 phase.
    //   Per CK period the monitor then samples ck90_sel at two grid
    //   points where it is STATIC (transitions are >= 0.8 ns away):
    //     at det            (+0.0 ns): ck90 must be LOW  (correct rises at
    //                        +2.5; rejects 0-degree and 270-degree)
    //     at det delayed x2 (+6.67ns): ck90 must be HIGH (correct falls at
    //                        +7.5 worst case 50% duty; rejects the
    //                        180-degree inverse which is LOW here, and
    //                        270-degree which fell at +2.5)
    //   Margins: correct CK90 rise +2.5+-0.2 -> >= 2.3 ns clear of the
    //   +0 sample; fall at +7.5 (50% duty) / +7.0 (worst asymmetry, regen
    //   makes this structural) -> >= 0.8 ns clear of the +6.67 sample.
    //   Both samples are metastability-free by construction; the ck_a
    //   samples feeding det are metastability-exposed only at the
    //   coincident CK-rise edge, whose value does not affect the falling-
    //   edge detection pattern.
    //
    //   A failure in CK90_MON_N consecutive CK periods sets sticky
    //   ck90_mon_err (feeds ERR, drops PHY_LOCKED) — same semantics as
    //   before.  Counting is qualified by phy_lock_core (the monitor
    //   validates locked operation; acquisition correctness is the DLL's
    //   own lock/loss logic).  Everything is in the MCK domain;
    //   phy_lock_core is latch_q (MCK domain) ANDed with quasi-static
    //   levels, the same reference the original ck_a-domain monitor used.
    // ------------------------------------------------------------------
    reg [1:0] cka_h;
    reg [1:0] det_pipe;
    reg       mon_bad;
    reg [3:0] mon_fail;
    reg       ck90_mon_err;
    wire      det = (cka_h == 2'b10);

    always @(posedge MCK_IN or posedge RST) begin
        if (RST) begin
            cka_h        <= 2'b00;
            det_pipe     <= 2'b00;
            mon_bad      <= 1'b0;
            mon_fail     <= 4'd0;
            ck90_mon_err <= 1'b0;
        end else begin
            cka_h    <= {cka_h[0], ck_a};
            det_pipe <= {det_pipe[0], det};

            // once per CK period, at the det edge: evaluate the period
            if (det) begin
                if (phy_lock_core) begin
                    if (mon_bad || (ck90_sel !== 1'b0)) begin
                        if (mon_fail >= CK90_MON_N-1) ck90_mon_err <= 1'b1;
                        else                          mon_fail     <= mon_fail + 1'b1;
                    end else begin
                        mon_fail <= 4'd0;
                    end
                end else begin
                    mon_fail <= 4'd0;
                end
                mon_bad <= 1'b0;
            end else if (det_pipe[1] && (ck90_sel !== 1'b1)) begin
                // +6.67 ns sample of this CK period: must be HIGH
                mon_bad <= 1'b1;
            end
        end
    end

    wire ck90_ok = dll_locked_c & ~ck90_mon_err;

    // ------------------------------------------------------------------
    // BLOCKER 8(c): BYPASS is synchronized/committed only while RST is
    // asserted.  Changes outside reset are ignored, so the output mux is
    // only ever switched while both sides are quiet.
    // ------------------------------------------------------------------
    // Power-up state: the bypass commit must be DEFINED even when
    // EXT_SYS_CLK never toggles (the normal non-bypass board may not route
    // it) and before any reset edge.  Without these initialisers a static
    // EXT_SYS_CLK leaves the commit register X, and PHY_LOCKED (computed
    // from bypass_q) is then X instead of low — not fail-closed.  Found by
    // src/ddr1_duty_tb.v (2026-11-28).  The reset branch below still
    // commits the BYPASS strap on every reset edge.
    reg bp_meta = BYPASS, bp_sync = BYPASS, bypass_q = BYPASS;
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

    wire chain_ok      = PLL_LOCKED & ck90_ok & ~err_q;
    wire latch_next    = chain_ok && (dbc >= LOCK_DBC_CY-1);
    wire phy_lock_core = latch_q & PLL_LOCKED & ck90_ok & ~err_q;

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
            if (!bypass_q && dll_err_c)                  err_q <= 1'b1;
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
                if (!PLL_LOCKED || !ck90_ok)
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
    assign DBG = {PHY_LOCKED, ERR, bypass_q, 1'b1,
                  dll_locked_c, dll_err_c, 2'b00,
                  dll_code_c[7:0]};
endmodule
