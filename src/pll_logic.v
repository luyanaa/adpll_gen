`default_nettype none
// The digital synthesizable part of the PLL

module pll_logic#(
    parameter integer COARSE_NDELS = 15, // 4-bit coarse
    parameter integer MID_NDELS = 15, // 4-bit mid
    parameter integer FINE_NDELS = 31, // 5-bit fine
    parameter integer FILTER_BITS = 16,
    parameter integer IS_DSM = 1,
    parameter integer DSM_DIV = 2,
    parameter integer LOCKED_WAIT = 64,
    parameter integer FILTER_ILL = 16,
    parameter integer LOCK_TOL = 1,
    parameter integer LOCK_COUNT = 16,
    parameter integer LOSS_COUNT = 4,
    // Simulation hook.  When 1, PHASE_LOCK / LOCK_LOST / FREQ_LOCKED /
    // FREQ_ERR come from the *_TB regs below instead of the detectors.
    // Synthesis leaves this at 0.  Forcing those nets is not used: they
    // are wires driven by module instances, and Icarus segfaults on force.
    parameter integer TB_OVERRIDE = 0,
    // DCO cycles without a REF edge before the watchdog drops REF_OK.
    // Must be larger than the legal FCW: one REF edge is expected every
    // FCW DCO cycles while the loop is in range.
    parameter integer REF_TIMEOUT = 512,
    // REF cycles without a DCO edge, checked only while locked.  A stopped,
    // stuck-high or stuck-low DCO cannot be seen by the REF watchdog,
    // because that counter is clocked by OUT.  The Gray word spends up to
    // three REF cycles in the synchronizer before the first miss is
    // counted, so the effective detection window is DCO_TIMEOUT + 3.
    parameter integer DCO_TIMEOUT = 4,
    parameter integer CNT_EXTRA_BITS = 8,
    parameter integer MEAS_PERIODS = 1,
`ifndef PLL_WITHOUT_DIVIDER
    parameter integer DIV_BITS = 8,
    parameter integer DIV_INIT = 2,
`endif
    parameter integer FCW_BITS = 8
) (
`ifdef WITH_POWER
    input VDD, VSS, // Ignored (for now)
`endif
    input REF, OUT, MID_OUT, INJ_EDGE, RST_N,
    input [1:0] SS_BBPD,
    input [FILTER_BITS-1:0] KP, KI,
    input [FCW_BITS-1:0] FCW,
    input DSM_EN_DT,
    input DSM_EN_SHDT,
    input [1:0] DSM_ORDER,
`ifndef PLL_WITHOUT_DIVIDER
    input [DIV_BITS-1:0] SET_DIV,
    input LOAD_DIV,
    output OUT_DIV,
    output CK,
