`timescale 1ps/1fs
// Gate-level smoke test for PLL_ANALOG_MACRO with post-PnR SDF.
// This is a logic-level macro test, not a transistor-level analog simulation.
module test_pll_analog_macro;
  reg DCO_EN=0, INJ_EN=0, REF=0;
  reg [14:0] COARSE_MUX=15'h7fff;
  reg [14:0] MID_MUX=15'h7fff;
  reg [30:0] FINE_MUX=31'h7fffffff;
  wire INJ_EDGE, MID_OUT, OUT;
  wire [1:0] SS_BBPD;
  wire VDD=1'b1, VSS=1'b0;

  integer edges=0;
  time first=0;
  time last=0;
  time period=0;
  time avg=0;

  // Fast REF toggle used only to kick-start the injection-locked macro.
  always #5000 REF = ~REF;

  always @(posedge OUT) begin
    edges = edges + 1;
    if (edges == 1) first = $time;
    if (edges > 4) period = $time - last;
    last = $time;
    if (edges > 1) avg = (last - first) / (edges - 1);
  end

  PLL_ANALOG_MACRO dut (
    .DCO_EN(DCO_EN), .INJ_EN(INJ_EN), .REF(REF),
    .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
    .INJ_EDGE(INJ_EDGE), .MID_OUT(MID_OUT), .OUT(OUT), .SS_BBPD(SS_BBPD),
    .VDD(VDD), .VSS(VSS)
  );

  initial begin
`ifndef NOSDF
    // Icarus 12 accepts the file and instance; it warns that the optional
    // log/corner arguments are ignored.  Use OpenSTA for signoff corner work.
    $sdf_annotate("PLL_ANALOG_MACRO.sdf", dut);
`endif
    #1 DCO_EN = 1'b1;
    INJ_EN = 1'b1;
    #200000;
    $display("POST_PNR_RESULT edges=%0d last_period_ps=%0d avg_period_ps=%0d time_ps=%0d", edges, period, avg, $time);
    $finish;
  end

  initial begin
    $dumpfile(`ifdef NOSDF "test_pll_analog_macro_nosdf.vcd" `else "test_pll_analog_macro_sdf.vcd" `endif);
    $dumpvars(0, test_pll_analog_macro);
  end
endmodule
