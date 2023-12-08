module Top #(
    parameter WIDTH = 32
) (
    input  logic            clk,        // CPU clock
    input  logic            rst,        // reset
    output logic [WIDTH-1:0] A0        // O/P Register
);

    // CONTROL SIGNALS
    logic                   REGWRITE;
    logic   [2:0]           ALUCTRL;
    logic                   ALUSRC;
    logic   [1:0]           IMMSRC;
    logic                   PCSRC;

    // INTER SIGNALS
    logic   [WIDTH-1:0]     PC_OUT;     // address of instruction memory
    logic   [WIDTH-1:0]     IMMOP;      // O/P of sign extend block
    logic   [WIDTH-1:0]     INSTRUCT;   // current cycle instruction
    logic                   EQ;
    // logic   [WIDTH-1:0]     UNUSED;     // discard unused instruc memory bits

    PC CPU_PC (
        .clk(clk),
        .rst(rst),
        .PCsrc(PCSRC),
        .ImmOp(IMMOP),
        .PC_out(PC_OUT)
    );

    signextend CPU_SIGNEXTEND (
        .code(INSTRUCT),
        .immscr(IMMSRC),
        .immop(IMMOP)
    );

    instrmem CPU_ROM (
        .addr(PC_OUT),
        .instr(INSTRUCT),
        // .ignoreunused(UNUSED)
    );

    CU CPU_CU (
        .instr(INSTRUCT),
        .pc_src(PCSRC),
        //.result_src(RESULTSRC),
        //.mem_write(MEMWRITE),
        .alu_ctrl(ALUCTRL),
        .alu_src(ALUSRC),
        .imm_src(IMMSRC),
        .reg_write(REGWRITE)
    );

    RMA CPU_RMA (
        .clk(clk),
        .rs1(INSTRUCT[19:15]),
        .rs2(INSTRUCT[24:20]),
        .rd(INSTRUCT[11:7]),
        .RegWrite(REGWRITE),
        .ImmOp(IMMOP),
        .ALUsrc(ALUSRC),
        .ALUctrl(ALUCTRL),
        .eq(EQ),
        .a0(A0)

    );

endmodule
