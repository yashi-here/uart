# 🚀 UART Receiver with Auto-Baud Detection

![Language](https://img.shields.io/badge/Language-Verilog-blue)
![Simulation](https://img.shields.io/badge/Simulation-Vivado-orange)
![Synthesis](https://img.shields.io/badge/Synthesis-Cadence%20Genus-green)
![Domain](https://img.shields.io/badge/Domain-VLSI%20Design-purple)

---
## 📌 Project Description

This project implements a **UART Receiver with Auto-Baud Detection** using **Verilog HDL**.  
The receiver automatically determines the baud rate using a synchronization byte (`0x55`) and configures the sampling logic accordingly.

The project demonstrates a **complete digital VLSI design flow**, including:

- RTL Design  
- Functional Simulation (Vivado)  
- Waveform Verification (Vivado & Cadence)  
- RTL Synthesis (Cadence Genus)  
- Gate-Level Netlist Generation  
- Quality of Results (QoR) Analysis  
- Area Analysis  
- Power Analysis  
- Timing Analysis  

---

# 📊 Design Flow Coverage

| Design Stage | Tool Used |
|--------------|-----------|
| RTL Design | Verilog HDL |
| Functional Simulation | Vivado Simulator |
| Waveform Verification | Vivado & Cadence |
| RTL Synthesis | Cadence Genus |
| Netlist Generation | Cadence Genus |
| QoR Analysis | Cadence Genus |
| Area Analysis | Cadence Genus |
| Power Analysis | Cadence Genus |
| Timing Analysis | Cadence Genus |

---

# 📊 Project Overview

| Feature | Description |
|-------|-------------|
| Project | UART Receiver with Auto-Baud Detection |
| Language | Verilog HDL |
| Simulation Tool | Xilinx Vivado |
| Synthesis Tool | Cadence Genus |
| Clock Frequency | 50 MHz |
| Clock Period | 20 ns |
| UART Frame Format | 1 Start, 8 Data, 1 Stop |
| Detection Method | Edge-Based Auto-Baud Detection |

---

# ⚙️ Design Specifications

| Parameter | Value |
|----------|------|
| Clock Frequency | 50 MHz |
| Clock Period | 20 ns |
| Data Bits | 8 |
| Start Bit | 1 |
| Stop Bit | 1 |
| Parity | None |
| Synchronization Byte | 0x55 |

---

# 📡 Supported Baud Rates

| Baud Rate | Clock Cycles per Bit | Bit Time (ns) |
|-----------|----------------------|---------------|
| 115200 | 434 | 8680 |
| 57600 | 868 | 17360 |
| 19200 | 2604 | 52080 |
| 9600 | 5208 | 104160 |
| 4800 | 10416 | 208320 |

The detected bit time matches the testbench configuration, validating correct auto-baud detection.

---

# 🧠 Working Principle

The receiver determines the baud rate using the synchronization byte:
0x55
Binary representation:
01010101

This bit pattern generates **transitions at every bit boundary**, enabling accurate measurement of the UART bit period.

### Detection Process

| Step | Operation |
|----|-----------|
| 1 | Detect first RX edge |
| 2 | Start clock counter |
| 3 | Detect next RX edge |
| 4 | Measure clock cycles between edges |
| 5 | Calculate baud rate |
| 6 | Generate sampling ticks |

The synchronization byte is **used only for baud detection and ignored as data**.

---

# 🧩 System Architecture
 +----------------+

RX ---->| Edge Detector |
+----------------+
|
v
+----------------+
| Baud Counter |
| (Auto Detect) |
+----------------+
|
v
+----------------+
| Baud Tick Gen |
+----------------+
|
v
+----------------+
| UART RX FSM |
+----------------+
|
v
DATA_OUT

 
---

# 🔄 Internal Operation Flow
RX Signal
│
▼
Edge Detection
│
▼
Measure Edge-to-Edge Time
│
▼
Calculate Baud Count
│
▼
Generate bit_tick & sample_tick
│
▼
UART FSM Samples Data Bits
│
▼
Assemble Byte
│
▼
Output data_out + data_valid


---

# 🧩 Module Description

| Module | Function |
|------|---------|
| edge_detector | Detects transitions on the RX signal |
| baud_counter | Measures clock cycles between edges to detect baud rate |
| baud_tick_gen | Generates bit_tick and sample_tick signals |
| uart_rxfsm | UART receiver finite state machine |
| uart_auto_baud_top | Top-level integration module |
| uart_auto_baud_tb | Simulation testbench |

---

# 🧪 RTL Simulation (Vivado)

RTL simulation was performed using **Xilinx Vivado Simulator**.

| Parameter | Value |
|----------|------|
| Simulation Tool | Vivado |
| Clock Frequency | 50 MHz |
| Clock Period | 20 ns |
| Verification Method | Behavioral Simulation |

---

# 📊 Simulation Waveform

The waveform verifies correct UART reception including edge detection, baud detection, and data sampling.

![Waveform](outputs/waveform.png)

---

# ⚡ RTL Synthesis (Cadence Genus)

RTL synthesis was performed using **Cadence Genus**.

| Parameter | Value |
|----------|------|
| Tool | Cadence Genus |
| Input | Verilog RTL |
| Output | Synthesized Gate-Level Netlist |
| Target Clock | 50 MHz |

---

# 📏 Area Analysis

| Metric | Value |
|------|------|
| Total Cell Count | 282 |
| Combinational Cells | 204 |
| Sequential Cells | 78 |
| Cell Area | 2711.216 µm² |
| Net Area | 0 |
| Total Area | 2711.216 µm² |

The design occupies a relatively small area since it mainly contains counters and FSM logic.

---

# 🔋 Power Analysis

| Power Component | Value |
|---------------|------|
| Leakage Power | 1.43858e-05 W |
| Internal Power | 1.30239e-04 W |
| Switching Power | 9.97730e-06 W |
| **Total Power** | **1.54602e-04 W** |

Power distribution:

| Component | Contribution |
|----------|-------------|
| Registers | 89.90% |
| Logic | 6.62% |
| Clock | 3.47% |

---

# ⏱ Timing Analysis

| Metric | Value |
|------|------|
| Clock Period | 20 ns |
| Worst Slack | 16101 ps |
| Total Negative Slack | 0 |
| Violating Paths | 0 |

The design meets timing constraints comfortably for a **50 MHz clock**.

---

# 📈 Quality of Results (QoR)

| Metric | Value |
|------|------|
| Leaf Instance Count | 282 |
| Sequential Instances | 78 |
| Combinational Instances | 204 |
| Max Fanout | 78 |
| Average Fanout | 2.6 |
| Terms to Net Ratio | 3.74 |
| Terms to Instance Ratio | 4.18 |

---

# 📂 Repository Structure
uart-auto-baud/
│
├── rtl/
│ ├── edge_detector.v
│ ├── baud_counter.v
│ ├── baud_tick_gen.v
│ ├── uart_rxfsm.v
│ └── uart_auto_baud_top.v
│
├── testbench/
│ └── uart_auto_baud_tb.v
│
├── outputs/
│ ├── waveform.png
│ └── layout_images/
│ └── synthesis_layout.png
│
└── README.md

---

# 📁 Folder Description

| Folder | Description |
|------|-------------|
| rtl | Contains Verilog RTL design modules |
| testbench | Contains the simulation testbench |
| outputs | Contains waveform screenshots and synthesis results |
| README.md | Project documentation |

---

# 🛠 Tools Used

| Tool | Purpose |
|-----|--------|
| Verilog HDL | Hardware description language |
| Xilinx Vivado | RTL simulation |
| Vivado Waveform Viewer | Signal verification |
| Cadence Genus | RTL synthesis |
| Cadence Reports | Area, Power, Timing, QoR analysis |

---
