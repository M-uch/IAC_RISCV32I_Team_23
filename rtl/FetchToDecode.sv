module FetchToDecode #(
    parameter   DATA_WIDTH = 32
)(
    input   logic                       CLK, EN, CLR,
    input   logic [DATA_WIDTH-1:0]      InstrF, PCPlus4F, PCF,
    output  logic [DATA_WIDTH-1:0]      InstrD, PCPlus4D, PCD
);

always_ff @(posedge CLK) begin
    if(~EN) begin
        if(CLR) begin
            InstrD <= 32'b0;
            PCPlus4D <= 32'b0;
            PCD <= 32'b0;
        end
        else begin
            InstrD <= InstrF;
            PCPlus4D <= PCPlus4F;
            PCD <= PCF;
        end
    end

end

endmodule
