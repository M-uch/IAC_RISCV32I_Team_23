module main_decoder #(
    parameter OP_WIDTH = 7,
    parameter 2_WIDTH = 2,
    parameter 3_WIDTH = 3
) (
    input logic [OP_WIDTH-1:0] op,
    output logic branch,
    output logic jump,
    output logic [2_WIDTH-1:0] result_src,
    output logic mem_write,
    output logic alu_src,
    output logic [3_WIDTH-1:0] imm_src,
    output logic reg_write,
    output logic [3_WIDTH-1:0] alu_op
);

typedef enum logic [6:0] {
    Type_R      = 7'b0110011,  
    Type_I      = 7'b0000011, 
    Type_I_ALU  = 7'b0010011, 
    Type_S      = 7'b0100011, 
    Type_B      = 7'b1100011, 
    Type_U      = 7'b0010111, 
    Type_U_LUI  = 7'b0110111, 
    Type_J_JALR = 7'b1100111,  
    Type_J_JAL  = 7'b1101111  
} Instruction_Type;

// Define Control Code
assign {reg_write, imm_src, alu_src, mem_write, result_src, branch, alu_op, jump} = command_code; // takes form x_xxx_x_x_xx_x_xxx_x

always_comb begin
    Instruction_Type opcode = op;

    case(opcode)
        // NOTE: 
        // - not sure about result_src for Upper instructions
        // - alu_op is same for R and I_ALU Instruction types
        Type_R:         command_code = 13'b1_xxx_0_0_00_0_000_0 ;
        Type_I:         command_code = 13'b1_001_1_0_01_0_001_0 ;
        Type_I_ALU:     command_code = 13'b1_001_1_0_00_0_000_0 ;
        Type_S:         command_code = 13'b0_011_1_1_xx_0_010_0 ;
        Type_B:         command_code = 13'b0_100_0_0_xx_1_011_0 ;
        Type_U:         command_code = 13'b1_010_1_0_00_0_100_0 ;
        Type_U_LUI:     command_code = 13'b1_010_1_0_00_0_101_0 ;
        Type_J_JALR:    command_code = 13'b1_101_0_0_10_0_110_1 ;
        Type_J_JAL:     command_code = 13'b1_101_0_0_10_0_111_1 ;
        default:        command_code = 13'bx_xxx_x_x_xx_x_xxx_x ;

    endcase
end

endmodule
