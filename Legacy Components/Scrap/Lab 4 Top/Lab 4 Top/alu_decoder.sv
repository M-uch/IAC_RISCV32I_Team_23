module alu_decoder #(
    parameter ALUOP_WIDTH = 2,
    parameter OP_WIDTH = 7,
    parameter F3_WIDTH = 3,
    parameter F7_WIDTH = 7
) (
    input logic [ALUOP_WIDTH-1:0]  alu_op,
    input logic [OP_WIDTH-1:0] op,
    input logic [F3_WIDTH-1:0] funct3,
    input logic [F7_WIDTH-1:0] funct7,
    output logic [F3_WIDTH-1:0] alu_ctrl
);

always_comb begin

    logic [1:0] test = {op[5], funct7[5]};

    // if (alu_op == 2'b00) begin
    //     alu_ctrl = 3'b000;
    // end else if (alu_op == 2'b01) begin
    //     alu_ctrl = 3'b001;
    // end else if (alu_ctrl = 2'b10) begin
    //     if (funct3 == b'000) begin
    //         if((test == 2'b00) || (test == 2'b01) || (test == 2'b10)) begin
    //             alu_ctrl = 3'b000;
    //         end else if (test == 2'b11) begin
    //             alu_ctrl = 3'b001;
    //         end
    //     end else if (funct3 == 3'b010) begin
    //         alu_ctrl = 3'b101;
    //     end else if (funct3 == 3'b110) begin
    //         alu_ctrl = 3'b011;
    //     end else if (functt3 == 3'b111) begin
    //        alu_ctrl = 3'b010; 
    //     end
    // end
    
    case(alu_op)

        // lw, sw
        2'b00: begin
            alu_ctrl = 3'b000;
        end

        // beq
        2'b01: begin
            alu_ctrl = 3'b001;
        end

        // ALU instructions
        2'b10: begin
            
            case(funct3)

                // add or sub
                3'b000: begin
                    case(test)

                        // add
                        2'b00, 2'b01, 2'b10: begin
                            alu_ctrl = 3'b000;
                        end

                        // sub
                        2'b11: begin
                            alu_ctrl = 3'b001;
                        end
                        default: ;
                    endcase
                end

                // slt
                3'b010: begin
                    alu_ctrl = 3'b101;
                end

                // or
                3'b110: begin
                    alu_ctrl = 3'b011;
                end

                // and
                3'b111: begin
                    alu_ctrl = 3'b010;
                end
                default: ;
            endcase
        end
    endcase 
end

endmodule
