module control_unit(
    input logic [31:0] instr,
    input logic eq,
    output logic reg_write,
    output logic alu_ctrl,
    output logic alu_src,
    output logic [1:0] imm_src,
    output logic pc_src
);


parameter ADDI_OP = 7'b0010011;
parameter BNE_OP = 7'b1100011;
parameter ADDI_FUNC3 = 3'b000;
parameter BNE_FUNC3 = 3'b001;
parameter alu_add = 3'd0;
parameter alu_subtract =3'd1;

assign alu_src = ((instr[6:0]==ADDI_OP)&&(instr[14:12]==ADDI_FUNC3)) ? 1'b1 : 1'b0;
assign pc_src = ((instr[6:0]==BNE_OP)&&(instr[14:12]==BNE_FUNC3)&&(eq==1'b0)) ? 1'b1 : 1'b0;
assign imm_src = (instr[6:0]==ADDI_OP) ? 2'b00 : 
                 (instr[6:0]==BNE_OP ) ? 2'b10 : 2'b11 ;
assign reg_write = ((instr[6:0]==ADDI_OP)&&(instr[14:12]==ADDI_FUNC3)) ? 1'b1 : 1'b0;
assign alu_ctrl = ((instr[6:0]==ADDI_OP)&&(instr[14:12]==ADDI_FUNC3)) ? 3'd0 : 3'd1;
endmodule
