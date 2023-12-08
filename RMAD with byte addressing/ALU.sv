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
    if(ALUctrl == 3'b001)                                   // sub
        {Zero, ALUout} = ALUop1 - ALUop2;
    if(ALUctrl == 3'b111)                                   // and
        {Zero, ALUout} = ALUop1 & ALUop2;
    if(ALUctrl == 3'b110)                                   // or
        {Zero, ALUout} = ALUop1 | ALUop2;
    if(ALUctrl == 3'b100)                                   // xor
        {Zero, ALUout} = ALUop1 ^ ALUop2;
    if(ALUctrl == 3'b010)                                   // sll
        {Zero, ALUout} = ALUop1 << ALUop2;
    if(ALUctrl == 3'b101)                                   // slr
        {Zero, ALUout} = ALUop1 >> ALUop2;
end

endmodule
