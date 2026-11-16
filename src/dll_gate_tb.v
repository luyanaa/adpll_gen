// Gate-level/SDF closed-loop smoke for the Route B DLL.
`timescale 1ns/1ps
module dll_gate_tb;
    reg REF = 1'b0;
    always #2.5 REF = ~REF;
    reg TICK = 1'b0;   // unused by the physical TDC
    reg RST_N = 1'b1;
    reg EN = 1'b1;
    reg [8:0] CODE_START = 9'd88;
    wire OUT, LOCKED, PHASE_OK, RANGE_OK, CODE_RAILED, ALIVE;
    wire [8:0] CODE;
    wire PFD_UP, PFD_DN, ACQ_BUSY, ACQ_OK, ACQ_FAIL;

`ifdef SDF_FILE
    initial $sdf_annotate(`SDF_FILE, dut);
`endif

    DLL_FULL_PERIOD_TOP dut (
        .REF(REF), .RST_N(RST_N), .EN(EN), .TICK(TICK),
        .CODE_START(CODE_START),
        .OUT(OUT), .LOCKED(LOCKED), .PHASE_OK(PHASE_OK),
        .RANGE_OK(RANGE_OK), .CODE_RAILED(CODE_RAILED), .ALIVE(ALIVE),
        .CODE(CODE), .PFD_UP(PFD_UP), .PFD_DN(PFD_DN),
        .ACQ_BUSY(ACQ_BUSY), .ACQ_OK(ACQ_OK), .ACQ_FAIL(ACQ_FAIL)
    );

    real ref_t, ph, delay;
    always @(posedge REF) ref_t = $realtime;
    always @(posedge OUT) begin
        ph = $realtime - ref_t;
        if (ph < 0.0) ph = ph + 5.0;
    end

    integer k;
    initial begin
        #1 RST_N = 1'b0;
        #20 RST_N = 1'b1;
        for (k = 0; k < 2000; k = k + 1) begin
            @(posedge REF);
            if (LOCKED === 1'b1) begin
                // ph is the time from the latest REF edge.  A 0T lock shows
                // up as a small ph; unwrap it by one period and require the
                // delay to be a full period, not one period plus an offset.
                delay = (ph < 2.5) ? ph + 5.0 : ph;
                $display("GL DLL: LOCKED after %0d REF, CODE=%0d phase=%0.3f delay=%0.3f per=%0d main=%0d mon=%0d",
                         k, CODE, ph, delay, dut.period_ticks, dut.main_stamp,
                         dut.mon_stamp);
                if (delay < 4.0 || delay >= 5.1) begin
                    $display("FAIL: gate-level DLL phase not full-period (delay=%0.3f)", delay);
                    $fatal(1, "phase");
                end
                $display("dll_gate_tb: PASS");
                $finish;
            end
        end
        $display("FAIL: gate-level DLL did not lock, CODE=%0d LOCKED=%b",
                 CODE, LOCKED);
        $fatal(1, "lock");
    end
endmodule
