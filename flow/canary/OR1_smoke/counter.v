module counter (
  input  wire clk,
  input  wire d,
  output wire [3:0] q
);
  reg [3:0] sr;
  always @(posedge clk) sr <= {sr[2:0], d};
  assign q = sr;
endmodule
