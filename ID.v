module ID_stage
(
	input	clk,
	input	rst,
	input 	[15:0]input_instr,
	output 	[2:0]rs1_addr,
	output 	[2:0]rs2_addr,
	output 	 reg [15:0]rs1_data_out,
	output   reg [15:0]rs2_data_out,
	input 	[15:0]rs1_data_in,
	input 	[15:0]rs2_data_in,
	output 	reg [2:0]alu_cmd,
	output 	branch_taken,
	output 	[5:0]branch_offset_imm

);

parameter NOP = 0,ADDI=9;

wire [3:0] opcode;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		{alu_cmd, rs1_data_out, rs2_data_out} <=0;
	end
	else begin
		{alu_cmd, rs1_data_out, rs2_data_out} <=0;
		if (!branch_taken )begin
			rs1_data_out <= rs1_data_in;
			if (opcode < 9 && opcode != NOP)begin
				alu_cmd <= input_instr[15:12]-1;
			end
			if(opcode == ADDI) begin
				alu_cmd <= 0;
				rs2_data_out <= $signed(branch_offset_imm);
			end
			else begin
				rs2_data_out <= rs2_data_in;
			end
		end
	end
end

assign opcode = input_instr[15:12];
assign branch_offset_imm = input_instr[5:0];
assign branch_taken = (opcode == 4'b1100) && (rs1_data_in == 0);
assign rs1_addr = input_instr[8:6];
assign rs2_addr = input_instr[5:3];
endmodule