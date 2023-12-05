module DataMemory #(
    parameter ADDRESS_WIDTH = 32, // for tidyness
              DATA_WIDTH = 32 
)(
    input   logic                       clk,
    input   logic [ADDRESS_WIDTH-1:0]   A,
    input   logic [DATA_WIDTH-1:0]      WD,
    input   logic                       WE,
    input   logic                       ADTP, // addressing type if 0 then 32 bit W/R , if 1 then 8 bit W/R extended to 32 with 0s
    output  logic [DATA_WIDTH-1:0]      RD
);

// 7:0 set as each address holds 8 bits
logic [7:0] Reg_File [2**17-1:0]; // set max address to 1FFFF as shown in memory map 

// write input
always_ff @(posedge clk) begin

    if(WE & ADTP) Reg_File[A] <= WD[7:0]; // if ADTP 1 then write into one address a first 8 bits of data (byte)

    if(WE & ~ADTP) begin // if ADTP 0 then write into first address first 8 bits then 2nd address next 8 and so on (little endian storage)
        Reg_File[A] <= WD[7:0];
        Reg_File[A + 32'b1] <= WD[15:8];
        Reg_File[A + 32'b10] <= WD[23:16];
        Reg_File[A + 32'b11] <= WD[31:24];
    end
end


// read output
always_comb begin

if(ADTP) RD = {24'b0 ,Reg_File[A]}; // byte type reads one address
else RD = {Reg_File[A + 32'b11], Reg_File[A + 32'b10], Reg_File[A + 32'b1], Reg_File[A]}; // reads first address followed by 2nd 3rd 4th, with first address being lsb (little endian)

end

endmodule
