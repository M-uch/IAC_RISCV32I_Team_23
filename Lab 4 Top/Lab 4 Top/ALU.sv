module  ALU #(
    parameter       DATA_WIDTH = 32
)(
    input   logic[DATA_WIDTH-1:0]       ALUop1, ALUop2,
    input   logic[2:0]                  ALUctrl,
    output  logic[DATA_WIDTH-1:0]       ALUout,
    output  logic                       eq
);

always_comb begin
    if(ALUctrl == 0)
        {eq, ALUout} = ALUop1 + ALUop2;
end

endmodule
