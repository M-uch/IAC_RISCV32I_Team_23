module Top #(
    parameter WIDTH = 32
) (
    input  logic                       clk,        // CPU clock
    input  logic                       rst,        // reset
    input  logic                       en,         // enable
    input  logic                       T0,         // trigger
    output logic     [WIDTH-1:0]       A0          // O/P Register
);

    ///////////////////////////
    // --- INTER SIGNALS --- //
    ///////////////////////////
    
    // --- FETCH O/P --- //
    
    logic [WIDTH-1:0]  INSTRD;
    logic [WIDTH-1:0]  PCD;
    logic [WIDTH-1:0]  PCPLUS4D;

// <-------------------------------------------------------------------------------------> //

    // --- DECODE -O/P --- //

    // CONTROL SIGNALS
    logic REGWRITEE;
    logic [1:0] RESULTSRCE;
    logic MEMWRITEE;
    logic JUMPE;
    logic BRANCHE;
    logic [2:0] ALUCTRLE;
    logic ALUSRCE;
    logic JUMPSRCE; // NOT SURE IF THIS WILL BE NEEDED IN E-PHASE
    logic ATYPEE;

    // REG DATA
    logic [WIDTH-1:0] RD1E;
    logic [WIDTH-1:0] RD2E;
    logic [WIDTH-1:0] RAE;

    // SIGN EXTEND
    logic [25:0] IMMEXTE;

    // FLOW THROUGH
    logic [WIDTH-1:0] PCE;
    logic [5:0] RS1E;
    logic [5:0] RS2E;
    logic [5:0] RDE;
    logic [WIDTH-1:0] PCPLUS4E

// <-------------------------------------------------------------------------------------> //

    // --- EXECUTE O/P --- //

    // CONTROL SIGNALS
    logic PCSRCE;           // GOES BACK TO FETCH
    logic REGWRITEM;
    logic [1:0] RESULTSRCM;
    logic MEMWRITEM;
    logic ATYPEM;

    // DATA
    logic [WIDTH-1:0] ALURESULTM;
    logic [WIDTH-1:0] WRITEDATAM;
    logic [WIDTH-1:0] PCTARGETE;

    // FLOW THROUGH
    logic [5:0] RDM;
    logic [WIDTH-1:0] PCPLUS4M;

// <-------------------------------------------------------------------------------------> //
    
    // --- MEMORY O/P --- //

    // CONTROL SIGNALS
    logic REGWRITEW_i;
    logic [1:0] RESULTSRCW;

    // DATA
    logic [WIDTH-1:0] ALURESULTW;
    logic [WIDTH-1:0] READDATAW;

    // FLOW THROUGH
    logic [5:0] RDW_i;
    logic [WIDTH-1:0] PCPLUS4W;

// <-------------------------------------------------------------------------------------> //

    // --- WRITEBACK O/P --- //

    logic [WIDTH-1:0] RESULTW;
    logic             REGWRITEW_o;
    logic [5:0]       RDW_o;

// <-------------------------------------------------------------------------------------> //    

    // --- HAZARD UNIT O/P --- //

    logic STALLF;
    logic STALLD;
    logic FLUSHD;
    logic FLUSHE;
    logic FORWARDAE; 
    logic FORWARDBE;

