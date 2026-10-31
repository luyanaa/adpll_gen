// Frequency locking. A very basic (and probably wrong) RTL for
// locking the frequency of a DCO in an IL-PLL

// The RTL will have a counter which is constantly reset by the
// ref clock, and update coarse and mid configurations.
`timescale 1fs/1fs

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
    parameter integer TOL_COARSE_WAIT = 1,  // Wait REF cycles for changing the COARSE once the MID is in the limit, 1 for always change
    // Counter frontend selection. 0 = synchronous (default), 1 = async ripple,
    // 2 = Johnson prescaler.  Ripple/Johnson require an explicit CDC review.
    // PRESCALE only changes the internal update rate; the frontend COUNT/GRAY
    // contract is normalized to actual input edges so FCW is unchanged.
    parameter integer FRONTEND_MODE = 0,
    parameter integer PRESCALE = 1
) (
    input REF, MID_OUT, OUT, RST_N, START,
    input [CNT_BITS-1:0] FCW,
    input LOCK,
    input FORCE_P, FORCE_N,                 // Force count up or down
    output reg LOCKED, ERR,
    output reg [COARSE_NDELS-1:0] COARSE_MUX,
    output reg [MID_NDELS-1:0] MID_MUX,
    // Measurement interface (separate from acquisition control).  CNT_EXTRA_BITS
    // widens the source counter beyond the legal FCW width; MEAS_PERIODS sets
    // the REF window used for the completed SAMPLE_VALID/MEASURED_COUNT.
    output reg SAMPLE_VALID,
    output reg [MEAS_W-1:0] MEASURED_COUNT
);
    wire CLK_REF = REF; // NOTE: Negative injection
    wire CLK_OUT = MID_OUT;

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
    reg [CNT_W-1:0] cnt_cap; // count over the last REF period
    reg [CNT_W-1:0] cnt_filt; // 1/4 IIR filter for lock/tuning decisions
    reg [MEAS_W-1:0] meas_accum;
    reg [31:0] meas_count;
    reg cap_valid;

    initial begin
        cnt_gray_s1 = 'd0;
        cnt_gray_s2 = 'd0;
        cnt_bin = 'd0;
        sample_bin = 'd0;
        cnt_cap = 'd0;
        cnt_filt = 'd0;
        meas_accum = 'd0;
        meas_count = 'd0;
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
            cnt_cap <= 'd0;
            cnt_filt <= 'd0;
            meas_accum <= 'd0;
            meas_count <= 'd0;
            cap_valid <= 1'b0;
            SAMPLE_VALID <= 1'b0;
            MEASURED_COUNT <= 'd0;
        end else begin
            cnt_gray_s1 <= cnt_gray;
            cnt_gray_s2 <= cnt_gray_s1;
            // Blocking temporary: the delta and the history must use the same
            // newly synchronized sample.
            sample_bin = gray_to_bin(cnt_gray_s2);
            if(!cap_valid) begin
                cnt_bin <= sample_bin;
                cnt_cap <= 'd0;
                cnt_filt <= 'd0;
                meas_accum <= 'd0;
                meas_count <= 'd0;
                cap_valid <= 1'b1;
                SAMPLE_VALID <= 1'b0;
                MEASURED_COUNT <= 'd0;
            end else begin
                cnt_cap <= sample_bin - cnt_bin;
                // Round the IIR update.  Truncating every low-count sample
                // can pin the filtered value at zero when REF sees only 1-3
                // DCO edges per period (Core C / low-frequency operation).
                cnt_filt <= (cnt_filt * 3 + (sample_bin - cnt_bin) + 2) >> 2;
                cnt_bin <= sample_bin;
                if(meas_count == MEAS_PERIODS - 1) begin
                    MEASURED_COUNT <= meas_accum + (sample_bin - cnt_bin);
                    meas_accum <= 'd0;
                    meas_count <= 'd0;
                    SAMPLE_VALID <= 1'b1;
                end else begin
                    meas_accum <= meas_accum + (sample_bin - cnt_bin);
                    meas_count <= meas_count + 1'b1;
                    SAMPLE_VALID <= 1'b0;
                end
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

    // Register the tolerances... 
    reg [CNT_W-1:0] FCW_PA; // FCW + TOL
    reg [CNT_W-1:0] FCW_NA; // FCW - TOL
    always @(posedge CLK_REF) begin
        FCW_PA <= FCW + LOCK_TOL;
        FCW_NA <= FCW - LOCK_TOL;
    end

`ifdef INVALID
    reg cnt_less;
    reg cnt_more;
    always @(negedge CLK_REF) cnt_less <= cnt_cap < FCW;
    always @(negedge CLK_REF) cnt_more <= cnt_cap > FCW;
`else
    wire cnt_less;
    wire cnt_more;
    // Judge acquisition on the filtered count, not the raw single-cycle
    // capture.  This keeps a noisy REF edge from toggling the tuning FSM.
    assign cnt_less = cnt_filt < FCW;
    assign cnt_more = cnt_filt > FCW;
`endif

    reg [CNT_TOL_BITS-1:0] cnt_done;
    reg [CNT_TOL_BITS-1:0] cnt_err;
    reg [CNT_TOL_BITS-1:0] cnt_coarse_wait;
    reg started;
    always @(posedge CLK_REF or negedge RST_N) begin
        if(!RST_N) begin
            ERR <= 1'b0;
            LOCKED <= 1'b0;
            COARSE_MUX <= 'd0;
            MID_MUX <= 'd0;
            cnt_done <= 'd0;
            cnt_err <= 'd0;
            cnt_coarse_wait <= 'd0;
            started <= 1'b0;
        end else begin
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
                if(FCW_NA <= cnt_filt && cnt_filt <= FCW_PA)
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
