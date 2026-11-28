// DDR1_CK90_DLL — DDR1 100 MHz CK90 generation, candidate B: master/slave
// ratio DLL (Phase B on-chip clock generation, pass 1 behavioral/RTL).
//
// NOTE (architecture decision): candidate B is the Phase-B architecture.
// DDR1_CLOCK_TOP therefore instantiates this DLL by default (USE_DLL90=1)
// and the upstream DCC is optional/off by default because B locks on the
// 50%-duty toggle-generated CK.
//
// Structure (the ratio argument is structural, not a fixed delay)
// ---------------------------------------------------------------------
// ONE code CODE controls FIVE identical DDR1_DLL_SEG quarter replicas:
//
//   CKIN --+-- [SEG]--[SEG]--[SEG][SEG] --+--> master_out --+
//          |   (4 cascaded = master line)  |                | phase
//          |                                            | detector
//          +-- [SEG] --------------------------------+   | (vs CKIN)
//                     (1 segment = slave line)      v   |
//                                              CK90 = CKIN + T/4
//
// Every segment is the same submodule with the same CODE input and
// therefore the same per-cell delay cell_ps = (CELL_X4_MIN + CODE*CELL_X4_STEP)/4.
//   master delay = 4 * NQ_SEG * cell_ps
//   slave  delay =     NQ_SEG * cell_ps   =  master / 4 exactly, by structure
// The loop adjusts CODE until master delay = one full CKIN period T
// (10 ns), so the slave line output is CKIN + T/4 = the 90-degree tap,
// PVT-tracked with CK by construction (same cells, same code, same bias).
//
// Code law
// --------
// Delay law (quarter-ps resolution, integer math):
//   cell_ps = (CELL_X4_MIN + CODE * CELL_X4_STEP) / 4
// With CELL_X4_MIN=96 (24 ps), CELL_X4_STEP=1 (0.25 ps) and NQ_SEG=64:
//   master delay = 4 * 64 * cell_ps = 64 * (96 + CODE) ps
//   T = 10000 ps  ->  lock target 96+CODE = 156.25 -> CODE = 60.25
// One CODE LSB moves the master line by 64 ps and the slave (CK90) by
// 16 ps.  Phase is measured at MASTER scale, so
//   phase_error_master = 4 * phase_error_CK90.
//
// REAL signed phase measurement (BLOCKER FIX, attempt 2)
// ------------------------------------------------------
// The old bang-bang PD produced only 1 bit, so the previous revision used a
// "8 same-direction steps" heuristic for loss and a hardcoded [40,80] code
// window.  Neither is a phase measurement: a legitimate supply-droop /
// thermal step of >=8 LSBs looked identical to a loss, and a valid corner
// needing a code outside the TT-derived window was a false loss.
//
// 2026-11-28 measurement rewrite (TDC-honest semantics):
//   * On every CKIN rising edge push the timestamp into a small FIFO.
//   * On every master_out rising edge pop the oldest timestamp and compute
//     the raw delay, then apply the semantics of the REAL detector —
//     a plain FINE_DELAY_CELL tapped-chain flash TDC
//     (docs/DDR1_TDC_DESIGN.md, option (d)):
//       1. RESIDUAL MODULO THE PERIOD: the chain captures only the
//          sub-cycle residual; integer-period offsets are invisible.
//          The measurement folds into (-T/2, +T/2]:
//              e_meas = modulo_fold(raw_delay - REF_PERIOD_PS)
//          A step that crosses a period boundary ALIASES, exactly as it
//          would in silicon.  In lock this never happens (residual ~ 0).
//          During acquisition from a far offset the sign can read wrong;
//          the bang-bang loop then walks the wrong way into the rail,
//          which the acquisition rail aid (RAIL_CONSEC) and the
//          acquisition watchdog (ACQ_TIMEOUT_CY) are designed to catch.
//          PASS-2 ELEMENT-SIZING CONSTRAINT: the initial segment delay at
//          CODE_INIT must place the first measured residual inside the
//          same half-period as lock, or acquisition is not guaranteed.
//       2. QUANTIZATION to TDC_STEP_PS round-to-nearest (+-0.5 tap):
//          measured sg13g2 FINE_DELAY_CELL taps are 65/100/45 ps
//          TT/SS/FF (flow/sta/run_ddr1_dqs_corners.sh).  Sweep
//          TDC_STEP_PS across those in verification.  Consequences:
//          LOCK_TOL_PS=192 is 3.0/1.9/4.3 taps and LOSS_TOL_PS=640 is
//          9.8/6.4/14.2 taps at TT/SS/FF respectively — at SS the
//          quantized loss trip lands at 600 ps master = 150 ps CK90
//          (inside the 200 ps spec, tighter than nominal, benign), at FF
//          at 675 ps = 169 ps CK90.
//   * The FIFO structure is retained ONLY as the simulation vehicle that
//     pairs the n-th CKIN edge with the n-th master edge; the absolute
//     delay it produces is folded/quantized before use.  A real
//     implementation has no FIFO and no $realtime — pass 2 replaces this
//     whole measurement block with the structural tapped chain
//     (TDC_IMPL=1, not yet implemented).
//   * The per-edge code latch in DDR1_DLL_SEG is unchanged (no in-flight
//     edge is re-timed).
//
// WHY THE DELAY CHAIN AND THE FIFO ARE RESET-FREE
// -----------------------------------------------
// Correct pairing requires that, at every instant, the FIFO holds exactly
// the CKIN edges whose master edge has not yet come out of the chain.
// Resetting either side breaks that invariant:
//
//   * Resetting the CHAIN is not merely unnecessary, it is harmful.  A
//     stage does `r <= #d nd[i]`; if RST asserts while such an assignment
//     is in flight, the reset's `r <= 0` is immediately overwritten by the
//     still-pending delayed assignment, so that stage sticks at the old
//     level.  The next real edge then produces NO transition there and is
//     silently swallowed -> the chain emits one fewer master edge than
//     CKIN edges, forever.  (Observed: u_m3.stage[51] stuck at 1, every
//     measurement off by exactly +T, code running to the rail.)
//     The chain is a pure delay line: it needs no reset at all, so it has
//     none.  r/ch carry declaration initialisers (=0 / =CODE_INIT).
//
//   * Freezing the FIFO (push and pop) during RST is also wrong, because
//     the chain keeps running: CKIN edges inside the reset window are
//     never pushed and master edges inside it are never popped, so on
//     release the first pop pairs with a timestamp from BEFORE the reset
//     and the measurement is inflated by the length of the reset window.
//
// So: chain free-runs, push free-runs, pop free-runs — once per genuine
// master_out rising edge, including while RST is held (measurements taken
// under RST are discarded) — and the loop state lives in a single always
// block sensitive to master_out AND posedge RST, so the pop is never
// suppressed and there is no multi-driver.  Because both counters advance
// at exactly one per CKIN period, the FIFO depth stays bounded; BUT the
// pairing is NOT exact across a reset boundary: the FIFO retains pre-reset
// timestamps and the first post-release delay spans the reset gap.  The
// stale_cnt epoch (first STALE_CY measurements after release) discards
// those before the loop resumes — see the loop-state comment below.
//
// Lock / loss semantics (phase based)
// -----------------------------------
//   phase_ps = signed (master_delay - T), master scale; |phase| = 4x CK90.
//
//   * DLL_LOCKED: |phase_ps| <= LOCK_TOL_PS for LOCK_N consecutive
//     measurements.  LOCK_TOL_PS=192 ps master = 48 ps CK90 = 3 CODE LSB
//     (absorbs the 1-LSB dither plus the loop's one-update latency).
//     LOCK_N=8.
//   * Loss-of-lock: after locked, |phase_ps| > LOSS_TOL_PS for LOSS_N
//     consecutive measurements -> clear DLL_LOCKED, set sticky DLL_ERR.
//     LOSS_TOL_PS = 640 ps master = 160 ps CK90: at/below the hard 200 ps
//     CK90 spec (x4 because the master line is 4x the slave), so a real
//     spec violation is flagged with margin.  LOSS_N = 3 (debounce for
//     measurement noise only): fail-closed — 3 samples ~ 30 ns, and the
//     loop can move at most 3 LSB = 192 ps master in that window, so it
//     can NEVER slew a beyond-spec excursion back into band before the
//     trip.  (The old 800/24 pair allowed a correctable 800+23*64 = 2272
//     ps master = 568 ps CK90 step — 2.8x the hard spec — to ride with
//     PHY_LOCKED high for 240 ns, the opposite of fail-closed.)  A
//     correctable in-spec step stays inside LOCK_TOL..LOSS_TOL each
//     update, so check14's 512 ps master (128 ps CK90) droop still never
//     trips.
//   * Between LOCK_TOL and LOSS_TOL the lock is HELD (hysteresis) so the
//     loop can slew back without a spurious loss.  Only the measured phase
//     clears lock; code window and direction-run play no part.
//   * Rail detector (RAIL_CONSEC) is an ACQUISITION AID only: if the code
//     sits saturated at 0 or max for RAIL_CONSEC consecutive updates while
//     not yet locked, the target is unreachable -> DLL_ERR.  Post-lock the
//     phase loss rule already covers a pinned line; the rail aid is
//     ignored once locked.
//   * Acquisition watchdog ACQ_TIMEOUT_CY: if DLL_LOCKED is still low that
//     many sampling updates after reset release (regardless of rail), set
//     DLL_ERR.
//   * DLL_ERR is sticky until RST.  DDR1_CLOCK_TOP parks the DLL in reset
//     while PLL_LOCKED=0, so a PLL relock restarts acquisition.
//
// The old [CODE_LOCK_MIN,CODE_LOCK_MAX] window and the same-direction
// run-length loss rule are REMOVED from the lock/loss path.  run_len
// remains only as a debug/diagnostic counter (it never clears lock or sets
// ERR).  A legitimate corner that needs a code outside the old window
// keeps lock as long as the measured phase is in spec.
//
// TEST SCAFFOLDING (pass-2 removal): `dly_off_x4` is a DLL-internal
// unsigned reg (not a port, constant 0 in synthesis) added to every
// segment's delay law.  A testbench can force it to emulate a cell-delay
// PVT step/droop/drift without changing the CKIN waveform.  It is
// deliberately NOT in the port list so the top-level interface is
// unchanged; pass 2 deletes it and relies on real bias/PVT.
// NOTE: `release` of a FORCED REG keeps the forced value (there is no RTL
// procedural driver to restore it, unlike a net).  A testbench that forces
// dly_off_x4 must assign it back to 0 after release, or the next test
// inherits the stale offset.
//
// Pass 1 caveats (behavioral):
//   * DDR1_DLL_SEG models a bias-controlled fine-cell chain with transport
//     delay per stage; the structural 4:1 ratio (5 identical segments,
//     shared code) is real.  The per-cell law must be re-derived from real
//     IHP130 fine-cell characterization in pass 2.
//   * The behavioural timestamp FIFO must be replaced by the coarse-cycle-
//     counter + dll_tdc_phys hardware described above.
//   * REF_PERIOD_PS is the 10 ns production period; other periods need
//     recalibration (the comparison target is REF_PERIOD_PS).
//   * Loop state is written from ONE always block (sensitive to
//     master_out and posedge RST); there is no second driver.  On a bare
//     posedge RST with no master edge the pop does not fire (the rise flag
//     is false), so a coincident reset/master-edge never double-pops.
`timescale 1ns/1ps

// One quarter-replica delay segment (BEHAVIORAL MODEL, IMPL-equivalent of
// the structural DDR1_DLL_SEG_PHYS = 2x dll8_line4).
//
// Delay law: total = NQ_SEG * (CELL_X4_MIN + CODE*CELL_X4_STEP) / 4 ps.
// It is applied as ONE transport delay, not as NQ_SEG chained #-delays:
// at the 1 ps timescale a per-stage delay of 0.25 ps/LSB cannot be
// represented, so the chained form quantized to a 64 ps staircase every
// 4 codes (measured 2026-11-28) — 4x coarser than the law and a direct
// cause of a 128 ps CK90 limit cycle.  The aggregate form has exactly
// NQ_SEG*CELL_X4_STEP/4 = 16 ps per code at the defaults.
//
// Quiet code update: the segment LATCHES the code when an edge enters and
// applies the latched value to that edge (ch <= CODE takes effect for the
// NEXT edge), so a code update never re-times an edge in flight.
//
// NO RESET: see the header.  Resetting while a `<= #d` assignment is in
// flight overwrites it and leaves the segment at the wrong level,
// swallowing the next edge.  The chain is a pure delay line and is
// reset-free by design.
module DDR1_DLL_SEG #(
    parameter integer NQ_SEG       = 64,
    parameter integer CODE_BITS    = 9,
    parameter integer CELL_X4_MIN  = 96,  // ps*4 per cell at CODE=0 (24 ps)
    parameter integer CELL_X4_STEP = 1,   // ps*4 per cell per CODE LSB (0.25 ps)
    parameter integer CODE_INIT    = 40
) (
    input  wire                  IN,
    input  wire [CODE_BITS-1:0]  CODE,
    input  wire [31:0]           DLY_OFF_X4,  // test scaffolding (ps*4/cell)
    output wire                  OUT
);
    // Delay law, evaluated at execution time in each stage (identical in
    // every segment instance -> identical delay per CODE).  Note: do NOT
    // precompute this into an integer with always @(*); iverilog misses
    // the t=0 declaration-initializer event and leaves it X.
    // BEHAVIORAL MODEL: ONE transport delay for the whole segment with the
    // AGGREGATE delay law  NQ_SEG * (CELL_X4_MIN + CODE*CELL_X4_STEP)/4 ps.
    //
    // Why not NQ_SEG chained #-delays (as before 2026-11-28): each stage's
    // delay is rounded to the 1 ps timescale, so the documented 0.25 ps/LSB
    // per stage never existed -- the chain quantized to ~1 ps per stage =
    // 64 ps per segment per 4 codes, a staircase 4x coarser than intended.
    // That staircase inflated the post-lock limit cycle to 128 ps at CK90
    // (measured by src/ddr1_jitter_tb.v) and made the model disagree with
    // the measured silicon step (28-39 ps/segment/code).  With the
    // aggregate law the per-code step is exactly NQ_SEG*CELL_X4_STEP/4 ps
    // = 16 ps at the defaults, i.e. the intended law and the closest
    // whole-ps approximation of the measured element.
    //
    // The per-edge code commit is unchanged and still structural in
    // spirit: `ch` captures CODE when an edge enters, so a code update
    // never re-times an edge already in flight.
    reg r = 1'b0;
    reg [CODE_BITS-1:0] ch = CODE_INIT[CODE_BITS-1:0];   // next-edge code
    always @(IN) begin
        r  <= #((NQ_SEG * (CELL_X4_MIN + (ch * CELL_X4_STEP)) + NQ_SEG*DLY_OFF_X4)/4000.0)
              IN;
        ch <= CODE;
    end
    assign OUT = r;
