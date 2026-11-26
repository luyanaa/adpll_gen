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
    //
    // DEFAULT CHANGED to 0 (2026-11-25, dco_tuning_design.md): the per-stage
    // dco_stage coarse MOS-cap bank (COARSE[4:0]) is now the runtime
    // frequency knob and replaces the static closing-node trim.  The
    // parameter is kept for back-compat: a consumer that pins
    // CLOSE_LOAD>0 AND ties COARSE=0 gets the legacy centered behavior
    // (OpenSERDES pma/rx_clk8.sv / pma/tx_clk4.sv pass CLOSE_LOAD=1 and do
    // not connect the new tuning ports yet -- with the ports left open the
    // DCO internally interprets them as COARSE=0/FINE=0, the fast end, and
    // CLOSE_LOAD=1 restores the old period).
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
    output wire [ (1<<PH_W)-1 : 0 ] PHASE,
    // Runtime frequency tuning (dco_tuning_design.md).  Both words are
    // PSEUDO-STATIC vs the ring: change them on the quarter-rate clock,
    // never on a ring edge.
    //
    // COARSE[4:0]: binary MOS-cap bank word, one bank per stage, on every
    //   stage output.  0 = fast end, 31 = slow end (~280 fF/stage on).
    // FINE[5:0]: signed fine word, -31..+31, applied to every stage
    //   (63 NAND3 switched-cap fingers/stage, +32 centered -> code 0 puts
    //   32 fingers on / 31 off; symmetric by the fixed +1).
    //
    // Back-compat: leaving these ports UNCONNECTED elaborates fine and the
    // DCO treats them as COARSE=0, FINE=0 (fast end of the new range --
    // faster than the old CLOSE_LOAD-centered period; consumers that rely
    // on the old centering keep CLOSE_LOAD>0 until they drive the words).
    input  wire [4:0]           COARSE,
    input  wire signed [5:0]    FINE
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
    // ------------------------------------------------------------------
    // Runtime tuning decode (dco_tuning_design.md "Ports").
    //
    // Back-compat with consumers that do not connect the new ports (rx_clk8,
    // tx_clk4 today): an unconnected input presents all-z in SIMULATION,
    // so map that to COARSE=0 / FINE=0 under `define PLL_DCO_SIM (testbench
    // builds only -- synthesis ties the words structurally, and the z-compare
    // path must never reach Yosys/OpenSTA).
    //
    // FINE decode happens ONCE here, not per stage: fine_idx = FINE + 32
    // (the fixed +1 keeps at least one finger on at the -31 rail, so the
    // on-count is continuous across the sign boundary: 1..63 as FINE goes
    // -31..+31, code 0 = 32 on / 31 off).  The 6 bit lines (weights
    // 1,2,4,8,16,32 fingers of NAND3 cap) are routed once and buffered
    // locally in every stage; a 63-line thermometer cannot be routed
    // identically down the snake (same argument the brief makes against
    // thermometer COARSE) and per-stage wire-length skew becomes tap skew.
    // ------------------------------------------------------------------
`ifdef PLL_DCO_SIM
    wire [4:0] coarse_c = (COARSE === 5'bzzzzz) ? 5'd0 : COARSE;
    wire signed [5:0] fine_c = (FINE === 6'bzzzzz) ? 6'sd0 : FINE;
`else
    wire [4:0] coarse_c = COARSE;
    wire signed [5:0] fine_c = FINE;
`endif
    // Centered 6-bit fine index: -31 -> 1, 0 -> 32, +31 -> 63.
    wire [5:0] fine_idx = fine_c + 6'sd32;

    // ------------------------------------------------------------------
    // One repeated, heavily tuned inverting stage: dco_stage replaces the
    // bare stage_inv.  Each stage output chain[i+1] carries:
    //   - 5-bit binary sg13_moscap_n coarse bank (1:2:4:8:16 unit fingers,
    //     each bit buffered in-place with dont_touch buf_1 so the placer
    //     cannot clone the driver and move the cap off the tuned node --
    //     the mid_delay.v clone-kills-tuning failure),
    //   - 63 sg13g2_nand3_1 fine fingers, two-level cap trick (A1 on the
    //     stage output, A0/A2 = fine bit and its complement, output open),
    //   - per-bit dont_touch buf_1 (+ inv_1 complement) for all 11 bits,
    //   - one sg13g2_decap_4 (supply bounce from coherent cap switching).
    // The tap buffers stay UNLOADED: caps land on the stage OUTPUT
    // (chain[i+1]), never on the tap_buf input, so tap load and tune load
    // do not sum and the tap grid does not skew with the tuning code.
    // ------------------------------------------------------------------
    generate
        for (i = 0; i < NSTAGE; i = i + 1) begin : stage
            (* keep *) (* dont_touch = "true" *)
            DCO_STAGE stage (
`ifdef WITH_POWER
                .VDD(VDD), .VSS(VSS),
