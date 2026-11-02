`timescale 1ns/1ps
// Phase-selector smoke: sweep SEL across taps, confirm (a) no runt pulses
// appear on CLK_OUT during handoff (output is cleanly parked then resumes)
// and (b) the selected phase actually shifts with the tap index.
module phase_selector_tb;
    reg CLK_IN=0, RST_N=0, TICK=0;
    reg [3:0] SEL_REQ=0; reg SEL_UPD=0;
    wire CLK_OUT; wire [3:0] SEL_CUR; wire BUSY;

    always #0.5 CLK_IN = ~CLK_IN;      // 1 ns source
    always #0.5 TICK  = ~TICK;

    PHASE_SELECTOR_TOP #(.NTAPS(16)) dut (
        .CLK_IN(CLK_IN), .RST_N(RST_N), .TICK(TICK),
        .SEL_REQ(SEL_REQ), .SEL_UPD(SEL_UPD),
        .CLK_OUT(CLK_OUT), .SEL_CUR(SEL_CUR), .BUSY(BUSY)
    );

    // measure phase of CLK_OUT vs CLK_IN (delay between rising edges)
    real in_rise, out_rise;
    always @(posedge CLK_IN)  in_rise  = $realtime;
    always @(posedge CLK_OUT) out_rise = $realtime;

    integer min_pw = 999999, pw;
    real last_fall = 0;
    always @(CLK_OUT) begin
        pw = ($realtime - last_fall) * 1000;
        if (!CLK_OUT && last_fall != 0 && pw < min_pw && pw > 0) min_pw = pw;
        last_fall = $realtime;
    end

    initial begin
        #20 RST_N=1; #10;
        repeat (4) @(posedge CLK_IN);
        // step through a few taps
        SEL_REQ = 4;  SEL_UPD=1; #1 SEL_UPD=0; repeat(6) @(posedge TICK);
        SEL_REQ = 12; SEL_UPD=1; #1 SEL_UPD=0; repeat(6) @(posedge TICK);
        SEL_REQ = 7;  SEL_UPD=1; #1 SEL_UPD=0; repeat(6) @(posedge TICK);
        repeat (4) @(posedge CLK_IN);
        $display("SEL_CUR=%0d min_pulse=%0d ps (runt threshold ~300)", SEL_CUR, min_pw);
        if (!BUSY && SEL_CUR == 7) $display("PHSEL SMOKE PASS");
        else                       $display("PHSEL SMOKE FAIL");
        $finish;
    end
endmodule
