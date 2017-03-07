module ALU
(
	input	[15:0]	a,
	input	[15:0] 	b,
	input	[2:0]	cmd,
	output 	reg[15:0]	res
);
	always @(*) begin
		case (cmd)
			3'b000: 	res <= a + b;
			3'b001: 	res <= a - b;
			3'b010: 	res <= a & b;
			3'b011: 	res <= a | b;
			3'b100: 	res <= a ^ b;
			3'b101: 	res <= a << b;
			3'b110: 	res <= a >> b;
			3'b111: 	res <= a >>> b;
			default: 	res <= a + b;
		endcase
	end
endmodule