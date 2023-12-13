module Memory_stage #(
    parameter D_WIDTH = 32,
    parameter A_WIDTH = 5
) (
    input logic                     clk, RegWriteM_i, WriteDataM, MemWriteM, a_typeM,
    input logic [1:0]               ResultSrcM_i,
    input logic [D_WIDTH-1:0]       RdM_i, PCPlus4M_i, ALUResultM_i,

    output logic                    RegWriteM_o, RegWriteW,
    output logic [1:0]              ResultSrcW,
    output logic [D_WIDTH-1:0]      RdM_o, ALUResultM_o, ReadDataW, ALUResultW, RdW, PCPlus4M_o
);

logic   [D_WIDTH-1:0]           ReadDataM;

assign RegWriteM_o = RegWriteM_i;
assign RdM_o = RdM_i;
assign ALUResultM_o = ALUResultM_i;

DataMemory DataMem (
    .clk        (clk),
    .ADTP       (a_typeM),
    .WE         (MemWriteM),
    .A          (ALUResultM_i),
    .WD         (WriteDataM),
    .RD         (ReadDataM)
);

MemoryToWriteback   PipelineRegisters (
    .CLK        (clk),
    .RegWriteM  (RegWriteM_i),
    .ResultSrcM (ResultSrcM_i),
    .RdM        (RdM_i),
    .ALUResultM (ALUResultM_i),
    .ReadDataM  (ReadDataM),
    .PCPlus4M   (PCPlus4M_i),

    .RegWriteW  (RegWriteW,)
    .ResultSrcW (ResultSrcW),
    .RdW        (RdW),
    .ALUResultW (ALUResultW),
    .ReadDataW  (ReadDataW),
    .PCPlus4M_o (PCPlus4M_i)
);

endmodule
