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
    output  logic [DATA_WIDTH-1:0]      RD2,
    input   logic                       trigger, // direct access to t0 for trigger
    output  logic [DATA_WIDTH-1:0]      a0,
    output  logic [DATA_WIDTH-1:0]      ra
);

logic   [DATA_WIDTH-1:0] Reg_File [2**ADDRESS_WIDTH-1:0];

always_ff @(posedge clk) begin
    if(WE3 && (A3 != 4'b0000)) Reg_File[A3] <= WD3;     // new cond to avoid writing to r[0] on unconditional jumps 
    if(trigger== 1'b1) Reg_File[5] <= 1; // t0 location 
end

assign RD1 = Reg_File[A1];
assign RD2 = Reg_File[A2];
assign a0  = Reg_File[10];
assign ra  = Reg_File[1];

endmodule
