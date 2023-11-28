module instrmem #(
    parameter ADDRESS_WIDTH = 32, // 32 bit addresses // NOTE current mem only is 172 addresses so only first 8 bits are read 
              DATA_WIDTH = 32, // 32 bit instructions
              READ_WIDTH = 8 // byte sized reading
) (
    input logic [ADDRESS_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] instr,
    output logic [ADDRESS_WIDTH-1:0] ignoreunused // ignore warning from unused input bits
);

assign ignoreunused = addr;

logic [7:0] short;
logic [READ_WIDTH-1:0] rom_array [2**8-1:0];

assign short = addr[7:0];

initial begin
    $display("loading rom.");
    $readmemh("program.mem", rom_array);
end;

assign instr = {rom_array[short + 8'b11], // read from largest address representing bits 25-32
             rom_array[short + 8'b10], // bits 17-24
             rom_array[short + 8'b1], // bits 9-16
             rom_array[short]}; // bits 1-8
endmodule
