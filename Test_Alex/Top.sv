module Top #(
    parameter WIDTH = 32
) (
    input  logic                       clk,        // CPU clock
    input  logic                       rst,        // reset
    input  logic                       T0,         // trigger
    output logic     [WIDTH-1:0]       A0          // O/P Register
);

    // CONTROL SIGNALS
    logic                   PCSRC;
    logic   [1:0]           RESULTSRC;
    logic                   MEMWRITE;
    logic   [2:0]           ALUCTRL;
    logic                   ALUSRC;
    logic   [2:0]           IMMSRC;
    logic                   REGWRITE;
    logic                   JUMPSRC;


    // INTER SIGNALS
    logic   [WIDTH-1:0]     PC_OUT;              // Address of instruction memory
    logic   [WIDTH-1:0]     PCPLUS4;             // Current PC Address + 4
    logic   [WIDTH-1:0]     PCTARGET_TO_RMAD;    // PC Target (PC -> RMAD)
    logic   [WIDTH-1:0]     PCTARGET_TO_PC;      // PC Target (RMAD -> PC)
    logic   [WIDTH-1:0]     IMMOP;               // O/P of sign extend block
    logic   [WIDTH-1:0]     INSTRUCT;            // current cycle instruction
    logic                   EQ;


    PC CPU_PC (
        .clk(clk),
        .rst(rst),
        .PC_TargetI(PCTARGET_TO_PC),
        .PCsrc(PCSRC),
        .ImmOp(IMMOP),
        .PC_out(PC_OUT),
        .PC_Plus4(PCPLUS4),
        .PC_TargetO(PCTARGET_TO_RMAD)
    );

    signextend CPU_SIGNEXTEND (
        .code(INSTRUCT),
        .immscr(IMMSRC),
        .immop(IMMOP)
    );

    instrmem CPU_ROM (
        .addr(PC_OUT),
        .instr(INSTRUCT)
    );

    CU CPU_CU (
        .instr(INSTRUCT),
        .eq(EQ),
        .pc_src(PCSRC),
        .result_src(RESULTSRC),
        .mem_write(MEMWRITE),
        .alu_ctrl(ALUCTRL),
        .alu_src(ALUSRC),
        .imm_src(IMMSRC),
        .reg_write(REGWRITE),
        .jump_src(JUMPSRC)
    );

    RMAD CPU_RMAD (
        .clk(clk),
        .A1(INSTRUCT[19:15]),
        .A2(INSTRUCT[24:20]),
        .A3(INSTRUCT[11:7]),
        .RegWrite(REGWRITE),
        .trigger(T0),
        .ImmExt(IMMOP),
        .ALUSrc(ALUSRC),
        .MemWrite(MEMWRITE),
        .ResultSrc(RESULTSRC),
        .PCPlus4(PCPLUS4),
        .JumpSrc(JUMPSRC),
        .PCtargetIn(PCTARGET_TO_RMAD),
        .ALUControl(ALUCTRL),
        .Zero(EQ),
        .a0(A0),
        .PCtargetOut(PCTARGET_TO_PC)
    );

endmodule