endmodule

module DDR1_CK90_DLL #(
    parameter integer NQ_SEG            = 64,
    parameter integer CODE_BITS         = 9,
    parameter integer CELL_X4_MIN       = 96,   // ps*4/cell at CODE=0 (24 ps)
    parameter integer CELL_X4_STEP      = 1,    // ps*4/cell per CODE LSB
    parameter integer CODE_INIT         = 40,
    parameter integer REF_PERIOD_PS     = 10000,// comparison target (CKIN period)
    parameter integer QDEPTH            = 16,   // timestamp FIFO depth (> max delay/T)
    parameter integer LOCK_TOL_PS       = 192,  // |master phase| lock band
    // BLOCKER 3: LOSS_TOL is AT/BELOW the hard spec (640 ps master = 160 ps
    // CK90 < the 200 ps hard spec) and LOSS_N is a 3-sample noise debounce
    // only.  The old 800 ps / N=24 combination let a correctable step up to
    // 800 + 23*64 = 2272 ps master (568 ps CK90 = 2.8x the hard spec) slew
    // back with PHY_LOCKED high for up to 240 ns -- the opposite of
    // fail-closed.  Any excursion beyond the band now drops lock in 3
    // measurements (~30 ns): the loop moves at most 3 LSBs = 192 ps master
    // in that window, so it cannot pull the phase back into band first.
    parameter integer LOSS_TOL_PS       = 640,  // |master phase| loss (160 ps CK90 x4)
    parameter integer LOCK_N            = 8,    // consecutive in-band samples
    parameter integer LOSS_N            = 3,    // out-of-band debounce (noise only)
    parameter integer STALE_CY          = 4,    // discard first N measurements
                                               // after reset release (epoch)
    parameter integer ACQ_TIMEOUT_CY    = 8192, // acquisition watchdog (samples)
    parameter integer RAIL_CONSEC       = 32,   // acquisition-only rail aid
    // TDC measurement model (2026-11-28 rewrite): the behavioral FIFO no
    // longer measures the absolute delay.  A real tapped-chain flash TDC
    // (docs/DDR1_TDC_DESIGN.md) measures the phase residual MODULO the
    // CKIN period, quantized to the tap step.  TDC_STEP_PS is the tap
    // resolution: measured sg13g2 FINE_DELAY_CELL taps are 65/100/45 ps
    // TT/SS/FF (flow/sta/run_ddr1_dqs_corners.sh); sweep this parameter
    // in verification.  Quantization is round-to-nearest (+-0.5 tap).
    parameter integer TDC_STEP_PS       = 65,   // tap quantization (TT cell)
    parameter integer TDC_IMPL          = 0,    // 0 = behavioral quantized
                                                // model; 1 = structural
                                                // (pass 2, with elements)
    // Pass-2 structural insertion (2026-11-28, docs/DDR1_DLL_ELEMENT_SIZING.md):
    //   SEG_IMPL=1 replaces the five behavioral segments with structural
    //   ones (2x dll8_line4 hard-macro strips each, N=8 elements/segment)
    //   driven by a shared thermometer strap decoder.  The structural
    //   segments are elaboration/synthesis/SPICE evidence — no behavioral
    //   model exists for the strips, so RTL regression stays on
    //   SEG_IMPL=0 (the behavioral law is intentionally NOT the silicon
    //   law; what must match is the loop/lock/loss semantics, verified in
    //   ddr1_ck90_dll_tdc_tb.v).
    //   REGEN=1 inserts the matched SR phase regeneration at the master
    //   measurement point and the CK90 output: Q rises at the chain edge,
    //   falls T/2 later at the opposite master-chain tap, so output duty
    //   is structurally T/2 independent of chain tpHL/tpLH asymmetry.
    //   The TDC then measures the REGENERATED master (m_loop): the loop
    //   servos the latch set-path delay down to a residual systematic
    //   (3/4)*D_set at CK90.  REGEN_IMPL selects behavioral (0) vs
    //   structural (1) latch cells; behavioral adds zero delay (logic-
    //   correct connectivity verification), silicon adds D_set.
    parameter integer SEG_IMPL          = 0,
    parameter integer REGEN             = 0,
    parameter integer REGEN_IMPL        = 0,
    // Systematic-phase calibration (P1 item of ddr-phy
    // ADPLL_DDR1_SECOND_CHECK.md §2.2: "matched replica gate OR calibrate in
    // the lock target").  MASTER-scale ps added to the residual target:
    // the loop drives (master_delay - T + TRIM) to 0, so a POSITIVE value
    // ADVANCES CK90 (shortens the locked segment delay by TRIM/4).
    //
    // NOTE on semantics: TRIM is added to the MEASURED residual, so every
    // downstream consumer sees the TRIMMED value — `phase_ps`/DBG and the
    // LOCK_TOL / LOSS_TOL / HOLD_PS comparisons are all relative to the
    // trimmed zero.  The loop therefore settles at a TRUE residual of
    // -TRIM (master deliberately early), which is what cancels the late
    // CK90 systematic.  A wrong trim strap does not trip loss (the loop
    // re-targets); it silently shifts CK90 by (TRIM_wrong - TRIM_true)/4,
    // so the strap must be set at test/init from the corner.
    //
    // Value to null the real-cell systematic, from SPICE/STA:
    //   REGEN=0:  TRIM = 4 * D_and                    (EN gate on CK90 only)
    //   REGEN=1:  TRIM = 3 * D_set + 4 * D_and        (regenerated master
    //             measured -> (3/4)D_set leaks to CK90, plus the EN gate)
    // Default 0 = no calibration, the behavioral/corner-neutral setting.
    // ddr1_ck90_dll_tdc_tb.v check20 verifies the sign and magnitude.
    parameter integer TRIM_MASTER_PS    = 0,
    // Dead-zone half-width, MASTER-scale ps.  The loop holds the code when
    // |measured residual| <= HOLD_PS.  It must be >= BOTH:
    //   * the master step  NQ_SEG*CELL_X4_STEP = 64 ps at the defaults --
    //     otherwise an unlucky phase offset leaves no reachable code inside
    //     the band (2-cycle limit cycle, observed at 45/100 ps taps);
    //   * the measurement quantization TDC_STEP_PS -- otherwise a reading
    //     one tap away (which may be a tenth of a tap in reality) keeps
    //     stepping the code: observed as a 5-6 code wander (80 ps at CK90)
    //     with a 65 ps tap against a 64 ps band.
    // Default = max(step, tap).  The converged residual is then bounded by
    // HOLD_PS master = <=25 ps CK90 (SS), inside the +-100 ps target, and
    // the code is STATIONARY in steady state (zero dither contribution to
    // period/c2c jitter).
    parameter integer STEP_MASTER_PS    = NQ_SEG * CELL_X4_STEP,
    parameter integer HOLD_PS           = (TDC_STEP_PS > STEP_MASTER_PS)
                                          ? TDC_STEP_PS : STEP_MASTER_PS,
    // Runtime trim select.  With TRIM_EXT_EN=0 the compile-time
    // TRIM_MASTER_PS is used and the TRIM_EXT port is ignored (existing
    // instantiations keep their behavior even with the port unconnected:
    // a mux with select 0 does not propagate X from the unselected input).
    // With TRIM_EXT_EN=1 the clock top drives the corner-selected strap
    // value (docs/DDR1_HANDOFF.md §7: TRIM 1472/1018/791 SS/TT/FF).
    parameter integer TRIM_EXT_EN       = 0
) (
    input  wire                  CKIN,   // 100 MHz CK (the master locks ON it)
    input  wire                  RST,    // async reset, active high (state only)
    input  wire                  EN,     // quiet gate: 0 -> CK90 low
    input  wire signed [15:0]    TRIM_EXT, // runtime trim (see TRIM_EXT_EN)
    output wire                  CK90,   // CKIN delayed by the slave replica
    output wire                  DLL_LOCKED,
    output wire                  DLL_ERR,  // rail/acq-timeout/loss (sticky)
    output wire [CODE_BITS-1:0]  DBG_CODE
);
    // ------------------------------------------------------------------
    // Five identical quarter replicas: 4 master + 1 slave, same CODE.
    // No RST connection: the delay chain is reset-free (see header).
    // ------------------------------------------------------------------
    wire s1, s2, s3, s4, slave_out;
    wire master_out;
    wire [CODE_BITS-1:0] CODE;

    // Test scaffolding: constant 0 unless a TB forces it.  Shared by all
    // five replicas so it emulates a PVT cell-delay shift (see header).
    reg [31:0] dly_off_x4 = 32'd0;

    generate
        if (SEG_IMPL == 0) begin : seg_beh
            DDR1_DLL_SEG #(.NQ_SEG(NQ_SEG), .CODE_BITS(CODE_BITS),
                           .CELL_X4_MIN(CELL_X4_MIN), .CELL_X4_STEP(CELL_X4_STEP),
                           .CODE_INIT(CODE_INIT)) u_m1 (
                .IN(CKIN), .CODE(CODE), .DLY_OFF_X4(dly_off_x4), .OUT(s1));
            DDR1_DLL_SEG #(.NQ_SEG(NQ_SEG), .CODE_BITS(CODE_BITS),
                           .CELL_X4_MIN(CELL_X4_MIN), .CELL_X4_STEP(CELL_X4_STEP),
                           .CODE_INIT(CODE_INIT)) u_m2 (
                .IN(s1), .CODE(CODE), .DLY_OFF_X4(dly_off_x4), .OUT(s2));
            DDR1_DLL_SEG #(.NQ_SEG(NQ_SEG), .CODE_BITS(CODE_BITS),
                           .CELL_X4_MIN(CELL_X4_MIN), .CELL_X4_STEP(CELL_X4_STEP),
                           .CODE_INIT(CODE_INIT)) u_m3 (
                .IN(s2), .CODE(CODE), .DLY_OFF_X4(dly_off_x4), .OUT(s3));
            DDR1_DLL_SEG #(.NQ_SEG(NQ_SEG), .CODE_BITS(CODE_BITS),
                           .CELL_X4_MIN(CELL_X4_MIN), .CELL_X4_STEP(CELL_X4_STEP),
                           .CODE_INIT(CODE_INIT)) u_m4 (
                .IN(s3), .CODE(CODE), .DLY_OFF_X4(dly_off_x4), .OUT(master_out));
            DDR1_DLL_SEG #(.NQ_SEG(NQ_SEG), .CODE_BITS(CODE_BITS),
                           .CELL_X4_MIN(CELL_X4_MIN), .CELL_X4_STEP(CELL_X4_STEP),
                           .CODE_INIT(CODE_INIT)) u_sl (
                .IN(CKIN), .CODE(CODE), .DLY_OFF_X4(dly_off_x4), .OUT(slave_out));
        end else begin : seg_phys
            // Structural: 2x dll8_line4 strips per segment (N=8 elements),
            // one shared thermometer strap decoder broadcast everywhere.
            // CODE is 9 bits behaviorally; the structural bank is 7 bits —
            // the pass-2 loop parameter set uses CODE_BITS=7 end to end.
            wire [126:0] strap;
            DDR1_DLL_THERM_STRAP u_therm (.CODE(CODE[6:0]), .STRAP(strap));
            (* keep *) DDR1_DLL_SEG_PHYS u_m1 (.IN(CKIN), .STRAP(strap), .OUT(s1));
            (* keep *) DDR1_DLL_SEG_PHYS u_m2 (.IN(s1),   .STRAP(strap), .OUT(s2));
            (* keep *) DDR1_DLL_SEG_PHYS u_m3 (.IN(s2),   .STRAP(strap), .OUT(s3));
            (* keep *) DDR1_DLL_SEG_PHYS u_m4 (.IN(s3),   .STRAP(strap), .OUT(master_out));
            (* keep *) DDR1_DLL_SEG_PHYS u_sl (.IN(CKIN), .STRAP(strap), .OUT(slave_out));
        end
    endgenerate

    // ------------------------------------------------------------------
    // Matched SR phase regeneration (REGEN=1).
    //   master measurement copy: SET = master_out rise, RESET = s2 rise
    //     (s2 is the same waveform T/2 earlier -> high time exactly T/2).
    //   CK90 output:             SET = slave_out rise, RESET = s3 rise
    //     (s3 = master + 3T/4; slave = CKIN + T/4 -> spacing exactly T/2).
    //   m_loop is the measurement/loop clock: the TDC and the loop always
    //   block key on the REGENERATED master when REGEN=1, so the latch
    //   set-path delay is servoed out down to the (3/4)*D_set systematic.
    // ------------------------------------------------------------------
    wire q_master, q_ck90;
    generate
        if (REGEN != 0) begin : rg
            DDR1_CLK_REGEN #(.IMPL(REGEN_IMPL)) u_rg_master (
                .SET_IN(master_out), .RESET_IN(s2), .Q(q_master));
            DDR1_CLK_REGEN #(.IMPL(REGEN_IMPL)) u_rg_ck90 (
                .SET_IN(slave_out),  .RESET_IN(s3), .Q(q_ck90));
        end else begin : rg_none
            assign q_master = master_out;
            assign q_ck90   = slave_out;
        end
    endgenerate
    wire m_loop   = q_master;
    wire ck90_int = q_ck90;

    // ------------------------------------------------------------------
    // Structural signed flash TDC (TDC_IMPL=1): src/ddr1_dll_tdc.v.
    // The measurement chain is started by CKIN and captured by master_d;
    // E_MEAS/MEAS_VLD update one MASTER period after the capture edge —
    // the loop therefore consumes residuals with one extra period of
    // latency vs. the behavioral emulation, the physically irreducible
    // cost of the real detector.  Verified in ddr1_ck90_dll_tdc_tb2.v.
    // ------------------------------------------------------------------
    wire signed [15:0] tdc_e;
    wire               tdc_vld;
    DDR1_DLL_TDC #(
        .NTAP(32), .TDC_STEP_PS(TDC_STEP_PS), .IMPL(0)
    ) u_tdc (
        .CKIN(CKIN), .MASTER(m_loop), .RST(RST),
        .E_MEAS(tdc_e), .MEAS_VLD(tdc_vld));

    // ------------------------------------------------------------------
    // Behavioural absolute time-difference measurement.
    //   PUSH: free-running, one timestamp per CKIN rising edge.
    //   POP : free-running, one pairing per master_out rising edge.
    //   master_delay = now - paired CKIN time (absolute, never modulo T).
    //   Real-cell equivalent: coarse CKIN-cycle counter + delay-line TDC.
    // Both sides advance at exactly one entry per CKIN period, so the FIFO
    // occupancy is constant and pairing is exact across resets.
    // ------------------------------------------------------------------
    integer e_meas;
    reg     meas_vld;

