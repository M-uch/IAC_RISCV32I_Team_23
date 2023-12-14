module  ALU #(
    parameter       DATA_WIDTH = 32
)(
    input   logic[DATA_WIDTH-1:0]       ALUop1, ALUop2,
    input   logic[2:0]                  ALUctrl,
    output  logic[DATA_WIDTH-1:0]       ALUout,
    output  logic                       Zero
);

logic   [DATA_WIDTH-1:0]        ALU_Result;

assign Zero = (ALU_Result == 32'b0) ? 1'b1 : 1'b0;
assign ALUout = ALU_Result;

always_comb begin

    case(ALUctrl)

        3'b000: ALU_Result = ALUop1 + ALUop2; 
        3'b001: ALU_Result = ALUop1 - ALUop2; 
        3'b010: ALU_Result = ALUop1 << ALUop2; 
        3'b011: ALU_Result = ALUop2; // Select Input 2 for LUI type
        3'b100: ALU_Result = ALUop1 ^ ALUop2; 
        3'b101: ALU_Result = ALUop1 >> ALUop2;      
        3'b110: ALU_Result = ALUop1 | ALUop2;    
        3'b111: ALU_Result = ALUop1 & ALUop2;

        default: ;
    
    endcase

end

endmodule
