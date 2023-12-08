module CU #(
    parameter WIDTH = 32
) (
    input logic     [WIDTH-1:0]     instr,   // Instruction
    output logic                    pc_src,
    // output logic                    result_src,
    // output logic                    mem_write,
    output logic    [2:0]           alu_ctrl,
    output logic                    alu_src,
    output logic    [1:0]           imm_src,
    output logic                    reg_write

);

    logic [1:0] ALUOp;
    logic branch;

    assign pc_src = branch;

    main_decoder Main_Decoder (
        .op(instr[6:0]),
        .branch(branch),
        // .result_src(result_src),
        // .mem_write(mem_write),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .reg_write(reg_write),
        .alu_op(ALUOp)
    );

    alu_decoder ALU_Decoder (
        .alu_op(ALUOp),
        .op(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .alu_ctrl(alu_ctrl)
    );

endmodule
