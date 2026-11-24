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
    // Delay stages between adjacent taps.  The line is built as
    // NSTAGE = NPHASE*STEP + 1 stages: odd so the (non-inverting) AND
    // closure yields an odd loop inversion count -- a clean travelling-wave
    // ring.  The tapped body is NPHASE*STEP (an exact multiple), so tap k
    // sits at exactly k*STEP stages with no floor error, covering a half
    // period in 8 steps (the complementary edges complete the UI grid).
    // STEP sets the period: ring period ~= 2*NSTAGE*stage_delay.  STEP=6 ->
    // NSTAGE=49 (~243 MHz at ~42 ps/stage SS); STEP=3 -> NSTAGE=25
    // (~476 MHz).  DELAY_BITS is retained only for back-compat of the
    // parameter port; STEP takes precedence when nonzero.
    parameter integer DELAY_BITS  = 0,
    parameter integer STEP        = 3,
    // Extra unit-load fingers hung on the closing node chain[NSTAGE] to pull
    // the frequency DOWN without touching the (uniform) tap grid.  A static
    // parameter, not a runtime port: runtime phase/frequency control is the
    // PI's job (Stage B), this just centers the free-running period.  0 = no
    // extra load.
    parameter integer CLOSE_LOAD  = 0
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
    // NSTAGE = NPHASE*STEP + 1: odd (oscillates) and the tapped body is an
    // exact multiple of NPHASE, so tap k is exactly k*STEP stages in.
    // Back-compat: if STEP==0 fall back to the legacy 2^DELAY_BITS line.
    localparam integer STEP_EFF = (STEP != 0) ? STEP : (1 << (DELAY_BITS - PH_W));
    localparam integer NSTAGE   = NPHASE * STEP_EFF + 1;
    // Tap positions are exact multiples of STEP_EFF -- no floor error.
    function integer tap_stage(input integer k);
        begin
            tap_stage = k * STEP_EFF;
        end
    endfunction

    generate
        if (STEP == 0 && DELAY_BITS < PH_W) begin : g_bad_geometry
            // Fail closed at elaboration time rather than silently producing
            // a non-integer tap spacing (legacy DELAY_BITS path only).
            MULTIPHASE_DCO_REQUIRES_DELAY_BITS_GE_PH_W u_error();
        end
    endgenerate

    // Loop polarity and period.
    //
    // A ring of inverting stages oscillates only with an ODD stage count, but
    // the tap grid needs the delay line to span exactly ONE period with taps
    // at exact multiples of STEP.  NSTAGE = NPHASE*STEP + 1 satisfies both:
    // odd (oscillates) and the tapped body is NPHASE*STEP, so tap k lands at
    // exactly k*STEP with no floor error.
    //
    // (The previous 2^DELAY_BITS + 1 form also gave an odd line, but its tap
    // positions were floor(k*NSTAGE/NPHASE) -- a one-stage quantisation that
    // was harmless at NSTAGE=513 yet breaks the uniform grid on a short,
    // fast line.  The STEP form removes it exactly.)
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
    //
    // Each tap is driven through its own dont_touch buffer.  Without it the
    // tap node (chain[tap_stage]) carries the observability port AND the phase
    // mux as direct loads, so its routed wire is whatever the placer happened
    // to produce — measured on the routed macro that spread the tap-to-tap
    // spacing by up to ~72 ps, over the < 30 ps budget.  Buffering gives every
    // tap the same local load (one buffer input next to the stage + the next
    // chain stage); the off-tap wire length then moves onto the buffer output
    // where it does not perturb the ring's phase grid.  keep/dont_touch stops
    // ABC collapsing the buffer back into the chain.
    genvar t;
    generate
        for (t = 0; t < NPHASE; t = t + 1) begin : tap
            wire tap_iso;
            assign tap_iso = chain[tap_stage(t)];
            (* keep *) (* dont_touch = "true" *)
            PLL_CELL_BUFFX0 tap_buf (
`ifdef WITH_POWER
                .VDD(VDD), .VSS(VSS),
`endif
                .I(tap_iso), .Z(PHASE[t])
            );
        end
    endgenerate

    // Closing stage: NON-inverting (AND) enable so the loop inversion count
    // is exactly NSTAGE -- odd for the STEP geometry -> a clean travelling-
    // wave ring.  The tapped body is NPHASE*STEP stages (an exact multiple),
    // so tap k sits at k*STEP and the grid spans the half-line; the odd
    // NSTAGE line is the full loop period, one tap step == T/NPHASE.
    //
    // (The previous form closed with an inverting NAND: NSTAGE+1 inversions
    // is EVEN, which is a relaxation/bi-stable mode, not a travelling wave --
    // it can latch when released and its tap grid measured 0/83/166/250 deg,
    // not the T/8 a sampler needs.  The AND closure fixes both.)
    PLL_CELL_AND2X1 loop_close (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .A0(chain[NSTAGE]), .A1(DCO_EN), .Z(loop_back)
    );

    // Static frequency centering: CLOSE_LOAD extra unit loads hang on the
    // closing node chain[NSTAGE].  That node is the ring boundary (not a tap
    // node), so loading it shifts the period uniformly while the 8-way tap
    // grid stays exact.  Each finger is an inverter with its input on the
    // node and its output left open -- a load only.
    generate
        for (genvar f = 0; f < CLOSE_LOAD; f = f + 1) begin : close_load
            (* keep *) (* dont_touch = "true" *)
            PLL_CELL_INVX1 load_inv (
`ifdef WITH_POWER
                .VDD(VDD), .VSS(VSS),
`endif
                .I(chain[NSTAGE]), .ZN()
            );
        end
    endgenerate

    // Complementary end of the line for a differential buffer, if used.
    assign DCO_OUT_N = chain[NSTAGE-1];

endmodule
`default_nettype wire
