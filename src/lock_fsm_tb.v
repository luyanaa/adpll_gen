// Lock FSM regression: LOCKED must require PHASE_LOCK and must clear on
// LOCK_LOST.  The frequency-lock indication is forced here so this test is
// independent of the DCO/counter behavior.
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
    always #5 REF = ~REF;
    always #5 INJ_EDGE = ~INJ_EDGE;
    always #0.5 MID_OUT = ~MID_OUT;
    always #0.5 OUT = ~OUT;

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
    wire OUT_DIV, DCO_EN, LOCKED, ERR;

    pll_logic #(
        .COARSE_NDELS(COARSE_NDELS),
        .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS),
        .FILTER_BITS(FILTER_BITS),
        .IS_DSM(1),
        .DSM_DIV(2),
        .LOCKED_WAIT(2),
        .FILTER_ILL(2),
        .DIV_BITS(8),
        .FCW_BITS(FCW_BITS)
    ) dut (
        .REF(REF), .OUT(OUT), .MID_OUT(MID_OUT), .INJ_EDGE(INJ_EDGE), .RST_N(RST_N),
        .SS_BBPD(SS_BBPD),
        .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT), .DSM_EN_SHDT(DSM_EN_SHDT), .DSM_ORDER(DSM_ORDER),
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV), .OUT_DIV(OUT_DIV),
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
        // Force the frequency-lock indication; the state machine must still
        // wait for PHASE_LOCK before asserting LOCKED.
        force dut.FREQ_LOCKED = 1'b1;
        force dut.FREQ_ERR = 1'b0;
        // The detector is exercised separately; here we force its outputs so
        // the FSM transition logic is tested in isolation.
        force dut.PHASE_LOCK = 1'b0;
        force dut.LOCK_LOST = 1'b0;
        #30 RST_N = 1'b1;
        #100;

        expect_locked(1'b0, "no phase lock");
        force dut.PHASE_LOCK = 1'b1;
        #100;
        expect_locked(1'b1, "phase lock");

        force dut.LOCK_LOST = 1'b1;
        #20;
        expect_locked(1'b0, "lock lost");
        if (dut.state !== 3'b001) begin
            $display("FAIL: LOCK_LOST state=%0d expected=1", dut.state);
            errors = errors + 1;
        end

        force dut.LOCK_LOST = 1'b0;
        #100;
        expect_locked(1'b1, "reacquire");

        // PHASE_LOCK deassertion alone must also clear LOCKED.
        force dut.PHASE_LOCK = 1'b0;
        #20;
        expect_locked(1'b0, "phase lock drop");

        release dut.PHASE_LOCK;
        release dut.LOCK_LOST;
        release dut.FREQ_LOCKED;
        release dut.FREQ_ERR;
        if (errors != 0) $fatal(1, "lock_fsm_tb failed");
        $display("lock_fsm_tb: PASS");
        $finish;
    end
endmodule
