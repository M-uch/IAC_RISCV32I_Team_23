module Execute_stage #(
    parameter D_WIDTH = 32,
    parameter A_WIDTH = 5
) (
    input logic clk,
    input logic [1:0] ForwardAE,
    input logic [1:0] ForwardBE,
    input logic RegWriteE,
    input logic [1:0] ResultSrcE_i,
    input logic MemWriteE,
    input logic JumpE,
    input logic BranchE,
    input logic [2:0] ALUCtrlE,
    input logic ALUSrcE,
    input logic JumpSrcE,
    input logic ATypeE,
    input logic [D_WIDTH-1:0] PCE,
    input logic [D_WIDTH-1:0] RD1E,
    input logic [D_WIDTH-1:0] RD2E,
    input logic [A_WIDTH-1:0] RdE_i,
    input logic [D_WIDTH-1:0] raE,
    input logic [D_WIDTH-1:0] ImmExtE,
    input logic [D_WIDTH-1:0] PCPlus4E,
    input logic [D_WIDTH-1:0] ALUResultM_i, // FEEDBACK FROM MEMORY STAGE
    input logic [D_WIDTH-1:0] ResultW,   // FEEDBACK FROM WRTIEBACK STAGE

    output logic PCSrcE,
    output logic RegWriteM,
    output logic [1:0] ResultSrcM,
    output logic MemWriteM,
    output logic ATypeM,
    output logic [D_WIDTH-1:0] ALUResultM_o,
    output logic [D_WIDTH-1:0] WriteDataM,
    output logic [D_WIDTH-1:0] PCTargetE,
    output logic [A_WIDTH-1:0] RdM,
    output logic [D_WIDTH-1:0] PCPlus4M
);

    // assign / declare vals
    logic               ZeroE;
    logic [D_WIDTH-1:0] SrcAE;
    logic [D_WIDTH-1:0] WriteDataE;
    logic [D_WIDTH-1:0] SrcBE;
    logic [D_WIDTH-1:0] ALUResultE;
    logic [D_WIDTH-1:0] PCTarget;



    // Connect follow through wires
    assign PCSrcE = (BranchE & ZeroE) | JumpE;
    assign PCTarget = PCE + ImmExtE;

Mux     JumpMux (
    .in0        (PCTarget),
    .in1        (raE),
    .select     (JumpSrcE),
    .out        (PCTargetE)
);

Mux3    SrcAEMux (
    .in0        (RD1E),
    .in1        (ResultW),
    .in2        (ALUResultM_i),
    .select     (ForwardAE),
    .out        (SrcAE)
);

Mux3    WriteDataEMux (
    .in0        (RD2E),
    .in1        (ResultW),
    .in2        (ALUResultM_i),
    .select     (ForwardBE),
    .out        (WriteDataE)
);

Mux     SrcBEMux (
    .in0        (WriteDataE),
    .in1        (ImmExtE),
    .select     (ALUSrcE),
    .out        (SrcBE)
);

ALU     ALUE (
    .ALUop1     (SrcAE),
    .ALUop2     (SrcBE),
    .ALUctrl    (ALUCtrlE),
    .ALUout     (ALUResultE),
    .Zero       (ZeroE)
);

ExecuteToMemory     PipelineRegister (
    .CLK        (clk),
    .RegWriteE  (RegWriteE),
    .MemWriteE  (MemWriteE),
    .a_typeE    (ATypeE),
    .ResultSrcE (ResultSrcE_i),
    .RdE        (RdE_i),
    .ALUResultE (ALUResultE),
    .WriteDataE (WriteDataE),
    .PCPlus4E   (PCPlus4E),

    .RegWriteM  (RegWriteM),
    .MemWriteM  (MemWriteM),
    .ResultSrcM (ResultSrcM),
    .RdM        (RdM),
    .ALUResultM (ALUResult_o),
    .WriteDataM (WriteDataM),
    .PCPlus4M   (PCPlus4M),
    .a_typeM    (ATypeM)
);

endmodule