`endif
    output reg [COARSE_NDELS-1:0] COARSE_MUX,
    output reg [MID_NDELS-1:0] MID_MUX,
    output reg [FINE_NDELS-1:0] FINE_MUX,
    output reg DCO_EN, ERR,
    // LOCKED is gated by the DCO-domain reference watchdog.  It is not a
    // flop in the INJ_EDGE domain: that clock stops when REF stops.
    output LOCKED
);
    localparam integer FINE_CODE_BITS = $clog2(FINE_NDELS + 1);

    // Explicit single-bit status nets: with `default_nettype none these must
    // not be implicit wires.
    wire PHASE_LOCK_W;
    wire LOCK_LOST_W;
    wire FREQ_LOCKED_W, FREQ_ERR_W, FREQ_OK_W;
    reg PHASE_LOCK_TB;
    reg LOCK_LOST_TB;
    reg FREQ_LOCKED_TB;
    reg FREQ_ERR_TB;
    reg FREQ_OK_TB;
    wire PHASE_LOCK = TB_OVERRIDE ? PHASE_LOCK_TB : PHASE_LOCK_W;
    wire LOCK_LOST = TB_OVERRIDE ? LOCK_LOST_TB : LOCK_LOST_W;
    wire FREQ_LOCKED = TB_OVERRIDE ? FREQ_LOCKED_TB : FREQ_LOCKED_W;
    wire FREQ_ERR = TB_OVERRIDE ? FREQ_ERR_TB : FREQ_ERR_W;
    // FREQ_OK is the live FCW window, not the sticky acquisition flag.
    // A phase-lock indication must not enter or hold the locked state
    // without it.
    wire FREQ_OK = TB_OVERRIDE ? FREQ_OK_TB : FREQ_OK_W;

    wire [COARSE_NDELS-1:0] COARSE_MUX_D;
    wire [MID_NDELS-1:0] MID_MUX_D;
    wire [FINE_NDELS-1:0] FINE_MUX_D;

    // CKR is a derived clock, not a data enable.  It is REF sampled on
    // the falling edge of MID_OUT, so a high pulse lasts an integer number
    // of MID_OUT periods: from the falling edge that samples REF=1 until
    // the next falling edge that samples REF=0.  It is not one MID_OUT
    // high time.  Coarse and mid codes are registered on its rising edge;
    // that write does not toggle OUT.  CKR exists only while MID_OUT
    // toggles.  A static-timing run has to treat it as a generated clock
    // of MID_OUT gated by REF, not as a free-running clock.
    reg CKR;
    always @(negedge MID_OUT or negedge RST_N) if(!RST_N) CKR <= 1'b0; else CKR <= REF;
    //always @(posedge CKR or negedge RST_N) if(!RST_N) FINE_MUX <= 'd0; else FINE_MUX <= FINE_MUX_D; // Done afterwards
    always @(posedge CKR or negedge RST_N) if(!RST_N) MID_MUX <= 'd0; else MID_MUX <= MID_MUX_D;
    always @(posedge CKR or negedge RST_N) if(!RST_N) COARSE_MUX <= 'd0; else COARSE_MUX <= COARSE_MUX_D;

    // Filter stage
    wire [FILTER_BITS-1:0] FILTER_OUT;
    wire ILL_P, ILL_N;
    reg ENABLE;
    pll_digital_loop_filter #(
        .BITS(FILTER_BITS),
        .INT_INIT(1 << (FILTER_BITS - 1)),
        .INVERT_PN(1)
    ) dlf (
        .CLK(!INJ_EDGE),
        .RST_N(RST_N), .ENABLE(ENABLE),
        .SS_BBPD(SS_BBPD),
        .KP(KP), .KI(KI),
        .OUT(FILTER_OUT),
        .ILL_P(ILL_P),
        .ILL_N(ILL_N)
    );

    wire [FINE_CODE_BITS-1:0] FILTER_DEC;
    generate
        if(IS_DSM) begin : dsm_impl
            wire DSM_CK;
            pll_fix_divider #(.DIV(DSM_DIV)) dsm_div (.clk(MID_OUT), .rst_n(RST_N), .out(DSM_CK));
            reg [FINE_CODE_BITS-1:0] FCWI;
            reg [FILTER_BITS-FINE_CODE_BITS:0] FCWF;
            always @(posedge DSM_CK or negedge RST_N) begin
                if(!RST_N) begin
                    FCWI <= 0;
                    FCWF <= 0;
                end else begin
                    // Skip 1 bit. The LSB will do the fractional part
                    FCWI <= {FILTER_OUT[FILTER_BITS-1:FILTER_BITS-FINE_CODE_BITS+1], 1'b0};
                    FCWF <= FILTER_OUT[FILTER_BITS-FINE_CODE_BITS:0];
                end     
            end
            delta_sigma #(
                .BITS_INT(FINE_CODE_BITS),
                .BITS_DSM(FILTER_BITS-FINE_CODE_BITS+1)
            ) dsm (
                .CK(DSM_CK),
                .RST(!RST_N),
                .EN_DSM(DCO_EN),
                .EN_DSM_DT(DSM_EN_DT),
                .EN_DSM_SHDT(DSM_EN_SHDT),
                .DSM_ORDER(DSM_ORDER),
                .FCWI(FCWI),
                .FCWF(FCWF),
                .DSM_OUT(FILTER_DEC)
            );
            always @(posedge DSM_CK or negedge RST_N) if(!RST_N) FINE_MUX <= 'd0; else FINE_MUX <= FINE_MUX_D; // For better in-time resolution
        end else begin
            assign FILTER_DEC = FILTER_OUT[FILTER_BITS-1:FILTER_BITS-FINE_CODE_BITS];
            always @(posedge CKR or negedge RST_N) if(!RST_N) FINE_MUX <= 'd0; else FINE_MUX <= FINE_MUX_D; // Just save energy
        end
    endgenerate

    pll_term_decoder_with_zero #(
        .NDELS(FINE_NDELS)
    ) dec (
        .IN(FILTER_DEC),
        .OUT(FINE_MUX_D)
    );

    // Freq locking stage
    reg START;
    // PHASE_LOCK is driven by the fine-stage phase detector.  It must not be
    // inferred from LOCKED_WAIT.  The detector samples the same edge as the
    // DLF and qualifies a window that contains both P and N; a stream that
    // stays one-sided, or a saturated fine filter, does not lock.  LOCK_LOST
    // covers a failed qualification window or filter saturation.  REF loss
    // is separate: the FSM is clocked by INJ_EDGE, which dies with REF, so a
    // watchdog on the free-running DCO is what clears LOCKED.  A stopped DCO
    // is the complementary case and is counted on REF, armed only after
    // locked_q is set.
    wire LOCK = PHASE_LOCK & FREQ_OK;
    wire REF_OK;
    wire DCO_OK;
    pll_ref_watchdog #(.TIMEOUT(REF_TIMEOUT)) ref_wd (
        .clk_count(OUT), .clk_watch(REF), .enable(1'b1),
        .rst_n(RST_N), .alive(REF_OK)
    );
    // REF is the only clock still running if OUT sticks.  OUT edges are
    // counted in a Gray code and sampled through two flops in REF.  A
    // binary counter would let REF sample a mixture of several changing
    // bits; Gray changes one bit per OUT edge, so every sample is a valid
    // word.  Any change of the sampled word means at least one OUT edge
    // happened, so no conversion or subtraction is needed.
    //
    // A stuck-high, stuck-low or stopped DCO leaves the word unchanged.
    // While locked_q is 0 the check stays healthy: acquisition may
    // legally run the DCO slower than REF.  10 bits hold 1024 edges
    // between REF samples, well above the 8-bit FCW range; an exact
    // 1024-edge alias would be needed to hide activity.
    localparam integer DCO_ACT_W = 10;
    localparam integer DCO_MISS_MAX = (DCO_TIMEOUT < 1) ? 1 :
        (DCO_TIMEOUT > 7) ? 7 : DCO_TIMEOUT;
    reg [DCO_ACT_W-1:0] out_edges;
    reg [DCO_ACT_W-1:0] out_edges_gray;
    // The watchdog only needs edge activity, not the exact edge count.  A
    // static /2 prescaler keeps the 10-bit Gray counter off the full-rate OUT
    // clock; the extra toggle flop is the only full-rate storage.
    reg out_div2;
    (* ASYNC_REG = "TRUE" *) reg [DCO_ACT_W-1:0] out_edges_g1;
    (* ASYNC_REG = "TRUE" *) reg [DCO_ACT_W-1:0] out_edges_g2;
    reg [DCO_ACT_W-1:0] out_edges_g2_q;
    reg [2:0] dco_miss_cnt;
    wire [DCO_ACT_W-1:0] out_edges_next = out_edges + 1'b1;
    always @(posedge OUT or negedge RST_N) begin
        if (!RST_N) out_div2 <= 1'b0;
        else        out_div2 <= ~out_div2;
    end
    always @(posedge out_div2 or negedge RST_N) begin
        if (!RST_N) begin
            out_edges <= 'd0;
            out_edges_gray <= 'd0;
        end else begin
            out_edges <= out_edges_next;
            out_edges_gray <= out_edges_next ^ (out_edges_next >> 1);
        end
    end
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            out_edges_g1 <= 'd0;
            out_edges_g2 <= 'd0;
            out_edges_g2_q <= 'd0;
            dco_miss_cnt <= 'd0;
        end else begin
            out_edges_g1 <= out_edges_gray;
            out_edges_g2 <= out_edges_g1;
            out_edges_g2_q <= out_edges_g2;
            if (!locked_q || (out_edges_g2 != out_edges_g2_q)) begin
                dco_miss_cnt <= 'd0;
            end else if (dco_miss_cnt < DCO_MISS_MAX) begin
                dco_miss_cnt <= dco_miss_cnt + 1'b1;
            end
        end
    end
    assign DCO_OK = (dco_miss_cnt < DCO_MISS_MAX);
    // ref_fail sticks until the FSM, which only runs while INJ_EDGE runs,
    // has dropped the lock flop and acknowledged.  Gating with the live
    // REF_OK level would reassert LOCKED on the first REF edge after an
    // outage, before the FSM had re-acquired.  dco_fail is the same sticky
    // for a stopped DCO; it is cleared by the same acknowledgement.
    reg ref_fail;
    reg dco_fail;
    reg clr_q, clr_qq;
    reg locked_q;
    reg clr_toggle;
    reg fail_q, fail_qq;
    assign LOCKED = locked_q & ~ref_fail & ~dco_fail;
    always @(posedge OUT or negedge RST_N) begin
        if (!RST_N) begin
            ref_fail <= 1'b0;
            clr_q <= 1'b0;
            clr_qq <= 1'b0;
        end else begin
            clr_q <= clr_toggle;
            clr_qq <= clr_q;
            if (!REF_OK)
                ref_fail <= 1'b1;
            else if (clr_q ^ clr_qq)
                ref_fail <= 1'b0;
        end
    end
    // DCO_OK is already a REF-domain level, and it is held healthy
    // whenever the check is disarmed.  Follow it directly.  Clearing
    // through clr_toggle races the sampler: the toggle is an INJ_EDGE
    // event, and a REF edge can set the sticky again before the FSM has
    // dropped locked_q.
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N)
            dco_fail <= 1'b0;
        else
            dco_fail <= ~DCO_OK;
    end
    always @(negedge INJ_EDGE or negedge RST_N) begin
        if (!RST_N) begin
            fail_q <= 1'b0;
            fail_qq <= 1'b0;
        end else begin
            fail_q <= ref_fail | dco_fail;
            fail_qq <= fail_q;
        end
    end
    reg FORCE_P, FORCE_N;

    pll_lock_detector #(
        .LOCK_COUNT(LOCK_COUNT),
        .LOSS_COUNT(LOSS_COUNT)
    ) lock_detector (
        // Same edge as pll_digital_loop_filter: the latch is transparent
        // during INJ_EDGE high, so its outputs are the phase decision
        // before INJ_EDGE falls.  Sampling on the other edge sees the
        // latch resolution state, not the decision.
        .CLK(!INJ_EDGE), .RST_N(RST_N), .ENABLE(ENABLE),
        .SS_BBPD(SS_BBPD), .ILL_P(ILL_P), .ILL_N(ILL_N),
        .PHASE_LOCK(PHASE_LOCK_W), .LOCK_LOST(LOCK_LOST_W)
    );
    pll_freq_lock #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .CNT_BITS(FCW_BITS),
        .CNT_EXTRA_BITS(CNT_EXTRA_BITS),
        .MEAS_PERIODS(MEAS_PERIODS),
        .LOCK_TOL(LOCK_TOL)
    ) flock (
        .REF(REF), .MID_OUT(MID_OUT), .OUT(OUT),
        .RST_N(RST_N),
        .FCW(FCW), .START(START),
        .LOCK(LOCK),
        .FORCE_P(FORCE_P), .FORCE_N(FORCE_N),
        .LOCKED(FREQ_LOCKED_W), .ERR(FREQ_ERR_W), .FREQ_OK(FREQ_OK_W),
        .COARSE_MUX(COARSE_MUX_D),
        .MID_MUX(MID_MUX_D)
    );

    // State machine.
    reg [2:0] state;
    reg [7:0] cnt;
    reg [7:0] cntf;
    always @(negedge INJ_EDGE or negedge RST_N) begin
        if(!RST_N) begin
            state <= 3'b000;
            START <= 1'b0;
            cnt <= 'd0;
            cntf <= 'd0;
            locked_q <= 1'b0;
            clr_toggle <= 1'b0;
            ERR <= 1'b0;
            DCO_EN <= 1'b0;
            ENABLE <= 1'b0;
            FORCE_P <= 1'b0;
            FORCE_N <= 1'b0;
        end else begin
            case(state)
                3'b000: begin  // Init. Do nothing
                    cnt <= cnt + 1;
                    DCO_EN <= 1'b1;
                    if(cnt[3]) begin 
                        state <= 3'b001;
                        START <= 1'b1;
                        cnt <= 'd0;
                        ENABLE <= 1'b1; // Enable the filter here
                    end
                end
                3'b001: begin  // Waiting for the freq locking
                    START <= 1'b0;
                    if(!START) begin
                        // FREQ_LOCKED is sticky.  FREQ_OK is the live
                        // window, and it is what keeps a stale acquisition
                        // result from opening the phase-lock wait.
                        if(FREQ_LOCKED && FREQ_OK) begin
                            state <= 3'b010;
                        end
                        else if(FREQ_ERR) state <= 3'b100;
                        else if(FREQ_LOCKED && !FREQ_OK) begin
                            // The count left the window after the FLL had
                            // latched.  Restart the frequency search; the
                            // sticky flag alone would wait forever.
                            START <= 1'b1;
                        end
                    end
                end
                3'b010: begin  // Wait for phase locking
                    FORCE_P <= 1'b0;
                    FORCE_N <= 1'b0;
                    if(LOCK_LOST || fail_qq || !FREQ_OK) begin
                        // Phase failure, the watchdog sticky, or a count
                        // that has left the FCW window.  fail_qq is the
                        // DCO-domain flag after two INJ_EDGE flops, so it
                        // is only visible once REF (and therefore INJ_EDGE)
                        // is running again.  While REF is stopped, LOCKED is
                        // already low because of ref_fail.  A phase-detector
                        // event stays in phase acquisition; a frequency or
                        // watchdog failure goes back to frequency acquisition.
                        state <= (LOCK_LOST && !fail_qq && FREQ_OK) ? 3'b010 : 3'b001;
                        cnt <= 'd0;
                        cntf <= 'd0;
                        locked_q <= 1'b0;
                        if (fail_qq)
                            clr_toggle <= ~clr_toggle;
                    end else if((cnt == LOCKED_WAIT) && PHASE_LOCK && !fail_qq) begin
                        state <= 3'b011;
                        cnt <= 'd0;
                        locked_q <= 1'b0; // asserted only in the LOCKED state
                    end else begin  // Logic for force count up/down whenever the illegal positive/negative is triggered
                        if(ILL_P || ILL_N) begin
                            cntf <= cntf + 1;
                            cnt <= 'd0;
                            if(cntf == FILTER_ILL) begin
                                // Activate one of the FORCE_P/FORCE_N
                                if(ILL_P) FORCE_P <= 1'b1;
                                else if(ILL_N) FORCE_N <= 1'b1;
                                cntf <= 'd0;
                            end
                        end else begin
                            cntf <= 'd0;
                            cnt <= cnt + 1;
                        end
                    end
                end
                3'b011: begin  // Locked state, but only while the phase detector agrees
                    // REF loss drops straight out.  The FSM cannot notice
                    // this on its own once INJ_EDGE has stopped, so the
                    // watchdog output is the input that still toggles.
                    if(fail_qq) begin
                        state <= 3'b001;
                        cnt <= 'd0;
                        cntf <= 'd0;
                        locked_q <= 1'b0;
                        clr_toggle <= ~clr_toggle;
                    end else if(!FREQ_OK) begin
                        // Quiet BBPD with the count outside the FCW window
                        // is not a lock.  Re-enter frequency acquisition.
                        state <= 3'b001;
                        cnt <= 'd0;
                        cntf <= 'd0;
                        locked_q <= 1'b0;
                    end else if(LOCK_LOST || !PHASE_LOCK) begin
                        state <= 3'b010;
                        cnt <= 'd0;
                        cntf <= 'd0;
                        locked_q <= 1'b0;
                    end else begin
                        state <= 3'b011;
                        locked_q <= 1'b1;
                    end
                end
                3'b100: begin  // Error state
                    state <= 3'b100;
                    ERR <= 1'b1;
                end
                default:
                    state <= 3'b100; // Go to the error state
            endcase
        end
    end
    
