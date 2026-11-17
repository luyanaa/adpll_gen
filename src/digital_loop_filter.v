// The digital loop filter
`timescale 1fs/1fs

module pll_digital_loop_filter #(
    parameter integer BITS = 16,
    // Integrator preload.  The phase loop in pll_logic starts at mid-scale so
    // both P and N corrections have range; the ADCC/ADDLL up/down loops keep
    // the default zero.
    parameter integer INT_INIT = 0,
    // Swap the P/N correction direction.  The DCO delay increases with the
    // fine code, so the phase loop needs the opposite sign from the default
    // filter decode; the ADCC/ADDLL keep the default.
    parameter integer INVERT_PN = 0,
    // Register the DLF output only where the extra latency is acceptable
    // (the PLL phase loop).  The ADCC/ADDLL duty loops keep the combinational
    // output so their pulse-combiner timing is unchanged.
    parameter integer REG_OUT = 0
) (
    input CLK, RST_N, ENABLE,
    input [1:0] SS_BBPD,
    input [BITS-1:0] KP, KI,
    output reg [BITS-1:0] OUT,
    output reg ILL_P, ILL_N // Illegal positive/negative, meaning the filter cannot go upper/lower
);
    // Lets name all accordingly.
    wire SS_BBPD_REF;
    wire SS_BBPD_OUT;
    assign SS_BBPD_REF = SS_BBPD[0];
    assign SS_BBPD_OUT = SS_BBPD[1];
    
    /*
    CASE SLOW
    REF __________|^^^^^^^^^^^^^^^|_________
    OUT |___|^^^|___|^^^|___|^^^|___|^^^|___
    PD    1   1  1|0  0   0   0  0|1  1 (REF)
          1   0  1|1  1   1   1  1|1  0 (OUT)
    PDR 1   |   1   |   0   |   0   |   1   |
        1   |   1   |   1   |   1   |   1   |
    PDF |   1   |   1   |   0*  |   0   |   1
        |   0   |   0   |   1*  |   1   |   0
    WIN ________________^^^^^^^^^_________________ (injecting rising)
    WIN _________________________________^^^^^^^^^ (injecting falling)

    CASE FAST
    REF ______________|^^^^^^^^^^^^^^^|_________
    OUT ____|^^^|___|^^^|___|^^^|___|^^^|___|^^^
    PD    1   1   1  1|1  0   0   0  0|1  1 (REF)
          1   0   1  0|0  1   1   1  1|0  1 (OUT)
    PDR 1   |   1   |   1   |   0   |   0   |   1
        1   |   1   |   1   |   1   |   1   |   1
    PDF     1   |   1   |   1*  |   0   |   0   |
            0   |   0   |   0*  |   1   |   1   |
    WIN ________________^^^^^^^^^________________ (injecting rising)
    WIN ________________________________^^^^^^^^^ (injecting falling)
    */
    wire SYMBOL_P_RAW;
    wire SYMBOL_N_RAW;
`ifdef WITH_REF_TRIG_OUT
    // SS_BBPD symbols:
    // REF,OUT = 1,0: -1
    // REF,OUT = 0,1: +1
    // Otherwise    :  0 (Possibly an error)
    assign SYMBOL_P_RAW = !SS_BBPD_REF && SS_BBPD_OUT;
    assign SYMBOL_N_RAW = SS_BBPD_REF && !SS_BBPD_OUT;
