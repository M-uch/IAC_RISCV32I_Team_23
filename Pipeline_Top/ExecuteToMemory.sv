module ExecuteToMemory #(
    parameter   DATA_WIDTH = 32,
                ADDRESS_WIDTH = 5
)(
    input  logic                       CLK, RegWriteE, MemWriteE, a_typeE,
    input  logic [1:0]                 ResultSrcE,
    input  logic [ADDRESS_WIDTH-1:0]   RdE,
    input  logic [DATA_WIDTH-1:0]      ALUResultE, WriteDataE, PCPlus4E,

    output  logic                      RegWriteM, MemWriteM, a_typeM,
    output  logic [1:0]                ResultSrcM,
    output  logic [ADDRESS_WIDTH-1:0]  RdM,
    output  logic [DATA_WIDTH-1:0]     ALUResultM, WriteDataM, PCPlus4M
    );

always_ff @(posedge CLK) begin
        RegWriteM <= RegWriteE;
        MemWriteM <= MemWriteE;
        ResultSrcM <= ResultSrcE;
        RdM <= RdE;
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;     
        PCPlus4M <= PCPlus4E;
        a_typeM <= a_typeE;
end

endmodule
