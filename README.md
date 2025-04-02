# Verification-of-Router-1X3-using-UVM

# Router 1x3 Verification using UVM

## Project Overview

This project implements the **verification environment** for a **Router 1x3** using **Universal Verification Methodology (UVM)** in SystemVerilog. The router receives data from a single input port and forwards it to one of the three output ports based on control signals. The testbench ensures correctness, efficiency, and robustness of the design.

## Verification Architecture

The verification environment follows the standard UVM structure and consists of the following components:

### 1. **UVM Agent**

- **Router Agent:** Encapsulates the driver, monitor, and sequencer.
- **Router Driver:** Sends packets with control signals to the **Device Under Test (DUT)**.
- **Router Monitor:** Observes transactions and forwards them to the scoreboard.
- **Router Sequencer:** Generates test scenarios and sequences.

### 2. **UVM Environment**

- **Router Environment:** Instantiates the **Agent**, **Scoreboard**, and **Coverage Collector**.
- **Router Scoreboard:** Compares actual and expected output and Measures functional coverage to ensure verification completeness.

### 3. **UVM Testbench**

- **Router Test:** Runs different test cases for various routing scenarios.

## Test Scenarios

The following test cases are implemented:

### ✅ **Basic Packet Transmission:**

- Verify correct routing to output ports based on control signals.

### ✅ **Back-to-Back Transactions:**

- Ensure no data loss or corruption in continuous packet transmission.

### ✅ **Boundary Conditions:**

- Check behavior when the router operates at max load.

### ✅ **Randomized Stimulus Testing:**

- Send packets with random control signals and validate correctness.

### ✅ **Error Injection Testing:**

- Verify DUT behavior under faulty conditions (e.g., parity errors, invalid control signals).

## Key Files

```
├── rtl/                         # RTL source files
│   ├── router_1x3.v             # Router 1x3 Verilog implementation
├── uvm_tb/                      # UVM Testbench
│   ├── router_agent.sv          # UVM Agent
│   ├── router_driver.sv         # UVM Driver
│   ├── router_monitor.sv        # UVM Monitor
│   ├── router_sequencer.sv      # UVM Sequencer
│   ├── router_sequence.sv       # UVM Test Sequences
│   ├── router_scoreboard.sv     # UVM Scoreboard
│   ├── router_env.sv            # UVM Environment
│   ├── router_test.sv           # Top-level Testbench
├── sim/                         # Simulation scripts and logs
├── README.md                    # This documentation
```

## Simulation & Results

After running the UVM testbench, the following outputs will be generated:

- **Simulation Logs:** Capturing test execution details.
- **Functional Coverage Reports:** Indicating the verification completeness.
- **Waveform Files:** For debugging in simulation tools like **QuestaSim or VCS**.

## Tools & Methodologies

- **Language:** SystemVerilog (SV)
- **Methodology:** Universal Verification Methodology (UVM)
- **Simulation Tools:** QuestaSim, VCS
- **Coverage Metrics:** Code and functional coverage

## Contribution

Feel free to fork the repository and contribute by adding additional test cases or improving the verification architecture.

## License

This project is licensed under the **MIT License**.

## Author

📌 **Vikas K**  
📩 **Contact:** [GitHub Profile](https://github.com/Vk13io)
