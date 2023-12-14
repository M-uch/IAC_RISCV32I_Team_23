module PC#(
    parameter WIDTH = 32
)(

    input  logic                     clk,
    input  logic                     rst,
    input  logic    [WIDTH-1:0]      PC_TargetI,                      
    input  logic                     PCsrc,        // select for mux
    input  logic    [WIDTH-1:0]      ImmOp,        // imm ofsset for branch instructions
    output logic    [WIDTH-1:0]      PC_out,       // PC Counter
    output logic    [WIDTH-1:0]      PC_Plus4      // PC + 4 (for return address)
    output logic    [WIDTH-1:0]      PC_TargetO    // PC Target
);

    // intermediate vals
    logic [WIDTH-1:0]   inc_PC;       // result of PC + 4 
    logic [WIDTH-1:0]   next_PC;      // result from select line

    assign PC_TargetO = PC_out + ImmOp;
    assign inc_PC = PC_out + 32'b100;


    // Instantiate modules
    mux PC_mux (

        .i1(PC_TargetI),
        .i0(inc_PC),
        .s(PCsrc),
        .out(next_PC)
    );

    register PC_Reg (

        .clk(clk),
        .rst(rst),
        .next_PC(next_PC),
        .PC(PC_out)
    );

endmodule
