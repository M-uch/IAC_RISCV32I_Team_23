module RMAD #(
    parameter   ADDRESS_WIDTH = 5,
                DATA_WIDTH = 32
)(
    input   logic                       clk,                    // REG input and DataMemory input
    input   logic [ADDRESS_WIDTH-1:0]   A1,                     // REG input
    input   logic [ADDRESS_WIDTH-1:0]   A2,                     // REG input
    input   logic [ADDRESS_WIDTH-1:0]   A3,                     // REG input
    input   logic                       RegWrite,               // REG input
    input   logic                       trigger,                // REG input
    input   logic [DATA_WIDTH-1:0]      ImmExt,                 // first MUX input
    input   logic                       ALUSrc,                 // first MUX input
    input   logic                       MemWrite,               // DataMemory input
    input   logic [1:0]                 ResultSrc,              // Three input MUX input
    input   logic [DATA_WIDTH-1:0]      PCPlus4,                // Mux3 input
    input   logic                       JumpSrc,                // second MUX input
    input   logic [DATA_WIDTH-1:0]      PCtargetIn,             // second MUX input
    input   logic [2:0]                 ALUControl,             // ALU input
    output  logic                       Zero,                   // ALU output
    output  logic [DATA_WIDTH-1:0]      a0,                     // REG output
    output  logic [DATA_WIDTH-1:0]      PCtargetOut             // second MUX output

);

    logic   [DATA_WIDTH-1:0]              SrcA;           // interconnect wire from RD1 to ALU
    logic   [DATA_WIDTH-1:0]              RD2;            // interconnect wire from RD2 to 1st MUX and DataMemory
    logic   [DATA_WIDTH-1:0]              SrcB;           // interconnect wire from 1st MUX to ALU
    logic   [DATA_WIDTH-1:0]              ALUResult;      // interconnect wire from ALU to DataMemory and three input MUX
    logic   [DATA_WIDTH-1:0]              ReadData;       // interconnect wire from DataMemory to three input MUX
    logic   [DATA_WIDTH-1:0]              Result;         // interconnect wire from three input MUX to WD3
    logic   [DATA_WIDTH-1:0]              ra;             // interconnect wire from ra to second MUX



RegFile Register (
    .clk        (clk),
    .A1         (A1),
    .A2         (A2),
    .A3         (A3),
    .WD3        (Result),
    .WE3        (RegWrite),
    .RD1        (SrcA),
    .RD2        (RD2),
    .trigger    (trigger),
    .a0         (a0),
    .ra         (ra)
);

Mux FirstMux (
    .in0        (RD2),
    .in1        (ImmExt),
    .select     (ALUSrc),
    .out        (SrcB)
);

ALU Arithmetic_logic_unit (
    .ALUop1     (SrcA),
    .ALUop2     (SrcB),
    .ALUctrl    (ALUControl),
    .ALUout     (ALUResult),
    .Zero       (Zero)
);

DataMemory DataMem (
    .clk        (clk),
    .WE         (MemWrite),
    .A          (ALUResult),
    .WD         (RD2),
    .RD         (ReadData)
);

Mux3 ThreeInputMux (
    .in0        (ALUResult),
    .in1        (ReadData),
    .in2        (PCPlus4),
    .select     (ResultSrc),
    .out        (Result)
);

Mux SecondMux (
    .in0        (PCtargetIn),
    .in1        (ra),
    .select     (JumpSrc),
    .out        (PCtargetOut)
);

endmodule
