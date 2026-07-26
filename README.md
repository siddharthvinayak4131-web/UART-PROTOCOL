# UART Transceiver in Verilog HDL

## Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) Transmitter and Receiver using Verilog HDL. The design follows the standard UART communication protocol with 8-bit data transmission, 1 start bit, and 1 stop bit (8N1 format).

The project was simulated and verified using Xilinx Vivado.

---

## Features

* UART Transmitter (TX)
* UART Receiver (RX)
* 8-bit Data Communication
* 1 Start Bit
* 1 Stop Bit
* Configurable Baud Rate
* Configurable Clock Frequency
* FSM-Based Design
* Loopback Verification using Testbench

---

## Project Structure

```
uart-transceiver-verilog/

├── rtl/
│   ├── uart_tx.v
│   ├── uart_rx.v
│   └── uart_top.v
│
├── tb/
│   └── uart_tb.v
│
├── screenshots/
│   └── waveform.png
│
└── README.md
```

---

## UART Frame Format

```
| Start Bit | Data Bits (8) | Stop Bit |
|     0     |   D0 ... D7   |     1    |
```

Data is transmitted LSB first.

---

## Design Architecture

### UART Transmitter

The transmitter performs the following operations:

1. Waits for `tx_start`
2. Sends Start Bit (`0`)
3. Sends 8 Data Bits (LSB First)
4. Sends Stop Bit (`1`)
5. Returns to Idle State

### UART Receiver

The receiver performs the following operations:

1. Detects Start Bit
2. Receives Serial Data Bits
3. Stores Data into Shift Register
4. Detects Stop Bit
5. Generates `rx_done` signal

---

## Simulation Parameters

| Parameter       | Value    |
| --------------- | -------- |
| Clock Frequency | 50 MHz   |
| Baud Rate       | 9600 bps |
| Data Bits       | 8        |
| Stop Bits       | 1        |
| Parity          | None     |

---

## Test Cases

### Test Case 1

Input Data:

```
10110111
```

Expected Output:

```
10110111
```

---

### Test Case 2

Input Data:

```
00000000
```

Expected Output:

```
00000000
```

---

### Test Case 3

Input Data:

```
11111111
```

Expected Output:

```
11111111
```

---

## Simulation Results

The UART transmitter and receiver were successfully verified in Vivado Simulation. All test cases passed successfully, confirming correct serial transmission and reception of data.

Waveform screenshots are available in the `screenshots` directory.

---

## Tools Used

* Verilog HDL
* Xilinx Vivado Simulator
* Git
* GitHub

---

## Future Improvements

* Parity Bit Support
* Multiple Stop Bit Support
* Baud Rate Generator Module
* FIFO Integration
* UART Loopback on FPGA Hardware

---

## Author

Jay Jain

Electronics & Communication Engineering
