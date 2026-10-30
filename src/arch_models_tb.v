`timescale 1ns/1ps

module arch_models_tb;
    reg REF = 1'b0;
    always #50 REF = ~REF; // 10 MHz reference

    reg [14:0] C0 = 15'd0, CMAX = {15{1'b1}};
    reg [14:0] M0 = 15'd0;
    reg [30:0] F0 = 31'd0;
    wire ring_out0, ring_out1, counter_out0, counter_out1;
    wire [1:0] ss0, ss1, ss2, ss3;
    integer ring_edges0 = 0, ring_edges1 = 0;
    integer counter_edges0 = 0, counter_edges1 = 0;

    PLL_RING_DCO ring0(.COARSE_MUX(C0), .MID_MUX(M0), .FINE_MUX(F0),
                       .DCO_EN(1'b1), .REF(REF), .INJ_EN(1'b0),
                       .SS_BBPD(ss0), .OUT(ring_out0), .MID_OUT(), .INJ_EDGE());
    PLL_RING_DCO ring1(.COARSE_MUX(CMAX), .MID_MUX(CMAX), .FINE_MUX({31{1'b1}}),
                       .DCO_EN(1'b1), .REF(REF), .INJ_EN(1'b0),
                       .SS_BBPD(ss1), .OUT(ring_out1), .MID_OUT(), .INJ_EDGE());
    PLL_COUNTER_DCO counter0(.COARSE_MUX(C0), .MID_MUX(M0), .FINE_MUX(F0),
                             .DCO_EN(1'b1), .REF(REF), .INJ_EN(1'b0),
                             .SS_BBPD(ss2), .OUT(counter_out0), .MID_OUT(), .INJ_EDGE());
    PLL_COUNTER_DCO counter1(.COARSE_MUX(CMAX), .MID_MUX(CMAX), .FINE_MUX({31{1'b1}}),
                             .DCO_EN(1'b1), .REF(REF), .INJ_EN(1'b0),
                             .SS_BBPD(ss3), .OUT(counter_out1), .MID_OUT(), .INJ_EDGE());

    always @(posedge ring_out0) ring_edges0 = ring_edges0 + 1;
    always @(posedge ring_out1) ring_edges1 = ring_edges1 + 1;
    always @(posedge counter_out0) counter_edges0 = counter_edges0 + 1;
    always @(posedge counter_out1) counter_edges1 = counter_edges1 + 1;

    initial begin
        #2000;
        if (ring_edges0 == 0 || ring_edges1 == 0 ||
            counter_edges0 == 0 || counter_edges1 == 0) begin
            $display("FAIL: model did not oscillate");
            $fatal(1);
        end
        if (ring_edges1 <= ring_edges0 || counter_edges1 <= counter_edges0) begin
            $display("FAIL: control code does not change model frequency");
            $fatal(1);
        end
        $display("arch_models_tb: PASS ring=%0d/%0d counter=%0d/%0d",
                 ring_edges0, ring_edges1, counter_edges0, counter_edges1);
        $finish;
    end
endmodule
