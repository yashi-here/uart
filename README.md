<div align="center">

# 🚀 UART Receiver with Auto-Baud Detection

### Verilog Implementation | Multi-Baud UART Receiver

A **Verilog-based UART receiver** capable of automatically detecting the baud rate  
using an incoming synchronization byte (`0x55`).

This project demonstrates a **complete digital design flow** including RTL design,  
simulation, synthesis, area analysis, and power estimation.

---

![Language](https://img.shields.io/badge/Language-Verilog-blue)
![Simulation](https://img.shields.io/badge/Simulation-Vivado-orange)
![Synthesis](https://img.shields.io/badge/Synthesis-Cadence%20Genus-green)
![Status](https://img.shields.io/badge/Project-Completed-brightgreen)
![Domain](https://img.shields.io/badge/Domain-VLSI%20Design-purple)

---

</div>

A **Verilog-based UART receiver** capable of **automatically detecting the baud rate** using an incoming synchronization byte (`0x55`).  
The receiver dynamically measures the bit period and configures the sampling logic without manual baud rate configuration.

This project demonstrates the **complete digital design flow** including:

✔ RTL Design  
✔ Functional Simulation (Vivado)  
✔ Waveform Verification  
✔ RTL Synthesis (Cadence Genus)  
✔ Area Analysis  
✔ Power Analysis  
✔ Post-Synthesis Verification  

---

# 📌 Project Status

| Stage | Status |
|------|--------|
| RTL Design | ✅ Completed |
| Functional Simulation | ✅ Completed |
| Multi-Baud Verification | ✅ Completed |
| RTL Synthesis | ✅ Completed |
| Area Analysis | ✅ Completed |
| Power Analysis | ✅ Completed |
| Post-Synthesis Verification | ✅ Completed |

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

The **detected bit time matches the testbench values**, validating correct auto-baud detection.

---

# 🧠 Working Principle

The receiver determines the baud rate using the synchronization byte:

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
RX ---->| Edge Detector  |
        +----------------+
                |
                v
        +----------------+
        | Baud Counter   |
        | (Auto Detect)  |
        +----------------+
                |
                v
        +----------------+
        | Baud Tick Gen  |
        +----------------+
                |
                v
        +----------------+
        | UART RX FSM    |
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

Area utilization after synthesis:

| Metric | Value |
|------|------|
| Total Cells | (Insert from report) |
| Combinational Cells | (Insert value) |
| Sequential Cells | (Insert value) |
| Total Area | (Insert value from Genus report) |

---

# 🔋 Power Analysis

Power estimation results:

| Power Component | Value |
|---------------|------|
| Dynamic Power | (Insert value) |
| Leakage Power | (Insert value) |
| Total Power | (Insert value) |

Power analysis was performed using **Cadence Genus power reports**.

---

# 📂 Repository Structure

| File | Description |
|------|-------------|
| edge_detector.v | RX edge detection module |
| baud_counter.v | Baud detection logic |
| baud_tick_gen.v | Tick generation module |
| uart_rxfsm.v | UART receiver FSM |
| uart_auto_baud_top.v | Top-level module |
| uart_auto_baud_tb.v | Testbench |
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
| Cadence Genus Reports | Area & Power analysis |

---
