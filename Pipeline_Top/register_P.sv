module register_P #(
    parameter WIDTH = 32
) (

    input logic                         clk,
    input logic                         rst,
    input logic                         en,
    input logic       [WIDTH-1:0]       next_PC,   // Calculated next PC value
    output logic      [WIDTH-1:0]       PC         // PC O/P

);

always_ff @ (posedge clk, posedge rst) begin
    if(~en) begin                           // if no stall
        if (rst) PC <= {WIDTH{1'b0}};    // if reset = 1 then PC = 0
        else PC <= next_PC;
    end
end               
endmodule
