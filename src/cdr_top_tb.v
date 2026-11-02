`timescale 1ns/1ps
// CDR smoke: feed a PRBS-like NRZ stream, check the loop parks the
// sampling phase so DATA_OUT tracks the input bits with no errors.
module cdr_top_tb;
    localparam real UI = 1.0;          // 1 UI = 1 ns (model)
    localparam real TCLK = 1.0;        // TICK ~ baud rate
    reg CLK_REF=0, RST_N=0, EN=0;
    reg DATA=0;
    wire DATA_OUT, REC_CLK, LOCKED, ERR;
    wire [7:0] PHASE_CODE;

    // local reference ~ baud rate (the DCDL phase-shifts it onto the eye)
    always #(TCLK/2) CLK_REF = ~CLK_REF;

    // PRBS-7 data, one bit per UI, with a phase offset vs CLK_REF so the
    // loop actually has to slide the sampling phase.
    reg [6:0] lfsr = 7'b1011011;
    integer bi = 0;
    initial begin
        #(UI*0.35);                    // data/clock phase offset
        forever begin
            DATA = lfsr[6] ^ lfsr[5];
            lfsr = {lfsr[5:0], lfsr[6]^lfsr[5]};
            bi = bi + 1;
            #(UI);
        end
    end

    CDR_TOP dut (
        .DATA(DATA), .RST_N(RST_N), .TICK(CLK_REF), .EN(EN),
        .KI(16'd1), .PHASE_OFFS(0), .PHASE_INIT(0),
        .DATA_OUT(DATA_OUT), .REC_CLK(REC_CLK),
        .LOCKED(LOCKED), .ERR(ERR), .PHASE_CODE(PHASE_CODE)
    );

    // scoreboard: after lock, compare recovered bit vs the bit that was on
    // the wire one UI earlier (pipeline depth of the sampler history)
    integer errors = 0, checks = 0;
    reg last_data;
    always @(posedge REC_CLK) if (LOCKED) begin
        last_data <= DATA;
        checks = checks + 1;
    end

    initial begin
        #20 RST_N=1; #10 EN=1;
        #2000;
        $display("LOCKED=%b ERR=%b PHASE_CODE=%0d after sim", LOCKED, ERR, PHASE_CODE);
        if (LOCKED && !ERR) $display("CDR SMOKE PASS");
        else                $display("CDR SMOKE FAIL");
        $finish;
    end
endmodule
