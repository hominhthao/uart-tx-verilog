# UART Transmitter (TX) in Verilog

This project implements a **UART Transmitter** using Verilog HDL, based on a
Finite State Machine (FSM) that serializes 8-bit parallel input into a standard
UART serial stream (8N1 format).

---

## Features

- FSM-based UART transmitter
- Parameterizable baud rate via `CLKS_PER_BIT`
- 8-bit parallel-to-serial transmission (LSB first)
- Start bit and stop bit handling
- Verified with directed testbench using Icarus Verilog and GTKWave

---

## UART Frame Format (8N1)
```
Idle  Start   D0   D1   D2   D3   D4   D5   D6   D7   Stop  Idle
  1     0     lsb  ...  ...  ...  ...  ...  ...  msb    1     1
        ←──────────────── 10 bit periods ────────────────→
```

---

## FSM State Diagram
```
IDLE
  ↓  (tx_start = 1)
START_BIT
  ↓
DATA_BITS (8 bits, LSB first)
  ↓
STOP_BIT
  ↓
CLEANUP
  ↓
IDLE
```

---

## Parameters

| Parameter      | Default | Description                      |
|----------------|---------|----------------------------------|
| `CLKS_PER_BIT` | 868     | Clock cycles per UART bit period |

**Baud rate formula:**
```
CLKS_PER_BIT = CLK_FREQ / BAUD_RATE
```

| Clock  | Baud Rate | CLKS_PER_BIT |
|--------|-----------|--------------|
| 50 MHz | 115200    | 434          |
| 50 MHz | 57600     | 868          |
| 25 MHz | 115200    | 217          |

---

## Port Description

| Port        | Dir    | Width | Description                        |
|-------------|--------|-------|------------------------------------|
| `clk`       | input  | 1     | System clock                       |
| `rst_n`     | input  | 1     | Active-low synchronous reset       |
| `tx_start`  | input  | 1     | Pulse HIGH to begin transmission   |
| `tx_data`   | input  | 8     | Parallel data byte to transmit     |
| `tx_serial` | output | 1     | UART serial output line            |
| `tx_done`   | output | 1     | Pulses HIGH for 1 clk when TX done |

---

## Project Structure
```
uart-tx-verilog/
├── src/
│   └── uart_tx.v              # TX RTL module
├── tb/
│   └── uart_tb.v              # Directed testbench
├── sim/
│   └── waveform/
│       ├── uart_tx_waveform1.png   # Overview waveform
│       └── uart_tx_waveform2.png   # Zoom — single UART frame
├── Makefile
└── README.md
```

---

## Simulation

### Prerequisites
- [Icarus Verilog](http://iverilog.icarus.com/)
- [GTKWave](http://gtkwave.sourceforge.net/)

### Compile and run
```bash
iverilog -o sim/uart_sim src/uart_tx.v tb/uart_tb.v
vvp sim/uart_sim
gtkwave sim/waveform/uart_tx.vcd
```

---

## Simulation Waveform

### Overview — full simulation

![UART TX waveform overview](sim/waveform/uart_tx_waveform1.png)

### Zoom — single UART frame

![UART TX waveform zoom](sim/waveform/uart_tx_waveform2.png)

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Git & GitHub

---

## Related

- [uart-rx-verilog](https://github.com/hominhthao/uart-rx-verilog) — UART Receiver (RX) + Loopback Verification

> Together, `uart-tx-verilog` and `uart-rx-verilog` form a complete
> **full-duplex UART 8N1** implementation verified end-to-end via loopback testbench.

---

## Author

**Ho Minh Thao**
Electronics & Telecommunications Engineering — HCMUT
Interested in Digital IC Design, RTL Design, and VLSI Systems
