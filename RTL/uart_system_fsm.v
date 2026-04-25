module uart_system_fsm(
    input clk,
    input rst,
    input baud_detected,
    input tx_busy,
    input tx_done,

    output reg tx_start,
    output reg [7:0] tx_data,
    output reg all_data_sent
);

reg [3:0] state;
reg [2:0] data_index;

localparam IDLE          = 4'd0;
localparam SEND_SYNC     = 4'd1;
localparam WAIT_SYNC     = 4'd2;
localparam WAIT_BAUD     = 4'd3;
localparam LOAD_DATA     = 4'd4;
localparam SEND_DATA     = 4'd5;
localparam WAIT_DATA     = 4'd6;
localparam COMPLETE      = 4'd7;

localparam TOTAL_BYTES = 4;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        data_index <= 3'd0;
        tx_start <= 1'b0;
        tx_data <= 8'd0;
        all_data_sent <= 1'b0;
    end
    else begin
        tx_start <= 1'b0;

        case (state)

            IDLE: begin
                all_data_sent <= 1'b0;
                data_index <= 3'd0;
                tx_data <= 8'h55;
                state <= SEND_SYNC;
            end

            SEND_SYNC: begin
                if (!tx_busy) begin
                    tx_start <= 1'b1;
                    state <= WAIT_SYNC;
                end
            end

            WAIT_SYNC: begin
                if (tx_done) begin
                    state <= WAIT_BAUD;
                end
            end

            WAIT_BAUD: begin
                if (baud_detected) begin
                    state <= LOAD_DATA;
                end
            end

            LOAD_DATA: begin
                case (data_index)
                    3'd0: tx_data <= 8'h2C;
                    3'd1: tx_data <= 8'hC0;
                    3'd2: tx_data <= 8'hA5;
                    3'd3: tx_data <= 8'h5A;
                    default: tx_data <= 8'h00;
                endcase

                state <= SEND_DATA;
            end

            SEND_DATA: begin
                if (!tx_busy) begin
                    tx_start <= 1'b1;
                    state <= WAIT_DATA;
                end
            end

            WAIT_DATA: begin
                if (tx_done) begin
                    if (data_index == TOTAL_BYTES - 1) begin
                        state <= COMPLETE;
                    end
                    else begin
                        data_index <= data_index + 3'd1;
                        state <= LOAD_DATA;
                    end
                end
            end

            COMPLETE: begin
                all_data_sent <= 1'b1;
                state <= COMPLETE;
            end

            default: begin
                state <= IDLE;
            end

        endcase
    end
end

endmodule
