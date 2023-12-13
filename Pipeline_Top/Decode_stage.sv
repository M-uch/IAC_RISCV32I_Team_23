module Decode_stage #(
    parameter D_WIDTH = 32,
    parameter A_WIDTH = 5
) (
    input logic clk,
    input logic FlushE,
    input logic WE3,
    input logic [D_WIDTH-1:0] InstrD,
    input logic [D_WIDTH-1:0] PCD,
    input logic [D_WIDTH-1:0] PCplus4D_i,
    input logic [A_WIDTH-1:0] A3,
    input logic [D_WIDTH-1:0] WD3,
    input logic               trigger,
    output logic RegWriteE,
    output logic [1:0] ResultSrcE,
    output logic MemWriteE,
    output logic JumpE,
    output logic BranchE,
    output logic [2:0] ALUCtrlE,
    output logic ALUSrcE,
    output logic JumpSrcE,
    output logic ATypeE,
    output logic [D_WIDTH-1:0] RD1E,
    output logic [D_WIDTH-1:0] RD2E,
    output logic [D_WIDTH-1:0] RAE,
    output logic [D_WIDTH-1:0] ImmExtE,
    output logic [D_WIDTH-1:0] PCE,
    output logic [A_WIDTH-1:0] Rs1E,
    output logic [A_WIDTH-1:0] Rs2E,
    output logic [A_WIDTH-1:0] RdE,
    output logic [D_WIDTH-1:0] PCplus4E,
    output logic [D_WIDTH-1:0] A0

);

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

    logic [D_WIDTH-1:0] Rd1;
    logic [D_WIDTH-1:0] Rd2;
    logic [D_WIDTH-1:0] Ra;
    logic [D_WIDTH-1:0] ImmExtD;

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

    RegFile_P CPU_REGFile (
        .clk(clk),              // I/Ps
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .WE3(WE3),
        .trigger(trigger),

        .RD1(Rd1),
        .RD2(Rd2),
        .ra(Ra),
        .a0(A0)
    );

    DecodeToExecute D2E (
        
    );
endmodule
