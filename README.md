# CPU

## Overview
This project implements a simple single-cycle CPU architecture using Verilog. The CPU includes modules for arithmetic operations, memory management, and instruction handling. Additionally, an assembler is provided to convert assembly code into machine code that the implemented CPU can execute.

## CPU File Descriptions
- **alu.v:** Implements the Arithmetic Logic Unit (ALU) for performing arithmetic and logical operations.
- **branch_comparator.v:** Handles comparison operations for branching.
- **data_memory.v:** Manages data storage and retrieval.
- **defines.vh:** Contains global definitions and constants used across modules.
- **instruction_memory.v:** Manages instruction storage and retrieval.
- **register_module.v:** Implements the register file for the CPU.
- **run_top.v:** Component used for simulation.
- **top.v:** Top-level module integrating all components.

## Features
- **Assembler:** Converts assembly language programs into machine-readable instructions.
- **/Assembly/:** Folder with example assembly code that can be run on the CPU using the assembler.

## Example Assembly Programs
- **Assembly/all_instructions.txt:** Demonstrates all supported instructions.
- **Assembly/fibonacci.txt:** Computes the Nth fibonacci number.

## How to Use
1. **Assemble Code:**
   - Modify the user-defined variables at the top of `assembler.py` to point to your assembly and instruction memory files.
   - Run the assembler using Python to generate machine code.
2. **Run Program:**
   - Open your verilog simulation software and simulate with the simulation source set to `run_top.v`.

## Requirements
- **Software:**
  - Verilog simulator (e.g., ModelSim, Vivado)
  - Python 3.x

## License
This project is open-source and available under the MIT License.