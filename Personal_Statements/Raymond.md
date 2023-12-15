# Overview
This statement outlines my contributions to the group project and the development of a RISC-V 32I CPU with single cycle and also pipelining capabilities. The statement is divided into the following sections.

1. [Writing the F1 Program in Assembly](#writing-the-f1-program-in-assembly)
2. [Instruction Memory](#instruction-memory)
3. [Data Memory RAM with Byte Addressing](#data-memory-ram-with-byte-addressing)
4. [Immediate Extension Module](#immediate-extension-module)
5. [Debugging of the F1 Program in Single Cycle](#debugging-of-the-f1-program-in-single-cycle)
6. [Debugging of the Reference PDF Program in Single Cycle](#debugging-of-the-reference-pdf-program-in-single-cycle)
7. [Miscellaneous Contributions](#miscellaneous-contributions)
8. [Challenges during the Project](#challenges-during-the-project)
9. [Conclusions](#conclusions)
10. [Significant Commits](#significant-commits)
11. [Other Notes](#other-notes)

# Writing the F1 program in Assembly

I was responsible for writing the F1 lights sequence in assembly for use in the RISCV CPU. The general concept for this system was to have an idle loop where a LFSR utilising a Primitive polynomial that would store its current value into a register, which would determine the length of the final delay when all the lights are on. This would be used for both the single cycle and pipelined processor with hazard detection.

see [F1ProgramAnnotated.s](<../Legacy Components/F1 Code/F1ProgramAnnotated.s>)

The complete program displays an F1 light sequence, initiated with a trigger, with a random final delay determined by a LFSR with a primitive polynomial degree 8 and 256 different delay lengths.

Register T0 is directly accessed and written to in the CPU hardware using Vbuddy's flag state, this allows for the activation of the F1 light sequence on demand.

The program developed does generates it's random delay locally, reducing the overall complexity during testing and debugging. And for the project's requirements, a pseudo random delay is sufficient.

## Testing the Program

I used the VSCode extension [RISC-V Venus Simulator](https://marketplace.visualstudio.com/items?itemName=hm.riscv-venus) which allows for step simulating through the program, as well as inspecting the registers and their values. This allowed for a relatively simple debugging process for the program. 

![Alt text](<Raymond Media/F1TEST.png>)

Stepping through a version of the F1 program during the debugging process. Current instruction highlighted in yellow, registers located on the left hand side, registers that have recently updated are highlighted as they change.

the subsequent program was then compiled using the shell script provided in the project brief, which generated a hexadecimal array where instructions are in little endian format. Each address would represent a byte of the 32 bit instruction, where the least significant address corresponds to the least significant byte, and address+3 would represent the most significant byte.

## Additional Changes

To further simplify the program for debugging unconditional branches which originally used "BEQ zero, zero" to a BNE version reducing the instructions set to only one type of branch.

# Instruction Memory

The instruction memory remains relatively unchanged from lab 4, simply loading the .mem containing instructions to be executed. The hex files generated from our assembler store instructions in bytes with little endian form, so in order to reconstruct the correct instruction from a given address, we must read the given address and 3 consecutive addresses and flip the order of bytes where the first address represents the least significant byte.

The instruction memory is designed to be asynchronous ROM, since no writing is needed, reducing the risk of instruction corruption during testing. 

![Alt text](<Raymond Media/Instruction Memory Diagram.png>)

see [Instrmem.sv](<../Legacy Components/Instruction Memory/instrmem.sv>)

Although the memory map from the project brief states to follow the offset for instructions in the memory map, this is only necessary if data and instructions are being kept in the same memory as this separates the two allowing for easier debugging.

The CPU utilises a Harvard architecture style with separate data and instruction memory components so only the size of the instruction memory need be followed.

![Alt text](<Raymond Media/Instruction Memory Map.png>)

Addresses range from 0xBFC00000 to 0xBFC00FFF hence 2^12 addresses for the instruction memory array.

# Data Memory RAM with Byte Addressing

The data memory shares similarity with instruction memory previously developed as data memory loaded from the reference program is also stored in little endian format, although there is no use of 32 bit word addressing in the F1 and reference program. 

Additions that differ the Data memory from instruction memory is a synchronous write, and the inclusion of both byte and word read/write using a 1 bit control signal which determine the type of addressing. This allows for the use of byte addressing instructions such as SB and LBU in the reference program.

![Alt text](<Raymond Media/Data Memory Diagram.png>)

see [DataMemory.sv](<../Legacy Components/RMAD with byte addressing/DataMemory.sv>)

Writing to the data memory is controlled by the signals WE (Write enable) and ADTP (Addressing type). 

ADTP = 0 writes a full 32 bit value into the memory using the same method as reading, bits 0~7 are written into the input address, 8~15 into address+1 etc.

When ADTP = 1, this specifies byte addressing, the data memory will only write into the exact address the first 8 bits of input write data. When reading the value from the exact address is output after being extended with 0s to the left giving a 8 bit value extended to 32 bits.

![Alt text](<Raymond Media/Data Memory Map.png>)

Following the memory map provided for the reference program, data loaded into the array starts at an offset of 0x10000 to separate the loaded data from the memory addresses used by the pdf program. 

# Immediate Extension Module

The immediate extension module is responsible for reconstructing the correct immediate operand (if any) from the current instruction and sign extending it to the correct 32 bit length immediate, preserving it's value in two's complement. 

This was a relatively simple task of concatenation and checking the most significant bit following the structure of the RISCV instruction set.

![Alt text](<Raymond Media/RISCV Instruction Architecture.png>)

see [signextend.sv](<../Legacy Components/ImmExtend/signextend.sv>)

# Debugging of the F1 Program in Single Cycle

The debugging of the program was jointly done with Alex, which mostly involved analysis of the VCD files produced during test runs of the CPU with the F1 program using a test bench I coded [F1_tb.cpp](<../Legacy Components/TestBenches/F1_tb.cpp>) which would connect a0 to the LED strip and allow for t0 to be toggled with Vbuddy's flag.

The major error in our CPU identified during the debugging process was the control signals that were produced when a JAL or JALR instruction was being executed. 

![Alt text](<Raymond Media/J Type Muxes.jpg>)

On JAL and JALR instructions, a specified register rd should have PC+4 written into. However for RET (a special case of JALR where rd = zero) there should be no write as it is returning from a subroutine, and if writing is enabled to the registers, this results in register zero being overwritten to a non zero value. Which results in erroneous branches and load integer instructions, this caused the program to indefinitely loop on branches that should've had a set number of loops.

![Alt text](<Raymond Media/RET Pseudoinstruction.png>)

![Alt text](<Raymond Media/F1 Debugging.png>)

VCD of F1 program being run on CPU, marked line shows the point at which register zero is being written into on a RET instruction.

To fix this problem, we corrected the control unit's signals to disable the register write enable when executing RET instruction so that only a saved address would be loaded into PC and no PC+4 would be written into the zero register.

# Debugging of the Reference PDF Program in Single Cycle

Also done jointly with Alex. Debugging the reference PDF program had a similar process to the F1 program, we loaded the program into the instruction memory along with a data set provided into the instruction memory, using the test bench I programmed [pdf_tb.cpp](../rtl/pdf_tb.cpp). The subsequent VCD file was then analysed to identify any errors. 

## Overwrite of the Zero Register

A similar error was discovered that overwrote the zero register, on the instruction "J forever" another pseudo instruction that is a special case of "JAL zero, offset". Since an unconditional jump has it's write address as register zero, this would result in an overwrite of the zero register once again, corrupting any load immediate instructions and others involving the zero register. 

![Alt text](<Raymond Media/J Psuedoinstruction.png>)

To fix this issue and any future cases we added a condition to the register's write enable, disabling it if the write address (A3) is designated as 0, which holds the zero register removing any potential overwrites for any instruction type.

![Alt text](<Raymond Media/Zero register fix.png>)

## Failure to execute LUI

In the PDF program an instance of LI translates to LUI as the immediate associated (0x10000, the offset of the data memory base_data) is greater than 12 bits for regular LI -> ADDI. At the time LUI had not yet been implemented to our CPU, this resulted in an set of addresses being incorrect as the data array's offset was incorrect. To circumvent this issue I had modified the PDF program to load the base_data offset correctly using a 12 bit LI and left shifts.

So "LI a1, base_data" was changed to the following to correctly load base_data into a1 using the current hardware avaliable. 

![Alt text](<Raymond Media/PDF mod.png>)

## Length of Simulation

An oversight was made when testing the program with different memories loaded was that we were unaware of the number of cycles it would take the program to initialise the pdf array completely, and plotting the output register a0 continuously would slow down the cycle rate of the system greatly, so that it seems as if the program has no output when run for a short amount of time.

When running the program with each data memory they would take a varying number of cycles to completely initialise before output is displayed:

sine.mem -> 30000+ cycles
noisy.mem -> 200000+ cycles
gaussian.mem -> 120000+ cycles
triangle.mem -> 310000+ cycles

When plotting output onto Vbuddy's display this would reduce the number of cycles per second to < 100, meaning to see any relevant output the simulation would have had to run for a minimum of 5 minutes. 

![Alt text](<Raymond Media/Plot Ignore.png>)

To fix this problem I reprogrammed the test bench to only begin plotting to VBuddy once and non zero output was detected from a0. This allowed for the simulation to run much faster using the full capabilities of the laptop's CPU (speeds in GHz), avoiding being bottlenecked by Vbuddy's unnecessary plotting during initialisation when there is no output. The initialisation would only take less than a second to complete once this change was made, and the desired results were achieved in the test and recorded (See recordings in team personal statement README.md)

# Miscellaneous Contributions

This section briefly covers areas of work that I assisted in, but did not manage directly.

**1. Jump & RET muxes:**
   The jump and RET muxes were something that I had initially mentioned during the development of the single cycle CPU, as they were required to correctly store and load a return address during J type instructions. They could be implemented as a set of 2, 2 input multiplexers with a control signals as a select. Discussion eventually led to the decision to integrate the JUMP mux into the result mux where PC+4 would be an input to write into the registers given the correct control signals, and the RET mux would be implemented separately to load register Ra into the PC on RETs. Matthew took on the task of programming them into his RMAD top level file.
   
**2. Trigger input to CPU for F1 program:**
   To include a manual trigger for the f1 program I modified the register block so that it would take an external input and write directly into T0 (register x5), this register is then used to determine when to initiate the F1 light sequence in the program. Using the Vbuddy flag state in one shot mode proved as sufficient input for t0.

**3. Pipelining debugging and testing:**
   Matthew and Alex did most of the programming for the pipelining stage, as my laptop broke down suddenly during the start of this stage. I helped mainly by giving an extra opinion during the debugging stage as they inspected the VCD files generated during the tests. The difference in performance between the single cycle and pipelined processors were also noted by me and Alex, where it was discovered that the pipelined processor performed much slower than the single cycle. This was due to the frequent flushing of the pipeline registers as both the F1 and PDF programs used jumps and branches very frequently. Final tests were done as a team before committing rtl and final test folders for each of the processor versions.

**4. Additional implementation of instructions:**
   For additional completeness of our CPU, Alex and I decided to implement and test the LUI instruction afterwards which was originally omitted in the F1 and PDF programs. This involved an addition of an ALU function and modification of it's respective control signals. 

**5. Repository Organisation:** 
   Organisation of the repository and it's branches were discussed frequently between the team as everyone had partial responsibility. This includes the group statement and various other descriptions in the repo such as the test instructions.

# Challenges during the Project

Various challenges were encountered during the duration of this project, which have proven good learning experiences and have given me better insight for future projects and team work.

1. Communication between team members has been an important aspect of this project, in order to keep up with the work and avoid overlap effective communication was maintained using the messaging app "WhatsApp", here we could stay updated while we worked on the project remotely, or organise team work sessions in the department's study lab.
   
2. The importance of having a consistent coding style across the whole project has become apparent, as inconsistent naming schemes for input and output of components make it much more difficult in long term development. As a project grows in complexity, having to revisit code to decipher it's function becomes increasingly tedious. This is even more important when working on a project with other team members, as each person's coding style will vary.
   
3. Backing up data and ensuring you have a secondary workspace became a hard learned lesson when my laptop broke down becoming unusable (see [Other Notes](#other-notes) for more details). While I had lost no progress to my work on the project, it became delayed as I had no available computer to work with at them time, having to spend time to find a set up a new workstation as I had not prepared one prior.
   
4. Understanding of the different CPU components proved difficult due to each team member working with each specific area of the CPU led to greater individual understanding. However this meant that time needed to be spent for members to understand other components in details. To improve this issue I commented most of my work in detail to show it's function, allowing for others to understand without having to directly ask me.

# Conclusions 

**Technical skills gained**:
- Github and Git proficiency
- Markdown proficiency
- Developing code in system Verilog
- Running simulations using Verilator
- Further understanding of instruction architecture 
- Further understanding of computer architecture
- Debugging by analysing waveforms in VCD files

**General skills gained:**
- Team management and communication
- Resource management and organisation
- Project documentation

**What could be done differently**:
- Improving coding style and consistency
- Preparing a backup method of work
- Improving time and workload management
- A more extensive use of Git and GitHub management tools
- Improving teams understanding of areas that individuals may not have worked on themselves

**Future works:**
- implementing functional data caching for our pipelined processor

# Significant Commits 

This section contains a list of significant commits throughout the course of the project, ordered chronologically.

- [Creation of the F1 program](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/dbb43e512997182a360ead34aee6bc990121a817)
- [Creation of instruction memory](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/4af36c160e1ab4bae11f28ffbcece18459a2bd22)
- [Creation of the immediate extend block](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/812876013eeaea9dd2aef3a8bca44f5848fd0665)
- [Tested F1 program](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/956671263af2290a2dff8ce16147f877d55b3b92)
- [Updated project plan](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/9a48bbea1c9104b11740623fb5b59d9b313e04b6)
- [Added trigger input to CPU](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/dc5faa550381e1ae12df13fdec0057f61473a7fa)
- [Updated project plan, idea of jump and RET muxes](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/bfd0ee20ada48287c5dbe2b8fa9affab11f050c7)
- [Identified RET error during F1 debugging](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/ae9c4cfd89584dea31bf06fa51d39f54a047c1ab)
- [Creation of data memory with byte addressing](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/d788471a35f995b33250cfeadc5d643fedc8b1b7)
- [Finished debugging of pdf reference program](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/11709fd9baffa456e57ea438e04ece1cf6e36d16)
- 11/12/2023 <- [laptop breaks down](#other-notes) 
- [Implemented LUI for CPU](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/b0327bebfb90df647ddccbed06d670968e96cab2)
- [Final tests for single cycle processor, created test and rtl folders](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/a1d91ced1c78deac3f780ced99d0a09fa51b694c)
- [Final tests for pipelined processor, created test and rtl folders](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/7db3a10abaa5d22b8ef6bf5393b67fc23715c406)

# Other Notes

My original workstation laptop became unusable 11/12/2023, this was likely due to a loose battery connection to the motherboard which caused a short circuit, disabling the laptop completely. This delayed my work slightly while I tried to find an alternative, having to set up an old desktop that I could only use while at home and send off my laptop for repairs and data recovery. While very little data had been lost as I frequently commit and push my changes to the repository, this made it difficult to work on the project while away from home. still I managed to help with the project by giving second opinions when needed by teammates and various other miscellaneous tasks such as repository organisation and write ups.