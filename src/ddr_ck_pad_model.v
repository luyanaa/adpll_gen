// Functional DDR CK pad/load model.
//
// This is deliberately not an SI, IBIS or PVT model.  It gives the RTL path a
// matched differential driver delay and a load-dependent edge time so the
// measured duty and phase include a pad/load budget:
//
//   TDRIVE = TPAD + ROUT * LOAD + (TRISE + TFALL)/2
//
// Rise and fall are matched, so the load does not change duty; the phase
// measurement includes the common TDRIVE.  Use the selected PDK's IO cell and
// extracted load for any real signoff.
`timescale 1ns/1ps

module DDR_CK_PAD_MODEL #(
    parameter integer TPAD_PS = 80,
    parameter real    LOAD_PF = 0.5,
    parameter integer ROUT_OHM = 50,
    parameter integer TRISE_PS = 30,
    parameter integer TFALL_PS = 30
) (
    input  wire CK_PHY,
    input  wire CK_PHY_N,
    output wire PAD_CK_T,
    output wire PAD_CK_C
);
    localparam real TDRIVE_NS =
        (TPAD_PS + ROUT_OHM * LOAD_PF + (TRISE_PS + TFALL_PS) / 2.0) / 1000.0;

    assign #(TDRIVE_NS) PAD_CK_T = CK_PHY;
    assign #(TDRIVE_NS) PAD_CK_C = CK_PHY_N;
endmodule
