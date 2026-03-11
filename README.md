# 🚀 UART Receiver with Auto-Baud Detection

### Verilog Implementation | Multi-Baud UART Receiver

A **Verilog-based UART receiver** capable of **automatically detecting the baud rate** using an incoming synchronization byte (`0x55`).  

The receiver dynamically measures the bit period and configures the sampling logic without manual baud rate configuration.

This project demonstrates a **complete digital VLSI design flow** including RTL design, simulation, synthesis, and physical analysis.

---

# 📌 Design Flow Coverage

| Design Stage | Tool Used |
|--------------|-----------|
| RTL Design | Verilog HDL |
| Functional Simulation | Vivado Simulator |
| Multi-Baud Waveform Verification | Vivado & Cadence |
| RTL Synthesis | Cadence Genus |
| Gate-Level Netlist Generation | Cadence Genus |
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
| UART Frame | 1 Start, 8 Data, 1 Stop |
| Detection Method | Edge-based Auto-Baud Detection |

---

# ⚙️ Design Specifications

| Parameter | Value |
|----------|------|
| Clock Frequency | 50 MHz |
| Clock Period | 20 ns |
| Data Bits | 8 |
| Start Bits | 1 |
| Stop Bits | 1 |
| Parity | None |
| Synchronization Byte | 0x55 |

---

# 📡 Supported Baud Rates

The design was verified with the following baud rates.

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

The receiver determines the baud rate using a synchronization byte:0x55

Binary representation:01010101

This pattern produces **transitions at every bit boundary**, enabling accurate measurement of the UART bit period.

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

# 🧩 Module Description

| Module | Function |
|------|---------|
| edge_detector | Detects transitions on the RX signal |
| baud_counter | Measures clock cycles between edges to detect baud rate |
| baud_tick_gen | Generates bit_tick and sample_tick signals |
| uart_rxfsm | UART receiver state machine |
| uart_auto_baud_top | Top-level integration module |
| uart_auto_baud_tb | Simulation testbench |

---

# 🧪 RTL Simulation (Vivado)

RTL simulation was performed using **Xilinx Vivado Simulator**.

| Parameter | Value |
|----------|------|
| Simulation Tool | Vivado Simulator |
| Clock Frequency | 50 MHz |
| Clock Period | 20 ns |
| Verification Method | Behavioral Simulation |

---

# 📊 Waveform Verification

Simulation waveforms confirm correct functionality.

| Observed Signal | Description |
|---------------|-------------|
| rx | UART serial input |
| edge_pulse | Pulse generated on RX transition |
| baud_count | Clock cycles per UART bit |
| baud_valid | Indicates successful baud detection |
| bit_tick | UART bit timing signal |
| sample_tick | Sampling point inside bit |
| data_out | Received parallel data |
| data_valid | Indicates valid received byte |

*(Waveform screenshot available in repository)*

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

The design occupies a relatively small area since the UART receiver mainly consists of counters and FSM logic.

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

Registers dominate power consumption due to the presence of counters and state registers.

---

# ⏱ Timing Analysis

| Metric | Value |
|------|------|
| Clock Period | 20000 ps (20 ns) |
| Worst Slack | 16101 ps |
| Total Negative Slack | 0 |
| Violating Paths | 0 |
| Timing Status | ✅ Timing Met |

The design comfortably meets timing constraints for a **50 MHz clock**.

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

These results indicate efficient logic distribution with minimal fanout overhead.

---

# 📂 Repository Structure

| File | Description |
|------|-------------|
| edge_detector.v | RX edge detection module |
| baud_counter.v | Baud detection logic |
| baud_tick_gen.v | Tick generation module |
| uart_rxfsm.v | UART receiver FSM |
| uart_auto_baud_top.v | Top-level module |
| uart_auto_baud_tb.v | Simulation testbench |
| waveform.png | Simulation waveform |
| README.md | Project documentation |

---

# ▶️ Running RTL Simulation

| Step | Action |
|----|-------|
| 1 | Create a Vivado project |
| 2 | Add all Verilog source files |
| 3 | Set `uart_auto_baud_tb.v` as simulation top |
| 4 | Run Behavioral Simulation |
| 5 | Observe waveform outputs |

---

# 🛠 Tools Used

| Tool | Purpose |
|-----|--------|
| Verilog HDL | Hardware description |
| Xilinx Vivado | RTL simulation |
| Vivado Waveform Viewer | Signal verification |
| Cadence Genus | RTL synthesis |
| Cadence Genus Reports | Area, Power, Timing, QoR analysis |
| Cadence Innovus | Layout |
