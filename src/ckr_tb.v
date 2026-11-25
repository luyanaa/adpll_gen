// CKR pulse width, and the coarse/mid code update.
//
// CKR is REF sampled on the falling edge of MID_OUT.  Its high time is
// therefore an integer number of MID_OUT periods, not one MID_OUT high
// time.  This bench uses a REF high that covers two falling edges, so the
// measured high time is 2 MID_OUT periods.
//
// A coarse/mid change is a register write on posedge CKR.  The behavioral
// delay cells used by PLL_ILDCO (`sim_delay_*`) recompute only when IN
// changes, so a code write while IN is stable must not add an OUT edge.
`timescale 1ps/1ps

module ckr_tb;
    localparam integer COARSE_NDELS = 4;
    localparam integer MID_NDELS = 4;
    localparam integer FINE_NDELS = 7;
    localparam integer FILTER_BITS = 8;
    localparam integer FCW_BITS = 4;

    reg REF = 1'b0;
    reg MID_OUT = 1'b0;
    reg OUT = 1'b0;
    reg INJ_EDGE = 1'b0;
    reg RST_N = 1'b0;
    reg [1:0] SS_BBPD = 2'b00;
    reg [FILTER_BITS-1:0] KP = 0;
    reg [FILTER_BITS-1:0] KI = 0;
    reg [FCW_BITS-1:0] FCW = 4'd8;
    reg DSM_EN_DT = 1'b0;
    reg DSM_EN_SHDT = 1'b1;
    reg [1:0] DSM_ORDER = 2'b01;
    reg [7:0] SET_DIV = 8'd2;
    reg LOAD_DIV = 1'b0;

    // MID_OUT / OUT: period 10 ns, high 5 ns.  First falling edge at 10 ns.
    initial begin
        MID_OUT = 1'b0;
        OUT = 1'b0;
        forever #5000 begin
            MID_OUT = ~MID_OUT;
            OUT = ~OUT;
        end
    end
    // REF high covers exactly two MID_OUT falling edges.  Offset by 2 ns
    // so a REF edge never lands on a sample edge.
    initial begin
        REF = 1'b0;
        INJ_EDGE = 1'b0;
        #2000;
        forever #20000 begin
            REF = ~REF;
            INJ_EDGE = ~INJ_EDGE;
        end
    end

    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0] MID_MUX;
    wire [FINE_NDELS-1:0] FINE_MUX;
    wire OUT_DIV, CK, DCO_EN, LOCKED, ERR;

    pll_logic #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .FILTER_BITS(FILTER_BITS),
        .IS_DSM(0),
        .LOCKED_WAIT(2),
        .FILTER_ILL(2),
        .LOCK_COUNT(4),
        .LOSS_COUNT(2),
        .LOCK_WINDOW(1),
        .FCW_BITS(FCW_BITS),
        .DIV_BITS(8)
    ) dut (
        .REF(REF), .OUT(OUT), .MID_OUT(MID_OUT), .INJ_EDGE(INJ_EDGE),
        .RST_N(RST_N), .SS_BBPD(SS_BBPD),
        .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT), .DSM_EN_SHDT(DSM_EN_SHDT), .DSM_ORDER(DSM_ORDER),
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV), .OUT_DIV(OUT_DIV), .CK(CK),
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .DCO_EN(DCO_EN), .LOCKED(LOCKED), .ERR(ERR)
    );

    integer errors = 0;
    integer ckr_n = 0;
    integer ckr_high = 0;
    integer mid_high = 0;
    integer mid_period = 0;
    integer ckr_rise_t = 0;
    integer mid_rise_t = 0;
    integer guard = 0;

    always @(posedge dut.CKR) ckr_rise_t = $time;
    always @(negedge dut.CKR) begin
        if (ckr_rise_t > 0 && ckr_n < 4) begin
            ckr_high = $time - ckr_rise_t;
            ckr_n = ckr_n + 1;
            // Two falling samples of REF=1, then REF=0: 2 * 10 ns.
            if (ckr_high != 20000) begin
                $display("FAIL: CKR high=%0d ps, expected 20000 (2 MID_OUT periods)",
                         ckr_high);
                errors = errors + 1;
            end else begin
                $display("PASS: CKR high=%0d ps = 2 MID_OUT periods, MID_OUT high=%0d ps",
                         ckr_high, mid_high);
            end
        end
    end

    always @(posedge MID_OUT) mid_rise_t = $time;
    always @(negedge MID_OUT) begin
        if (mid_rise_t > 0) begin
            mid_high = $time - mid_rise_t;
            if (mid_period == 0)
                mid_period = mid_high + mid_high;
        end
    end

    // Behavioral ring tap.  sim_delay_* arms its delay from IN and does
    // not reschedule when MUX changes.  A code write during the pulse
    // already in flight must not add an output edge.
    reg [14:0] coarse_code = 15'd0;
    reg [14:0] mid_code = 15'd0;
    reg [30:0] fine_code = 31'd0;
    reg ring_in = 1'b0;
    wire coarse_out, mid_out_d, fine_out;
    integer c_seen = 0;
    integer m_seen = 0;
    integer f_seen = 0;
    integer launch_t = 0;
    integer coarse_dt = 0;
    reg count_chain = 1'b0;

    sim_delay_coarse #(.NDELS(15)) u_coarse (
        .MUX(coarse_code), .IN(ring_in), .OUT(coarse_out)
    );
    sim_delay_mid #(.NDELS(15)) u_mid (
        .MUX(mid_code), .IN(coarse_out), .OUT(mid_out_d)
    );
    sim_delay_fine #(.NDELS(31)) u_fine (
        .MUX(fine_code), .IN(mid_out_d), .OUT(fine_out)
    );
    // The time-0 initial value of OUT is not a pulse launched by IN.
    always @(coarse_out) if (count_chain) begin
        c_seen = c_seen + 1;
        coarse_dt = $time - launch_t;
    end
    always @(mid_out_d) if (count_chain) m_seen = m_seen + 1;
    always @(fine_out) if (count_chain) f_seen = f_seen + 1;

    initial begin
        #1000 RST_N = 1'b1;

        // One rising IN.  Code 0 coarse delay is 31.320 ps.  The code
        // write is 10 ps later, while that pulse is still inside the cell.
        // The written code's own delay is 133.300 ps; a second scheduled
        // event would show up there.
        #1;
        count_chain = 1'b1;
        launch_t = $time;
        ring_in = 1'b1;
        #10;
        coarse_code = 15'b000_0000_0000_0111;
        mid_code = 15'b000_0000_0000_0111;
        fine_code = 31'h0000_007f;
        #200;
        if (c_seen !== 1 || coarse_dt < 31 || coarse_dt > 32) begin
            $display("FAIL: coarse edges=%0d at %0d ps after IN, expected exactly 1 at the code-0 delay (31 ps)",
                     c_seen, coarse_dt);
            errors = errors + 1;
        end else begin
            $display("PASS: coarse edges=%0d at %0d ps (code-0 delay); write at 10 ps added none",
                     c_seen, coarse_dt);
        end
        if (m_seen !== 1 || f_seen !== 1) begin
            $display("FAIL: mid edges=%0d fine edges=%0d, expected 1 each from the single IN pulse",
                     m_seen, f_seen);
            errors = errors + 1;
        end else begin
            $display("PASS: mid edges=%0d fine edges=%0d from the one IN pulse", m_seen, f_seen);
        end

        guard = 0;
        while (ckr_n < 2 && guard < 20) begin
            #40000;
            guard = guard + 1;
        end
        if (ckr_n < 2) begin
            $display("FAIL: only %0d CKR pulses", ckr_n);
            errors = errors + 1;
        end
        if (mid_high != 5000) begin
            $display("FAIL: MID_OUT high=%0d ps, expected 5000", mid_high);
            errors = errors + 1;
        end else begin
            $display("PASS: MID_OUT high=%0d ps, CKR high is 4x that", mid_high);
        end

        if (errors != 0) $fatal(1, "ckr_tb failed");
        $display("ckr_tb: PASS");
        $finish;
    end
endmodule
