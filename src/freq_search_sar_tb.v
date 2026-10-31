`timescale 1ns/1ps
module freq_search_sar_tb;
    reg REF = 0, RST_N = 0, START = 0, MAP_VALID = 1, OBS_VALID = 0;
    reg [15:0] FCW = 16'd30;
    wire [14:0] COARSE, MID;
    wire BUSY, DONE, FALLBACK, ERR;
    integer edges;
    integer i;
    reg obs_enable = 1'b1;

    function integer popcount15(input [14:0] v); integer k;
        begin popcount15 = 0; for (k=0;k<15;k=k+1) popcount15 = popcount15 + v[k]; end
    endfunction
    wire [15:0] OBS_COUNT = 16'd60 - popcount15(COARSE) - popcount15(MID);

    freq_search_sar #(.TIMEOUT(12)) dut(
        .REF(REF), .RST_N(RST_N), .START(START),
        .MONOTONIC_MAP_VALID(MAP_VALID), .OBS_VALID(OBS_VALID),
        .OBS_COUNT(OBS_COUNT), .FCW(FCW),
        .COARSE_MUX(COARSE), .MID_MUX(MID),
        .BUSY(BUSY), .DONE(DONE), .FALLBACK(FALLBACK), .ERR(ERR));

    always #5 REF = ~REF;

    always @(posedge REF) begin
        if (obs_enable && BUSY && !OBS_VALID) OBS_VALID <= #0.1 1'b1;
        else OBS_VALID <= #0.1 1'b0;
    end

    task start_search(input valid);
        begin
            MAP_VALID = valid;
            RST_N = 0; START = 0; OBS_VALID = 0;
            #12 RST_N = 1;
            #1 START = 1;
            #10 START = 0;
        end
    endtask

    initial begin
        start_search(1);
        repeat (30) @(posedge REF);
        if (!DONE || FALLBACK || ERR) $fatal(1, "monotonic search failed done=%b fb=%b err=%b", DONE, FALLBACK, ERR);
        if (popcount15(COARSE) == 0 && popcount15(MID) == 0) $fatal(1, "no code applied");
        $display("monotonic search: coarse=%0d mid=%0d done=%b", popcount15(COARSE), popcount15(MID), DONE);

        start_search(0);
        #15;
        if (!FALLBACK || BUSY) $fatal(1, "invalid map did not fallback");
        $display("invalid map: fallback=%b busy=%b", FALLBACK, BUSY);

        obs_enable = 0;
        MAP_VALID = 1; RST_N = 0; START = 0; #12 RST_N = 1; #1 START = 1; #10 START = 0;
        // No observation pulse: exercise timeout.
        #300;
        if (!ERR) $fatal(1, "timeout did not assert ERR");
        $display("timeout: err=%b busy=%b", ERR, BUSY);
        $finish;
    end

endmodule
