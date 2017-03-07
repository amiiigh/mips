module IF_stage
(
	input	clk,
	input 	rst,
	input 	branch_taken,
	input 	[5:0]branch_offset_imm,
	output	reg [7:0]	pc,
	output 	reg [15:0] 	instr
);

always @(posedge clk or posedge rst) begin
	if (rst) begin
		pc <= 8'b0;	
	end
	else begin
		pc <= branch_taken? pc + $signed(branch_offset_imm): pc + 8'b1;
	end
end
always @(pc) begin
	case(pc)
		8'd0:	instr <= {4'b0001,3'b000,3'b010,3'b010,3'b000};//add reg1 + reg2
		8'd1:	instr <= {4'b1001,3'b000,3'b110,6'b111101};//addi reg2 i3
		8'd2:	instr <= {4'b0011,3'b000,3'b001,3'b000,3'b000};//and reg1 , reg0
		8'd3:	instr <= {4'b1100,3'b000,3'b000,6'b111101};//or reg1,reg0
		8'd4:	instr <= {4'b0101,3'b000,3'b001,3'b001,3'b000};//xor reg1,reg1
		8'd5:	instr <= {4'b0110,3'b000,3'b010,3'b001,3'b000};//sl reg2
		8'd6:	instr <= {4'b0111,3'b000,3'b010,3'b001,3'b000};//sr reg2
		8'd7:	instr <= {4'b1000,3'b000,3'b010,3'b001,3'b000};//sru
		8'd8:	instr <= {4'b0000,3'b000,3'b000,3'b000,3'b000};
		8'd9:	instr <= {4'b0000,3'b000,3'b000,3'b000,3'b000};
	endcase
end
endmodule
