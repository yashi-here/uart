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
parameter BIT_TIME_9600   = 104160;

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
    rx  = 1;      // UART idle
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

    // START BIT
    rx = 0;
    #(bit_time);

    // DATA BITS (LSB FIRST)
    for(i=0;i<8;i=i+1) begin
        rx = data[i];
        #(bit_time);
    end

    // STOP BIT
    rx = 1;
    #(bit_time);

end
endtask

//////////////////////////////////////////////////////
// TEST SEQUENCE
//////////////////////////////////////////////////////

initial begin

#20000;

////////////////////////////////////////
// TEST 1 : 115200
////////////////////////////////////////

$display("\n==============================");
$display("TESTING 115200 BAUD");
$display("==============================");

// SYNC BYTE
send_uart_byte(8'h55, BIT_TIME_115200);

// allow baud detection
#120000;

send_uart_byte(8'h2C, BIT_TIME_115200);
#80000;

send_uart_byte(8'hC0, BIT_TIME_115200);
#150000;

////////////////////////////////////////
// RESET
////////////////////////////////////////

$display("\nResetting DUT\n");
rst = 1;
#20000;
rst = 0;

#20000;

////////////////////////////////////////
// TEST 2 : 9600
////////////////////////////////////////

$display("\n==============================");
$display("TESTING 9600 BAUD");
$display("==============================");

// SYNC BYTE
send_uart_byte(8'h55, BIT_TIME_9600);

// allow baud detection
#400000;

send_uart_byte(8'hA8, BIT_TIME_9600);
#200000;

send_uart_byte(8'hC1, BIT_TIME_9600);
#2000000;

$finish;

end

//////////////////////////////////////////////////////
// DEBUG SIGNALS
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
// RX EDGE DEBUG
//////////////////////////////////////////////////////

always @(posedge dut.edge_pulse) begin
    $display("EDGE DETECTED  t=%0t  rx=%b  counter=%d",
              $time,
              dut.rx,
              dut.u2.counter);
end

//////////////////////////////////////////////////////
// BAUD DETECTION DEBUG
//////////////////////////////////////////////////////

always @(posedge clk) begin
    if(dut.baud_valid)
        $display("BAUD DETECTED  t=%0t  baud_count=%d",
                  $time,
                  dut.baud_count);
end

//////////////////////////////////////////////////////
// BIT TICK DEBUG
//////////////////////////////////////////////////////

always @(posedge dut.bit_tick) begin
    $display("BIT TICK        t=%0t", $time);
end

//////////////////////////////////////////////////////
// SAMPLE TICK DEBUG
//////////////////////////////////////////////////////

always @(posedge dut.sample_tick) begin
    $display("SAMPLE TICK     t=%0t  rx=%b  bit_index=%d",
              $time,
              dut.rx,
              dut.u4.bit_index);
end

//////////////////////////////////////////////////////
// FSM STATE DEBUG
//////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////
// BIT SHIFT DEBUG
//////////////////////////////////////////////////////

always @(posedge clk) begin
    if(dut.sample_tick && dut.u4.state==2) begin
        $display("BIT SAMPLE      t=%0t  bit=%d  rx=%b  shift=%b",
                  $time,
                  dut.u4.bit_index,
                  dut.rx,
                  dut.u4.shift_reg);
    end
end

//////////////////////////////////////////////////////
// BYTE RECEIVED
//////////////////////////////////////////////////////

always @(posedge clk) begin
    if(data_valid)
        $display("BYTE RECEIVED   t=%0t  data=%h",
                  $time,
                  data_out);
end

//////////////////////////////////////////////////////
// RX LINE CHANGE
//////////////////////////////////////////////////////

always @(rx) begin
    $display("RX CHANGE       t=%0t  rx=%b", $time, rx);
end

//////////////////////////////////////////////////////
// SIMULATION SAFETY TIMEOUT
//////////////////////////////////////////////////////

initial begin
    #5000000;
    $display("Simulation timeout");
    $finish;
end

endmodule
