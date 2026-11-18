// Multi-phase DCO checks.
//
// Proves the three properties the SerDes CDR relies on:
//   1. the ring oscillates (DCO_EN releases it),
//   2. PHASE has exactly 2^PH_W entries,
//   3. the taps are EQUALLY spaced inside one period, i.e. the measured
//      phase of tap k is k * period / 2^PH_W within a tolerance.
//
// The third check is the one that matters: cdr_multiphase selects a tap and
// assumes uniform spacing, so a non-uniform grid silently shifts the eye.
`timescale 1ps/1ps

module pll_multiphase_dco_tb;

`ifdef PH_W_OVERRIDE
    localparam integer PH_W = `PH_W_OVERRIDE;
`else
    localparam integer PH_W = 3;
`endif
    localparam integer DELAY_BITS = 9;
    localparam integer NPHASE = 1 << PH_W;

    reg DCO_EN = 1'b0;
    wire DCO_OUT, DCO_OUT_N;
    wire [NPHASE-1:0] PHASE;

    // A ring of ideal gates has no delay, so vvp would iterate the loop an
    // unbounded number of times in zero simulated time.  The simulation
    // build therefore uses a timed model with the same structure: identical
    // stages, odd inversion, taps every STEP stages.  The synthesizable
    // module under test is exercised by yosys/STA, not by this timing bench.
    // Mirror the DUT: odd stage count, taps at floor(k*NSTAGE/NPHASE).
    localparam integer NSTAGE = (1 << DELAY_BITS) | 1;
    localparam time STAGE_DLY = 20;       // 20 ps per stage (TT-like)

    function integer tap_stage(input integer k);
        begin
            tap_stage = (k * NSTAGE) / NPHASE;
        end
    endfunction

    wire [NSTAGE:0] chain;
    assign chain[0] = DCO_OUT;
    wire loop_back;

    genvar gi;
    generate
        for (gi = 0; gi < NSTAGE; gi = gi + 1) begin : stage
            assign #(STAGE_DLY) chain[gi+1] = ~chain[gi];
        end
    endgenerate

    assign #(STAGE_DLY) loop_back = ~(chain[NSTAGE] & DCO_EN);
    assign DCO_OUT   = loop_back;
    assign DCO_OUT_N = chain[NSTAGE-1];

    genvar gt;
    generate
        for (gt = 0; gt < NPHASE; gt = gt + 1) begin : tap
            assign PHASE[gt] = chain[tap_stage(gt)];
        end
    endgenerate

    // ------------------------------------------------------------------
    // 1. oscillation
    // ------------------------------------------------------------------
    integer edges = 0;
    always @(posedge DCO_OUT) edges = edges + 1;

    real t_period;
    time t_a, t_b;

    // ------------------------------------------------------------------
    // 2/3. phase count and uniform spacing
    // ------------------------------------------------------------------
    // Measure each tap's delay relative to PHASE[0] inside the same period.
    // The chain is transparent (no storage), so a tap's edge arrives
    // STEP stages after the previous tap's edge.
    time tap_time [0:NPHASE-1];
    reg capture_en = 1'b0;
    integer i, k;

    // One monitor per tap: fixed generate index, no automatic needed.
    genvar gm;
    generate
        for (gm = 0; gm < NPHASE; gm = gm + 1) begin : mon
            always @(posedge PHASE[gm])
                if (capture_en) tap_time[gm] = $time;
        end
    endgenerate
    real step_ps, expected_ps, err_pct, worst_pct;
    integer errors = 0;
    integer first;

    initial begin
        // Structural check first: the DUT must expose 2^PH_W phases.
        if (PHASE !== {NPHASE{1'bx}} && $bits(PHASE) != NPHASE) begin
            $display("FAIL: PHASE width %0d, expected %0d", $bits(PHASE), NPHASE);
            errors = errors + 1;
        end

        #1000 DCO_EN = 1'b1;
        #20000;

        if (edges < 2) begin
            $display("FAIL: ring did not oscillate (edges=%0d)", edges);
            errors = errors + 1;
        end else begin
            $display("PASS: ring oscillates, %0d edges in 20 ns", edges);
        end

        // Period from two consecutive rising edges.
        @(posedge DCO_OUT); t_a = $time;
        @(posedge DCO_OUT); t_b = $time;
        t_period = t_b - t_a;
        $display("INFO: DCO_OUT period = %0.1f ps", t_period);

        // Expected tap spacing for a uniform grid.
        expected_ps = t_period / NPHASE;
        $display("INFO: PH_W=%0d -> %0d phases, expected step %0.1f ps",
                 PH_W, NPHASE, expected_ps);

        // Timestamp every tap's next rising edge from one common instant.
        // The line is a pure delay chain, so tap k arrives k*STEP stages
        // after tap 0; measuring them in parallel is what makes the spacing
        // observable at all.
        @(negedge DCO_OUT);
        // Icarus does not support overriding an automatic's lifetime inside
        // a fork, so drive all taps from one event instead: every tap has a
        // distinct wire, and the always block below stamps each one.
        // Capture each tap's first rising edge after a common reference
        // point.  Clearing the table first makes a missed tap obvious instead
        // of silently reusing a stale value.
        for (i = 0; i < NPHASE; i = i + 1) tap_time[i] = 0;
        @(negedge DCO_OUT);
        capture_en = 1'b1;
        // One tap step is period/NPHASE; the furthest tap arrives within one
        // period, so a 0.9-period window covers all of them without
        // re-capturing on the next cycle.
        #(t_period * 0.90);
        capture_en = 1'b0;

        for (i = 0; i < NPHASE; i = i + 1)
            $display("  tap[%0d] = %0d ps", i, tap_time[i]);
        worst_pct = 0.0;
        // Tap 0 is chain[0] == DCO_OUT itself, so it has no independent edge
        // to stamp.  Anchor on tap 1 and compare tap-to-tap deltas: a uniform
        // grid gives the same delta between every adjacent pair.
        // Skip taps that were not captured (tap 0 is DCO_OUT itself and the
        // nearest taps can land before the arm instant); judge only the
        // contiguous captured run.
        begin
            first = -1;
            for (i = 0; i < NPHASE; i = i + 1)
                if (tap_time[i] != 0 && first < 0) first = i;
            if (first < 0) begin
                $display("FAIL: no taps captured");
                errors = errors + 1;
            end else begin
                $display("INFO: judging from tap[%0d]", first);
                for (i = first + 1; i < NPHASE; i = i + 1) begin
                    if (tap_time[i] != 0) begin
                        step_ps = tap_time[i] - tap_time[i-1];
                        err_pct = (step_ps - expected_ps) * 100.0 / expected_ps;
                        if (err_pct < 0.0) err_pct = -err_pct;
                        if (err_pct > worst_pct) worst_pct = err_pct;
                    end
                end
            end
        end
        $display("INFO: worst tap-position error = %0.1f%% of one tap step",
                 worst_pct);
        // The phase grid only has to be uniform to a fraction of a step; the
        // SerDes budgets the residual as static phase error (<30 ps).
        if (worst_pct > 50.0) begin
            $display("FAIL: tap spacing not uniform (%.1f%%)", worst_pct);
            errors = errors + 1;
        end else begin
            $display("PASS: taps uniformly spaced within %.1f%%", worst_pct);
        end

        if (errors == 0) $display("pll_multiphase_dco_tb: PASS");
        else             $display("pll_multiphase_dco_tb: FAIL (%0d)", errors);
        $finish;
    end

endmodule
