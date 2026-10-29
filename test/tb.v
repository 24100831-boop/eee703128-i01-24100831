
`timescale 1ns/1ps

// IMPORTANT:
// Set DUT_MODULE to the exact module name in src/project.v.
// Example:
// `define DUT_MODULE tt_um_eee703128_i01_24100831

`ifndef DUT_MODULE
`define DUT_MODULE tt_um_eee703128_I01
`endif

module tb;

    reg        clk;
    reg        rst_n;
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;

    wire [7:0] uo_out;
    wire [7:0] uio_out;

    // Device under test
    `DUT_MODULE dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .ui_in   (ui_in),
        .uo_out  (uo_out),
        .uio_in  (uio_in),
        .uio_out (uio_out),
        .ena     (1'b1)
    );

    // 10 ns clock period
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Wait for done with timeout.
    // Assumes uio_out[6] is the done signal.
    task wait_done;
        integer count;
        begin
            count = 0;

            while ((uio_out[6] !== 1'b1) &&
                   (count < 1000)) begin
                @(posedge clk);
                #1;
                count = count + 1;
            end

            if (uio_out[6] !== 1'b1)
                $fatal(1, "Timeout waiting for divider done");
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

            // Wait until the previous operation is finished.
            @(negedge clk);

            ui_in  = dividend;
            uio_in = {1'b1, 3'b000, divisor};

            // Deassert start after one clock cycle.
            @(negedge clk);
            uio_in[7] = 1'b0;

            wait_done;
            #1;

            if (divisor != 0) begin
                $display(
                    "%0d / %0d: quotient=%0d expected=%0d, remainder=%0d expected=%0d",
                    dividend, divisor, uo_out, expected_q,
                    uio_out[3:0], expected_r
                );

                if (uo_out !== expected_q)
                    $fatal(1, "Quotient mismatch");

                if (uio_out[3:0] !== expected_r)
                    $fatal(1, "Remainder mismatch");

                $display("PASS");
            end else begin
                $display(
                    "%0d / 0: divide_by_zero=%b expected=1",
                    dividend, uio_out[7]
                );

                if (uio_out[7] !== 1'b1)
                    $fatal(1, "Divide-by-zero flag mismatch");

                $display("PASS");
            end

            repeat (2) @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("i01.vcd");
        $dumpvars(0, tb);

        rst_n  = 1'b0;
        ui_in  = 8'd0;
        uio_in = 8'd0;

        $display("=== START RESTORING DIVIDER TEST ===");

        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        repeat (2) @(negedge clk);

        run_test(8'd200, 4'd10);
        run_test(8'd255, 4'd7);
        run_test(8'd168, 4'd1);
        run_test(8'd3,   4'd5);
        run_test(8'd0,   4'd5);
        run_test(8'd200, 4'd0);

        $display("=== ALL TESTS PASSED ===");
        $finish;
    end

endmodule
