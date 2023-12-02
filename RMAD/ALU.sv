module  ALU #(
    parameter       DATA_WIDTH = 32
)(
    input   logic[DATA_WIDTH-1:0]       ALUop1, ALUop2,
    input   logic[2:0]                  ALUctrl,
    output  logic[DATA_WIDTH-1:0]       ALUout,
    output  logic                       Zero
);

always_latch begin
    if(ALUctrl == 3'b000)                                   // add
        {Zero, ALUout} = ALUop1 + ALUop2;
    if(ALUctrl == 3'b111)                                   // and
        ALUout = ALUop1 & ALUop2;
    if(ALUctrl == 3'b110)                                   // or
        ALUout = ALUop1 | ALUop2;
    if(ALUctrl == 3'b100)                                   // xor
        ALUout = ALUop1 ^ ALUop2;
    if(ALUctrl == 3'b001)                                   // sll
        {Zero, ALUout} = ALUop1 << ALUop2;
    if(ALUctrl == 3'b101)                                   // slr
        ALUout = ALUop1 >> ALUop2;
end

endmodule
