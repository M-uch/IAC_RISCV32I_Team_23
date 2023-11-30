module RMAD #(
    parameter   ADDRESS_WIDTH = 5,
                DATA_WIDTH = 32
)(
    input   logic                       clk,                    // REG input and DataMemory input
    input   logic [ADDRESS_WIDTH-1:0]   A1,                     // REG input
    input   logic [ADDRESS_WIDTH-1:0]   A2,                     // REG input
    input   logic [ADDRESS_WIDTH-1:0]   A3,                     // REG input
    input   logic                       RegWrite,               // REG input
    input   logic [DATA_WIDTH-1:0]      ImmExt,                 // first MUX input
    input   logic                       ALUSrc,                 // first MUX input
    input   logic                       clk,                    // DataMemory input
    input   logic                       MemWrite,               // DataMemory input
    input   logic                       ResultSrc,              // second MUX input
    input   logic [2:0]                 ALUControl,             // ALU input
    output  logic                       Zero,                   // ALU output
);

    logic   [DATA_WIDTH-1:0]              SrcA;           // interconnect wire from RD1 to ALU
    logic   [DATA_WIDTH-1:0]              RD2;            // interconnect wire from RD2 to 1st MUX and DataMemory
    logic   [DATA_WIDTH-1:0]              SrcB;           // interconnect wire from 1st MUX to ALU
    logic   [DATA_WIDTH-1:0]              ALUResult;      // interconnect wire from ALU to DataMemory and 2nd MUX
    logic   [DATA_WIDTH-1:0]              ReadData;       // interconnect wire from DataMemory to 2nd MUX
    logic   [DATA_WIDTH-1:0]              Result;         // interconnect wire from 2nd MUX to DataMemory


RegFile Register (
    .clk        (clk),
    .A1         (A1),
    .A2         (A2),
    .A3         (A3),
    .WD3        (Result),
    .WE3        (RegWrite),
    .RD1        (SrcA),
    .RD2        (RD2)
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

Mux SecondMux (
    .in0        (ALUResult),
    .in1        (ReadData),
    .select     (ResultSrc),
    .out        (Result)
);

endmodule
