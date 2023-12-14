# **Matthew's Personal Statement** #

## Statement Layout: ##

### Contributions: ##

#### *Single-Cycle CPU* ###
- [ALU](#ALU)
- [Data Memory](#DataMemory)
- [Muxes](#Muxes)
- [Register File](#RegisterFile)
- [RMAD](#RMAD)

#### *Pipelined CPU* ###
- [Hazard Detection Unit](#HazardDetectionUnit)
- [Pipeline Registers](#PipelineRegisters)
- [Execute Stage File](#ExecuteStageFile)
- [Memory Stage File](#MemoryStageFile)
- [Writeback Stage File](#WritebackStageFile)
- [Debugging](#Debugging)

### [Mistakes](#Mistakes) ###

### [What I've learnt](#Learnt) ###

### [If I Did It Again](#Improvements) ###

#

<div id="ALU">

## ALU  ##
Construction of [ALU.sv](https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Legacy%20Components/RMAD/ALU.sv) was the first thing that I set out to do in this project. In theory it was simple, to use a select signal to decide the operation to be done on the two input signals.<br /> 
Here is a table of the select signal (ALUCtrl) and the corresponding operation it would perform:

|  ALUCtrl  | Operation | 
|:---------:|:---------:| 
| 000       | Add       | 
| 001       | Sub       | 
| 111       | And       | 
| 110       | Or        | 
| 100       | Xor       | 
| 010       | Sll       | 
| 101       | Slr       |

I tested my ALU using [ALU_tb.cpp](ADDLINK). In this testbench, it assigned input values for the ALU and then ran through a loop to test each operation. To show what the outputted values were, I used gtkwave to display the output value at each clock cycle. I repeated this multiple times with varying input values.
<br />Due to a conceptual misunderstanding, I implemented the Zero signal incorrectly and I used multiple if statements instead of a much neater case statement. More on this in the [mistakes](#Mistakes) section.

<div id="DataMemory">

## Data Memory ##
My implementation of the data memory was to make it a simple RAM file. I tested this RAM file using [DataMemory_tb.cpp](ADDLINK) and repeated the same method I used when testing the ALU. <br />When the team was attempting to implement the single-cycle CPU, we found that the data memory was missing byte addressing and so Raymond added to it. See more in the [mistakes](#Mistakes) section.

<div id="Muxes">

## Muxes ##
I created [Mux.sv](#INCLUDELINK) (two input mux) and [Mux3.sv](#INCLUDELINK) (three input mux). These muxes were used in the RMAD module and later used in [Execute_stage.sv](#INCLUDELINK), [Memory_stage.sv](#INCLUDELINK) and [Writeback_stage.sv](#INCLUDELINK).<br />
Testing of these two mux modules was done with [Mux_tb.cpp](#INCLUDELINK) and [Mux3_tb.cpp](#INCLUDELINK). Tests were repeated with different values to test consistency.

<div id="RegisterFile">

## Register File ##
This RAM file stores the value of a register using its address and outputs the values through to the execution stage (or just the ALU and a mux for the single-cycle CPU). I tested the register with [RegFile_tb.cpp](ADDLINK).

<div id="RMAD">

## RMAD ##
The RMAD module is a top file module for the regfile, muxes, ALU and data memory that I created. The point of this file was to make it easier for Alex to write the top module for the single-cycle CPU by reducing the number of connections he needed to deal with. The RMAD module got scrapped when we began the pipelining stage because the CPU got split into stages that the RMAD module was not able to incorporate. Although it wasn't used in the pipelined CPU, it was still of use in the single-cycle CPU.
Testing the RMAD module was not done as rigorously as some of my other modules due to the large number of inputs, but some testing was done using [RMAD_tb.cpp](#INCLUDELINK).

<div id="HazardDetectionUnit">

## Hazard Detection Unit ##
The CPU was split into 5 stages (Fetch, Decode, Execute, Memory and Writeback) and by doing this we introduced the CPU to hazards. The hazard unit is responsible for solving these problems. <br />The hazards that needed to be solved and a description of them are:
- Raw data hazard. This hazard is caused when a register that is still inside the CPU is being used again by a later instruction. To solve this, the new value of the register needs to be fed back into the execute stage of the CPU to replace the old value that is currently being used by the later instruction. This is called forwarding.
- Load data hazard. This hazard is similar to raw data hazard except the register that is still inside the CPU is being loaded onto a memory address (result of a load instruction). This means that the new value of the register can't be used until the instruction is fully completed. Stalling is used to solve this. Stalling is when the PC is paused so that the load instruction can finish its cycle before the next instruction is ran.
- Control hazard. When jumping or branching, the following instructions in the PC are not wanted to be processed but because it takes multiple cycles to process the jump/branch, new unwanted instructions are processed in the CPU. Flushing is used to solve this. Flushing is done by reseting all the values in the first two pipeline registers so that no registers are modified whilst waiting to jump/branch. The reason this works is because the ALU will end up adding 0 plus 0 to register 0 (the register that is always 0).

The code of the Hazard Unit was split into three sections, one for each hazard type.<br />

For forwarding, this is the relevant code:

```
    if ((Rs1E == RdM) && (RegWriteM) && (Rs1E!=0))          ForwardAE = 2;
    else if ((Rs1E == RdW) && (RegWriteW) && (Rs1E!=0))     ForwardAE = 1;
    else                                                    ForwardAE = 0;

    if ((Rs2E == RdM) && (RegWriteM) && (Rs2E!=0))          ForwardBE = 2;
    else if ((Rs2E == RdW) && (RegWriteW) && (Rs2E!=0))     ForwardBE = 1;
    else                                                    ForwardBE = 0;
```
This section of code compares the registers that are being used in the execute phase to the registers that will be written to in the memory and writeback stage (with memory stage taking prioity as this stage holds a newer value of the register). Once it checks if forwarding from the memory or writeback stage is required, it uses ForwardAE and ForwardBE to control three input muxes in the execute phase. These three input muxes decide which register values is inputted into the ALU. Forwarding cannot happen if the register value is 0 as this is the zero register (a constant register).

For stalling, this is the relevant code:

```
    lwStall = ResultSrcE & ((Rs1D == RdE) | (Rs2D == RdE));
    StallD = lwStall;
    StallF = lwStall;
```
If the 0th bit of ResultSrcE is 1, it means that the instruction in the execute stage is a load instruction. If a load instruction is being run, it checks if one of the registers in the decode stage is a register that will be changed as a result of the load instruction, if so then stalling is triggered.

For flushing (and stalling), this is the relevant code:

```
    FlushD = PCSrcE;
    FlushE = lwStall | PCSrcE;
```
PCSrcE determines if a jump or a branch instruction is taking place, if it's high then flushing is required to not process unwanted instructions. FlushE (flush execute stage) can also be triggered if there is a stall. This is because stalling holds the values in the fetch and decode stage but it doesn't prevent the values in the decode stage from being pushed into the execute stage, this is why the execute stage needs to be flushed. Additionally, stalling the execute stage would not work as we don't want the CPU to process the same load instruction again.

[HazardUnit_tb.cpp](ADDLINK) and gtkwave was used to test the Hazard Unit.

<div id="PipelineRegisters">

## Pipeline Registers ##
Between each of the pipeline stages, four pipeline registers were installed so that the CPU could process multiple instructions at once. These registers were made compatible with the hazard unit to solve problems caused by data hazard and control hazard. Without the addition of the hazard unit, these pipeline registers are simple d-type registers that push the inputs to the output on every clock rising edge. The additions made to the registers to account for hazard handling is listed below:

- Fetch To Decode: An enable was added so the register can be stalled and a clear was added so the register can be flushed.
- Decode To Execute: A clear was added for when a flush was enabled.
- Execute to Memory: No changes required.
- Memory to Writeback: No changed required.

<div id="ExecuteStageFile">

## Execute Stage File ##
This stage file (like the other stage files) was created to simplify the top file and help debug issues. In this stage file, everything in the execute stage was written into it including the ExecuteToMemory pipeline register.

<div id="MemoryStageFile">

## Memory Stage File ##
This stage file serves the same function as the Execute stage file but with the exception of containing the Memory stage components and MemoryToWriteback register.

<div id="WritebackStageFile">

## Writeback Stage File ##
This stage file serves the same function as the Execute stage file but with the exception of containing the Writeback stage components.

<div id="Debugging">

## Debugging ##
When the construction of the pipelined-CPU was complete, debugging issues was essential. Alex and I worked together on this as we had both made/contributed to the stage and top files. At first it was mostly syntax and compiler errors that arose but because of the error list provided by the compiler, these were easy to fix. <br />
Once the compiler was able to run without any errors, the CPU still didn't work. When we ran the f1 program, VBuddy would momentarily display a 1 on the TFT display before going back to 0. After using VCD waveform viewer, we found that the FetchToDecode register was clearing all output values once A0 (the displayed register) turned to 0. This was weird because the clear input was never going high. After some thought and testing, I realised that the clear signal was being controlled by signals that were synchronous with the clock, meaning the clear signals were also synchonous with the clock. This is important because the pipeline registers were written to have an asynchrnous clear. Once I changed the FetchToDecode and DecodeToFetch files to be synchronous, the f1 program began running properly. We also tested the PDF programs which also ran without error.

<div id="Mistakes">

## Mistakes ##
When I created the Pipeline-Processor branch on the git repository, I accidentaly cloned all the files on the main branch over to the new branch. This was not a major issue as we only needed to delete the cloned files but it was annoying because the branch already had many commits from the main branch.(The first commit on the Pipeline-Processor branch was "Commit Hazard Unit"). <br />
When creating the pipeline registers, I made the registers with an asynchronous clear signal which became a problem when testing the pipelined-CPU. This was a very easy fix as all I had to do was make the registers synchronous.<br />
When I made the ALU, I coded the zero signal incorrectly. When Alex and Raymond began debugging the single-cycle CPU, they found that the zero signal was not outputting what it was meant to output. Alex fixed the ALU by making the zero signal go high whenever ALUResult was zero. He also shortened it by using a case statement as opposed to multiple if statements.<br />
When I created the Data memory, I hadn't include byte addressing, this became a problem when testing the PDF programs. Raymond added everything that was missing to the Data Memory file, this included a data memory to load to and little endian storage.

<div id="Learnt">

## What I've learnt ##
I have learnt how to use GitHub beyond simply cloning repositories as I can now create branches, create a github repo (I'm not the one who made the teams repo but I still learnt how to via observational learning) and how to push and pull commits. My knowledge and skills in using RISV and System Verilog has become more in-depth.

<div id="Improvements">

## If I Did It Again ##
If I did it again, I would've made sure to attempt to fix all my mistakes myself. When the ALU and Data Memory mistakes were found, I had moved onto the pipeline stage whilst Alex and Raymond were debugging the CPU which left it to them to fix it. <br />
With my new skills using github, I would take more advantage of branching because it was very useful when seperating folders. <br />
Completing the data memory cache challenge would've been desirable but due to a time constraint, we weren't able to complete it.