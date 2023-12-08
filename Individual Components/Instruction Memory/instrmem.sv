module instrmem #(
    parameter ADDRESS_WIDTH = 32, // 32 bit addresses 
              DATA_WIDTH = 32, // 32 bit instructions
              READ_WIDTH = 8 // byte sized reading
) (
    input logic [ADDRESS_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] instr
);

logic [READ_WIDTH-1:0] rom_array [2**12-1:0]; // current rom is 2^12 as memory map states up to address FFF is used

initial begin
    $display("loading rom.");
    $readmemh("program.mem", rom_array);
end;

assign instr = {rom_array[addr + 32'b11], // read from largest address representing bits 25-32
             rom_array[addr + 32'b10], // bits 17-24
             rom_array[addr + 32'b1], // bits 9-16
             rom_array[addr]}; // bits 1-8
endmodule
