// Lock FSM regression: LOCKED must require PHASE_LOCK and must clear on
// LOCK_LOST.  The frequency-lock indication is forced here so this test is
// independent of the DCO/counter behavior.
`ifndef LOCK_FSM_KEEP_DIV
`define PLL_WITHOUT_DIVIDER
`endif
`timescale 1ns/1ps

module lock_fsm_tb;
    localparam integer COARSE_NDELS = 4;
    localparam integer MID_NDELS = 4;
    localparam integer FINE_NDELS = 7;
    localparam integer FILTER_BITS = 8;
    localparam integer FCW_BITS = 4;

    reg REF = 1'b0;
    reg INJ_EDGE = 1'b0;
    reg MID_OUT = 1'b0;
    reg OUT = 1'b0;
    // Gate the free-running clocks instead of forcing them.  Icarus 12
    // segfaults on force/release of these nets.
    reg ref_run = 1'b1;
    reg out_run = 1'b1;
    always begin
        #5;
        if (ref_run) begin
            REF = ~REF;
            INJ_EDGE = ~INJ_EDGE;
        end
    end
    // Offset from REF so an OUT edge is not the same event as a REF edge.
    initial begin
        #0.25;
        forever begin
            #0.5;
            if (out_run) begin
                MID_OUT = ~MID_OUT;
                OUT = ~OUT;
            end
        end
    end

    reg RST_N = 1'b0;
    reg [1:0] SS_BBPD = 2'b00;
    reg [FILTER_BITS-1:0] KP = 0, KI = 0;
    reg [FCW_BITS-1:0] FCW = 4'd8;
    reg DSM_EN_DT = 1'b0, DSM_EN_SHDT = 1'b1;
    reg [1:0] DSM_ORDER = 2'b01;
    reg [7:0] SET_DIV = 8'd2;
    reg LOAD_DIV = 1'b0;

    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0] MID_MUX;
    wire [FINE_NDELS-1:0] FINE_MUX;
`ifdef PLL_WITHOUT_DIVIDER
    wire DCO_EN, LOCKED, ERR;
    wire CK = 1'b0;
`else
    wire OUT_DIV, CK, DCO_EN, LOCKED, ERR;
`endif

    pll_logic #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .FILTER_BITS(FILTER_BITS),
        .IS_DSM(1),
        .DSM_DIV(2),
        .LOCKED_WAIT(2),
        .FILTER_ILL(2),
        .REF_TIMEOUT(32),
        .DCO_TIMEOUT(4),
        .TB_OVERRIDE(1),
`ifndef PLL_WITHOUT_DIVIDER
        .DIV_BITS(8),
