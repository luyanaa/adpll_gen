// Real ics55 SS-BBPD sign/offset characterization at a 5 ns period.
// Drives the latch balanced inputs and samples on negedge INJ_EDGE, the DLF
// edge.  Counts the four codes over a phase walk.
`timescale 1ns/1ps

module ssbbpd_real_tb;
    reg REF = 1'b0;
    always #5 REF = ~REF;

    reg INJ = 1'b0;
    always @(REF) INJ <= #0.074 REF;

    reg VCO = 1'b0;
    initial begin
        #0.13;
        forever #0.487 VCO = ~VCO;
    end

    wire [1:0] code;
    PLL_SSBBPD pd (
        .INJ_EDGE_BALANCED(!INJ),
        .OSC_BALANCED(!VCO),
        .SS_BBPD(code)
    );

    integer cp0=0, cp1=0, cp2=0, cp3=0;
    integer cn0=0, cn1=0, cn2=0, cn3=0;
    integer i;
    always @(posedge INJ) begin
        case (code)
            2'b00: cp0 = cp0 + 1;
            2'b01: cp1 = cp1 + 1;
            2'b10: cp2 = cp2 + 1;
            2'b11: cp3 = cp3 + 1;
        endcase
    end
    always @(negedge INJ) begin
        case (code)
            2'b00: cn0 = cn0 + 1;
            2'b01: cn1 = cn1 + 1;
            2'b10: cn2 = cn2 + 1;
            2'b11: cn3 = cn3 + 1;
        endcase
    end

    initial begin
        for (i = 0; i < 200; i = i + 1) begin
            @(posedge INJ);
            @(negedge INJ);
        end
        $display("posedge INJ: 00=%0d 01=%0d 10=%0d 11=%0d",
                 cp0, cp1, cp2, cp3);
        $display("negedge INJ: 00=%0d 01=%0d 10=%0d 11=%0d",
                 cn0, cn1, cn2, cn3);
        if (cn0 != 0 || cn2 != 0) begin
            $display("FAIL: invalid code at the DLF edge");
            $fatal(1);
        end
        if (cn1 == 0 || cn3 == 0) begin
            $display("FAIL: real PD did not produce both decisions");
            $fatal(1);
        end
        $display("ssbbpd_real_tb: PASS");
        $finish;
    end
endmodule
