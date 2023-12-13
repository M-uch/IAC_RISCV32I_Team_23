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
    output logic RegWriteE,
    output logic [1:0] ResultSrcE,
    output logic MemWriteE,
    output logic JumpE,
    output logic BranchE,
    output logic [2:0] ALUCtrlE,
    output logic ALUSrcE,
    output logic JumpSrcE,
    output logic ATypeE,
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
    logic [2:0] ImmSrcD;
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD =  InstrD[11:7];
    assign imm_ext = InstrD[31:7];
    logic RegWriteD;
    logic [1:0] ResultSrcD;
    logic MemWriteD;
    logic JumpD;
    logic BranchD;
    logic [2:0] ALUCtrlD;
    logic ALUSrcD;
    logic JumpSrcD;
    logic ATypeD;

    CU_P CPU_CU (
        .instr(InstrD),
        .result_src(ResultSrcD),
        .mem_write(MemWriteD),
        .alu_ctrl(ALUCtrlD),
        .alu_src(ALUSrcD),
        .imm_src(ImmSrcD),
        .reg_write(RegWriteD),
        .jump_src(JumpSrcD),
        .a_type(ATypeD),
        .jump(JumpD),
        .branch(BranchD)
    );

    RegFile_P CPU_REGFile
endmodule
