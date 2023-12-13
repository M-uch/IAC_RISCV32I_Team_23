module Fetch_stage #(
    parameter D_WIDTH = 32
) (
    input logic clk,   
    input logic rst,
    input logic en,
    input logic StallF,
    input logic StallD,
    input logic FlushD,
    input logic PCSrcE,
    input logic [D_WIDTH-1:0] PCTargetE,
    output logic [D_WIDTH-1:0] InstrD,
    output logic [D_WIDTH-1:0] PCOut,
    output logic [D_WIDTH-1:0] PCplus4F
);





endmodule
