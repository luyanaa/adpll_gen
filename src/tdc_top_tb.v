`timescale 1ns/1ps
// TDC smoke: REF is a periodic edge; SIG is the same edge delayed by a
// known amount.  Each SAR step uses the NEXT REF edge, so REF/SIG must
// keep running during the conversion (that is how a real SAR TDC works
// on a repetitive timing signal).
module tdc_top_tb;
    reg REF=0, SIG=0, RST_N=0, TICK=0, START=0;
    wire [7:0] TDC_CODE; wire DONE, BUSY, TDC_HALF;
    localparam real INJ_NS = 0.9;      // injected SIG delay vs REF
    localparam real TPER   = 4.0;      // REF/SIG period

    always #0.5 TICK = ~TICK;
    // periodic REF; SIG = REF delayed by INJ_NS (behavioural delay)
    always #(TPER/2) REF = ~REF;
    always @(REF) SIG <= #(INJ_NS) REF;

    TDC_TOP dut (.REF(REF), .SIG(SIG), .RST_N(RST_N), .TICK(TICK),
                 .START(START), .TDC_CODE(TDC_CODE), .TDC_HALF(TDC_HALF),
                 .DONE(DONE), .BUSY(BUSY));

    integer to;
    initial begin
        #20 RST_N=1; #10;
        START=1; repeat(3) @(posedge TICK); START=0;
        to = 0;
        while (!DONE && to < 4000) begin @(posedge TICK); to = to + 1; end
        if (!DONE) $display("TIMEOUT mid=%0d", dut.mid);
        $display("TDC_CODE=%0d HALF=%b -> %0d+%0.1f ps   (injected %0d ps)",
                 TDC_CODE, TDC_HALF, TDC_CODE*15, (TDC_HALF?7.5:0.0), INJ_NS*1000);
        if (DONE && TDC_CODE*15 > (INJ_NS*1000 - 60) && TDC_CODE*15 < (INJ_NS*1000 + 60))
             $display("TDC SMOKE PASS");
        else $display("TDC SMOKE FAIL");
        $finish;
    end
endmodule
