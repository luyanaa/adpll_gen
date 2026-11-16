`timescale 1ps/1ps
// Physical delay-line TDC for the Route B DLL.
//
// There is no GHz binary timestamp counter.  Three tapped delay lines produce
// thermometer codes; the timestamp unit is one tap (FINE_DELAY_CELL) delay:
//
//   LINE_PHASE : input PHASE_IN (REF in tracking, REF/16 in acquisition)
//                sampled by OUT          -> absolute/one-period phase code
//   LINE_ACQ   : input ACQ_CLK
//                sampled by REF at the first REF after the ACQ edge
//                                        -> REF period in tap units
//                sampled by MON_OUT      -> monitor-line delay in tap units
//
// The sampler banks are clocked by the measured edge, so no fast clock is
// needed.  The binary codes are Gray-synchronized to REF where required.  The
// DLL controller consumes phase/period/monitor codes in tap units and uses
// only relative tolerances (period>>5/4/3), so the tap delay may vary with
// PVT.
//
// IMPL=0 uses the behavioral DLL_DELAY_CELL; IMPL=1 uses the real
// FINE_DELAY_CELL chain for gate-level/SDF.  The sampler/encoder logic is
// synthesizable RTL.
module DLL_TDC_LINE #(
    parameter integer NTAP = 320,
    parameter integer CELL_PS = 35,
    parameter integer IMPL = 0
) (
    input  wire           IN,
    output wire [NTAP:0]  TAP
);
    assign TAP[0] = IN;
    genvar i;
    generate
        if (IMPL == 0) begin : sim
            for (i = 0; i < NTAP; i = i + 1) begin : stage
                DLL_DELAY_CELL #(.DLY_PS(CELL_PS)) u_cell (
                    .I(TAP[i]), .O(TAP[i+1])
                );
            end
        end else begin : phys
            for (i = 0; i < NTAP; i = i + 1) begin : stage
                FINE_DELAY_CELL u_cell (
                    .MUX(1'b1), .IN(TAP[i]), .OUT(TAP[i+1])
                );
            end
        end
    endgenerate
endmodule

// Short start pulse for the delay line.  The line must be driven by an edge,
// not a clock: a clock leaves several high regions in the line and makes the
// sampled thermometer ambiguous.  A 2-cell pulse keeps one wavefront per
// REF/ACQ edge.
module DLL_EDGE_PULSE #(
    parameter integer IMPL = 0,
    parameter integer CELL_PS = 35,
    parameter integer CELLS = 2
) (
    input  wire CLK,
    output wire PULSE
);
    wire delayed;
    genvar i;
    generate
        if (IMPL == 0) begin : sim
            DLL_DELAY_CELL #(.DLY_PS(CELLS * CELL_PS)) u_dly (
                .I(CLK), .O(delayed)
            );
        end else begin : phys
            wire [CELLS:0] chain;
            assign chain[0] = CLK;
            for (i = 0; i < CELLS; i = i + 1) begin : stage
                FINE_DELAY_CELL u_cell (
                    .MUX(1'b1), .IN(chain[i]), .OUT(chain[i+1])
                );
            end
            assign delayed = chain[CELLS];
        end
    endgenerate
    assign PULSE = CLK & ~delayed;
endmodule

// Hierarchical first-high priority encoder for the delay-line thermometer.  The line is
// a series chain, so the taps rise in order; the highest asserted tap is the
// wavefront.  A 32-deep group priority is shorter than a 320-input adder.
module DLL_PRIO320 (
    input  wire [319:0] T,
    output reg  [8:0]   C
);
    wire [9:0] any;
    reg  [5:0] hi0, hi1, hi2, hi3, hi4, hi5, hi6, hi7, hi8, hi9;
    reg        f0, f1, f2, f3, f4, f5, f6, f7, f8, f9;
    integer i;
    assign any[0] = |T[31:0];
    assign any[1] = |T[63:32];
    assign any[2] = |T[95:64];
    assign any[3] = |T[127:96];
    assign any[4] = |T[159:128];
    assign any[5] = |T[191:160];
    assign any[6] = |T[223:192];
    assign any[7] = |T[255:224];
    assign any[8] = |T[287:256];
    assign any[9] = |T[319:288];

    always @* begin
        hi0 = 0; f0 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f0 && T[i]) begin hi0 = i + 1; f0 = 1; end
    end
    always @* begin
        hi1 = 0; f1 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f1 && T[32+i]) begin hi1 = i + 1; f1 = 1; end
    end
    always @* begin
        hi2 = 0; f2 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f2 && T[64+i]) begin hi2 = i + 1; f2 = 1; end
    end
    always @* begin
        hi3 = 0; f3 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f3 && T[96+i]) begin hi3 = i + 1; f3 = 1; end
    end
    always @* begin
        hi4 = 0; f4 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f4 && T[128+i]) begin hi4 = i + 1; f4 = 1; end
    end
    always @* begin
        hi5 = 0; f5 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f5 && T[160+i]) begin hi5 = i + 1; f5 = 1; end
    end
    always @* begin
        hi6 = 0; f6 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f6 && T[192+i]) begin hi6 = i + 1; f6 = 1; end
    end
    always @* begin
        hi7 = 0; f7 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f7 && T[224+i]) begin hi7 = i + 1; f7 = 1; end
    end
    always @* begin
        hi8 = 0; f8 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f8 && T[256+i]) begin hi8 = i + 1; f8 = 1; end
    end
    always @* begin
        hi9 = 0; f9 = 0;
        for (i = 0; i < 32; i = i + 1)
            if (!f9 && T[288+i]) begin hi9 = i + 1; f9 = 1; end
    end

    always @* begin
        if (any[0])      C = hi0;
        else if (any[1]) C = 32 + hi1;
        else if (any[2]) C = 64 + hi2;
        else if (any[3]) C = 96 + hi3;
        else if (any[4]) C = 128 + hi4;
        else if (any[5]) C = 160 + hi5;
        else if (any[6]) C = 192 + hi6;
        else if (any[7]) C = 224 + hi7;
        else if (any[8]) C = 256 + hi8;
        else if (any[9]) C = 288 + hi9;
        else             C = 0;
    end
endmodule

module DLL_PRIO320_HI (
    input  wire [319:0] T,
    output reg  [8:0]   C
);
    wire [9:0] any;
    reg  [5:0] hi0, hi1, hi2, hi3, hi4, hi5, hi6, hi7, hi8, hi9;
    integer i;
    assign any[0] = |T[31:0];
    assign any[1] = |T[63:32];
    assign any[2] = |T[95:64];
    assign any[3] = |T[127:96];
    assign any[4] = |T[159:128];
    assign any[5] = |T[191:160];
    assign any[6] = |T[223:192];
    assign any[7] = |T[255:224];
    assign any[8] = |T[287:256];
    assign any[9] = |T[319:288];
    always @* begin
        hi0 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[i]) hi0 = i + 1;
    end
    always @* begin
        hi1 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[32+i]) hi1 = i + 1;
    end
    always @* begin
        hi2 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[64+i]) hi2 = i + 1;
    end
    always @* begin
        hi3 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[96+i]) hi3 = i + 1;
    end
    always @* begin
        hi4 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[128+i]) hi4 = i + 1;
    end
    always @* begin
        hi5 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[160+i]) hi5 = i + 1;
    end
    always @* begin
        hi6 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[192+i]) hi6 = i + 1;
    end
    always @* begin
        hi7 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[224+i]) hi7 = i + 1;
    end
    always @* begin
        hi8 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[256+i]) hi8 = i + 1;
    end
    always @* begin
        hi9 = 0;
        for (i = 0; i < 32; i = i + 1) if (T[288+i]) hi9 = i + 1;
    end
    always @* begin
        if (any[9])      C = 288 + hi9;
        else if (any[8]) C = 256 + hi8;
        else if (any[7]) C = 224 + hi7;
        else if (any[6]) C = 192 + hi6;
        else if (any[5]) C = 160 + hi5;
        else if (any[4]) C = 128 + hi4;
        else if (any[3]) C = 96 + hi3;
        else if (any[2]) C = 64 + hi2;
        else if (any[1]) C = 32 + hi1;
        else if (any[0]) C = hi0;
        else             C = 0;
    end
endmodule

module DLL_TDC_PHYS #(
    parameter integer NTAP = 320,
    parameter integer CELL_PS = 35,
    parameter integer IMPL = 0,
    parameter integer CODE_BITS = 9
) (
    input  wire                  REF,
    input  wire                  ACQ_CLK,
    input  wire                  PHASE_IN,
    input  wire                  OUT,
    input  wire                  MON_OUT,
    input  wire                  RST_N,
    input  wire                  ACQ_LATCH,
    output wire [15:0]           ref_stamp,
    output wire [15:0]           period_ticks,
    output wire [15:0]           main_stamp,
    output wire                  main_tog,
    output wire [15:0]           mon_stamp,
    output wire                  mon_tog,
    output wire [15:0]           acq_stamp,
    // Exposed ACQ sampler pipeline; the top/TB computes the period code
    // outside this module so Yosys/ABC cannot fold it away.
    output wire [319:0]          acq_therm_ref_out,
    output wire [4:0]            acq_dly_out
);
    // ------------------------------------------------------ delay lines
    wire [NTAP:0] phase_tap;
    wire [NTAP:0] acq_tap;
    wire phase_start, acq_start;
    DLL_EDGE_PULSE #(.IMPL(IMPL), .CELL_PS(CELL_PS), .CELLS(16)) u_phase_pulse (
        .CLK(PHASE_IN), .PULSE(phase_start)
    );
    DLL_EDGE_PULSE #(.IMPL(IMPL), .CELL_PS(CELL_PS), .CELLS(8)) u_acq_pulse (
        .CLK(ACQ_CLK), .PULSE(acq_start)
    );
    DLL_TDC_LINE #(.NTAP(NTAP), .CELL_PS(CELL_PS), .IMPL(IMPL)) u_phase (
        .IN(phase_start), .TAP(phase_tap)
    );
    DLL_TDC_LINE #(.NTAP(NTAP), .CELL_PS(CELL_PS), .IMPL(IMPL)) u_acq (
        .IN(ACQ_CLK), .TAP(acq_tap)
    );

    // ------------------------------------------------------ samplers
    reg [NTAP-1:0] phase_therm;
    reg [NTAP-1:0] acq_therm_ref;
    reg [NTAP-1:0] acq_therm_mon;
    always @(posedge OUT or negedge RST_N) begin
        if (!RST_N) phase_therm <= {NTAP{1'b0}};
        else        phase_therm <= phase_tap[NTAP-1:0];
    end
    (* keep *) reg [319:0] th0, th1;
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            acq_therm_ref <= {NTAP{1'b0}};
            th0           <= {320{1'b0}};
            th1           <= {320{1'b0}};
            first_therm   <= {320{1'b0}};
        end else begin
            acq_therm_ref <= acq_tap[NTAP-1:0];
            // Unconditional sampler pipeline.  The Yosys opt otherwise
            // dead-code-eliminates a conditional first_therm capture and
            // ties the whole REF sampler path to zero.
            th0 <= acq_therm_ref;
            th1 <= th0;
            first_therm <= th1;
        end
    end
    always @(posedge MON_OUT or negedge RST_N) begin
        if (!RST_N) acq_therm_mon <= {NTAP{1'b0}};
        else        acq_therm_mon <= acq_tap[NTAP-1:0];
    end

    wire [CODE_BITS-1:0] phase_code;
    wire [CODE_BITS-1:0] acq_code_ref;
    wire [CODE_BITS-1:0] acq_code_mon;
    DLL_PRIO320 u_phase_enc (.T(phase_therm), .C(phase_code));
    DLL_PRIO320_HI u_acq_ref_enc (.T(acq_therm_ref), .C(acq_code_ref));
    DLL_PRIO320_HI u_acq_mon_enc (.T(acq_therm_mon), .C(acq_code_mon));

    // ------------------------------------------------ event handshakes
    // The phase/monitor codes are captured in their sampler domains and
    // transferred with a toggle handshake.  This avoids a multi-bit Gray
    // jump being sampled incoherently during acquisition, when the code can
    // move by many taps in one step.
    reg out_tog_r, mon_tog_r;
    always @(posedge OUT or negedge RST_N) begin
        if (!RST_N) out_tog_r <= 1'b0;
        else        out_tog_r <= ~out_tog_r;
    end
    always @(posedge MON_OUT or negedge RST_N) begin
        if (!RST_N) mon_tog_r <= 1'b0;
        else        mon_tog_r <= ~mon_tog_r;
    end

    reg ot1, ot2, ot3, mt1, mt2, mt3;
    reg [15:0] phase_cap, mon_cap;
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            ot1 <= 1'b0; ot2 <= 1'b0; ot3 <= 1'b0;
            mt1 <= 1'b0; mt2 <= 1'b0; mt3 <= 1'b0;
            phase_cap <= 16'd0;
            mon_cap   <= 16'd0;
        end else begin
            ot1 <= out_tog_r; ot2 <= ot1; ot3 <= ot2;
            mt1 <= mon_tog_r; mt2 <= mt1; mt3 <= mt2;
            if (ot2 != ot3) phase_cap <= {7'b0, phase_code};
            if (mt2 != mt3) mon_cap   <= {7'b0, acq_code_mon};
        end
    end

    // ------------------------------------------------------ period code
    // LINE_ACQ starts at the ACQ_CLK edge.  The REF sampler at the next edge
    // sees one REF period; the encoder output is available one REF later.
    (* keep *) reg [4:0]  acq_dly;
    (* keep *) reg [15:0] period_r;
    (* keep *) reg [319:0] first_therm;
    wire [8:0] first_enc;
    DLL_PRIO320_HI u_first_enc (.T(first_therm), .C(first_enc));
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            acq_dly     <= 4'd0;
            period_r    <= 16'd0;
            first_therm <= {320{1'b0}};
        end else begin
            acq_dly <= {acq_dly[3:0], ACQ_LATCH};
            // ACQ_LATCH is one REF before the ACQ edge.  The first REF sample
            // after the edge is acq_dly[1]; capture that sampler Q (not the
            // encoder output, which can see the next 2T wavefront) at
            // acq_dly[2], and register its code at acq_dly[3].
            if (acq_dly[4])
                period_r <= {7'b0, first_enc};
        end
    end
    assign period_ticks = period_r;

    // ------------------------------------------------------ outputs
    assign main_stamp = phase_cap;
    assign mon_stamp  = mon_cap;
    assign ref_stamp  = 16'd0;
    assign acq_stamp  = 16'd0;
    assign main_tog   = ot2;
    assign mon_tog    = mt2;
    assign acq_therm_ref_out = acq_therm_ref;
    assign acq_dly_out       = acq_dly;
endmodule