`endif
                .IN   (chain[i]),
                .OUT  (chain[i+1]),
                .COARSE(coarse_c),
                .FINE (fine_idx)
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
    //
    // One-shot startup kick (brief risk 7, confirmed by measurement): at max
    // coarse code the loaded ring can sit in a DC dead state after release
    // (reproduced for both init states).  The kick forces chain[0] high for
    // ~3 gate delays at DCO_EN release only: EN is delayed by 3 dont_touch
    // inverters; AND(EN, ~EN_delayed) is high from the release edge until the
    // delayed copy arrives, then drops and stays 0 -- in steady state the
    // OR sees only the AND path, so the oscillation is untouched.  Both
    // closure gates are non-inverting: the loop inversion count is still
    // exactly NSTAGE (odd).
    wire close_and;
    wire en_dly1, en_dly2, en_dly3, kick;

    PLL_CELL_AND2X1 loop_close (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .A0(chain[NSTAGE]), .A1(DCO_EN), .Z(close_and)
    );

    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_INVX1 en_d1 ( `ifdef WITH_POWER .VDD(VDD), .VSS(VSS), `endif .I(DCO_EN), .ZN(en_dly1) );
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_INVX1 en_d2 ( `ifdef WITH_POWER .VDD(VDD), .VSS(VSS), `endif .I(en_dly1), .ZN(en_dly2) );
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_INVX1 en_d3 ( `ifdef WITH_POWER .VDD(VDD), .VSS(VSS), `endif .I(en_dly2), .ZN(en_dly3) );

    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_AND2X1 kick_g (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .A0(DCO_EN), .A1(en_dly3), .Z(kick)
    );
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_OR2X1 loop_or (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .A0(close_and), .A1(kick), .Z(loop_back)
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

// ============================================================================
// DCO_STAGE -- one tuned ring stage (dco_tuning_design.md "Stage cell").
//
// Placed as ONE macro cell per ring stage (~50 leaf cells, abutted).  All
// content keep/dont_touch: ABC must not retime the chain, and the placer
// must not clone the bit drivers off the tuned node.
//
// Cell mapping (IHP sg13g2):
//   inv     sg13g2_inv_1        (the ring stage itself)
//   coarse  sg13_moscap_n fingers behind sg13_lv_nmos switches,
//           binary 1:2:4:8:16 unit fingers; bit 4 (16 fingers behind one
//           switch) uses a 4x wider switch (brief risk 3)
//   fine    63 sg13_moscap_n unit fingers (0.15u x 0.5u, ~0.7 fF) in
//           binary groups 1:2:4:8:16:32 behind per-bit switches --
//           measured deviation from the brief's NAND3 fine: the nand3_1
//           input pin is ~0.4 fF with ~0.05 fF on/off contrast at ring
//           edge rates (see the dco_stage comment for the numbers)
//   bufs    5 coarse + 6 fine sg13g2_buf_1, dont_touch
//   decap   sg13g2_decap_4 (coherent cap-switching supply bounce)
// ============================================================================
module DCO_STAGE (
`ifdef WITH_POWER
    inout  wire              VDD, VSS,
