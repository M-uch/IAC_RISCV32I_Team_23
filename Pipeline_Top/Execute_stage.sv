module Execute_stage #(
    parameter D_WIDTH = 32,
    parameter A_WIDTH = 5
) (
    input logic clk,
    input logic ForwardAE,
    input logic ForwardBE,
    input logic RegWriteE_i,
    input logic [1:0] ResultSrcE_i,
    input logic MemWriteE_i,
    input logic JumpE,
    input logic BranchE,
    input logic [2:0] ALUCtrlE,
    input logic ALUSrcE,
    input logic JumpSrcE,
    input logic ATypeE_i,
    input logic [D_WIDTH-1:0] PCE_i,
    input logic [A_WIDTH-1:0] Rs1E,
    input logic [A_WIDTH-1:0] Rs2E,
    input logic [D_WIDTH-1:0] ImmExtE,
    input logic [D_WIDTH-1:0] PCplus4E_i,
    input logic [D_WIDTH-1:0] ALUResult, // FEEDBACK FROM MEMORY STAGE
    input logic [D_WIDTH-1:0] ResultW,   // FEEDBACK FROM WRTIEBACK STAGE
    output logic PCSrcE,
    output logic RegWriteE_o,
    output logic [1:0] ResultSrcE_o,
    output logic MemWriteE_o
    output logic ATypeE_o,
    output logic [D_WIDTH-1:0] ALUResult,
    output logic [D_WIDTH-1:0] WriteDataE, // NOT SURE ABOUT THE SIZE
    output logic [D_WIDTH-1:0] PCTargetE,
    output logic [A_WIDTH-1:0] RdE_o,
    output logic [D_WIDTH-1:0] PCplus4E_o
);

    // Connect follow through wires
    assign RegWriteE_i = RegWriteE_o;
    assign ResultSrcE_i = ResultSrcE_o;
    assign MemWriteE_i = MemWriteE_o;    
    assign PCplus4E_i = PCplus4E_o;

    // assign / declare vals
    logic [D_WIDTH-1:0] SrcAE;
    logic [D_WIDTH-1:0] WriteDataE;
    logic [D_WIDTH-1:0] SrcBE;


endmodule
