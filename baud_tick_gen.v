module baud_tick_gen(
    input clk,
    input rst,
    input [15:0] baud_count,
    input baud_valid,
    output reg sample_tick,
    output reg bit_tick
);
reg [15:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        sample_tick <= 0;
        bit_tick <= 0;
    end

    else if(baud_valid) begin

        sample_tick <= 0;
        bit_tick <= 0;

        if(counter >= baud_count) begin
            counter <= 0;
            bit_tick <= 1;
        end
        else begin
            counter <= counter + 1;
        end

        if(counter == (baud_count >> 1))
            sample_tick <= 1;

    end

    else begin
        counter <= 0;
    end
    end
endmodule
