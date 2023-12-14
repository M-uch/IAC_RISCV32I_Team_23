module Fetch_stage #(
    parameter D_WIDTH = 32
) (
    input logic clk,   
    input logic rst,
    input logic StallF,
    input logic StallD,
    input logic FlushD,
    input logic PCSrcE,
    input logic [D_WIDTH-1:0] PCTargetE,
    output logic [D_WIDTH-1:0] InstrD,
    output logic [D_WIDTH-1:0] PCOut,
    output logic [D_WIDTH-1:0] PCplus4F_o
);

    // assign / declare vals
    logic [D_WIDTH-1:0] PCF;        // PC -> InstrMem
    logic [D_WIDTH-1:0] PCPlus4F;   // PC -> Pipeline Register
    logic [D_WIDTH-1:0] Instr;      // InstrMem -> Pipeline Register


    PC_P CPU_PC (
        .clk(clk),
        .rst(rst),
        .en(StallF),
        .PC_Target(PCTargetE),
        .PCsrc(PCSrcE),
        .PC_out(PCF),
        .PC_Plus4(PCPlus4F)
    );

    instrmem CPU_ROM (
        .addr(PCF),
        .instr(Instr)
    );

    FetchToDecode F2D (
        .CLK(clk),                  // I/Ps
        .EN(StallD),
        .CLR(FlushD),
        .InstrF(Instr),
        .PCPlus4F(PCPlus4F),
        .PCF(PCF),

        .InstrD(InstrD),            // O/Ps
        .PCPlus4D(PCplus4F_o),
        .PCD(PCOut)
    );



endmodule