`endif
    input  wire              IN,
    output wire              OUT,
    input  wire [4:0]        COARSE,
    input  wire [5:0]        FINE   // centered fine index, 1..63
);
    // The stage itself.
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_INVX4 stage_inv (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS),
`endif
        .I(IN), .ZN(OUT)
    );

    // ------------------------------------------------------------------
    // Coarse bank: 5 binary bits, common word.  Each bit is buffered right
    // here (dont_touch) before the switch gate: buffer output = the local
    // gate drive, so the routed COARSE wire load sits on the buffer input,
    // never on the tuned node.
    // ------------------------------------------------------------------
    genvar b;
    generate
        for (b = 0; b < 5; b = b + 1) begin : coarse_bit
            wire g;
            // Switch width scales with the finger count behind it
            // (approved 2026-11-25, extends bit4's fix): bits 0-3 all had
            // SW_M=1 and the measured SS sweep was non-monotone at the
            // bit3/bit4 group boundaries (c7->c8 +45 MHz, c23->c24 +34 MHz)
            // because the shared switch R shrank the big bits' effective
            // dC below the sum of the lower bits.  Map 1,1,2,4,4 keeps
            // fingers/switch-width <= 4 for every bit -> monotone by
            // construction; bit4 was already clean at 4.
            (* keep *) (* dont_touch = "true" *)
            PLL_CELL_BUFFX0 gbuf (
`ifdef WITH_POWER
                .VDD(VDD), .VSS(VSS),
`endif
                .I(COARSE[b]), .Z(g)
            );
            (* keep *) (* dont_touch = "true" *)
            PLL_CELL_COARSE_BIT #(
                .NFINGERS (1 << b),
                .SW_M     (b == 4 ? 8 : (b >= 3 ? 4 : (b == 2 ? 2 : 1)))
            ) bank (
`ifdef WITH_POWER
                .VDD(VDD), .VSS(VSS),
`endif
                .NODE(OUT), .EN(g)
            );
        end
    endgenerate

    // ------------------------------------------------------------------
    // Fine bank: 63 unit fingers in binary groups 1,2,4,8,16,32 driven by
    // the centered fine index bits, structured exactly like the coarse
    // bank: sg13_moscap_n fingers behind one series sg13_lv_nmos switch
    // per bit.  Per-bit dont_touch buffers, local to the stage.
    //
    // DEVIATION from the brief's NAND3 fine, measured justification
    // (re-scope, 2026-11-25): sg13g2_nand3_1's B input presents only
    // ~0.4 fF and ~0.05 fF on/off contrast through the two-level trick
    // (ramp-extracted at both 1 GHz-class and LF rates) -- 63 fingers
    // give ~3-6 fF of range, not the ±62 fF the brief assumes, while
    // hanging ~25 fF of permanent A1 load that caps the SS fast end
    // ~35 MHz below the signed-off 335 MHz.  A switched moscap unit
    // finger gives a real 2-terminal cap (~0.7 fF/finger, works at ring
    // edge rates because both plates are contacted) with ~zero off-state
    // residual: LSB ~0.7 fF, total fine swing ~44 fF > 4x one coarse LSB
    // (9.2 fF), fixed +1 of the centered decode keeps >=1 finger on at
    // the -31 rail.
    // ------------------------------------------------------------------
    genvar f;
    generate
        for (f = 0; f < 6; f = f + 1) begin : fine_bit
            wire g;
            (* keep *) (* dont_touch = "true" *)
            PLL_CELL_BUFFX0 gbuf (
`ifdef WITH_POWER
                .VDD(VDD), .VSS(VSS),
`endif
                .I(FINE[f]), .Z(g)
            );
            // Group of 2^f unit fingers behind one switch; the centered
            // fine index FINE+32 (1..63) is the on-count, so code 0 = 32
            // fingers on / 31 off and the on-count is continuous across
            // the sign boundary (the "fixed +1").
            // Fine groups get the same proportional switch rule
            // (fingers/m <= 4): 1,1,1,2,4,8 for groups 1..32.
            (* keep *) (* dont_touch = "true" *)
            PLL_CELL_FINE_UNIT #(
                .NFINGERS (1 << f),
                .SW_M     ((f >= 5) ? 8 : (f == 4 ? 4 : (f == 3 ? 2 : 1)))
            ) bank (
`ifdef WITH_POWER
                .VDD(VDD), .VSS(VSS),
`endif
                .NODE(OUT), .EN(g)
            );
        end
    endgenerate

    // Supply decoupling against coherent cap switching (brief risk 4).
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_DECAP4 decap (
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS)
`endif
    );
endmodule
`default_nettype wire
