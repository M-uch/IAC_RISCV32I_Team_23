module DecodeToExecute #(
    parameter   DATA_WIDTH = 32,
                ADDRESS_WIDTH = 5
)(
    input   logic                       CLK, CLR, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD,
    input   logic [1:0]                 ResultSrcD,
    input   logic [2:0]                 ALUControlD,
    input   logic [ADDRESS_WIDTH-1:0]   Rs1D, Rs2D, RdD,
    input   logic [DATA_WIDTH-1:0]      RD1D, RD2D, PCD, ImmExtD, PCPlus4D,

    output  logic                       RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,
    output  logic [1:0]                 ResultSrcE,
    output  logic [2:0]                 ALUControlE,
    output  logic [ADDRESS_WIDTH-1:0]   Rs1E, Rs2E, RdE,
    output  logic [DATA_WIDTH-1:0]      RD1E, RD2E, PCE, ImmExtE, PCPlus4E
    );

always_ff @(posedge CLK, posedge CLR) begin
    if(CLR) begin
        RegWriteE <= 1'b0;
        MemWriteE <= 1'b0;
        JumpE <= 1'b0;
        BranchE <= 1'b0;
        ALUSrcE <= 1'b0;
        ResultSrcE <= 2'b0;
        ALUControlE <= 3'b0;
        Rs1E <= 5'b0;
        Rs2E <= 5'b0;
        RdE <= 5'b0;
        RD1E <= 32'b0;
        RD2E <= 32'b0;
        PCE <= 32'b0;
        ImmExtE <= 32'b0;
        PCPlus4E <= 32'b0;
    end
    else begin
        RegWriteE <= RegWriteD;
        MemWriteE <= MemWriteD;
        JumpE <= JumpD;
        BranchE <= BranchD;
        ALUSrcE <= ALUSrcD;
        ResultSrcE <= ResultSrcD;
        ALUControlE <= ALUControlD;
        Rs1E <= Rs1D;
        Rs2E <= Rs2D;
        RdE <= RdD;
        RD1E <= RD1D;
        RD2E <= RD2D;
        PCE <= PCD;
        ImmExtE <= ImmExtD;
        PCPlus4E <= PCPlus4D;
    end

end

endmodule
