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

## ALU  [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/1cdfe83262b019dd869af057e12a288df94841f4)
Construction of the ALU was the first thing that I set out to do in this project. In theory it was simple, to use a select signal to decide the operation to be done on the two input signals.<br /> 
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

The LUI operation was added by Raymond and Alex later in the project.
To test the ALU, [ALU_tb.cpp](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/a9a83fff95a73f4615dde3c13ca1bdeaa4766044) was used. In this testbench, it assigned input values for the ALU and then ran through a loop to test each operation. Gtkwave was used to display the output value at each clock cycle. Further testing consisted of repeating this multiple times with varying input values.
<br />Due to a conceptual misunderstanding, I implemented the Zero signal incorrectly and I used multiple if statements instead of a much neater single case statement. More on this in the [mistakes](#Mistakes) section.

<div id="DataMemory">

## Data Memory [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/1cdfe83262b019dd869af057e12a288df94841f4)
My implementation of the data memory was to make it a simple RAM file. To test this RAM file, [DataMemory_tb.cpp](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/a9a83fff95a73f4615dde3c13ca1bdeaa4766044) was used and the same method when testing the ALU was used again. <br />When the team was attempting to implement the single-cycle CPU, we found that the data memory was missing byte addressing and so Raymond added to it. See more in the [mistakes](#Mistakes) section.

<div id="Muxes">

## Muxes [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/1cdfe83262b019dd869af057e12a288df94841f4) [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/8018840c8f7548d7363d36f683ed1ffb08be146d)
There are two relevant mux modules: Mux (two input mux) and Mux3 (three input mux). These muxes were used in the RMAD module and later used in [Execute Stage File](#ExecuteStageFile), [Memory Stage File](#MemoryStageFile) and [Writeback Stage File](#WritebackStageFile).<br />
Testing of these two mux modules was done with [Mux_tb.cpp](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/a9a83fff95a73f4615dde3c13ca1bdeaa4766044) and [Mux3_tb.cpp](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/a9a83fff95a73f4615dde3c13ca1bdeaa4766044). Tests were repeated with different values to test consistency.

<div id="RegisterFile">

## Register File [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/1cdfe83262b019dd869af057e12a288df94841f4)
This register may be referred to as RegFile. This RAM file writes to a single register and reads from two registers at a time. It outputs the read values towards the execute stage (or just the ALU and a mux in the single-cycle CPU). To test the register, [RegFile_tb.cpp](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/e63b1686499fbe658864e5b10ff9ddec50735b4a) was used. The testbench that was first commited had incorrect inputs that I accidentally added, hence why the commit is an error fix. As the project progressed, the team realised that we needed an a0 output, ra output, trigger input and another condition in the if statement that prevented the zero register from changing. The trigger and a0 were added by Raymond ([added t0 direct access to regfile and a0](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/dc5faa550381e1ae12df13fdec0057f61473a7fa)), ra was added by me ([Added ra and return mux](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/dec7dde3efe5caa388fb73671f319b11fdae7117)) and the condition to keep the zero register constant was added by Alex ([debugging - jumpsrc = 0 for branches, added condition for uncondition…](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/5826b2e81b71bdd3603836ff5a5d3e3d64f72e6c)).

<div id="RMAD">

## RMAD [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/1cdfe83262b019dd869af057e12a288df94841f4)
The RMAD module is a top file module for the regfile, muxes, ALU and data memory. The point of this file was to make it easier for Alex to write the top module for the single-cycle CPU by reducing the number of connections he needed to deal with. The RMAD module got scrapped when we began the pipelining stage because it was spread across multiple pipeling stages and so was not worth the effort of including it in the top file. Although it wasn't used in the pipelined CPU, it was still of use in the single-cycle CPU.
Testing the RMAD module was not done as rigorously as some of the other modules due to the larger number of inputs, but some testing was done using [RMAD_tb.cpp](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/65b7d4d855dc4af01b430ae197592c502140f43f). As new components and signals were being created, RMAD got changed frequently. A commit with one of these changes: ([Added ra and return mux](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/dec7dde3efe5caa388fb73671f319b11fdae7117)).

<div id="HazardDetectionUnit">

## Hazard Detection Unit [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/e1388c9698eadfbd5aa9c9ee080bccdbd89d3ff4)
The CPU was split into 5 stages (Fetch, Decode, Execute, Memory and Writeback) and by doing this we introduced the CPU to hazards. The hazard unit is responsible for solving these problems. <br />The hazards that needed to be solved and a description of them are:
- Raw data hazard. This hazard is caused when a register that is still inside the CPU is being used again by a later instruction. To solve this, the new value of the register needs to be fed back into the execute stage of the CPU to replace the old value that is currently being used by the later instruction. This is called forwarding.
- Load data hazard. This hazard is similar to raw data hazard except the register that is still inside the CPU is being loaded onto a memory address (result of a load instruction). This means that the new value of the register can't be used until the instruction is fully completed. Stalling is used to solve this. Stalling is when the PC is paused so that the load instruction can finish its cycle before the next instruction is ran.
- Control hazard. When jumping or branching, the following instructions in the PC are not wanted to be processed but because it takes multiple cycles to process the jump/branch, new unwanted instructions are processed in the CPU. Flushing is used to solve this. Flushing is done by reseting all the values in the first two pipeline registers so that no registers are modified whilst waiting to jump/branch.

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
This section of code compares the registers that are being used in the execute phase to the registers that will be written to in the memory and writeback stage (with memory stage taking prioity as this stage holds a newer value of the register). Once it checks if forwarding from the memory or writeback stage is required, it uses ForwardAE and ForwardBE to control three input muxes in the execute phase. These three input muxes decide which register values will be inputted into the ALU. Forwarding cannot happen if the register value is 0 as this is the zero register (a constant register).

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
PCSrcE determines if a jump or a branch instruction is taking place, if it's high then flushing is required to not process unwanted instructions. FlushE can also be triggered if there is a stall. Stalling holds the values in the fetch and decode stage but it doesn't prevent the values in the decode stage from being pushed into the execute stage, this is why the execute stage needs to be flushed on a stall. Additionally, stalling the execute stage would not work as we don't want the CPU to process the same load instruction again.

[HazardUnit_tb.cpp](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/3171f691dbc2570c4856ece37c2fb3a3a89db23e) was used to test the Hazard Unit.

<div id="PipelineRegisters">

## Pipeline Registers [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/861bf4e906655ee4075c6343a6e7eac0e45373ab)
Between each of the pipeline stages, four pipeline registers were installed so that the CPU could process multiple instructions at once. These registers were made compatible with the hazard unit to solve problems caused by data hazard and control hazard. Without the addition of the hazard unit, these pipeline registers are simple d-type registers that push the inputs to the output on every clock rising edge. The additions made to the registers to account for hazard handling is listed below:

- Fetch To Decode: An enable was added so the register can be stalled and a clear was added so the register can be flushed.
- Decode To Execute: A clear was added for when a flush was enabled.
- Execute to Memory: No changes required.
- Memory to Writeback: No changed required.

All the testbenches that were used to test these pipelines are all on this [commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/3171f691dbc2570c4856ece37c2fb3a3a89db23e).

<div id="ExecuteStageFile">

## Execute Stage File [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/dd7c29dd4a231a0fb5f6df8a1a92be81047aa0e5)
This stage file (like the other stage files) was created to simplify the top file and help debug issues. The execute stage is responsible for selecting the immediate or register value, calculating the new value of the Rd register, calculating the target PC value and this section is also where forwarding takes place. Modules included in this file are: ALU, adder, two input mux, 2 three input muxes and the ExecuteToMemory pipeline register. No testbench was made for the stage files as we went straight to debugging the whole CPU once we completed the stages and top.

<div id="MemoryStageFile">

## Memory Stage File [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/c3cbb31a5ead8233989c6e73732a5ee10b9ad78f)
The two components in this stage are the data memory and MemoryToWriteback pipeline register. The function of this stage is to write to memory and load from memory.

<div id="WritebackStageFile">

## Writeback Stage File [.sv Commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/c3cbb31a5ead8233989c6e73732a5ee10b9ad78f)
The single component in this stage is a three input mux which decides if the output is from an arithmetic instruction, memory instruction or a JAL instruction.

<div id="Debugging">

## Debugging ##
When the construction of the pipelined-CPU was complete, debugging issues was essential. Alex and I worked together on this as we had both made/contributed to the stage and top files. At first it was mostly syntax and compiler errors that arose but because of the error list provided by the compiler, these were easy to fix. <br />
([Debugged compiler errors](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/9a4c481c2d15a0f8e117c68b240d5eb9b725780d)), ([Debug syntax errors [1]](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/7b8bcd04fa21b1195b48ccd3e87060afc779dd47)), ([Debug syntax errors [2]](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/d340c4de8b7edb338d536a3c16bf0c2865172a67)), ([Debug errors](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/8d02c447d74046146307dd38d6be4d1b8c914043)) and ([Corrected ResultSrcE bit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/bb74176784d0818c0e64804ad39df3364a499d8a))

Once the compiler was able to run without any errors, the CPU still didn't work. After some testing we found that the FetchToDecode register was clearing all output values. This was weird because the clear input was never going high. After some thought and more testing, we realised that the signals controlling the clear signal were synchronous with the clock, meaning the clear signals were also synchonous with the clock. This is important because the pipeline registers were written to have an asynchronous clear. Once I changed the FetchToDecode and DecodeToFetch files to be synchronous ([Made pipeline registers synchronous](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/2bf3858d684ddf9d46bc735aced070268439a855)), the f1 program began running properly. We also tested the PDF programs which also ran without error.

<div id="Mistakes">

## Mistakes ##
When I created the Pipeline-Processor branch on the git repository, I accidentally cloned all the files on the main branch over to the new branch. This was not a major issue as we only needed to delete the cloned files but it was annoying because the branch already had many commits to it.(The first commit on the Pipeline-Processor branch was ([Commit Hazard Unit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/e1388c9698eadfbd5aa9c9ee080bccdbd89d3ff4))). <br />
When creating the pipeline registers, I made the registers with an asynchronous clear signal which became a problem when testing the pipelined-CPU.<br />
When I made the ALU, I coded the zero signal incorrectly. When Alex and Raymond began debugging the single-cycle CPU, they found that the zero signal was not outputting what it was meant to output. Alex fixed the ALU by making the zero signal go high whenever ALUResult was zero (as I should have done at the beginning). He also shortened it by using a single case statement as opposed to multiple if statements. Here is Alex's [commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/53c47d8b04ee0b69a6d64a546f77094fc5240d94).<br />
When I created the Data memory, I hadn't include byte addressing, this became a problem when testing the PDF programs. Raymond added everything that was missing to the Data Memory file, this included little endian storage. Here is Raymond's [commit](https://github.com/M-uch/IAC_RISCV32I_Team_23/commit/d788471a35f995b33250cfeadc5d643fedc8b1b7).

<div id="Learnt">

## What I've learnt ##
I have learnt how to use GitHub beyond simply cloning repositories as I can now create branches and can push and pull commits. My knowledge and skills in using RISV and System Verilog has also become more in-depth.

<div id="Improvements">

## If I Did It Again ##
When the ALU and Data Memory mistakes were found, I had moved onto the pipeline stage whilst Alex and Raymond were debugging the single-cycle CPU and so they fixed my errors themselves. If I did it again, I would make sure to fix my own mistakes or at least attempt to. This would be to make sure that I'm not a liability to my teammates and have a chance to learn from my mistakes. <br />
We used _i and _o in the stage files to represent signals that needed to be inputted and outputted, we also used lettering to show which stage a signal was in but these two naming techniques often got mixed up and although I believe that communication with most of the team went well, if I did this project again I would make sure that the team sticks to the same naming conventions. This was because connecting wires with different naming conventions was annoying to deal with and resulted in many errors.<br />
With my new skills using github, I would take more advantage of branching as it was very useful for keeping the repository neat. I would also like to be the repo master to deepen my technical understanding of github and to take on more responsibility for the team.<br />
Completing the data memory cache challenge would've been desirable but due to a time constraint, we weren't able to complete it.