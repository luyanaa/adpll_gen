// Closed-loop post-lock transient measurement.
// Same DUT as pll_macro_top_tb, but logs a per-REF-cycle CSV trace of the
// DCO code trajectory + instantaneous frequency, so we can measure:
//   - frequency/phase acquisition profile (settling)
//   - post-lock fine-code limit cycle (bang-bang dither)
//   - lock time (REF cycles to FREQ_LOCKED / LOCKED)
// Behavioral sim_* models: no device noise, so the trace is the digital
// loop's own dither/settling, not random jitter (that lives in the ISF
// phase-noise numbers).
`timescale 1fs/1fs

module pll_macro_transient_tb;
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
        .DSM_DIV(4),
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
    integer mid_edges = 0;
    integer mid_prev = 0;
    integer f_lock_cycle = -1;
    integer p_lock_cycle = -1;
    integer csv_fd;

    // countones of the thermometer codes
    function integer c4; input [3:0] x; c4 = x[0]+x[1]+x[2]+x[3]; endfunction
    integer c_cnt, m_cnt, f_cnt;
    task count_codes;
        integer i;
        begin
            c_cnt = 0; m_cnt = 0; f_cnt = 0;
            for (i = 0; i < NDELS; i = i + 1) begin
                c_cnt = c_cnt + dut.pll_dig.COARSE_MUX[i];
                m_cnt = m_cnt + dut.pll_dig.MID_MUX[i];
            end
            for (i = 0; i < 31; i = i + 1)
                f_cnt = f_cnt + dut.pll_dig.FINE_MUX[i];
        end
    endtask

    always @(posedge REF) cycles = cycles + 1;
    always @(posedge dut.MID_OUT) mid_edges = mid_edges + 1;

    // per-REF log: cycle, FREQ_LOCKED, LOCKED, state, C/M/F countones,
    // instantaneous MID_OUT edges this REF (integer freq), DLF INT
    always @(negedge REF) begin
        count_codes;
        if (csv_fd) $fwrite(csv_fd,
            "%0d,%b,%b,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
            cycles,
            dut.pll_dig.FREQ_LOCKED,
            LOCKED,
            dut.pll_dig.state,
            c_cnt, m_cnt, f_cnt,
            mid_edges - mid_prev,      // inst freq (edges/REF)
            dut.pll_dig.dlf.INT,
            dut.pll_dig.SS_BBPD
        );
        mid_prev = mid_edges;
        if (f_lock_cycle < 0 && dut.pll_dig.FREQ_LOCKED === 1'b1)
            f_lock_cycle = cycles;
        if (p_lock_cycle < 0 && LOCKED === 1'b1)
            p_lock_cycle = cycles;
    end

    initial begin
        csv_fd = $fopen("lock_transient.csv", "w");
        $fwrite(csv_fd, "cycle,freq_locked,locked,state,coarse,mid,fine,inst_freq,dlf_int,ss_bbpd\n");
        #1 RST_N = 1'b0;
        #20 RST_N = 1'b1;
        #20000000 INJ_EN = 1'b1;

        // Run long enough to see the post-lock limit cycle:
        // freq acquisition (few hundred) + 1600 REF of locked dwell.
        begin : wait_for
            wait (dut.pll_dig.FREQ_LOCKED === 1'b1);
            repeat (1600) @(posedge REF);
        end

        $display("pll_macro_transient_tb: FREQ_LOCKED at cycle %0d, LOCKED at %0d",
                 f_lock_cycle, p_lock_cycle);
        count_codes;
        $display("pll_macro_transient_tb: final COARSE=%0d MID=%0d FINE=%0d LOCKED=%b ERR=%b",
                 c_cnt, m_cnt, f_cnt, LOCKED, ERR);
        $fclose(csv_fd);
        if (ERR) begin
            $display("FAIL: ERR");
            $fatal(1);
        end
        $finish;
    end
endmodule
