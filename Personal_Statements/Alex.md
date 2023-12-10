# Alex's Personal Statement #
## Contents ##

PUT IN CONTENTS TABLE AT THE END

## My contributions: ##

### Single Cycle Processor: ###

- CU([link](put in link here))
- Top File([link](put in link here))
- PC([link](put in link here))
- Testing / Debugging([link](put in link here))

### Pipelined Processor: ###
- x([link](put in link here))
- y([link](put in link here))
- z([link](put in link here))


## The Control Unit ##

The main methodology behind my CU design was to make the '.sv' files readbable and easy to debug. This would allow my team members to quickly interpret and thus inform their own design choices when they depended upon control signals from the CU.

The component design was split into **2 seperate modules**:

1. The Main Decoder
2. The ALU Decoder

These components form design detailled in the diagram below:

![CU Design Diagram](src/CU_Design.png)

The CU has been decomposed as shown so that we can implement any instruction's appropriate ALU operations seperately from its control signals. Not only does this make the code clearer to read, but also it provides some interesting functionality, allowing us to combine R-Type and I-ALU type instructions using the same 'ALUOp' signal.

**The Main Decoder:**

Here is where the bulk of the signals are assigned, only excluding 'ALUCTRL' and 'ATYPE'. The assignment of these control signals are as follows:

| Instruction Type | RegWrite | ImmSrc | ALUSrc | MemWrite | ResultSrc | Branch | ALUOp | Jump | JumpSrc |
| :--------------: | :------: | :----: | :----: | :------: | :-------: | :----: | :---: | :--: | :-----: |
| Type_R           |          |        |        |          |           |        |       |      |         |
| Type_I           |          |        |        |          |           |        |       |      |         |
| Type_I_ALU       |          |        |        |          |           |        |       |      |         |
| Type_S           |          |        |        |          |           |        |       |      |         |
| Type_B           |          |        |        |          |           |        |       |      |         |
| Type_U           |          |        |        |          |           |        |       |      |         |
| Type_U_LUI       |          |        |        |          |           |        |       |      |         |
| Type_J_JALR      |          |        |        |          |           |        |       |      |         |
| Type_J_JAL       |          |        |        |          |           |        |       |      |         | 

This is implemented using a 'command code', which allows for quick and easy modification of control signals during the debugging process.

```

    ENTER CODE HERE WHEN DONE

```

**The ALU Decoder:**

Recieving the ALUOp signal from The Main Decoder, we can now assign the appropriate ALU operations to instructions. Due to our use of a limited set of instructions we can simply implement entire instruction types in a single line. We also combine the Type_R and Type_I_ALU instructions.

The table below details the 'ALUCtrl' and 'AType' signals based on the instruction type:

| Instruction Type | ALUCtrl | 
| :--------------: | :-----: | 
| Type_I           |         | 
| Type_S           |         | 
| Type_B           |         | 
| Type_U           |         | 
| Type_U_LUI       |         | 
| Type_J_JALR      |         | 
| Type_J_JAL       |         | 

And for the signal 'AType', we look only at I and S instructions, refering to store and load instructions:

| Instruction Type | funct3  | AType  | Instruction |
| :--------------: | :----:  | :---:  | :---------: |
| Type_I           |  100    |   1    |    lbu      |
|                  |otherwise|   0    |    lw       | 
| Type_S           |  000    |   1    |    sb       |
|                  |otherwise|   0    |    sw       | 

*Note: If AType is 1 then we use byte addressing, 0 is word addressing*    

We note that for 'Type_R' and 'Type_I_ALU' instructions, the 'ALUCtrl' signals depend on funct3 (as well as op[5] and funct7[5]):

| funct3 | op[5] : funct7[5] | ALUCtrl | ALU Instruction |
| :----: | :---------------: | :-----: | :-------------: |
|  000   |  00, 01 or 10     |   000   |  add            | 
|  000   |    11             |   001   |  sub            |
|  001   |     x             |   010   |  sll            | 
|  010   |     x             |   xxx   |  slt (unsused)  | 
|  011   |     x             |   xxx   |  sltu (unused)  | 
|  100   |     x             |   100   |  xor            | 
|  101   |     x             |   101   |  slr            | 
|  110   |     x             |   110   |  or             | 
|  111   |     x             |   111   |  and            | 

*Note: For these 2 instruction types, 'AType' does not matter.*

This has been implemented as follows:
```
    Type_RIALU: begin
        case(funct3)

            3'b000: alu_ctrl = (test == 2'b11) ? 3'b001 : 3'b000;    // if test is 11 then sub, otherwise add
            3'b001: alu_ctrl = 3'b010;                                // sll
            3'b010: alu_ctrl = 3'bxxx;                                // slt unassigned
            3'b011: alu_ctrl = 3'bxxx;                                // sltu unassigned
            3'b100: alu_ctrl = 3'b100;                                // xor
            3'b101: alu_ctrl = 3'b101;                                // slr
            3'b110: alu_ctrl = 3'b110;                                // or
            3'b111: alu_ctrl = 3'b111;                                // and

        endcase

```
**Control Signals Breakdown:**


## Appendix ##

[RISC-V ISA](src/RISC-V_ISA.png)
