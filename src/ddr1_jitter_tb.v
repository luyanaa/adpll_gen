`timescale 1ns/1ps
// DDR1 clock-chain jitter measurement testbench (pass-2 spec evidence).
//
// The DDR1 requirement: period jitter <= 100 ps pk-pk, cycle-to-cycle
// <= 50 ps, and "no jitter data => timing margin may not be called closed".
// This TB produces the data with an explicit measurement methodology:
//
//   * periods are measured at the OUTPUT pins of DDR1_CLOCK_TOP
//     (CK_PHY, CK90_PHY) rising-edge to rising-edge, post-lock, over
//     NJ cycles;
//   * period jitter   = max(T_i) - min(T_i)        (pk-pk, spec 100 ps)
//   * c2c jitter      = max |T_{i+1} - T_i|        (spec 50 ps)
//
// Two configurations:
//   1. CLEAN input: measures the jitter ADDED by our own chain.  Expected
//      contributors: DLL bang-bang dither (+-1 slave LSB = 16 ps at the
//      behavioral law; silicon law is +-7-10 ps per chain SPICE —
//      conservatively verified here), TDC quantization noise feeding the
//      loop, DE3 edge referencing.  Verdict: CK90 pk-pk <= 100 ps,
//      c2c <= 50 ps.
//   2. INJECTED input jitter: MCK edges displaced by uniform +-15 ps
//      (30 ps pk-pk input).  The chain is a delay line for HF jitter
//      (unity transfer) plus its own addition: output pk-pk must stay
//      <= input pk-pk + intrinsic addition.  Methodology note: the DCO's
//      own jitter is the upstream budget; this TB bounds how much the
//      DDR1 clock chain itself may degrade it.
//
// MCK jitter injection: each MCK half-period is stretched/shrunk by a
// uniform random amount in [-15, +15] ps (integer ps quantization is fine
// at this scale).  Implementation: period jitter on BOTH edges (the DCO
// period-noise model), i.e. edge n+1 time = edge n + T/2 + u(-15,+15) ps.
//
// Run: iverilog -g2012 -DSIMULATION -o ... ddr1_jitter_tb.v <deps> && vvp
// Exits nonzero on verdict failure.

module ddr1_jitter_tb;
    localparam integer NJ = 2000;   // measured periods per configuration
    localparam integer JINJ = 15;   // injected half-period jitter amplitude (ps)

    // ---------------- clock gen: MCK 300 MHz with optional edge jitter
    reg mck = 1'b0;
    reg jitter_en = 1'b0;
    integer jamp = 0;
    integer hp;  // half-period in fs resolution
    integer uj;
    integer seed = 32'hdeadbeef;
    always begin
        // base half period 1666.667 ps; jitter uniform +-jamp ps in fs units
        uj = jamp ? ($dist_uniform(seed, -jamp*1000, jamp*1000)) : 0;
        hp = 1666667 + uj;   // fs
        #(hp/1000000.0);
        mck = ~mck;
    end

    reg rst = 1'b1;
    reg pll_locked = 1'b0;
    reg bypass = 1'b0;

    wire ck, ckn, ck90, sysclk, phylock, err;
    wire [15:0] dbg;

    DDR1_CLOCK_TOP u_top (
        .MCK_IN(mck), .PLL_LOCKED(pll_locked), .RST(rst),
        .EXT_CK(1'b0), .EXT_CK90(1'b0), .EXT_SYS_CLK(1'b0),
        .BYPASS(bypass),
        .CK_PHY(ck), .CK_PHY_N(ckn), .CK90_PHY(ck90), .SYS_CLK(sysclk),
        .PHY_LOCKED(phylock), .ERR(err), .DBG(dbg));

    // ---------------- period measurement
    real t_ck  [0:NJ];   // rising-edge times
    real t_ck90[0:NJ];
    integer n_ck = 0, n_ck90 = 0;
    reg    meas_en = 1'b0;

    always @(posedge ck)   if (meas_en && n_ck   <= NJ) begin t_ck[n_ck]     = $realtime; n_ck   = n_ck + 1; end
    always @(posedge ck90) if (meas_en && n_ck90 <= NJ) begin t_ck90[n_ck90] = $realtime; n_ck90 = n_ck90 + 1; end

    // ---------------- analysis
    integer errors = 0, checks = 0;
    integer fd;

    task chk(input cond, input [8*80-1:0] name);
        begin
            checks = checks + 1;
            if (cond) begin $display("PASS: %0s", name); $fdisplay(fd, "PASS: %0s", name); end
            else      begin errors = errors + 1; $display("FAIL: %0s", name); $fdisplay(fd, "FAIL: %0s", name); end
        end
    endtask

    // compute stats over the recorded edges; returns ps x1000 (fs) integers
    task stats(input integer which,   // 0 = ck, 1 = ck90
               output integer pkpk_fs, output integer c2c_fs, output integer mean_fs);
        integer i;
        real p, pmin, pmax, psum, d, dmax, pprev;
        begin
            pmin = 1e12; pmax = 0.0; psum = 0.0; dmax = 0.0; pprev = -1.0;
            for (i = 1; i < NJ-2; i = i + 1) begin
                if (which == 0) p = t_ck[i+1]   - t_ck[i];
                else            p = t_ck90[i+1] - t_ck90[i];
                if (p < pmin) pmin = p;
                if (p > pmax) pmax = p;
                psum = psum + p;
                if (pprev > 0.0) begin
                    d = p - pprev; if (d < 0.0) d = -d;
                    if (d > dmax) dmax = d;
                end
                pprev = p;
            end
            // times are in ns -> convert to fs
            pkpk_fs = $rtoi((pmax - pmin) * 1000000.0);
            c2c_fs  = $rtoi(dmax * 1000000.0);
            mean_fs = $rtoi((psum / (NJ-3)) * 1000000.0);
        end
    endtask

    integer pkpk, c2c, meanp;
    integer pkpk9, c2c9, meanp9;
    integer pkpk_c, c2c_c;
    integer pkpk9_c, c2c9_c;
    integer tmo;

    task acquire_and_measure;
        begin
            n_ck = 0; n_ck90 = 0;
            meas_en = 1'b0;
            // wait for lock
            tmo = 0;
            while (!phylock && tmo < 30000) begin #10; tmo = tmo + 10; end
            if (!phylock) begin
                chk(0, "jitter: PHY_LOCKED acquired");
            end
            // settle, then measure NJ+2 edges
            #2000;
            meas_en = 1'b1;
            while (n_ck90 < NJ-1) begin #1000; end
            meas_en = 1'b0;
        end
    endtask

    initial begin
        fd = $fopen("sim/outputs/ddr1/ddr1_jitter_tb.log", "w");
        $display("=== DDR1 jitter TB ===");
        pll_locked = 1'b0;
        rst = 1'b1; #100;
        @(posedge mck); #0.5; rst = 1'b0;
        #100; pll_locked = 1'b1;

        // ---------- config 1: clean input ----------
        jamp = 0; jitter_en = 0;
        acquire_and_measure;
        stats(0, pkpk, c2c, meanp);
        stats(1, pkpk9, c2c9, meanp9);
        $display("CLEAN: CK   mean=%0d fs pkpk=%0d fs c2c=%0d fs", meanp, pkpk, c2c);
        $display("CLEAN: CK90 mean=%0d fs pkpk=%0d fs c2c=%0d fs", meanp9, pkpk9, c2c9);
        $fdisplay(fd, "CLEAN: CK   mean=%0d fs pkpk=%0d fs c2c=%0d fs", meanp, pkpk, c2c);
        $fdisplay(fd, "CLEAN: CK90 mean=%0d fs pkpk=%0d fs c2c=%0d fs", meanp9, pkpk9, c2c9);
        chk(meanp9 > 9500000 && meanp9 < 10500000, "jitter1: CK90 mean period ~10 ns");
        chk(pkpk9 <= 100000, "jitter1: CK90 period jitter pk-pk <= 100 ps (clean input)");
        chk(c2c9  <= 50000,  "jitter1: CK90 c2c jitter <= 50 ps (clean input)");
        chk(pkpk  <= 100000, "jitter1: CK period jitter pk-pk <= 100 ps (clean input)");
        chk(c2c   <= 50000,  "jitter1: CK c2c jitter <= 50 ps (clean input)");
        pkpk_c = pkpk; c2c_c = c2c; pkpk9_c = pkpk9; c2c9_c = c2c9;

        // ---------- config 2: injected input jitter ----------
        // reset and relock with jitter on (jitter during acquisition is
        // realistic and the loop must still acquire).
        rst = 1'b1; pll_locked = 1'b0; #100;
        jamp = JINJ;
        @(posedge mck); #0.5; rst = 1'b0;
        #100; pll_locked = 1'b1;
        acquire_and_measure;
        stats(0, pkpk, c2c, meanp);
        stats(1, pkpk9, c2c9, meanp9);
        $display("INJ30: CK   mean=%0d fs pkpk=%0d fs c2c=%0d fs", meanp, pkpk, c2c);
        $display("INJ30: CK90 mean=%0d fs pkpk=%0d fs c2c=%0d fs", meanp9, pkpk9, c2c9);
        $fdisplay(fd, "INJ30: CK   mean=%0d fs pkpk=%0d fs c2c=%0d fs", meanp, pkpk, c2c);
        $fdisplay(fd, "INJ30: CK90 mean=%0d fs pkpk=%0d fs c2c=%0d fs", meanp9, pkpk9, c2c9);
        // transfer: output must not exceed input (30ps pk-pk per half
        // period — up to ~60ps pk-pk on the full period) plus our own
        // intrinsic addition measured in config 1.
        chk(pkpk9 <= 60000 + pkpk9_c + 10000,
            "jitter2: CK90 pk-pk <= input + intrinsic + 10ps margin");
        chk(c2c9 <= 30000 + c2c9_c + 10000,
            "jitter2: CK90 c2c <= input amplitude + intrinsic + 10ps margin");
        chk(phylock === 1'b1 && err === 1'b0,
            "jitter2: lock maintained under 30ps input jitter");

        $fdisplay(fd, "SUMMARY: %0d checks, %0d errors", checks, errors);
        $display("=== jitter TB done, %0d checks, errors=%0d ===", checks, errors);
        $fclose(fd);
        if (errors != 0) $fatal(1, "ddr1_jitter_tb FAILED");
        $finish;
    end

    initial begin
        #(400_000_000);  // 400 us global watchdog
        $display("FAIL: global timeout");
        $fatal(1, "watchdog");
    end
endmodule
