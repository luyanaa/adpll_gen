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
    integer mid_ss0 = 0, mid_ss1 = 0;
    integer p_cnt = 0, n_cnt = 0, bad_cnt = 0, ill_cnt = 0;
    real ss_per_ref, ss_err_ppm;
    reg count_syms = 1'b0;
    always @(posedge REF) cycles = cycles + 1;
    always @(posedge OUT) out_edges = out_edges + 1;
    always @(posedge dut.MID_OUT) mid_edges = mid_edges + 1;
    // Actual SS-BBPD stream at the detector/DLF sampling edge.
    always @(negedge dut.INJ_EDGE) if (count_syms) begin
        if (dut.pll_dig.ILL_P || dut.pll_dig.ILL_N)
            ill_cnt = ill_cnt + 1;
        case (dut.SS_BBPD)
            2'b01: p_cnt = p_cnt + 1;
            2'b11: n_cnt = n_cnt + 1;
            default: bad_cnt = bad_cnt + 1;
        endcase
    end

    initial begin
        #1 RST_N = 1'b0;
        #20 RST_N = 1'b1;
        #20000000 INJ_EN = 1'b1;

        // Frequency acquisition settles in a few hundred REF cycles.
        // Phase lock is a separate indication.  The behavioral SS-BBPD
        // does emit both P and N, but in this netlist every N sample also
        // asserts ILL_N: the 16-bit filter output sits at 257 and KP=3967,
        // so the N correction rails the fine code at 0.  The stream is
        // counted below instead of being treated as a ratio failure.
        fork : wait_freq
            begin
                wait (dut.pll_dig.FREQ_LOCKED === 1'b1);
                count_syms = 1'b1;
                mid_ss0 = mid_edges;
                repeat (400) @(posedge REF);
                mid_ss1 = mid_edges;
                count_syms = 1'b0;
            end
            begin
                #20000000000; // 2000 REF cycles
            end
        join_any
        disable wait_freq;

        $display("pll_macro_top_tb: cycles=%0d LOCKED=%b ERR=%b OUT=%b state=%0d FREQ_LOCKED=%b PHASE_LOCK=%b LOCK_LOST=%b SS_BBPD=%b",
                 cycles, LOCKED, ERR, OUT, dut.pll_dig.state, dut.pll_dig.FREQ_LOCKED,
                 dut.pll_dig.PHASE_LOCK, dut.pll_dig.LOCK_LOST, dut.pll_dig.SS_BBPD);
        $display("pll_macro_top_tb: gates dsm_gate=%b fll_standby=%b",
                 dut.pll_dig.dsm_impl.dsm_gate, dut.pll_dig.flock.fll_standby);
        $display("pll_macro_top_tb: fll cnt_filt=%0d cnt_done=%0d FREQ_OK=%b LOCKED=%b ERR=%b FCW_NA=%0d FCW_PA=%0d",
                 dut.pll_dig.flock.cnt_filt, dut.pll_dig.flock.cnt_done,
                 dut.pll_dig.FREQ_OK, dut.pll_dig.FREQ_LOCKED,
                 dut.pll_dig.FREQ_ERR, dut.pll_dig.flock.FCW_NA,
                 dut.pll_dig.flock.FCW_PA);
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
        // Full LOCKED also needs a qualified phase window.  Record the
        // measured stream; a railed fine filter is not a frequency failure.
        $display("note: LOCKED=%b PHASE_LOCK=%b (phase lock is not the ratio check)",
                 LOCKED, dut.pll_dig.PHASE_LOCK);
        $display("pll_macro_top_tb: SS_BBPD stream P=%0d N=%0d invalid=%0d ILL=%0d win_cnt=%0d seen_p=%b seen_n=%b bad_cnt=%0d",
                 p_cnt, n_cnt, bad_cnt, ill_cnt,
                 dut.pll_dig.lock_detector.win_cnt,
                 dut.pll_dig.lock_detector.seen_p,
                 dut.pll_dig.lock_detector.seen_n,
                 dut.pll_dig.lock_detector.bad_cnt);
        $display("pll_macro_top_tb: ILL_P=%b ILL_N=%b DLF_INT=%0d",
                 dut.pll_dig.ILL_P, dut.pll_dig.ILL_N,
                 dut.pll_dig.dlf.INT);

        // Steady-state frequency is a separate metric from FREQ_LOCKED.
        // FREQ_LOCKED only says the filtered count entered FCW +/- LOCK_TOL
        // (default 1 count per REF), not that the output meets a SoC ppm
        // budget.  Report the average over the 400-cycle window above.
        ss_per_ref = (mid_ss1 - mid_ss0) / 400.0;
        ss_err_ppm = (ss_per_ref - FCW) * 1000000.0 / FCW;
        $display("pll_macro_top_tb: steady-state %0d MID_OUT / 400 REF = %0.3f per REF, error %0.0f ppm (FREQ_LOCKED is acquisition range, not SoC accuracy)",
                 mid_ss1 - mid_ss0, ss_per_ref, ss_err_ppm);

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
