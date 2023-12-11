# IAC-RISC-V-32I-CPU-Team-23
Implementing a 32 bit RISCV-I instruction set CPU used to run a F1 light simulation, with additional versions which implement pipelining and data caching.

**Group Details**

| Name    | CID           | GitHub Username | Personal Statement           |
| :-----  | :-------------| :-------------  | :------------------          |
| Raymond | 02288579      | M-uch           | [Raymond's Personal Statement](/Personal_Statements/Raymond.md) |
| Letong  |               | ksrxlt          | [Letong's Personal Statement](/Personal_Statements/Letong.md)  |
| Mathew  | 02300957      | MatthewGodsmark | [Matthew's Personal Statement](/Personal_Statements/Matthew.md) |
| Alex    | 02269571      | AlexSeferidis   | [Alex's Personal Statement](/Personal_Statments/Alex.md)    |

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
| Jump & Ret Muxes        |     x     |          |     M     |   x    |
| Program Counter         |           |          |           |   M    |
| Register File           |     x     |          |     M     |   x    |
| Top level sv            |           |          |           |   M    |
| Testbench               |     M     |          |           |        |
| Debugging               |     x     |          |           |   x    |
| **Reference Program**   | **Raymond** | **Letong** | **Matthew** | **Alex** |
| Byte address Data Memory|     M     |          |     x     |        |
| Testbench               |     M     |          |           |        |
| Debugging               |     x     |          |           |   x    |
| **Pipelining Design**   | **Raymond** | **Letong** | **Matthew** | **Alex** |
| Pipeline Registers      |           |    M     |           |        |
| Hazard Detection Unit   |           |          |     M     |        |
| Top level sv            |           |          |           |        |
| Testbench               |           |          |           |        |
| Debugging               |           |          |           |        |
| **Reference Program**   | **Raymond** | **Letong** | **Matthew** | **Alex** |
| Testbench               |           |          |           |        |
| Debugging               |           |          |           |        |
| **Data Caching**        | **Raymond** | **Letong** | **Matthew** | **Alex** |

*Main Contributor = M*   
*Contribution = x*

# Repository Organisation

The decision was made to work using only the main branch to commit and pull changes to the project due to the following reasons.
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

Below are the tests for the provided signal data:

1. Sine wave - 'sine.mem'



2. Triangle wave - 'traingle.mem'

https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Pictures/triangletestnew.mp4 

3. Noise signl with gaussian distribtuion - 'gaussian.mem'



4. Noisy sine wave - 'noisy.mem'


**Specific details on components can be found in the personal statements and each component folder**

# 2. **Pipelined RISCV-32I**

# 3. **Data Caching RISCV-32I**