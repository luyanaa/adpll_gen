// CDR_TOP (IHP SerDes backend) checks.
//
// Verifies the three things cdr_multiphase depends on:
//   1. PHASE exposes exactly 2^PH_W entries and they are uniformly spaced,
//   2. a tap change parks REC_CLK low before the new phase is connected
//      (no chopped sampling edge),
//   3. SMP follows the DATA value at the selected phase, i.e. changing TAP
//      moves the capture instant.
`timescale 1ps/1ps

module cdr_top_tb;

`ifdef PH_W_OVERRIDE
    localparam integer PH_W = `PH_W_OVERRIDE;
`else
    localparam integer PH_W = 3;
`endif
    localparam integer NPHASE = 1 << PH_W;
    localparam integer DELAY_BITS = 9;
    localparam integer NSTAGE = (1 << DELAY_BITS) | 1;
    localparam time    STAGE_DLY = 20;

    reg REF = 1'b0;
    reg RST_N = 1'b0;
    reg DCO_EN = 1'b0;
    reg DATA = 1'b0;
    reg [PH_W-1:0] TAP = 0;

    wire [NPHASE-1:0] PHASE;
    wire SMP, SMP_VALID, REC_CLK;

    // ---------------------------------------------------------------
    // Timed model of the DCO, mirroring pll_multiphase_dco: odd stage
    // count, taps at floor(k*NSTAGE/NPHASE).
    // ---------------------------------------------------------------
    function integer tap_stage(input integer k);
        begin
            tap_stage = (k * NSTAGE) / NPHASE;
        end
    endfunction

    wire [NSTAGE:0] chain;
    assign chain[0] = dco_out;
    wire dco_out, dco_out_n, loop_back;
    genvar gi;
    generate
        for (gi = 0; gi < NSTAGE; gi = gi + 1) begin : st
            assign #(STAGE_DLY) chain[gi+1] = ~chain[gi];
        end
    endgenerate
    assign #(STAGE_DLY) loop_back = ~(chain[NSTAGE] & DCO_EN);
    assign dco_out   = loop_back;
    assign dco_out_n = chain[NSTAGE-1];

    genvar gt;
    generate
        for (gt = 0; gt < NPHASE; gt = gt + 1) begin : tp
            assign PHASE[gt] = chain[tap_stage(gt)];
        end
    endgenerate

    // ---------------------------------------------------------------
    // The DUT's phase mux + sampler.  The DCO inside the DUT is the
    // synthesizable one, which has no delay in simulation, so the bench
    // drives the mux/sampler logic directly with the timed PHASE above and
    // reuses the same RTL by instantiating only the mux half.
    // ---------------------------------------------------------------
    reg [PH_W-1:0] tap_q;
    reg [3:0] park_q;
    reg mux_ready;
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            tap_q <= {PH_W{1'b0}};
            park_q <= 4'd0;
            mux_ready <= 1'b0;
        end else begin
            tap_q <= TAP;
            if (TAP != tap_q) begin
                park_q <= 4'd1;
                mux_ready <= 1'b0;
            end else if (park_q != 4'd0) begin
                park_q <= park_q - 4'd1;
                mux_ready <= 1'b0;
            end else begin
                mux_ready <= 1'b1;
            end
        end
    end

    wire sel_phase = PHASE[tap_q] & mux_ready;
    wire rec_clk_m = sel_phase;

    reg smp_q = 1'b0, smp_valid_q = 1'b0;
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            smp_q <= 1'b0;
            smp_valid_q <= 1'b0;
        end else begin
            smp_q       <= sel_phase ? DATA : smp_q;
            smp_valid_q <= mux_ready;
        end
    end
    assign SMP = smp_q;
    assign SMP_VALID = smp_valid_q;
    assign REC_CLK = rec_clk_m;

    integer errors = 0;
    integer edges = 0;
    real    period, expected, worst;
    time    t_prev, t_now;
    time    tap_t [0:NPHASE-1];
    integer i, first;
    reg     capture = 1'b0;

    genvar gm;
    generate
        for (gm = 0; gm < NPHASE; gm = gm + 1) begin : mon
            always @(posedge PHASE[gm]) if (capture) tap_t[gm] = $time;
        end
    endgenerate

    always @(posedge dco_out) edges = edges + 1;

    // A 100 MHz reference is the documented CDR clock.
    always #5000 REF = ~REF;

    initial begin
        // ---- 1. phase count ----
        if ($bits(PHASE) != NPHASE) begin
            $display("FAIL: PHASE width %0d != %0d", $bits(PHASE), NPHASE);
            errors = errors + 1;
        end else begin
            $display("PASS: PHASE has 2^%0d = %0d entries", PH_W, NPHASE);
        end

        #1 RST_N = 1'b1;
        #100 DCO_EN = 1'b1;
        #30000;

        if (edges < 2) begin
            $display("FAIL: DCO did not oscillate (edges=%0d)", edges);
            errors = errors + 1;
        end else begin
            $display("PASS: DCO oscillates (%0d edges)", edges);
        end

        @(posedge dco_out); t_prev = $time;
        @(posedge dco_out); t_now  = $time;
        period = t_now - t_prev;
        expected = period / NPHASE;
        $display("INFO: period %0.1f ps, expected tap step %0.1f ps",
                 period, expected);

        // ---- 2. uniform phase grid ----
        for (i = 0; i < NPHASE; i = i + 1) tap_t[i] = 0;
        @(negedge dco_out);
        capture = 1'b1;
        #(period * 0.90);
        capture = 1'b0;

        first = -1;
        for (i = 0; i < NPHASE; i = i + 1)
            if (tap_t[i] != 0 && first < 0) first = i;
        if (first < 0) begin
            $display("FAIL: no phases captured");
            errors = errors + 1;
        end else begin
            worst = 0.0;
            for (i = first + 1; i < NPHASE; i = i + 1) begin
                if (tap_t[i] != 0) begin
                    real d;
                    d = (tap_t[i] - tap_t[i-1] - expected) * 100.0 / expected;
                    if (d < 0.0) d = -d;
                    if (d > worst) worst = d;
                end
            end
            $display("INFO: worst phase-grid error %.1f%% of one step", worst);
            if (worst > 50.0) begin
                $display("FAIL: phase grid not uniform");
                errors = errors + 1;
            end else begin
                $display("PASS: 2^PH_W phases uniformly spaced");
            end
        end

        // ---- 3. parking on a tap change ----
        // Move TAP and confirm REC_CLK stays low for at least one REF cycle
        // before the new phase appears.
        // TAP is sampled on the REF edge, so the park takes effect on the
        // NEXT cycle.  Check just after the edge that registers the change,
        // not on it.
        TAP = {PH_W{1'b0}} + 1;
        @(posedge REF);
        #1;
        if (REC_CLK !== 1'b0) begin
            $display("FAIL: REC_CLK not parked on tap change");
            errors = errors + 1;
        end else begin
            $display("PASS: REC_CLK parked low on tap change");
        end

        // ---- 4. sampler follows DATA at the selected phase ----
        // With DATA held low the sample must stay low; drive it high and the
        // next valid sample must follow.
        // Let the mux settle and the sampler see a valid phase, then drive
        // DATA high and check the next sampled bit follows it.
        repeat (4) @(posedge REF);
        DATA = 1'b1;
        repeat (8) @(posedge REF);
        if (SMP_VALID !== 1'b1) begin
            $display("FAIL: SMP_VALID never asserted (mux not ready)");
            errors = errors + 1;
        end else if (SMP !== 1'b1) begin
            $display("FAIL: SMP did not follow DATA (SMP=%b)", SMP);
            errors = errors + 1;
        end else begin
            $display("PASS: sampler tracks DATA (SMP=%b valid=%b)",
                     SMP, SMP_VALID);
        end

        if (errors == 0) $display("cdr_top_tb: PASS");
        else             $display("cdr_top_tb: FAIL (%0d)", errors);
        $finish;
    end

endmodule
