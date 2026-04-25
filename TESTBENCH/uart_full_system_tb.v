`timescale 1ns/1ps

module uart_full_system_tb;

reg clk;
reg rst;

wire [7:0] rx_data_out;
wire rx_data_valid;
wire baud_detected;
wire all_data_sent;
wire tx_line;
wire [31:0] detected_baud_rate;
wire [31:0] detected_bit_time_ns;

parameter CLK_PERIOD = 20;

// Change this value to test other baud rates
parameter TEST_BAUD_RATE = 9600;

uart_full_system_top #(
    .CLK_FREQ(50000000),
    .BAUD_RATE(TEST_BAUD_RATE)
) dut (
    .clk(clk),
    .rst(rst),
    .rx_data_out(rx_data_out),
    .rx_data_valid(rx_data_valid),
    .baud_detected(baud_detected),
    .all_data_sent(all_data_sent),
    .tx_line(tx_line),
    .detected_baud_rate(detected_baud_rate),
    .detected_bit_time_ns(detected_bit_time_ns)
);

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
    rst = 1'b1;
    #200;
    rst = 1'b0;
end

initial begin
    $display("====================================");
    $display("FULL UART SYSTEM TEST");
    $display("TX sends 0x55 first");
    $display("RX detects baud");
    $display("TX sends actual data after detection");
    $display("====================================");

    #10000000;

    $display("Simulation timeout");
    $finish;
end

always @(posedge baud_detected) begin
    $display("BAUD DETECTED at t=%0t", $time);
    $display("Detected baud rate   = %0d", detected_baud_rate);
    $display("Detected bit time ns = %0d", detected_bit_time_ns);
end

always @(posedge rx_data_valid) begin
    $display("RX DATA RECEIVED at t=%0t : %h", $time, rx_data_out);
end

always @(posedge all_data_sent) begin
    $display("ALL TX DATA SENT at t=%0t", $time);

    #2000000;

    $display("====================================");
    $display("TEST COMPLETED");
    $display("====================================");

    $finish;
end

endmodule
