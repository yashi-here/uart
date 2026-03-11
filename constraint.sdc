# Clock definition (50 MHz clock)
create_clock -name clk -period 20 [get_ports clk]

# Clock transition (10% of clock period)
set_clock_transition -rise 2 [get_clocks clk]
set_clock_transition -fall 2 [get_clocks clk]

# Clock uncertainty (setup/hold margin)
set_clock_uncertainty 0.2 [get_clocks clk]

# Input delays (relative to clock)
set_input_delay 2 -clock clk [get_ports rx]
set_input_delay 2 -clock clk [get_ports rst]

# Output delays
set_output_delay 2 -clock clk [get_ports data_out]
set_output_delay 2 -clock clk [get_ports data_valid]