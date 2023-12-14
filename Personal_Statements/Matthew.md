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
Construction of [ALU.sv](#https://github.com/M-uch/IAC_RISCV32I_Team_23/blob/main/Legacy%20Components/RMAD/ALU.sv) was the first thing that I set out to do in this project. In theory it was simple, to use a select signal to decide the operation to be done on the two input signals.<br /> 
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

<div id="RMAD">

## RMAD ##
The RMAD module is a top file module for the regfile, muxes, ALU and data memory that I created. The point of this file was to make it easier for Alex to write the top module for the single-cycle CPU by reducing the number of connections he needed to deal with. The RMAD module got scrapped when we began the pipelining stage because the CPU got split into stages that the RMAD module was not able to incorporate. Although it wasn't used in the pipelined CPU, it was still of use in the single-cycle CPU.
Testing the RMAD module was not done as rigorously as some of my other modules due to the large number of inputs, but some testing was done using [RMAD_tb.cpp](#INCLUDE LINK).

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
This section of code compares the registers that are being used in the execute phase to the registers that will be written to in the memory and writeback stage (with memory stage taking prioity as this stage holds a newer value of the register). Once it checks if forwarding from the memory or writeback stage is required, it uses ForwardAE and ForwardBE to control a three input mux in the execute phase. This three input mux decides which register values is inputted into the ALU. Forwarding cannot happen if the register value is 0 as this is the zero register.

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
Between each of the pipeline stages, four pipeline registers were installed so that the CPU could process multiple instructions at once. These registers were made compatible with the hazard unit to solve problems caused by data hazard and control hazard. In each bullet point, I explain how every register was incorporated with the hazard unit:

- Fetch To Decode:
- Decode To Execute: a reset was added for when a flush was enabled.
- Execute to Memory: No changes required.
- Memory to Writeback: No changed required.

<div id="ExecuteStageFile">

## Execute Stage File ##

<div id="MemoryStageFile">

## Memory Stage File ##

<div id="WritebackStageFile">

## Writeback Stage File ##

<div id="Debugging">

## Debugging ##
This entailed fixing errors

<div id="Mistakes">

## Mistakes ##

<div id="Learnt">

## What I've learnt ##

<div id="Improvements">

## If I Did It Again ##