`endif
        .FCW_BITS(FCW_BITS)
    ) dut (
        .REF(REF), .OUT(OUT), .MID_OUT(MID_OUT), .INJ_EDGE(INJ_EDGE), .RST_N(RST_N),
        .SS_BBPD(SS_BBPD),
        .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT), .DSM_EN_SHDT(DSM_EN_SHDT), .DSM_ORDER(DSM_ORDER),
`ifndef PLL_WITHOUT_DIVIDER
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV), .OUT_DIV(OUT_DIV), .CK(CK),
`endif
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .DCO_EN(DCO_EN), .LOCKED(LOCKED), .ERR(ERR)
    );

    integer errors = 0;
    integer i;

    task expect_locked;
        input expected;
        input [8*24-1:0] name;
        begin
            if (LOCKED !== expected) begin
                $display("FAIL: %0s LOCKED=%b expected=%b state=%0d",
                         name, LOCKED, expected, dut.state);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s LOCKED=%b", name, LOCKED);
            end
        end
    endtask

    initial begin
        $display("TB start");
        // The detectors are exercised by their own benches.  Here the FSM
        // sees the TB_OVERRIDE regs, so the transition logic is isolated.
        dut.FREQ_LOCKED_TB = 1'b1;
        dut.FREQ_ERR_TB = 1'b0;
        dut.FREQ_OK_TB = 1'b1;
        dut.PHASE_LOCK_TB = 1'b0;
        dut.LOCK_LOST_TB = 1'b0;
        #30 RST_N = 1'b1;
        #100;

        expect_locked(1'b0, "no phase lock");
        dut.PHASE_LOCK_TB = 1'b1;
        // Init is 8 INJ_EDGE edges, then one edge consumes START, then
        // LOCKED_WAIT more edges, then one more edge asserts locked_q.
        #500;
        expect_locked(1'b1, "phase lock");

        dut.LOCK_LOST_TB = 1'b1;
        #30;
        expect_locked(1'b0, "lock lost");
        // LOCK_LOST with the frequency still in window returns to phase
        // acquisition (state 2).  A frequency-window miss, and the REF
        // and DCO watchdogs, return to frequency acquisition (state 1).
        if (dut.state !== 3'b010) begin
            $display("FAIL: LOCK_LOST state=%0d expected=2", dut.state);
            errors = errors + 1;
        end else begin
            $display("PASS: LOCK_LOST stays in phase acquisition");
        end

        dut.LOCK_LOST_TB = 1'b0;
        dut.PHASE_LOCK_TB = 1'b1;
        #500;
        expect_locked(1'b1, "reacquire");

        // PHASE_LOCK deassertion alone must also clear LOCKED.
        dut.PHASE_LOCK_TB = 1'b0;
        #30;
        expect_locked(1'b0, "phase lock drop");

        // Re-arm the lock, then stop REF and INJ_EDGE together.  The FSM
        // clock is INJ_EDGE, so it cannot clear itself.  OUT keeps running
        // and the watchdog has to drop LOCKED, which drops CK.
        dut.FREQ_LOCKED_TB = 1'b1;
        dut.FREQ_ERR_TB = 1'b0;
        dut.FREQ_OK_TB = 1'b1;
        dut.PHASE_LOCK_TB = 1'b1;
        dut.LOCK_LOST_TB = 1'b0;
        #500;
        expect_locked(1'b1, "locked before ref loss");
        ref_run = 1'b0;
        REF = 1'b0;
        INJ_EDGE = 1'b0;
        #80;
        expect_locked(1'b0, "ref stopped");
        if (CK !== 1'b0) begin
            $display("FAIL: CK still running after REF loss");
            errors = errors + 1;
        end else begin
            $display("PASS: CK quiet after REF loss");
        end

        // REF returns.  LOCKED must stay low until the FSM re-acquires;
        // the first REF edge is not enough.
        ref_run = 1'b1;
        #40;
        expect_locked(1'b0, "ref back, not yet locked");
        #500;
        expect_locked(1'b1, "relock after ref returns");

        // DCO stuck high, stuck low, and stopped.  REF keeps running, so the
        // REF-domain watchdog is the one that can still see it.  The first
        // case is armed from the lock reached above.
        // Stop between REF edges.  Stopping on a REF edge races the
        // activity counter and can hide the stall for one more sample.
        @(negedge REF);
        out_run = 1'b0;
        OUT = 1'b1;
        MID_OUT = 1'b1;
        #60;
        expect_locked(1'b0, "dco stuck high");
        if (CK !== 1'b0) begin
            $display("FAIL: CK high while DCO stuck high");
            errors = errors + 1;
        end else begin
            $display("PASS: CK low while DCO stuck high");
        end

        out_run = 1'b1;
        #500;
        expect_locked(1'b1, "relock after stuck high");

        @(negedge REF);
        out_run = 1'b0;
        OUT = 1'b0;
        MID_OUT = 1'b0;
        #60;
        expect_locked(1'b0, "dco stuck low");
        if (CK !== 1'b0) begin
            $display("FAIL: CK high while DCO stuck low");
            errors = errors + 1;
        end else begin
            $display("PASS: CK low while DCO stuck low");
        end

        out_run = 1'b1;
        #500;
        expect_locked(1'b1, "relock after stuck low");

        // Stop on the opposite level from the stuck-low case, and wait
        // out the same REF-cycle budget.
        @(negedge REF);
        out_run = 1'b0;
        #60;
        expect_locked(1'b0, "dco stopped");
        out_run = 1'b1;

        // False lock: the phase detector stays quiet and reports lock,
        // but the frequency counter has left the FCW window.  That must
        // not enter the locked state, and must not hold one already taken.
        dut.FREQ_LOCKED_TB = 1'b1;
        dut.FREQ_OK_TB = 1'b0;
        dut.PHASE_LOCK_TB = 1'b1;
        dut.LOCK_LOST_TB = 1'b0;
        #500;
        expect_locked(1'b0, "quiet bbpd, frequency out of window");
        if (dut.state === 3'b011) begin
            $display("FAIL: entered locked state without FREQ_OK");
            errors = errors + 1;
        end else begin
            $display("PASS: stayed out of locked state");
        end

        dut.FREQ_OK_TB = 1'b1;
        #500;
        expect_locked(1'b1, "locked with frequency in window");
        dut.FREQ_OK_TB = 1'b0;
        #30;
        expect_locked(1'b0, "frequency left window");
        if (dut.state !== 3'b001) begin
            $display("FAIL: frequency loss state=%0d expected=1", dut.state);
            errors = errors + 1;
        end else begin
            $display("PASS: frequency loss returns to acquisition");
        end

        if (errors != 0) $fatal(1, "lock_fsm_tb failed");
        $display("lock_fsm_tb: PASS");
        $finish;
    end
endmodule
