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

        if(counter == baud_count) begin
            counter <= 0;
            bit_tick <= 1;
        end
        else
            counter <= counter + 1;

        if(counter == (baud_count >> 1))
            sample_tick <= 1;

    end
end

endmodule