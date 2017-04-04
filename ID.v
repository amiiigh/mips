module ID_stage
(
	input	clk,
	input	rst,
	input 	[15:0]input_instr,
	output 	[2:0]rs1_addr,
	output 	[2:0]rs2_addr,
	output 	reg [15:0]rs1_data_out,
	output  reg [15:0]rs2_data_out,
	input 	[15:0]rs1_data_in,
	input 	[15:0]rs2_data_in,
	output 	reg [2:0]alu_cmd,
	output 	branch_taken,
	output 	[5:0]branch_offset_imm,

	output 	reg [15:0] id_ex_store_data,
	output 	reg [2:0] id_ex_op_dest,
	output 	reg id_ex_mem_write_en,
	output 	reg id_ex_wb_mux,
	output 	reg id_ex_wb_en

);

parameter NOP = 0,ADDI=9,LD=10,ST=11,BZ=12;
parameter ALU_CMD_ADD = 0;
wire [3:0] opcode;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		{alu_cmd, rs1_data_out, rs2_data_out,id_ex_store_data,id_ex_op_dest,id_ex_mem_write_en,id_ex_wb_mux,id_ex_wb_en} <=0;
	end
	else begin
		{alu_cmd, rs1_data_out, rs2_data_out,id_ex_store_data,id_ex_op_dest,id_ex_mem_write_en,id_ex_wb_mux,id_ex_wb_en} <=0;
		if (!branch_taken )begin
			rs1_data_out <= rs1_data_in;
			if(opcode != NOP && opcode != BZ && opcode != ST) begin
				id_ex_wb_en <= 1;
			end
			if (opcode < 9 && opcode != NOP)begin
				alu_cmd <= input_instr[15:12]-1;
			end
			if(opcode == ADDI || opcode == LD || opcode == ST) begin
				alu_cmd <= ALU_CMD_ADD;
				rs2_data_out <= $signed(branch_offset_imm);
			end
			else begin
				rs2_data_out <= rs2_data_in;
			end
			if (opcode == LD) begin
				id_ex_op_dest <= input_instr[8:6];
				id_ex_wb_mux <= 1;
			end
			if (opcode == ST) begin
				id_ex_mem_write_en <= 1;
				id_ex_store_data <= rs2_data_in;
			end
		end
	end
end

assign opcode = input_instr[15:12];
assign branch_offset_imm = input_instr[5:0];
assign branch_taken = (opcode == BZ) && (rs1_data_in == 0);
assign rs1_addr = input_instr[8:6];
// injaro bepa
assign rs2_addr = (opcode == ST) ? input_instr[11:9] : input_instr[5:3];
endmodule