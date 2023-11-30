module PC#(
    parameter WIDTH = 32
)(

    input  logic                     clk,
    input  logic                     rst,
    input  logic                     PCsrc,      // select for mux
    input  logic    [WIDTH-1:0]      ImmOp,      // imm ofsset for branch instructions
    output logic    [WIDTH-1:0]      PC_out          // PC Counter 
);

    // intermediate vals
    logic [WIDTH-1:0]   branch_PC;    // result of PC + ImmOp
    logic [WIDTH-1:0]   inc_PC;       // result of PC + 4 
    logic [WIDTH-1:0]   next_PC;      // result from select line

    assign branch_PC = PC_out + ImmOp;
    assign inc_PC = PC_out + 32'b100;


    // Instantiate modules
    mux PC_mux (

        .i1(branch_PC),
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
