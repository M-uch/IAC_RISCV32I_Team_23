module Decode_stage #(
    parameter D_WIDTH = 32,
    parameter A_WIDTH = 5
) (
    input logic clk,
    input logic FlushE,
    input logic WE3,
    input logic [D_WIDTH-1:0] InstrD,
    input logic [D_WIDTH-1:0] PCD_i,
    input logic [D_WIDTH-1:0] PCplus4D_i,
    input logic [A_WIDTH-1:0] A3,
    input logic [D_WIDTH-1:0] WD3,
    output logic RegWriteD,
    output logic [1:0] ResultSrcD,
    output logic MemWriteD,
    output logic JumpD,
    output logic BranchD,
    output logic [2:0] ALUCtrlD,
    output logic ALUSrcD,
    output logic JumpSrcD,
    output logic ATypeD,
    output logic [D_WIDTH-1:0] RD1,
    output logic [D_WIDTH-1:0] RD2,
    output logic [D_WIDTH-1:0] RA,
    output logic [D_WIDTH-1:0] ImmExtD,
    output logic [D_WIDTH-1:0] PCD_o,
    output logic [A_WIDTH-1:0] Rs1D,
    output logic [A_WIDTH-1:0] Rs2D,
    output logic [A_WIDTH-1:0] RdD,
    output logic [D_WIDTH-1:0] PCplus4D_o,
    output logic [D_WIDTH-1:0] A0

);

    // Connect follow through wires
    assign PCD_o = PCD_i;    
    assign PCplus4D_i = PCplus4D_o;

    // assign / declare vals
    logic [A_WIDTH-1:0] A1 = InstrD[19:15];
    logic [A_WIDTH-1:0] A2 = InstrD[24:20];
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD =  InstrD[11:7];
    assign imm_ext = InstrD[31:7];


endmodule
