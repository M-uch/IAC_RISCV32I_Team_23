module Top #(
    parameter WIDTH = 32
) (
    input  logic                       clk,        // CPU clock
    input  logic                       rst,        // reset
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
    logic [WIDTH-1:0] IMMEXTE;

    // FLOW THROUGH
    logic [WIDTH-1:0] PCE;
    logic [4:0] RS1E;
    logic [4:0] RS2E;
    logic [4:0] RDE;
    logic [WIDTH-1:0] PCPLUS4E;

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
    logic [4:0] RDM;
    logic [WIDTH-1:0] PCPLUS4M;

// <-------------------------------------------------------------------------------------> //
    
    // --- MEMORY O/P --- //

    // CONTROL SIGNALS
    logic REGWRITEW;
    logic [1:0] RESULTSRCW;

    // DATA
    logic [WIDTH-1:0] ALURESULTW;
    logic [WIDTH-1:0] READDATAW;

    // FLOW THROUGH
    logic [4:0] RDW;
    logic [WIDTH-1:0] PCPLUS4W;

// <-------------------------------------------------------------------------------------> //

    // --- WRITEBACK O/P --- //

    logic [WIDTH-1:0] RESULTW;
    logic             REGWRITEW_o;
    logic [4:0]       RDW_o;

// <-------------------------------------------------------------------------------------> //    

    // --- HAZARD UNIT O/P --- //

    logic STALLF;
    logic STALLD;
    logic FLUSHD;
    logic FLUSHE;
    logic [1:0] FORWARDAE; 
    logic [1:0] FORWARDBE;

// <-------------------------------------------------------------------------------------> //  

    /////////////////////////////////
    // --- INSTANTIATE MODULES --- //
    /////////////////////////////////

    Fetch_stage FETCH (
        .clk(clk),                          // I/Ps
        .rst(rst),
        .StallF(STALLF),
        .StallD(STALLD),
        .FlushD(FLUSHD),
        .PCSrcE(PCSRCE),
        .PCTargetE(PCTARGETE),

        .InstrD(INSTRD),                    // O/Ps
        .PCOut(PCD),
        .PCplus4F_o(PCPLUS4D)
    );

    Decode_stage DECODE (
        .clk(clk),                          // I/Ps
        .FlushE(FLUSHE),
        .WE3(REGWRITEW_o),
        .InstrD(INSTRD),
        .PCD(PCD),
        .PCplus4D(PCPLUS4D),
        .A3(RDW_o),
        .WD3(RESULTW),
        .trigger(T0),

        .RegWriteE(REGWRITEE),              // O/Ps
        .ResultSrcE(RESULTSRCE),
        .MemWriteE(MEMWRITEE),
        .JumpE(JUMPE),
        .BranchE(BRANCHE),
        .ALUCtrlE(ALUCTRLE),
        .ALUSrcE(ALUSRCE),
        .JumpSrcE(JUMPSRCE),
        .ATypeE(ATYPEE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .RAE(RAE),
        .ImmExtE(IMMEXTE),
        .PCE(PCE),
        .Rs1E(RS1E),
        .Rs2E(RS2E),
        .RdE(RDE),
        .PCplus4E(PCPLUS4E),
        .a0(A0)
    );

    Execute_stage EXECUTE (
        .clk(clk),                        // I/Ps
        .ForwardAE(FORWARDAE),
        .ForwardBE(FORWARDBE),
        .RegWriteE(REGWRITEE),
        .ResultSrcE_i(RESULTSRCE),
        .MemWriteE(MEMWRITEE),
        .JumpE(JUMPE),
        .BranchE(BRANCHE),
        .ALUCtrlE(ALUCTRLE),
        .ALUSrcE(ALUSRCE),
        .JumpSrcE(JUMPSRCE),
        .ATypeE(ATYPEE),
        .PCE(PCE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .RdE_i(RDE),
        .ImmExtE(IMMEXTE),
        .PCPlus4E(PCPLUS4E),
        .ALUResultM_i(ALURESULTM),
        .ResultW(RESULTW),
        .raE(RAE),

        .PCSrcE(PCSRCE),                 // O/Ps
        .RegWriteM(REGWRITEM),
        .ResultSrcM(RESULTSRCM),
        .MemWriteM(MEMWRITEM),
        .ATypeM(ATYPEM),
        .ALUResultM_o(ALURESULTM),
        .WriteDataM(WRITEDATAM),
        .PCTargetE(PCTARGETE),
        .RdM(RDM),
        .PCPlus4M(PCPLUS4M)
    );

    Memory_stage MEMORY (
        .clk(clk),                      // I/Ps
        .a_typeM(ATYPEM),
        .RegWriteM_i(REGWRITEM),
        .ResultSrcM_i(RESULTSRCM),
        .MemWriteM(MEMWRITEM),
        .ALUResultM_i(ALURESULTM),
        .WriteDataM(WRITEDATAM),
        .RdM_i(RDM),
        .PCPlus4M_i(PCPLUS4M),


        .RegWriteW(REGWRITEW),        // O/Ps
        .RegWriteM_o(REGWRITEM),
        .ResultSrcW(RESULTSRCW),
        .ALUResultM_o(ALURESULTM),
        .RdW(RDW),
        .RdM_o(RDM),
        .PCPlus4M_o(PCPLUS4W),
        .ReadDataW(READDATAW),
        .ALUResultW(ALURESULTW)

    );

    Writeback_stage WRITEBACK (
        .RegWriteW_i(REGWRITEW),        // I/Ps
        .ResultSrcW(RESULTSRCW),
        .ReadDataW(READDATAW),
        .RdW_i(RDW),
        .PCPlus4W(PCPLUS4W),
        .ALUResultW(ALURESULTW),

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
        .RdW(RDW),
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
        .FlushE(FLUSHE)
    );

endmodule
