
`timescale 1ns/1ps

module tb;

    reg         clk;
    reg         rst_n;
    reg  [7:0]  ui_in;
    reg  [7:0]  uio_in;

    wire [7:0]  uo_out;
    wire [7:0]  uio_out;
    wire [7:0]  unused_ua;

    // --------------------------------------------------
    // DUT: Tiny Tapeout project
    // --------------------------------------------------
    tt_um_i01_restoring_divider dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .ui_in  (ui_in),
        .uo_out (uo_out),
        .uio_in (uio_in),
        .uio_out(uio_out),
        .ena    (1'b1)
    );

    // --------------------------------------------------
    // Clock: period = 10 ns
    // --------------------------------------------------
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // --------------------------------------------------
    // Wait for done, with timeout
    // Assumption: uio_out[6] = done
    // --------------------------------------------------
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

            if (uio_out[6] !== 1'b1) begin
                $display("ERROR: Timeout waiting for done");
                $fatal(1, "Divider timeout");
            end
        end
    endtask

    // --------------------------------------------------
    // Run one division test
    //
    // ui_in[7:0]  = dividend
    // uio_in[3:0] = divisor
    // uio_in[7]   = start
    //
    // uo_out[7:0] = quotient
    // uio_out[3:0]= remainder
    // uio_out[6]  = done
    // uio_out[7]  = divide-by-zero flag
    // --------------------------------------------------
    task run_test;
        input [7:0] dividend;
        input [3:0] divisor;

        reg [7:0] expected_q;
        reg [3:0] expected_r;

        begin
            if (divisor != 0) begin
                expected_q = dividend / divisor;
                expected_r = dividend % divisor;
            end else begin
                expected_q = 8'd0;
                expected_r = 4'd0;
            end

            // Set inputs and assert start
            @(negedge clk);
            ui_in = dividend;
            uio_in = {1'b1, 3'b000, divisor};

            // Keep start asserted for one full clock cycle
            @(negedge clk);
            uio_in[7] = 1'b0;

            // Wait for operation to complete
            wait_done;

            // Allow outputs to settle
            #1;

            if (divisor != 0) begin
                $display(
                    "TEST: %0d / %0d => Q=%0d expected=%0d R=%0d expected_R=%0d",
                    dividend,
                    divisor,
                    uo_out,
                    expected_q,
                    uio_out[3:0],
                    expected_r
                );

                if (uo_out !== expected_q) begin
                    $error(
                        "Quotient mismatch: got %0d, expected %0d",
                        uo_out,
                        expected_q
                    );
                end

                if (uio_out[3:0] !== expected_r) begin
                    $error(
                        "Remainder mismatch: got %0d, expected %0d",
                        uio_out[3:0],
                        expected_r
                    );
                end

                if ((uo_out === expected_q) &&
                    (uio_out[3:0] === expected_r)) begin
                    $display("PASS");
                end
            end else begin
                $display(
                    "TEST: %0d / 0 => DivZero=%b (expected 1)",
                    dividend,
                    uio_out[7]
                );

                if (uio_out[7] !== 1'b1) begin
                    $error("Divide-by-zero flag mismatch");
                end else begin
                    $display("PASS");
                end
            end

            // Allow the DUT to return to its idle state
            repeat (2) @(negedge clk);
        end
    endtask

    // --------------------------------------------------
    // Main test sequence
    // --------------------------------------------------
    initial begin
        $dumpfile("i01.vcd");
        $dumpvars(0, tb);

        // Initialize signals
        clk   = 1'b0;
        rst_n = 1'b0;
        ui_in = 8'd0;
        uio_in = 8'd0;

        $display("========================================");
        $display("START I01 RESTORING DIVIDER TEST");
        $display("========================================");

        // Apply reset
        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        repeat (2) @(negedge clk);

        // Test 1: Exact division
        run_test(8'd200, 4'd10);

        // Test 2: Division with remainder
        run_test(8'd255, 4'd7);

        // Test 3: Divide by one
        run_test(8'd168, 4'd1);

        // Test 4: Dividend smaller than divisor
        run_test(8'd3, 4'd5);

        // Test 5: Zero dividend
        run_test(8'd0, 4'd5);

        // Test 6: Divide by zero
        run_test(8'd200, 4'd0);

        $display("========================================");
        $display("ALL TEST VECTORS COMPLETED");
        $display("========================================");

        $finish;
    end

endmodule

