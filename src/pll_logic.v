`default_nettype none
// The digital synthesizable part of the PLL

module pll_logic#(
    parameter integer COARSE_NDELS = 15, // 4-bit coarse
    parameter integer MID_NDELS = 15, // 4-bit mid
    parameter integer FINE_NDELS = 31, // 5-bit fine
    parameter integer FILTER_BITS = 16,
    parameter integer IS_DSM = 1,
    // MID_OUT/2 fails setup post-route (-1.14 ns SS, dsmdiv2_macro run);
    // /4 doubles that period and is the only closing value.  The
    // noise-shaping sample rate halves with it.
    parameter integer DSM_DIV = 4,
    parameter integer LOCKED_WAIT = 64,
    parameter integer FILTER_ILL = 16,
    // Counts of the lock-window sum, not counts per REF.  The Gray
    // synchronizer holds the sampled word for two REF edges, so the delta on
    // the edge that opens a window and the delta on the edge that closes it
    // each belong to the neighbouring window.  Measured on an exact FCW=16
    // ratio that comes out as a sum 6 or 7 below the ideal 4096, every
    // window, so the tolerance has to clear that floor.  8 does, and it is
    // still far inside half a count per REF (128 counts over the 256-REF
    // window, the +3.1% the old window accepted).  One count of the window
    // is about 244 ppm at FCW=16, so the accepted band is about +/-2000 ppm.
    parameter integer LOCK_TOL = 8,
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
    // REF periods summed into one lock-window sample.  256 of a ratio near
    // 16 is one count of resolution, about 244 ppm, which is inside the fine
    // bank's span.  1 restores the old per-REF window.
    parameter integer LOCK_WINDOW = 256,
    // Gear shifting: when 1 the FSM switches the DLF from the external
    // KP/KI ports (acquisition gain) to the tracking gains below once it
    // reaches state 011 (locked).  0 keeps the port values in both phases,
    // the historical behaviour.  The defaults below come from
    // src/dlf_design.py at f_ref=100 MHz, K_DCO_fine=55 kHz/code,
    // sigma_t=4 ps, D=3 REF cycles: acquisition fc* = f_ref/20,
    // tracking fc* = f_ref/80 (PM ~60 deg).  They are 16-bit FILTER LSBs,
    // the same units as the KP/KI ports.
    parameter integer GEAR_SHIFT = 1,
    parameter integer KP_TRACK = 1148,
    parameter integer KI_TRACK = 23,
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
    // Gear-shifted gains.  The FSM drives `gear_track`; the mux is a plain
    // select so the extra LUT stays off the DLF->DSM path (it feeds the
    // same KP/KI pins the ports always did).
    reg gear_track;
    wire [FILTER_BITS-1:0] KP_EFF = (GEAR_SHIFT && gear_track) ? KP_TRACK[FILTER_BITS-1:0] : KP;
    wire [FILTER_BITS-1:0] KI_EFF = (GEAR_SHIFT && gear_track) ? KI_TRACK[FILTER_BITS-1:0] : KI;
    pll_digital_loop_filter #(
        .BITS(FILTER_BITS),
        .INT_INIT(1 << (FILTER_BITS - 1)),
        .INVERT_PN(1),
        .REG_OUT(1)
    ) dlf (
        .CLK(!INJ_EDGE),
        .RST_N(RST_N), .ENABLE(ENABLE),
        .SS_BBPD(SS_BBPD),
        .KP(KP_EFF), .KI(KI_EFF),
        .OUT(FILTER_OUT),
        .ILL_P(ILL_P),
        .ILL_N(ILL_N)
    );

    wire [FINE_CODE_BITS-1:0] FILTER_DEC;
    wire [FINE_CODE_BITS-1:0] FILTER_DEC_RAW;
    generate
        if(IS_DSM) begin : dsm_impl
            wire DSM_CK;
            pll_fix_divider #(.DIV(DSM_DIV)) dsm_div (.clk(MID_OUT), .rst_n(RST_N), .out(DSM_CK));
            // The fine bank is the only actuator the bang-bang phase loop has,
            // and FINE_MUX, the thermometer decoder and the DSM all sit on
            // this clock.  Gating it off once LOCKED froze the fine code, so
            // the residual the FLL hands over (up to half a count per REF,
            // ~3% at FCW=16) had nothing left to trim it.  The SerDes
            // bang-bang tracks about +/-1000 ppm, ~30x tighter than that.
            //
            // The gate stays, but only for the divider's reset release.  OUT
            // starts after the FSM sets DCO_EN, by which time the external
            // RST_N is already high, so the divider's first edges come out of
            // X.  Two DSM_CK edges after reset are enough for its own
            // registers to leave reset; after that the clock runs for good,
            // locked or not.  The enable is computed here in the DSM_CK
            // domain, so no LOCKED crossing reaches the gate.
            // Startup delay for the ICG enable.  dsm_run must rise ~2 DSM_CK
            // edges after reset so the divider (dsm_div) leaves X before
            // DSM_CK_G turns on.  Count it in the MID_OUT domain, not on
            // DSM_CK: DSM_CK is the divider output, not a declared clock, so
            // flops clocked by it are "unclocked" in STA (the _4504_/_4505_
            // hole); declaring DSM_CK as a clock instead makes CTS build a
            // second tree that cascades with the DSM_CK_G tree (B20/B23).
            // DSM_CK = MID_OUT/DSM_DIV, so 2 DSM_CK posedges = 2*DSM_DIV
            // MID_OUT edges; counting that many MID_OUT edges guarantees both
            // posedges occurred.  The few extra MID_OUT edges only postpone
            // the noise-shaping start, irrelevant at a ~1 MHz loop bandwidth.
            localparam integer DSM_RUN_EDGES = 2*DSM_DIV;
            // Minimal width: need to count 0..2*DSM_DIV.
            localparam integer DSM_RUN_W = (DSM_RUN_EDGES < 2) ? 1 : $clog2(DSM_RUN_EDGES + 1);
            reg [DSM_RUN_W-1:0] dsm_run_cnt;
            wire dsm_run = (dsm_run_cnt >= DSM_RUN_EDGES);
            always @(posedge MID_OUT or negedge RST_N) begin
                if (!RST_N)
                    dsm_run_cnt <= {DSM_RUN_W{1'b0}};
                else if (!dsm_run)
                    dsm_run_cnt <= dsm_run_cnt + 1'b1;
            end
            wire DSM_CK_G;
            PLL_CLKGATE u_dsm_icg (
                .EN(dsm_run), .CLK(DSM_CK), .GCLK(DSM_CK_G)
            );
            // DCO_EN is generated in the INJ_EDGE domain (_4240_, a negedge
            // register) and used here as delta_sigma's clock enable.  That makes
            // it a cross-domain connection, and once the negedge clocks are
            // declared STA times it and fails hold:
            //   _4240_/Q -> fanout116 -> _2425_/A1 -> _2425_/Y -> _4316_/D
            //   hold -0.4039
            // Six SDC exemption forms were tried and none closed it (the pair is
            // reached through more than one cone), so synchronise it here the
            // same way LOCKED is synchronised above.
            //
            // EN_DSM is a level, not an edge: delaying it by two DSM_CK_G periods
            // only postpones the noise-shaping start, which is irrelevant at a
            // ~1 MHz loop bandwidth.  Reset releases the enable to 1 so the DSM
            // is not held off during reset.
            (* ASYNC_REG = "TRUE" *) reg dco_en_dsm_s1, dco_en_dsm_s2;
            always @(posedge DSM_CK_G or negedge RST_N) begin
                if (!RST_N) begin
                    dco_en_dsm_s1 <= 1'b1;
                    dco_en_dsm_s2 <= 1'b1;
                end else begin
                    dco_en_dsm_s1 <= DCO_EN;
                    dco_en_dsm_s2 <= dco_en_dsm_s1;
                end
            end
            wire DCO_EN_DSM = dco_en_dsm_s2;

            reg [FINE_CODE_BITS-1:0] FCWI;
            reg [FILTER_BITS-FINE_CODE_BITS:0] FCWF;
            always @(posedge DSM_CK_G or negedge RST_N) begin
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
                .CK(DSM_CK_G),
                .RST(!RST_N),
                .EN_DSM(DCO_EN_DSM),
                .EN_DSM_DT(DSM_EN_DT),
                .EN_DSM_SHDT(DSM_EN_SHDT),
                .DSM_ORDER(DSM_ORDER),
                .FCWI(FCWI),
                .FCWF(FCWF),
                .DSM_OUT(FILTER_DEC_RAW)
            );
            // Split the DSM adder chain from the thermometer decode.
            //
            // Measured path (SS, -6.14 ns, 101 of 181 paths):
            //   dsm.dff_err3[11] -> sum/err adder -> FILTER_DEC
            //     -> pll_term_decoder_with_zero ((1<<IN)-1, 31 bits, no reg)
            //     -> FINE_MUX_D -> FINE_MUX (DSM_CK_G)
            //
            // Registering the DECODER OUTPUT does not help: the adder and the
            // decode are still in series in the same cycle.  The register has
            // to sit on FILTER_DEC, which is the actual boundary -- delta_sigma
            // documents its output as combinational ("Register outside").
            //
            // Cost: one DSM_CK of fine-update latency, irrelevant at a
            // ~1 MHz loop bandwidth.  The DSM noise-shaping maths is untouched.
            reg [FINE_CODE_BITS-1:0] FILTER_DEC_Q;
            always @(posedge DSM_CK_G or negedge RST_N)
                if (!RST_N) FILTER_DEC_Q <= 'd0;
                else        FILTER_DEC_Q <= FILTER_DEC_RAW;
            assign FILTER_DEC = FILTER_DEC_Q;

            always @(posedge DSM_CK_G or negedge RST_N) if(!RST_N) FINE_MUX <= 'd0; else FINE_MUX <= FINE_MUX_D; // For better in-time resolution
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
    // ref_fail lives in the REF domain, like dco_fail.  REF_OK is produced
    // by pll_ref_watchdog on REF, so the sticky bit needs no crossing; and
    // the OUT domain version had no logic in its own feedback, so the
    // timing-repair pass filled it with a ten-deep BUFX1P4 chain that became
    // the last ics55 SS setup violator (ref_fail -> rebuffer58x -> ref_fail/D,
    // -0.44 ns).  LOCKED already mixes domains combinationally (locked_q is
    // OUT, dco_fail is REF), so this does not add a new crossing.
    reg ref_fail;
    reg dco_fail;
    (* ASYNC_REG = "TRUE" *) reg clr_r1, clr_r2, clr_r3;
    reg locked_q;
    reg clr_toggle;
    reg fail_q, fail_qq;
    // REF_OK is the live watchdog output (OUT domain).  It is needed in the
    // gate because ref_fail is registered on REF: if REF stops, there is no
    // posedge REF to latch !REF_OK, so the sticky alone can never drop
    // LOCKED.  locked_q is in the INJ_EDGE domain, which also dies with REF.
    // The sticky is still required for the returning-REF case: REF_OK comes
    // back before the FSM acknowledges, and ~ref_fail holds LOCKED low until
    // it does, so this level term cannot re-assert lock early.
    assign LOCKED = locked_q & ~ref_fail & ~dco_fail & REF_OK;
    // clr_toggle is toggled by the INJ_EDGE-domain FSM; synchronize it into
    // REF and clear the sticky on the detected edge.
    wire clr_r_edge = clr_r2 ^ clr_r3;
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            ref_fail <= 1'b0;
            clr_r1 <= 1'b0;
            clr_r2 <= 1'b0;
            clr_r3 <= 1'b0;
        end else begin
            clr_r1 <= clr_toggle;
            clr_r2 <= clr_r1;
            clr_r3 <= clr_r2;
            if (!REF_OK)
                ref_fail <= 1'b1;
            else if (clr_r_edge)
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
        .LOCK_WINDOW(LOCK_WINDOW),
        .LOCK_TOL(LOCK_TOL),
        .FRONTEND_MODE(3),
        .PRESCALE(2)
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
            gear_track <= 1'b0;
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
                    // Tracking gear: once the loop is locked the DLF drops
                    // to KP_TRACK/KI_TRACK (narrower bandwidth, ~60 deg PM).
                    // Any exit back to acquisition restores the port gains.
                    gear_track <= 1'b1;
                    // REF loss drops straight out.  The FSM cannot notice
                    // this on its own once INJ_EDGE has stopped, so the
                    // watchdog output is the input that still toggles.
                    if(fail_qq) begin
                        state <= 3'b001;
                        cnt <= 'd0;
                        cntf <= 'd0;
                        locked_q <= 1'b0;
                        gear_track <= 1'b0;
                        clr_toggle <= ~clr_toggle;
                    end else if(!FREQ_OK) begin
                        // Quiet BBPD with the count outside the FCW window
                        // is not a lock.  Re-enter frequency acquisition.
                        state <= 3'b001;
                        cnt <= 'd0;
                        cntf <= 'd0;
                        locked_q <= 1'b0;
                        gear_track <= 1'b0;
                    end else if(LOCK_LOST || !PHASE_LOCK) begin
                        state <= 3'b010;
                        cnt <= 'd0;
                        cntf <= 'd0;
                        locked_q <= 1'b0;
                        gear_track <= 1'b0;
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
    // div_rst_n is split into two posedge copies (div_rst_n/div_rst_n_b)
    // driving separate reset ports on the divider.  One net feeding ~50
    // async-clear pins left the deassert deep in the recovery window (-0.09
    // ns SS); two equal registers halve each net's fanout.  A negedge
    // release was tried and rejected -- it halves the recovery window for
    // the very flops it was meant to help (74 violations at -0.29).
    reg div_rst_n, div_rst_n_b;
    always @(posedge OUT or negedge RST_N) begin
        if (!RST_N) begin
            div_rst_cnt <= 'd0;
            div_rst_n   <= 1'b0;
            div_rst_n_b <= 1'b0;
        end else if (!div_rst_n) begin
            if (div_rst_cnt == 4'hf) begin
                div_rst_n   <= 1'b1;
                div_rst_n_b <= 1'b1;
            end else begin
                div_rst_cnt <= div_rst_cnt + 1'b1;
            end
        end
    end
    wire div_raw;
    wire div_even;
    wire [DIV_BITS-1:0] div_q;
    pll_mod_divider #(.W(DIV_BITS), .DIV_INIT(DIV_INIT)) div(
        .clk(OUT),
        .rst_n(div_rst_n),
        .rst_n2(div_rst_n_b),
        .set_div(SET_DIV),
        .load_div(LOAD_DIV),
        .out(div_raw),
        .div_q(div_q),
        .div_even(div_even)
    );
    assign OUT_DIV = div_raw;
    ddr_ck_gate #(.W(DIV_BITS)) u_ddr_ck (
        .clk_div(div_raw),
        .locked(LOCKED),
        .rst_n(div_rst_n),
        .div(div_q),
        .div_even(div_even),
        .ck(CK)
    );
`endif

endmodule
`default_nettype wire
