module RegFile #(
    parameter   ADDRESS_WIDTH = 5,
                DATA_WIDTH = 32
)(
    input   logic                       clk,
    input   logic [ADDRESS_WIDTH-1:0]   A1,
    input   logic [ADDRESS_WIDTH-1:0]   A2,
    input   logic [ADDRESS_WIDTH-1:0]   A3,
    input   logic [DATA_WIDTH-1:0]      WD3,
    input   logic                       WE3,
    output  logic [DATA_WIDTH-1:0]      RD1,
    output  logic [DATA_WIDTH-1:0]      RD2
);

logic   [DATA_WIDTH-1:0] Reg_File [2**ADDRESS_WIDTH-1:0];

always_ff @(posedge clk) begin
    if(WE3) Reg_File[A3] <= WD3;
end

assign RD1 = Reg_File[A1];
assign RD2 = Reg_File[A2];

endmodule
