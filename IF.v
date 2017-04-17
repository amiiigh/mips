module IF_stage
(
	input	clk,
	input 	rst,
	input 	branch_taken,
	input 	[5:0]branch_offset_imm,
	output	reg [7:0]	pc,
	output 	reg [15:0] 	instr
);
parameter NOP = 16'b0;
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
		8'd0:	instr <= {4'b1011,3'b011,3'b010,6'b000000};
		8'd1:	instr <= NOP;
		8'd2:	instr <= NOP;
		8'd3:	instr <= NOP;
		8'd4:	instr <= NOP;
		8'd5:	instr <= NOP;
		8'd6:	instr <= NOP;
		8'd7:	instr <= NOP;
		8'd8:	instr <= NOP;
		8'd9:	instr <= {4'b1010,3'b111,3'b010,6'b000000};
	endcase
end
endmodule
