module alu_decoder #(
    parameter ALUOP_WIDTH = 3,
    parameter OP_WIDTH = 7,
    parameter F3_WIDTH = 3,
    parameter F7_WIDTH = 7
) (
    input logic [ALUOP_WIDTH-1:0]  alu_op,
    input logic [OP_WIDTH-1:0] op,
    input logic [F3_WIDTH-1:0] funct3,
    input logic [F7_WIDTH-1:0] funct7,
    output logic [F3_WIDTH-1:0] alu_ctrl,
    output logic                a_type     // byte or word addressing
);

typedef enum logic [ALUOP_WIDTH-1:0] {
    Type_RIALU  = 3'b000,  
    Type_I      = 3'b001, 
    Type_S      = 3'b010, 
    Type_B      = 3'b011, 
    Type_U      = 3'b100, 
    Type_U_LUI  = 3'b101, 
    Type_J_JALR = 3'b110,  
    Type_J_JAL  = 3'b111 
} Instruction_Type;

always_comb begin
    logic [1:0] test = {op[5], funct7[5]};
    Instruction_Type i_type = alu_op;

    case(i_type)

        Type_RIALU: begin
            case(funct3)

                3'b000: alu_ctrl = (test == 2'b11) ? 3'b001 : 3'b000;    // if test is 11 then sub, otherwise add
                3'b001: alu_ctrl = 3'b010;                                // sll
                3'b010: alu_ctrl = 3'bxxx;                                // slt unassigned
                3'b011: alu_ctrl = 3'bxxx;                                // sltu unassigned
                3'b100: alu_ctrl = 3'b100;                                // xor
                3'b101: alu_ctrl = 3'b101;                                // slr
                3'b110: alu_ctrl = 3'b110;                                // or
                3'b111: alu_ctrl = 3'b111;                                // and

            endcase
        end

        Type_I: begin         
            alu_ctrl = 3'b000;
            a_type = (funct3 == 3'b100) ? 1'b1 : 1'b0;                                // I think for store and load we add
        end

        Type_S: begin         
            alu_ctrl = 3'b000;
            a_type = (funct3 == 3'b000) ? 1'b1 : 1'b0;                                // ^
        end
        
        // Type_B: alu_ctrl = 3'b001;                               // beq is subtraction
        // Type_U: alu_ctrl = 3'b000;                                // add for upper ?
        // Type_U_LUI: alu_ctrl = 3'b010;                             // assuming need to do sll
        // Type_J_JALR: alu_ctrl = 3'b000;                             // add for jump 
        // Type_J_JAL: alu_ctrl = 3'b000;                                 // add for jump
        
        Type_B: begin         
            alu_ctrl = 3'b001;
            a_type = 1'bx;                                // beq is subtraction
        end

        Type_U: begin         
            alu_ctrl = 3'b000; 
            a_type = 1'bx;                                // add for upper ?
        end

        Type_U_LUI: begin     
            alu_ctrl = 3'b011; 
            a_type = 1'bx;                                // assuming need to do sll
        end

        Type_J_JALR: begin   
            alu_ctrl = 3'b000;
            a_type = 1'bx;                                // add for jump 
        end
        
        Type_J_JAL: begin    
            alu_ctrl = 3'b000; 
            a_type = 1'bx;                                // add for jump
        end
        // default: a_type = 1'bx;
        default: ;
        
    endcase
end

endmodule
