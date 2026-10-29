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
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV), .OUT_DIV(OUT_DIV),
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
        #20000000000; // 2000 REF cycles after release

        $display("pll_macro_top_tb: cycles=%0d LOCKED=%b ERR=%b OUT=%b state=%0d FREQ_LOCKED=%b PHASE_LOCK=%b LOCK_LOST=%b SS_BBPD=%b",
                 cycles, LOCKED, ERR, OUT, dut.pll_dig.state, dut.pll_dig.FREQ_LOCKED,
                 dut.pll_dig.PHASE_LOCK, dut.pll_dig.LOCK_LOST, dut.pll_dig.SS_BBPD);
        $display("pll_macro_top_tb: refq=%b rst_cnt=%b rst_d=%b cnt=%0d cap_tog=%b out_edges=%0d mid_edges=%0d FCW=%0d cnt_cap=%0d COARSE=%b MID=%b FINE=%b",
                 dut.pll_dig.flock.CLK_REF_Q, dut.pll_dig.flock.rst_cnt, dut.pll_dig.flock.rst_cnt_d,
                 dut.pll_dig.flock.cnt, dut.pll_dig.flock.cap_toggle, out_edges, mid_edges,
                 FCW, dut.pll_dig.flock.cnt_cap,
                 dut.pll_dig.flock.COARSE_MUX, dut.pll_dig.flock.MID_MUX,
                 dut.pll_dig.FINE_MUX);
        if (ERR) begin
            $display("FAIL: controller entered ERR");
            $fatal(1);
        end
        if (!LOCKED) begin
            $display("FAIL: no LOCKED within the behavioral window");
            $fatal(1);
        end
        $finish;
    end
endmodule
