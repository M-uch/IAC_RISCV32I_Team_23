module ALU_Mux #(
    parameter      DATA_WIDTH = 32
)(
    input   logic[DATA_WIDTH-1:0]   ImmOp, RD2,
    input   logic                   ALUsrc,
    output  logic[DATA_WIDTH-1:0]   ALUop2
);
assign ALUop2 = ALUsrc ? ImmOp : RD2;

endmodule
