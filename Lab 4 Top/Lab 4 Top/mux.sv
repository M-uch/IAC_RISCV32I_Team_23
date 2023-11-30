module mux #(
    parameter WIDTH = 32
)(
    input  logic    [WIDTH-1:0]     i1,     // input when s = 1
    input  logic    [WIDTH-1:0]     i0,     // input when s = 0
    input  logic                    s,      // select
    output logic    [WIDTH-1:0]     out     // O/P  
);

    assign out = s ? i1 : i0;

endmodule
