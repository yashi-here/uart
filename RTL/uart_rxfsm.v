module uart_rxfsm(
    input clk,
    input rst,
    input rx,
    input baud_valid,
    input [15:0] baud_count,

    output reg [7:0] data_out,
    output reg data_valid
);

reg [2:0] bit_index;
reg [7:0] shift_reg;
reg [3:0] state;
reg [15:0] rx_counter;

localparam WAIT_BAUD = 4'd0;
localparam WAIT_IDLE = 4'd1;
localparam IDLE      = 4'd2;
localparam START     = 4'd3;
localparam DATA      = 4'd4;
localparam STOP      = 4'd5;
localparam DONE      = 4'd6;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= WAIT_BAUD;
        bit_index <= 3'd0;
        shift_reg <= 8'd0;
        data_valid <= 1'b0;
        data_out <= 8'd0;
        rx_counter <= 16'd0;
    end
    else begin
        data_valid <= 1'b0;

        case (state)

            WAIT_BAUD: begin
                rx_counter <= 16'd0;
                bit_index <= 3'd0;

                if (baud_valid) begin
                    state <= WAIT_IDLE;
                end
            end

            // Wait until the sync byte 0x55 has fully finished.
            // A real idle gap is detected when rx stays high for one bit time.
            WAIT_IDLE: begin
                if (rx == 1'b1) begin
                    if (rx_counter >= baud_count) begin
                        rx_counter <= 16'd0;
                        state <= IDLE;
                    end
                    else begin
                        rx_counter <= rx_counter + 16'd1;
                    end
                end
                else begin
                    rx_counter <= 16'd0;
                end
            end

            IDLE: begin
                rx_counter <= 16'd0;
                bit_index <= 3'd0;

                if (rx == 1'b0) begin
                    state <= START;
                end
            end

            START: begin
                if (rx_counter == (baud_count >> 1)) begin
                    rx_counter <= 16'd0;

                    if (rx == 1'b0) begin
                        state <= DATA;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                else begin
                    rx_counter <= rx_counter + 16'd1;
                end
            end

            DATA: begin
                if (rx_counter == baud_count - 1) begin
                    rx_counter <= 16'd0;
                    shift_reg[bit_index] <= rx;

                    if (bit_index == 3'd7) begin
                        bit_index <= 3'd0;
                        state <= STOP;
                    end
                    else begin
                        bit_index <= bit_index + 3'd1;
                    end
                end
                else begin
                    rx_counter <= rx_counter + 16'd1;
                end
            end

            STOP: begin
                if (rx_counter == baud_count - 1) begin
                    rx_counter <= 16'd0;

                    if (rx == 1'b1) begin
                        state <= DONE;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                else begin
                    rx_counter <= rx_counter + 16'd1;
                end
            end

            DONE: begin
                data_out <= shift_reg;
                data_valid <= 1'b1;

                bit_index <= 3'd0;
                rx_counter <= 16'd0;
                state <= IDLE;
            end

            default: begin
                state <= WAIT_BAUD;
                bit_index <= 3'd0;
                rx_counter <= 16'd0;
            end

        endcase
    end
end

endmodule
