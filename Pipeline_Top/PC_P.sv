module PC_P#(
    parameter WIDTH = 32
)(

    input  logic                     clk,
    input  logic                     rst,
    input  logic                     en,
    input  logic    [WIDTH-1:0]      PC_Target,                      
    input  logic                     PCsrc,        // select for mux
    output logic    [WIDTH-1:0]      PC_out,       // PC Counter
    output logic    [WIDTH-1:0]      PC_Plus4      // PC + 4 (for return address)
);

    // intermediate vals
    logic [WIDTH-1:0]   next_PC;      // result from select line

    assign PC_Plus4 = PC_out + 32'b100;


    // Instantiate modules
    pc_mux PC_mux (

        .i1(PC_Target),
        .i0(PC_Plus4),
        .s(PCsrc),
        .out(next_PC)
    );

    register_P PC_Reg (

        .clk(clk),
        .rst(rst),
        .en(en),
        .next_PC(next_PC),
        .PC(PC_out)
    );

endmodule