`else
    // SS_BBPD symbols:
    // REF,OUT = 1,0: +1
    // REF,OUT = 1,1: -1
    // Otherwise    :  0 (Possibly an error)
    assign SYMBOL_P_RAW = SS_BBPD_REF && !SS_BBPD_OUT;
    assign SYMBOL_N_RAW = SS_BBPD_REF && SS_BBPD_OUT;
`endif
    wire SYMBOL_P = INVERT_PN ? SYMBOL_N_RAW : SYMBOL_P_RAW;
    wire SYMBOL_N = INVERT_PN ? SYMBOL_P_RAW : SYMBOL_N_RAW;

    // The filter is H_DLF = KP + KI/s

    // Integrate part
    reg [BITS-1:0] INT;
    wire [BITS:0] INT_P; // The 1 bit more is for getting the carry
    wire [BITS:0] INT_N;
    assign INT_P = {1'b0, INT} + {1'b0, KI};
    assign INT_N = {1'b0, INT} - {1'b0, KI};
    wire INT_EN_P, INT_EN_N;
    assign INT_EN_P = SYMBOL_P && ENABLE;
    assign INT_EN_N = SYMBOL_N && ENABLE;

    always @(posedge CLK or negedge RST_N) begin
        if(!RST_N) begin
            INT <= INT_INIT;
        end else begin
            if(INT_EN_P) begin
                if(INT_P[BITS]) INT <= {BITS{1'b1}}; // Illegal. Put to maxium
                else            INT <= INT_P[BITS-1:0];
            end
            if(INT_EN_N) begin
                if(INT_N[BITS]) INT <= {BITS{1'b0}}; // Illegal. Put to minimum
                else            INT <= INT_N[BITS-1:0];
            end
        end
    end
    
    // Output
    wire [BITS:0] OUT_P; // The 1 bit more is for getting the carry
    wire [BITS:0] OUT_N;
    assign OUT_P = {1'b0, INT} + {1'b0, KP};
    assign OUT_N = {1'b0, INT} - {1'b0, KP};

    // Combinational result, then a registered output.  Registering breaks
    // the DLF -> decoder -> DCO control path out of the critical timing path;
    // it adds one filter-clock latency to both the P and I contributions.
    reg [BITS-1:0] OUT_C;
    reg ILL_P_C, ILL_N_C;
    always @(*) begin
        if(SYMBOL_P) begin
            if(OUT_P[BITS]) begin  // Illegal. Put to maxium
                ILL_P_C = 1'b1; ILL_N_C = 1'b0;
                OUT_C = {BITS{1'b1}};
            end else begin
                ILL_P_C = 1'b0; ILL_N_C = 1'b0;
                OUT_C = OUT_P[BITS-1:0];
            end
        end else if(SYMBOL_N) begin
            if(OUT_N[BITS]) begin  // Illegal. Put to minimum
                ILL_P_C = 1'b0; ILL_N_C = 1'b1;
                OUT_C = {BITS{1'b0}};
            end else begin
                ILL_P_C = 1'b0; ILL_N_C = 1'b0;
                OUT_C = OUT_N[BITS-1:0];
            end
        end else begin
            // NOTE: This is not supposed to happen!
            ILL_P_C = 1'b0; ILL_N_C = 1'b0;
            OUT_C = INT;
        end
    end
    generate
        if (REG_OUT) begin : out_reg
            always @(posedge CLK or negedge RST_N) begin
                if(!RST_N) begin
                    OUT   <= INT_INIT[BITS-1:0];
                    ILL_P <= 1'b0;
                    ILL_N <= 1'b0;
                end else begin
                    OUT   <= OUT_C;
                    ILL_P <= ILL_P_C;
                    ILL_N <= ILL_N_C;
                end
            end
        end else begin : out_comb
            always @(*) begin
                OUT   = OUT_C;
                ILL_P = ILL_P_C;
                ILL_N = ILL_N_C;
            end
        end
    endgenerate

`ifdef SIMULATION
    // Just to debug the legality
    reg [1:0] SS_BBPD_Q; always @(posedge CLK) SS_BBPD_Q <= SS_BBPD;
    reg INT_EN_P_Q; always @(posedge CLK) INT_EN_P_Q <= INT_EN_P;
    reg INT_EN_N_Q; always @(posedge CLK) INT_EN_N_Q <= INT_EN_N;
`endif

endmodule