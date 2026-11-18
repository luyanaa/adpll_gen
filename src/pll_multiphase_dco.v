// Multi-phase DCO for a SerDes CDR backend.
//
// Requirement (../OpenSERDES docs/dll_backend.md section 5, rtl/cdr_multiphase.sv)
// ------------------------------------------------------------------------------
// The CDR_MODE=4 loop consumes 2^PH_W EQUALLY SPACED phases of the sample
// clock, one full period, monotonic, with the tap index exposed as a plain
// register slice:
//
//   tap[PH_W-1:0] -> external phase mux -> sampler -> rx_smp
//
// cdr_multiphase only ever selects a phase; it never generates the edge, so
// the phase spacing has to be uniform or the loop quantisation becomes
// non-uniform and the eye drifts per tap.  At 100 MHz with PH_W=3 that is
// 8 phases, 1.25 ns apart, one tap per 1/8 UI.
//
// Why the ring DCO cannot be tapped directly
// ------------------------------------------
// The obvious source is PLL_ILDCO's BASE_CHAIN, but that chain is only PART
// of the period (BASE_NDELS stages out of the full ring), and its delay
// changes with the coarse/mid/fine codes.  Tapping it would give a spacing
// that moves with the tuning word, which breaks the uniform-grid contract.
//
// This block therefore taps a dedicated in-loop delay line whose length is
// the WHOLE period, at every 2^(DELAY_BITS-PH_W) stages:
//
//   DCO_OUT -> [ DELAY_CELL x 2^DELAY_BITS ] -> return to the ring
//                      |  |  |  ...  |
//                      phase taps every 2^(DELAY_BITS-PH_W) stages
//
// Uniformity comes from the line being made of one repeated cell, so tap n
// sees exactly n identical stages.  The remaining tap error is the same
// cell-mismatch term the SerDes document budgets at < 30 ps static phase
// error.
//
// PH_W is a parameter: PH_W=3 -> 8 phases (documented default), PH_W=4 -> 16,
// PH_W=2 -> 4.  The requirement is 2^PH_W, so the line length is always a
// multiple of 2^PH_W.
//
// Scope note: the taps are STRUCTURAL.  Their spacing in nanoseconds is a
// per-PDK, per-corner number that has to come from STA or SPICE on the built
// macro (see flow/macro/*/ring_dco_*).  This module guarantees equal stage
// counts per tap, not a calibrated 1.25 ns.
`default_nettype none
`timescale 1ns/1ps

module PLL_MULTIPHASE_DCO #(
    // DLL tap-select width: 2^PH_W phases are produced.
    parameter integer PH_W        = 3,
    // Log2 of the total delay-line stage count.  9 -> 512 stages, i.e. 64
    // stages per tap at PH_W=3.  Must satisfy DELAY_BITS >= PH_W.
    parameter integer DELAY_BITS  = 9
) (
`ifdef WITH_POWER
    inout  wire                 VDD, VSS,
`endif
    input  wire                 DCO_EN,
    // Ring return: the delay line closes the oscillator loop.
    output wire                 DCO_OUT,
    output wire                 DCO_OUT_N,
    // 2^PH_W equally spaced phases inside one period.  PHASE[0] is the first
    // tap after DCO_OUT; PHASE[n] is n * (period / 2^PH_W) later.
    output wire [ (1<<PH_W)-1 : 0 ] PHASE
);
    localparam integer NPHASE = 1 << PH_W;
    // Odd stage count so the line both oscillates and spans one full period.
    localparam integer NSTAGE = (1 << DELAY_BITS) | 1;
    // Stages between two adjacent taps.  Integer by construction because
    // DELAY_BITS >= PH_W; the elaboration check below enforces it.
    // Tap positions are floor(k * NSTAGE / NPHASE) stages.  With an odd
    // NSTAGE that is not a single integer, so neighbouring taps differ by one
    // stage at most -- that one-stage quantisation is inherent to putting
    // 2^PH_W taps on an odd-length line and is well below one tap step.
    function integer tap_stage(input integer k);
        begin
            tap_stage = (k * NSTAGE) / NPHASE;
        end
    endfunction

    generate
        if (DELAY_BITS < PH_W) begin : g_bad_geometry
            // Fail closed at elaboration time rather than silently producing
            // a non-integer tap spacing.
            MULTIPHASE_DCO_REQUIRES_DELAY_BITS_GE_PH_W u_error();
        end
    endgenerate

    // Loop polarity and period.
    //
    // A ring of inverting stages oscillates only with an ODD stage count, but
    // the tap grid needs the delay line itself to span exactly ONE period so
    // that tap k sits at k*(period/2^PH_W).  Both requirements are met by
    // making the tapped line an odd number of stages and letting that same
    // line be the whole loop: NSTAGE is 2^DELAY_BITS + 1 stages.
    //
    // (An earlier version used 2^DELAY_BITS stages plus a separate closing
    // NAND.  The taps then spanned only NSTAGE/(NSTAGE+1) of a period, so the
    // last phase was short of a full grid and the CDR's uniform-spacing
    // assumption broke.  That is what the divided-grid check below catches.)
    wire [NSTAGE:0] chain;
    assign chain[0] = DCO_OUT;
    wire loop_back;
    assign DCO_OUT = loop_back;

    genvar i;
    generate
        for (i = 0; i < NSTAGE; i = i + 1) begin : stage
            // One repeated inverting stage.  Keeping every stage prevents ABC
            // from collapsing the line, exactly as the ring DCO base chain
            // needs (see src/il_dco.v): a collapsed line shortens the period
            // and destroys the phase grid.
            (* keep *) (* dont_touch = "true" *)
            PLL_CELL_INVX1 stage_inv (
`ifdef WITH_POWER
                .VDD(VDD), .VSS(VSS),
`endif
                .I(chain[i]), .ZN(chain[i+1])
            );
        end
    endgenerate

    // Tap every STEP stages.  NSTAGE is a multiple of NPHASE, so the taps
    // partition the line and tap k is exactly k*STEP stages from DCO_OUT.
    genvar t;
    generate
        for (t = 0; t < NPHASE; t = t + 1) begin : tap
            assign PHASE[t] = chain[tap_stage(t)];
        end
    endgenerate

    // Closing stage: inverting NAND with the enable, giving the odd inversion
    // the ring needs without perturbing the delay grid.
    PLL_CELL_NAND2X1 loop_close (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .A0(chain[NSTAGE]), .A1(DCO_EN), .ZN(loop_back)
    );

    // Complementary end of the line for a differential buffer, if used.
    assign DCO_OUT_N = chain[NSTAGE-1];

endmodule
`default_nettype wire
