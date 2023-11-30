module main_decoder #(
    parameter OP_WIDTH = 7,
    parameter WIDTH = 2
) (
    input logic [OP_WIDTH-1:0] op,
    output logic branch,
    // output logic result_src,
    // output logic mem_write,
    output logic alu_src,
    output logic [WIDTH-1:0] imm_src,
    output logic reg_write,
    output logic [WIDTH-1:0] alu_op
);

always_comb begin

    // if(op == 7'b0000011) begin
    //         eg_write = 1;
    //         imm_src = 2'b00;
    //         alu_src = 1;
    //         // mem_write = 0;
    //         // result_src = 1;
    //         branch = 0;
    //         alu_op = 2'b00;
    // end else if (op == 7'b0100011) begin
    //         reg_write = 0;
    //         imm_src = 2'b01;
    //         alu_src = 1;
    //         // mem_write = 1;
    //         // result_src = 0; // x
    //         branch = 0;
    //         alu_op = 2'b00;
    // end else if (op == 7'b0110011) begin
    //         reg_write = 1;
    //         imm_src = 2'b00; // xx
    //         alu_src = 0;
    //         // mem_write = 0;
    //         // result_src = 0;
    //         branch = 0;
    //         alu_op = 2'b10;
    // end else if (op == 7'b1100011) begin
    //         reg_write = 0;
    //         imm_src = 2'b10;
    //         alu_src = 0;
    //         // mem_write = 0;
    //         // result_src = 0; // x
    //         branch = 1;
    //         alu_op = 2'b01;
    // end
    
    
    case (op)
        // lw
        7'b0000011: begin
            reg_write = 1;
            imm_src = 2'b00;
            alu_src = 1;
            // mem_write = 0;
            // result_src = 1;
            branch = 0;
            alu_op = 2'b00;
        end

        // sw
        7'b0100011: begin
            reg_write = 0;
            imm_src = 2'b01;
            alu_src = 1;
            // mem_write = 1;
            // result_src = 0; // x
            branch = 0;
            alu_op = 2'b00;
        end

        // R-type
        7'b0110011: begin
            reg_write = 1;
            imm_src = 2'b00; // xx
            alu_src = 0;
            // mem_write = 0;
            // result_src = 0;
            branch = 0;
            alu_op = 2'b10;
        end

        // beq
        7'b1100011: begin
            reg_write = 0;
            imm_src = 2'b10;
            alu_src = 0;
            // mem_write = 0;
            // result_src = 0; // x
            branch = 1;
            alu_op = 2'b01;
        end

        //addi
        7'b0010011: begin
            reg_write = 1;
            imm_src = 2'b00;
            alu_src = 1;
            branch = 0;
            alu_op = 2'b10;
        end
        default: ;
    endcase
end

endmodule
