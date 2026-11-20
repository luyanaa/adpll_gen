`timescale 1ns/1ps
module ratio_change_tb;
  localparam W=5;
  reg clk=0, rst_n=0, load_div=0;
  reg [W-1:0] set_div=2;
  wire out; wire [W-1:0] div_q; wire div_even;
  pll_mod_divider #(.W(W), .DIV_INIT(2)) dut (
    .clk(clk), .rst_n(rst_n), .set_div(set_div), .load_div(load_div),
    .out(out), .div_q(div_q), .div_even(div_even));
  always #5000 clk = ~clk;
  integer errs=0;
  task check(input [W-1:0] want);
    begin
      if (div_q !== want) begin
        $display("  FAIL: div_q=%0d expected %0d at %0t", div_q, want, $time);
        errs=errs+1;
      end else
        $display("  OK: div_q=%0d (div_even=%b)", div_q, div_even);
    end
  endtask
  initial begin
    repeat(4) @(posedge clk); rst_n=1; repeat(2) @(posedge clk);
    $display("initial:"); check(2);
    // commit a sequence of ratios, each must take effect
    for (int d=3; d<=9; d+=2) begin
      set_div=d[W-1:0]; load_div=1; @(negedge clk); load_div=0;
      repeat (4*d + 8) @(posedge clk);
      $display("after SET_DIV=%0d:", d); check(d[W-1:0]);
    end
    set_div=2; load_div=1; @(negedge clk); load_div=0;
    repeat (30) @(posedge clk);
    $display("back to 2:"); check(2);
    if (errs==0) $display("ratio_change_tb: PASS"); else $display("ratio_change_tb: FAIL %0d", errs);
    $finish;
  end
endmodule
