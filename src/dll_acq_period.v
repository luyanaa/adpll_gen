// Self-contained highest-tap priority encoder (same structure as the TDC's
// DLL_PRIO320_HI, but local so this module needs no other RTL source file).
module DLL_ACQ_PRIO (
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
    always @* begin hi0 = 0; for (i = 0; i < 32; i = i + 1) if (T[i]) hi0 = i + 1; end
    always @* begin hi1 = 0; for (i = 0; i < 32; i = i + 1) if (T[32+i]) hi1 = i + 1; end
    always @* begin hi2 = 0; for (i = 0; i < 32; i = i + 1) if (T[64+i]) hi2 = i + 1; end
    always @* begin hi3 = 0; for (i = 0; i < 32; i = i + 1) if (T[96+i]) hi3 = i + 1; end
    always @* begin hi4 = 0; for (i = 0; i < 32; i = i + 1) if (T[128+i]) hi4 = i + 1; end
    always @* begin hi5 = 0; for (i = 0; i < 32; i = i + 1) if (T[160+i]) hi5 = i + 1; end
    always @* begin hi6 = 0; for (i = 0; i < 32; i = i + 1) if (T[192+i]) hi6 = i + 1; end
    always @* begin hi7 = 0; for (i = 0; i < 32; i = i + 1) if (T[224+i]) hi7 = i + 1; end
    always @* begin hi8 = 0; for (i = 0; i < 32; i = i + 1) if (T[256+i]) hi8 = i + 1; end
    always @* begin hi9 = 0; for (i = 0; i < 32; i = i + 1) if (T[288+i]) hi9 = i + 1; end
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

// ACQ period capture with real gates.  Uses the TDC's fast thermometer
// priority encoder instead of a 320-input adder; the ACQ line is high from
// the launch edge to the wavefront, so the highest asserted tap is the
// period code.  The pipeline and acq_dly[3] tap match the verified TDC-only
// ACQ flow.
module DLL_ACQ_PERIOD (
    input  wire         REF,
    input  wire         RST_N,
    input  wire         ACQ_CLK,
    input  wire [319:0] ACQ_THERM,
    input  wire [4:0]   ACQ_DLY,
    output wire [15:0]  PERIOD,
    output wire [4:0]   DBG_DLY,
    output wire [8:0]   DBG_FIRST,
    output wire [15:0]  DBG_PERIOD
);
    reg [319:0] th0, th1, first;
    reg [15:0]  period_r;

    wire [8:0] first_enc;
    DLL_ACQ_PRIO u_first_enc (.T(first), .C(first_enc));

    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            th0      <= {320{1'b0}};
            th1      <= {320{1'b0}};
            first    <= {320{1'b0}};
            period_r <= 16'd0;
        end else begin
            th0   <= ACQ_THERM;
            th1   <= th0;
            first <= th1;
            if (ACQ_DLY[3])
                period_r <= {7'b0, first_enc};
        end
    end

    assign PERIOD     = period_r;
    assign DBG_DLY    = ACQ_DLY;
    assign DBG_FIRST  = first_enc;
    assign DBG_PERIOD = period_r;
endmodule
