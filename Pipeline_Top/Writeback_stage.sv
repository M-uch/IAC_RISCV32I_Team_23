module Writeback_stage #(
    parameter D_WIDTH = 32,
    parameter A_WIDTH = 5
) (
    input logic                     RegWriteW_i,
    input logic [1:0]               ResultSrcW,
    input logic [D_WIDTH-1:0]       ReadDataW, ALUResultW, RdW_i, PCPlus4W,

    output logic                    RegWriteW_o,
    output logic [D_WIDTH-1:0]      result, RdW_o
);

assign RegWriteW_o = RegWriteW_i;
assign RdW_o = RdW_i;


Mux3    ResultMux (
    .in0        (ALUResultW),
    .in1        (ReadDataW),
    .in2        (PCPlus4W),
    .select     (ResultSrcW),
    .out        (result)
);

endmodule
