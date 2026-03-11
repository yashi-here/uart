module uart_rxfsm(
    input clk,
    input rst,
    input rx,
    input baud_valid,
    input sample_tick,
    output reg [7:0] data_out,
    output reg data_valid
);

reg [2:0] bit_index;
reg [7:0] shift_reg;
reg [3:0] state;
reg first_byte_ignore;

localparam IDLE  = 0;
localparam START = 1;
localparam DATA  = 2;
localparam STOP  = 3;
localparam DONE  = 4;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        bit_index <= 0;
        data_valid <= 0;
        data_out <= 8'b0;
          first_byte_ignore <= 1;
    end
    else begin

        data_valid <= 0;

        case(state)

        IDLE:
            if(rx == 0 && baud_valid)
                state <= START;

        START:
            if(sample_tick)
                state <= DATA;

        DATA:
        begin
            if(sample_tick) begin
                shift_reg[bit_index] <= rx;

                if(bit_index == 7)
                    state <= STOP;
                else
                    bit_index <= bit_index + 1;
            end
        end

        STOP:
            if(sample_tick)
                state <= DONE;

DONE:
begin
    if(first_byte_ignore) begin
        first_byte_ignore <= 0;
    end
    else begin
        data_out <= shift_reg;
        data_valid <= 1;
    end

    bit_index <= 0;
    state <= IDLE;
end
        endcase
    end
end

endmodule
