module  HazardUnit #(
    parameter       ADDRESS_WIDTH = 5
)(
    input   logic [ADDRESS_WIDTH-1:0]      Rs1D, Rs2D, Rs1E, Rs2E, RdM, RdW, RdE,
    input   logic                          RegWriteM, RegWriteW, PCSrcE, ResultSrcE,
    output  logic [1:0]                    ForwardAE, ForwardBE,
    output  logic                          StallF, StallD, FlushD, FlushE
);
    logic                                  lwStall;

always_ff begin

// Forwarding to solve RAW data hazard
    if ((Rs1E == RdM) && (RegWriteM) && (Rs1E!=0))          ForwardAE = 2;
    else if ((Rs1E == RdW) && (RegWriteW) && (Rs1E!=0))     ForwardAE = 1;
    else                                                    ForwardAE = 0;

    if ((Rs2E == RdM) && (RegWriteM) && (Rs2E!=0))          ForwardBE = 2;
    else if ((Rs2E == RdW) && (RegWriteW) && (Rs2E!=0))     ForwardBE = 1;
    else                                                    ForwardBE = 0;

// Stalling to solve Load data hazard
    lwStall = ResultSrcE & ((Rs1D == RdE) | (Rs2D == RdE));
    StallD = lwStall;
    StallF = lwStall;

// Flushing to solve Control Hazard caused by branching
    FlushD = PCSrcE;
    FlushE = lwStall | PCSrcE;

end

endmodule
