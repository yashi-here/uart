`timescale 1ns/1ps

module uart_auto_baud_tb;

reg clk;
reg rst;
reg rx;

wire [7:0] data_out;
wire data_valid;

parameter CLK_PERIOD = 20;

// Bit times
parameter BIT_TIME_115200 = 8680;
parameter BIT_TIME_57600  = 17360;
parameter BIT_TIME_19200  = 52080;
parameter BIT_TIME_9600   = 104160;
parameter BIT_TIME_4800   = 208320;

//////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////

uart_auto_baud_top dut(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .data_out(data_out),
    .data_valid(data_valid)
);

//////////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////////

initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

//////////////////////////////////////////////////////
// RESET
//////////////////////////////////////////////////////

initial begin
    rst = 1;
    rx  = 1;
    #200;
    rst = 0;
end

//////////////////////////////////////////////////////
// UART TRANSMIT TASK
//////////////////////////////////////////////////////

task send_uart_byte;
input [7:0] data;
input integer bit_time;
integer i;

begin
    $display("\n--- TRANSMIT BYTE %h ---", data);

    // START
    rx = 0;
    #(bit_time);

    // DATA
    for(i=0;i<8;i=i+1) begin
        rx = data[i];
        #(bit_time);
    end

    // STOP
    rx = 1;
    #(bit_time);
end
endtask

//////////////////////////////////////////////////////
// TEST SEQUENCE
//////////////////////////////////////////////////////

initial begin

#20000;

//////////////////////////////////////////////////
// TEST 1 : 115200
//////////////////////////////////////////////////

$display("\n==============================");
$display("TESTING 115200 BAUD");
$display("==============================");

send_uart_byte(8'h55, BIT_TIME_115200);

#120000;

send_uart_byte(8'h2C, BIT_TIME_115200);
#80000;

send_uart_byte(8'hC0, BIT_TIME_115200);
#150000;


//////////////////////////////////////////////////
// RESET
//////////////////////////////////////////////////

$display("\nResetting DUT\n");
rst = 1;
#20000;
rst = 0;

#20000;

//////////////////////////////////////////////////
// TEST 2 : 57600
//////////////////////////////////////////////////

$display("\n==============================");
$display("TESTING 57600 BAUD");
$display("==============================");

send_uart_byte(8'h55, BIT_TIME_57600);

#200000;

send_uart_byte(8'h33, BIT_TIME_57600);
#200000;

send_uart_byte(8'hF0, BIT_TIME_57600);
#300000;


//////////////////////////////////////////////////
// RESET
//////////////////////////////////////////////////

$display("\nResetting DUT\n");
rst = 1;
#20000;
rst = 0;

#20000;

//////////////////////////////////////////////////
// TEST 3 : 19200
//////////////////////////////////////////////////

$display("\n==============================");
$display("TESTING 19200 BAUD");
$display("==============================");

send_uart_byte(8'h55, BIT_TIME_19200);

#300000;

send_uart_byte(8'hA5, BIT_TIME_19200);
#300000;

send_uart_byte(8'h5A, BIT_TIME_19200);
#400000;


//////////////////////////////////////////////////
// RESET
//////////////////////////////////////////////////

$display("\nResetting DUT\n");
rst = 1;
#20000;
rst = 0;

#20000;

//////////////////////////////////////////////////
// TEST 4 : 9600
//////////////////////////////////////////////////

$display("\n==============================");
$display("TESTING 9600 BAUD");
$display("==============================");

send_uart_byte(8'h55, BIT_TIME_9600);

#400000;

send_uart_byte(8'hA8, BIT_TIME_9600);
#200000;

send_uart_byte(8'hC1, BIT_TIME_9600);
#500000;


//////////////////////////////////////////////////
// RESET
//////////////////////////////////////////////////

$display("\nResetting DUT\n");
rst = 1;
#20000;
rst = 0;

#20000;

//////////////////////////////////////////////////
// TEST 5 : 4800
//////////////////////////////////////////////////

$display("\n==============================");
$display("TESTING 4800 BAUD");
$display("==============================");

send_uart_byte(8'h55, BIT_TIME_4800);

#600000;

send_uart_byte(8'h3C, BIT_TIME_4800);
#600000;

send_uart_byte(8'hF3, BIT_TIME_4800);
#2000000;

$finish;

end

//////////////////////////////////////////////////////
// DEBUG SIGNALS
//////////////////////////////////////////////////////

always @(posedge dut.edge_pulse) begin
    $display("EDGE DETECTED  t=%0t  rx=%b  counter=%d",
              $time,
              dut.rx,
              dut.u2.counter);
end

always @(posedge clk) begin
    if(dut.baud_valid)
        $display("BAUD DETECTED  t=%0t  baud_count=%d",
                  $time,
                  dut.baud_count);
end

always @(posedge dut.bit_tick) begin
    $display("BIT TICK        t=%0t", $time);
end

always @(posedge dut.sample_tick) begin
    $display("SAMPLE TICK     t=%0t  rx=%b  bit_index=%d",
              $time,
              dut.rx,
              dut.u4.bit_index);
end

reg [3:0] prev_state = 0;

always @(posedge clk) begin
    if(prev_state != dut.u4.state) begin
        $display("STATE CHANGE    t=%0t  %d -> %d",
                  $time,
                  prev_state,
                  dut.u4.state);
        prev_state <= dut.u4.state;
    end
end

always @(posedge clk) begin
    if(dut.sample_tick && dut.u4.state==2) begin
        $display("BIT SAMPLE      t=%0t  bit=%d  rx=%b  shift=%b",
                  $time,
                  dut.u4.bit_index,
                  dut.rx,
                  dut.u4.shift_reg);
    end
end

always @(posedge clk) begin
    if(data_valid)
        $display("BYTE RECEIVED   t=%0t  data=%h",
                  $time,
                  data_out);
end

always @(rx) begin
    $display("RX CHANGE       t=%0t  rx=%b", $time, rx);
end

//////////////////////////////////////////////////////
// SAFETY TIMEOUT
//////////////////////////////////////////////////////

initial begin
    #10000000;
    $display("Simulation timeout");
    $finish;
end

endmodule
