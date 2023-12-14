module Memory_stage #(
    parameter D_WIDTH = 32,
    parameter A_WIDTH = 5
) (
    input logic                     clk, RegWriteM, MemWriteM, a_typeM,
    input logic [1:0]               ResultSrcM,
    input logic [D_WIDTH-1:0]       PCPlus4M, ALUResultM, WriteDataM,
    input logic [A_WIDTH-1:0]       RdM,

    output logic                    RegWriteW,
    output logic [1:0]              ResultSrcW,
    output logic [A_WIDTH-1:0]      RdW,
    output logic [D_WIDTH-1:0]      PCPlus4W, ReadDataW, ALUResultW
);

logic   [D_WIDTH-1:0]           ReadDataM;

DataMemory DataMem (
    .clk        (clk),
    .ADTP       (a_typeM),
    .WE         (MemWriteM),
    .A          (ALUResultM),
    .WD         (WriteDataM),
    .RD         (ReadDataM)
);

MemoryToWriteback   PipelineRegisters (
    .CLK        (clk),
    .RegWriteM  (RegWriteM),
    .ResultSrcM (ResultSrcM),
    .RdM        (RdM),
    .ALUResultM (ALUResultM),
    .ReadDataM  (ReadDataM),
    .PCPlus4M   (PCPlus4M),

    .RegWriteW  (RegWriteW),
    .ResultSrcW (ResultSrcW),
    .RdW        (RdW),
    .ALUResultW (ALUResultW),
    .ReadDataW  (ReadDataW),
    .PCPlus4W   (PCPlus4W)
);

endmodule
