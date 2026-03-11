🚀 UART Receiver with Auto-Baud Detection (Verilog)

A Verilog-based UART receiver capable of automatically detecting the baud rate from an incoming synchronization byte.
The design measures the bit period dynamically and configures the receiver timing without manual baud configuration.

This project currently includes:

✔ RTL Design
✔ Functional Simulation
✔ Waveform Verification

Simulation and verification were performed using Xilinx Vivado Simulator.

Future work will include logic synthesis and timing analysis using Cadence Genus.

📌 Project Features

✨ Automatic baud rate detection
✨ Supports multiple baud rates without configuration
✨ Modular RTL design
✨ Edge-based bit timing measurement
✨ Fully verified through simulation

⚙️ Design Specifications
Parameter	Value
Clock Frequency	50 MHz
Clock Period	20 ns
UART Frame	1 Start + 8 Data + 1 Stop
Detection Method	Edge-based Auto-Baud
Language	Verilog HDL
📡 Supported Baud Rates

The following baud rates were verified through simulation.

Baud Rate	Clock Cycles	Bit Time
115200	434	8680 ns
57600	868	17360 ns
19200	2604	52080 ns
9600	5208	104160 ns
4800	10416	208320 ns

The detected bit time matches the testbench configuration, confirming correct auto-baud operation.

🧠 Working Principle

The receiver detects baud rate using a synchronization byte:

0x55

Binary representation:

01010101

This pattern generates transitions at every bit boundary, allowing the system to measure the UART bit period.

Detection Process

1️⃣ Detect first RX transition
2️⃣ Start clock counter
3️⃣ Detect next RX transition
4️⃣ Measure clock cycles between edges
5️⃣ Calculate baud rate
6️⃣ Generate sampling ticks

The synchronization byte is used only for baud detection and is ignored as data.

🏗 System Architecture
RX Input
   │
   ▼
Edge Detector
   │
   ▼
Baud Counter
   │
   ▼
Baud Tick Generator
   │
   ▼
UART RX FSM
   │
   ▼
Parallel Data Output
📦 Module Description
1️⃣ Edge Detector

Detects transitions on the RX signal.

Purpose

Generates a pulse whenever RX changes state

Used for measuring edge timing during baud detection

2️⃣ Baud Counter

Measures the number of clock cycles between two RX edges.

Outputs

baud_count

baud_rate

bit_time_ns

baud_valid

Equations

baud_rate = CLK_FREQ / baud_count
bit_time_ns = baud_count × CLK_PERIOD
3️⃣ Baud Tick Generator

Generates timing signals used for sampling UART bits.

Outputs:

bit_tick → indicates one UART bit period

sample_tick → sampling point at middle of bit

4️⃣ UART Receiver FSM

State machine responsible for receiving serial data.

States:

IDLE → START → DATA → STOP → DONE

Responsibilities

Detect start bit

Sample data bits

Assemble received byte

Output valid data

🧪 Simulation Environment

Simulation was performed using Xilinx Vivado Simulator.

Clock configuration:

Clock Frequency = 50 MHz
Clock Period = 20 ns
🧾 Testbench Operation

The testbench performs the following sequence:

1. Send synchronization byte (0x55)
2. Allow baud detection
3. Transmit data bytes
4. Verify receiver output

Example transmission sequence:

0x55  → Sync byte
0x2C  → Data
0xC0  → Data
📊 Waveform Verification

The simulation waveform verifies correct operation of:

RX signal transitions

Edge detection

Baud detection

Bit sampling

Byte reconstruction

Signals observed:

rx
edge_pulse
baud_valid
baud_count
bit_tick
sample_tick
data_out
data_valid

📷 (Waveform screenshot available in repository)

📂 Repository Structure
uart_auto_baud/
│
├── edge_detector.v
├── baud_counter.v
├── baud_tick_gen.v
├── uart_rxfsm.v
├── uart_auto_baud_top.v
│
├── uart_auto_baud_tb.v
│
├── waveform.png
│
└── README.md
▶️ Running Simulation

Using Vivado Simulator

1️⃣ Create a Vivado project
2️⃣ Add all Verilog source files
3️⃣ Set uart_auto_baud_tb.v as the top simulation module
4️⃣ Run behavioral simulation

Observe waveform signals to verify UART reception.

🔧 Current Project Status

✔ RTL design completed
✔ Functional verification completed
✔ Multi-baud detection verified

🚧 Next Phase

RTL synthesis using Cadence Genus

Gate-level simulation

Timing analysis

🛠 Tools Used
Tool	Purpose
Vivado	RTL design and simulation
Verilog HDL	Hardware description
Vivado Waveform Viewer	Signal analysis
Cadence Genus	Planned synthesis
