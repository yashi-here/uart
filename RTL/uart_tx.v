module uart_tx #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,

    output reg tx,
    output reg tx_busy,
    output reg tx_done
);

localparam integer BAUD_COUNT = CLK_FREQ / BAUD_RATE;

reg [15:0] baud_counter;
reg [2:0] bit_index;
reg [7:0] tx_shift;
reg [2:0] state;

localparam IDLE  = 3'd0;
localparam START = 3'd1;
localparam DATA  = 3'd2;
localparam STOP  = 3'd3;
localparam DONE  = 3'd4;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx <= 1'b1;
        tx_busy <= 1'b0;
        tx_done <= 1'b0;
        baud_counter <= 16'd0;
        bit_index <= 3'd0;
        tx_shift <= 8'd0;
        state <= IDLE;
    end
    else begin
        tx_done <= 1'b0;

        case (state)

            IDLE: begin
                tx <= 1'b1;
                tx_busy <= 1'b0;
                baud_counter <= 16'd0;
                bit_index <= 3'd0;

                if (tx_start) begin
                    tx_shift <= tx_data;
                    tx_busy <= 1'b1;
                    state <= START;
                end
            end

            START: begin
                tx <= 1'b0;
                tx_busy <= 1'b1;

                if (baud_counter == BAUD_COUNT - 1) begin
                    baud_counter <= 16'd0;
                    state <= DATA;
                end
                else begin
                    baud_counter <= baud_counter + 16'd1;
                end
            end

            DATA: begin
                tx <= tx_shift[bit_index];
                tx_busy <= 1'b1;

                if (baud_counter == BAUD_COUNT - 1) begin
                    baud_counter <= 16'd0;

                    if (bit_index == 3'd7) begin
                        bit_index <= 3'd0;
                        state <= STOP;
                    end
                    else begin
                        bit_index <= bit_index + 3'd1;
                    end
                end
                else begin
                    baud_counter <= baud_counter + 16'd1;
                end
            end

            STOP: begin
                tx <= 1'b1;
                tx_busy <= 1'b1;

                if (baud_counter == BAUD_COUNT - 1) begin
                    baud_counter <= 16'd0;
                    state <= DONE;
                end
                else begin
                    baud_counter <= baud_counter + 16'd1;
                end
            end

            DONE: begin
                tx <= 1'b1;
                tx_busy <= 1'b0;
                tx_done <= 1'b1;
                state <= IDLE;
            end

            default: begin
                state <= IDLE;
                tx <= 1'b1;
                tx_busy <= 1'b0;
                tx_done <= 1'b0;
            end

        endcase
    end
end

endmodule
