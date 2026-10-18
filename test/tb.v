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

    tt_um_example uut (
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

    task run_test(input [7:0] dividend, input [3:0] divisor);
        begin
            ui_in = dividend;
            uio_in = {1'b1, 3'b000, divisor}; // uio_in[7] = start
            #10;
            uio_in[7] = 1'b0;

            // Đờ cờ done ở bit 6 uio_out[6] lên 1
            wait(uio_out[6] == 1'b1);
            #10;
            $display("TEST: %d / %d => Quotient = %d (Expected: %d), Remainder = %d, DivZero = %b",
                     dividend, divisor, uo_out, dividend/divisor, uio_out[3:0], uio_out[7]);
            #20;
        end
    endtask

    initial begin
        $dumpfile("sim/i01.vcd");
        $dumpvars(0, tb);

        clk = 0;
        rst_n = 0;
        ena = 1;
        ui_in = 0;
        uio_in = 0;

        #20 rst_n = 1;
        #10;

        $display("=== START SIMULATION FOR I01 - RESTORING DIVIDER ===");

        // Ca 1: Chia het
        run_test(8'd200, 4'd10);

        // Ca 2: Chia co du
        run_test(8'd255, 4'd7);

        // Ca 3: Chia cho 1
        run_test(8'd168, 4'd1);

        // Ca 4: So bi chia < So chia
        run_test(8'd3, 4'd5);

        // Ca 5: Chia cho 0
        ui_in = 8'd200;
        uio_in = {1'b1, 3'b000, 4'd0};
        #10;
        uio_in[7] = 1'b0;
        wait(uio_out[6] == 1'b1);
        #10;
        $display("TEST DIV BY ZERO: 200 / 0 => DivZero Flag = %b (Expected: 1)", uio_out[7]);

        $display("=== SIMULATION COMPLETED SUCCESSFULY ===");
        $finish;
    end
endmodule
