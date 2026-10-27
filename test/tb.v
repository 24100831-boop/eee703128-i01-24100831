
`timescale 1ns/1ps

module tb;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg ena;
    reg clk;
    reg rst_n;

    tt_um_eee703128_I01 uut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;


task wait_done;
    integer count;
    begin
        count = 0;
        while ((uio_out[6] !== 1'b1) && (count < 1000)) begin
            @(posedge clk);
            count = count + 1;
        end

        if (uio_out[6] !== 1'b1) begin
            $fatal(1, "Divider timeout");
        end
    end
endtask

task run_test;
    input [7:0] dividend;
    input [3:0] divisor;
    reg [7:0] expected_q;
    reg [3:0] expected_r;
    begin
        expected_q = 0;
        expected_r = 0;

        if (divisor != 0) begin
            expected_q = dividend / divisor;
            expected_r = dividend % divisor;
        end

        @(negedge clk);
        ui_in = dividend;
        uio_in = {1'b1, 3'b000, divisor};

        @(negedge clk);
        uio_in[7] = 1'b0;

        wait_done;
        #1;

        if (divisor != 0) begin
            $display(
                "TEST: %0d / %0d => Q=%0d expected=%0d R=%0d expected_R=%0d",
                dividend, divisor, uo_out, expected_q,
                uio_out[3:0], expected_r
            );

            if (uo_out !== expected_q)
                $error("Quotient mismatch");

            if (uio_out[3:0] !== expected_r)
                $error("Remainder mismatch");
        end else begin
            $display("TEST: %0d / 0 => DivZero=%b", dividend, uio_out[7]);
            if (uio_out[7] !== 1'b1)
                $error("Divide-by-zero flag mismatch");
        end

        repeat (2) @(negedge clk);
    end
endtask

    initial begin
        // Save waveform in current test directory
        $dumpfile("i01.vcd");
        $dumpvars(0, tb);

        clk = 0;
        rst_n = 0;
        ena = 1;
        ui_in = 0;
        uio_in = 0;

        repeat (2) @(negedge clk);
        rst_n = 1;
        repeat (2) @(negedge clk);

        $display("=== START I01 RESTORING DIVIDER TEST ===");

        run_test(8'd200, 4'd10);
        run_test(8'd255, 4'd7);
        run_test(8'd168, 4'd1);
        run_test(8'd3,   4'd5);
        run_test(8'd200, 4'd0);

        $display("=== ALL TEST VECTORS COMPLETED ===");

        // Do not call $finish here; Cocotb controls simulation shutdown.
    end
endmodule

