# IAC-RISC-V-32I-CPU-Team-23
Implementing a 32 bit RISCV-I instruction set CPU used to run an F1 light simulation, with an additional version which implements pipelining.

**Group Details**

| Name    | CID           | GitHub Username | Personal Statement           |
| :-----  | :-------------| :-------------  | :------------------          |
| Raymond | 02288579      | M-uch           | [Raymond's Personal Statement](/Personal_Statements/Raymond.md) |
| Letong  | 02225603      | ksrxlt          | [Letong's Personal Statement](/Personal_Statements/Letong.md)   |
| Matthew | 02300957      | MatthewGodsmark | [Matthew's Personal Statement](/Personal_Statements/Matthew.md) |
| Alex    | 02269571      | AlexSeferidis   | [Alex's Personal Statement](/Personal_Statements/Alex.md)        |

Project Work Division
---
Below is a breakdown of how we distributed the work amongst ourselves:

| Single Cycle CPU        | Raymond   | Letong   | Matthew   | Alex   |
| :---------              | :-------: | :------: | :-------: | :----: |
| Group Statement         |     x     |          |           |   x    |
| F1 Assembly Code        |     M     |          |           |        |
| ALU                     |     x     |          |     M     |   x    |   
| Control Unit            |     x     |          |           |   M    |   
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
| Pipeline Registers      |           |          |     M     |        |
| Hazard Detection Unit   |           |          |     M     |        |
| Top level sv            |           |          |     x     |    M   |
| Fetch Stage             |           |          |           |    M   |
| Decode Stage            |           |          |           |    M   |
| Execute Stage           |           |          |     M     |    x   |
| Memory Stage            |           |          |     M     |    x   |
| Writeback Stage         |           |          |     M     |    x   |
| Debugging               |     x     |          |     x     |    x   |

*Main Contributor = M*   
*Contribution = x*

# Repository Organisation

The decision was made to work within a branch for each version of the CPU, with single cycle and pipelining being seperate branches. <br/>
This benefited us by:
- reducing management due to branch merging and maintenance
- ensuring that all team members are working with the newest version of the project
- ease of access to all resources and work

Individual work on components and tests with each version of the CPU were created in separate folders. By doing this, components could easily be copied and tested by others in their own folders when needed.

to avoid overlap and accidental removal of work when committing, members would individually work on folders and notify others if jointly working in one. A git pull would be run before starting a work session, with all changes being committed upon finishing. 

# Overview of CPU Models

1. [**Single Cycle RISCV-32I**](#1-single-cycle-riscv-32i): CPU used to run the F1 light sequence program and reference programs provided, including jump instructions.

2. [**Pipelined RISCV-32I**](#2-pipelined-riscv-32i): CPU with 5 stage pipelining which improves performance by staging instructions across multiple steps.

3. [**Caching RISCV-32I**](#3-caching-riscv-32i): CPU with pipelining and caching which improves performance by storing relavant data and instructions. 

# 1. Single Cycle RISCV-32I: 

Various components could be pulled from lab 4 and reused in the project with additional modifications to include a larger instruction set such as J-types, S-types and new I-type instructions.

**Lab 4 CPU Diagram**

![Alt text](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Pictures/Pasted%20image%2020231207112136.png)

**Project Brief Diagram**

![Alt text](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Pictures/Pasted%20image%2020231207111708.png)

## Our Design: ##

**Abstracted 'Top' CPU Diagram**

![Alt text](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Personal_Statements/src/Top_Abstracted.png)

**Unabstracted CPU Diagram**

![Alt text](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Personal_Statements/src/Top_UnAbstracted.png)
Tthe following tasks needed to be completed to finish the first stage of the project:

- Writing an f1 program in assembly and converting to it's little endian machine code equivalent 
- Adding the data memory component and it's respective multiplexer (including byte sized addressing)
- Implementing additional operations to the ALU
- Implementing additional control signals to the control unit for the JAL instructions and the store load instructions
- Adding components to allow for jumps (storing the RET address and returning to respective address on RET)
- Implementing a trigger that can be externally changed through Vbuddy to start the f1 light sequence on demand

**For detailed explanations of work see individual statements**

## Evidence ##

Below is the test for the F1 Program:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/92a46c07-49b1-4605-88e9-9a3c40543e0d


Below are the tests for the provided signal data:

1. Sine wave - sine.mem:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/70d67e01-1402-4487-a6f4-13e8fe51c50d

![Alt text](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Test_Evidence/vcd_waveforms/sine.png)

2. Triangle wave - triangle.mem:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/03f22519-758b-468f-bdb6-fa98026f6996

![Alt text](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Test_Evidence/vcd_waveforms/Triangle.png)

3. Noise signal with gaussian distribution - gaussian.mem:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/92d7c906-4bcf-46a5-abcd-91c0d0818510

![Alt text](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Test_Evidence/vcd_waveforms/Gaussian.png)

4. Noisy sine wave - noisy.mem:

https://github.com/M-uch/IAC_RISCV32I_Team_23/assets/123762865/a66fb50a-68e7-4e3f-a972-f938b1e35a6e

![Alt text](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Test_Evidence/vcd_waveforms/Noisy.png)

# 2. **Pipelined RISCV-32I**

For files and CPU see [Pipeline Processor Branch](https://github.com/M-uch/IAC_RISCV32I_Team_23/tree/Pipeline-Processor).

This branch contains all pipeline related work. Including the rtl source, and test folders for F1 and PDF programs.

## Pipeline Structure ##

We decided to split the pipeline into 5 stages:

1. Fetch
2. Decode
3. Execute
4. Memory
5. Writeback

Below is a diagram detailing the abstracted scope of the top file:

![Alt text](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Personal_Statements/src/Top_Abstracted_P.png)

## Pipeline Performance ## 

This was measured by counting the number of cycles from start to finish.

| .mem File | Single Cycle | Pipelined |
| :-------: | :----------: | :-------: |
| sine      | 37562        | 56445     |           
| noisy     | 204900       | 307475    |            
| gaussian  | 123728       | 185695    |            
| triangle  | 316028       | 474172    |            

It was discovered that for our particular PDF program, pipelining is slower. This is due to the fact that the program frequently branches and jumps and so this causes the hazard unit to frequently flush the pipeline registers, which increases the number of cycles it takes to run the program.

This can be seen in the following wavefile of noisy.mem:

![Noisy Wave Viewer](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Test_Evidence/Pipeline_Performance/noisypipelinewaveform.png)

Left of the marker is the PDF program before plotting and to the right is during plotting. It can be seen clearly that flushes occur very frequently, therefore explaining the loss in performance for our particular program.
    
# 3. **Caching RISCV-32I**

Caching was the next step to our processor design, we had planned to implement two-way associative cache on top of our pipeline processor with hazard handling. 

However, due to unforeseen cirumstances and delays we decided that it would be best to focus on ensuring that the quality of our current work was to a good standard. 

#

This project both used information and followed the same structure as the CPU from [Digital Design and Computer Architecture: RISC-V Edition](https://www.vlebooks.com/Product/Index/2432539?page=0&startBookmarkId=-1) by Harris, Sarah L.
