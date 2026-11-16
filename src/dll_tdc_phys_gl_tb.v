// Gate-level/SDF smoke test for the physical delay-line TDC.
//
// The netlist is the Yosys/abc mapped DLL_TDC_PHYS_MEAS.  PHASE_IN is REF,
// OUT is REF delayed by ~4.5 ns, ACQ is REF/16, MON_OUT is ACQ delayed by
// ~4.5 ns.  The period code should be one REF period in tap units; the main
// code should be the ~4.5 ns phase.  The exact values depend on the SDF
// corner.
`timescale 1ns/1ps

module dll_tdc_phys_gl_tb;
    reg REF = 1'b0;
    always #2.5 REF = ~REF;

    reg [3:0] div = 4'd0;
    always @(posedge REF) div <= div + 1'b1;
    wire ACQ = div[3];
    reg ACQ_LATCH = 1'b0;
    always @(posedge REF) ACQ_LATCH <= (div == 4'd7);

    reg OUT = 1'b0;
    reg MON_OUT = 1'b0;
    always @(posedge REF) OUT <= #(4.5) 1'b1;
    always @(negedge REF) OUT <= #(4.5) 1'b0;
    always @(posedge ACQ) MON_OUT <= #(4.5) 1'b1;
    always @(negedge ACQ) MON_OUT <= #(4.5) 1'b0;

    reg RST_N = 1'b0;
    wire [15:0] ref_stamp, period_ticks, main_stamp, mon_stamp, acq_stamp;
    wire main_tog, mon_tog;

`ifdef SDF_FILE
    initial $sdf_annotate(`SDF_FILE, dut);
`endif

    DLL_TDC_PHYS_MEAS dut (
        .REF(REF), .ACQ_CLK(ACQ), .PHASE_IN(REF), .OUT(OUT),
        .MON_OUT(MON_OUT), .RST_N(RST_N), .ACQ_LATCH(ACQ_LATCH),
        .ref_stamp(ref_stamp), .period_ticks(period_ticks),
        .main_stamp(main_stamp), .main_tog(main_tog),
        .mon_stamp(mon_stamp), .mon_tog(mon_tog), .acq_stamp(acq_stamp)
    );

    integer k;
    initial begin
        #2 RST_N = 1'b1;
        repeat (40) @(posedge REF);
        $display("GL TDC: period=%0d main=%0d mon=%0d", period_ticks,
                 main_stamp, mon_stamp);
        if (period_ticks == 0 || period_ticks > 400) begin
            $display("FAIL: period code out of range");
            $fatal(1, "period code");
        end
        if (main_stamp == 0 || main_stamp > 400) begin
            $display("FAIL: main code out of range");
            $fatal(1, "main code");
        end
        $display("dll_tdc_phys_gl_tb: PASS");
        $finish;
    end
endmodule
