module RMA #(
    parameter   ADDRESS_WIDTH = 5,
                DATA_WIDTH = 32
)(
    input   logic                       clk,                // REG input
    input   logic [ADDRESS_WIDTH-1:0]   rs1,                // REG input
    input   logic [ADDRESS_WIDTH-1:0]   rs2,                // REG input
    input   logic [ADDRESS_WIDTH-1:0]   rd,                 // REG input
    input   logic                       RegWrite,           // REG input
    input   logic [DATA_WIDTH-1:0]      ImmOp,              // MUX input
    input   logic                       ALUsrc,             // MUX input
    input   logic [2:0]                 ALUctrl,            // ALU input
    output  logic                       eq,                 // ALU output
    output  logic [DATA_WIDTH-1:0]      a0                  // REG output
);

    logic   [DATA_WIDTH-1:0]              ALUop1;           // interconnect wire from RD1 to ALU
    logic   [DATA_WIDTH-1:0]              regop2;           // interconnect wire from RD2 to MUX
    logic   [DATA_WIDTH-1:0]              ALUop2;           // interconnect wire from MUX to ALU
    logic   [DATA_WIDTH-1:0]              ALUout;           // interconnect wire from ALU to WD3

RegFile Register (
    .clk        (clk),
    .AD1        (rs1),
    .AD2        (rs2),
    .AD3        (rd),
    .WD3        (ALUout),
    .WE3        (RegWrite),
    .a0         (a0),
    .RD1        (ALUop1),
    .RD2        (regop2)
);

ALU_Mux Mux2 (
    .ImmOp      (ImmOp),
    .RD2        (regop2),
    .ALUsrc     (ALUsrc),
    .ALUop2     (ALUop2)
);

ALU Arithmetic_logic_unit (
    .ALUop1     (ALUop1),
    .ALUop2     (ALUop2),
    .ALUctrl    (ALUctrl),
    .ALUout     (ALUout),
    .eq         (eq)
);

endmodule
