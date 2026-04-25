module baud_counter #(
    parameter CLK_FREQ = 50000000,
    parameter CLK_PERIOD = 20
)(
    input clk,
    input rst,
    input edge_pulse,
    output reg [15:0] baud_count,
    output reg baud_valid,
    output reg [31:0] baud_rate,
    output reg [31:0] bit_time_ns
);

reg [15:0] counter;
reg [2:0] edge_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter     <= 16'd0;
        baud_count  <= 16'd0;
        baud_valid  <= 1'b0;
        edge_count  <= 3'd0;
        baud_rate   <= 32'd0;
        bit_time_ns <= 32'd0;
    end
    else begin
        if (!baud_valid) begin
            counter <= counter + 16'd1;
        end

        if (edge_pulse && !baud_valid) begin
            edge_count <= edge_count + 3'd1;

            if (edge_count == 3'd0) begin
                counter <= 16'd0;
            end
            else if (edge_count == 3'd1) begin
                baud_count  <= counter + 16'd1;
                baud_rate   <= CLK_FREQ / (counter + 16'd1);
                bit_time_ns <= (counter + 16'd1) * CLK_PERIOD;
                baud_valid  <= 1'b1;
            end
        end
    end
end

endmodule
