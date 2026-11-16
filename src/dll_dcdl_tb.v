// DLL_DCDL segmented-line continuity test.
//
// The 4-segment structure is only useful if the code->delay map is monotonic
// across each coarse x 56 boundary.  This test measures every code of the
// behavioral segmented backend and checks:
//   - d(0)   = T0
//   - d(279) = T0 + 279*CELL + 4*EXTRA
//   - non-boundary step = CELL
//   - boundary step at 56/112/168/224 = CELL + EXTRA
//   - monotonic over all 280 codes
// The physical-cell boundary steps are measured separately by
// flow/sta/segmented_boundary.sta.tcl.
`timescale 1ns/1ps

module dll_dcdl_tb;
    reg clk_tt = 0, clk_ss = 0, clk_ff = 0;
    reg [8:0] code_tt = 0, code_ss = 0, code_ff = 0;
    wire out_tt, out_ss, out_ff;

    DLL_DCDL #(
        .IMPL(0), .T0_PS(2930), .CELL_PS(30), .EXTRA_PS(62)
    ) u_tt (.CLK_IN(clk_tt), .CODE(code_tt), .CLK_OUT(out_tt));
    DLL_DCDL #(
        .IMPL(0), .T0_PS(3320), .CELL_PS(52), .EXTRA_PS(75)
    ) u_ss (.CLK_IN(clk_ss), .CODE(code_ss), .CLK_OUT(out_ss));
    DLL_DCDL #(
        .IMPL(0), .T0_PS(2780), .CELL_PS(20), .EXTRA_PS(70)
    ) u_ff (.CLK_IN(clk_ff), .CODE(code_ff), .CLK_OUT(out_ff));

    integer errors = 0;
    integer c;
    real t0, d_ps, prev_ps;
    integer exp_ps;

    function integer expect_ps;
        input integer code;
        input integer t0ps;
        input integer cellps;
        input integer extra;
        begin
            expect_ps = t0ps + code * cellps + (code / 56) * extra;
        end
    endfunction

    task pulse_tt;
        input [8:0] code;
        begin
            clk_tt = 1'b0; #20;
            code_tt = code; #5;
            clk_tt = 1'b1; t0 = $realtime;
            @(posedge out_tt);
            d_ps = ($realtime - t0) * 1000.0;
            #2;
        end
    endtask

    task pulse_ss;
        input [8:0] code;
        begin
            clk_ss = 1'b0; #20;
            code_ss = code; #5;
            clk_ss = 1'b1; t0 = $realtime;
            @(posedge out_ss);
            d_ps = ($realtime - t0) * 1000.0;
            #2;
        end
    endtask

    task pulse_ff;
        input [8:0] code;
        begin
            clk_ff = 1'b0; #20;
            code_ff = code; #5;
            clk_ff = 1'b1; t0 = $realtime;
            @(posedge out_ff);
            d_ps = ($realtime - t0) * 1000.0;
            #2;
        end
    endtask

    task check_corner;
        input integer which;
        input [8*2-1:0] name;
        input integer t0ps;
        input integer cellps;
        input integer extra;
        begin
            prev_ps = -1.0;
            for (c = 0; c < 280; c = c + 1) begin
                case (which)
                    0: pulse_tt(c[8:0]);
                    1: pulse_ss(c[8:0]);
                    default: pulse_ff(c[8:0]);
                endcase
                exp_ps = expect_ps(c, t0ps, cellps, extra);
                if (d_ps < exp_ps - 2.0 || d_ps > exp_ps + 2.0) begin
                    $display("FAIL: %0s code %0d delay %0.1f ps expected %0d",
                             name, c, d_ps, exp_ps);
                    errors = errors + 1;
                end
                if (prev_ps >= 0.0 && d_ps <= prev_ps) begin
                    $display("FAIL: %0s non-monotonic at code %0d: %0.1f <= %0.1f",
                             name, c, d_ps, prev_ps);
                    errors = errors + 1;
                end
                if ((c == 56) || (c == 112) || (c == 168) || (c == 224)) begin
                    if (d_ps - prev_ps < cellps + extra - 2.0 ||
                        d_ps - prev_ps > cellps + extra + 2.0) begin
                        $display("FAIL: %0s boundary %0d step %0.1f ps expected %0d",
                                 name, c, d_ps - prev_ps, cellps + extra);
                        errors = errors + 1;
                    end
                end else if (prev_ps >= 0.0) begin
                    if (d_ps - prev_ps < cellps - 2.0 ||
                        d_ps - prev_ps > cellps + 2.0) begin
                        $display("FAIL: %0s step at %0d is %0.1f ps expected %0d",
                                 name, c, d_ps - prev_ps, cellps);
                        errors = errors + 1;
                    end
                end
                prev_ps = d_ps;
            end
            $display("PASS: %0s min=%0d max=%0d boundary_step=%0d ps",
                     name, t0ps, t0ps + 279*cellps + 4*extra, cellps + extra);
        end
    endtask

    initial begin
        #10;
        check_corner(0, "TT", 2930, 30, 62);
        check_corner(1, "SS", 3320, 52, 75);
        check_corner(2, "FF", 2780, 20, 70);
        if (errors != 0) $fatal(1, "dll_dcdl_tb failed");
        $display("dll_dcdl_tb: PASS");
        $finish;
    end
endmodule