`ifndef SYNTHESIS
    // ------------------------------------------------------------------
    // SIMULATION-ONLY behavioral measurement vehicle ($realtime FIFO).
    // Yosys cannot parse `real`/`$realtime`, so the whole block is excluded
    // from synthesis: silicon has no FIFO and no timestamps — the phase
    // detector IS the structural TDC (TDC_IMPL=1), and the synthesized
    // netlist therefore uses the TDC branch exclusively (see the loop
    // block's `ifdef SYNTHESIS`).  Keeping the behavioral path compiled
    // out of synthesis also removes the last non-synthesizable construct
    // this file had.
    // ------------------------------------------------------------------
    real    t_ck_q [0:QDEPTH-1];
    integer q_head = 0, q_tail = 0;   // head/tail; head!=tail => FIFO non-empty
    real    dly_ns;
    integer dly_ps;

    always @(posedge CKIN) begin
        t_ck_q[q_head] = $realtime;
        if (q_head == QDEPTH-1) q_head = 0;
        else                    q_head = q_head + 1;
    end
`endif

    // ------------------------------------------------------------------
    // Loop state — SINGLE driver (BLOCKER 1 fix).
    //   Previously block A (posedge master_out) and block B (posedge RST)
    //   BOTH assigned code_q/locked_q/err_q/counters/phase_ps: a multi-
    //   driver construction that synthesis rejects and that races in
    //   simulation when posedge RST coincides with posedge master_out
    //   (the TB drives RST asynchronously, so coincidence happens).
    //   Both triggers now live in ONE always block:
    //     always @(master_out or posedge RST)
    //     rise = genuine master_out rising edge this activation
    //     if (RST)                 <loop-state defaults + pop if rise>
    //     else if (stale)           <discard, decrement stale_cnt>
    //     else if (meas_vld)        <pop already done, run loop>
    //   The rise flag (prev_m sample) makes a bare posedge RST a no-op for
    //   the FIFO: a reset coincident with a master edge pops exactly once,
    //   a reset alone pops never.
    //
    // FIFO pop during RST: YES, the pop still advances (the FIFO is
    // touched in the RST branch too) so head/tail pairing survives a reset
    // of any length; measurements taken while RST is asserted are simply
    // discarded (stale epoch, see stale_cnt below).
    //
    // Stale/epoch mechanism: the FIFO retains timestamps written BEFORE the
    // reset, and the first pop after release pairs a post-release master
    // edge with a pre-reset timestamp, inflating the delay by (reset gap
    // + chain latency).  Pairing is therefore NOT exact across resets, and
    // the previous header claim that it was is wrong (fixed).  Mechanism:
    //   * On posedge RST: stale_cnt <= STALE_CY  (re-armed on every reset).
    //   * On each pop with !RST: if stale_cnt != 0 the measurement is
    //     discarded (stale_cnt decrements, loop does not run); when it
    //     reaches 0 the measurement stream is trusted again.
    //   STALE_CY=4 > 2 (max FIFO occupancy = chain latency in periods), so
    //   every timestamp written before/during the reset has been popped and
    //   dropped before the loop resumes.  Real-cell equivalent: a flush
    //   counter that discards the first N TDC samples after a calibration
    //   restart.
    // ------------------------------------------------------------------
    reg [CODE_BITS-1:0]   code_q   = CODE_INIT[CODE_BITS-1:0];
    reg                   locked_q = 1'b0;
    reg                   err_q    = 1'b0;  // sticky error (cleared by RST)
    reg [31:0]            acq_cnt  = 32'd0; // acquisition watchdog counter
    reg [7:0]             lock_cnt = 8'd0;  // consecutive in-band samples
    reg [7:0]             loss_cnt = 8'd0;  // consecutive out-of-band samples
    reg [15:0]            rail_cnt = 16'd0; // acquisition-only rail saturation
    reg [7:0]             stale_cnt = 8'd0; // epoch: measurements to discard
    reg [5:0]             run_len  = 6'd0;  // DEBUG ONLY (not used for lock/loss)
    reg [1:0]             last_dir = 2'b00; // DEBUG ONLY
    integer               phase_ps = 0;     // last measured signed master error
    integer               e;                // working copy of the measurement

    // Effective calibration: compile-time value unless the runtime strap is
    // enabled.  A mux (not arithmetic) keeps an unconnected TRIM_EXT from
    // poisoning the value when TRIM_EXT_EN=0.
    wire signed [15:0] trim_eff = TRIM_EXT_EN ? TRIM_EXT
                                             : TRIM_MASTER_PS[15:0];

    assign CODE = code_q;

    wire code_max = {CODE_BITS{1'b1}};
    wire code_min = {CODE_BITS{1'b0}};

    // ---- SINGLE driver (BLOCKER 1): pop + loop + async clear in ONE block.
    // Triggers are level-sensitive on master_out plus posedge RST, so both
    // events live in one process (no multi-driver, no RST/master-edge race:
    // if they coincide the block runs once and both effects apply).
    //
    // Pop discipline (documented choice): the FIFO pop advances once per
    // GENUINE master_out rising edge, INCLUDING while RST is held high and
    // including a rise that coincides with posedge RST -- so pairing keeps
    // up with the free-running chain and survives a reset of any length.
    // A bare posedge RST with no master edge does NOT pop (prev_m would
    // make `rise` false), so the FIFO is never advanced spuriously.
    // Measurements taken while RST is asserted are discarded; the stale
    // epoch below discards the first STALE_CY after release as well.
    reg prev_m = 1'b0;      // last observed master_out level
    reg rise;               // genuine master_out rising edge this activation
`ifdef SYNTHESIS
    // Synthesis: edge-triggered sensitivity (level-sensitive event lists are
    // not synthesizable).  Every entry from a posedged m_loop IS a genuine
    // rising edge, so `rise` is unconditional; the FIFO pairing/epoch logic
    // does not exist in silicon (the TDC branch below is the detector).
    always @(posedge m_loop or posedge RST) begin
        rise = 1'b1;
`else
    always @(m_loop or posedge RST) begin
        // Simulation: level-sensitive so a bare posedge RST is a no-op for
        // the FIFO.  Detect a real rising edge regardless of trigger
        // order/merging: a bare posedge RST re-enters with m_loop unchanged
        // -> rise = 0.
        rise   = (m_loop === 1'b1) && (prev_m !== 1'b1);
        prev_m = m_loop;
`endif

        // POP (exactly once per genuine rise, even during RST)
        meas_vld = 1'b0;
`ifdef SYNTHESIS
        // Silicon: the phase detector is the structural TDC.  No FIFO, no
        // timestamps, no behavioral folding; E_MEAS already carries the
        // signed quantized residual in master-scale ps.
        e_meas   = tdc_e + trim_eff;
        meas_vld = rise & tdc_vld;
`else
        if (rise && (q_head != q_tail)) begin
            dly_ns = $realtime - t_ck_q[q_tail];
            if (q_tail == QDEPTH-1) q_tail = 0;
            else                    q_tail = q_tail + 1;
            dly_ps  = $rtoi(dly_ns * 1000.0 + 0.5);
            // TDC-honest measurement (2026-11-28):
            //   1. residual MODULO the period: a tapped-chain flash TDC
            //      cannot resolve integer-period offsets; the residual is
            //      folded into (-T/2, +T/2].  CONSEQUENCE: at extreme
            //      initial offsets (delay > T + T/2) the sign can read
            //      wrong and the bang-bang loop walks the wrong way --
            //      pinned at the rail, caught by the acquisition rail aid
            //      / watchdog.  Element sizing must place the initial
            //      delay within +-T/2 of lock (pass-2 constraint).
            //   2. quantization to TDC_STEP_PS, round-to-nearest.
            e_meas  = dly_ps - REF_PERIOD_PS;
            // fold into (-T/2, +T/2]
            while (e_meas >  REF_PERIOD_PS/2) e_meas = e_meas - REF_PERIOD_PS;
            while (e_meas <= -REF_PERIOD_PS/2) e_meas = e_meas + REF_PERIOD_PS;
            // quantize (round to nearest tap, ties away from zero)
            e_meas = e_meas + trim_eff;
            if (e_meas >= 0)
                e_meas = ((e_meas + TDC_STEP_PS/2) / TDC_STEP_PS) * TDC_STEP_PS;
            else
                e_meas = -(((-e_meas) + TDC_STEP_PS/2) / TDC_STEP_PS) * TDC_STEP_PS;
            meas_vld = 1'b1;
        end

        // TDC_IMPL=1: replace the behavioral arithmetic with the structural
        // TDC output.  At this master edge the TDC's own nonblocking update
        // has not landed yet, so tdc_e is the residual measured from the
        // PREVIOUS master edge — one extra period of loop latency, exactly
        // what silicon will have.
        if (TDC_IMPL != 0) begin
            e_meas   = tdc_e + trim_eff;
            meas_vld = rise & tdc_vld;
        end
`endif

        if (RST) begin
            // async clear of loop state (never the FIFO head/tail)
`ifdef SYNTHESIS
            // (no FIFO in silicon; the measurement nets are constant under
            //  reset so the async branch has defined values)
            e_meas   <= 0;
            meas_vld <= 1'b0;
`endif
            code_q    <= CODE_INIT[CODE_BITS-1:0];
            locked_q  <= 1'b0;
            err_q     <= 1'b0;
            acq_cnt   <= 32'h0000_0000;
            lock_cnt  <= 8'd0;
            loss_cnt  <= 8'd0;
            rail_cnt  <= 16'd0;
            stale_cnt <= STALE_CY[7:0];  // arm the epoch flush on every reset
            run_len   <= 6'd0;
            last_dir  <= 2'b00;
            phase_ps  <= 0;
            // meas_vld (if any) is intentionally discarded here.
        end else if (meas_vld && (stale_cnt != 8'd0)) begin
            // epoch flush: the first STALE_CY measurements after reset
            // release may pair across the release boundary -> discard.
            stale_cnt <= stale_cnt - 1'b1;
        end else if (meas_vld) begin
                e = e_meas;
                phase_ps <= e;

                if (!err_q) begin
                    acq_cnt <= acq_cnt + 1'b1;

                    // ---- one-LSB bang-bang step driven by the measured sign ----
                    // e > 0 : master late (delay > T)  -> decrease code
                    // e < 0 : master early             -> increase code
                    // e == 0: within half a TDC tap   -> HOLD (dead zone)
                    //
                    // The dead zone is not cosmetic: without it the loop
                    // steps every measurement even when the residual is
                    // inside the quantization cell, producing a limit cycle
                    // of +-1-2 LSB whose period jitter landed at 128 ps
                    // pk-pk at CK90 (src/ddr1_jitter_tb.v, 2026-11-28) --
                    // over the 100 ps spec.  Holding at quantized zero
                    // freezes the code in steady state (jitter contribution
                    // -> 0) while TRACKING IS PRESERVED: any drift that
                    // moves the residual out of the cell re-engages the
                    // loop on the very next measurement.  Standard DLL
                    // dead-zone practice; the loss detector is unchanged
                    // and still trips on |e| > LOSS_TOL for LOSS_N samples.
                    if (e > HOLD_PS) begin
                        if (code_q != code_min) code_q <= code_q - 1'b1;
                        if (code_q == code_min) rail_cnt <= rail_cnt + 1'b1;
                        else                    rail_cnt <= 16'd0;
                        last_dir <= 2'b10;
                    end else if (e < -HOLD_PS) begin
                        if (code_q != code_max) code_q <= code_q + 1'b1;
                        if (code_q == code_max) rail_cnt <= rail_cnt + 1'b1;
                        else                    rail_cnt <= 16'd0;
                        last_dir <= 2'b01;
                    end else begin
                        // inside one step of zero: hold (dead zone)
                        rail_cnt <= 16'd0;
                        last_dir <= 2'b00;
                    end
                    // DEBUG ONLY: consecutive same-direction count.
                    if (last_dir == ((e > 0) ? 2'b10 : 2'b01))
                        run_len <= run_len + 1'b1;
                    else
                        run_len <= 6'd1;

                    // ---- lock qualification: measured phase, not balance ----
                    if ((e <= LOCK_TOL_PS) && (e >= -LOCK_TOL_PS)) begin
                        if (lock_cnt != 8'hff) lock_cnt <= lock_cnt + 1'b1;
                    end else begin
                        lock_cnt <= 8'd0;
                    end

                    if (!locked_q) begin
                        // acquire: N consecutive in-band measurements
                        if (lock_cnt >= LOCK_N-1)
                            locked_q <= 1'b1;
                        // acquisition watchdog (independent of rail state)
                        if (acq_cnt >= ACQ_TIMEOUT_CY[31:0])
                            err_q <= 1'b1;
                        // acquisition-only rail aid
                        if (rail_cnt >= RAIL_CONSEC-1)
                            err_q <= 1'b1;
                    end else begin
                        // loss: LOSS_N consecutive measurements beyond
                        // LOSS_TOL (fail-closed: 3 samples ~ 30 ns, the
                        // loop can move at most 3 LSB = 192 ps master in
                        // that window so it cannot slew back into band
                        // first).  Between LOCK_TOL and LOSS_TOL the lock
                        // is HELD (hysteresis) so correctable steps finish.
                        if ((e > LOSS_TOL_PS) || (e < -LOSS_TOL_PS)) begin
                            if (loss_cnt >= LOSS_N-1) begin
                                locked_q <= 1'b0;
                                err_q    <= 1'b1;
                            end else begin
                                loss_cnt <= loss_cnt + 1'b1;
                            end
                        end else begin
                            loss_cnt <= 8'd0;
                        end
                    end
                end
            end
        end

    assign DLL_LOCKED = locked_q & ~err_q;
    assign DLL_ERR    = err_q;
    assign CK90       = EN & ck90_int;
    assign DBG_CODE   = code_q;
endmodule
