module DataMemory #(
    parameter   DATA_WIDTH = 32
)(
    input   logic                       clk,
    input   logic [DATA_WIDTH-1:0]      A,
    input   logic [DATA_WIDTH-1:0]      WD,
    input   logic                       WE,
    output  logic [DATA_WIDTH-1:0]      RD
);

logic   [DATA_WIDTH-1:0] Reg_File [2**DATA_WIDTH-1:0];

always_ff @(posedge clk) begin
    if(WE) Reg_File[A] <= WD;
end

assign RD = Reg_File[A];

endmodule
