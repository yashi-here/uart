module baud_counter(
    input clk,
    input rst,
    input edge_pulse,
    output reg [15:0] baud_count,
    output reg baud_valid
);

reg [15:0] counter;
reg [1:0] edge_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        baud_count <= 0;
        baud_valid <= 0;
        edge_count <= 0;
    end
    else begin

        counter <= counter + 1;

        if(edge_pulse) begin

            edge_count <= edge_count + 1;

            if(edge_count == 0)
                counter <= 0;

            else if(edge_count == 1) begin
                baud_count <= counter; 
                baud_valid <= 1;
            end
        end

    end
end

endmodule
