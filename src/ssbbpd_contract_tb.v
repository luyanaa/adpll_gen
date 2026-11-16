// SS-BBPD symbol contract regression.
//
// The latch in ssbbpd.v cannot pull both buffered outputs low, so 2'b00 is
// not a reachable stable state.  At the DLF sampling edge
// (posedge(!INJ_EDGE) == negedge INJ_EDGE) the only reachable codes are
// the two phase decisions 2'b01 (P) and 2'b11 (N); 2'b10 is the latch
// resolution outside that phase.  A lock detector that waits for 00 can
// never qualify.
`timescale 1ns/1ps

module ssbbpd_contract_tb;
    reg REF = 1'b0;
    always #5 REF = ~REF;

    // Injection edge: REF delayed by the same 74 ps as sim_pll_injection.
    reg INJ_EDGE = 1'b0;
    always @(REF) INJ_EDGE <= #0.074 REF;

    // Slightly off 1 GHz so the oscillator phase at the REF edges walks
    // through the whole period over the run.
    reg VCO = 1'b0;
    initial begin
        #0.13;
        forever #0.487 VCO = ~VCO;
    end

    wire [1:0] code;
    sim_SSBBPD pd(
        .CLK_VCO(!VCO),
        .CLK_REF(!INJ_EDGE),
        .SS_BBPD(code)
    );

    integer cp0=0, cp1=0, cp2=0, cp3=0;
    integer cn0=0, cn1=0, cn2=0, cn3=0;
    integer errors = 0;
    integer i;

    // Count the value the sampling flop sees.  The code is read in the
    // active region at the edge, before the model's nonblocking update.
    always @(posedge INJ_EDGE) begin
        case (code)
            2'b00: cp0 = cp0 + 1;
            2'b01: cp1 = cp1 + 1;
            2'b10: cp2 = cp2 + 1;
            2'b11: cp3 = cp3 + 1;
        endcase
    end
    always @(negedge INJ_EDGE) begin
        case (code)
            2'b00: cn0 = cn0 + 1;
            2'b01: cn1 = cn1 + 1;
            2'b10: cn2 = cn2 + 1;
            2'b11: cn3 = cn3 + 1;
        endcase
    end

    initial begin
        for (i = 0; i < 200; i = i + 1) begin
            @(posedge INJ_EDGE);
            @(negedge INJ_EDGE);
        end

        $display("posedge INJ: 00=%0d 01=%0d 10=%0d 11=%0d",
                 cp0, cp1, cp2, cp3);
        $display("negedge INJ: 00=%0d 01=%0d 10=%0d 11=%0d",
                 cn0, cn1, cn2, cn3);

        // 00 is not a stable NAND state at either edge.
        if (cp0 != 0 || cn0 != 0) begin
            $display("FAIL: 00 was sampled (pos=%0d neg=%0d)", cp0, cn0);
            errors = errors + 1;
        end else begin
            $display("PASS: 00 never sampled");
        end

        // The DLF edge sees only the two decisions, and both occur.
        if (cn2 != 0) begin
            $display("FAIL: 10 sampled at the DLF edge %0d times", cn2);
            errors = errors + 1;
        end else if (cn1 == 0 || cn3 == 0) begin
            $display("FAIL: DLF edge did not see both P and N (01=%0d 11=%0d)",
                     cn1, cn3);
            errors = errors + 1;
        end else begin
            $display("PASS: DLF edge sees only P/N, both present");
        end

        if (errors != 0) $fatal(1, "ssbbpd_contract_tb failed");
        $display("ssbbpd_contract_tb: PASS");
        $finish;
    end
endmodule
