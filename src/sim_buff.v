`timescale 1ns/1ps
// Simulation-only buffer for the fixed Core B base-delay bank.  The physical
// implementation maps this bank to ics55 BUFX0P5H7R cells.
module sim_buff(input I, output Z);
    assign #0.030 Z = I;
endmodule
