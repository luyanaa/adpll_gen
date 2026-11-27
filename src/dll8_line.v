`timescale 1ps/1ps
// Purpose-built 8-phase all-digital DLL delay line.
//
// Architecture (approved 2026-11-27):
//   * EIGHT identical elements lock to a FULL period (8d = T).  A 4-element
//     half-period line puts the REF duty cycle directly into d (1% duty
//     error = +35 ps at tap 7 at 500 MHz, over the 30 ps budget); 8d = T is
//     duty-immune and is the textbook DLL.
//   * Per-element fine trim: 8 independent codes = shared loop code + a
//     signed per-element trim.  Independent residuals give tap-7 error
//     ~1.32*LSB instead of 3.5*LSB for one shared code, so a 20 ps cell
//     passes and 10 ps is the aim.
//   * Element: two INVX4 stages with a NAND3 switched-cap bank on the middle
//     node (the fine_delay.v pattern), all sg13g2 stdcell.  Binary
//     1:2:4:8:16:32:64 finger groups (one buffer + one inverter per bit):
//     monotone by construction, 7-bit code, LSB = one finger.
//
// Two backends (dll_dcdl.v convention):
//   DLL8_IMPL=0 : parameterised transport-delay model (BASE + CODE*STEP),
//                 used for the loop / conformance verification.
//   DLL8_IMPL=1 : the real sg13g2 stdcell structure; timing from SPICE/STA.
`default_nettype none

module DLL8_ELEM #(
    parameter integer BASE_PS   = 110,
    parameter integer STEP_PS   = 3,
    parameter integer CODE_BITS = 7,
    parameter integer DLL8_IMPL = 0
) (
    input  wire                  IN,
    input  wire [CODE_BITS-1:0]  CODE,
    output wire                  OUT,
    output wire                  LOAD
);
    generate
        if (DLL8_IMPL == 0) begin : model
            // Transport delay = BASE + CODE*STEP (Icarus evaluates the delay
            // expression when the event executes, so CODE can change at run
            // time exactly like a trimmed physical element).
            reg d;
            always @(IN) d <= #(BASE_PS + CODE * STEP_PS) IN;
            assign OUT  = d;
            assign LOAD = 1'b0;
        end else begin : phys
            // The real stdcell structure lives in its own module so the
            // implementation split does not need a nested generate
            // (iverilog rejects for-generate inside if-generate).
            DLL8_ELEM_PHYS #(.CODE_BITS(CODE_BITS)) u_phys (
                .IN(IN), .CODE(CODE), .OUT(OUT), .LOAD(LOAD)
            );
        end
    endgenerate
endmodule

// Real sg13g2 stdcell element: two INVX4 stages with a NAND3 switched-cap
// bank on the middle node (fine_delay.v pattern).  Binary 1:2:4:8:16:32:64
// finger groups, one buffer + one inverter per bit: monotone by
// construction, LSB = one finger.
module DLL8_ELEM_PHYS #(
    parameter integer CODE_BITS = 7
) (
    input  wire                  IN,
    input  wire [CODE_BITS-1:0]  CODE,
    output wire                  OUT,
    output wire                  LOAD
);
    // Fingers are separate generate loops (iverilog does not support nested
    // generate loops): finger n belongs to bit f_log2(n+1), so group b holds
    // exactly 2^b fingers -> binary weighting 1:2:4:8:16:32:64.
    function integer f_log2(input integer v);
        integer k;
        begin
            f_log2 = 0;
            for (k = 0; k < 16; k = k + 1)
                if ((1 << k) <= v) f_log2 = k;
        end
    endfunction

    wire mid;
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_INVX4 u_in (.I(IN), .ZN(mid));
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_INVX4 u_out (.I(mid), .ZN(OUT));
    // Per-bit buffered select lines (one buffer + one inverter per bit).
    // (Port connections, not generate-scope assigns: iverilog 12 rejects
    // assigning a vector element from inside a generate loop.)
    wire [CODE_BITS-1:0] g, gb;
    genvar b;
    generate
        for (b = 0; b < CODE_BITS; b = b + 1) begin : bitgrp
            DLL8_BITBUF u_bitbuf (
                .I(CODE[b]), .G(g[b]), .GB(gb[b])
            );
        end
    endgenerate

    genvar n;
    generate
        for (n = 0; n < (1 << CODE_BITS) - 1; n = n + 1) begin : finger
            localparam integer FB = f_log2(n + 1);
            (* keep *) (* dont_touch = "true" *)
            PLL_CELL_NAND3X1 cap (
                .A0(g[FB]), .A1(mid), .A2(gb[FB]), .ZN()
            );
        end
    endgenerate
    assign LOAD = mid;
endmodule

module DLL8_BITBUF (
    input  wire I,
    output wire G,
    output wire GB
);
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_BUFFX0 gbuf (.I(I), .Z(G));
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_INVX1 ginv (.I(G), .ZN(GB));
endmodule

// Eight-element line: tap k = (k+1) element delays from IN.  Per-element
// code ports allow independent trim; all outputs are 50% duty by
// construction (a chain of inverters), so the taps are duty-clean.
module DLL8_LINE #(
    parameter integer BASE_PS   = 110,
    parameter integer STEP_PS   = 3,
    parameter integer CODE_BITS = 7,
    parameter integer DLL8_IMPL = 0
) (
    input  wire                     IN,
    input  wire [8*CODE_BITS-1:0]   CODES,   // element i = CODES[i*CB +: CB]
    output wire [7:0]               TAP
);
    wire [8:0] n;
    assign n[0] = IN;
    assign TAP = {n[8], n[7], n[6], n[5], n[4], n[3], n[2], n[1]};
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : elem
            DLL8_ELEM #(
                .BASE_PS(BASE_PS), .STEP_PS(STEP_PS),
                .CODE_BITS(CODE_BITS), .DLL8_IMPL(DLL8_IMPL)
            ) u_elem (
                .IN(n[i]),
                .CODE(CODES[i*CODE_BITS +: CODE_BITS]),
                .OUT(n[i+1]),
                .LOAD()
            );
        end
    endgenerate
endmodule
`default_nettype wire
