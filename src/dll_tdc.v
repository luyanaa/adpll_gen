`timescale 1ps/1ps
// TDC front end for the full-period DLL.
//
// The fast counter lives only in the TICK domain.  REF, OUT and MON_OUT are
// synchronized into TICK (2FF + rising-edge detect) and timestamped there,
// so an event is never used to sample a faster counter.  Each timestamp is
// then handed to the REF controller with a toggle handshake; the multi-bit
// data is stable for several REF cycles before it is captured.
//
// The controller consumes timestamps in TICK units and the measured REF
// period, so it is independent of the physical TDC clock frequency.  A
// physical TDC can replace this module with the same interface.
module DLL_TDC #(
    parameter integer STAMP_BITS = 16
) (
    input  wire                  TICK,
    input  wire                  REF,
    input  wire                  OUT,
    input  wire                  MON_OUT,
    input  wire                  RST_N,
    input  wire                  ACQ_LATCH,
    output wire [STAMP_BITS-1:0] ref_stamp,
    output wire [STAMP_BITS-1:0] period_ticks,
    output wire [STAMP_BITS-1:0] main_stamp,
    output wire                  main_tog,
    output wire [STAMP_BITS-1:0] mon_stamp,
    output wire                  mon_tog,
    output wire [STAMP_BITS-1:0] acq_stamp
);
    // ------------------------------------------------------ TICK domain
    reg [STAMP_BITS-1:0] bin;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) bin <= {STAMP_BITS{1'b0}};
        else        bin <= bin + 1'b1;
    end

    // REF edge capture
    reg rs1, rs2, rs3;
    reg [STAMP_BITS-1:0] ref_ts_t;
    reg                  ref_tog_t;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            rs1 <= 1'b0; rs2 <= 1'b0; rs3 <= 1'b0;
            ref_ts_t <= {STAMP_BITS{1'b0}};
            ref_tog_t <= 1'b0;
        end else begin
            rs1 <= REF; rs2 <= rs1; rs3 <= rs2;
            if (rs2 && !rs3) begin
                ref_ts_t <= bin;
                ref_tog_t <= ~ref_tog_t;
            end
        end
    end

    // OUT edge capture
    reg os1, os2, os3;
    reg [STAMP_BITS-1:0] out_ts_t;
    reg                  out_tog_t;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            os1 <= 1'b0; os2 <= 1'b0; os3 <= 1'b0;
            out_ts_t <= {STAMP_BITS{1'b0}};
            out_tog_t <= 1'b0;
        end else begin
            os1 <= OUT; os2 <= os1; os3 <= os2;
            if (os2 && !os3) begin
                out_ts_t <= bin;
                out_tog_t <= ~out_tog_t;
            end
        end
    end

    // MON_OUT edge capture
    reg ms1, ms2, ms3;
    reg [STAMP_BITS-1:0] mon_ts_t;
    reg                  mon_tog_t;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            ms1 <= 1'b0; ms2 <= 1'b0; ms3 <= 1'b0;
            mon_ts_t <= {STAMP_BITS{1'b0}};
            mon_tog_t <= 1'b0;
        end else begin
            ms1 <= MON_OUT; ms2 <= ms1; ms3 <= ms2;
            if (ms2 && !ms3) begin
                mon_ts_t <= bin;
                mon_tog_t <= ~mon_tog_t;
            end
        end
    end

    // ------------------------------------------------------- REF domain
    reg  [1:0] rt_sync, ot_sync, mt_sync;
    reg        rt_prev, ot_prev, mt_prev;
    reg [STAMP_BITS-1:0] ref_stamp_r, ref_prev, period_r;
    reg [STAMP_BITS-1:0] main_stamp_r, mon_stamp_r;
    reg [STAMP_BITS-1:0] acq_stamp_r;
    reg                  acq_pending;
    wire                 ref_event = (rt_sync[1] != rt_prev);

    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            rt_sync <= 2'b0; ot_sync <= 2'b0; mt_sync <= 2'b0;
            rt_prev <= 1'b0; ot_prev <= 1'b0; mt_prev <= 1'b0;
            ref_stamp_r <= {STAMP_BITS{1'b0}};
            ref_prev    <= {STAMP_BITS{1'b0}};
            period_r    <= {STAMP_BITS{1'b0}};
            main_stamp_r <= {STAMP_BITS{1'b0}};
            mon_stamp_r  <= {STAMP_BITS{1'b0}};
            acq_stamp_r  <= {STAMP_BITS{1'b0}};
            acq_pending  <= 1'b0;
        end else begin
            rt_sync <= {rt_sync[0], ref_tog_t};
            ot_sync <= {ot_sync[0], out_tog_t};
            mt_sync <= {mt_sync[0], mon_tog_t};

            if (ref_event) begin
                ref_stamp_r <= ref_ts_t;
                ref_prev    <= ref_stamp_r;
                period_r    <= ref_ts_t - ref_stamp_r;
                rt_prev     <= rt_sync[1];
                if (acq_pending) begin
                    acq_stamp_r <= ref_ts_t;
                    acq_pending <= 1'b0;
                end
            end
            if (ot_sync[1] != ot_prev) begin
                main_stamp_r <= out_ts_t;
                ot_prev      <= ot_sync[1];
            end
            if (mt_sync[1] != mt_prev) begin
                mon_stamp_r <= mon_ts_t;
                mt_prev     <= mt_sync[1];
            end
            if (ACQ_LATCH) acq_pending <= 1'b1;
        end
    end
    assign ref_stamp    = ref_stamp_r;
    assign period_ticks = period_r;
    assign main_stamp   = main_stamp_r;
    assign main_tog     = ot_sync[1];
    assign mon_stamp    = mon_stamp_r;
    assign mon_tog      = mt_sync[1];
    assign acq_stamp    = acq_stamp_r;
endmodule
