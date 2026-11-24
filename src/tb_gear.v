// Gear-shift check: pll_logic in TB_OVERRIDE mode.  Watch KP_EFF/KI_EFF
// switch from the port values to KP_TRACK/KI_TRACK when the FSM reaches
// state 011, and back on lock loss.  FILTER_BITS=8 so the tracking
// parameters are small enough to see in the trace.
`define PLL_WITHOUT_DIVIDER
`timescale 1ns/1ps
module tb_gear;
    localparam integer COARSE_NDELS = 4;
    localparam integer MID_NDELS = 4;
    localparam integer FINE_NDELS = 7;
    localparam integer FILTER_BITS = 8;
    localparam integer FCW_BITS = 4;

    reg REF = 0, INJ_EDGE = 0, MID_OUT = 0, OUT = 0;
    always #5 begin REF = ~REF; INJ_EDGE = ~INJ_EDGE; end
    initial begin #0.25; forever #0.5 begin MID_OUT = ~MID_OUT; OUT = ~OUT; end end

    reg RST_N = 0;
    reg [1:0] SS_BBPD = 2'b00;
    reg [FILTER_BITS-1:0] KP = 8'd200, KI = 8'd20;
    reg [FCW_BITS-1:0] FCW = 4'd8;
    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0] MID_MUX;
    wire [FINE_NDELS-1:0] FINE_MUX;
    wire DCO_EN, LOCKED, ERR;

    pll_logic #(
        .COARSE_NDELS(COARSE_NDELS), .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS), .FILTER_BITS(FILTER_BITS),
        .IS_DSM(1), .DSM_DIV(2), .LOCKED_WAIT(2), .FILTER_ILL(2),
        .REF_TIMEOUT(32), .DCO_TIMEOUT(4), .LOCK_WINDOW(1),
        .TB_OVERRIDE(1),
        .GEAR_SHIFT(1), .KP_TRACK(8'd60), .KI_TRACK(8'd6),
        .FCW_BITS(FCW_BITS)
    ) dut (
        .REF(REF), .OUT(OUT), .MID_OUT(MID_OUT), .INJ_EDGE(INJ_EDGE),
        .RST_N(RST_N), .SS_BBPD(SS_BBPD), .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(1'b0), .DSM_EN_SHDT(1'b1), .DSM_ORDER(2'b01),
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .DCO_EN(DCO_EN), .LOCKED(LOCKED), .ERR(ERR)
    );

    integer errors = 0;
    task chk(input cond, input [8*48-1:0] name);
        if (!cond) begin $display("FAIL: %0s state=%0d gear=%b kp=%0d ki=%0d",
                                  name, dut.state, dut.gear_track,
                                  dut.KP_EFF, dut.KI_EFF);
                         errors = errors + 1; end
        else         $display("PASS: %0s", name);
    endtask

    initial begin
        dut.FREQ_LOCKED_TB = 1'b1; dut.FREQ_ERR_TB = 1'b0;
        dut.FREQ_OK_TB = 1'b1; dut.PHASE_LOCK_TB = 1'b0; dut.LOCK_LOST_TB = 1'b0;
        #30 RST_N = 1;
        // Wait for the FSM to leave init (state 000 -> 001) and reach the
        // phase-acquisition wait (state 010).  cnt[3] needs 8 negedges.
        wait (dut.state === 3'b010);
        #40;
        chk(dut.gear_track === 1'b0, "gear_track=0 in acquisition");
        chk(dut.KP_EFF === 8'd200, "KP_EFF=port KP before lock");
        chk(dut.KI_EFF === 8'd20,  "KI_EFF=port KI before lock");

        dut.PHASE_LOCK_TB = 1'b1;
        wait (dut.state === 3'b011);
        #40;
        chk(LOCKED === 1'b1, "LOCKED asserted");
        chk(dut.gear_track === 1'b1, "gear_track=1 in locked state");
        chk(dut.KP_EFF === 8'd60, "KP_EFF=KP_TRACK after lock");
        chk(dut.KI_EFF === 8'd6,  "KI_EFF=KI_TRACK after lock");

        // Lock loss must restore the acquisition gear immediately.
        dut.LOCK_LOST_TB = 1'b1;
        #30;
        chk(dut.gear_track === 1'b0, "gear_track=0 after LOCK_LOST");
        chk(dut.KP_EFF === 8'd200, "KP_EFF restored to port KP");
        chk(dut.KI_EFF === 8'd20,  "KI_EFF restored to port KI");

        dut.LOCK_LOST_TB = 1'b0; dut.PHASE_LOCK_TB = 1'b1;
        wait (dut.state === 3'b011);
        #40;
        chk(dut.gear_track === 1'b1, "gear_track reasserted on relock");

        if (errors != 0) $fatal(1, "tb_gear failed");
        $display("tb_gear: PASS");
        $finish;
    end
endmodule