// <-------------------------------------------------------------------------------------> //  

    /////////////////////////////////
    // --- INSTANTIATE MODULES --- //
    /////////////////////////////////

    Fetch_stage FETCH (
        .clk(clk),                          // I/Ps
        .rst(rst),
        .en(en),
        .StallF(STALLF),
        .StallD(STALLD),
        .FlushD(FLUSHD),
        .PCSrcE(PCSRCE),
        .PCTargetE(PCTARGETE),

        .InstrD(INSTRD),                    // O/Ps
        .PCOut(PCD),
        .PCplus4F(PCPLUS4D)
    );

    Decode_stage DECODE (
        .clk(clk),                          // I/Ps
        .FlushE(FLUSHE),
        .WE3(REGWRITEW_o),
        .InstrD(INSTRD),
        .PCD_i(PCD),
        .PCplus4D_i(PCPLUS4D),
        .A3(RDW_o),
        .WD3(RESULTW),

        .RegWriteD(REGWRITEE),              // O/Ps
        .ResultSrcD(RESULTSRCE),
        .MemWriteD(MEMWRITEE),
        .JumpD(JUMPE),
        .BranchD(BRANCHE),
        .ALUCtrlD(ALUCTRLE),
        .ALUSrcD(ALUSRCE),
        .JumpSrcD(JUMPSRCE),
        .ATypeD(ATYPEE),
        .RD1(RD1E),
        .RD2(RD2E),
        .RA(RAE),
        .ImmExtD(IMMEXTE),
        .PCD_o(PCE),
        .Rs1D(RS1E),
        .Rs2D(RS2E),
        .RdD(RDE),
        .PCplus4D_o(PCPLUS4E),
        .a0(A0)
    );

    Execute_stage EXECUTE (
        .clk(clk),                        // I/Ps
        .ForwardAE(FORWARDAE),
        .ForwardBE(FORWARDBE),
        .RegWriteE_i(REGWRITEE),
        .ResultSrcE_i(RESULTSRCE),
        .MemWriteE_i(MEMWRITEE),
        .JumpE(JUMPE),
        .BranchE(BRANCHE),
        .ALUCtrlE(ALUCTRLE),
        .ALUSrcE(ALUSRCE),
        .JumpSrcE(JUMPSRCE),
        .ATypeE_i(ATYPEE),
        .PCE_i(PCE),
        .Rs1E(RS1E),
        .Rs2E(RS2E),
        .RdE_i(RDE),
        .ImmExtE(IMMEXTE),
        .PCplus4E_i(PCPLUS4D),

        .PCSrcE(PCSRCE),                 // O/Ps
        .RegWriteE_o(REGWRITEM),
        .ResultSrcE_o(RESULTSRCM),
        .MemWriteE_o(MEMWRITEM),
        .ATypeE_o(ATYPEM),
        .ALUResult(ALURESULTM),
        .WriteDataE(WRITEDATAM),
        .PCTargetE(PCTARGETE),
        .RdE_o(RDM),
        .PCplus4E_o(PCPLUS4M),
    );

    Memory_stage MEMORY (
        .clk(clk),                      // I/Ps
        .RegWriteM_i(REGWRITEM),
        .ResultSrcM_i(RESULTSRCM),
        .MemWriteM(MEMWRITEM),
        .ALUResultM_i(ALURESULTM),
        .WriteDataM(WRITEDATAM),
        .RdM_i(RDM),
        .PCPlus4M_i(PCPLUS4M),


        .RegWriteM_o(REGWRITEW),        // O/Ps
        .ResultSrcM_o(RESULTSRCW),
        .ALUResultM_o(ALURESULTW),
        .RD(READDATAW),
        .RdM_o(RDW_i),
        .PCPlus4M_o(PCPLUS4W)

    );

    Writeback_stage WRITEBACK (
        .clk(clk),                      // I/Ps
        .RegWriteW_i(REGWRITEW),
        .ResultSrcW(RESULTSRCW),
        .ReadDataW(READDATAW),
        .RdW_i(RDW_i),
        .PCPlus4W(PCPLUS4W),

        .result(RESULTW),               // O/Ps
        .RegWriteW_o(REGWRITEW_o),
        .RdW_o(RDW_o)
    );

    HazardUnit HAZARDUNIT (
        .Rs1D(INSTRD[19:15]),           // I/Ps
        .Rs2D(INSTRD[24:20]),
        .Rs1E(RS1E),
        .Rs2E(RS2E),
        .RdM(RDM),
        .RdW(RdW),
        .RdE(RDE),
        .RegWriteM(REGWRITEM),
        .RegWriteW(REGWRITEW),
        .PCSrcE(PCSRCE),
        .ResultSrcE(RESULTSRCE),

        .ForwardAE(FORWARDAE),          // O/Ps
        .ForwardBE(FORWARDBE),
        .StallF(STALLF),
        .StallD(STALLD),
        .FlushD(FLUSHD),
        .FlushE(FLUSHE),
    );

endmodule
