`timescale 1ns/1ps
// Smoke: feed a 30%-duty clock; loop should shrink the high pulse toward
// 50% and assert LOCKED.  Measure duty before/after.
module adcc_top_tb;
    localparam real TCLK = 4.0;
    localparam real DUTY = 0.30;      // 30% high time in
    reg CLK_IN=0, RST_N=0, TICK=0, SAMP=0, EN=0;
    reg [15:0] KI=16'd1;
    reg [7:0] DUTY_OFFS=0, DUTY_INIT=0;
    wire CLK_OUT, LOCKED, ERR;
    wire [7:0] DUTY_CODE;

    // 30%-duty input clock
    always begin
        #(TCLK*DUTY)    CLK_IN = 0;
        #(TCLK*(1-DUTY)) CLK_IN = 1;
    end
    initial CLK_IN = 1;
    always #0.5 TICK = ~TICK;
    // async duty-sampling clock: incommensurate with the 4 ns CLK_IN so
    // samples sweep the whole waveform (1.11 ns).
    always #0.555 SAMP = ~SAMP;

    ADCC_TOP dut(
        .CLK_IN(CLK_IN),.RST_N(RST_N),.TICK(TICK),.SAMP(SAMP),.EN(EN),
        .KI(KI),.DUTY_OFFS(DUTY_OFFS),.DUTY_INIT(DUTY_INIT),
        .CLK_OUT(CLK_OUT),.LOCKED(LOCKED),.ERR(ERR),.DUTY_CODE(DUTY_CODE));

    real th, tl, t0;
    task measure_duty;
        begin
            @(posedge CLK_OUT); t0=$realtime;
            @(negedge CLK_OUT); th=$realtime-t0;
            @(posedge CLK_OUT); tl=$realtime-(t0+th);
            $display("in-duty=%0.0f%% out high=%0.3fns period=%0.3fns duty=%0.1f%% code=%0d locked=%b",
                DUTY*100, th, th+tl, 100*th/(th+tl), DUTY_CODE, LOCKED);
        end
    endtask

    integer k;
    initial begin
        repeat(8) @(posedge CLK_IN);
        RST_N=1; repeat(4) @(posedge CLK_IN); EN=1;
        for (k=0;k<80000 && !LOCKED;k=k+1) @(posedge TICK);
        $display("LOCKED=%b ERR=%b after %0d ticks",LOCKED,ERR,k);
        // The averaging PD asserts the dither-window LOCKED early in the
        // code's monotonic climb; let the integrator settle to the true
        // 50% point before measuring the steady-state duty.
        repeat (600) @(posedge TICK);
        measure_duty;
        if (LOCKED) $display("ADCC SMOKE PASS"); else $display("ADCC SMOKE FAIL");
        $finish;
    end
endmodule
