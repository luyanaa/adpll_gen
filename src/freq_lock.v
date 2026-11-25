// Frequency locking. A very basic (and probably wrong) RTL for
// locking the frequency of a DCO in an IL-PLL

// The RTL will have a counter which is constantly reset by the
// ref clock, and update coarse and mid configurations.
`timescale 1fs/1fs

// Standard clock-gate wrapper.  For the ics55 macro the PDK ICG cell is used
// when PLL_USE_ICS55_ICG is defined; otherwise this is the portable negedge
// latch + AND model.  The enable is sampled on the falling clock so GCLK has
// no glitch.
module PLL_CLKGATE (
    input  wire EN,
    input  wire CLK,
    output wire GCLK
);
`ifdef PLL_USE_ICS55_ICG
    ICGNX1H7R u_icg (.CKN(CLK), .E(EN), .ECK(GCLK));
`elsif PLL_USE_IHP_ICG
    // IHP SG13G2 clock gate.
    //
    // Do NOT build this from sg13g2_dllrq_1 (latch) + AND, even though that is
    // the textbook latch_negedge_postcontrol structure.  The library models
    // that latch with a GATE_N -> Q `falling_edge` arc, i.e. the gate is a
    // *clock* pin as far as STA is concerned.  Wiring GATE_N to CLK and then
    // ANDing CLK with the latch output closes a loop in the clock graph
    // (CLK -> GATE_N -> Q -> AND -> GCLK), and OpenSTA's path search never
    // terminates: report_checks spins forever at ~100% CPU with no output.
    // Measured: the same design with the two latches' Q disconnected reports
    // in 220 ms instead of hanging.
    //
    // sg13g2_lgcp_1 is the real ICG cell and is modelled correctly for this
    // use: GCLK carries no edge arc at all, and GATE only has setup/hold
    // against CLK.  The ORFS library marks it dont_use and lists it in
    // synth_excluded.cells, so both exclusions are lifted in the canary
    // config (PNR_EXCLUDED_CELLS / SYNTH_EXCLUDED_CELL_FILE) -- a design that
    // actually needs a clock gate cannot honour a blanket dont_use.
    sg13g2_lgcp_1 u_icg (
        .CLK(CLK), .GATE(EN), .GCLK(GCLK)
    );
`else
    (* keep *) reg en_l;
    initial en_l = 1'b1;
    always @(negedge CLK) en_l <= EN;
    assign GCLK = CLK & en_l;
