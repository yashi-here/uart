module edge_detector(
    input clk,
    input rst,
    input rx,
    output edge_pulse
);

reg rx_d1, rx_d2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rx_d1 <= 1'b1;
        rx_d2 <= 1'b1;
    end
    else begin
        rx_d1 <= rx;
        rx_d2 <= rx_d1;
    end
end

assign edge_pulse = rx_d1 ^ rx_d2;

endmodule