// Closed-loop smoke test for the digital controller + hardened analog wrapper.
// This uses the behavioral sim_* models, not the PDK PEX netlist.
`timescale 1fs/1fs

module pll_macro_top_tb;
    localparam integer FILTER_BITS = 16;
    localparam integer FCW_BITS = 8;
    localparam integer DIV_BITS = 8;
    localparam integer NDELS = 15;

    reg REF = 1'b0;
    always #5000000 REF = ~REF; // 100 MHz

    reg RST_N = 1'b1;
    reg INJ_EN = 1'b0;
    reg [FILTER_BITS-1:0] KP = 16'd3967;
    reg [FILTER_BITS-1:0] KI = 16'd257;
    reg [FCW_BITS-1:0] FCW = 8'd16;
    reg DSM_EN_DT = 1'b0;
    reg DSM_EN_SHDT = 1'b1;
    reg [1:0] DSM_ORDER = 2'b00;
    reg [DIV_BITS-1:0] SET_DIV = 8'd2;
    reg LOAD_DIV = 1'b0;

    wire OUT, OUT_DIV, LOCKED, ERR;

    pll_macro_top #(
        .COARSE_NDELS(NDELS),
        .MID_NDELS(NDELS),
        .FINE_NDELS(31),
        .FILTER_BITS(FILTER_BITS),
        .IS_DSM(1),
        .DSM_DIV(2),
        .LOCKED_WAIT(64),
        .FILTER_ILL(16),
        .DIV_BITS(DIV_BITS),
        .FCW_BITS(FCW_BITS)
    ) dut (
        .REF(REF), .RST_N(RST_N), .INJ_EN(INJ_EN),
        .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT), .DSM_EN_SHDT(DSM_EN_SHDT), .DSM_ORDER(DSM_ORDER),
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV), .OUT_DIV(OUT_DIV), .CK(),
        .LOCKED(LOCKED), .ERR(ERR), .OUT(OUT)
    );

    integer cycles = 0;
    integer out_edges = 0;
    integer mid_edges = 0;
    always @(posedge REF) cycles = cycles + 1;
    always @(posedge OUT) out_edges = out_edges + 1;
    always @(posedge dut.MID_OUT) mid_edges = mid_edges + 1;

    initial begin
        #1 RST_N = 1'b0;
        #20 RST_N = 1'b1;
        #20000000 INJ_EN = 1'b1;

        // Frequency acquisition settles in a few hundred REF cycles.
        // Phase lock is a separate indication: the behavioral SS-BBPD in
        // this sim_* netlist does not produce both correction symbols, so
        // PHASE_LOCK stays 0 here.  The ratio below is taken once the
        // frequency counter has been inside tolerance, which is what
        // FREQ_LOCKED reports.
        fork : wait_freq
            begin
                wait (dut.pll_dig.FREQ_LOCKED === 1'b1);
                repeat (64) @(posedge REF);
            end
            begin
                #20000000000; // 2000 REF cycles
            end
        join_any
        disable wait_freq;

        $display("pll_macro_top_tb: cycles=%0d LOCKED=%b ERR=%b OUT=%b state=%0d FREQ_LOCKED=%b PHASE_LOCK=%b LOCK_LOST=%b SS_BBPD=%b",
                 cycles, LOCKED, ERR, OUT, dut.pll_dig.state, dut.pll_dig.FREQ_LOCKED,
                 dut.pll_dig.PHASE_LOCK, dut.pll_dig.LOCK_LOST, dut.pll_dig.SS_BBPD);
        $display("pll_macro_top_tb: cap_valid=%b cnt_bin=%0d cnt=%0d out_edges=%0d mid_edges=%0d FCW=%0d cnt_cap=%0d COARSE=%b MID=%b FINE=%b",
                 dut.pll_dig.flock.cap_valid, dut.pll_dig.flock.cnt_bin,
                 dut.pll_dig.flock.cnt, out_edges, mid_edges,
                 FCW, dut.pll_dig.flock.cnt_cap,
                 dut.pll_dig.flock.COARSE_MUX, dut.pll_dig.flock.MID_MUX,
                 dut.pll_dig.FINE_MUX);
        if (ERR) begin
            $display("FAIL: controller entered ERR");
            $fatal(1);
        end
        if (dut.pll_dig.FREQ_LOCKED !== 1'b1) begin
            $display("FAIL: FREQ_LOCKED did not rise");
            $fatal(1);
        end
        // Full LOCKED also needs PHASE_LOCK.  Record it; do not treat a
        // stuck behavioral BBPD as a frequency-ratio failure.
        $display("note: LOCKED=%b PHASE_LOCK=%b (phase lock is not the ratio check)",
                 LOCKED, dut.pll_dig.PHASE_LOCK);

        // freq_lock counts MID_OUT edges per REF and compares them with
        // FCW.  32 periods after FREQ_LOCKED must land on FCW, not on
        // FCW/2 or 2*FCW.  +/-2 counts per REF still rejects those aliases.
        begin : ratio_check
            integer lo, hi, got, lo_lim, hi_lim;
            lo = mid_edges;
            repeat (32) @(posedge REF);
            #1;
            hi = mid_edges;
            got = hi - lo;
            lo_lim = 32 * (FCW - 2);
            hi_lim = 32 * (FCW + 2);
            $display("pll_macro_top_tb: MID_OUT edges=%0d over 32 REF, FCW=%0d, per REF=%0d.%0d",
                     got, FCW, got / 32, ((got % 32) * 10) / 32);
            if (dut.pll_dig.FREQ_LOCKED !== 1'b1) begin
                $display("FAIL: FREQ_LOCKED dropped during the ratio window");
                $fatal(1);
            end
            if (got < lo_lim || got > hi_lim) begin
                $display("FAIL: ratio %0d edges / 32 REF is not FCW=%0d (limits %0d..%0d)",
                         got, FCW, lo_lim, hi_lim);
                $fatal(1);
            end
            $display("PASS: frequency lock is FCW=%0d, not an alias", FCW);
        end
        $finish;
    end
endmodule
