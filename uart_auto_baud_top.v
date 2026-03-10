module uart_auto_baud_top(
    input clk,
    input rst,
    input rx,
    output [7:0] data_out,
    output data_valid
);

wire edge_pulse;
wire [15:0] baud_count;
wire baud_valid;
wire sample_tick;
wire bit_tick;

edge_detector u1(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .edge_pulse(edge_pulse)
);

baud_counter u2(
    .clk(clk),
    .rst(rst),
    .edge_pulse(edge_pulse),
    .baud_count(baud_count),
    .baud_valid(baud_valid)
);

baud_tick_gen u3(
    .clk(clk),
    .rst(rst),
    .baud_count(baud_count),
    .baud_valid(baud_valid),
    .sample_tick(sample_tick),
    .bit_tick(bit_tick)
);

uart_rxfsm u4(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .sample_tick(sample_tick),
    .data_out(data_out),
    .data_valid(data_valid)
);

endmodule