module Mux3 #(
    parameter      DATA_WIDTH = 32
)(
    input   logic[DATA_WIDTH-1:0]   in2, in1, in0,
    input   logic[1:0]              select,
    output  logic[DATA_WIDTH-1:0]   out
);

    logic   [DATA_WIDTH-1:0]              MuxInput;

assign MuxInput = select[0] ? in1 : in0;
assign out = select[1] ? in2 : MuxInput;

endmodule
