module MemoryToWriteback #(
    parameter   DATA_WIDTH = 32,
                ADDRESS_WIDTH = 5
)(
    input  logic                       CLK, RegWriteM,
    input  logic [1:0]                 ResultSrcM,
    input  logic [ADDRESS_WIDTH-1:0]   RdM,
    input  logic [DATA_WIDTH-1:0]      ALUResultM, ReadDataM, PCPlus4M,

    output  logic                      RegWriteW,
    output  logic [1:0]                ResultSrcW,
    output  logic [ADDRESS_WIDTH-1:0]  RdW,
    output  logic [DATA_WIDTH-1:0]     ALUResultW, ReadDataW, PCPlus4W
    );

always_ff @(posedge CLK) begin
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        RdW <= RdM;
        ALUResultW <= ALUResultM;
        ReadDataW <= ReadDataM;     
        PCPlus4W <= PCPlus4M;
end

endmodule
