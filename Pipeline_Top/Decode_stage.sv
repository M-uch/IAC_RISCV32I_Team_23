module Decode_stage #(
    parameter D_WIDTH = 32,
    parameter A_WIDTH = 5
) (
    input logic clk,
    input logic FlushE,
    input logic WE3,
    input logic [D_WIDTH-1:0] InstrD,
    input logic [D_WIDTH-1:0] PCD,
    input logic [D_WIDTH-1:0] PCplus4D,
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
    output logic [D_WIDTH-1:0] a0

);

    // assign / declare vals
    logic [2:0] ImmSrcD;
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
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(A3),
        .WD3(WD3),
        .WE3(WE3),
        .trigger(trigger),

        .RD1(Rd1),
        .RD2(Rd2),
        .ra(Ra),
        .a0(a0)
    );

    signextend CPU_SIGNEXTEND (
        .code(InstrD),
        .immscr(ImmSrcD),
        .immop(ImmExtD)
    );

    DecodeToExecute D2E (
        .CLK(clk),              // I/Ps
        .CLR(FlushE),
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUSrcD(ALUSrcD),
        .JumpSrcD(JumpSrcD),
        .ATypeD(ATypeD),
        .ResultSrcD(ResultSrcD),
        .ALUControlD(ALUCtrlD),
        .Rs1D(InstrD[19:15]),
        .Rs2D(InstrD[24:20]),
        .RdD(InstrD[11:7]),
        .RD1D(Rd1),
        .RD2D(Rd2),
        .Ra(Ra),
        .PCD(PCD),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCplus4D),

        .RegWriteE(RegWriteE),           // O/Ps
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .JumpSrcE(JumpSrcE),
        .ATypeE(ATypeE),
        .ResultSrcE(ResultSrcE),
        .ALUControlE(ALUCtrlE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .RaE(RAE),
        .PCE(PCE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCplus4E)
    );


endmodule
