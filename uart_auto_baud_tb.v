`timescale 1ns/1ps

module uart_auto_baud_tb;

reg clk;
reg rst;
reg rx;

wire [7:0] data_out;
wire data_valid;

parameter CLK_PERIOD = 20;
parameter BIT_TIME   = 8680;

uart_auto_baud_top dut(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .data_out(data_out),
    .data_valid(data_valid)
);

//
// CLOCK GENERATOR
//
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

//
// RESET
//
initial begin
    rst = 1;
    rx  = 1;
    #200;
    rst = 0;
end

//
// UART TRANSMIT TASK
//
task send_uart_byte;
input [7:0] data;
integer i;
begin

    // start bit
    rx = 0;
    #(BIT_TIME);

    // data bits
    for(i=0;i<8;i=i+1) begin
        rx = data[i];
        #(BIT_TIME);
    end

    // stop bit
    rx = 1;
    #(BIT_TIME);

end
endtask

//
// TEST SEQUENCE
//
initial begin

#20000;

$display("Sending SYNC byte 0x55");
send_uart_byte(8'h55);

#20000;

$display("Sending DATA byte 0xA5");
send_uart_byte(8'hA5);

#20000;

$display("Sending DATA byte 0x3C");
send_uart_byte(8'h3C);

#100000;

$finish;

end

//
// DEBUG PRINTS
//
always @(posedge clk) begin
    $display(
    "t=%0t | rx=%b edge=%b baud_cnt=%d baud_valid=%b sample=%b bit_tick=%b state=%d bit=%d shift=%h data_valid=%b data=%h",
    $time,
    dut.rx,
    dut.edge_pulse,
    dut.baud_count,
    dut.baud_valid,
    dut.sample_tick,
    dut.bit_tick,
    dut.u4.state,
    dut.u4.bit_index,
    dut.u4.shift_reg,
    dut.data_valid,
    dut.data_out
    );
end

//
// RX CHANGE MONITOR
//
always @(rx)
    $display("RX changed to %b at time %t", rx, $time);

//
// DATA RECEIVED
//
always @(posedge clk) begin
    if(data_valid)
        $display("Received Data = %h at time %t", data_out, $time);
end

endmodule