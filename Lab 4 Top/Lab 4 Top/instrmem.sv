module instrmem #(
    parameter ADDRESS_WIDTH = 32, // 32 bit addresses // NOTE current mem only is 2^5 addresses, so need to find a method to 
              DATA_WIDTH = 32, // 32 bit instructions
              READ_WIDTH = 8 // byte sized reading
) (
    input logic [ADDRESS_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] instr,
    // output logic [ADDRESS_WIDTH-1:0] ignoreunused // ignore warning from unused input bits

    /* testing 
    input logic clk,
    */
);

// assign ignoreunused = addr;

logic [4:0] short;
logic [READ_WIDTH-1:0] rom_array [2**5-1:0];

assign short = addr[4:0];

initial begin
    $display("loading rom.");
    $readmemh("./program.mem", rom_array);
end

/* testing
always_ff @(posedge clk) begin
    instr <= {rom_array[short + 5'b11], // read from largest address representing bits 25-32
                rom_array[short + 5'b10], // bits 17-24
                rom_array[short + 5'b1], // bits 9-16
                rom_array[short]}; // bits 1-8
end
*/

assign instr = {rom_array[short + 5'd3], // read from largest address representing bits 25-32
             rom_array[short + 5'd2], // bits 17-24
             rom_array[short + 5'd1], // bits 9-16
             rom_array[short]}; // bits 1-8
endmodule
