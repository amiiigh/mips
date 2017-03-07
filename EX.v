module EX_stage
(
	input	clk,
	input	rst,
	input 	[15:0]rs_1,
	input 	[15:0]rs_2,
	input 	[2:0] cmd,
	output 	[15:0]alu_res
);
ALU alu(rs_1,rs_2,cmd,alu_res);
endmodule