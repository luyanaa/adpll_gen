// Real-cell physical TDC measurement/synthesis top.
module DLL_TDC_PHYS_MEAS (
    input  wire        REF,
    input  wire        ACQ_CLK,
    input  wire        PHASE_IN,
    input  wire        OUT,
    input  wire        MON_OUT,
    input  wire        RST_N,
    input  wire        ACQ_LATCH,
    output wire [15:0] ref_stamp,
    output wire [15:0] period_ticks,
    output wire [15:0] main_stamp,
    output wire        main_tog,
    output wire [15:0] mon_stamp,
    output wire        mon_tog,
    output wire [15:0] acq_stamp,
    output wire [319:0] acq_therm_ref_out,
    output wire [4:0]   acq_dly_out,
    output wire         REF_CLK
);
    DLL_TDC_PHYS #(.NTAP(320), .IMPL(1)) u_tdc (
        .REF(REF), .ACQ_CLK(ACQ_CLK), .PHASE_IN(PHASE_IN),
        .OUT(OUT), .MON_OUT(MON_OUT), .RST_N(RST_N),
        .ACQ_LATCH(ACQ_LATCH),
        .ref_stamp(ref_stamp), .period_ticks(period_ticks),
        .main_stamp(main_stamp), .main_tog(main_tog),
        .mon_stamp(mon_stamp), .mon_tog(mon_tog),
        .acq_stamp(acq_stamp),
        .acq_therm_ref_out(acq_therm_ref_out),
        .acq_dly_out(acq_dly_out),
        .REF_CLK(REF_CLK)
    );
endmodule
