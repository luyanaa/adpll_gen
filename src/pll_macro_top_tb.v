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

    reg RST_N = 1'b0;
    reg INJ_EN = 1'b0;
    reg [FILTER_BITS-1:0] KP = 16'd3967;
    reg [FILTER_BITS-1:0] KI = 16'd257;
    reg [FCW_BITS-1:0] FCW = 8'd15;
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
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV), .OUT_DIV(OUT_DIV),
        .LOCKED(LOCKED), .ERR(ERR), .OUT(OUT)
    );

    integer cycles = 0;
    always @(posedge REF) cycles = cycles + 1;

    initial begin
        #20000000 RST_N = 1'b1;
        #20000000 INJ_EN = 1'b1;
        #20000000000; // 2000 REF cycles after release

        $display("pll_macro_top_tb: cycles=%0d LOCKED=%b ERR=%b OUT=%b state=%0d FREQ_LOCKED=%b PHASE_LOCK=%b LOCK_LOST=%b SS_BBPD=%b",
                 cycles, LOCKED, ERR, OUT, dut.pll_dig.state, dut.pll_dig.FREQ_LOCKED,
                 dut.pll_dig.PHASE_LOCK, dut.pll_dig.LOCK_LOST, dut.pll_dig.SS_BBPD);
        if (ERR) begin
            $display("FAIL: controller entered ERR");
            $fatal(1);
        end
        if (!LOCKED) begin
            $display("NOTE: no LOCKED within this short behavioral window");
        end
        $finish;
    end
endmodule
