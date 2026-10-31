`timescale 1ns/1ps
module counter_dco_phys_tb;
    reg TICK = 0;
    reg DCO_EN = 0;
    reg REF = 0;
    reg [14:0] COARSE = 0;
    reg [14:0] MID = 0;
    reg [30:0] FINE = 0;
    wire [1:0] SS_BBPD;
    wire OUT, MID_OUT, INJ_EDGE;
    integer edges;
    realtime first_edge, last_edge, measured_period;

    PLL_COUNTER_DCO_PHYS dut(
        .COARSE_MUX(COARSE), .MID_MUX(MID), .FINE_MUX(FINE),
        .TICK(TICK), .DCO_EN(DCO_EN), .REF(REF), .INJ_EN(1'b0),
        .SS_BBPD(SS_BBPD), .OUT(OUT), .MID_OUT(MID_OUT),
        .INJ_EDGE(INJ_EDGE));

    always #0.5 TICK = ~TICK;
    always #50 REF = ~REF;

    task measure;
        begin
            edges = 0;
            first_edge = 0;
            last_edge = 0;
            @(posedge TICK);
            DCO_EN = 1;
            repeat (20) @(posedge OUT);
            first_edge = $realtime;
            repeat (20) @(posedge OUT);
            last_edge = $realtime;
            measured_period = (last_edge - first_edge) / 20.0;
            $display("COARSE=%0d MID=%0d FINE=%0d period_ns=%0.3f freq_mhz=%0.3f",
                     COARSE, MID, FINE, measured_period, 1000.0 / measured_period);
        end
    endtask

    initial begin
        #1 DCO_EN = 0;
        #5;
        measure();
        COARSE = 15'h7fff;
        #5 measure();
        MID = 15'h7fff;
        #5 measure();
        FINE = 31'h7fffffff;
        #5 measure();
        DCO_EN = 0;
        #10;
        $finish;
    end
endmodule