`endif
endmodule

module pll_freq_lock #(
    parameter integer COARSE_NDELS = 4,     // Assign to coarse delays
    parameter integer MID_NDELS = 5,        // Assign to mid delays
    parameter integer CNT_BITS = 8,         // Number of bits for the freq counter
    parameter integer CNT_TOL_BITS = 8,     // Number of bits for tolerances
    // The measurement counter is widened beyond FCW so acquisition cannot
    // silently wrap when the free-running DCO is far above REF.  The extra
    // bits are not part of the legal FCW range.
    parameter integer CNT_EXTRA_BITS = 8,
    parameter integer MEAS_PERIODS = 1,     // REF periods per completed measurement window
    parameter integer CNT_W = CNT_BITS + CNT_EXTRA_BITS,
    parameter integer MEAS_W = CNT_W + ((MEAS_PERIODS > 1) ? $clog2(MEAS_PERIODS) : 0),
    parameter integer LOCK_LIMIT = 64,      // If CNT is inside the locking tolerance for this many cycles, lock
    parameter integer ERR_LIMIT = 64,       // If COARSE and MID cannot increase/decrease for this many cycles, err
    parameter integer LOCK_TOL = 0,         // Tolerance for the FCW for locking. 0 for exact (CNT = FCW +/- LOCK_TOL)
    // Consecutive out-of-window filtered samples before the live
    // FREQ_OK flag falls.  Sticky LOCKED is not cleared by this.
    parameter integer FREQ_LOSS = 4,
    // Judge the lock window on a sum of this many per-REF counts instead of
    // one.  A single count resolves 1/FCW (6.25% at FCW=16), which is ~30x
    // wider than the SerDes bang-bang can track.  256 counts of a ratio near
    // 16 resolve about 244 ppm, inside the fine bank's ~600 ppm span, so the
    // phase loop has an actuator left once coarse/mid freeze.  LOCK_TOL is
    // counted on that sum, so the accepted band shrinks as the window grows.
    // 1 keeps the old per-REF window; the measurement port is unchanged.
    parameter integer LOCK_WINDOW = 1,
    parameter integer TOL_COARSE_WAIT = 1,  // Wait REF cycles for changing the COARSE once the MID is in the limit, 1 for always change
    // Counter frontend selection. 0 = synchronous (default), 1 = async ripple,
    // 2 = Johnson prescaler.  Ripple/Johnson require an explicit CDC review.
    // PRESCALE only changes the internal update rate; the frontend COUNT/GRAY
    // contract is normalized to actual input edges so FCW is unchanged.
    parameter integer FRONTEND_MODE = 0,
    parameter integer PRESCALE = 1,
    parameter integer LOCK_W = CNT_W + ((LOCK_WINDOW > 1) ? $clog2(LOCK_WINDOW) : 0)
) (
    input REF, MID_OUT, OUT, RST_N, START,
    input [CNT_BITS-1:0] FCW,
    input LOCK,
    input FORCE_P, FORCE_N,                 // Force count up or down
    output reg LOCKED, ERR,
    // Live window: filtered count is inside FCW +/- LOCK_TOL.  Unlike
    // LOCKED, this falls again after FREQ_LOSS consecutive misses, so a
    // phase detector cannot keep a lock the frequency counter disagrees with.
    output reg FREQ_OK,
    output reg [COARSE_NDELS-1:0] COARSE_MUX,
    output reg [MID_NDELS-1:0] MID_MUX,
    // Completed lock-window sum, LOCK_WINDOW per-REF counts wide.  The tuning
    // FSM and FREQ_OK read this; the per-REF delta stays on cnt_cap for the
    // existing measurement checks.
    output reg [LOCK_W-1:0] LOCK_COUNT_Q,
    // Measurement interface (separate from acquisition control).  CNT_EXTRA_BITS
    // widens the source counter beyond the legal FCW width; MEAS_PERIODS sets
    // the REF window used for the completed SAMPLE_VALID/MEASURED_COUNT.
    output reg SAMPLE_VALID,
    output reg [MEAS_W-1:0] MEASURED_COUNT
);
    wire CLK_REF = REF; // NOTE: Negative injection
    wire CLK_OUT = MID_OUT;
    // Static frontend normalization.  FRONTEND_MODE 3 registers a Gray word
    // of the divided count, one bit per PS input edges, and the REF domain has
    // to multiply the delta back (frequency_counter_frontend.v).  The other
    // modes already report input edges, so the shift only applies here.  With
    // it missing, PRESCALE=2 reports half the real ratio and the loop locks at
    // FCW/2 (measured: 4 divided counts per REF against a DCO running at 8).
    localparam integer PS_SHIFT = (FRONTEND_MODE == 3 && PRESCALE == 2) ? 1 :
        (FRONTEND_MODE == 3 && PRESCALE == 4) ? 2 : 0;

    // Frequency-count CDC: constrained asynchronous Gray snapshot.
    //
    // The counter free-runs in MID_OUT and is not reset by REF.  Every MID_OUT
    // edge changes exactly one Gray bit, so a 2FF sample taken in REF is always
    // a valid Gray word (it may be the old or new word if the sample lands on
    // an edge, but never a multi-bit mixture).  REF converts the sampled word
    // to binary and subtracts the previous sample; the difference is the count
    // over one REF period.  The Gray word is intentionally NOT used as a
    // one-bit snapshot-to-snapshot edge detector: many MID_OUT counts can pass
    // between two REF samples.
    wire [CNT_W-1:0] cnt;
    wire [CNT_W-1:0] cnt_gray;
    wire frontend_cdc_safe;
    frequency_counter_frontend #(
        .CNT_W(CNT_W),
        .MODE(FRONTEND_MODE),
        .PRESCALE(PRESCALE)
    ) counter_frontend (
        .CLK(CLK_OUT),
        .RST_N(RST_N),
        .COUNT(cnt),
        .GRAY_COUNT(cnt_gray),
        .CDC_SAFE(frontend_cdc_safe)
    );
    (* ASYNC_REG = "TRUE" *) reg [CNT_W-1:0] cnt_gray_s1;
    (* ASYNC_REG = "TRUE" *) reg [CNT_W-1:0] cnt_gray_s2;
    reg [CNT_W-1:0] cnt_bin;
    reg [CNT_W-1:0] sample_bin;
    reg [CNT_W-1:0] cnt_cap; // count over the last REF period (input edges)
    // One guard bit, and a net rather than a reg.  sample_bin and cnt_bin are
    // free-running and wrap, so the delta is a modular subtraction; taking it
    // at CNT_W and then shifting for the prescale turns the wrap into a carry
    // one bit above the counter (measured at the 16-bit wrap, 65527 -> 7: the
    // shifted 16-bit difference came back as 16711920).  A blocking reg does
    // not help: the nonblocking adds in this same block read it a cycle late,
    // so the accumulator still took the wrapped value (224 -> 65776) while
    // cnt_cap, which uses it directly, was already right.
    // The delta must be taken against the sample captured on the previous REF
    // edge.  cnt_bin cannot be that reference: it is written with a nonblocking
    // assignment in this same block, and under iverilog 12 a read of it returns
    // the value just written, so the subtraction collapses to zero on every
    // edge except the counter wrap, where it comes back as 65536 plus the real
    // count (measured: 65552 added, accumulator 224 -> 65776).  Reading cnt_bin
    // into a second register has the same problem one edge later and doubles
    // every count.  sample_bin is a blocking temporary, so copying it here
    // records exactly the word used for this edge's delta.
    reg [CNT_W-1:0] cnt_prev;
    // Computed inside the sampler block, after sample_bin is assigned.  A
    // continuous assignment here runs before that blocking write and subtracts
    // a sample from itself, so every delta is zero.  The integer form is also
    // deliberate: iverilog 12 folds `{1'b0, a} - {1'b0, b}` back to CNT_W bits,
    // dropping the borrow at the counter wrap (measured: 7 - 65527 = 65552
    // instead of 16), and the prescale shift doubles that into the window sum.
    integer delta_int;
    // The shift is applied to the sized vector, not the integer.  iverilog 12
    // treats `<<` on an integer as arithmetic, so a delta whose top bit is set
    // (anything at or above half the counter) comes back negative and the
    // window sum collapses.
    reg [CNT_W:0] delta_edges;
    reg [CNT_W:0] delta_edges_ps;
    // Running total of the current window.  An integer rather than a reg: the
    // published sum is taken from it on the closing edge and it is cleared in
    // the same pass, and doing that to a reg let iverilog 12 keep the clear.
    integer win_sum;

    // FLL standby gate: once the frequency is locked and the live window is
    // good, freeze the IIR/control updates.  The Gray sampler and the live
    // cnt_cap/FREQ_OK path stay on REF, so a FREQ_OK drop reopens the gate.
    wire fll_standby = LOCKED & FREQ_OK;
    reg [CNT_W-1:0] cnt_filt; // 1/4 IIR filter for lock/tuning decisions
    reg [MEAS_W-1:0] meas_accum;
    reg [31:0] meas_count;
    // Lock window, separate from the measurement port.  win_sum adds the
    // per-REF deltas and lock_sum publishes the total once every LOCK_WINDOW
    // REF edges.  FREQ_OK and the acquisition counter read lock_sum, so a
    // single noisy REF edge cannot drop the lock; coarse/mid tuning stays on
    // the per-REF capture, which moves a step per edge.
    reg [31:0] lock_count;
    reg [LOCK_W-1:0] lock_sum;
    reg lock_sum_valid;
    // Combinational view of the window sum on the REF edge that closes it.
    // The IIR block reads this rather than lock_sum: both blocks are clocked
    // by REF, and a nonblocking read of lock_sum would be the previous window.
    reg [LOCK_W-1:0] lock_sum_now;
    reg lock_sum_now_valid;
    reg cap_valid;

    initial begin
        cnt_gray_s1 = 'd0;
        cnt_gray_s2 = 'd0;
        cnt_bin = 'd0;
        sample_bin = 'd0;
        cnt_prev = 'd0;
        delta_edges_ps = 'd0;
        win_sum = 0;
        cnt_cap = 'd0;
        cnt_filt = 'd0;
        meas_accum = 'd0;
        meas_count = 'd0;
        lock_count = 'd0;
        lock_sum = 'd0;
        lock_sum_valid = 1'b0;
        lock_sum_now = 'd0;
        lock_sum_now_valid = 1'b0;
        LOCK_COUNT_Q = 'd0;
        cap_valid = 1'b0;
        SAMPLE_VALID = 1'b0;
        MEASURED_COUNT = 'd0;
    end

    // The selected counter frontend is free-running in the DCO domain.  The
    // default synchronous mode has no REF-derived reset.  The alternate modes
    // are explicit CDC experiments; see frequency_counter_frontend.v.

    // REF-domain Gray sampling and per-REF delta.
    always @(posedge CLK_REF or negedge RST_N) begin
        if(!RST_N) begin
            cnt_gray_s1 <= 'd0;
            cnt_gray_s2 <= 'd0;
            cnt_bin <= 'd0;
            sample_bin <= 'd0;
            cnt_prev <= 'd0;
            delta_edges_ps <= 'd0;
            win_sum = 0;
            cnt_cap <= 'd0;
            meas_accum <= 'd0;
            meas_count <= 'd0;
            lock_count <= 'd0;
            lock_sum <= 'd0;
            lock_sum_valid <= 1'b0;
            lock_sum_now = 'd0;
            lock_sum_now_valid = 1'b0;
            LOCK_COUNT_Q <= 'd0;
            cnt_filt <= 'd0;
            cap_valid <= 1'b0;
            SAMPLE_VALID <= 1'b0;
            MEASURED_COUNT <= 'd0;
            FREQ_OK <= 1'b0;
            freq_miss <= 3'd0;
        end else begin
            cnt_gray_s1 <= cnt_gray;
            cnt_gray_s2 <= cnt_gray_s1;
            // Blocking temporary: the delta and the history must use the same
            // newly synchronized sample.
            sample_bin = gray_to_bin(cnt_gray_s2);
            delta_int = sample_bin - cnt_prev;
            if (delta_int < 0)
                delta_int = delta_int + (1 << CNT_W);
            delta_edges = delta_int[CNT_W:0];
            delta_edges_ps = delta_edges << PS_SHIFT;
            if(!cap_valid) begin
                cnt_bin <= sample_bin;
                cnt_cap <= 'd0;
                meas_accum <= 'd0;
                meas_count <= 'd0;
                lock_count <= 'd0;
                lock_sum_now = 'd0;
                lock_sum_now_valid = 1'b0;
                win_sum = 0;
                cap_valid <= 1'b1;
                SAMPLE_VALID <= 1'b0;
                MEASURED_COUNT <= 'd0;
            end else begin
                cnt_cap <= delta_edges_ps;
                cnt_bin <= sample_bin;
                cnt_prev <= sample_bin;
                if(meas_count == MEAS_PERIODS - 1) begin
                    MEASURED_COUNT <= meas_accum + delta_edges_ps;
                    meas_accum <= 'd0;
                    meas_count <= 'd0;
                    SAMPLE_VALID <= 1'b1;
                end else begin
                    meas_accum <= meas_accum + delta_edges_ps;
                    meas_count <= meas_count + 1'b1;
                    SAMPLE_VALID <= 1'b0;
                end
                // One running total, published on the closing edge and cleared
                // for the next window.  The clear and the add are in opposite
                // arms, so a given edge only ever does one of them.
                win_sum = win_sum + delta_edges_ps;
                if(lock_count == LOCK_WINDOW - 1) begin
                    lock_sum_now = win_sum;
                    lock_sum_now_valid = 1'b1;
                    lock_sum <= lock_sum_now;
                    LOCK_COUNT_Q <= lock_sum_now;
                    win_sum = 0;
                    lock_count = 'd0;
                    lock_sum_valid <= 1'b1;
                    // Filter here, in the same block as the sum, and only
                    // while the tuning clock is running.  A separate block on
                    // REF_G reads lock_sum_now one window late: the two clocks
                    // are the same net while the gate is open, and iverilog
                    // runs that block first.
                    if (!fll_standby) begin : fll_filt
                        integer filt_next;
                        // One expression.  Splitting this into two integer
                        // assignments lets iverilog evaluate the second with
                        // the first still unset, and the filter then follows
                        // its own output instead of the window sum.
                        filt_next = (3 * cnt_filt + lock_sum_now + 2) / 4;
                        cnt_filt <= filt_next[LOCK_W-1:0];
                    end
                end else begin
                    lock_sum_now = 'd0;
                    lock_sum_now_valid = 1'b0;
                    lock_count = lock_count + 1'b1;
                end
            end
            // Live FCW window: this stays on REF even when the FLL
            // IIR/tuning clock is gated, so a FREQ_OK drop can reopen it.
            // It reads the completed window sum, not the per-REF delta: one
            // count of FCW is 1/FCW, and the phase loop cannot trim that.
            if (!lock_sum_valid) begin
                FREQ_OK <= 1'b0;
                freq_miss <= 3'd0;
            end else if ((lock_sum >= FCW_NA) && (lock_sum <= FCW_PA)) begin
                FREQ_OK <= 1'b1;
                freq_miss <= 3'd0;
            end else if (freq_miss >= FREQ_LOSS_LIM - 1) begin
                FREQ_OK <= 1'b0;
            end else begin
                freq_miss <= freq_miss + 3'd1;
            end
        end
    end

    function [CNT_W-1:0] gray_to_bin;
        input [CNT_W-1:0] gray;
        integer i;
        begin
            gray_to_bin[CNT_W-1] = gray[CNT_W-1];
            for(i = CNT_W-2; i >= 0; i = i - 1)
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
        end
    endfunction

    // Tolerances on the window sum, not on one REF count.  FCW and
    // LOCK_TOL are both counts per REF, so the window scales both by
    // LOCK_WINDOW: a ratio of FCW +/- LOCK_TOL stays inside, and the
    // resolution becomes one count over the whole window.
    // Combinational, not registered.  The live window below compares the
    // sum on the same edge that publishes it; a registered tolerance would
    // still be zero on that edge and accept the first window unconditionally.
    //
    // LOCK_TOL is counts of the window sum, not counts per REF.  Scaling it
    // by LOCK_WINDOW would leave the band at +/-1/FCW (6.25% at FCW=16) no
    // matter how long the window is, which is the error this window exists
    // to remove.  With LOCK_WINDOW=1 the two readings are identical, so the
    // per-REF tests are unchanged; with LOCK_WINDOW=256 one count is about
    // 244 ppm at FCW=16.
    wire [LOCK_W-1:0] FCW_PA; // LOCK_WINDOW*FCW + TOL
    wire [LOCK_W-1:0] FCW_NA; // LOCK_WINDOW*FCW - TOL
    wire [LOCK_W-1:0] fcw_target = FCW * LOCK_WINDOW;
    assign FCW_PA = fcw_target + LOCK_TOL;
    assign FCW_NA = fcw_target - LOCK_TOL;

    // True ICG for the IIR/tuning.  The wrapper latches EN on the falling REF
    // (or instantiates the ics55 ICG cell); the live sampler/FREQ_OK/
    // measurement remain on CLK_REF.
    wire REF_G;
    PLL_CLKGATE u_fll_icg (
        .EN(~fll_standby), .CLK(CLK_REF), .GCLK(REF_G)
    );

`ifdef INVALID
    reg cnt_less;
    reg cnt_more;
    always @(negedge CLK_REF) cnt_less <= cnt_cap < FCW;
    always @(negedge CLK_REF) cnt_more <= cnt_cap > FCW;
