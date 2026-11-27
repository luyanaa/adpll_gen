`timescale 1ps/1ps
// Purpose-built 8-phase all-digital DLL delay line.
//
// Architecture (approved 2026-11-27, SPICE-confirmed):
//   * EIGHT identical elements lock to a FULL period (8d = T): duty-cycle
//     immune, taps at k*d.
//   * Per-element signed trim: code_i = clamp(loop + trim_i).
//   * Element (SPICE-measured, in lockstep with the RTL below):
//       stage 1: balanced custom driver "INVX4-B" (Wp=5.30um, Wn=2.96um),
//                NOT stock sg13g2_inv_4 (Wp=4.48/Wn=2.96, too-weak PMOS under
//                the bank load -> tpHL/tpLH asymmetry)
//       stage 2: sg13g2_inv_4
//       bank   : 7-bit THERMOMETER (127) of symmetric N/P switched
//                sg13_moscap (0.9 x 1.1 um, ~12.7 fF/finger): even fingers
//                NMOS->VSS (moscap_n), odd fingers PMOS->VDD (moscap_p),
//                each driven by buf_8 / inv_8.
//
// Two backends (dll_dcdl.v convention):
//   DLL8_IMPL=0 : parameterised transport-delay model (BASE + CODE*STEP),
//                 used for the loop / conformance verification.  BASE/LSB
//                 are the SPICE-measured values.
//   DLL8_IMPL=1 : the structural element (DLL8_ELEM_PHYS).  It is a PnR/SPICE
//                 netlist; the digital gate uses the model.  Binding notes
//                 are in the wrapper cells below.
`default_nettype none

module DLL8_ELEM #(
    parameter real    BASE_PS   = 110.0,
    parameter real    STEP_PS   = 3.0,
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
            DLL8_ELEM_PHYS #(.CODE_BITS(CODE_BITS)) u_phys (
                .IN(IN), .CODE(CODE), .OUT(OUT), .LOAD(LOAD)
            );
        end
    endgenerate
endmodule

// ---------------------------------------------------------------- decoder
// Binary code -> 127-bit thermometer (code c enables fingers 0..c-1).
module DLL8_THERM_DEC (
    input  wire [6:0]   CODE,
    output wire [126:0] THERM
);
    genvar j;
    generate
        for (j = 0; j < 127; j = j + 1) begin : bitg
            assign THERM[j] = (CODE > j);
        end
    endgenerate
endmodule

// ---------------------------------------------------------- measured element
// Structure matches flow/characterization/dll8_pex2.py (npstrong, 0.9x1.1).
// NOTE: the physical cells are PnR/SPICE bindings (see wrappers).  This
// module is not simulated by the digital gate (DLL8_IMPL=0); it defines the
// circuit that the SPICE deck and the layout must describe.
module DLL8_ELEM_PHYS #(
    parameter integer CODE_BITS = 7
) (
    input  wire                  IN,
    input  wire [CODE_BITS-1:0]  CODE,
    output wire                  OUT,
    output wire                  LOAD
);
    wire [126:0] th;
    DLL8_THERM_DEC u_dec (.CODE(CODE), .THERM(th));

    wire mid;
    (* keep *) (* dont_touch = "true" *)
    DLL8_INV4B u_in (.A(IN), .Y(mid));          // balanced custom driver
    (* keep *) (* dont_touch = "true" *)
    PLL_CELL_INVX4 u_out (.I(mid), .ZN(OUT));   // sg13g2_inv_4
    assign LOAD = mid;

    genvar j;
    generate
        for (j = 0; j < 127; j = j + 1) begin : finger
            DLL8_FINGER #(.IS_P(j % 2)) u_f (
                .EN(th[j]), .MID(mid)
            );
        end
    endgenerate
endmodule

// One thermometer finger: even -> NMOS switch + moscap_n to VSS,
// odd -> PMOS switch + moscap_p to VDD.  A submodule (not a nested generate
// inside the element) because iverilog forbids nested generate regions.
module DLL8_FINGER #(
    parameter integer IS_P = 0
) (
    input  wire EN,
    input  wire MID
);
    generate
        if (IS_P == 0) begin : nside
            wire g, cn;
            DLL8_BUF8 gbuf (.I(EN), .Z(g));
            DLL8_NSW sw (.D(cn), .G(g), .S(MID));
            DLL8_MOSCAP_N cap (.G(cn), .B(1'b0));
        end else begin : pside
            wire gb, cn;
            DLL8_INV8 ginv (.I(EN), .ZN(gb));
            DLL8_PSW sw (.D(cn), .G(gb), .S(MID));
            DLL8_MOSCAP_P cap (.G(cn), .B(1'b1));
        end
    endgenerate
endmodule

// ------------------------------------------------------------- cell wrappers
// PnR binding: a custom stdcell "sg13g2_inv_4b" with Wp=5.30um/Wn=2.96um
// (the SPICE-balanced driver).  Do NOT map this to sg13g2_inv_4.
// Behavioural stand-in for elaboration only.
module DLL8_INV4B (A, Y);
    input  wire A;
    output wire Y;
    assign Y = ~A;
endmodule

// buf_8 / inv_8 control buffers (thermometer bit fanout).  PnR: sg13g2_buf_8
// / sg13g2_inv_8.
module DLL8_BUF8 (I, Z);
    input  wire I;
    output wire Z;
    assign Z = I;
endmodule

module DLL8_INV8 (I, ZN);
    input  wire I;
    output wire ZN;
    assign ZN = ~I;
endmodule

// Switch + moscap primitives.  PnR/SPICE: sg13_lv_nmos (w=0.5u l=0.45u,
// drain=D, gate=G, source=S), sg13_lv_pmos (w=1.0u l=0.13u), sg13_moscap_n /
// sg13_moscap_p (w=0.9u l=1.1u, gate=G, plate=B).  These are PDK primitive
// devices, NOT digital stdcells -- PnR must treat them as a custom/analog
// block; the digital gate uses the model.
module DLL8_NSW (D, G, S);
    input  wire D, G;
    output wire S;
endmodule

module DLL8_PSW (D, G, S);
    input  wire D, G;
    output wire S;
endmodule

module DLL8_MOSCAP_N (G, B);
    input wire G, B;
endmodule

module DLL8_MOSCAP_P (G, B);
    input wire G, B;
endmodule

// Eight-element line: tap k = (k+1) element delays from IN.
module DLL8_LINE #(
    parameter real    BASE_PS   = 110.0,
    parameter real    STEP_PS   = 3.0,
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
