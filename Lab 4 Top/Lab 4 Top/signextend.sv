module signextend (
    input logic [31:0] code, // full instruction from rom
    input logic [1:0] immscr, // signal from control module which determines the correct imm composition
    output logic [31:0] immop // output 32 bit immediate

    // testing line remove after
    // input logic clk,
    // output logic [31:0] ignorewarning // used to bypass unused input warning from verilog
);

logic [19:0] extend;

// assign ignorewarning = code;  // bypass

// remove always ff after testing
// always_ff @(posedge clk) begin

always_comb begin

    // check sign extend value
    if (code[31]) extend = 'hFFFFF;
    else extend = 'h00000;
    
    // if (imm_src == 2'b00) begin
    //     immop = {extend, code[31:20]};
    // end else if (imm_src == 2'b10) begin
    //     immop = {extend, code[31], code[7], code[30:25], code[11:8]};
    // end else begin
    //     immop = 32'b0;
    // end
    
    case(immscr)

        // I-Type
        2'b00: immop = {extend, code[31:20]};

        // B-Type
        2'b10: immop = {extend[18:0], code[31], code[7], code[30:25], code[11:8], 1'b0};

        default: immop = 32'b0;
    endcase

    // RAYMOND CODE:
    // // if immscr = 1 then it is a B-type instruction (refer to lecture 6)
    // if (immscr) immop = {extend, code[31], code[7], code[30:25], code[11:8]};

    // // if immscr = 0 then it is a I-type instruction, sign extend 12 bit to 32 bit imm
    // else if (~immscr) immop = {extend, code[31:20]};

    // else immop = 32'b0; // default case

end 

endmodule
