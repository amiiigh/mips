module SSD 
(
in,
res
);
input [3:0] in;
output [6:0] res;
reg [6:0] out;
always @(in) begin
  
case(in)
4'd0: out <= 7'h3f;
4'd1: out <= 7'h06;
4'd2: out <= 7'h5b;
4'd3: out <= 7'h4f;
4'd4: out <= 7'h66;
4'd5: out <= 7'h6d;
4'd6: out <= 7'h7d;
4'd7: out <= 7'h07;
4'd8: out <= 7'h7f;
4'd9: out <= 7'h6f;
default: out<=7'h3f;

endcase

end
assign res = ~ out;

endmodule