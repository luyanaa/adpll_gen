`timescale 1ns/1ps
// Smoke test: ADDLL_TOP closed loop.  CLK_IN is delayed by the DCDL;
// the bang-bang loop should walk the delay code up until CLK_OUT is
// aligned (a full CLK_IN period late) and then assert LOCKED.
module addll_top_tb;
    localparam real TCLK_NS = 4.0;   // 250 MHz input clock
    reg CLK_IN = 0, RST_N = 0, TICK = 0, EN = 0;
    reg [15:0] KI = 16'd1;
    reg [7:0] PHASE_OFFS = 8'd0;
    reg [7:0] DLY_INIT = 8'd0;
    wire CLK_OUT, LOCKED, ERR;
    wire [7:0] DLY_CODE;

    always #(TCLK_NS/2.0) CLK_IN = ~CLK_IN;
    always #0.5 TICK = ~TICK;        // 1 GHz loop clock

    ADDLL_TOP #(
        .COARSE_NDELS(15), .MID_NDELS(15), .FINE_NDELS(31),
        .FILTER_BITS(16)
    ) dut (
        .CLK_IN(CLK_IN), .RST_N(RST_N), .TICK(TICK), .EN(EN),
        .KI(KI), .PHASE_OFFS(PHASE_OFFS), .DLY_INIT(DLY_INIT),
        .CLK_OUT(CLK_OUT), .LOCKED(LOCKED), .ERR(ERR),
        .DLY_CODE(DLY_CODE)
    );

    integer k;
    real t_ref, t_out, meas;
    initial begin
        repeat (10) @(posedge CLK_IN);
        RST_N = 1;
        repeat (5) @(posedge CLK_IN);
        EN = 1;
        // run until lock or timeout
        for (k = 0; k < 200000 && !LOCKED; k = k + 1) @(posedge TICK);
        $display("LOCKED=%0b ERR=%0b DLY_CODE=%0d after %0d ticks", LOCKED, ERR, DLY_CODE, k);
        // measure insertion delay at lock
        @(posedge CLK_IN); t_ref = $realtime;
        @(posedge CLK_OUT); t_out = $realtime;
        meas = t_out - t_ref;
        $display("CLK_OUT lag vs CLK_IN = %0.3f ns (mod %0.1f ns period)", meas, TCLK_NS);
        if (LOCKED) $display("ADDLL SMOKE PASS");
        else        $display("ADDLL SMOKE FAIL (no lock)");
        $finish;
    end
endmodule
