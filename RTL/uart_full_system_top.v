module uart_full_system_top #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input clk,
    input rst,

    output [7:0] rx_data_out,
    output rx_data_valid,
    output baud_detected,
    output all_data_sent,
    output tx_line,
    output [31:0] detected_baud_rate,
    output [31:0] detected_bit_time_ns
);

wire tx_start;
wire [7:0] tx_data;
wire tx_busy;
wire tx_done;

uart_system_fsm u_uart_system_fsm(
    .clk(clk),
    .rst(rst),
    .baud_detected(baud_detected),
    .tx_busy(tx_busy),
    .tx_done(tx_done),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .all_data_sent(all_data_sent)
);

uart_tx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) u_uart_tx(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx_line),
    .tx_busy(tx_busy),
    .tx_done(tx_done)
);

uart_auto_baud_top u_uart_auto_baud_rx(
    .clk(clk),
    .rst(rst),
    .rx(tx_line),
    .data_out(rx_data_out),
    .data_valid(rx_data_valid),
    .baud_detected(baud_detected),
    .baud_rate(detected_baud_rate),
    .bit_time_ns(detected_bit_time_ns)
);

endmodule
