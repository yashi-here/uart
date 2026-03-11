module baud_counter(
    input clk,
    input rst,
    input edge_pulse,
    output reg [15:0] baud_count,
    output reg baud_valid
);

reg [15:0] counter;
reg [2:0] edge_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter     <= 0;
        baud_count  <= 0;
        baud_valid  <= 0;
        edge_count  <= 0;
    end
    else begin

        // Count clock cycles only until baud detected
        if(!baud_valid)
            counter <= counter + 1;

        if(edge_pulse && !baud_valid) begin

            edge_count <= edge_count + 1;

            // First edge → start measurement
            if(edge_count == 0) begin
                counter <= 0;
            end

            // Second edge → capture bit period
            else if(edge_count == 1) begin
                baud_count <= counter;
                baud_valid <= 1;
            end
        end

    end
end

endmodule
