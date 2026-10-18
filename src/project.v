`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // ui_in[7:0] = Dividend (Số bị chia 8-bit)
    output wire [7:0] uo_out,   // uo_out[7:0] = Quotient (Thương số 8-bit)
    input  wire [7:0] uio_in,   // uio_in[3:0] = Divisor (4-bit), uio_in[7] = start
    output wire [7:0] uio_out,  // uio_out[3:0] = Remainder (4-bit), uio_out[6] = done, uio_out[7] = div_by_zero
    output wire [7:0] uio_oe,   // IO direction control
    input  wire       ena,      // always 1
    input  wire       clk,      // clock
    input  wire       rst_n     // active low reset
);

    assign uio_oe = 8'b1111_1111;

    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [3:0] count;
    reg [4:0] acc;        // Accumulator 5-bit
    reg [7:0] quot;       // Quotient 8-bit
    reg [3:0] div_reg;    // Divisor 4-bit
    reg       zero_err;   // Cờ báo chia cho 0

    wire start = uio_in[7];
    wire [3:0] divisor_in = uio_in[3:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            count    <= 4'd0;
            acc      <= 5'd0;
            quot     <= 8'd0;
            div_reg  <= 4'd0;
            zero_err <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        if (divisor_in == 4'd0) begin
                            zero_err <= 1'b1;
                            quot     <= 8'd0;
                            acc      <= 5'd0;
                            state    <= DONE;
                        end else begin
                            zero_err <= 1'b0;
                            div_reg  <= divisor_in;
                            acc      <= 5'd0;
                            quot     <= ui_in;
                            count    <= 4'd0;
                            state    <= CALC;
                        end
                    end
                end

                CALC: begin
                    // Dịch trái {acc, quot} 1 bit & thử trừ divisor
                    if ({acc[3:0], quot[7]} < {1'b0, div_reg}) begin
                        // Dư âm -> Khôi phục, bit thương = 0
                        acc  <= {acc[3:0], quot[7]};
                        quot <= {quot[6:0], 1'b0};
                    end else begin
                        // Dư không âm -> Giữ kết quả trừ, bit thương = 1
                        acc  <= {acc[3:0], quot[7]} - {1'b0, div_reg};
                        quot <= {quot[6:0], 1'b1};
                    end

                    if (count == 4'd7) begin
                        state <= DONE;
                    end else begin
                        count <= count + 1'b1;
                    end
                end

                DONE: begin
                    if (!start) begin
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Gán đầu ra
    assign uo_out  = quot;
    assign uio_out = {zero_err, (state == DONE), 2'b00, acc[3:0]};

endmodule
