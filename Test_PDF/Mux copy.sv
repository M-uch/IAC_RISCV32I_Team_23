module Mux #(
    parameter      DATA_WIDTH = 32
)(
    input   logic[DATA_WIDTH-1:0]   in1, in0,
    input   logic                   select,
    output  logic[DATA_WIDTH-1:0]   out
);
assign out = select ? in1 : in0;

endmodule