`ifndef PLL_WITHOUT_DIVIDER
    // OUT_DIV is the raw integer divider (loop observability).
    // CK is the DDR pad clock: quiet until lock, even divisors only.
    //
    // The divider and the CK gate are clocked by OUT, which only starts
    // after the FSM releases DCO_EN.  The external RST_N is already high by
    // then, so an async reset alone never sees a clock edge while reset is
    // low and the registers stay X.  Hold a local reset for 16 OUT edges
    // after RST_N deasserts so the first edges initialize both blocks.
    reg [3:0] div_rst_cnt;
    reg div_rst_n;
    always @(posedge OUT or negedge RST_N) begin
        if (!RST_N) begin
            div_rst_cnt <= 'd0;
            div_rst_n <= 1'b0;
        end else if (!div_rst_n) begin
            if (div_rst_cnt == 4'hf)
                div_rst_n <= 1'b1;
            else
                div_rst_cnt <= div_rst_cnt + 1'b1;
        end
    end
    wire div_raw;
    wire [DIV_BITS-1:0] div_q;
    pll_mod_divider #(.W(DIV_BITS), .DIV_INIT(DIV_INIT)) div(
        .clk(OUT),
        .rst_n(div_rst_n),
        .set_div(SET_DIV),
        .load_div(LOAD_DIV),
        .out(div_raw),
        .div_q(div_q)
    );
    assign OUT_DIV = div_raw;
    ddr_ck_gate #(.W(DIV_BITS)) u_ddr_ck (
        .clk_div(div_raw),
        .locked(LOCKED),
        .rst_n(div_rst_n),
        .div(div_q),
        .ck(CK)
    );
`endif

endmodule
`default_nettype wire
