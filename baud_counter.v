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
        counter     <= 0;
        baud_count  <= 0;
        baud_valid  <= 0;
        edge_count  <= 0;
        baud_rate   <= 0;
        bit_time_ns <= 0;
    end

    else begin

        if(!baud_valid)
            counter <= counter + 1;

        if(edge_pulse && !baud_valid) begin

            edge_count <= edge_count + 1;

            // First edge → start measuring
            if(edge_count == 0) begin
                counter <= 0;
            end

            // Second edge → capture bit time
            else if(edge_count == 1) begin
                baud_count  <= counter + 1;
                baud_rate   <= CLK_FREQ / (counter + 1);
                bit_time_ns <= (counter + 1) * CLK_PERIOD;
                baud_valid  <= 1;
            end
        end

    end
end

endmodule
