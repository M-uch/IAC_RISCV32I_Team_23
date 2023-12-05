module signextend (
    input logic [31:0] code, // full instruction from rom
    input logic [2:0] immscr, // signal from control module tells what instruction type it is hence we know the correct bits for immediate composition
    output logic [31:0] immop // output 32 bit immediate

    // output logic [31:0] ignorewarning // used to bypass unused input warning from verilog
);

// assign ignorewarning = code;
logic [19:0] extend;

always_comb begin

// check sign extend value
if (code[31]) extend = 'hFFFFF;
else extend = 'h00000;

if (immscr==3'b001) immop = {extend, code[31:20]}; // I type  
else if (immscr==3'b010) immop = {32'b0}; // U type UNUSED
else if (immscr==3'b011) immop = {extend, code[31:25], code[11:7] }; // S type
else if (immscr==3'b100) immop = {extend[18:0], code[31], code[7], code[30:25], code[11:8], 1'b0}; // B type 
else if (immscr==3'b101) immop = {extend[10:0], code[31], code[19:12], code[20], code[30:21], 1'b0}; // J type 

else immop = 32'b0; // default case

end 

endmodule
