// Physical tap-out for the phase selector.
//
// The selector needs NTAPS parallel phases, while PLL_COUNTER_DCDL_PHYS is a
// single-output DCDL.  This block builds the tap-out from the same
// FINE_DELAY_CELL used by the DCDL fine bank: one cell per tap, all loads
// enabled (MUX=1), and every intermediate node exposed.  TAP[0] is the
// undelayed input; TAP[g] is g fine-cell delays.
//
// The step is the physical fine-cell delay.  With 50 ps input transition and
// a 2 fF tap load, OpenSTA measures about 35 ps at ics55 H7CR TT, 61 ps at
// SS (1.08 V, 125 C) and 24 ps at FF (1.32 V, -40 C).  The SIMULATION branch
// of PHASE_SELECTOR_TOP uses a 60 ps model step, so tap index must be
// calibrated per PDK/corner before it is used as a phase number.
module PLL_DCDL_TAP_BUS_PHYS #(
    parameter integer NTAPS = 16
) (
    input  wire             CLK_IN,
    output wire [NTAPS-1:0] TAP
);
    wire [NTAPS:0] chain;
    assign chain[0] = CLK_IN;

    genvar g;
    generate
        for (g = 0; g < NTAPS; g = g + 1) begin : stage
            // Same fine-delay cell as the DCDL fine bank.  VDD/VSS are
            // intentionally left open in this structural view.
            FINE_DELAY_CELL u_cell (
                .MUX(1'b1),
                .IN(chain[g]),
                .OUT(chain[g+1])
            );
            assign TAP[g] = chain[g];
        end
    endgenerate
endmodule
