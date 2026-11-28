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
// This revision measures the signed residual directly:
//   * On every CKIN rising edge push the timestamp into a small FIFO.
//   * On every master_out rising edge pop the oldest timestamp and compute
//         master_delay = now - paired_CKIN_timestamp
//         phase_ps     = master_delay - REF_PERIOD_PS
//     The FIFO pairs the n-th CKIN edge with the n-th master edge, so the
//     delay is ABSOLUTE (not modulo the period) and a large step cannot
//     alias onto 2T/3T.  1 ps resolution under `timescale 1ns/1ps`.
//   * This is the "fine-resolution time-difference sampler built into the
//     behavioural model" option.  A real implementation cannot free-run
//     $realtime: its equivalent is a coarse CKIN-cycle counter (to resolve
//     which period the edge belongs to) plus a delay-line TDC
//     (dll_tdc_phys-style tapped line + thermometer encoder + sync) for the
//     sub-cycle residual.  Pass 2 must instantiate that hardware; the
//     measurement update rate is one master edge per CKIN period.
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

// One quarter-replica delay segment: NQ_SEG identical fine cells in
// series, all enabled, per-cell delay set by the shared CODE.
//
// Quiet code update: each stage LATCHES the code as an edge passes
// through it and applies the latched value to the NEXT edge, so a code
// update never re-times an edge in flight (the standard DLL practice).
//
// NO RESET: see the header.  Resetting a stage while a `<= #d` assignment
// is in flight leaves that stage stuck and swallows the next edge.  The
// chain is a pure delay line and is reset-free by design.
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
    wire [NQ_SEG:0] nd;
    assign nd[0]   = IN;
    assign OUT     = nd[NQ_SEG];

    genvar i;
    generate
        for (i = 0; i < NQ_SEG; i = i + 1) begin : stage
            reg r = 1'b0;
            reg [CODE_BITS-1:0] ch = CODE_INIT[CODE_BITS-1:0]; // next-edge code
            always @(nd[i]) begin
                // current edge leaves with the previously latched code.
                // DLY_OFF_X4 is test-only scaffolding (normally 0).
                r  <= #((CELL_X4_MIN + (ch * CELL_X4_STEP) + DLY_OFF_X4)/4000.0)
                      nd[i];
                // latch the present code for the next edge
                ch <= CODE;
            end
            assign nd[i+1] = r;
        end
    endgenerate
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
    parameter integer RAIL_CONSEC       = 32    // acquisition-only rail aid
) (
    input  wire                  CKIN,   // 100 MHz CK (the master locks ON it)
    input  wire                  RST,    // async reset, active high (state only)
    input  wire                  EN,     // quiet gate: 0 -> CK90 low
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

    // ------------------------------------------------------------------
    // Behavioural absolute time-difference measurement.
    //   PUSH: free-running, one timestamp per CKIN rising edge.
    //   POP : free-running, one pairing per master_out rising edge.
    //   master_delay = now - paired CKIN time (absolute, never modulo T).
    //   Real-cell equivalent: coarse CKIN-cycle counter + delay-line TDC.
    // Both sides advance at exactly one entry per CKIN period, so the FIFO
    // occupancy is constant and pairing is exact across resets.
    // ------------------------------------------------------------------
    real    t_ck_q [0:QDEPTH-1];
    integer q_head = 0, q_tail = 0;   // head/tail; head!=tail => FIFO non-empty
    real    dly_ns;
    integer dly_ps;
    integer e_meas;
    reg     meas_vld;

    always @(posedge CKIN) begin
        t_ck_q[q_head] = $realtime;
        if (q_head == QDEPTH-1) q_head = 0;
        else                    q_head = q_head + 1;
    end

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
    always @(master_out or posedge RST) begin
        // Detect a real rising edge regardless of trigger order/merging:
        // a bare posedge RST re-enters with master_out unchanged -> rise=0.
        rise   = (master_out === 1'b1) && (prev_m !== 1'b1);
        prev_m = master_out;

        // POP (exactly once per genuine rise, even during RST)
        meas_vld = 1'b0;
        if (rise && (q_head != q_tail)) begin
            dly_ns = $realtime - t_ck_q[q_tail];
            if (q_tail == QDEPTH-1) q_tail = 0;
            else                    q_tail = q_tail + 1;
            dly_ps  = $rtoi(dly_ns * 1000.0 + 0.5);
            e_meas  = dly_ps - REF_PERIOD_PS;
            meas_vld = 1'b1;
        end

        if (RST) begin
            // async clear of loop state (never the FIFO head/tail)
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
                    // e <= 0: master early             -> increase code
                    if (e > 0) begin
                        if (code_q != code_min) code_q <= code_q - 1'b1;
                        if (code_q == code_min) rail_cnt <= rail_cnt + 1'b1;
                        else                    rail_cnt <= 16'd0;
                        last_dir <= 2'b10;
                    end else begin
                        if (code_q != code_max) code_q <= code_q + 1'b1;
                        if (code_q == code_max) rail_cnt <= rail_cnt + 1'b1;
                        else                    rail_cnt <= 16'd0;
                        last_dir <= 2'b01;
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
    assign CK90       = EN & slave_out;
    assign DBG_CODE   = code_q;
endmodule
