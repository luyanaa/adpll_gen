// Ports-only blackbox stub for Yosys/ABC.  The simulatable RTL body lives in
// dll_acq_period.v and is compiled only by Icarus.
(* blackbox *)
module DLL_ACQ_PERIOD (
    input  wire         REF,
    input  wire         RST_N,
    input  wire [319:0] ACQ_THERM,
    input  wire [4:0]   ACQ_DLY,
    output wire [15:0]  PERIOD,
    output wire [4:0]   DBG_DLY,
    output wire [8:0]   DBG_FIRST,
    output wire [15:0]  DBG_PERIOD
);
endmodule
