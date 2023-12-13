# IAC-RISC-V-32I-CPU-Team-23
Implementing a 32 bit RISCV-I instruction set CPU used to run a F1 light simulation, with additional versions which implement pipelining and data caching.

**Group Details**

| Name    | CID           | GitHub Username | Personal Statement           |
| :-----  | :-------------| :-------------  | :------------------          |
| Raymond | 02288579      | M-uch           | [Raymond's Personal Statement](/Personal_Statements/Raymond.md) |
| Letong  |               | ksrxlt          | [Letong's Personal Statement](/Personal_Statements/Letong.md)   |
| Matthew | 02300957      | MatthewGodsmark | [Matthew's Personal Statement](/Personal_Statements/Matthew.md) |
| Alex    | 02269571      | AlexSeferidis   | [Alex's Personal Statement](/Personal_Statments/Alex.md)        |

Project Work Division
---
Below is a breakdown of how we distributed the work amongst ourselves:

| Single Cycle CPU        | Raymond   | Letong   | Matthew   | Alex   |
| :---------              | :-------: | :------: | :-------: | :----: |
| Group Statement         |     x     |          |           |   x    |
| F1 Assembly Code        |     M     |          |           |        |
| ALU                     |           |          |     M     |   x    |   
| Control Unit            |     x     |    x     |           |   M    |   
| Data Memory             |           |          |     M     |        |     
| Instruction Memory      |     M     |          |           |        |
| Imm Extender            |     M     |          |           |        |
| Jump & Ret Muxes        |     x     |          |     x     |   x    |
| Program Counter         |           |          |           |   M    |
| Register File           |     x     |          |     M     |   x    |
| Top level sv            |           |          |           |   M    |
| Testbench               |     M     |          |           |        |
| Debugging               |     x     |          |           |   x    |
| **Reference Program**   | **Raymond** | **Letong** | **Matthew** | **Alex** |
| PDF.s Modification      |     M     |          |           |        |
| Byte address Data Memory|     M     |          |           |        |
| Testbench               |     M     |          |           |        |
| Debugging               |     x     |          |           |   x    |
| **Pipelining Design**   | **Raymond** | **Letong** | **Matthew** | **Alex** |
| Pipeline Registers      |           |          |     M     |    x   |
| Hazard Detection Unit   |     x     |          |     M     |        |
| Top level sv            |           |          |     x     |    M   |
| Fetch Stage             |           |          |           |    M   |
| Decode Stage            |           |          |           |    M   |
| Execute Stage           |           |          |     M     |    x   |
| Memory Stage            |           |          |     M     |    x   |
| Writeback Stage         |           |          |     M     |    x   |
| Debugging               |           |          |     x     |    x   |


*Main Contributor = M*   
*Contribution = x*

# Repository Organisation

The decision was made to work within a branch for each version of the CPU, with single cycle and pipelining being seperate branches. 
- Reduced management due to branch merging and maintenance
- ensures that all team members are working with the newest version of the project
- ease of access to all resources and work

Individual work on components and tests on versions each CPU were created in separate folders to make them distinguishable, and components could be copied and tested with others in their own folders when needed.

to avoid overlap and accidental removal of work when committing, members would individually work on folders and notify others if jointly working in one, a git pull would be run before starting a work session, with all changes being committed upon finishing. 

# Summary of CPU Models

1. **Single Cycle RISCV-32I**: CPU used to run the F1 light sequence program and reference programs provided, including jump instructions

2. **Pipelined RISCV-32I**: CPU with pipelining which improves performance by fetching instructions for multiple steps.

3. **Data Caching RISCV-32I**: CPU with data caching which improves performance by storing frequently used data. 

# 1. Single Cycle RISCV-32I: 

Various components could be pulled from lab 4 and reused in the project with additional modifications to include a larger instruction set such as J-types, S-types and new I-type instructions.

**Lab 4 CPU Diagram**

![Alt text](<Pictures/Pasted image 20231207112136.png>)

**Project Diagram**

![Alt text](<Pictures/Pasted image 20231207111708.png>)

the following tasks needed to completed to finish the first stage of the project:

- Writing a f1 program in assembly and converting to it's little endian machine code equivalent 
- Adding the data memory component and it's respective multiplexer (including byte sized addressing)
- implementing additional operations to the ALU
- implementing additional control signals to the control unit for the JAL instructions required and store load instructions
- Adding components to allow for jumps (storing the RET address and returning to respective address on RET)
- implementing a trigger that can be externally changed through Vbuddy to start the f1 light sequence on demand

## Evidence ##

Below is the test for the F1 Program:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/184ebd14-43eb-4edf-9ec3-9e22c294e63d


Below are the tests for the provided signal data:

1. Sine wave - sine.mem:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/70d67e01-1402-4487-a6f4-13e8fe51c50d

2. Triangle wave - triangle.mem:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/03f22519-758b-468f-bdb6-fa98026f6996

3. Noise signal with gaussian distribution - gaussian.mem:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/92d7c906-4bcf-46a5-abcd-91c0d0818510

4. Noisy sine wave - noisy.mem:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/a66fb50a-68e7-4e3f-a972-f938b1e35a6e

**Specific details on components can be found in the personal statements and each component folder**

# 2. **Pipelined RISCV-32I**

For files and CPU see [Pipeline Processor Branch](https://github.com/M-uch/IAC_RISCV32I_Team_23/tree/Pipeline-Processor).

We decided to design our Pipelined processor into multiple modules:

1. Fetch
    This includes the modules:
    - Instruction memory
    - PC register
    - PC mux
    - PC + 4

    And has the following inputs:
    - PC Target E
    - StallF
    - StallD
    - FlushD
    - PCSrcE
    - clk

    And has the following outputs:
    - InstrD
    - PCD
    - PC+4D

2. Decode
    This includes the modules:
    - Register file
    - Extend
    - CU

    And has the following inputs:
    - InstrD
    - PCD
    - PC+4D
    - RegWriteW
    - ResultW
    - RdW
    - FlushE
    - Trigger
    - (NOT) clk

    And has the following outputs:
    - RegWriteE
    - ATypeE
    - ResultSrcE
    - MemWriteE
    - JumpE
    - BranchE
    - ALUCtrlE
    - ALUSrcE
    - Rd1E
    - Rd2E
    - PCE
    - RAE
    - A0
    - Rs1E
    - Rs2E
    - RDE
    - ImmExtE
    - PC+4E
    - Rs1D
    - Rs2D

3. Execute

    This includes the modules:
    - 2, 3 input muxes
    - 2 input mux
    - PC Targer
    - ALU

    And has the following inputs:
    - RegWriteE
    - ATypeE
    - ResultSrcE
    - MemWriteE
    - JumpE
    - BranchE
    - ALUCtrlE
    - ALUSrcE
    - Rd1E
    - Rd2E
    - PCE
    - RAE
    - Rs1E
    - Rs2E
    - RDE
    - ImmExtE
    - PC+4E
    - ALUResultM
    - ResultW
    - FowardAE
    - ForwardBE

    And has the following outputs:
    - RDE
    - RDM
    - RS2E
    - RS1E
    - PCsrcE
    - PC+4M
    - WriteDataM
    - ALUResultM
    - MemWriteM
    - ResultSrcM
    - RegWriteM

4. Memory
    This includes the modules:
    - Data memory

    And has the following inputs:
    - RDM
    - PC+4M
    - WriteDataM
    - ALUResultM
    - MemWriteM
    - ResultSrcM
    - RegWriteM
    - clk

    And has the following outputs:
    - RegWriteM
    - RegWriteW
    - RDM
    - ALUResultM
    - ResultSrcW
    - ReadDataW
    - ALUResultW
    - RDW
    - PC+4W

5. Writeback
    This includes the modules:
    - 3 input mux

    And has the following inputs:
    - RegWriteW
    - ResultSrcW
    - ReadDataW
    - ALUResultW
    - RDW
    - PC+4W

    And has the following outputs:
    - RDW
    - ResultW
    - RegWriteW
    
# 3. **Data Caching RISCV-32I**

N/A