`else
    wire cnt_less;
    wire cnt_more;
    // Tuning reads the per-REF capture, not the filtered window sum.  The
    // filter settles over about twenty windows, and stepping coarse/mid only
    // once it has settled leaves the loop a full window behind the DCO: it
    // stops moving while the ratio is still a count away from FCW.  One REF
    // of noise can move the code by a single step, which the next REF undoes.
    // The lock decision stays on the window sum, where one count is the
    // resolution the phase loop can actually trim.
    assign cnt_less = cnt_cap < FCW;
    assign cnt_more = cnt_cap > FCW;
`endif

    reg [CNT_TOL_BITS-1:0] cnt_done;
    reg [CNT_TOL_BITS-1:0] cnt_err;
    reg [CNT_TOL_BITS-1:0] cnt_coarse_wait;
    reg started;
    localparam integer FREQ_LOSS_LIM = (FREQ_LOSS < 1) ? 1 :
        (FREQ_LOSS > 7) ? 7 : FREQ_LOSS;
    reg [2:0] freq_miss;
    always @(posedge REF_G or negedge RST_N) begin
        if(!RST_N) begin
            ERR <= 1'b0;
            LOCKED <= 1'b0;
            // cnt_filt is reset and updated in the REF sampler block, next to
            // the window sum it filters.  Resetting it here as well makes
            // iverilog 12 resolve the register to X for the whole run.
            COARSE_MUX <= 'd0;
            MID_MUX <= 'd0;
            cnt_done <= 'd0;
            cnt_err <= 'd0;
            cnt_coarse_wait <= 'd0;
            started <= 1'b0;
        end else begin
            // The IIR itself is updated next to the window sum, on
            // CLK_REF, and held while fll_standby is set.  Doing it here, on
            // REF_G, reads the sum one window late.
            // Start status
            if(!started && START) started <= 1'b1;

            // Start again if it was already locked or in error status
            if((LOCKED || ERR) && START) begin
                LOCKED <= 1'b0;
                ERR <= 1'b0;
                cnt_done <= 'd0;
                cnt_err <= 'd0;
            end

            if(!LOCKED && !ERR && started) begin
                // Locking done when the frequency doesn't 
                // change anymore during a certain time
                if(cnt_done >= LOCK_LIMIT) LOCKED <= 1'b1;

                // Increase the locking counter when the frequency counter is
                // within the range. Reset the counter when counters are different
                // Same quantity FREQ_OK judges.  cnt_filt is the IIR of the
                // window sum and settles over about twenty windows, so a band
                // only a few counts wide around the target (the Gray sampler
                // already sits 6 or 7 below it) never contains it and the
                // acquisition counter stalls at 0 while FREQ_OK is already 1.
                if(FCW_NA <= lock_sum && lock_sum <= FCW_PA)
                    cnt_done <= cnt_done + 1;
                else if(cnt_done != 0)
                    cnt_done <= cnt_done - 1; // leaky: one bad sample must not restart acquisition
            end

            // Coarse and mid delay tuning
            if(started && ((!LOCK && cnt_less) || FORCE_N)) begin
                // if the captured counter is lower than the desired
                // means that the frequency is lower
                // need to make it faster, and by extension, disable delays
                if(MID_MUX[0] == 1'b0) begin // Mid cannot decrease anymore
                    cnt_coarse_wait <= cnt_coarse_wait - 1;
                    if(cnt_coarse_wait == 'd0) begin
                        if(COARSE_MUX[0] == 1'b0) begin 
                            cnt_err <= cnt_err + 1;
                            if(cnt_err == ERR_LIMIT) ERR <= 1'b1; // Cannot decrease anything
                        end else begin
                            MID_MUX <= {{2{1'b0}}, {(MID_NDELS-2){1'b1}}}; // Put the mid on highest
                            COARSE_MUX <= {1'b0, COARSE_MUX[COARSE_NDELS-1:1]}; // Decrease by one
                            cnt_err <= 'd0;
                            cnt_coarse_wait <= TOL_COARSE_WAIT-1;
                        end
                    end
                end else begin
                    MID_MUX <= {1'b0, MID_MUX[MID_NDELS-1:1]}; // Decrease by one
                    cnt_err <= 'd0;
                    cnt_coarse_wait <= TOL_COARSE_WAIT-1;
                end
            end else if(started && ((!LOCK && cnt_more) || FORCE_P)) begin
                // if the captured counter is higher than the desired
                // means that the frequency is higher
                // need to make it slower, and by extension, enable delays
                if(MID_MUX[MID_NDELS-1] == 1'b1) begin // Mid cannot increase anymore
                    cnt_coarse_wait <= cnt_coarse_wait - 1;
                    if(cnt_coarse_wait == 'd0) begin
                        if(COARSE_MUX[COARSE_NDELS-1] == 1'b1) begin
                            cnt_err <= cnt_err + 1;
                            if(cnt_err == ERR_LIMIT) ERR <= 1'b1; // Cannot increase anything
                        end else begin
                            MID_MUX <= {{(MID_NDELS-2){1'b0}}, {2{1'b1}}}; // Put the mid on lowest
                            COARSE_MUX <= {COARSE_MUX[COARSE_NDELS-2:0], 1'b1}; // Increase by one
                            cnt_err <= 'd0;
                            cnt_coarse_wait <= TOL_COARSE_WAIT-1;
                        end
                    end
                end else begin
                    MID_MUX <= {MID_MUX[MID_NDELS-2:0], 1'b1}; // Increase by one
                    cnt_err <= 'd0;
                    cnt_coarse_wait <= TOL_COARSE_WAIT-1;
                end
            end else begin
                cnt_coarse_wait <= TOL_COARSE_WAIT-1;
            end
        end
    end

endmodule
