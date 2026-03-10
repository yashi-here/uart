module edge_detector(
    input clk,
    input rst,
    input rx,
    output edge_pulse
);

reg rx_d;

always @(posedge clk or posedge rst) begin
    if (rst)
        rx_d <= 1'b1;   // UART idle state
    else
        rx_d <= rx;
end

assign edge_pulse = rx ^ rx_d;

endmodule